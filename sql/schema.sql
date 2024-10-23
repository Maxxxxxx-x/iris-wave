CREATE TYPE Roles AS ENUM ("owner", "superadmin", "admin");
CREATE TYPE UserActions AS ENUM ("create-account", "get-accounts", "login-account", "update-account", "delete-account", "send-creation-email");
CREATE TYPE TokenActions AS ENUM("create-token", "revoke-token")

CREATE TABLE IF NOT EXISTS Users(
    Id CHAR(26) PRIMARY KEY,
    Email TEXT UNIQUE NOT NULL,
    Password TEXT NOT NULL,
    Role Roles NOT NULL,
    CreatedAt BIGINT,
    UpdatedAt BIGINT
);

CREATE TABLE IF NOT EXISTS KeyPairs(
    Id CHAR(26) PRIMARY KEY,
    PublicKey BYTEA NOT NULL,
    CreatedAt BIGINT
);

CREATE TABLE IF NOT EXISTS Tokens(
    Id CHAR(26) PRIMARY KEY,
    CreatorId CHAR(26) NOT NULL,
    KeyId CHAR(26) NOT NULL,
    Name CHAR(20) NOT NULL,
    ExpiresAt BIGINT,
    IsRevoked BOOLEAN DEFAULT FALSE,
    CreatedAt BIGINT,
    FOREIGN KEY (KeyId) REFERENCES KeyPairs(Id),
    FOREIGN KEY (CreatorId) REFERENCES Users(Id),
    FOREIGN KEY (RevokedBy) REFERENCES Users(Id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS UsageLogs(
    Id CHAR(26)  PRIMARY KEY,
    TokenId CHAR(26) NOT NULL,
    CallerIP CIDR NOT NULL,
    Subject TEXT NOT NULL,
    From TEXT NOT NULL,
    To TEXT NOT NULL,
    FilePath TEXT NOT NULL,
    CreatedAt BIGINT,
    FOREIGN KEY (TokenId) REFERENCES Tokens(Id)
);

CREATE TABLE IF NOT EXISTS UserLogs(
    Id CHAR(26) PRIMARY KEY,
    UserId CHAR(26) NOT NULL,
    ActionType UserActions NOT NULL,
    IPAddress CIDR NOT NULL,
    UserAgent TEXT NOT NULL,
    CreatedAt BIGINT,
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE IF NOT EXISTS TokenLogs(
    Id CHAR(26) PRIMARY KEY,
    UserId CHAR(26) NOT NULL,
    TokenId CHAR(26) NOT NULL,
    ActionType TokenActions NOT NULL,
    IPAddress CIDR NOT NULL,
    CreatedAt BIGINT,
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (TokenId) REFERENCES Tokens(Id)
);

CREATE INDEX IF NOT EXISTS UsersIdx ON Users (Email);
CREATE INDEX IF NOT EXISTS TokenIdx ON Tokens(CreatorId);
CREATE INDEX IF NOT EXISTS UsageLogs_TokenIdx ON UsageLogs(TokenId);
CREATE INDEX IF NOT EXISTS UsageLogs_IpIdx ON UsageLogs(CallerIP);
CREATE INDEX IF NOT EXISTS UserLogs_UserIdx ON UserLogs(UserId);
CREATE INDEX IF NOT EXISTS UserLogs_ActionIdx ON UserLogs(ActionType);
CREATE INDEX IF NOT EXISTS TokenLogs_UserIdx ON TokenLogs(UserId);
CREATE INDEX IF NOT EXISTS TokenLogs_TokenIdx ON TokenLogs(ActionType);
