-- name: AddUser :one
INSERT INTO Users (
    Id, Email, Password, Role, UpdatedAt
) VALUES (
    $1, $2, $3, $4, $5
) RETURNING *;


-- name: GetUserById :one
SELECT * FROM Users WHERE Id = $1 LIMIT 1;


-- name: GetUserByEmail :one
SELECT * FROM Users WHERE Id = $1 LIMIT 1;


-- name: GetUsersByRole :many
SELECT * FROM Users WHERE Role = $1;


-- name: GetAllUsers :many
SELECT * FROM Users;


-- name: UpdatePassword :exec
UPDATE Users SET Password = $2, UpdatedAt = $3 WHERE Id = $1;


-- name: UpdatePlatformRole :exec
UPDATE Users SET Role = $2, UpdatedAt = $3 WHERE Id = $1;


-- name: DeleteUser :exec
DELETE FROM Users WHERE Id = $1;
