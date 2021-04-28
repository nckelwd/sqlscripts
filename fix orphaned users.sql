declare @username varchar(100)
,@sql varchar(max)

declare user_cur cursor for
SELECT name
FROM sysusers where (islogin =1 and issqluser = 1) and name not in ('sa','public','dbo','guest','INFORMATION_SCHEMA','sys') --modified by Andy 20190102
 -- previous SQL statement modified by Andy 20190102

open user_cur
fetch next from user_cur into @username

while @@FETCH_STATUS = 0
begin

--set @sql = ALTER user "'+@username+'" WITH LOGIN = "'+@username+'"
exec ('ALTER user ['+ @username + '] WITH LOGIN = [' + @username + '] ');

--exec(@sql)

fetch next from user_cur into @username

end

close user_cur
deallocate user_cur 
 
