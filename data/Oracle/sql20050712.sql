 CREATE OR REPLACE PROCEDURE workflow_CurrentOperator_I 
( requestid1	integer, userid1		integer, groupid1	in out integer, 
workflowid1	integer, workflowtype1	integer, usertype1	integer, isremark1	char  ,nodeid  integer,agentorbyagentid  integer,agenttype  char,showorder integer,
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin if groupid1 is null then groupid1 := 0 ; end if ; 
insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder) 
values(requestid1,userid1,groupid1, workflowid1,workflowtype1,usertype1,isremark1,nodeid,agentorbyagentid,agenttype,showorder); end;
/


CREATE OR REPLACE PROCEDURE workflow_RequestLog_Insert
( requestid1	integer, workflowid1	integer, nodeid1	integer,logtype1	char ,
operatedate1	char, operatetime1	char,operator1	integer, remark1	varchar2,
clientip1	char, operatortype1	integer,destnodeid1	integer, operate varchar2,
agentorbyagentid  integer,agenttype  char,showorder integer,
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor )
AS count1 integer;
begin

   if logtype1 = '1' then
               select  count(*) INTO  count1 from workflow_requestlog where requestid=requestid1 and nodeid=nodeid1 and logtype=logtype1 and operator = operator1 and operatortype = operatortype1;

               if count1 > 0 then
                      update workflow_requestlog SET	 operatedate	 = operatedate1, operatetime	 = operatetime1, remark	 = remark1, clientip	 = clientip1, destnodeid	 = destnodeid1
                      WHERE ( requestid	 = requestid1 AND nodeid	 = nodeid1 AND logtype	 = logtype1 AND operator	 = operator1 AND operatortype	 = operatortype1);

               else
                      insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder)
                      values(requestid1,workflowid1,nodeid1,logtype1, operatedate1,operatetime1,operator1, remark1,clientip1,operatortype1,destnodeid1,operate,agentorbyagentid,agenttype,showorder);
               end if;
   else


                  delete workflow_requestlog where requestid=requestid1 and nodeid=nodeid1 and (logtype='1') and operator = operator1 and operatortype = operatortype1;
                  insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder) values(requestid1,workflowid1,nodeid1,logtype1, operatedate1,operatetime1,operator1, remark1,clientip1,operatortype1,destnodeid1,operate,agentorbyagentid,agenttype,showorder);


   end if;

end;
/


 CREATE OR REPLACE PROCEDURE workflow_RequestViewLog_Insert 
( id1	integer, viewer1	integer, viewdate1	char , viewtime1	char , 
clientip1	char , viewtype1	integer, currentnodeid1	integer,ordertype char,showorder integer, 
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin 
insert into workflow_requestviewlog (id,viewer, viewdate,viewtime,ipaddress,viewtype,currentnodeid,ordertype,showorder) 
values(id1,viewer1, viewdate1,viewtime1,clientip1,viewtype1,currentnodeid1,ordertype,showorder); end;
/


 CREATE OR REPLACE PROCEDURE workflow_groupdetail_SByGroup 
(id_1 	integer, 	 flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
AS begin open thecursor for SELECT * FROM workflow_groupdetail WHERE ( groupid = id_1) order by id asc ; end;
/


CREATE or REPLACE procedure wrkcrt_mutidel
(flag	out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 )
as
requestid_1 integer;
userid_1 integer;
isremark_1 integer;
groupid_1 integer;
workflowid_1 integer;
workflowtype_1 integer;

begin

delete from workflow_requestViewLog where concat(concat(to_char(id),','), to_char(currentnodeid)) in 
( select concat(concat(to_char(a.id),','), to_char(a.currentnodeid)) from 
  workflow_requestViewLog a, workflow_requestbase b
  where a.currentnodeid != b.currentnodeid and a.id = b.requestid ) ;
/*
delete from workflow_currentoperator where userid in (select id from hrmresource where 
loginid is null) and usertype = 0 ;
*/
delete from DocShareDetail where userid in(select id from hrmresource where 
loginid is null) and usertype = 1;
/*
for all_cursor in
(select requestid, userid , min(to_number(isremark)) isremark from workflow_currentoperator 
group by requestid, userid having count(requestid) > 1  )

loop
    requestid_1 := all_cursor.requestid ;
    userid_1 := all_cursor.userid ;
    isremark_1 := all_cursor.isremark ;
    
    
    select min(groupid) , min(workflowid) ,min(workflowtype) into groupid_1, workflowid_1 , workflowtype_1 
    from workflow_currentoperator  
    where requestid = requestid_1 and  userid = userid_1 and to_number(isremark) = isremark_1  ;

    delete workflow_currentoperator where  requestid = requestid_1 and  userid = userid_1   ;

    insert into workflow_currentoperator (requestid,userid,usertype,isremark,groupid,workflowid,workflowtype) 
	values (requestid_1 , userid_1 , 0 , to_char(isremark_1),groupid_1 ,workflowid_1, workflowtype_1);    
end loop;
*/
end;
/




