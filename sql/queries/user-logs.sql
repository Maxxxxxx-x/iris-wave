-- name: AddUserLogs :one
INSERT INTO UserLogs(
    Id, UserId, ActionType, IPAddr, UserAgent
) VALUES ($1, $2, $3, $4, $5) RETURNING *;


-- name: GetUserLogs :many
SELECT * FROM UserLogs;


-- name: GetUserLogsByUserId :many
SELECT * FROM UserLogs WHERE UserId = $1;


-- name: GetUserLogsByIP :many
SELECT * FROM UserLogs WHERE IPAddr = $1;


-- name: GetUserLogsByActionType :many
SELECT * FROM UserLogs WHERE ActionType = $1;


-- name: DeleteUserLogs :exec
DELETE FROM UserLogs WHERE Id = $1;
