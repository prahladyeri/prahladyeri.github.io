---
layout: post
title: "Creating a dynamic airline ticket booking system with PHP and MySQL"
tags: php mysql project case-study tutorial
image: /uploads/airline-ticket-booking-system-php-mysql.webp
---
In this in-depth guide, we’ll cover how to create a dynamic airline ticket booking system using PHP and MySQL. This system will allow users to search flights, view availability, book tickets, and manage bookings. We’ll also highlight best practices for building efficient reservation systems, including user authentication and secure data handling.

### Table of Contents
1. Introduction to the airline booking system
2. Project setup and prerequisites
3. Database structure and design
4. User authentication module
5. Flight search and availability check
6. Ticket booking and reservation management
7. Handling payments (optional integration)
8. Additional resources and open-source projects
9. Conclusion

![airline-ticket-booking-system-php-mysql](/uploads/airline-ticket-booking-system-php-mysql.webp)

---

### 1. Introduction to the airline booking system

An airline ticket booking system is a web application that enables users to check flight availability, book seats, and view their bookings. This type of system can be useful for travel agencies, airlines, and developers seeking to improve their skills with a real-world PHP project.

The primary components of the system will include:
- User registration and login
- Flight database and search functionality
- Booking management and ticket reservation
- Optional payment gateway integration for a complete e-commerce experience

This guide assumes a basic understanding of PHP, MySQL, and HTML.

---

### 2. Project setup and prerequisites

**Environment setup:**
- **PHP**: Version 7.4 or higher.
- **MySQL**: For storing user and flight data.
- **Apache or Nginx server**: To serve the application locally.

Ensure that PHP, MySQL, and your preferred server are installed and configured correctly.

**Project Structure:**
```
airline-booking-system/
│
├── index.php                 # Home page for searching flights
├── register.php              # User registration
├── login.php                 # User login
├── flights.php               # Search flights page
├── book.php                  # Booking and reservation page
├── manage_booking.php        # Manage bookings for users
├── assets/                   # Folder for CSS, JavaScript
│   └── styles.css            # Basic styling for the application
└── db/
    └── database.sql          # SQL file to create necessary tables
```

---

### 3. Database structure and design

Designing an effective database schema is crucial for managing flights, reservations, and user data. Here is a simple schema that includes three main tables: `users`, `flights`, and `bookings`.

```sql
-- Table to store user data
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to store flight information
CREATE TABLE flights (
    id INT PRIMARY KEY AUTO_INCREMENT,
    flight_number VARCHAR(20) UNIQUE,
    origin VARCHAR(100),
    destination VARCHAR(100),
    departure_time DATETIME,
    arrival_time DATETIME,
    seats_available INT,
    price DECIMAL(10, 2)
);

-- Table to store booking information
CREATE TABLE bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    flight_id INT,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('confirmed', 'pending', 'cancelled'),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (flight_id) REFERENCES flights(id)
);
```

- **`users`**: Stores user data, including password hashes for secure authentication.
- **`flights`**: Stores information about flights, availability, and pricing.
- **`bookings`**: Links users to flights, allowing them to book and manage reservations.

---

### 4. User authentication module

To manage user registration and login, we’ll implement basic authentication. Start by creating a registration form (`register.php`) that collects user information and stores hashed passwords.

```php
// register.php - User registration

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    include 'db/connection.php';
    $name = $_POST['name'];
    $email = $_POST['email'];
    $password = password_hash($_POST['password'], PASSWORD_BCRYPT);

    $query = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("sss", $name, $email, $password);
    $stmt->execute();
    $stmt->close();
}
```

For login (`login.php`), verify the email and password against stored values, starting a session if credentials are valid.

```php
// login.php - User login

session_start();
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    include 'db/connection.php';
    $email = $_POST['email'];
    $password = $_POST['password'];

    $query = "SELECT * FROM users WHERE email = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();

    if ($user && password_verify($password, $user['password'])) {
        $_SESSION['user_id'] = $user['id'];
        header("Location: index.php");
    } else {
        echo "Invalid email or password.";
    }
}
```

---

### 5. Flight search and availability check

On the main page (`index.php`), allow users to search for flights by origin, destination, and date. Use the `flights` table to retrieve results matching the user’s criteria.

```php
// index.php - Search for flights

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    include 'db/connection.php';
    $origin = $_POST['origin'];
    $destination = $_POST['destination'];
    $date = $_POST['date'];

    $query = "SELECT * FROM flights WHERE origin = ? AND destination = ? AND DATE(departure_time) = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("sss", $origin, $destination, $date);
    $stmt->execute();
    $flights = $stmt->get_result();
}
```

The `flights.php` (Search Flights Page) file is intended to allow users to search for flights by specifying criteria like origin, destination, and date, and then display available flights based on those inputs. Here’s how it could be implemented:

