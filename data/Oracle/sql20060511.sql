CREATE or REPLACE PROCEDURE workflow_requeststatus_Select 
(userid_1 integer,
requestid_1 integer,
workflowid_1 integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
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
      ,orderdate
      ,ordertime
      ,iscomplete
 
      ,operatedate
      ,operatetime
  FROM workflow_currentoperator  where requestid = requestid_1 ) a,workflow_nodebase b
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
      ,orderdate
      ,ordertime
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
      ,orderdate
      ,ordertime
      ,iscomplete
 
      ,operatedate
      ,operatetime
  FROM workflow_currentoperator  where requestid = requestid_1 ) a,workflow_nodebase b
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
      ,orderdate
      ,ordertime
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

delete from ShareinnerDoc where ShareinnerDoc.id<(select max(b.id) from ShareinnerDoc b where 
                ShareinnerDoc.sourceid=b.sourceid and ShareinnerDoc.type=b.type and 
                ShareinnerDoc.content=b.content and ShareinnerDoc.srcfrom=b.srcfrom and ShareinnerDoc.opuser=b.opuser 
                and ShareinnerDoc.sharelevel=b.sharelevel) and ShareinnerDoc.type=1
/

delete from ShareinnerDoc where ShareinnerDoc.sharelevel<(select max(b.sharelevel) from ShareinnerDoc b where 
                ShareinnerDoc.sourceid=b.sourceid and ShareinnerDoc.type=b.type and 
                ShareinnerDoc.content=b.content and ShareinnerDoc.srcfrom=b.srcfrom and ShareinnerDoc.opuser=b.opuser 
                ) and ShareinnerDoc.type=1
/

delete from ShareinnerDoc where ShareinnerDoc.id<(select max(b.id) from ShareinnerDoc b where 
                ShareinnerDoc.sourceid=b.sourceid and ShareinnerDoc.type=b.type and 
                ShareinnerDoc.content=b.content and ShareinnerDoc.srcfrom=b.srcfrom and ShareinnerDoc.opuser=b.opuser 
                and ShareinnerDoc.sharelevel=b.sharelevel) and ShareinnerDoc.type!=1
/

delete from ShareinnerDoc where ShareinnerDoc.sharelevel<(select max(b.sharelevel) from ShareinnerDoc b where 
                ShareinnerDoc.sourceid=b.sourceid and ShareinnerDoc.type=b.type and 
                ShareinnerDoc.content=b.content and ShareinnerDoc.srcfrom=b.srcfrom and ShareinnerDoc.opuser=b.opuser 
                ) and ShareinnerDoc.type!=1
/


delete from ShareouterDoc where ShareouterDoc.id<(select max(b.id) from ShareouterDoc b where 
                ShareouterDoc.sourceid=b.sourceid and ShareouterDoc.type=b.type and 
                ShareouterDoc.content=b.content and ShareouterDoc.srcfrom=b.srcfrom and ShareouterDoc.opuser=b.opuser 
                and ShareouterDoc.sharelevel=b.sharelevel) and ShareouterDoc.type=9
/
delete from ShareouterDoc where ShareouterDoc.sharelevel<(select max(b.sharelevel) from ShareouterDoc b where 
                ShareouterDoc.sourceid=b.sourceid and ShareouterDoc.type=b.type and 
                ShareouterDoc.content=b.content and ShareouterDoc.srcfrom=b.srcfrom and ShareouterDoc.opuser=b.opuser 
                ) and ShareouterDoc.type=9
/

delete from ShareouterDoc where ShareouterDoc.id<(select max(b.id) from ShareouterDoc b where 
                ShareouterDoc.sourceid=b.sourceid and ShareouterDoc.type=b.type and 
                ShareouterDoc.content=b.content and ShareouterDoc.srcfrom=b.srcfrom and ShareouterDoc.opuser=b.opuser 
                and ShareouterDoc.sharelevel=b.sharelevel) and ShareouterDoc.type!=10
/

delete from ShareouterDoc where ShareouterDoc.sharelevel<(select max(b.sharelevel) from ShareouterDoc b where 
                ShareouterDoc.sourceid=b.sourceid and ShareouterDoc.type=b.type and 
                ShareouterDoc.content=b.content and ShareouterDoc.srcfrom=b.srcfrom and ShareouterDoc.opuser=b.opuser 
                ) and ShareouterDoc.type!=10
/

delete from ShareinnerDoc where (sourceid<=0 or content<=0)
/
delete from ShareouterDoc where (sourceid<=0 or content<=0)
/ 
delete from docdetail where (id<=0)
/ 
delete from docshare  where (docid<=0)
/ 
delete from docshare  where (sharetype=0)
/ 