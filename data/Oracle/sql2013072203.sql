alter table BILL_FNAPAYAPPLY modify REASON VARCHAR2(4000)
/

update workflow_billfield 
set fielddbtype = 'varchar2(4000)' 
where billid = 156 and fieldname = 'reason'
/