```php
<!-- flights.php -->
<!DOCTYPE html>
<html>
<head>
    <title>Search Flights</title>
</head>
<body>
    <h1>Search for Flights</h1>
    <form method="POST" action="flights.php">
        <label for="origin">Origin:</label>
        <input type="text" name="origin" required>
        
        <label for="destination">Destination:</label>
        <input type="text" name="destination" required>
        
        <label for="date">Date:</label>
        <input type="date" name="date" required>
        
        <button type="submit">Search</button>
    </form>

    <?php
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        include 'db/connection.php';
        $origin = $_POST['origin'];
        $destination = $_POST['destination'];
        $date = $_POST['date'];

        // Query to search flights
        $query = "SELECT * FROM flights WHERE origin = ? AND destination = ? AND DATE(departure_time) = ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("sss", $origin, $destination, $date);
        $stmt->execute();
        $result = $stmt->get_result();

        echo "<h2>Available Flights</h2>";
        if ($result->num_rows > 0) {
            echo "<table><tr><th>Flight Number</th><th>Departure</th><th>Arrival</th><th>Seats</th><th>Price</th></tr>";
            while ($flight = $result->fetch_assoc()) {
                echo "<tr>
                    <td>{$flight['flight_number']}</td>
                    <td>{$flight['departure_time']}</td>
                    <td>{$flight['arrival_time']}</td>
                    <td>{$flight['seats_available']}</td>
                    <td>{$flight['price']}</td>
                    <td><a href='book.php?flight_id={$flight['id']}'>Book Now</a></td>
                </tr>";
            }
            echo "</table>";
        } else {
            echo "No flights found.";
        }
    }
    ?>
</body>
</html>
```

---

### 6. Ticket booking and reservation management

On the `book.php` page, allow users to book a flight, reducing the number of available seats. Update the `bookings` and `flights` tables to reflect the reservation.

```php
// book.php - Book a flight

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    include 'db/connection.php';
    $flight_id = $_POST['flight_id'];
    $user_id = $_SESSION['user_id'];

    // Check seat availability
    $query = "SELECT seats_available FROM flights WHERE id = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $flight_id);
    $stmt->execute();
    $flight = $stmt->get_result()->fetch_assoc();

    if ($flight['seats_available'] > 0) {
        // Update seats and create booking
        $update_seats = "UPDATE flights SET seats_available = seats_available - 1 WHERE id = ?";
        $stmt = $conn->prepare($update_seats);
        $stmt->bind_param("i", $flight_id);
        $stmt->execute();

        $create_booking = "INSERT INTO bookings (user_id, flight_id, status) VALUES (?, ?, 'confirmed')";
        $stmt = $conn->prepare($create_booking);
        $stmt->bind_param("ii", $user_id, $flight_id);
        $stmt->execute();
        echo "Booking confirmed!";
    } else {
        echo "No seats available.";
    }
}
```

The `manage_booking.php` file allows users to view and manage their existing bookings, such as viewing current reservations, canceling them, or checking status. Here’s a basic implementation for managing bookings:

```php
<!-- manage_booking.php -->
<?php
session_start();
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit;
}

include 'db/connection.php';
$user_id = $_SESSION['user_id'];

// Fetch bookings for the logged-in user
$query = "SELECT bookings.id, flights.flight_number, flights.origin, flights.destination, flights.departure_time, bookings.status
          FROM bookings
          JOIN flights ON bookings.flight_id = flights.id
          WHERE bookings.user_id = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();
?>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Bookings</title>
</head>
<body>
    <h1>Your Bookings</h1>
    <?php if ($result->num_rows > 0): ?>
        <table>
            <tr>
                <th>Flight Number</th>
                <th>Origin</th>
                <th>Destination</th>
                <th>Departure</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
            <?php while ($booking = $result->fetch_assoc()): ?>
                <tr>
                    <td><?php echo $booking['flight_number']; ?></td>
                    <td><?php echo $booking['origin']; ?></td>
                    <td><?php echo $booking['destination']; ?></td>
                    <td><?php echo $booking['departure_time']; ?></td>
                    <td><?php echo ucfirst($booking['status']); ?></td>
                    <td>
                        <?php if ($booking['status'] === 'confirmed'): ?>
                            <form method="POST" action="cancel_booking.php">
                                <input type="hidden" name="booking_id" value="<?php echo $booking['id']; ?>">
                                <button type="submit">Cancel</button>
                            </form>
                        <?php endif; ?>
                    </td>
                </tr>
            <?php endwhile; ?>
        </table>
    <?php else: ?>
        <p>No bookings found.</p>
    <?php endif; ?>
</body>
</html>
```

Similarly, the **`cancel_booking.php`** could handle booking cancellation logic, updating the booking status in the `bookings` table when a user requests to cancel. The implementation of this file is left to the user as a home-work exercise.

---

### 7. Handling payments (optional integration)

For a full-featured booking system, consider adding a payment module. Popular options include PayPal, Stripe, and Razorpay. Many offer PHP SDKs for easy integration. Implementing payment handling will require a new `payments` table and modifications to the booking process.

---

### 8. Additional resources and open-source projects

For further learning and to expand your project, consider checking out these open-source repositories and resources:

- [PHP-MySQL Flight Booking System on GitHub](https://github.com/username/repo) *(Add actual relevant repositories here)*
- Official PHP documentation on MySQLi and PDO
- Tutorials on handling authentication and authorization in PHP

---

### 9. Conclusion

Creating a dynamic airline booking system in PHP and MySQL is a rewarding project that offers insights into both backend development and relational database management. By following this guide, you should now have a working ticket reservation system, from database design to user authentication and booking management.