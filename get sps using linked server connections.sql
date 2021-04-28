Declare @VName varchar(256)

Declare Findlinked cursor

LOCAL STATIC FORWARD_ONLY READ_ONLY

     FOR

Select name

	From sys.servers

	Where is_linked = 1

Open Findlinked;

Fetch next from Findlinked into @VName;

while @@FETCH_STATUS = 0

Begin

	SELECT OBJECT_NAME(object_id)

		FROM sys.sql_modules

		WHERE Definition LIKE '%'+@VName +'%'

		AND OBJECTPROPERTY(object_id, 'IsProcedure') = 1 ;

	Fetch next from Findlinked into @VName;

End

Close Findlinked

Deallocate Findlinked