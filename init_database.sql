-- 1. Create the AutoTest database if it doesn't exist
IF NOT EXISTS (
    SELECT name 
    FROM sys.databases 
    WHERE name = N'AutoTest_ML_27March'
)
BEGIN
    CREATE DATABASE [AutoTest_ML_27March];
END;
GO
USE [AutoTest_ML_27March];
GO

-- 2. Create the [user] table if it doesn't exist
IF NOT EXISTS (
    SELECT * 
    FROM sys.tables 
    WHERE name = N'user'
)
BEGIN
    CREATE TABLE [dbo].[user] (
        [Name] VARCHAR(50) NOT NULL,
        [Surname] VARCHAR(50) NOT NULL,
        [Email] VARCHAR(100) NOT NULL
    );
END;
GO

-- 3. Create a stored procedure that inserts rows with TRY...CATCH 
--    but without returning explicit error details
IF EXISTS (
    SELECT * 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[InsertUser]') 
    AND type IN (N'P', N'PC')
)
BEGIN
    DROP PROCEDURE [dbo].[InsertUser];
END;
GO

CREATE PROCEDURE [dbo].[InsertUser]
    @Name VARCHAR(50),
    @Surname VARCHAR(50),
    @Email VARCHAR(100)
AS
BEGIN
    BEGIN TRY
        INSERT INTO [dbo].[user] ([Name], [Surname], [Email])
        VALUES (@Name, @Surname, @Email);
    END TRY
    BEGIN CATCH
        -- Error details removed. This block is empty (or could log errors).
        -- No SELECT or PRINT statement here, so it won't return error info.
    END CATCH;
END;
GO

-- 4. Insert sample data (will complete silently if valid)
EXEC [dbo].[InsertUser] 'John', 'Doe', 'john.doe@example.com';
EXEC [dbo].[InsertUser] 'Jane', 'Smith', 'jane.smith@example.org';
GO
