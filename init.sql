IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'sqli')
BEGIN
    CREATE DATABASE sqli;
END
GO

USE sqli;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U')
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL,
    password NVARCHAR(50) NOT NULL
);
GO

IF NOT EXISTS (SELECT * FROM users)
BEGIN
    INSERT INTO users (username, password) VALUES
    ('admin', 'admin123'),
    ('test', 'test123');
END
GO