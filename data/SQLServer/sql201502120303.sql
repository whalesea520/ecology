delete from workflow_SelectItem 
where selectvalue=0 and selectname='���ظ�' 
and fieldid in (SELECT id from workflow_billfield where billid=85 and fieldhtmltype=5 and fieldname='repeatType')
go

update  Meeting_Type set approver1=0 where approver1=approver
go