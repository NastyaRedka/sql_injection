<?php
// Create (or open) the SQLite database
$db = new SQLite3('database.db');

// Get user input from the login form
$user = $_POST['username'];
$pass = $_POST['password'];

// SQL query (vulnerable to SQL Injection)
$sql = "SELECT * FROM users WHERE username = '$user' AND password = '$pass'";

$result = $db->query($sql);

// Check if the user exists in the database
if ($result->fetchArray()) {
    echo "Login successful!";
} else {
    header("Location: index.html?error=true");
}

$db->close();
?>