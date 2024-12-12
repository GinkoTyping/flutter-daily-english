CREATE DATABASE IF NOT EXISTS li_hong_yao;
USE li_hong_yao;

CREATE TABLE IF NOT EXISTS users
(
    id       INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50)  NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

DELETE FROM users where id = 1