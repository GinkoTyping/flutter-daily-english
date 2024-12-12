<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: *');
header('Content-Type: application/json');

$response = [
    'success' => true,
    'message' => 'Users found.',
    'data' => []
];

try {
    $db = require 'db.php';

    $getAllUsersSql = "SELECT id, username FROM users";
    $getAllUsersStmt = $db->prepare($getAllUsersSql);
    $getAllUsersStmt->execute();

    $users = $getAllUsersStmt->fetchAll(PDO::FETCH_ASSOC);

    if (empty($users)) {
        $response['success'] = false;
        $response['message'] = 'No users found!';
    } else {
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