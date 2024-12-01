---
layout: post
title: "Building a Secure and Efficient MQTT-HTTP Gateway with Node.js"
tags: mqtt nodejs javascript tutorial
image: /uploads/mqtt-http-gateway-node.webp
---
One of my recent projects involved creating a Node.js script that acts as a gateway or middleware, capturing messages from an MQTT broker and relaying (streaming) them on the HTTP side via GET requests. Similarly, it should also handle POST requests from the HTTP side and publish them to the corresponding broker on the respective topic.

Why use this approach?

- **Security:** Avoid exposing MQTT broker credentials or certificates to browsers.
- **Efficiency:** Browsers require WebSocket for MQTT communication, adding overhead compared to native MQTTS.
- **Flexibility:** Centralized middleware simplifies custom message processing, improving maintainability.

![mqtt-http-gateway-node](/uploads/mqtt-http-gateway-node.webp)

## Preparing the Node.js environment.

We only need two node components viz. [mqtt](https://www.npmjs.com/package/mqtt) and [express](https://www.npmjs.com/package/express). The former is the core library used to interact with MQTT broker and latter is the micro-framework used to interact with HTTP GET/POST requests.

It's not necessary to stick to version 4 of the mqtt.js but I found it more stable and compatible with my Node.js setup.

```bash
npm install mqtt@4 express
```

### Optional: CORS Package

You might also need the `cors` package if you want to customize Cross-Origin Resource Sharing (CORS) settings and enable access to the gateway for multiple users, such as REST API clients. I needed this in my case.

```bash
npm install cors
```

## Setting Up Your MQTT Brokers

The `brokers` object contains configurations for each MQTT broker such as the URL and options (e.g., authentication). Each broker is also assigned a `lastMessage` object to store the latest MQTT message for each topic.

```javascript
const mqtt = require('mqtt');
const express = require('express');
const cors = require('cors');  // Optional: Import CORS package
const fs  = require('fs');
const path = require('path');
const os = require('os');


const brokers = {};

brokers['example'] =  { 
	url: "mqtts://example.us-east-1.amazonaws.com:8883",
	lastMessage: {},
	devices: {},
	options: {
		ca: fs.readFileSync( 'certs/ca.pem'),
		cert: fs.readFileSync( 'certs/cert.crt') ,
		key: fs.readFileSync( 'certs/key.key') ,
		protocolId: 'MQTT',
		protocolVersion: 4,
		keepalive: 60,
		//wsOptions: {timeout: 30000, path: '/mqtt'},
		clientId: 'mqttjs_'+Math.random().toString(16).substr(2,8),
        rejectUnauthorized: true,
		clean: true,
        secureProtocol: 'TLSv1_2_method', // Explicitly use TLSv1.2
	}
  };
brokers["mosquitto"]= { 
	url: 'mqtt://test.mosquitto.org', options:{},
	clientId: 'mqttjs_'+Math.random().toString(16).substr(2,8),
	lastMessage: {} 
};
```

## Initializing Middleware for HTTP Requests

Middleware ensures proper handling of requests by validating input and enabling CORS.

```javascript
// Initialize HTTP Server
const app = express();
app.use(express.json()); // Parse JSON payloads

app.use(cors({
    origin: '*'  // Allow requests from any origin
}));
```

## Establishing MQTT Connections

```javascript
// Store MQTT client objects for each broker
const mqttClients = {};
const subTopics = '#';

// Function to connect to each broker
Object.keys(brokers).forEach(key => {
	const broker =brokers[key];
	console.log("initializing broker:", key, broker.url);
    const mqttClient = mqtt.connect(broker.url, broker.options);

    mqttClient.on('connect', () => {
      console.log(`Connected to broker: ${broker.url}`);
		mqttClient.subscribe(subTopics, (err) => {
        if (err) {
          console.error(`Subscription error for ${key}:`, err);
        } else {
          console.log(`Subscribed to topic ${subTopics} on ${key}`);
        }
      });
    });

    mqttClient.on('message', (topic, message) => {
      const msg = message.toString();
      console.log(`[${key}] Received message on topic: ${topic}`);
	  broker['lastMessage'][topic] = msg;
	  switch(key) { //custom logic
		  case "custom_broker":
			//@todo: handle custom logic
			break;
	  }
    });
	
	mqttClient.on('error', (err) => {
		console.error(`Error with broker ${key}:`, err.message);
	});
	
	mqttClient.on('auth', (packet, cb) => {
	  console.log('Authenticating with certificate...');

	  // Check the certificate properties and perform the authentication logic here.
	  // Call cb() with an error if authentication fails or null if it succeeds.
	  cb(null);
	});	
	
	mqttClients[key] = mqttClient;
  });
```

I've kept the subscription topic to `#` wildcard i.e. subscribe to all topics, you may or may not want to do that. The "connect" event of mqttClient handles the connection where you can subscribe to the topics. Correspondingly, the "message" event handles the incoming events from each broker. The dummy `switch` block here can be used to add any custom processing logic you may have. The `lastMessage` variable will anyway store the message for the corresponding topic.

The 'error' and 'auth' event handlers are just dummy blocks which you can expand upon if you want to. In the end, each client object is stored to `mqttClients` array object from which it can later be retrieved.

## Bridging MQTT with Express API Routes

On the HTTP side, I've created just two routes viz. `events` and `publish`. The former is used to fetch messages from a broker and latter to publish to them. 

```javascript
app.get('/events', (req, res) => {
	const { brokerKey, topic } = req.query;
	// Build the SQL query dynamically based on provided parameters

	if (!brokerKey || !topic) {
		return res.status(400).send('Invalid request. Provide brokerkey and topic.');
	}
	broker = brokers[brokerKey];
	switch (brokerKey) { //custom logic
		case "custom_broker":
			//@todo: handle custom logic
			break;
		default:
			res.json(broker['lastMessage'][topic]);
			break;
	}
});

// HTTP POST: Publish messages back to MQTT
app.post('/publish', (req, res) => {
  const { brokerKey, topic, message } = req.body; // Destructure input fields

  // Validate the input
  if (!brokerKey || !topic || !message) {
    return res.status(400).send('Invalid request. Provide broker key, topic, and message.');
  }

  // Retrieve the MQTT client for the specified broker
  const mqttClient = mqttClients[brokerKey];
  if (!mqttClient) {
    return res.status(400).send('Invalid broker specified.');
  }

  // Publish the message
  mqttClient.publish(topic, message, (err) => {
    if (err) {
      console.error(`Publish error on ${brokerKey}:`, err);
      res.status(500).send('Failed to publish message.');
    } else {
      res.send(`Message published successfully to ${brokerKey}.`);
    }
  });
});
```

This is also pretty simple and straightforward. As earlier, I've created a dummy switch block for custom handling. The default is to just pick the latest message for that particular broker and topic (`broker['lastMessage'][topic]`) and return it using `res.json()`.

Same holds true for publish. It accepts three parameters called brokerKey, topic and message, then correspondingly publishes the message on the broker. You may want to add custom logic here including authentication logic based on API keys, etc.

## Starting the Express Server

The final step is to start the Express server. Use a custom port, or fallback to a default if not provided.

```javascript
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
```

This setup provides a reliable foundation for creating an MQTT-HTTP gateway. You can further enhance it with persistent storage, advanced authentication, or message processing workflows. Let me know how this implementation works for you—or share your own ideas for improvement—in the comments below. Happy coding!