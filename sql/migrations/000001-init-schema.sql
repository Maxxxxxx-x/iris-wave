CREATE TYPE Roles AS ENUM ('owner', 'admin', 'user');
CREATE TYPE UserActions AS ENUM ('create-account', 'get-accounts', 'login-account', 'update-account', 'delete-account', 'send-invite-mail');
CREATE TYPE TokenActions AS ENUM ('create-token', 'get-tokens', 'revoke-token');


CREATE TABLE IF NOT EXISTS Users (
    Id UUID PRIMARY KEY,
    Email TEXT UNIQUE NOT NULL,
    Password TEXT NOT NULL,
    Role Roles NOT NULL,
    UpdatedAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS Users_Email ON Users (
    Email
);

CREATE INDEX IF NOT EXISTS Users_Role ON Users (
    Role
);


CREATE TABLE IF NOT EXISTS PublicKeys (
    Id UUID PRIMARY KEY,
    PubKey BYTEA UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS Tokens (
    Id UUID PRIMARY KEY,
    CreatorId UUID NOT NULL,
    KeyId UUID NOT NULL,
    TokenName CHAR(20) UNIQUE NOT NULL,
    ExpiresAt TIMESTAMPTZ,
    IsRevoked BOOLEAN NOT NULL DEFAULT FALSE,
    RevokedBy UUID DEFAULT NULL,
    RevokedAt TIMESTAMPTZ,
    FOREIGN KEY (CreatorId) REFERENCES Users(Id),
    FOREIGN KEY (KeyId) REFERENCES KeyPairs(Id),
    FOREIGN KEY (RevokedBy) REFERENCES Users(Id)
);

CREATE INDEX IF NOT EXISTS Tokens_CreatorId ON Tokens (
    CreatorId
);

CREATE INDEX IF NOT EXISTS Tokens_KeyId ON Tokens (
    KeyId
);

CREATE INDEX IF NOT EXISTS Tokens_ExpiresAt ON Tokens (
    ExpiresAt
);

CREATE INDEX IF NOT EXISTS Tokens_IsRevoked ON Tokens (
    IsRevoked
);

CREATE INDEX IF NOT EXISTS Tokens_CreatorId ON Tokens (
    CreatorId
);

CREATE INDEX IF NOT EXISTS Tokens_KeyId ON Tokens (
    KeyId
);

CREATE INDEX IF NOT EXISTS Tokens_ExpiresAt ON Tokens (
    ExpiresAt
);

CREATE INDEX IF NOT EXISTS Tokens_IsRevoked ON Tokens (
    IsRevoked
);


CREATE TABLE IF NOT EXISTS UsageLogs (
    Id UUID PRIMARY KEY,
    TokenId UUID NOT NULL,
    CallerIP CIDR NOT NULL,
    Subject TEXT NOT NULL,
    Sender TEXT NOT NULL,
    Receiver TEXT NOT NULL,
    FOREIGN KEY (TokenId) REFERENCES Tokens(Id)
);

CREATE INDEX IF NOT EXISTS UsageLogs_TokenId ON UsageLogs (
    TokenId
);

CREATE INDEX IF NOT EXISTS UsageLogs_CallerIP ON UsageLogs (
    CallerIP
);


CREATE TABLE IF NOT EXISTS UserLogs (
    Id UUID PRIMARY KEY,
    UserId UUID NOT NULL,
    ActionType UserActions NOT NULL,
    IPAddr CIDR NOT NULL,
    UserAgent TEXT NOT NULL,
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE INDEX IF NOT EXISTS UserLogs_UserId ON UserLogs (
    UserId
);

CREATE INDEX IF NOT EXISTS UserLogs_ActionType ON UserLogs (
    ActionType
);

CREATE INDEX IF NOT EXISTS UserLogs_IPAddr ON UserLogs (
    IPAddr
);


CREATE TABLE IF NOT EXISTS TokenLogs (
    Id UUID PRIMARY KEY,
    UserId UUID NOT NULL,
    TokenId UUID NOT NULL,
    ActionType TokenActions NOT NULL,
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (TokenId) REFERENCES Tokens(Id)
);

CREATE INDEX IF NOT EXISTS TokenLogs_UserId ON TokenLogs (
    UserId
);

CREATE INDEX IF NOT EXISTS TokenLogs_TokenId ON TokenLogs (
    TokenId
);

CREATE INDEX IF NOT EXISTS TokenLogs_ActionType ON TokenLogs (
    ActionType
);
