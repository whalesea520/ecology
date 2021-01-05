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

delete from DocShareDetail where userid in(select id from hrmresource where 
loginid is null) and usertype = 1;

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