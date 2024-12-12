<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: *');
header('Content-Type: application/json');

$response = [
    'success' => true,
    'message' => 'Users found.',
    'data' => []  // 这里将存储所有用户的数据
];

try {
    $db = require 'db.php';  // 确保这个文件包含了数据库连接信息，并返回了一个 PDO 实例

    // 修改 SQL 查询以获取所有用户
    $getAllUsersSql = "SELECT id, username FROM users";
    $getAllUsersStmt = $db->prepare($getAllUsersSql);
    $getAllUsersStmt->execute();

    // 获取所有用户的结果
    $users = $getAllUsersStmt->fetchAll(PDO::FETCH_ASSOC);

    // 检查是否获取到了用户数据
    if (empty($users)) {
        $response['success'] = false;
        $response['message'] = 'No users found!';
    } else {
        // 将用户数据添加到响应中
        $response['data'] = $users;
    }

    echo json_encode($response);
} catch (PDOException $e) {
    http_response_code(500);
    $response['success'] = false;
    $response['message'] = "Database error: " . $e->getMessage();

    echo json_encode($response);
}

?>