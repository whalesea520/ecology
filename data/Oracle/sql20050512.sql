ALTER TABLE workflow_requestlog ADD receivedPersons varchar(1000)
/


CREATE OR REPLACE PROCEDURE workflow_RequestLog_Insert
( requestid1	integer, workflowid1	integer, nodeid1	integer,logtype1	char ,
operatedate1	char, operatetime1	char,operator1	integer, remark1	varchar2,
clientip1	char, operatortype1	integer,destnodeid1	integer, operate varchar2,
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor )
AS count1 integer;
begin

   if logtype1 = '1' then
               select  count(*) INTO  count1 from workflow_requestlog where requestid=requestid1 and nodeid=nodeid1 and logtype=logtype1 and operator = operator1 and operatortype = operatortype1;

               if count1 > 0 then
                      update workflow_requestlog SET	 operatedate	 = operatedate1, operatetime	 = operatetime1, remark	 = remark1, clientip	 = clientip1, destnodeid	 = destnodeid1
                      WHERE ( requestid	 = requestid1 AND nodeid	 = nodeid1 AND logtype	 = logtype1 AND operator	 = operator1 AND operatortype	 = operatortype1);

               else
                      insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons)
                      values(requestid1,workflowid1,nodeid1,logtype1, operatedate1,operatetime1,operator1, remark1,clientip1,operatortype1,destnodeid1,operate);
               end if;
   else


                  delete workflow_requestlog where requestid=requestid1 and nodeid=nodeid1 and (logtype='1') and operator = operator1 and operatortype = operatortype1;
                  insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons) values(requestid1,workflowid1,nodeid1,logtype1, operatedate1,operatetime1,operator1, remark1,clientip1,operatortype1,destnodeid1,operate);


   end if;

end;
/