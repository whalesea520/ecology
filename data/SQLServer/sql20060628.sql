create PROCEDURE workflow_formFieldRt_S 
@formid		int, 
@nodeid		int, 
@flag integer output , 
@msg varchar(80) output AS 

select a.fieldid,a.fieldorder,a.isdetail,b.isedit 
from workflow_formfield a, workflow_nodeform b 
where formid=@formid and (isdetail<>'1' or isdetail is null) 
and a.fieldid=b.fieldid and b.nodeid=@nodeid 
order by a.fieldid 

GO


create  PROCEDURE workflow_billFieldRt_S
@formid		int, 
@nodeid		int, 
@flag integer output , 
@msg varchar(80) output AS 

select a.* ,b.isedit 
from workflow_billfield a, workflow_nodeform b 
where a.billid=@formid and a.id=b.fieldid and b.nodeid=@nodeid 
order by dsporder

GO
