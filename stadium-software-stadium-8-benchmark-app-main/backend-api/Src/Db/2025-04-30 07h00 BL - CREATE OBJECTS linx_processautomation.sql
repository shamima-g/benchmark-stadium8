/****** Object:  Schema [linx_processautomation]    Script Date: 2025/08/14 11:39:58 ******/
CREATE SCHEMA [linx_processautomation]
GO
/****** Object:  Schema [linx_processautomation_extensions]    Script Date: 2025/08/14 11:39:58 ******/
CREATE SCHEMA [linx_processautomation_extensions]
GO
/****** Object:  Schema [linx_processautomation_reporting]    Script Date: 2025/08/14 11:39:58 ******/
CREATE SCHEMA [linx_processautomation_reporting]
GO
/****** Object:  Table [linx_processautomation].[WorkflowInstances]    Script Date: 2025/08/14 11:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [linx_processautomation].[WorkflowInstances](
	[Id] [nvarchar](450) NOT NULL,
	[DefinitionId] [nvarchar](450) NOT NULL,
	[TenantId] [nvarchar](450) NULL,
	[Version] [int] NOT NULL,
	[WorkflowStatus] [int] NOT NULL,
	[CorrelationId] [nvarchar](450) NOT NULL,
	[ContextType] [nvarchar](450) NULL,
	[ContextId] [nvarchar](450) NULL,
	[Name] [nvarchar](450) NULL,
	[CreatedAt] [datetimeoffset](7) NOT NULL,
	[LastExecutedAt] [datetimeoffset](7) NULL,
	[FinishedAt] [datetimeoffset](7) NULL,
	[CancelledAt] [datetimeoffset](7) NULL,
	[FaultedAt] [datetimeoffset](7) NULL,
	[Data] [nvarchar](max) NULL,
	[LastExecutedActivityId] [nvarchar](max) NULL,
	[DefinitionVersionId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_WorkflowInstances] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [linx_processautomation_reporting].[Statuses]    Script Date: 2025/08/14 11:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [linx_processautomation_reporting].[Statuses](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Statuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [linx_processautomation_reporting].[ProcessDefinitions]    Script Date: 2025/08/14 11:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [linx_processautomation_reporting].[ProcessDefinitions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DefinitionId] [nvarchar](50) NOT NULL,
	[IsCurrent] [bit] NOT NULL,
	[ProcessId] [nvarchar](40) NOT NULL,
	[ProcessName] [nvarchar](200) NOT NULL,
	[BpmnXml] [nvarchar](max) NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ProcessDefinitions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [linx_processautomation_reporting].[ProcessActivities]    Script Date: 2025/08/14 11:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [linx_processautomation_reporting].[ProcessActivities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProcessDefinitionId] [int] NOT NULL,
	[ActivityId] [nvarchar](40) NOT NULL,
	[ActivityName] [nvarchar](200) NULL,
	[ActivityType] [nvarchar](40) NOT NULL,
 CONSTRAINT [PK_ProcessActivities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [linx_processautomation_reporting].[ProcessInstancesView]    Script Date: 2025/08/14 11:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                CREATE VIEW [linx_processautomation_reporting].[ProcessInstancesView] AS
                SELECT 
                    wi.[Id] AS ProcessInstanceId,
                    wi.[DefinitionId],
                    pd.[ProcessName],
                    wi.[ContextId],
                    statuses.[Id] AS CurrentStatusId,
                    statuses.[Name] AS CurrentStatus,
                    wi.[CreatedAt],
                    wi.[LastExecutedAt],
                    wi.[FinishedAt],
                    wi.[CancelledAt],
                    wi.[FaultedAt],
                    wi.[Data],
                    wi.[LastExecutedActivityId],
                    pa.[ActivityName] AS LastExecutedActivityName
                FROM 
                    linx_processautomation.WorkflowInstances wi
                INNER JOIN linx_processautomation_reporting.Statuses statuses
                    ON wi.[WorkflowStatus] = statuses.[Id]
                INNER JOIN linx_processautomation_reporting.ProcessDefinitions pd
                    ON wi.[DefinitionId] = pd.[DefinitionId]
                LEFT JOIN linx_processautomation_reporting.ProcessActivities pa
                    ON pd.[Id] = pa.[ProcessDefinitionId]
                    AND wi.[LastExecutedActivityId] = pa.[ActivityId]
GO
/****** Object:  Table [linx_processautomation].[WorkflowExecutionLogRecords]    Script Date: 2025/08/14 11:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [linx_processautomation].[WorkflowExecutionLogRecords](
	[Id] [nvarchar](450) NOT NULL,
	[TenantId] [nvarchar](450) NULL,
	[WorkflowInstanceId] [nvarchar](450) NOT NULL,
	[ActivityId] [nvarchar](450) NOT NULL,
	[ActivityType] [nvarchar](450) NOT NULL,
	[Timestamp] [datetimeoffset](7) NOT NULL,
	[EventName] [nvarchar](max) NULL,
	[Message] [nvarchar](max) NULL,
	[Source] [nvarchar](max) NULL,
	[Data] [nvarchar](max) NULL,
 CONSTRAINT [PK_WorkflowExecutionLogRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [linx_processautomation_reporting].[ProcessExecutionLogsView]    Script Date: 2025/08/14 11:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                CREATE VIEW [linx_processautomation_reporting].[ProcessExecutionLogsView] AS
                SELECT
	                welr.[Id],
	                welr.[WorkflowInstanceId] AS ProcessInstanceId,
	                pa.[ActivityId],
	                pa.[ActivityName],
	                pa.[ActivityType],
	                welr.[EventName],
	                welr.[Timestamp],
	                welr.[Message],
	                welr.[Source],
	                welr.[Data]
                FROM
                    linx_processautomation.WorkflowExecutionLogRecords welr
                INNER JOIN linx_processautomation.WorkflowInstances wi
                    ON welr.[WorkflowInstanceId] = wi.[Id]
                INNER JOIN linx_processautomation_reporting.ProcessDefinitions pd
                    ON wi.[DefinitionId] = pd.[DefinitionId]
                INNER JOIN linx_processautomation_reporting.ProcessActivities pa
                    ON pd.[Id] = pa.[ProcessDefinitionId]
                    AND pa.[ActivityId] = welr.[ActivityId]
GO
/****** Object:  Table [linx_processautomation].[__EFMigrationsHistory]    Script Date: 2025/08/14 11:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [linx_processautomation].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [linx_processautomation].[Bookmarks]    Script Date: 2025/08/14 11:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [linx_processautomation].[Bookmarks](
	[Id] [nvarchar](450) NOT NULL,
	[TenantId] [nvarchar](450) NULL,
	[Hash] [nvarchar](450) NOT NULL,
	[Model] [nvarchar](max) NOT NULL,
	[ModelType] [nvarchar](max) NOT NULL,
	[ActivityType] [nvarchar](450) NOT NULL,
	[ActivityId] [nvarchar](450) NOT NULL,
	[WorkflowInstanceId] [nvarchar](450) NOT NULL,
	[CorrelationId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_Bookmarks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [linx_processautomation].[Triggers]    Script Date: 2025/08/14 11:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [linx_processautomation].[Triggers](
	[Id] [nvarchar](450) NOT NULL,
	[TenantId] [nvarchar](450) NULL,
	[Hash] [nvarchar](450) NOT NULL,
	[Model] [nvarchar](max) NOT NULL,
	[ModelType] [nvarchar](max) NOT NULL,
	[ActivityType] [nvarchar](450) NOT NULL,
	[ActivityId] [nvarchar](450) NOT NULL,
	[WorkflowDefinitionId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_Triggers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [linx_processautomation].[WorkflowDefinitions]    Script Date: 2025/08/14 11:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [linx_processautomation].[WorkflowDefinitions](
	[Id] [nvarchar](450) NOT NULL,
	[DefinitionId] [nvarchar](450) NOT NULL,
	[TenantId] [nvarchar](450) NULL,
	[Name] [nvarchar](450) NULL,
	[DisplayName] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[Version] [int] NOT NULL,
	[IsSingleton] [bit] NOT NULL,
	[PersistenceBehavior] [int] NOT NULL,
	[DeleteCompletedInstances] [bit] NOT NULL,
	[IsPublished] [bit] NOT NULL,
	[IsLatest] [bit] NOT NULL,
	[Tag] [nvarchar](450) NULL,
	[Data] [nvarchar](max) NULL,
	[CreatedAt] [datetimeoffset](7) NOT NULL,
 CONSTRAINT [PK_WorkflowDefinitions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [linx_processautomation_extensions].[__EFMigrationsHistory]    Script Date: 2025/08/14 11:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [linx_processautomation_extensions].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [linx_processautomation_extensions].[ResetProcessInstanceLogs]    Script Date: 2025/08/14 11:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [linx_processautomation_extensions].[ResetProcessInstanceLogs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Timestamp] [datetime2](7) NOT NULL,
	[UserId] [nvarchar](40) NOT NULL,
	[ProcessInstanceId] [nvarchar](40) NOT NULL,
	[TargetActivityId] [nvarchar](40) NULL,
 CONSTRAINT [PK_ResetProcessInstanceLogs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [linx_processautomation_reporting].[__EFMigrationsHistory]    Script Date: 2025/08/14 11:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [linx_processautomation_reporting].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Bookmark_ActivityId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_Bookmark_ActivityId] ON [linx_processautomation].[Bookmarks]
(
	[ActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Bookmark_ActivityType]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_Bookmark_ActivityType] ON [linx_processautomation].[Bookmarks]
(
	[ActivityType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Bookmark_ActivityType_TenantId_Hash]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_Bookmark_ActivityType_TenantId_Hash] ON [linx_processautomation].[Bookmarks]
(
	[ActivityType] ASC,
	[TenantId] ASC,
	[Hash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Bookmark_CorrelationId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_Bookmark_CorrelationId] ON [linx_processautomation].[Bookmarks]
(
	[CorrelationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Bookmark_Hash]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_Bookmark_Hash] ON [linx_processautomation].[Bookmarks]
(
	[Hash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Bookmark_Hash_CorrelationId_TenantId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_Bookmark_Hash_CorrelationId_TenantId] ON [linx_processautomation].[Bookmarks]
(
	[Hash] ASC,
	[CorrelationId] ASC,
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Bookmark_TenantId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_Bookmark_TenantId] ON [linx_processautomation].[Bookmarks]
(
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Bookmark_WorkflowInstanceId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_Bookmark_WorkflowInstanceId] ON [linx_processautomation].[Bookmarks]
(
	[WorkflowInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Trigger_ActivityId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_Trigger_ActivityId] ON [linx_processautomation].[Triggers]
(
	[ActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Trigger_ActivityType]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_Trigger_ActivityType] ON [linx_processautomation].[Triggers]
(
	[ActivityType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Trigger_ActivityType_TenantId_Hash]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_Trigger_ActivityType_TenantId_Hash] ON [linx_processautomation].[Triggers]
(
	[ActivityType] ASC,
	[TenantId] ASC,
	[Hash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Trigger_Hash]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_Trigger_Hash] ON [linx_processautomation].[Triggers]
(
	[Hash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Trigger_Hash_TenantId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_Trigger_Hash_TenantId] ON [linx_processautomation].[Triggers]
(
	[Hash] ASC,
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Trigger_TenantId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_Trigger_TenantId] ON [linx_processautomation].[Triggers]
(
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Trigger_WorkflowDefinitionId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_Trigger_WorkflowDefinitionId] ON [linx_processautomation].[Triggers]
(
	[WorkflowDefinitionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowDefinition_DefinitionId_VersionId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_WorkflowDefinition_DefinitionId_VersionId] ON [linx_processautomation].[WorkflowDefinitions]
(
	[DefinitionId] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_WorkflowDefinition_IsLatest]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowDefinition_IsLatest] ON [linx_processautomation].[WorkflowDefinitions]
(
	[IsLatest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_WorkflowDefinition_IsPublished]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowDefinition_IsPublished] ON [linx_processautomation].[WorkflowDefinitions]
(
	[IsPublished] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowDefinition_Name]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowDefinition_Name] ON [linx_processautomation].[WorkflowDefinitions]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowDefinition_Tag]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowDefinition_Tag] ON [linx_processautomation].[WorkflowDefinitions]
(
	[Tag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowDefinition_TenantId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowDefinition_TenantId] ON [linx_processautomation].[WorkflowDefinitions]
(
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_WorkflowDefinition_Version]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowDefinition_Version] ON [linx_processautomation].[WorkflowDefinitions]
(
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowExecutionLogRecord_ActivityId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowExecutionLogRecord_ActivityId] ON [linx_processautomation].[WorkflowExecutionLogRecords]
(
	[ActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowExecutionLogRecord_ActivityType]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowExecutionLogRecord_ActivityType] ON [linx_processautomation].[WorkflowExecutionLogRecords]
(
	[ActivityType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowExecutionLogRecord_TenantId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowExecutionLogRecord_TenantId] ON [linx_processautomation].[WorkflowExecutionLogRecords]
(
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_WorkflowExecutionLogRecord_Timestamp]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowExecutionLogRecord_Timestamp] ON [linx_processautomation].[WorkflowExecutionLogRecords]
(
	[Timestamp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowExecutionLogRecord_WorkflowInstanceId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowExecutionLogRecord_WorkflowInstanceId] ON [linx_processautomation].[WorkflowExecutionLogRecords]
(
	[WorkflowInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowInstance_ContextId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowInstance_ContextId] ON [linx_processautomation].[WorkflowInstances]
(
	[ContextId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowInstance_ContextType]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowInstance_ContextType] ON [linx_processautomation].[WorkflowInstances]
(
	[ContextType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowInstance_CorrelationId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowInstance_CorrelationId] ON [linx_processautomation].[WorkflowInstances]
(
	[CorrelationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_WorkflowInstance_CreatedAt]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowInstance_CreatedAt] ON [linx_processautomation].[WorkflowInstances]
(
	[CreatedAt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowInstance_DefinitionId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowInstance_DefinitionId] ON [linx_processautomation].[WorkflowInstances]
(
	[DefinitionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowInstance_DefinitionVersionId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowInstance_DefinitionVersionId] ON [linx_processautomation].[WorkflowInstances]
(
	[DefinitionVersionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_WorkflowInstance_FaultedAt]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowInstance_FaultedAt] ON [linx_processautomation].[WorkflowInstances]
(
	[FaultedAt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_WorkflowInstance_FinishedAt]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowInstance_FinishedAt] ON [linx_processautomation].[WorkflowInstances]
(
	[FinishedAt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_WorkflowInstance_LastExecutedAt]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowInstance_LastExecutedAt] ON [linx_processautomation].[WorkflowInstances]
(
	[LastExecutedAt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowInstance_Name]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowInstance_Name] ON [linx_processautomation].[WorkflowInstances]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowInstance_TenantId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowInstance_TenantId] ON [linx_processautomation].[WorkflowInstances]
(
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_WorkflowInstance_WorkflowStatus]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowInstance_WorkflowStatus] ON [linx_processautomation].[WorkflowInstances]
(
	[WorkflowStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowInstance_WorkflowStatus_DefinitionId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowInstance_WorkflowStatus_DefinitionId] ON [linx_processautomation].[WorkflowInstances]
(
	[WorkflowStatus] ASC,
	[DefinitionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_WorkflowInstance_WorkflowStatus_DefinitionId_Version]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_WorkflowInstance_WorkflowStatus_DefinitionId_Version] ON [linx_processautomation].[WorkflowInstances]
(
	[WorkflowStatus] ASC,
	[DefinitionId] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ResetProcessInstanceLogs_ProcessInstanceId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_ResetProcessInstanceLogs_ProcessInstanceId] ON [linx_processautomation_extensions].[ResetProcessInstanceLogs]
(
	[ProcessInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProcessActivities_ProcessDefinitionId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE NONCLUSTERED INDEX [IX_ProcessActivities_ProcessDefinitionId] ON [linx_processautomation_reporting].[ProcessActivities]
(
	[ProcessDefinitionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ProcessDefinitions_DefinitionId]    Script Date: 2025/08/14 11:39:58 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProcessDefinitions_DefinitionId] ON [linx_processautomation_reporting].[ProcessDefinitions]
(
	[DefinitionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [linx_processautomation].[Bookmarks] ADD  DEFAULT (N'') FOR [CorrelationId]
GO
ALTER TABLE [linx_processautomation].[WorkflowDefinitions] ADD  DEFAULT ('0001-01-01T00:00:00.0000000+00:00') FOR [CreatedAt]
GO
ALTER TABLE [linx_processautomation].[WorkflowInstances] ADD  DEFAULT (N'') FOR [CorrelationId]
GO
ALTER TABLE [linx_processautomation_reporting].[ProcessActivities]  WITH CHECK ADD  CONSTRAINT [FK_ProcessActivities_ProcessDefinitions_ProcessDefinitionId] FOREIGN KEY([ProcessDefinitionId])
REFERENCES [linx_processautomation_reporting].[ProcessDefinitions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [linx_processautomation_reporting].[ProcessActivities] CHECK CONSTRAINT [FK_ProcessActivities_ProcessDefinitions_ProcessDefinitionId]
GO
/****** Object:  StoredProcedure [linx_processautomation_extensions].[ResetProcessInstance]    Script Date: 2025/08/14 11:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [linx_processautomation_extensions].[ResetProcessInstance]
    @ProcessInstanceId NVARCHAR(MAX),
    @TargetActivityId NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF (NOT EXISTS (SELECT 1 FROM linx_processautomation.WorkflowInstances WHERE Id = @ProcessInstanceId))
	BEGIN
		DECLARE @ProcessInstanceNotFoundMessage NVARCHAR(MAX) = CONCAT('The process instance with ID [', @ProcessInstanceId, '] was not found.');
        THROW 50000, @ProcessInstanceNotFoundMessage, 1;
	END
    IF (@TargetActivityId IS NULL)
    BEGIN
        UPDATE linx_processautomation.WorkflowInstances
        SET WorkflowStatus = 0, -- Idle
            Data = JSON_MODIFY(
                JSON_MODIFY(Data, '$.blockingActivities', JSON_QUERY('[]')),
                '$.scheduledActivities',
                JSON_QUERY('[]'))
        WHERE Id = @ProcessInstanceId;
    END
    ELSE
    BEGIN
        IF (NOT EXISTS (
            SELECT 1 FROM linx_processautomation_reporting.ProcessActivities pa
	            INNER JOIN linx_processautomation_reporting.ProcessDefinitions pd ON pd.Id = pa.ProcessDefinitionId
	            INNER JOIN linx_processautomation.WorkflowInstances wi ON wi.DefinitionId = pd.DefinitionId
            WHERE wi.Id = @ProcessInstanceId
            AND ActivityId = @TargetActivityId))
        BEGIN
			DECLARE @ProcessActivityNotFoundMessage NVARCHAR(MAX) = CONCAT('The process activity with ID [', @TargetActivityId, '] was not found.');
            THROW 50000, @ProcessActivityNotFoundMessage, 1;
        END
        DECLARE @ScheduledActivitiesJson NVARCHAR(MAX) = '[ { "ActivityId": "' + @TargetActivityId + '" } ]';
        UPDATE linx_processautomation.WorkflowInstances
        SET WorkflowStatus = 1, -- Running
            Data = JSON_MODIFY(
                JSON_MODIFY(Data, '$.blockingActivities', JSON_QUERY('[]')),
                '$.scheduledActivities',
                JSON_QUERY(@ScheduledActivitiesJson))
        WHERE Id = @ProcessInstanceId;
    END
    INSERT INTO linx_processautomation_extensions.ResetProcessInstanceLogs
        (Timestamp, UserId, ProcessInstanceId, TargetActivityId)
        VALUES (GETUTCDATE(), SUSER_NAME(), @ProcessInstanceId, @TargetActivityId);
END
GO

INSERT INTO [linx_processautomation].__EFMigrationsHistory (MigrationId, ProductVersion)
VALUES
	('20210523093504_Initial','8.0.13'),
	('20210611200049_Update21','8.0.13'),
	('20210923112224_Update23','8.0.13'),
	('20211215100215_Update24','8.0.13'),
	('20220120170305_Update241','8.0.13'),
	('20220120204205_Update25','8.0.13'),
	('20220512203701_Update28','8.0.13')
GO

INSERT INTO [linx_processautomation_reporting].[__EFMigrationsHistory] (MigrationId, ProductVersion)
  VALUES
    ('20250711090141_AddStatusesTable', '8.0.13'),
	('20250711090242_AddProcessDefinitionTables', '8.0.13'),
	('20250711090324_AddProcessInstancesView', '8.0.13'),
	('20250717091344_UpdateProcessInstancesView_AddColumns', '8.0.13'),
	('20250718063503_AddProcessExecutionLogsView', '8.0.13'),
	('20250926050232_UpdateProcessInstancesView_DefinitionIdColumn', '8.0.13')
GO

INSERT INTO [linx_processautomation_extensions].[__EFMigrationsHistory] (MigrationId, ProductVersion)
  VALUES
    ('20250710061508_AddResetProcessInstanceLogTable', '8.0.13'),
	('20250710061520_AddResetProcessInstanceStoredProc', '8.0.13'),
	('20250807142704_FixResetProcessInstanceStoredProc_ResetProcessDoesNotCompleteNormally', '8.0.13')
GO

INSERT [linx_processautomation_reporting].[Statuses] ([Id], [Name]) 
VALUES 
	(0, N'Idle'),
	(1, N'Running'),
	(2, N'Finished'),
	(3, N'Suspended'),
	(4, N'Faulted'),
	(5, N'Cancelled')
GO
