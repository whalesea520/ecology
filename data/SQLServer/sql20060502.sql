Alter FUNCTION GetDocShareDetailTable  (@userid varchar(10) ,@usertype  varchar(10))
RETURNS @DocShareDetail  TABLE (sourceid int , sharelevel int)
AS
BEGIN  
   Declare @seclevel varchar(10),@departmentid varchar(10),@subcompanyid varchar(10),@type varchar(10),@isSysadmin integer
   if @usertype='1'
   begin
      select @seclevel=seclevel,@departmentid=departmentid,@subcompanyid=subcompanyid1 from hrmresource where id=@userid   
      begin
        select @isSysadmin=count(*) from hrmresourcemanager where id=@userid        
        if @isSysadmin=1
            insert @DocShareDetail SELECT  sourceid,MAX(sharelevel) AS sharelevel from shareinnerdoc where 
            (type=1 and content=@userid) or (  type=4 and content in 
            (select convert(VARCHAR(10),roleid)+CONVERT(VARCHAR(10),rolelevel) from hrmrolemembers where resourceid=@userid) and seclevel<=@seclevel) 
            GROUP BY sourceid
        else         
	        insert @DocShareDetail SELECT  sourceid,MAX(sharelevel) AS sharelevel from shareinnerdoc where 
	        (type=1 and content=@userid) or  (type=2 and content=@subcompanyid and seclevel<=@seclevel) or 
	        (type=3 and content=@departmentid and seclevel<=@seclevel) or (  type=4 and content in 
	        (select convert(VARCHAR(10),roleid)+CONVERT(VARCHAR(10),rolelevel) from hrmrolemembers where resourceid=@userid) and seclevel<=@seclevel) 
	        GROUP BY sourceid
     end       
   end
   else 
    begin     
      select @type=type,@seclevel=seclevel from crm_customerinfo where id=@userid
       insert @DocShareDetail  SELECT  sourceid,MAX(sharelevel) AS sharelevel from shareouterdoc where 
                               (type=9 and content=@userid) or 
                               (type=10 and content=@type and seclevel<=@seclevel)
                                GROUP BY sourceid
    end  
   RETURN 
END
GO
