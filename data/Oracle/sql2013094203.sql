create or replace trigger task_crm_log after insert  or  delete on WorkPlan for each row 
DECLARE  
var_userid integer;  
var_workdate CHAR(10); 
var_taskid integer; 
var_logid integer;
var_type integer; 

begin    
if inserting then 
  BEGIN 
   var_userid:=:new.createrid; 
   var_workdate:=:new.createdate; 
   var_taskid:=:new.crmid; 
   var_logid:=:new.id;
   var_type:=:new.type_n;
   if var_type=3 then 
	   insert into task_operateLog(userid,workdate,tasktype,taskid,logid,createdate,createtime,logtype)  
	   VALUES(var_userid,var_workdate,9,var_taskid,var_logid,to_char(sysdate,'yyyy-mm-dd'),to_char(sysdate,'hh24:mi:ss'),1); 
   end if;
  END; 
end if; 

if deleting then  
   var_userid:=:old.createrid;  
   var_taskid:=:old.crmid;  
   var_type:=:old.type_n;
   if var_type=3 then 
   	DELETE FROM task_operateLog WHERE userid=var_userid AND tasktype=9 AND taskid=var_taskid; 
   end if; 
end if;
end;     
/