<?php
header('Access-Control-Allow-Origin: *');

$username = isset($_POST['username']) ? $_POST['username'] : '';
$password = isset($_POST['password']) ? $_POST['password'] : '';

// 对密码进行加密
$hashedPassword = password_hash($password, PASSWORD_BCRYPT);

try {
    $db = require 'db.php';
    // 检测用户是否已经注册
    $checkUserSql = "SELECT COUNT(*) FROM users WHERE username = :username";
    $checkUserStmt = $db->prepare($checkUserSql);
    $checkUserStmt->bindParam(':username', $username);
    $checkUserStmt->execute();
    $IsExisted = $checkUserStmt->fetchColumn() > 0;

    if ($IsExisted) {
        http_response_code(400);
        echo "username: '" . $username . "' is not valid.";
        exit;
    } else {
        // SQL
        $sql = "INSERT INTO users (username, password) VALUES (:username, :password)";
        $stmt = $db->prepare($sql);
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':password', $hashedPassword);
        $stmt->execute();
        http_response_code(200);
        echo "Register Successfully.";
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo "Database error：" . $e->getMessage();
}
?>