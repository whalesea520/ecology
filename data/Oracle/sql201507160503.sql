update hrm_state_proc_fields set field003 = 6114 where field002 = 'oldjoblevel' and field001 = 40
/
update hrm_state_proc_fields set field003 = 124926 where field002 = 'newjoblevel' and field001 = 40
/
update hrm_state_proc_fields set field003 = 124927 where field002 = 'resource_n' and field001 = 42
/
update hrm_state_proc_fields set field003 = 124928 where field002 = 'departmentid' and field001 = 40
/
update hrm_state_proc_fields set field006 = 4 where field002 = 'departmentid' and field001 = 0
/
update hrm_state_proc_fields set field010 = 0 where field002 in ('hirereason','manager') and field001 = 42
/
update hrm_state_proc_fields set field010 = 0 where field002 in ('docid','dismissreason','manager') and field001 = 41
/
update hrm_state_proc_fields set field010 = 0 where field002 in ('redeployreason','oldjoblevel','newjoblevel','manager','ischangesalary') and field001 = 40
/
update hrm_state_proc_fields set field010 = 1 where field002 in ('changereason','changecontractid','infoman') and field001 = 8
/
insert into workflow_browserurl(id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl,typeid,useable,orderid) values((select MAX(id)+1 from workflow_browserurl),614, 'int','/systeminfo/BrowserMain.jsp?url=/hrm/pm/HrmContract/browser.jsp','HrmContract','contractname','id','/hrm/contract/contract/HrmContractView.jsp?id=',9,1,(select MAX(id)+1 from workflow_browserurl))
/