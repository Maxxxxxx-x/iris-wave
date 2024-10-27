-- name: AddTokenLogs :one
INSERT INTO TokenLogs (
    Id, UserId, TokenId, ActionType
) VALUES (
    $1, $2, $3, $4
) RETURNING *;


-- name: GetTokenLogs :many
SELECT * FROM TokenLogs;


-- name: GetTokenLogsByTokenId :many
SELECT * FROM TokenLogs WHERE UserId = $1;


-- name: GetTokenLogsByUserId :many
SELECT * FROM TokenLogs WHERE TokenId = $1;


-- name: GetTokenLogsByActionType :many
SELECT * FROM TokenLogs WHERE ActionType = $1;


-- name: DeleteTokenLog :exec
DELETE FROM TokenLogs WHERE Id = $1;
