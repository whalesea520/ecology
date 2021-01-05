CREATE OR REPLACE PROCEDURE workflow_CurrentOperator_I
( requestid1    integer, userid1        integer, groupid1    in out integer,
workflowid1    integer, workflowtype1    integer, usertype1    integer, isremark1    char  ,nodeid  integer,agentorbyagentid  integer,agenttype  char,showorder integer,groupdetailid_1 integer,
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor )
AS
workflowtype2 integer;
receivedate char(10);
receivetime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into receivedate from dual;
select to_char(sysdate,'hh24:mm:ss') into receivetime from dual;

if groupid1 is null 
then groupid1 := 0 ; 
end if ;

update workflow_currentoperator set islasttimes=0 where requestid=requestid1 and userid=userid1 and usertype = usertype1;

if workflowtype1 = '' 
then 
select  workflowtype INTO  workflowtype2 from workflow_base where id = workflowid1;
insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,iscomplete,islasttimes,groupdetailid)
values(requestid1,userid1,groupid1, workflowid1,workflowtype2,usertype1,isremark1,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,0,0,1,groupdetailid_1); 
else
insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,iscomplete,islasttimes,groupdetailid)
values(requestid1,userid1,groupid1, workflowid1,workflowtype1,usertype1,isremark1,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,0,0,1,groupdetailid_1); 
end if ;

end;
/

CREATE or REPLACE PROCEDURE workflow_requeststatus_Select 
(userid_1 integer,requestid_1 integer,workflowid_1 integer,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
mcount integer ;
viewnodeidstmp varchar(1000);
viewnodeids varchar(5000);
begin
    select count(*) into mcount from workflow_monitor_bound where monitorhrmid=userid_1 and workflowid=workflowid_1;
        

    if mcount>0 then
         open thecursor for
	     select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid,
	     a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime,a.viewtype
	     from (SELECT distinct requestid
      ,userid
      ,workflowid
      ,workflowtype
      ,isremark
      ,usertype
      ,nodeid
      ,agentorbyagentid
      ,agenttype
     
      ,receivedate
      ,receivetime
      ,viewtype
      ,iscomplete
 
      ,operatedate
      ,operatetime
  FROM workflow_currentoperator  where requestid = requestid_1) a,workflow_nodebase b
	     where a.nodeid=b.id
	     and requestid=requestid_1 and a.agenttype<>1
	     order by a.receivedate,a.receivetime;
  
    else 
	     
         viewnodeids:='';
         for c1 in(
	     select b.viewnodeids 
	     	from (SELECT distinct requestid
      ,userid
      ,workflowid
      ,workflowtype
      ,isremark
      ,usertype
      ,nodeid
      ,agentorbyagentid
      ,agenttype
     
      ,receivedate
      ,receivetime
      ,viewtype
      ,iscomplete
 
      ,operatedate
      ,operatetime
  FROM workflow_currentoperator  where requestid = requestid_1) a,workflow_flownode b
	     where a.workflowid=b.workflowid and a.nodeid=b.nodeid
	     and a.requestid=requestid_1 and a.userid=userid_1 and a.usertype=0)
         loop 
              viewnodeidstmp := c1.viewnodeids;
		     if viewnodeidstmp='-1' then
			     viewnodeids:='-1';
			     exit;
		     else
			     viewnodeids:=CONCAT(viewnodeids,viewnodeidstmp);
		     end if;
         end loop;
    
	     if viewnodeids='-1' then
              open thecursor for
		     select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid,
		     a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime,a.viewtype
		     from (SELECT distinct requestid
      ,userid
      ,workflowid
      ,workflowtype
      ,isremark
      ,usertype
      ,nodeid
      ,agentorbyagentid
      ,agenttype
     
      ,receivedate
      ,receivetime
      ,viewtype
       ,iscomplete
 
      ,operatedate
      ,operatetime
  FROM workflow_currentoperator  where requestid = requestid_1) a,workflow_nodebase b
		     where a.nodeid=b.id
		     and requestid=requestid_1 and a.agenttype<>1
		     order by a.receivedate,a.receivetime;
	     else 
              viewnodeids:=trim(viewnodeids);
              viewnodeids:=substr(viewnodeids,1,length(viewnodeids)-1);
              open thecursor for
		     select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid,
		     a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime,a.viewtype
		from (SELECT distinct requestid
      ,userid
      ,workflowid
      ,workflowtype
      ,isremark
      ,usertype
      ,nodeid
      ,agentorbyagentid
      ,agenttype
     
      ,receivedate
      ,receivetime
      ,viewtype
      ,iscomplete
 
      ,operatedate
      ,operatetime
  FROM workflow_currentoperator  where requestid = requestid_1) a,workflow_nodebase b
		     where a.nodeid=b.id
		     and requestid=requestid_1 and a.agenttype<>1
		     order by a.receivedate,a.receivetime;
	     end if;    
    end if;
end;
/

ALTER TABLE workflow_currentoperator DROP COLUMN orderdate
/

ALTER TABLE workflow_currentoperator DROP COLUMN ordertime
/
