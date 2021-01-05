CREATE or replace FUNCTION GetDocShareDetailTable 
(userid_1 varchar2,
usertype_2  varchar2)
RETURN table_DocShare
AS
seclevel_1 varchar2(10);
departmentid_2 varchar2(10);
subcompanyid_3 varchar2(10);
type_4 varchar2(10);
count_5 integer;
isSysadmin_1 integer;
DocShareDetail table_DocShare := table_DocShare();
BEGIN  
   if usertype_2 ='1'
   then
      select count(id) into count_5 from  hrmresource where id = userid_1;
	  if count_5 >0 then
	  select seclevel into seclevel_1 from hrmresource where id = userid_1;
	  select  departmentid into departmentid_2  from hrmresource where id = userid_1;
	  select subcompanyid1 into subcompanyid_3 from hrmresource where id = userid_1;
	  end if;
	  select count(*) into isSysadmin_1 from hrmresourcemanager where id = userid_1;
	  if isSysadmin_1=1 then
			SELECT obj_DocShare(sourceid,MAX(sharelevel)) bulk collect into DocShareDetail  from shareinnerdoc where 
			(type=1 and content= userid_1) or (  type=4 and content in 
			(select concat(to_char(roleid),to_char(rolelevel)) from hrmrolemembers where resourceid = userid_1) and seclevel <= seclevel_1) GROUP BY sourceid;
      else
        SELECT obj_DocShare(sourceid,MAX(sharelevel)) bulk collect into DocShareDetail from shareinnerdoc where (type=1 and content = userid_1) or  (type=2 and content = subcompanyid_3 and seclevel <= seclevel_1) or 
        (type=3 and content = departmentid_2 and seclevel <= seclevel_1) or (type=4 and content in 
        (select concat(to_char(roleid),to_char(rolelevel)) from hrmrolemembers where resourceid = userid_1) and seclevel <= seclevel_1) GROUP BY sourceid;
	  end if;
   else 
      select count(id) into count_5 from crm_customerinfo where id = userid_1;
      if count_5 >0 then
	  select type into type_4 from crm_customerinfo where id = userid_1;
		select seclevel into seclevel_1 from crm_customerinfo where id = userid_1;
		end if;
      SELECT obj_DocShare(sourceid,MAX(sharelevel)) bulk collect into DocShareDetail from shareouterdoc where (type=9 and content = userid_1) or (type=10 and content = type_4 and seclevel <= seclevel_1) GROUP BY sourceid;
   end if;
   RETURN DocShareDetail;
END;
/