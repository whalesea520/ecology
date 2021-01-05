alter TRIGGER task_crm_log ON WorkPlan FOR INSERT,DELETE 
AS DECLARE @userid INT,@workdate CHAR(10),@taskid INT,@logid INT 
if exists(select 1 from inserted WHERE type_n=3)
  BEGIN
   select @userid=createrid,@workdate=createdate,@taskid=crmid,@logid=id from inserted 
   insert into task_operateLog(userid,workdate,tasktype,taskid,logid,createdate,createtime,logtype) 
   VALUES(@userid,@workdate,9,@taskid,@logid,CONVERT(CHAR(10),GETDATE(),23),CONVERT(CHAR(10),GETDATE(),24),1)
  END 
ELSE if exists(select 1 from deleted WHERE type_n=3)
  BEGIN
   select @userid=createrid,@workdate=createdate,@taskid=crmid,@logid=id from deleted
   DELETE FROM task_operateLog WHERE userid=@userid AND tasktype=9 AND taskid=@taskid
  END   
GO