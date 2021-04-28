SELECT DB_NAME() as dbname, type_desc, name as logical_name, 
    CONVERT(decimal(12,1),size/128.0) as TotalMB,
    CONVERT(decimal(12,1),FILEPROPERTY(name,'SpaceUsed')/128.0) as UsedMB,
    CONVERT(decimal(12,1),(size - FILEPROPERTY(name,'SpaceUsed'))/128.0) as FreeMB,
    physical_name
FROM sys.database_files WITH (NOLOCK)
ORDER BY type, file_id;

USE ShoreTel
GO
EXEC sp_spaceused
GO