<?php
header('Access-Control-Allow-Origin: *');

// 接收POST请求的数据
$username = isset($_POST['username']) ? $_POST['username'] : '';
$password = isset($_POST['password']) ? $_POST['password'] : '';

// 模拟的用户数据（实际中应该从数据库中获取）
$valid_credentials = [
    '1' => '1'
];

$response = [
    'success' => false,
    'message' => 'Invalid credentials'
];

// 检查凭据是否有效
if (isset($valid_credentials[$username]) && $valid_credentials[$username] === $password) {
    $response['success'] = true;
    $response['message'] = 'Login successful';
    // 可以在这里添加其他信息，比如用户的ID或角色
    // $response['user_id'] = 1;
    // $response['role'] = 'admin';
}

// 将响应数据编码为JSON格式并输出
//echo json_encode($data);

echo json_encode($response);
?>