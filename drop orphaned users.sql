USE DBNAME()

BEGIN
      CREATE TABLE #OrphanedUsers
             (
               row_num INT IDENTITY(1, 1)
             , username VARCHAR(1000)
             , id VARCHAR(1000)
             )

      INSERT INTO
        #OrphanedUsers ( username, id )
        EXEC sp_change_users_login 'Report'
        
        DELETE FROM  #OrphanedUsers WHERE [#OrphanedUsers].[username] = 'DBO';

      DECLARE @rowCount INT = (
                                SELECT COUNT (1) FROM #OrphanedUsers
                              ) ;

      DECLARE @i INT = 1 ;
      DECLARE @tempUsername VARCHAR(1000) ;

      WHILE( @i <= @rowCount )
            BEGIN
                  SELECT
                    @tempUsername = username
                  FROM
                    #OrphanedUsers
                  WHERE
                    row_num = @i ;
       
                 EXEC sp_change_users_login 'Auto_Fix', @tempUsername ;
       
                  SET @i = @i + 1 ;
            END

      DROP TABLE #OrphanedUsers ;

END