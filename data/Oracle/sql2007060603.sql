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
	     order by a.receivedate,a.receivetime,a.nodeid;
  
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
		     order by a.receivedate,a.receivetime,a.nodeid;
	     else 
              viewnodeids:=trim(viewnodeids);
	      if viewnodeids<>'' then
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
		     order by a.receivedate,a.receivetime,a.nodeid;
	     end if;  
	     end if;
    end if;
end;
/
