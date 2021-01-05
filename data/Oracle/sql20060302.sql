create table workflow_function_manage (
workflowid integer ,
typeview    char(1) ,
dataview   char(1),
automatism char(1),
manual char(1),
transmit char(1),
retract char(1),
pigeonhole char(1),
operatortype integer
)
/

INSERT INTO HtmlLabelIndex values(18357,'自动催办') 
/
INSERT INTO HtmlLabelIndex values(18359,'强制收回') 
/
INSERT INTO HtmlLabelIndex values(18360,'强制归档') 
/
INSERT INTO HtmlLabelIndex values(18358,'手动催办') 
/
INSERT INTO HtmlLabelInfo VALUES(18357,'自动催办',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18357,'automatism urgency',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18358,'手动催办',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18358,'manual',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18359,'强制收回',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18359,'compellent retract',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18360,'强制归档',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18360,'compellent over',8) 
/
INSERT INTO HtmlLabelIndex values(18361,'功能管理') 
/
INSERT INTO HtmlLabelInfo VALUES(18361,'功能管理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18361,'function manage',8) 
/

INSERT INTO HtmlLabelIndex values(18365,'查看前收回') 
/
INSERT INTO HtmlLabelIndex values(18364,'不可收回') 
/
INSERT INTO HtmlLabelIndex values(18366,'查看后收回') 
/
INSERT INTO HtmlLabelInfo VALUES(18364,'不可收回',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18364,'cann''t draw back',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18365,'查看前收回',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18365,'draw back before view',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18366,'查看后收回',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18366,'draw back after viewing',8) 
/
INSERT INTO HtmlLabelIndex values(18095,'启用') 
/
INSERT INTO HtmlLabelInfo VALUES(18095,'启用',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18095,'OPEN',8) 
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
	     a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime
	     from workflow_currentoperator a,workflow_nodebase b
	     where a.nodeid=b.id
	     and requestid=requestid_1 and a.agenttype<>1
	     order by a.id;
  
    else 
	     
         viewnodeids:='';
         for c1 in(
	     select b.viewnodeids 
	     from workflow_currentoperator a,workflow_flownode b
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
		     a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime
		     from workflow_currentoperator a,workflow_nodebase b
		     where a.nodeid=b.id
		     and requestid=requestid_1 and a.agenttype<>1
		     order by a.id;
	     else 
              viewnodeids:=trim(viewnodeids);
              viewnodeids:=substr(viewnodeids,1,length(viewnodeids)-1);
              open thecursor for
		     select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid,
		     a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime
		     from workflow_currentoperator a,workflow_nodebase b
		     where a.nodeid=b.id
		     and requestid=requestid_1 and a.agenttype<>1
		     order by a.id;
	     end if;    
    end if;
end;
/

