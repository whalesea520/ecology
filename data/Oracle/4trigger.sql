
create or REPLACE TRIGGER Tri_U_CptCapitalAssortment
after update ON CptCapitalAssortment 
FOR each row
when(new.assortmentmark<>'' or new.assortmentmark <> null)
Declare groupid_1 integer ;
	    supassortmentid_1 integer ;
	    oldmark_1	 varchar2(60) ;
	    newmark_1	 varchar2(60) ;
		supmark_1	 varchar2(60) ;
		tempstr_1	 varchar2(60) ;
begin
	groupid_1 := :old.id ;
	oldmark_1 := :old.assortmentmark ;
	
    for tmp_cursor in ( select distinct assortmentmark,supassortmentid from CptCapitalAssortment where id = groupid_1 )
    loop
	    if tmp_cursor.supassortmentid = 0 then
	        exit ;
	    end if ;
	    
	    select assortmentmark,supassortmentid into supmark_1,supassortmentid_1 from CptCapitalAssortment where id = tmp_cursor.supassortmentid ;
	    newmark_1 := supmark_1 + newmark_1 ;
	    oldmark_1 := supmark_1 + oldmark_1 ;    
    end loop ;
    
    tempstr_1 := '%|' + to_char(groupid_1) + '|%' ;
    update CptCapital set mark = newmark_1+substr(mark,length(oldmark_1)+1) 
	where (capitalgroupid=groupid_1 or capitalgroupid in (select id from CptCapitalAssortment where supassortmentstr like tempstr_1)) and  counttype is null ;
	
	update CptCapital set mark = substr(mark,1,2)+newmark_1+substr(mark,length(oldmark_1)+1) 
	where (capitalgroupid=groupid_1 or capitalgroupid in (select id from CptCapitalAssortment where supassortmentstr like tempstr_1 )) and ( counttype = '1' or counttype = '2') ;
end ;
/

CREATE or REPLACE TRIGGER Tri_Update_bill_HrmTime 
after update ON Prj_TaskProcess 
FOR each row
when (new.isactived=2)
Declare 
    prjid_1 integer ;
 	taskid_1 integer ;
 	subject_1 varchar2(80);
 	isactived_1	    integer ;
 	begindate_1     char(10);
 	enddate_1	    char(10) ;
 	resourceid_1    integer ;
 	tmpcount_1	    integer ;
 	tmpbegindate_1   char(10);
 	tmpenddate_1    char(10);
    tmpid_1       integer ;
begin
	prjid_1:=:old.prjid ;
	select name into subject_1 from prj_projectinfo where id=prjid_1 ;
	
	tmpbegindate_1:= '' ;
	tmpenddate_1:= '' ;
	begindate_1:=:new.begindate ;
	enddate_1:=:new.enddate ;
    if ( begindate_1 !='x' or enddate_1 != '-' ) and :new.isdelete <> 1 then
	    resourceid_1:=:new.hrmid ;
	    if begindate_1 = 'x' then
	        begindate_1:=enddate_1 ;
	    end if ;
	    if enddate_1 = '-' then
	        enddate_1:=begindate_1 ;
	    end if ;
	    
	    select count(id) into tmpcount_1 from bill_hrmtime
	    where resourceid=resourceid_1 and requestid=prjid_1 and basictype=1 ;
	    
	    if tmpcount_1 > 0 then
	        select id,begindate,enddate into tmpid_1,tmpbegindate_1,tmpenddate_1 from bill_hrmtime 
    	    where resourceid=resourceid_1 and requestid=prjid_1 and basictype=1 ;
    	    
    	    if tmpbegindate_1 > begindate_1 then
    	        tmpbegindate_1:=begindate_1 ;
    	    end if ;
    	    
    	    if tmpenddate_1 < enddate_1 then
    	        tmpenddate_1:=enddate_1 ;
    	    end if ;
    	    update bill_hrmtime set begindate=tmpbegindate_1 ,enddate=tmpenddate_1 where id=tmpid_1 ;
	    else 
	        if tmpcount_1 = 0 then
	        insert into bill_hrmtime (resourceid,basictype,detailtype,requestid,name,begindate,enddate,status,accepterid)
		    values (resourceid_1,1,1,prjid_1,subject_1,begindate_1,enddate_1,'0',to_char(resourceid_1)) ;
		    end if ;
	    end if ;
    end if ;
end ;
/

CREATE or REPLACE TRIGGER Tri_U_bill_HrmTimeByMeet1 
after update ON Meeting 
FOR each row
when(new.isapproved=3)
Declare 
 	name_1          varchar2(80) ;
 	isapproved_1    integer ;
 	begindate_1	    char(10) ;
 	begintime_1     char(8) ;
 	enddate_1       char(10) ;
 	endtime_1       char(8) ;
 	resourceid_1    integer ;
 	meetingid_1     integer ;
 	caller_1        integer ;
 	contacter_1     integer ;
	tmpcount_1      integer ;
