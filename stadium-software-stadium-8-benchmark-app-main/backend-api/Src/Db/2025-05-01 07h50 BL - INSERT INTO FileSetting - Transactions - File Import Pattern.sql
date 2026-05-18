SET IDENTITY_INSERT [File].[Setting] ON;
INSERT INTO [File].[Setting] ([Id],[Name],[SourceId],[TypeId],[ProcessDefinitionId], [StagingSchema], [StagingTable], [TargetSchema], [TargetTable], [Direction],[LastChangedUser])
VALUES
(1,'Transaction-Import',(SELECT [Id] FROM [File].[Source] WHERE [Name] = 'Bank'),(SELECT [Id] FROM [File].[Type] WHERE [Name] = 'Transaction'),N'_rYM2QSptED6S9JIOwDh2ow','Staging', 'Transaction', 'dbo','Transaction', 'In','System')
SET IDENTITY_INSERT [File].[Setting] OFF;
