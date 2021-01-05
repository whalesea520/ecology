delete from workflow_SelectItem 
where selectvalue=0 and selectname='≤ª÷ÿ∏¥' 
and fieldid in (SELECT id from workflow_billfield where billid=85 and fieldhtmltype=5 and fieldname='repeatType')
/

update  Meeting_Type set approver1=0 where approver1=approver
/