begin
    meetingid_1 := :new.id ;
	begindate_1 := :new.begindate ;
	enddate_1 := :new.enddate ;
	begintime_1 := :new.begintime ;
	endtime_1 := :new.endtime ;
	name_1 := :new.name ;
	caller_1 := :new.caller ;
	contacter_1 := :new.contacter ;
	
	delete from bill_hrmtime where requestid=meetingid_1 and basictype=5 and detailtype=1 ;
	
    insert into bill_hrmtime (resourceid,requestid,basictype,detailtype,name,begindate,begintime,enddate,endtime,status,accepterid)
    values (caller_1,meetingid_1,5,1,name_1,begindate_1,begintime_1,enddate_1,endtime_1,'0',to_char(caller_1)) ;
    
    insert into bill_hrmtime (resourceid,requestid,basictype,detailtype,name,begindate,begintime,enddate,endtime,status,accepterid)
    values (contacter_1,meetingid_1,5,1,name_1,begindate_1,begintime_1,enddate_1,endtime_1,'0',to_char(contacter_1)) ;
    
    for tmp_cursor in ( select memberid from Meeting_Member2 where meetingid=meetingid_1 and membertype = 1 )
    loop
        resourceid_1 := tmp_cursor.memberid ;
        insert into bill_hrmtime (resourceid,requestid,basictype,detailtype,name,begindate,begintime,enddate,endtime,status,accepterid)
        values (resourceid_1,meetingid_1,5,1,name_1,begindate_1,begintime_1,enddate_1,endtime_1,'0',to_char(resourceid_1)) ;
    end loop ;
end ;
/

CREATE or REPLACE TRIGGER Tri_U_bill_HrmTimeByMeet2
after update ON Meeting_Member2 
FOR each row
when(new.othermember<>'' or new.othermember <> null )
Declare 
    recordid_1   integer ;
 	name_1       varchar2(80) ;
 	begindate_1	 char(10) ;
 	begintime_1  char(8) ;
 	enddate_1    char(10) ;
 	endtime_1    char(8) ;
 	meetingid_1     integer ;
 	othermember_1     varchar2(255) ;
 	tmpcount_1     integer ;
 	tmpid_1        integer ;
begin
    recordid_1 := :new.id ;
    meetingid_1 := :new.meetingid ;
    othermember_1 := :new.othermember ;
    select name,begindate,enddate,begintime,endtime into name_1,begindate_1,enddate_1,begintime_1,endtime_1 from meeting where id=meetingid_1 ;
    
    select count(id) into tmpcount_1 from bill_hrmtime where requestid=meetingid_1 and billid=recordid_1 and basictype=5 and detailtype=1 ;
    if tmpcount_1 = 0 then
        insert into bill_hrmtime (billid,resourceid,requestid,basictype,detailtype,name,begindate,begintime,enddate,endtime,status,accepterid)
        values (recordid_1,0,meetingid_1,5,1,name_1,begindate_1,begintime_1,enddate_1,endtime_1,'0',othermember_1) ;
    else 
        if tmpcount_1 > 0 then
        select id into tmpid_1 from bill_hrmtime where requestid=meetingid_1 and billid=recordid_1 and basictype=5 and detailtype=1 ;
        update bill_hrmtime set accepterid=othermember_1,begindate=begindate_1,enddate=enddate_1,begintime=begintime_1,endtime=endtime_1 where id=tmpid_1 ;
        end if ;
    end if ;
end ;
/

CREATE or REPLACE TRIGGER Tri_U_workflow_createlist
after insert or update or delete ON HrmResource
for each row
Declare 
    workflowid_1 integer ;
	type_1 integer ;
 	objid_1 integer ;
	level_1 integer ;
	userid_1 integer ;
begin 
    delete from workflow_createrlist ;
    for tmp_cursor in ( select workflowid,type,objid,level from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid=t2.nodeid and t2.id = t3.groupid )
    loop
        workflowid_1 := tmp_cursor.workflowid ;
        type_1 := tmp_cursor.type ;
        objid_1 := tmp_cursor.objid ;
        level_1 := tmp_cursor.level ;
        
        if type_1 = 1 then
            for tmp_cursor2 in ( select id from HrmResource where departmentid = objid_1 and seclevel >= level_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'0') ;
            end loop ;
        end if ;

        if type_1 = 2 then
            for tmp_cursor2 in ( SELECT resourceid as id FROM HrmRoleMembers where roleid =  objid_1 and rolelevel >=level_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'0') ;
            end loop ;
        end if ;
        
        if type_1 = 3 then
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,objid_1,'0');
        end if ;
        
        if type_1 = 4 then
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,-1,level_1);
        end if ;
        
        if type_1 = 20 then
            for tmp_cursor2 in ( select id  from CRM_CustomerInfo where  seclevel >= level_1 and type = objid_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'1') ;
            end loop ;
        end if ;
        
        if type_1 = 21 then
            for tmp_cursor2 in ( select id  from CRM_CustomerInfo where  seclevel >= level_1 and status = objid_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'1') ;
            end loop ;
        end if ;
        
        if type_1 = 22 then
            for tmp_cursor2 in ( select id  from CRM_CustomerInfo where  seclevel >= level_1 and department = objid_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'1') ;
            end loop ;
        end if ;
        
        if type_1 = 25 then
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,-2,level_1);
        end if ;

	if type_1 = 30 then
            for tmp_cursor2 in ( select id from HrmResource where subcompanyid1 = objid_1 and seclevel >= level_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'0') ;
            end loop ;
        end if ;

    end loop ;
