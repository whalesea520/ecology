CREATE OR REPLACE PROCEDURE workflow_CurrentOperator_Copy
(requestid_0  	integer, 
 userid_0     	integer, 
 usertype_0  	integer, 
 flag out       integer, 
 msg out        varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
AS  
	 operatedate_0 varchar(10); 
	 operatetime_0 varchar(8) ;
begin	 
    select to_char(sysdate,'yyyy-mm-dd') into operatedate_0 from dual;
    select to_char(sysdate,'hh24:mi:ss') into operatetime_0 from dual;

update workflow_currentoperator 
set isremark=2,operatedate=operatedate_0,operatetime=operatetime_0
where requestid=requestid_0 and userid=userid_0 and usertype=usertype_0;
end;
/
