
CREATE or REPLACE procedure currentoperator_mutidel
as
workflowtype_1 integer;
workflowid_1 integer;
requestid_1 integer;
groupid_1 integer;
userid_1 integer;

begin

for all_cursor in
(select workflowtype,workflowid,requestid,groupid,userid from workflow_currentoperator 
where isremark = '2' and groupid != 0 
group by workflowtype,workflowid,requestid,groupid,userid having count(*) > 1 )

loop
    workflowtype_1 := all_cursor.workflowtype ;
    workflowid_1 := all_cursor.workflowid ;
    requestid_1 := all_cursor.requestid ;
    groupid_1 := all_cursor.groupid ;
    userid_1 := all_cursor.userid ;

    
    delete workflow_currentoperator where requestid = requestid_1 and  groupid = groupid_1 
    and  userid = userid_1 and isremark = '2' and  groupid != 0 ;

    insert into workflow_currentoperator (requestid,userid,groupid,workflowid,workflowtype,usertype,isremark) 
	values (requestid_1 , userid_1 , groupid_1,workflowid_1,workflowtype_1,0 , '2' );    
end loop;
end;
/

call currentoperator_mutidel()
/

drop procedure currentoperator_mutidel
/


drop  INDEX wrkcuoper_user_in 
/


create  INDEX docReadTag_user_in on docReadTag(userid,userType) 
/

CREATE INDEX DOCSHAREDETAIL_USER_IN ON DOCSHAREDETAIL(USERID,USERTYPE)
/

delete DOCSHAREDETAIL where userid in (select id from hrmresource where loginid='' or loginid is null )
/

