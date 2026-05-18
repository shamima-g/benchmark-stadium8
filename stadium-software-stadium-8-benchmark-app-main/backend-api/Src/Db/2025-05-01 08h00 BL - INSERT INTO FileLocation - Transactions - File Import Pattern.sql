SET IDENTITY_INSERT [File].[Location] ON;
INSERT INTO [File].[Location] ([Id],[SettingId],[LocationTypeId],[FileName],[Folder], [LastChangedUser])
VALUES
(1,(SELECT [Id] FROM [File].[Setting] WHERE [Name] = 'Transaction-Import'),(SELECT [Id] FROM [File].[LocationType] WHERE [Name] = 'Inbox'),'*transactions*.csv','C:\DigiataFileProcessing\Test\Input', 'System'),
(2,(SELECT [Id] FROM [File].[Setting] WHERE [Name] = 'Transaction-Import'),(SELECT [Id] FROM [File].[LocationType] WHERE [Name] = 'Backup'),'[YYYYMMDD]_Transactions.csv','C:\DigiataFileProcessing\Test\Input\Backup', 'System')
SET IDENTITY_INSERT [File].[Location] OFF;
