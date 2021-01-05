create or replace PROCEDURE Share_forcrm_init(
    crmid integer 
)
AS 
managerid integer;
managerstr varchar2(2000);
tempmanagerid integer;
begin
    managerid:=0;
    managerstr:='';
    tempmanagerid:=0;
    /*删除原来的的默认共享*/
    delete  from CRM_ShareInfo where isdefault='1' and relateditemid=crmid;
    /*共享给客户经理*/
    select manager into managerid from CRM_CustomerInfo where id=crmid;
    if (managerid<>0 and managerid is not null) then
        /*insert into CRM_ShareInfo (relateditemid,sharetype,seclevel,sharelevel,crmid,isdefault,userid) values (crmid,1,0,2,0,1,managerid);*/
        /*共享给所有上级*/
        select managerstr into managerstr from hrmresource where id=managerid;
        if (managerstr<>'' and managerstr is not null) then
            for hrmid_cursor in (select id from hrmresource where id in(','||managerstr) and id!=managerid)
            loop
                tempmanagerid:=hrmid_cursor.id;
                insert into CRM_ShareInfo (relateditemid,sharetype,seclevel,sharelevel,crmid,isdefault,userid) values (crmid,1,0,3,0,1,tempmanagerid);
            end loop;
        end if;
     end if;
     /*共享给客户管理员角色*/
     /*insert into CRM_ShareInfo (relateditemid,sharetype,seclevel,rolelevel,sharelevel,roleid,crmid,isdefault) values (crmid,3,0,2,4,8,0,1);*/
end; 
/

insert into CRM_ShareInfo (relateditemid,sharetype,seclevel,sharelevel,crmid,isdefault,userid) select id,1,0,2,0,1,manager from crm_customerinfo
/
insert into CRM_ShareInfo (relateditemid,sharetype,seclevel,rolelevel,sharelevel,roleid,crmid,isdefault) select id,3,0,0,4,8,0,1 from crm_customerinfo
/
insert into CRM_ShareInfo (relateditemid,sharetype,seclevel,rolelevel,sharelevel,roleid,crmid,isdefault) select id,3,0,1,4,8,0,1 from crm_customerinfo
/
insert into CRM_ShareInfo (relateditemid,sharetype,seclevel,rolelevel,sharelevel,roleid,crmid,isdefault) select id,3,0,2,4,8,0,1 from crm_customerinfo
/
alter table CRM_ShareInfo add deptorcomid integer
/
update crm_shareinfo set deptorcomid=(select departmentid from hrmresource where id=(select manager from crm_customerinfo where id=relateditemid))  where   sharetype=3 and rolelevel=0
/
update crm_shareinfo set deptorcomid=(select subcompanyid1 from hrmresource where id=(select manager from crm_customerinfo where id=relateditemid))  where   sharetype=3 and rolelevel=1
/

create or replace PROCEDURE CrmShareInitMain
AS
crmMax integer;
tempcount integer;
i integer;
pagesize integer;
pagenum integer;
crmid integer;
begin
	i:=1;
	pagesize:=500;
	select count(*) into tempcount from crm_customerinfo;
	if tempcount>0 then
	select max(id) into crmMax from crm_customerinfo;
	pagenum:=crmMax/pagesize;
	if pagenum=0 then
		pagenum:=1;
	end if; 
	if crmMax>pagenum*pagesize then
		pagenum:=pagenum+1;
	end if;
	 
	for i in 1 .. pagenum loop
		for initcrmid_cursor in (select id from crm_customerinfo where id>=(i-1)*pagesize and id<=i*pagesize)
		loop
			crmid:=initcrmid_cursor.id;
			execute immediate ('call Share_forcrm_init ('||crmid||')');
		end loop;
	end loop;
	end if;
end;
/

call CrmShareInitMain()
/

drop PROCEDURE CrmShareInitMain
/

drop PROCEDURE Share_forcrm_init
/


