create procedure crmshareinfo_mutidel
as
declare @crmid_1 int, @userid_1 int , @usertype_1 int , @sharelevel_1 int 
declare all_cursor cursor for
SELECT crmid, userid , usertype 
FROM CrmShareDetail 
GROUP BY crmid, userid , usertype  
HAVING (COUNT(crmid) > 1) 

OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @crmid_1 , @userid_1 , @usertype_1 
WHILE @@FETCH_STATUS = 0
begin
    select @sharelevel_1 = max(sharelevel) from CrmShareDetail  
    where crmid = @crmid_1 and  userid = @userid_1 and usertype = @usertype_1  

    delete CrmShareDetail where crmid = @crmid_1 and  userid = @userid_1 and usertype = @usertype_1 

    insert into CrmShareDetail (crmid,userid,usertype,sharelevel) 
	values (@crmid_1 , @userid_1 , @usertype_1 , @sharelevel_1 )    

    FETCH NEXT FROM all_cursor INTO @crmid_1 , @userid_1 , @usertype_1 
end 
CLOSE all_cursor
DEALLOCATE all_cursor 
GO

exec crmshareinfo_mutidel
GO

drop procedure crmshareinfo_mutidel
GO

