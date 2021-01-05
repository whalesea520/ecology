
CREATE TABLE workflow_currentoperator_tmp (
	requestid 	int NOT NULL ,
	userid 		int NULL ,
	groupid 	int NULL ,
	workflowid 	int NULL ,
	workflowtype 	int NULL ,
	isremark 	char (1)  NULL ,
	usertype 	int NULL ,
	nodeid		int NULL ,
	agentorbyagentid	int NULL ,
	agenttype	char (1)  NULL ,
	showorder	int NULL ,
	receivedate	char (10)  NULL ,
	receivetime	char (8)  NULL ,
	viewtype	int NULL ,
	orderdate	char (10)  NULL ,
	ordertime	char (8)  NULL ,
	iscomplete	int NULL ,
	islasttimes	int NULL 
)
/

INSERT INTO workflow_currentoperator_tmp(
requestid ,userid ,groupid ,workflowid ,workflowtype ,isremark ,usertype ,nodeid ,agentorbyagentid ,agenttype ,
showorder ,receivedate ,receivetime ,viewtype ,orderdate ,ordertime ,iscomplete ,islasttimes)
SELECT requestid ,userid ,groupid ,workflowid ,workflowtype ,isremark ,usertype ,nodeid ,agentorbyagentid ,agenttype ,
showorder ,receivedate ,receivetime ,viewtype ,orderdate ,ordertime ,iscomplete ,islasttimes
FROM workflow_currentoperator ORDER BY requestid,nodeid
/

DROP TABLE workflow_currentoperator
/

CREATE TABLE workflow_currentoperator (
	requestid 	int NOT NULL ,
	userid 		int NULL ,
	groupid 	int NULL ,
	workflowid 	int NULL ,
	workflowtype 	int NULL ,
	isremark 	char (1)  NULL ,
	usertype 	int NULL ,
	nodeid		int NULL ,
	agentorbyagentid	int NULL ,
	agenttype	char (1)  NULL ,
	showorder	int 	NULL ,
	receivedate	char (10)  NULL ,
	receivetime	char (8)  NULL ,
	viewtype	int NULL ,
	orderdate	char (10)  NULL ,
	ordertime	char (8)  NULL ,
	iscomplete	int NULL ,
	islasttimes	int NULL ,
	id		int  NOT NULL
)
/
create sequence T_wf_curopt_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger T_wf_curopt_Trigger
before insert on workflow_currentoperator
for each row
begin
select T_wf_curopt_id.nextval into :new.id from dual;
end;
/

INSERT INTO workflow_currentoperator(
requestid ,userid ,groupid ,workflowid ,workflowtype ,isremark ,usertype ,nodeid ,agentorbyagentid ,agenttype ,
showorder ,receivedate ,receivetime ,viewtype ,orderdate ,ordertime ,iscomplete ,islasttimes)
SELECT requestid ,userid ,groupid ,workflowid ,workflowtype ,isremark ,usertype ,nodeid ,agentorbyagentid ,agenttype ,
showorder ,receivedate ,receivetime ,viewtype ,orderdate ,ordertime ,iscomplete ,islasttimes
FROM workflow_currentoperator_tmp ORDER BY requestid,nodeid
/

CREATE INDEX wrkcuoper_requestid_in on workflow_currentoperator(REQUESTID,USERID,USERTYPE)
/
CREATE INDEX WRKCUOPER_USER_IN2
    ON WORKFLOW_CURRENTOPERATOR(isremark,USERID,USERTYPE)
/

DROP TABLE workflow_currentoperator_tmp
/


declare cursor c1 is select id,workflowtype from workflow_base;
wfid integer;
wftype integer;
begin
    open c1;
    fetch c1 into wfid, wftype;
    while c1%found
    loop
	     update workflow_currentoperator set workflowtype=wftype where workflowid=wfid and workflowtype<>wftype;
         fetch c1 into wfid, wftype;
    end loop;
    close c1;
end;
/


update workflow_currentoperator set islasttimes=1
/

