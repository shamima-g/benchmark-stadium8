/******************************************************************************************************************/
/* DROP FOREIGN KEYS */

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Staging].[Transaction]') AND type in (N'U'))
ALTER TABLE [Staging].[Transaction] DROP CONSTRAINT IF EXISTS [FkStagingTransactionFileLog]
GO

/******************************************************************************************************************/
/* DROP TABLES */
DROP TABLE IF EXISTS [Staging].[Transaction]
GO

/******************************************************************************************************************/
/* CREATE TABLES */

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Staging].[Transaction](
    [Id] [INT] IDENTITY(1,1) NOT NULL,
    [FileLogId] [INT] NULL,
    [Reference] VARCHAR(MAX) NOT NULL,
    [TransactionDate] VARCHAR(MAX) NOT NULL,
    [AccountNumber] VARCHAR(MAX) NOT NULL,
    [Description] VARCHAR(MAX) NULL,
    [Amount] VARCHAR(MAX) NOT NULL,
    [TransactionType] VARCHAR(MAX) NOT NULL,
    [Currency] VARCHAR(MAX) NOT NULL,
    [TransformedTransactionType] VARCHAR(7) NULL,
    [IsValid] [BIT] NULL,
    [InvalidReason] VARCHAR(MAX) NULL,
 CONSTRAINT [PkStagingTransaction] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/**********************************************************************************************************/
/** CREATE FOREIGN KEYS **/

ALTER TABLE [Staging].[Transaction]  WITH CHECK ADD  CONSTRAINT [FkStagingTransactionFileLog] FOREIGN KEY([FileLogId])
REFERENCES [File].[Log] ([Id])
GO
ALTER TABLE [Staging].[Transaction] CHECK CONSTRAINT [FkStagingTransactionFileLog]
GO