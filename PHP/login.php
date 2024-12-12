<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

// 接收POST请求的数据
$username = isset($_POST['username']) ? $_POST['username'] : '';
$password = isset($_POST['password']) ? $_POST['password'] : '';

$response = [
    'success' => true,
    'message' => 'Login successfully.'
];

try {
    $db = require 'db.php';
    $checkUserSql = "SELECT * FROM users WHERE username = :username";
    $checkUserStmt = $db->prepare($checkUserSql);
    $checkUserStmt->bindParam(':username', $username);
    $checkUserStmt->execute();

    // 获取查询结果
    $user = $checkUserStmt->fetch(PDO::FETCH_ASSOC);
    if (!$user || !password_verify($password, $user['password'])) {
        $response['success'] = false;
        $response['message'] = 'Username or password is wrong!';
    } else {
        $response['id'] = $user['id'];
    }

    echo json_encode($response);
} catch (PDOException $e) {
    http_response_code(500);
    $response['success'] = false;
    $response['message'] = "Database error：" . $e->getMessage();

    echo json_encode($response);
}
?>