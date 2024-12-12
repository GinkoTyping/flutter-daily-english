<?php
$dsn = 'mysql:host=localhost:3308;dbname=li_hong_yao;charset=utf8mb4';
$db_username = 'root';
$db_password = '123456';
$options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES => false,
];

try {
    $pdo = new PDO($dsn, $db_username, $db_password, $options);
} catch (PDOException $e) {
    throw new Exception('Database connection failed: ' . $e->getMessage());
}

return $pdo;
?>