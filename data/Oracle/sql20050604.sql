CREATE or REPLACE procedure wrkcrt_mutidel
(flag	out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 )
as
requestid_1 integer;
userid_1 integer;
isremark_1 integer;
isremark_2 integer;
groupid_1 integer;
workflowid_1 integer;
workflowtype_1 integer;

begin

delete from workflow_requestViewLog where concat(concat(to_char(id),','), to_char(currentnodeid)) in 
( select concat(concat(to_char(a.id),','), to_char(a.currentnodeid)) from 
  workflow_requestViewLog a, workflow_requestbase b
  where a.currentnodeid != b.currentnodeid and a.id = b.requestid ) ;

delete from workflow_currentoperator where userid in (select id from hrmresource where 
loginid is null) and usertype = 0 ;

delete from DocShareDetail where userid in(select id from hrmresource where 
loginid is null) and usertype = 1;

for all_cursor in
(select requestid, userid ,usertype , min(to_number(isremark)) isremark,max(to_number(isremark)) maxisremark from workflow_currentoperator 
group by requestid, userid,usertype having count(requestid) > 1  )

loop
    requestid_1 := all_cursor.requestid ;
    userid_1 := all_cursor.userid ;
    isremark_1 := all_cursor.isremark ;
    select min(groupid) , min(workflowid) ,min(workflowtype) into groupid_1, workflowid_1 , workflowtype_1 
    from workflow_currentoperator  
    where requestid = requestid_1 and  userid = userid_1 and to_number(isremark) = isremark_1;

    delete workflow_currentoperator where  requestid = requestid_1 and  userid = userid_1 and isremark<>4;
    if(isremark_2<4)then
    insert into workflow_currentoperator (requestid,userid,usertype,isremark,groupid,workflowid,workflowtype) 
	values (requestid_1 , userid_1 , 0 , to_char(isremark_1),groupid_1 ,workflowid_1, workflowtype_1);    
    end if;
end loop;
end;
/


/*真正删除所有原来用户删除的请求*/
delete workflow_currentoperator where requestid in (select requestid from workflow_requestbase where deleted=1) 
/
delete workflow_form where requestid in (select requestid from workflow_requestbase where deleted=1) 
/
delete workflow_requestLog where requestid in (select requestid from workflow_requestbase where deleted=1 ) 
/
delete workflow_requestViewLog where id in (select requestid from workflow_requestbase where deleted=1) 
/
delete workflow_requestbase where deleted=1
/



/*处理掉归档的操作人状态，改为4即代表操作人能查看的流程是规档的,历史操作人的isremark='2'记录保留*/
update  workflow_currentoperator  set isremark='4'  
where  requestid in (select requestid  from workflow_requestbase where currentnodetype = '3' )
and isremark='0'
/

/*删除掉在workflow_currentoperator中有但在workflow_requestbase里没有的requestid，在转换为oracle时请慎重*/
delete workflow_currentoperator where requestid in (select t2.requestid
from  workflow_requestbase t1 right join workflow_currentoperator t2 on t1.requestid=t2.requestid
where t1.requestid is null)
/