<?php
// Підключення до SQL Server
$serverName = "tcp:localhost,1433"; // Вказати адресу сервера
$connectionOptions = array(
    "Database" => "sqli", // Назва бази даних
    "Uid" => "sa", // Ваше ім'я користувача
    "PWD" => "N1astya_"  // Ваш пароль
);

// Підключення до бази даних
$conn = sqlsrv_connect($serverName, $connectionOptions);

if (!$conn) {
    die(print_r(sqlsrv_errors(), true));
}

// Отримуємо дані з форми (як з POST, так і з GET)
$user = $_POST['username'] ?? $_GET['username'] ?? ''; // Перевіряємо як POST, так і GET
$pass = $_POST['password'] ?? $_GET['password'] ?? ''; // Перевіряємо як POST, так і GET
$method = $_POST['method'] ?? $_GET['method'] ?? ''; // Перевіряємо метод

switch ($method) {
    case 'vulnerable':
        // Вразливий SQL запит без параметризації (SQL ін'єкція)
        $sql = "SELECT * FROM users WHERE username = '$user' AND password = '$pass'";
        break;
    case 'parameterized':
        // Параметризований запит для запобігання SQL ін'єкціям
        $sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        $params = array($user, $pass);
        break;
    case 'escaping':
        // Екранування даних для запобігання SQL ін'єкціям
        $user = addslashes($user); // Екранує спецсимволи
        $pass = addslashes($pass); // Екранує спецсимволи
        $sql = "SELECT * FROM users WHERE username = '$user' AND password = '$pass'";
        break;
    default:
        header("Location: index.html?error=true");
        exit;
}

// Виконання запиту
if (isset($sql)) {
    if ($method === 'parameterized') {
        $stmt = sqlsrv_query($conn, $sql, $params);
    } else {
        $stmt = sqlsrv_query($conn, $sql);
    }
}

// Перевіряємо чи існує користувач у базі даних
if ($stmt && sqlsrv_fetch_array($stmt)) {
    echo "Login successful!";
} else {
    header("Location: index.html?error=true");
}

// Закриваємо підключення
sqlsrv_close($conn);
?>
