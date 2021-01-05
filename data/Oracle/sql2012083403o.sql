CREATE OR REPLACE PROCEDURE workflow_RequestLogCurDate_I
( requestid1	integer, workflowid1	integer, nodeid1	integer,logtype1	char ,
operatedate1	char, operatetime1	char,operator1	integer, remark_1	varchar2,
clientip1	char, operatortype1	integer,destnodeid1	integer, operate1 clob,
agentorbyagentid1  integer,agenttype1  char,showorder1 integer,annexdocids1 varchar2,requestLogId1 integer,
signdocids1 varchar2,signworkflowids1 varchar2,
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor )
AS count1 integer;
count2 integer;
operatorDept1 integer;

begin 

    if operatortype1 = '0' then
        select count(*) into count2 from hrmresource where id = operator1;
        if count2 > 0 then
            select departmentid into operatorDept1 from hrmresource where id = operator1;
        else
            select distinct 0 into operatorDept1 from hrmresource;
        end if;
    else
        select distinct 0 into operatorDept1 from hrmresource;
    end if;
   
   if logtype1 = '1' then
               select  count(*) INTO  count1 from workflow_requestlog where requestid=requestid1 and nodeid=nodeid1 and logtype=logtype1 and operator = operator1 and operatortype = operatortype1;

               if count1 > 0 then
                      update workflow_requestlog SET operatedate= operatedate1, operatetime= operatetime1, remark= remark_1, clientip= clientip1, destnodeid= destnodeid1,annexdocids=annexdocids1,requestLogId=requestLogId1,signdocids=signdocids1,signworkflowids=signworkflowids1 WHERE ( requestid=requestid1 and nodeid=nodeid1 and logtype=logtype1 and operator = operator1 and operatortype = operatortype1);

               else
                      insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids,requestLogId,operatorDept,signdocids,signworkflowids) values(requestid1,workflowid1,nodeid1,logtype1, operatedate1,operatetime1,operator1, remark_1,clientip1,operatortype1,destnodeid1,operate1,agentorbyagentid1,agenttype1,showorder1,annexdocids1,requestLogId1,operatorDept1,signdocids1,signworkflowids1);
               end if;
   else


                  delete workflow_requestlog where requestid=requestid1 and nodeid=nodeid1 and (logtype='1') and operator = operator1 and operatortype = operatortype1;
                  insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids,requestLogId,operatorDept,signdocids,signworkflowids) values(requestid1,workflowid1,nodeid1,logtype1, operatedate1,operatetime1,operator1, remark_1,clientip1,operatortype1,destnodeid1,operate1,agentorbyagentid1,agenttype1,showorder1,annexdocids1,requestLogId1,operatorDept1,signdocids1,signworkflowids1);


   end if;

end;
/

CREATE OR REPLACE PROCEDURE workflow_RequestLog_Insert
( requestid1	integer, workflowid1	integer, nodeid1	integer,logtype1	char ,
operatedate1	char, operatetime1	char,operator1	integer, remark_1	varchar2,
clientip1	char, operatortype1	integer,destnodeid1	integer, operate1 clob,
agentorbyagentid1  integer,agenttype1  char,showorder1 integer,annexdocids1 varchar2,
requestLogId1 integer,signdocids1 varchar2,signworkflowids1 varchar2,
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor )
AS count1 integer;
count2 integer;
currentdate char(10);
currenttime char(8);
operatorDept1 integer;

begin 

select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

    if operatortype1 = '0' then
        select count(*) into count2 from hrmresource where id = operator1;
        if count2 > 0 then
            select departmentid into operatorDept1 from hrmresource where id = operator1;
        else
            select distinct 0 into operatorDept1 from hrmresource;
        end if;
    else
        select distinct 0 into operatorDept1 from hrmresource;
    end if;
       
   if logtype1 = '1' then
               select  count(*) INTO  count1 from workflow_requestlog where requestid=requestid1 and nodeid=nodeid1 and logtype=logtype1 and operator = operator1 and operatortype = operatortype1;

               if count1 > 0 then
                      update workflow_requestlog SET operatedate= currentdate, operatetime= currenttime, remark= remark_1, clientip= clientip1, destnodeid= destnodeid1,annexdocids=annexdocids1,requestLogId=requestLogId1,signdocids=signdocids1,signworkflowids=signworkflowids1 WHERE ( requestid=requestid1 and nodeid=nodeid1 and logtype=logtype1 and operator = operator1 and operatortype = operatortype1);

               else
                      insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids,requestLogId,operatorDept,signdocids,signworkflowids) values(requestid1,workflowid1,nodeid1,logtype1, currentdate,currenttime,operator1, remark_1,clientip1,operatortype1,destnodeid1,operate1,agentorbyagentid1,agenttype1,showorder1,annexdocids1,requestLogId1,operatorDept1,signdocids1,signworkflowids1);
               end if;
               OPEN thecursor FOR select currentdate,currenttime from dual;
   else


                  delete workflow_requestlog where requestid=requestid1 and nodeid=nodeid1 and (logtype='1') and operator = operator1 and operatortype = operatortype1;
                  insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids,requestLogId,operatorDept,signdocids,signworkflowids) values(requestid1,workflowid1,nodeid1,logtype1, currentdate,currenttime,operator1, remark_1,clientip1,operatortype1,destnodeid1,operate1,agentorbyagentid1,agenttype1,showorder1,annexdocids1,requestLogId1,operatorDept1,signdocids1,signworkflowids1);
                  OPEN thecursor FOR select currentdate,currenttime from dual;

   end if;

end;
/

CREATE OR REPLACE PROCEDURE workflow_nodebase_FFOptIst(
    operators_2 long, 
    id_1 integer,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
)
AS
BEGIN
    UPDATE workflow_nodebase SET operators = operators_2 WHERE id=id_1;
    commit;
END;
/