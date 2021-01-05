INSERT INTO HtmlLabelIndex values(18002,'接收时间') 
/
INSERT INTO HtmlLabelIndex values(18003,'停留时间') 
/
INSERT INTO HtmlLabelIndex values(18008,'办结时间') 
/
INSERT INTO HtmlLabelIndex values(18006,'已查看') 
/
INSERT INTO HtmlLabelIndex values(18007,'未查看') 
/
INSERT INTO HtmlLabelInfo VALUES(18002,'接收时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18002,'receive time',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18003,'停留时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18003,'operate time',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18006,'已查看',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18006,'viewed',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18007,'未查看',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18007,'no view',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18008,'办结时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18008,'opetating time',8) 
/

ALTER TABLE workflow_currentoperator ADD operatedate char(10)
/
ALTER TABLE workflow_currentoperator ADD operatetime char(8)
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
	     and requestid=requestid_1
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
		     and requestid=requestid_1
		     order by a.id;
	     else 
              viewnodeids:=trim(viewnodeids);
              viewnodeids:=substr(viewnodeids,1,length(viewnodeids)-1);
              open thecursor for
		     select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid,
		     a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime
		     from workflow_currentoperator a,workflow_nodebase b
		     where a.nodeid=b.id
		     and requestid=requestid_1 
		     order by a.id;
	     end if;    
    end if;
end;
/

CREATE or REPLACE PROCEDURE workflow_CurOpe_UpdatebyReject 
(requestid_1 integer,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mm:ss') into currenttime from dual;

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
select to_char(sysdate,'hh24:mm:ss') into currenttime from dual;

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
select to_char(sysdate,'hh24:mm:ss') into currenttime from dual;

update workflow_currentoperator set operatedate=currentdate,operatetime=currenttime 
where requestid =requestid_1 and userid =userid_1 and isremark in(0,4) and operatedate is null;

end;
/

CREATE or REPLACE PROCEDURE workflow_CurOpe_UbyForward 
(requestid_1 integer,userid_1 integer,usertype_1 integer,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mm:ss') into currenttime from dual;

update workflow_currentoperator set isremark=2,operatedate=currentdate,operatetime=currenttime 
where requestid =requestid_1 and userid =userid_1 and usertype=usertype_1 and isremark=1;

end;
/

