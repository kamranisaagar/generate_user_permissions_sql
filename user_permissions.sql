USE [mydb];

DECLARE @UserName sysname = 'johndoe';
DECLARE @DBName sysname;
DECLARE @SQL nvarchar(max) = '';
DECLARE @UserExists bit;

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @DBName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @UserExists = 0;
    SET @SQL = '';
    
    SET @SQL = 'USE ' + QUOTENAME(@DBName) + '; 
                SELECT @UserExists = 1 
                FROM sys.database_principals 
                WHERE name = ''' + @UserName + ''';';
                
    EXEC sp_executesql @SQL, N'@UserExists bit OUTPUT', @UserExists = @UserExists OUTPUT;

    IF @UserExists = 1
    BEGIN
        SET @SQL = '';
        SET @SQL = 'USE ' + QUOTENAME(@DBName) + ';' + CHAR(13);

        SELECT
            @SQL = @SQL + 'EXEC sp_addrolemember ''' + USER_NAME(rm.role_principal_id) + ''', ''' + @UserName + ''';' + CHAR(13)
        FROM
            sys.database_role_members rm
        WHERE
            rm.member_principal_id = USER_ID(@UserName);

        SELECT
            @SQL = @SQL + 'GRANT ' + dp.permission_name + ' ON ' + QUOTENAME(s.name) + '.' + QUOTENAME(o.name) + ' TO ' + QUOTENAME(@UserName) + ';' + CHAR(13)
        FROM
            sys.database_permissions dp
            JOIN sys.objects o ON dp.major_id = o.object_id
            JOIN sys.schemas s ON o.schema_id = s.schema_id
        WHERE
            dp.grantee_principal_id = USER_ID(@UserName)
            AND dp.class = 1;

        SELECT
            @SQL = @SQL + 'GRANT ' + dp.permission_name + ' TO ' + QUOTENAME(@UserName) + ';' + CHAR(13)
        FROM
            sys.database_permissions dp
        WHERE
            dp.grantee_principal_id = USER_ID(@UserName)
            AND dp.class = 0;

        PRINT @SQL;
    END
    
    FETCH NEXT FROM db_cursor INTO @DBName;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;
