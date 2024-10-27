-- name: AddPublicKey :one
INSERT INTO PublicKeys (Id, PubKey) VALUES ($1, $2) RETURNING *;


-- name: GetPublicKey :one
SELECT * FROM PublicKeys WHERE Id = $1 LIMIT 1;


-- name: GetAllPublicKeys :many
SELECT * FROM PublicKeys;


-- name: DeletePublicKey :exec
DELETE FROM PublicKeys WHERE Id = $1;
