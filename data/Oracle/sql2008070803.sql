alter table workflow_nodebase add nodeattribute char(1)
/
update workflow_nodebase set nodeattribute='0'
/
alter table workflow_nodebase add passnum integer
/
update workflow_nodebase set passnum=0
/
alter table workflow_nodelink add ismustpass char(1)
/
CREATE TABLE workflow_nownode(
    requestid integer,
    nownodeid integer,
    nownodetype integer,
    nownodeattribute integer
)
/
insert into workflow_nownode select requestid,currentnodeid,currentnodetype,0 from workflow_requestbase
/
alter table workflow_currentoperator add isreject char(1)
/

CREATE or REPLACE PROCEDURE workflow_CurOpe_UpdatebySubmit 
(userid_2	integer, requestid_1 integer,groupid_1 integer,nodeid_2 integer,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

update workflow_currentoperator set operatedate = currentdate,operatetime = currenttime,viewtype=-2 where requestid = requestid_1 and userid = userid_2 and isremark='0' and groupid = groupid_1 and nodeid=nodeid_2;

update workflow_currentoperator set isremark = '2' where requestid =requestid_1 and isremark='0' and groupid =groupid_1 and nodeid=nodeid_2;

update workflow_currentoperator set isremark = '2' where requestid =requestid_1 and (isremark='1' or isremark='5' or isremark='8' or isremark='9') and userid = userid_2 and nodeid=nodeid_2;
end;
/

CREATE or REPLACE PROCEDURE workflow_CurOpe_UpdatebyReject 
(requestid_1 integer,nodeid_2 integer,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

update workflow_currentoperator set isremark = '2',operatedate=currentdate,operatetime=currenttime 
where requestid =requestid_1 and isremark='0' and nodeid=nodeid_2; 

end;
/
