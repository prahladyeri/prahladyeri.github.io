---
layout: post
title: "Core PHP CRUD operations: A beginner's tutorial"
tags: php mysql
published: true
image: /uploads/code-php-2.jpg
---
Creating dynamic web applications often involves interacting with a database. One of the foundational elements of web development is the ability to perform CRUD operations: Create, Read, Update, and Delete. This tutorial will guide you through core PHP CRUD operations, helping you understand how to manage data effectively in your applications. Whether you're building a simple blog or a complex web app, mastering these operations will be essential for your development journey.

## Prerequisites

Before diving into CRUD operations, ensure you have a basic understanding of the following:

- **HTML and CSS**: To create user interfaces.
- **PHP**: Knowledge of core PHP concepts.
- **MySQL**: Basic understanding of relational databases and SQL queries.
- **XAMPP or MAMP**: A local server setup to run your PHP scripts.

### Setting Up Your Environment

1. **Install XAMPP or MAMP**: This will help you run PHP and MySQL on your local machine.
2. **Create a Database**: Open phpMyAdmin and create a database named `crud_demo`. Inside this database, create a table named `users` with the following structure:

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

This `users` table will hold the data for our CRUD operations.

## Creating a PHP Script for CRUD Operations

### 1. Database Connection

Start by creating a `config.php` file to handle database connections.

```php
<?php
$host = 'localhost';
$db_name = 'crud_demo';
$username = 'root'; // Change if your MySQL username is different
$password = ''; // Change if you have set a password

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
}
?>
```

### 2. Creating Data (Insert)

Next, create a `create.php` file to insert data into the `users` table.

```php
<?php
include 'config.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = $_POST['name'];
    $email = $_POST['email'];

    $stmt = $conn->prepare("INSERT INTO users (name, email) VALUES (:name, :email)");
    $stmt->bindParam(':name', $name);
    $stmt->bindParam(':email', $email);
    
    if ($stmt->execute()) {
        echo "New user created successfully.";
    } else {
        echo "Error creating user.";
    }
}
?>

<form method="POST">
    Name: <input type="text" name="name" required>
    Email: <input type="email" name="email" required>
    <input type="submit" value="Create User">
</form>
```

![code-php](/uploads/code-php-2.jpg)

### 3. Reading Data (Select)

Create a `read.php` file to display all users in the `users` table.

```php
<?php
include 'config.php';

$stmt = $conn->prepare("SELECT * FROM users");
$stmt->execute();
$users = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<table border="1">
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Actions</th>
    </tr>
    <?php foreach ($users as $user): ?>
    <tr>
        <td><?php echo $user['id']; ?></td>
        <td><?php echo $user['name']; ?></td>
        <td><?php echo $user['email']; ?></td>
        <td>
            <a href="update.php?id=<?php echo $user['id']; ?>">Edit</a>
            <a href="delete.php?id=<?php echo $user['id']; ?>">Delete</a>
        </td>
    </tr>
    <?php endforeach; ?>
</table>
```

### 4. Updating Data

Now, create an `update.php` file to update user information.

```php
<?php
include 'config.php';

$id = $_GET['id'];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = $_POST['name'];
    $email = $_POST['email'];

    $stmt = $conn->prepare("UPDATE users SET name = :name, email = :email WHERE id = :id");
    $stmt->bindParam(':name', $name);
    $stmt->bindParam(':email', $email);
    $stmt->bindParam(':id', $id);
    
    if ($stmt->execute()) {
        echo "User updated successfully.";
        header("Location: read.php");
        exit();
    } else {
        echo "Error updating user.";
    }
} else {
    $stmt = $conn->prepare("SELECT * FROM users WHERE id = :id");
    $stmt->bindParam(':id', $id);
    $stmt->execute();
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
}
?>

<form method="POST">
    Name: <input type="text" name="name" value="<?php echo $user['name']; ?>" required>
    Email: <input type="email" name="email" value="<?php echo $user['email']; ?>" required>
    <input type="submit" value="Update User">
</form>
```

### 5. Deleting Data

Finally, create a `delete.php` file to handle user deletions.

```php
<?php
include 'config.php';

$id = $_GET['id'];

$stmt = $conn->prepare("DELETE FROM users WHERE id = :id");
$stmt->bindParam(':id', $id);

if ($stmt->execute()) {
    echo "User deleted successfully.";
    header("Location: read.php");
    exit();
} else {
    echo "Error deleting user.";
}
?>
```

## Understanding CRUD Operations

### Create

The **Create** operation allows you to add new records to the database. In our example, we use an HTML form to gather user input and the PDO `prepare` and `execute` methods to insert data securely.

### Read

The **Read** operation fetches and displays records from the database. We use a SQL `SELECT` query to retrieve user data, and we format it into an HTML table for easy viewing.

### Update

The **Update** operation modifies existing records based on user input. We fetch the current data for a specific user, present it in a form, and update the record using a `POST` request.

### Delete

The **Delete** operation removes records from the database. By passing the user ID via a URL parameter, we can execute a `DELETE` statement to remove the specified user.

## Best Practices for PHP CRUD Operations

1. **Use Prepared Statements**: Always use prepared statements to protect against SQL injection.
2. **Validate User Input**: Implement server-side validation for user input to ensure data integrity.
3. **Implement Error Handling**: Use try-catch blocks to gracefully handle potential errors.
4. **Organize Your Code**: Keep your code organized by separating concerns (e.g., database connections, business logic, and presentation).
5. **Follow Security Best Practices**: Sanitize inputs, hash passwords, and secure your application against common vulnerabilities.

## Conclusion

In this tutorial, we've covered the essential core PHP CRUD operations, demonstrating how to create, read, update, and delete records in a MySQL database. By understanding these foundational operations, you'll be well-equipped to build dynamic web applications. 

Remember that mastering CRUD operations is just the beginning. As you advance in your PHP journey, explore additional concepts such as AJAX integration, data validation, and security measures to enhance your applications further.

With practice and patience, you’ll be able to implement complex functionalities and create robust web applications that meet various user needs. Happy coding!