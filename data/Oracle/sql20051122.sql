CREATE or REPLACE PROCEDURE workflow_CurOpe_UbyForward 
(requestid_1 integer,userid_1 integer,usertype_1 integer,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

update workflow_currentoperator set isremark=2,operatedate=currentdate,operatetime=currenttime 
where requestid =requestid_1 and userid =userid_1 and usertype=usertype_1 and isremark=1;

end;
/

CREATE or REPLACE PROCEDURE workflow_CurOpe_UpdatebyReject 
(requestid_1 integer,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

update workflow_currentoperator set isremark = '2',operatedate=currentdate,operatetime=currenttime 
where requestid =requestid_1 and isremark=0; 

end;
/

CREATE or REPLACE PROCEDURE workflow_CurOpe_UpdatebySubmit 
(requestid_1 integer,groupid_1 integer,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

update workflow_currentoperator set isremark = '2',operatedate=currentdate,operatetime=currenttime 
where requestid =requestid_1 and isremark=0 and groupid =groupid_1;

end;
/

CREATE or REPLACE PROCEDURE workflow_CurOpe_UpdatebyView 
(requestid_1 integer,userid_1 integer,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

update workflow_currentoperator set operatedate=currentdate,operatetime=currenttime 
where requestid =requestid_1 and userid =userid_1 and isremark in(0,4) and operatedate is null;

end;
/

CREATE OR REPLACE PROCEDURE workflow_CurrentOperator_I
( requestid1    integer, userid1        integer, groupid1    in out integer,
workflowid1    integer, workflowtype1    integer, usertype1    integer, isremark1    char  ,nodeid  integer,agentorbyagentid  integer,agenttype  char,showorder integer,
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor )
AS
workflowtype2 integer;
receivedate char(10);
receivetime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into receivedate from dual;
select to_char(sysdate,'hh24:mi:ss') into receivetime from dual;

if groupid1 is null 
then groupid1 := 0 ; 
end if ;

update workflow_currentoperator set islasttimes=0 where requestid=requestid1 and userid=userid1;

if workflowtype1 = '' 
then 
select  workflowtype INTO  workflowtype2 from workflow_base where id = workflowid1;
insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,orderdate,ordertime,iscomplete,islasttimes)
values(requestid1,userid1,groupid1, workflowid1,workflowtype2,usertype1,isremark1,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,0,receivedate,receivetime,0,1); 
else
insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,orderdate,ordertime,iscomplete,islasttimes)
values(requestid1,userid1,groupid1, workflowid1,workflowtype1,usertype1,isremark1,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,0,receivedate,receivetime,0,1); 
end if ;

end;
/

CREATE or REPLACE PROCEDURE workflow_Requestbase_Insert 
(requestid_1	integer,
workflowid_2	integer,
lastnodeid_3	integer, 
lastnodetype_4	char,
currentnodeid_5	integer,
currentnodetype_6	char, 
status_7		varchar2,
passedgroups_8	integer,
totalgroups_9	integer, 
requestname_10	varchar2,
creater_11	integer,
createdate_12	char, 
createtime_13	char,
lastoperator_14	integer, 
lastoperatedate_15	char, 
lastoperatetime_16	char,
deleted_17	integer,
creatertype_18	integer, 
lastoperatortype_19	integer,
nodepasstime_20	float ,
nodelefttime_21	float , 
docids_22 		Varchar2,
crmids_23 		Varchar2, 
hrmids_24 		Varchar2,
prjids_25 		Varchar2, 
cptids_26 		Varchar2,
messageType_27 	integer, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

insert into workflow_requestbase 
(requestid,
workflowid,
lastnodeid,
lastnodetype,
currentnodeid,
currentnodetype,
status, 
passedgroups,
totalgroups,
requestname,
creater,
createdate,
createtime,
lastoperator, 
lastoperatedate,
lastoperatetime,
deleted,
creatertype,
lastoperatortype,
nodepasstime,
nodelefttime,
docids,
crmids,
hrmids,
prjids,
cptids,
messageType) 
values
(requestid_1,
workflowid_2,
lastnodeid_3,
lastnodetype_4,
currentnodeid_5,
currentnodetype_6,
status_7, 
passedgroups_8,
totalgroups_9,
requestname_10,
creater_11,
currentdate,
currenttime,
lastoperator_14, 
lastoperatedate_15,
lastoperatetime_16,
deleted_17,
creatertype_18,
lastoperatortype_19,
nodepasstime_20,
nodelefttime_21,
docids_22,
crmids_23,
hrmids_24,
prjids_25,
cptids_26,
messageType_27);
end;
/

CREATE OR REPLACE PROCEDURE workflow_RequestLog_Insert
( requestid1	integer, workflowid1	integer, nodeid1	integer,logtype1	char ,
operatedate1	char, operatetime1	char,operator1	integer, remark1	varchar2,
clientip1	char, operatortype1	integer,destnodeid1	integer, operate varchar2,
agentorbyagentid  integer,agenttype  char,showorder integer,
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
                      update workflow_requestlog SET	 operatedate	 = currentdate, operatetime	 = currenttime, remark	 = remark1, clientip	 = clientip1, destnodeid	 = destnodeid1
                      WHERE ( requestid	 = requestid1 AND nodeid	 = nodeid1 AND logtype	 = logtype1 AND operator	 = operator1 AND operatortype	 = operatortype1);

               else
                      insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder)
                      values(requestid1,workflowid1,nodeid1,logtype1, currentdate,currenttime,operator1, remark1,clientip1,operatortype1,destnodeid1,operate,agentorbyagentid,agenttype,showorder);
               end if;
   else


                  delete workflow_requestlog where requestid=requestid1 and nodeid=nodeid1 and (logtype='1') and operator = operator1 and operatortype = operatortype1;
                  insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder) values(requestid1,workflowid1,nodeid1,logtype1, currentdate,currenttime,operator1, remark1,clientip1,operatortype1,destnodeid1,operate,agentorbyagentid,agenttype,showorder);


   end if;

end;
/