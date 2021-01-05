alter table FnaLoanLog modify description varchar2(4000)
/
alter table fnaloaninfo modify remark varchar2(4000)
/
alter table bill_HrmFinance modify description varchar2(4000)
/

create or replace TRIGGER Tri_importloan after INSERT ON fnaloanlog
FOR each row
declare
	relatedcrm_1 integer;
	relatedprj_1 integer;
	organizationid_1 integer;
	occurdate_1 char(10);
	amount_1 number(15,3);
	subject_1 integer;
	requestid_1 integer;
	description_1 varchar2(4000);
	loantype_1 integer;
	debitremark_1 varchar2(60);
	processorid_1 integer;
begin
loantype_1 := :new.loantypeid;
organizationid_1 := :new.resourceid;
relatedcrm_1 := :new.crmid;
relatedprj_1 := :new.projectid;
amount_1 := :new.amount;
occurdate_1 := :new.occurdate;
requestid_1 := :new.releatedid;
description_1 := :new.description;
debitremark_1 := :new.credenceno;
processorid_1 := :new.dealuser;
if(loantype_1=1) then
insert into fnaloaninfo(loantype,organizationtype,organizationid,relatedcrm,relatedprj,amount,occurdate,requestid,remark,debitremark,processorid) values(loantype_1,3,organizationid_1,relatedcrm_1,relatedprj_1,amount_1,occurdate_1,requestid_1,description_1,debitremark_1,processorid_1);
end if;
end;
/