end ;
/

CREATE or REPLACE TRIGGER Tri_URole_workflow_createlist
after insert or update or delete ON HrmRoleMembers
for each row
Declare 
    workflowid_1 integer ;
	type_1 integer ;
 	objid_1 integer ;
	level_1 integer ;
	userid_1 integer ;
begin
    delete from workflow_createrlist ;
    for tmp_cursor in ( select workflowid,type,objid,level from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid=t2.nodeid and t2.id = t3.groupid )
    loop
        workflowid_1 := tmp_cursor.workflowid ;
        type_1 := tmp_cursor.type ;
        objid_1 := tmp_cursor.objid ;
        level_1 := tmp_cursor.level ;
        
        if type_1 = 1 then
            for tmp_cursor2 in ( select id from HrmResource where departmentid = objid_1 and seclevel >= level_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'0') ;
            end loop ;
        end if ;
        
        if type_1 = 2 then
            for tmp_cursor2 in ( SELECT resourceid as id FROM HrmRoleMembers where roleid =  objid_1 and rolelevel >=level_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'0') ;
            end loop ;
        end if ;
        
        if type_1 = 3 then
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,objid_1,'0');
        end if ;
        
        if type_1 = 4 then
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,-1,level_1);
        end if ;
        
        if type_1 = 20 then
            for tmp_cursor2 in ( select id  from CRM_CustomerInfo where  seclevel >= level_1 and type = objid_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'1') ;
            end loop ;
        end if ;
        
        if type_1 = 21 then
            for tmp_cursor2 in ( select id  from CRM_CustomerInfo where  seclevel >= level_1 and status = objid_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'1') ;
            end loop ;
        end if ;
        
        if type_1 = 22 then
            for tmp_cursor2 in ( select id  from CRM_CustomerInfo where  seclevel >= level_1 and department = objid_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'1') ;
            end loop ;
        end if ;
        
        if type_1 = 25 then
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,-2,level_1);
        end if ;

	if type_1 = 30 then
            for tmp_cursor2 in ( select id from HrmResource where subcompanyid1 = objid_1 and seclevel >= level_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'0') ;
            end loop ;
        end if ;


    end loop ;
end ;
/

CREATE or REPLACE TRIGGER Tri_UCRM_workflow_createlist
after insert or update or delete ON CRM_CustomerInfo
for each row
Declare 
    workflowid_1 integer ;
	type_1 integer ;
 	objid_1 integer ;
	level_1 integer ;
	userid_1 integer ;
begin
    delete from workflow_createrlist ;
    for tmp_cursor in ( select workflowid,type,objid,level from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid=t2.nodeid and t2.id = t3.groupid )
    loop
        workflowid_1 := tmp_cursor.workflowid ;
        type_1 := tmp_cursor.type ;
        objid_1 := tmp_cursor.objid ;
        level_1 := tmp_cursor.level ;
        
        if type_1 = 1 then
            for tmp_cursor2 in ( select id from HrmResource where departmentid = objid_1 and seclevel >= level_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'0') ;
            end loop ;
        end if ;
        
        if type_1 = 2 then
            for tmp_cursor2 in ( SELECT resourceid as id FROM HrmRoleMembers where roleid =  objid_1 and rolelevel >=level_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'0') ;
            end loop ;
        end if ;
        
        if type_1 = 3 then
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,objid_1,'0');
        end if ;
        
        if type_1 = 4 then
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,-1,level_1);
        end if ;
        
        if type_1 = 20 then
            for tmp_cursor2 in ( select id  from CRM_CustomerInfo where  seclevel >= level_1 and type = objid_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'1') ;
            end loop ;
        end if ;
        
        if type_1 = 21 then
            for tmp_cursor2 in ( select id  from CRM_CustomerInfo where  seclevel >= level_1 and status = objid_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'1') ;
            end loop ;
        end if ;
        
        if type_1 = 22 then
            for tmp_cursor2 in ( select id  from CRM_CustomerInfo where  seclevel >= level_1 and department = objid_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'1') ;
            end loop ;
        end if ;
        
        if type_1 = 25 then
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,-2,level_1);
        end if ;

	if type_1 = 30 then
            for tmp_cursor2 in ( select id from HrmResource where subcompanyid1 = objid_1 and seclevel >= level_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'0') ;
            end loop ;
        end if ;


    end loop ;
end ;
/


