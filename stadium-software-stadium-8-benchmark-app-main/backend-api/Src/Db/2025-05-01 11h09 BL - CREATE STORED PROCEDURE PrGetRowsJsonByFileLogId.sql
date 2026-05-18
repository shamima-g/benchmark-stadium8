CREATE OR ALTER PROCEDURE dbo.PrGetRowsJsonByFileLogId
    @SchemaName sysname,
    @TableName  sysname,
    @FileLogId  INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @QualifiedTable NVARCHAR(512) = QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName);

    DECLARE @sql NVARCHAR(MAX) =
        N'SELECT (SELECT * FROM ' + @QualifiedTable + N' WHERE FileLogId = @p AND InvalidReason IS NOT NULL FOR JSON PATH) AS JsonArray';

    EXEC sp_executesql @sql, N'@p INT', @p = @FileLogId;
END
GO
