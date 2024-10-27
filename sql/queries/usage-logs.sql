-- name: AddUsageLogs :one
INSERT INTO UsageLogs (
    Id, TokenId, CallerIP, Subject, Subject, Sender, Receiver
) VALUES (
    $1, $2, $3, $4, $5, $6, $7
) RETURNING *;


-- name: GetUsageLogs :many
SELECT * FROM UsageLogs;


-- name: GetTokenUsage :many
SELECT * FROM UsageLogs WHERE TokenId = $1;


-- name: GetTokenUsageByIP :many
SELECT * FROM UsageLogs WHERE CallerIP = $1;


-- name: DeleteLogsByTokenId :exec
DELETE FROM UsageLogs WHERE TokenId = $1;
