CREATE TYPE Roles AS ENUM ("owner", "admin", "user");
CREATE TYPE UserActions AS ENUM ("create-account", "get-accounts", "login-account", "update-account", "delete-account", "send-invite-mail");
CREATE TYPE TokenActions AS ENUM ("create-token", "get-tokens", "revoke-token");


CREATE TABLE IF NOT EXISTS Users (
    Id UUID PRIMARY KEY,
    Email TEXT UNIQUE NOT NULL,
    Password TEXT NOT NULL,
    Role Roles NOT NULL,
    CreatedAt TIMESTAMPTZ NOT NULL,
    UpdatedAt TIMESTAMPTZ
);


CREATE TABLE IF NOT EXISTS KeyPairs (
    Id UUID PRIMARY KEY,
    PublicKey BYTEA UNIQUE NOT NULL,
    CreatedAt TIMESTAMPTZ
);


CREATE TABLE IF NOT EXISTS Tokens (
    Id UUID PRIMARY KEY,
    CreatorId UUID NOT NULL,
    KeyId UUID NOT NULL,
    TokenName CHAR(20) NOT NULL,
    ExpiresAt TIMESTAMPTZ,
    IsRevoked BOOLEAN NOT NULL DEFAULT FALSE,
    RevokedBy UUID NOT NULL,
    CreatedAt TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (CreatorId) REFERENCES Users(Id),
    FOREIGN KEY (KeyId) REFERENCES KeyPairs(Id),
    FOREIGN KEY (RevokedBy) REFERENCES Users(Id)
);


CREATE TABLE IF NOT EXISTS UsageLogs (
    Id UUID PRIMARY KEY,
    TokenId UUID NOT NULL,
    CallerIP CIDR NOT NULL,
    Subject TEXT NOT NULL,
    From TEXT NOT NULL,
    To TEXT NOT NULL,
    FilePath TEXT,
    CreatedAt TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (TokenId) REFERENCES Tokens(Id)
);

CREATE TABLE IF NOT EXISTS UserLogs (
    Id UUID PRIMARY KEY,
    UserId UUID NOT NULL,
    ActionType UserActions NOT NULL,
    IPAddress CIDR NOT NULL,
    UserAgent TEXT NOT NULL,
    CreatedAt TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE IF NOT EXISTS TokenLogs (
    Id UUID PRIMARY KEY,
    UserId UUID NOT NULL,
    TokenId UUID NOT NULL,
    ActionType TokenActions NOT NULL,
    IPAddress CIDR NOT NULL,
    CreatedAt TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (TokenId) REFERENCES Tokens(Id)
);
