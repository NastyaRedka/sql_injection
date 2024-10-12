<?php
// Create (or open) the SQLite database
$db = new SQLite3('database.db');

// Get user input from the login form
$user = $_POST['username'];
$pass = $_POST['password'];
$method = $_POST['method'];

switch ($method) {
    case 'vulnerable':
        // Vulnerable SQL query
        $sql = "SELECT * FROM users WHERE username = '$user' AND password = '$pass'";
        break;
    case 'parameterized':
        // Parametrized input to prevent SQL injection
        $stmt = $db->prepare('SELECT * FROM users WHERE username = :username AND password = :password');
        $stmt->bindValue(':username', $user, SQLITE3_TEXT);
        $stmt->bindValue(':password', $pass, SQLITE3_TEXT);
        $result = $stmt->execute();
        break;
    case 'escaping':
        // Escaping data to prevent SQL injection
        $user = SQLite3::escapeString($user);
        $pass = SQLite3::escapeString($pass);
        $sql = "SELECT * FROM users WHERE username = '$user' AND password = '$pass'";
        break;
    default:
        header("Location: index.html?error=true");
        exit;
}

// Execute the query if not using prepared statements
if (isset($sql)) {
    $result = $db->query($sql);
}

// Check if the user exists in the database
if ($result && $result->fetchArray()) {
    echo "Login successful!";
} else {
    header("Location: index.html?error=true");
}

$db->close();
?>