alter table workflow_base add isannexUpload char(1)
/
alter table workflow_base add annexdoccategory varchar2(200)
/
alter table workflow_RequestLog add annexdocids varchar2(2000)
/


CREATE OR REPLACE PROCEDURE workflow_RequestLog_Insert
( requestid1	integer, workflowid1	integer, nodeid1	integer,logtype1	char ,
operatedate1	char, operatetime1	char,operator1	integer, remark_1	varchar2,
clientip1	char, operatortype1	integer,destnodeid1	integer, operate1 varchar2,
agentorbyagentid1  integer,agenttype1  char,showorder1 integer,annexdocids1 varchar2,
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor )
AS count1 integer;
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

   if logtype1 = '1' then
               select  count(*) INTO  count1 from workflow_requestlog where requestid=requestid1 and nodeid=nodeid1 and logtype=logtype1 and operator = operator1 and operatortype = operatortype1;

               if count1 > 0 then
                      update workflow_requestlog SET operatedate= currentdate, operatetime= currenttime, remark= remark_1, clientip= clientip1, destnodeid= destnodeid1,annexdocids=annexdocids1 WHERE ( requestid=requestid1 and nodeid=nodeid1 and logtype=logtype1 and operator = operator1 and operatortype = operatortype1);

               else
                      insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids) values(requestid1,workflowid1,nodeid1,logtype1, currentdate,currenttime,operator1, remark_1,clientip1,operatortype1,destnodeid1,operate1,agentorbyagentid1,agenttype1,showorder1,annexdocids1);
               end if;
   else


                  delete workflow_requestlog where requestid=requestid1 and nodeid=nodeid1 and (logtype='1') and operator = operator1 and operatortype = operatortype1;
                  insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids) values(requestid1,workflowid1,nodeid1,logtype1, currentdate,currenttime,operator1, remark_1,clientip1,operatortype1,destnodeid1,operate1,agentorbyagentid1,agenttype1,showorder1,annexdocids1);


   end if;

end;
/