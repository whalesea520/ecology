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


update workflow_currentoperator set isremark='4' where requestid in(select requestid from workflow_requestbase where currentnodetype='3') and isremark='0'
/
INSERT INTO HtmlLabelIndex values(18420,'只允许复制具体的菜单项') 
/
INSERT INTO HtmlLabelInfo VALUES(18420,'只允许复制具体的菜单项',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18420,'you must select one menu',8) 
/
INSERT INTO HtmlLabelIndex values(18421,'是否复制到自定义分类') 
/
INSERT INTO HtmlLabelInfo VALUES(18421,'是否复制到自定义分类',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18421,'Do you copy this menu to custom menu category',8) 
/

update MainMenuInfo set linkaddress='/fna/report/budget/FnaBudgetDepartment.jsp' where id=246
/