declare cursor c_4 is
	select requestid,userid,max(id) maxid,count(*) tcount
	from workflow_currentoperator
	where isremark=4
	group by requestid,userid
	having count(*)>0
	order by requestid,userid;
    requestid_4 integer;
    userid_4 integer;
    maxid_4 integer;
    tcount_4 integer; 
begin
    open c_4;
    fetch c_4 into requestid_4,userid_4,maxid_4,tcount_4;
    while c_4%found
    loop        
	     update workflow_currentoperator set islasttimes=0 where requestid=requestid_4 and userid=userid_4 and isremark<4;
	     if tcount_4>1 then
		     update workflow_currentoperator set islasttimes=0 where requestid=requestid_4 and userid=userid_4 and isremark=4 and id<maxid_4;
         end if;
	     fetch c_4 into requestid_4,userid_4,maxid_4,tcount_4;
    end loop;
    close c_4;
end;
/

declare cursor c_0 is 
	select requestid,userid,max(id) maxid,count(*) tcount
	from workflow_currentoperator
	where islasttimes=1 and isremark=0
	group by requestid,userid
	having count(*)>0
	order by requestid,userid;
    requestid_0 integer;
    userid_0 integer; 
    maxid_0 integer;
    tcount_0 integer; 
begin
    open c_0;
    fetch c_0 into requestid_0,userid_0,maxid_0,tcount_0;
    while c_0%found
    loop            
	     update workflow_currentoperator set islasttimes=0 where requestid=requestid_0 and userid=userid_0 and isremark in (1,2);
	     if tcount_0>1 then
		     update workflow_currentoperator set islasttimes=0 where requestid=requestid_0 and userid=userid_0 and isremark=0 and id<maxid_0;
         end if;
	     fetch c_0 into requestid_0,userid_0,maxid_0,tcount_0;
    end loop;
    close c_0;
end;
/

declare cursor c_1 is
	select requestid,userid,max(id) maxid,count(*) tcount
	from workflow_currentoperator
	where islasttimes=1 and isremark=1
	group by requestid,userid
	having count(*)>0
	order by requestid,userid;
    requestid_1 integer;
    userid_1 integer; 
    maxid_1 integer;
    tcount_1 integer; 
begin
    open c_1;
    fetch c_1 into requestid_1,userid_1,maxid_1,tcount_1;
    while c_1%found
    loop
	     update workflow_currentoperator set islasttimes=0 where requestid=requestid_1 and userid=userid_1 and isremark=2;
	     if tcount_1>1 then
		     update workflow_currentoperator set islasttimes=0 where requestid=requestid_1 and userid=userid_1 and isremark=1 and id<maxid_1;
         end if;
         fetch c_1 into requestid_1,userid_1,maxid_1,tcount_1;
    end loop;
    close c_1;
end;
/

declare cursor c_2 is
	select requestid,userid,max(id) maxid,count(*) tcount
	from workflow_currentoperator
	where islasttimes=1 and isremark=2
	group by requestid,userid
	having count(*)>0
	order by requestid,userid;
    requestid_2 integer;
    userid_2 integer; 
    maxid_2 integer;
    tcount_2 integer; 
begin
    open c_2;
    fetch c_2 into requestid_2,userid_2,maxid_2,tcount_2;
    while c_2%found
    loop
	     if tcount_2>1 then
		     update workflow_currentoperator set islasttimes=0 where requestid=requestid_2 and userid=userid_2 and isremark=2 and id<maxid_2;
         end if;
	     fetch c_2 into requestid_2,userid_2,maxid_2,tcount_2;
    end loop;
    close c_2;
end;
/



update workflow_currentoperator set viewtype=-2 where viewtype is null or viewtype>0
/


update workflow_currentoperator set iscomplete=0 where requestid in(select requestid from workflow_requestbase where currentnodetype<>3) and iscomplete<>0
/
update workflow_currentoperator set iscomplete=1 where requestid in(select requestid from workflow_requestbase where currentnodetype=3) and iscomplete<>1
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
select to_char(sysdate,'hh24:mm:ss') into currenttime from dual;

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
