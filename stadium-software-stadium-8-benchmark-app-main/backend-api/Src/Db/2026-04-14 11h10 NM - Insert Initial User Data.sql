/******************************************************************************************************************/
/* INSERT Initial User DATA */
/******************************************************************************************************************/

--UserManagement.Page

SET IDENTITY_INSERT [UserManagement].[Page] ON
IF NOT EXISTS (SELECT 1 FROM [UserManagement].[Page])
	INSERT INTO [UserManagement].[Page] ([Id],[Name], [Route], [LastChangedUser], [LastChangedDate])
VALUES
    (1,		'Transactions',			'/transactions',                            'System', GETDATE())
GO
SET IDENTITY_INSERT [UserManagement].[Page] OFF

--UserManagement.Role
IF NOT EXISTS (SELECT 1 FROM [UserManagement].[Role])
	INSERT INTO [UserManagement].[Role] 
		([Name], [LastChangedUser]) 
	VALUES 
        ('File Importer', 'System'),
        ('Approver', 'System')
GO


--UserManagement.RolePage 
DECLARE @FileImporterRoleId INT = (SELECT [Id] FROM [UserManagement].[Role] WHERE [Name] = 'File Importer')

INSERT INTO [UserManagement].[RolePage] 
    ([RoleId], [PageId], [LastChangedUser])
SELECT
    @FileImporterRoleId,
    [Page].[Id],
    'System'
FROM
    [UserManagement].[Page]
WHERE
    NOT EXISTS (
        SELECT 1 
        FROM [UserManagement].[RolePage] 
        WHERE [RolePage].[RoleId] = @FileImporterRoleId 
          AND [RolePage].[PageId] = [Page].[Id]
    )
GO

DECLARE @ApproverRoleId INT = (SELECT [Id] FROM [UserManagement].[Role] WHERE [Name] = 'Approver')

INSERT INTO [UserManagement].[RolePage] 
    ([RoleId], [PageId], [LastChangedUser])
SELECT
    @ApproverRoleId,
    [Page].[Id],
    'System'
FROM
    [UserManagement].[Page]
WHERE
    NOT EXISTS (
        SELECT 1 
        FROM [UserManagement].[RolePage] 
        WHERE [RolePage].[RoleId] = @ApproverRoleId 
          AND [RolePage].[PageId] = [Page].[Id]
    )
GO


--UserManagement.User
IF NOT EXISTS (SELECT 1 FROM [UserManagement].[User] WHERE [Email] = 'fileimporter@digiata.com')
	INSERT INTO [UserManagement].[User] 
		([Email], [FirstName], [LastName], [PasswordHash], [LastChangedUser]) 
	VALUES ('fileimporter@digiata.com', 'File', 'Importer','c12834f1031f6497214f27d4432f26517ad494156cb88d512bdb1dc4b57db2d692a3dfa269a19b0a0a2a0fd7d6a2a885e33c839c93c206da30a187392847ed27', 'System')
GO

IF NOT EXISTS (SELECT 1 FROM [UserManagement].[User] WHERE [Email] = 'approver@digiata.com')
	INSERT INTO [UserManagement].[User] 
		([Email], [FirstName], [LastName], [PasswordHash], [LastChangedUser]) 
	VALUES ('approver@digiata.com', 'Approver', 'User','c12834f1031f6497214f27d4432f26517ad494156cb88d512bdb1dc4b57db2d692a3dfa269a19b0a0a2a0fd7d6a2a885e33c839c93c206da30a187392847ed27', 'System')
GO


--UserManagement.UserRole
DECLARE @FileImporterRoleId INT = (SELECT [Id] FROM [UserManagement].[Role] WHERE [Name] = 'File Importer')
DECLARE @UserId INT = (SELECT [Id] FROM [UserManagement].[User] WHERE Email = 'fileimporter@digiata.com')

IF NOT EXISTS (SELECT 1 FROM [UserManagement].[UserRole] WHERE [UserId] = @UserId AND [RoleId] = @FileImporterRoleId)
	INSERT INTO [UserManagement].[UserRole] 
		([UserId], [RoleId], [LastChangedUser]) 
	VALUES 
		(@UserId, @FileImporterRoleId, 'System')
GO 

DECLARE @ApproverRoleId INT = (SELECT [Id] FROM [UserManagement].[Role] WHERE [Name] = 'Approver')
DECLARE @UserId INT = (SELECT [Id] FROM [UserManagement].[User] WHERE Email = 'approver@digiata.com')

IF NOT EXISTS (SELECT 1 FROM [UserManagement].[UserRole] WHERE [UserId] = @UserId AND [RoleId] = @ApproverRoleId)
	INSERT INTO [UserManagement].[UserRole] 
		([UserId], [RoleId], [LastChangedUser]) 
	VALUES 
		(@UserId, @ApproverRoleId, 'System')
GO 

