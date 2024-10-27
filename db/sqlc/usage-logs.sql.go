// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.27.0
// source: usage-logs.sql

package db

import (
	"context"
	"net/netip"

	"github.com/oklog/ulid"
)

const addUsageLogs = `-- name: AddUsageLogs :one
INSERT INTO UsageLogs (
    Id, TokenId, CallerIP, Subject, Subject, Sender, Receiver
) VALUES (
    $1, $2, $3, $4, $5, $6, $7
) RETURNING id, tokenid, callerip, subject, sender, receiver
`

type AddUsageLogsParams struct {
	ID        ulid.ULID    `json:"id"`
	Tokenid   ulid.ULID    `json:"tokenid"`
	Callerip  netip.Prefix `json:"callerip"`
	Subject   string       `json:"subject"`
	Subject_2 string       `json:"subject_2"`
	Sender    string       `json:"sender"`
	Receiver  string       `json:"receiver"`
}

func (q *Queries) AddUsageLogs(ctx context.Context, arg AddUsageLogsParams) (Usagelog, error) {
	row := q.db.QueryRow(ctx, addUsageLogs,
		arg.ID,
		arg.Tokenid,
		arg.Callerip,
		arg.Subject,
		arg.Subject_2,
		arg.Sender,
		arg.Receiver,
	)
	var i Usagelog
	err := row.Scan(
		&i.ID,
		&i.Tokenid,
		&i.Callerip,
		&i.Subject,
		&i.Sender,
		&i.Receiver,
	)
	return i, err
}

const deleteLogsByTokenId = `-- name: DeleteLogsByTokenId :exec
DELETE FROM UsageLogs WHERE TokenId = $1
`

func (q *Queries) DeleteLogsByTokenId(ctx context.Context, tokenid ulid.ULID) error {
	_, err := q.db.Exec(ctx, deleteLogsByTokenId, tokenid)
	return err
}

const getTokenUsage = `-- name: GetTokenUsage :many
SELECT id, tokenid, callerip, subject, sender, receiver FROM UsageLogs WHERE TokenId = $1
`

func (q *Queries) GetTokenUsage(ctx context.Context, tokenid ulid.ULID) ([]Usagelog, error) {
	rows, err := q.db.Query(ctx, getTokenUsage, tokenid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []Usagelog{}
	for rows.Next() {
		var i Usagelog
		if err := rows.Scan(
			&i.ID,
			&i.Tokenid,
			&i.Callerip,
			&i.Subject,
			&i.Sender,
			&i.Receiver,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getTokenUsageByIP = `-- name: GetTokenUsageByIP :many
SELECT id, tokenid, callerip, subject, sender, receiver FROM UsageLogs WHERE CallerIP = $1
`

func (q *Queries) GetTokenUsageByIP(ctx context.Context, callerip netip.Prefix) ([]Usagelog, error) {
	rows, err := q.db.Query(ctx, getTokenUsageByIP, callerip)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []Usagelog{}
	for rows.Next() {
		var i Usagelog
		if err := rows.Scan(
			&i.ID,
			&i.Tokenid,
			&i.Callerip,
			&i.Subject,
			&i.Sender,
			&i.Receiver,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getUsageLogs = `-- name: GetUsageLogs :many
SELECT id, tokenid, callerip, subject, sender, receiver FROM UsageLogs
`

func (q *Queries) GetUsageLogs(ctx context.Context) ([]Usagelog, error) {
	rows, err := q.db.Query(ctx, getUsageLogs)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []Usagelog{}
	for rows.Next() {
		var i Usagelog
		if err := rows.Scan(
			&i.ID,
			&i.Tokenid,
			&i.Callerip,
			&i.Subject,
			&i.Sender,
			&i.Receiver,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}
