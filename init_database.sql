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

-- 3. Create a stored procedure that inserts rows with TRY...CATCH error handling
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
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;
GO

-- 4. Insert sample data
EXEC [dbo].[InsertUser] 'John', 'Doe', 'john.doe@example.com';
EXEC [dbo].[InsertUser] 'Jane', 'Smith', 'jane.smith@example.org';
GO
