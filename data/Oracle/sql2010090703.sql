create or replace  PROCEDURE CRM_ShareByHrm_WorkPlan_new1 (m_workid integer)
AS 
stype_0 integer;
seclevel_0 integer;
userid_0 integer;
department_0 integer;
sql_0 varchar2(4000);
crmids_0  varchar2(1000);
crmid_0 varchar2(10);
begin
	sql_0:='where  1=2 ';
	for tempcur in (select crmid from workplan where type_n='3' and id=m_workid)
	loop 
	crmids_0 := tempcur.crmid;
	if crmids_0 is not null then
		delete from WorkPlanShareDetail where workid=m_workid and sharelevel=0;
		WHILE (instr(crmids_0,',') > 0 )
		loop
			crmid_0:=SUBSTR(crmids_0,1,instr(crmids_0,',')-1);
			crmids_0:=SUBSTR(crmids_0,instr(crmids_0,',')+1,LENGTH(crmids_0));
			if crmid_0>0 then
			   for all_cursorcrm in (SELECT sharetype,seclevel,userid,departmentid FROM crm_shareinfo WHERE  relateditemid=crmid_0)
			   loop
			   	   stype_0:=all_cursorcrm.sharetype;
				   seclevel_0:=all_cursorcrm.seclevel;
				   userid_0:=all_cursorcrm.userid;
				   department_0:=all_cursorcrm.departmentid;
				   if stype_0=1 then
				   	  	sql_0:=sql_0||' or (id='||userid_0||') ';
					  else if stype_0=2 then
						   sql_0:=sql_0||' or (departmentid='||department_0||' and  seclevel<='||seclevel_0||') ' ;
						else if stype_0=4 then
							 sql_0:=sql_0||' or (seclevel<='||seclevel_0||')';
						end if;
					end if;
				   end if;
			   end loop;
			end if;
		end loop;
		
		if instr(crmids_0,',') <=0 then
		   crmid_0 := crmids_0;
		   if crmid_0>0 then
		   	  for all_cursorcrm in (SELECT sharetype,seclevel,userid,departmentid FROM crm_shareinfo WHERE  relateditemid=crmid_0)
			  loop
			  	  stype_0:=all_cursorcrm.sharetype;
				  seclevel_0:=all_cursorcrm.seclevel;
				  userid_0:=all_cursorcrm.userid;
				  department_0:=all_cursorcrm.departmentid;
				  if stype_0=1 then
				   	  	sql_0:=sql_0||' or (id='||userid_0||') ';
					  else if stype_0=2 then
						   sql_0:=sql_0||' or (departmentid='||department_0||' and  seclevel<='||seclevel_0||') ' ;
						else if stype_0=4 then
							 sql_0:=sql_0||' or (seclevel<='||seclevel_0||')';
						end if;
					end if;
				  end if;
			  end loop;
		   end if;
		end if;
	end if;
	end loop;
	sql_0 := 'insert into workplansharedetail (workid,userid,usertype,sharelevel) select '||m_workid||', id,1,0 from hrmresource  '||sql_0||' union select '||m_workid||',resourceid,1,0 from hrmrolemembers where roleid=8 ';
	EXECUTE IMMEDIATE sql_0;
end;
/

declare
docMax integer;
i integer;
pagesize integer;
pagenum integer;
planid integer;
begin 

i:=1;
pagesize:=1000;
select max(id) into docMax from WorkPlan ;
pagenum:=docMax/pagesize+1;

if pagenum=0 then
pagenum:=1;
end if; 

WHILE i<=pagenum
loop
	for initplan_cursor in (select id from workplan where id>=(i-1)*pagesize and id<i*pagesize) 
	loop
		planid := initplan_cursor.id;
		CRM_ShareByHrm_WorkPlan_new1 (planid) ;
	end loop;
	i:=i+1;
end loop;

end; 
/

drop PROCEDURE CRM_ShareByHrm_WorkPlan_new1
/