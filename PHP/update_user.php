<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: *');
header('Content-Type: application/json');

$username = isset($_POST['username']) ? $_POST['username'] : '';
$id = isset($_POST['id']) ? $_POST['id'] : '';

$response = [
    'success' => true,
    'message' => 'Update successfully.',
];

try {
    $db = require 'db.php';

    $updateUserSql = "UPDATE users SET username = :username WHERE id = :id";
    $updateUserStmt = $db->prepare($updateUserSql);
    $updateUserStmt->bindParam(':username', $username);
    $updateUserStmt->bindParam(':id', $id);
    $updateUserStmt->execute();

    if ($updateUserStmt->rowCount() == 0) {
        $response['success'] = false;
        $response['message'] = 'Updating failed';
    }

    echo json_encode($response);
} catch (PDOException $e) {
    http_response_code(500);
    $response['success'] = false;
    $response['message'] = "Database error: " . $e->getMessage();

    echo json_encode($response);
}
?>