SET IDENTITY_INSERT [File].[LocationType] ON;
INSERT INTO [File].[LocationType] ([Id],[Name],[Description], [LastChangedUser])
VALUES
(1,'Inbox','Inbox','System'),
(2,'Backup','Backup','System')

SET IDENTITY_INSERT [File].[LocationType] OFF;
