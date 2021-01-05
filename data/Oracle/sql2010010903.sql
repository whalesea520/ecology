delete from workflow_createrlist where usertype=1 and userid<>-1
/
create or replace PROCEDURE updatecuscreatewf as
	workflowid_1 integer;
	type_1 integer;
	objid_1 integer;
	customerid_1 integer;
	usertype1_1 integer;
	usertype2_1 integer;
begin
	for groupdetail_cursor in (select f.workflowid,g.type,g.objid,g.level_n,g.level2_n from workflow_groupdetail g left join workflow_nodegroup n on n.id=g.groupid left join workflow_flownode f on f.nodeid=n.nodeid where g.type in (20,21,22,23,24,25) and f.nodetype='0' )
	loop
		workflowid_1 := groupdetail_cursor.workflowid;
		type_1 := groupdetail_cursor.type;
		objid_1 := groupdetail_cursor.objid;
		usertype1_1 := groupdetail_cursor.level_n;
		usertype2_1 := groupdetail_cursor.level2_n;
		if type_1=20 then
			insert into workflow_createrlist (workflowid, userid, usertype, usertype2)
			select workflowid_1, id, 1, 0 from CRM_CustomerInfo where seclevel >= usertype1_1 and seclevel <= usertype2_1 and type = objid_1;
		end if;
		if type_1=21 then
			insert into workflow_createrlist (workflowid, userid, usertype, usertype2)
			select workflowid_1, id, 1, 0 from CRM_CustomerInfo where  seclevel >= usertype1_1 and seclevel <= usertype2_1 and status = objid_1;
		end if;
		if type_1=22 then
			insert into workflow_createrlist (workflowid, userid, usertype, usertype2)
			select workflowid_1, id, 1, 0 from CRM_CustomerInfo where  seclevel >= usertype1_1 and seclevel <= usertype2_1 and department = objid_1;
		end if;
		if type_1=25 then
			insert into workflow_createrlist (workflowid, userid, usertype, usertype2)
			values (workflowid_1, -2, usertype1_1, usertype2_1);
		end if;
		
	end loop;
end;

/

call updatecuscreatewf()
/
drop PROCEDURE updatecuscreatewf 
/


