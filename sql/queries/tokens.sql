-- name: AddToken :one
INSERT INTO Tokens (
    Id, CreatorId, KeyId, TokenName, ExpiresAt
) VALUES ($1, $2, $3, $4, $5) RETURNING *;


-- name: GetTokens :many
SELECT * FROM Tokens;


-- name: GetExpiredTokens :many
SELECT * FROM Tokens WHERE ExpiresAt <= now();


-- name: GetRevokedTokens :many
SELECT * FROM Tokens WHERE IsRevoked = "true";


-- name: GetInvalidTokens :many
SELECT * FROM Tokens WHERE IsRevoked = "true" or ExpiresAt <= now();


-- name: GetTokenById :one
SELECT * FROM Tokens WHERE Id = $1 LIMIT 1;


-- name: GetTokensByTokenName :one
SELECT * FROM Tokens WHERE TokenName = $1 LIMIT 1;


-- name: GetTokensByCreatorId :many
SELECT * FROM Tokens WHERE CreatorId = $1;


-- name: GetActiveTokensByCreatorId :many
SELECT * FROM Tokens
WHERE CreatorId = $1 AND IsRevoked = "false" AND ExpiresAt > now();


-- name: GetExpiredTokensByCreatorId :many
SELECT * FROM Tokens WHERE CreatorId = $1 AND ExpiresAt <= now();


-- name: GetRevokedTokensByCreatorId :many
SELECT * FROM Tokens WHERE CreatorId = $1 AND IsRevoked = "true";


-- name: GetInvalidTokensByCreatorId :many
SELECT * FROM Tokens
WHERE CreatorId = $1 AND IsRevoked = "true" AND ExpiresAt <= now();


-- name: MarkRevoked :one
UPDATE Tokens
SET RevokedBy = $2, IsRevoked = "true"
WHERE Id = $1 AND IsRevoked = "false" AND RevokedAt = $3
RETURNING *;

-- name: DeleteToken :exec
DELETE FROM Tokens WHERE Id = $1;
