UPDATE HrmCareerApply  SET careerinviteid = careerid  where careerinviteid is null 
/

update workflow_bill set operationpage = 'BillLoanOperation.jsp' where id = 13
/

CREATE OR replace trigger DocDetailLog_Trigger
before INSERT ON DocDetailLog
for each row
begin
SELECT DocDetailLog_id.nextval INTO:new.id from dual;
end;
/