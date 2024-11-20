---
layout: post
title: "Building a simple customer management system in PHP with MySQL"
tags: php mysql project case-study tutorial
image: /uploads/simple-customer-management-system-php-mysql.webp
---
Creating a customer management system (CMS) is a great way for beginners to learn PHP and MySQL. This hands-on project will guide you through the process of building a simple CMS from scratch, covering database design, CRUD operations, and form handling.

---

## What is a customer management system?

A customer management system is a tool used to store and manage customer information. It allows businesses to efficiently track customer details, such as names, email addresses, and phone numbers, using basic CRUD (Create, Read, Update, Delete) operations.

In this tutorial, you'll learn how to:
1. Design a database for storing customer information.
2. Build a user-friendly web interface for managing customers.
3. Implement CRUD functionality with PHP and MySQL.

---

## Prerequisites

To follow this tutorial, you need:
- A local server environment like **XAMPP** or **WAMP** (for Windows) or **MAMP** (for macOS).
- Basic knowledge of HTML, PHP, and SQL.
- A text editor such as VS Code, Sublime Text, or Notepad++.

![simple-customer-management-system-php-mysql](/uploads/simple-customer-management-system-php-mysql.webp)

---

## Step 1: Setting up the project

### 1.1 Install and configure your server
- Download and install **XAMPP** or your preferred local server.
- Start **Apache** and **MySQL** from the control panel.

### 1.2 Create the project folder
- Navigate to the `htdocs` directory in XAMPP and create a folder named `customer_management`.

---

## Step 2: Designing the database

### 2.1 Create the database
1. Open **phpMyAdmin** by navigating to `http://localhost/phpmyadmin`.
2. Click **New**, and name the database `customer_db`.

### 2.2 Create the `customers` table
Run the following SQL query to create the `customers` table:

```sql
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

This table has the following columns:
- `id`: A unique identifier for each customer.
- `name`: The customer's name.
- `email`: The customer's email address.
- `phone`: The customer's phone number.
- `created_at`: A timestamp of when the customer was added.

---

## Step 3: Building the front-end

### 3.1 Creating the HTML layout
Create a file named `index.php` in the `customer_management` folder:

```php
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Management</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h1>Customer Management System</h1>
        <a href="add_customer.php" class="btn">Add New Customer</a>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <!-- Dynamic content will go here -->
            </tbody>
        </table>
    </div>
</body>
</html>
```

---

## Step 4: Writing the back-end logic

### 4.1 Database connection
Create a file named `db.php` to handle database connectivity:

```php
<?php
$host = 'localhost';
$user = 'root';
$password = '';
$database = 'customer_db';

$conn = new mysqli($host, $user, $password, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
```

---

### 4.2 Fetch and display customers
Update `index.php` to fetch customer data dynamically:

```php
<?php
include 'db.php';

$sql = "SELECT * FROM customers";
$result = $conn->query($sql);
?>

<tbody>
    <?php if ($result->num_rows > 0): ?>
        <?php while ($row = $result->fetch_assoc()): ?>
            <tr>
                <td><?= $row['id']; ?></td>
                <td><?= $row['name']; ?></td>
                <td><?= $row['email']; ?></td>
                <td><?= $row['phone']; ?></td>
                <td>
                    <a href="edit_customer.php?id=<?= $row['id']; ?>" class="btn-edit">Edit</a>
                    <a href="delete_customer.php?id=<?= $row['id']; ?>" class="btn-delete">Delete</a>
                </td>
            </tr>
        <?php endwhile; ?>
    <?php else: ?>
        <tr>
            <td colspan="5">No customers found.</td>
        </tr>
    <?php endif; ?>
</tbody>
```

---

### 4.3 Adding a customer
1. Create `add_customer.php`:

```php
<?php
include 'db.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = $_POST['name'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];

    $sql = "INSERT INTO customers (name, email, phone) VALUES ('$name', '$email', '$phone')";
    if ($conn->query($sql)) {
        header('Location: index.php');
    } else {
        echo "Error: " . $conn->error;
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Add Customer</title>
</head>
<body>
    <form method="POST" action="">
        <input type="text" name="name" placeholder="Name" required>
        <input type="email" name="email" placeholder="Email" required>
        <input type="text" name="phone" placeholder="Phone">
        <button type="submit">Add Customer</button>
    </form>
</body>
</html>
```

---

## Step 5: Styling the app

Create a `style.css` file for basic styling:

```css
body {
    font-family: Arial, sans-serif;
    background-color: #f9f9f9;
    color: #333;
}
.container {
    max-width: 800px;
    margin: 20px auto;
    padding: 20px;
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 5px;
}
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}
table th, table td {
    border: 1px solid #ddd;
    padding: 10px;
    text-align: left;
}
.btn {
    display: inline-block;
    padding: 8px 12px;
    color: white;
    background-color: #007bff;
    text-decoration: none;
    border-radius: 3px;
}
```

---

## Step 6: Adding update and delete functionality

### Update
Create `edit_customer.php` to edit customer details using a pre-filled form.

### Delete
Create `delete_customer.php` to handle deleting a customer by ID.

---

## Conclusion

By following these steps, you’ve built a fully functional customer management system using PHP and MySQL. This project taught you how to:
- Design a database.
- Implement CRUD operations.
- Create a dynamic web interface.

You can now extend this project by adding features like search, sorting, or user authentication.

---

## References

- [PHP Documentation](https://www.php.net/manual/en/)
- [MySQL Official Docs](https://dev.mysql.com/doc/)