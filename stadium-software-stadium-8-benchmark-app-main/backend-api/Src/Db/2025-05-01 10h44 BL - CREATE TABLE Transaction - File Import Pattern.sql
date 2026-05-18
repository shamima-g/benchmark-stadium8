/******************************************************************************************************************/
/* DROP FOREIGN KEYS (if they exist) */

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Transaction]') AND type IN (N'U'))
BEGIN
    ALTER TABLE [dbo].[Transaction] DROP CONSTRAINT IF EXISTS [FkTransactionAccount];
    ALTER TABLE [dbo].[Transaction] DROP CONSTRAINT IF EXISTS [FkTransactionFileLog];
END
GO

/******************************************************************************************************************/
/* DROP UNIQUE INDEXES (if they exist) */

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UxTransactionReference' AND object_id = OBJECT_ID('dbo.[Transaction]')
)
    DROP INDEX [UxTransactionReference] ON [dbo].[Transaction];
GO

/******************************************************************************************************************/
/* DROP TABLES */

DROP TABLE IF EXISTS [dbo].[Transaction];
GO

/******************************************************************************************************************/
/* CREATE TABLES (no system-versioning; includes LastChangedDate) */

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [dbo].[Transaction](
    [Id]              INT IDENTITY(1,1) NOT NULL,
    [FileLogId]       INT NULL,
    [Reference]       VARCHAR(50) NOT NULL,
    [TransactionDate] DATETIME2(7) NOT NULL,
    [AccountNumber]   VARCHAR(50) NOT NULL,
    [Description]     VARCHAR(255) NULL,
    [Amount]          DECIMAL(18, 2) NOT NULL,
    [TransactionType] VARCHAR(10) NOT NULL,
    [Currency]        VARCHAR(3) NOT NULL CONSTRAINT [DfTransactionCurrency] DEFAULT ('ZAR'),
    [Status]          VARCHAR(10) NOT NULL CONSTRAINT [DfTransactionStatus] DEFAULT ('Imported'),
    [UserNote]        VARCHAR(1000) NULL,
    [LastChangedUser] VARCHAR(100) NOT NULL CONSTRAINT [DfTransactionLastChangedUser] DEFAULT ('System'),
    [LastChangedDate] DATETIME2(7) NOT NULL CONSTRAINT [DfTransactionLastChangedDate] DEFAULT (SYSDATETIME()),
    CONSTRAINT [PkTransaction] PRIMARY KEY CLUSTERED
    (
        [Id] ASC
    ) WITH (
        PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
        ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ),
    CONSTRAINT [CkTransactionType]
        CHECK ([TransactionType] IN ('Debit', 'Credit')),
    CONSTRAINT [CkTransactionStatus]
        CHECK ([Status] IN ('Imported', 'Approved', 'Rejected'))
) ON [PRIMARY];
GO


/****************************************************************************/
/** CREATE INDEXES **/

CREATE UNIQUE INDEX [UxTransactionReference] ON [dbo].[Transaction] ([Reference] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,
      IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF,
      ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
ON [PRIMARY];
GO

/**********************************************************************************************************/
/** CREATE FOREIGN KEYS **/

ALTER TABLE [dbo].[Transaction]  WITH CHECK
ADD  CONSTRAINT [FkTransactionFileLog] FOREIGN KEY([FileLogId])
REFERENCES [File].[Log] ([Id]);
GO

ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FkTransactionFileLog];
GO