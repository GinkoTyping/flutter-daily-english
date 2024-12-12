<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: *');
header('Content-Type: application/json');

$id = isset($_POST['id']) ? $_POST['id'] : '';

$response = [
    'success' => true,
    'message' => 'Delete successfully.',
];

try {
    $db = require 'db.php';

    $deleteUserSql = "DELETE FROM users WHERE id = :id";
    $deleteUserStmt = $db->prepare($deleteUserSql);
    $deleteUserStmt->bindParam(':id', $id);
    $deleteUserStmt->execute();

    if ($deleteUserStmt->rowCount() == 0) {
        $response['success'] = false;
        $response['message'] = 'Deleting failed';
    }

    echo json_encode($response);
} catch (PDOException $e) {
    http_response_code(500);
    $response['success'] = false;
    $response['message'] = "Database error: " . $e->getMessage();

    echo json_encode($response);
}
