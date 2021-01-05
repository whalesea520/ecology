alter table DirAccessPermission rename to DirAccessPermission1
/
alter table DocUserDefault add  useUnselected varchar(10)
/
update DocUserDefault set useUnselected ='false'
/
create table DirAccessControlDetail (
      id int  NOT NULL , 
      sourceid int not null ,                   
      type int not null,                        
      content int not null,                     
      seclevel int not null,                    
      sharelevel int not null,                  
      sourcetype int not null,               
      srcfrom int not null               
)
/
create sequence DirAccessControlDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DirAccessControlDetail_Trigger
  before insert on DirAccessControlDetail
  for each row
begin
  select DirAccessControlDetail_id.nextval into :new.id from dual;
end;
/
CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermission
(
dirid_1 integer,
dirtype_1 integer,
userid_1 integer,
usertype_1 integer,
seclevel_1 integer, 
operationcode_1 integer, 
departmentid_1 integer,
subcompanyid_1 integer,
roleid_1 varchar2,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
AS
count_1 integer;
result integer;
count_num integer;
begin
result := 0;
if usertype_1 = 0 then
	select count (sourceid) into count_num  from DirAccessControlDetail where sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and to_char(content) in (roleid_1) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1));
        if(count_num >0) then
               count_1 := 1 ;
        else count_1 := 0 ;
        end if;    
else 
    select count(mainid) into count_1  from DirAccessControlList where dirid=dirid_1 and dirtype=dirtype_1 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1));
end if;

if (count_1 > 0)  then
     result := 1 ;
end if;
open thecursor for
select result result from dual;
end;
/
CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermissionEx (
 dirid_1 integer,
 dirtype_1 integer,
 userid_1 integer,
 usertype_1 integer,
 seclevel_1 integer,
 operationcode_1 integer,
departmentid_1 integer,
subcompanyid_1 integer,
roleid_1 varchar2,
 flag out integer  , msg  out varchar2, thecursor IN OUT cursor_define.weavercursor )
 AS
 result_1 integer; mainid_1 integer; fatherid_1 integer; fatherid1_1 integer;
 begin
Doc_DirAcl_CheckPermissionEx1 (dirid_1, dirtype_1, userid_1, usertype_1, seclevel_1, operationcode_1,departmentid_1, subcompanyid_1,roleid_1,result_1);
if result_1 <> 1  then
    if dirtype_1 = 1 then
        select  subcategoryid into fatherid_1 from DocSubCategory where id = dirid_1;
    elsif dirtype_1 = 2 then
        select  subcategoryid into fatherid_1 from DocSecCategory where id = dirid_1;
        if fatherid_1 is null then
            fatherid_1 := -1;
        end if;
        if fatherid_1 = 0  then
            fatherid_1 := -1;
        end if;
    else
	fatherid_1 := -1;
    end if;
     if dirtype_1 = 1 then
        select  maincategoryid into mainid_1 from DocSubCategory where id = dirid_1;
        Doc_DirAcl_CheckPermissionEx1 (mainid_1, 0, userid_1, usertype_1, seclevel_1, operationcode_1,departmentid_1, subcompanyid_1,roleid_1, result_1);
		if result_1=1 then     
			fatherid_1 := -1;     
		end if;
	elsif dirtype_1 = 2 and fatherid_1 <> -1 then
	    select  maincategoryid into mainid_1 from DocSubCategory where id = fatherid_1;
	    Doc_DirAcl_CheckPermissionEx1 (mainid_1, 0, userid_1, usertype_1, seclevel_1, operationcode_1,departmentid_1, subcompanyid_1,roleid_1, result_1);
	    if result_1=1 then
		fatherid_1 := -1;
	    end if;
	    while fatherid_1 <> -1
	    loop Doc_DirAcl_CheckPermissionEx1(fatherid_1, 1, userid_1, usertype_1, seclevel_1, operationcode_1,departmentid_1, subcompanyid_1,roleid_1, result_1); 
		    if result_1 <> 1 then
			    select  subcategoryid into fatherid1_1 from DocSubCategory where id = fatherid_1; fatherid_1 := fatherid1_1;
		    else
			fatherid_1 := -1;
		    end if;
	    end loop;
	end if;
end if;
 open thecursor for select result_1 result from dual;  
 end;
/
 CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermissionEx1 ( 
 dirid_1 integer,
 dirtype_1 integer,
 userid_1 integer, 
 usertype_1 integer, 
 seclevel_1 integer,
 operationcode_1 integer,
 departmentid_1 integer,
 subcompanyid_1 integer,
 roleid_1 varchar2,
 haspermission_1 in out integer  
 )  AS  count_1 integer; result integer;  
 begin 
 result := 0;  
 if usertype_1 = 0 then 
	  select count(sourceid) into count_1  from DirAccessControlDetail where sharelevel=operationcode_1 and sourceid=dirid_1 and sourcetype=dirtype_1  and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and to_char(content) in (roleid_1) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1));
else 
	select  count(mainid) into  count_1 from DirAccessControlList where dirid=dirid_1 and dirtype=dirtype_1 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1));
 end if;  
 if  count_1 is not null and count_1>0 then result := 1; end if; 
 haspermission_1 := result; end;
/
CREATE OR REPLACE PROCEDURE Doc_DirAcl_CPermissionForDir
(
dirid_1 integer, 
dirtype_1 integer, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
delete from DirAccessControlList where dirid = dirid_1 and dirtype = dirtype_1;
end ;
/
CREATE OR REPLACE PROCEDURE Doc_DirAcl_Delete
(
mainid_1 integer, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
    for permission_cursor in(select dirid, dirtype, seclevel, departmentid, subcompanyid, roleid, rolelevel, usertype, permissiontype, operationcode, userid from DirAccessControlList where mainid = mainid_1)
    loop       
        delete from DirAccessControlList where mainid = mainid_1;
    end loop;
end;
/
CREATE OR REPLACE PROCEDURE Doc_DirAcl_Insert_Type1
(
dirid_1 integer,
dirtype_1 integer, 
operationcode_1 integer, 
departmentid_1 integer, 
seclevel_1 integer,
flag	out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
AS
userid_1 integer;
count_1 integer;
begin
insert into DirAccessControlList(dirid, dirtype, departmentid, seclevel, operationcode, permissiontype) values(dirid_1, dirtype_1, departmentid_1, seclevel_1, operationcode_1, 1);
end;
/
CREATE OR REPLACE PROCEDURE Doc_DirAcl_Insert_Type2
(
dirid_1 integer, 
dirtype_1 integer, 
operationcode_1 integer,
roleid_1 integer, 
rolelevel_1 integer, 
seclevel_1 integer, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
userid_1 integer;
count_1 integer;
begin
insert into DirAccessControlList(dirid, dirtype, roleid, rolelevel, seclevel, operationcode, permissiontype) values(dirid_1, dirtype_1, roleid_1, rolelevel_1, seclevel_1, operationcode_1, 2);
end;
/
CREATE OR REPLACE PROCEDURE Doc_DirAcl_Insert_Type3
(
dirid_1 integer,
dirtype_1 integer,
operationcode_1 integer,
seclevel_1 integer,
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
userid_1 integer;
count_1 integer;
begin
insert into DirAccessControlList(dirid, dirtype, seclevel, operationcode, permissiontype) 
values(dirid_1, dirtype_1, seclevel_1, operationcode_1, 3);
end;
/
CREATE OR REPLACE PROCEDURE Doc_DirAcl_Insert_Type4
(
dirid_1 integer,
dirtype_1 integer,
operationcode_1 integer,
usertype_1 integer,
seclevel_1 integer,
flag  out integer,
msg    out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
    userid_1 integer;
begin
insert into DirAccessControlList(dirid, dirtype, usertype, seclevel, operationcode, permissiontype) values(dirid_1, dirtype_1, usertype_1, seclevel_1, operationcode_1, 4);
end;
/
CREATE OR REPLACE PROCEDURE Doc_DirAcl_Insert_Type5
(
dirid_1 integer,
dirtype_1 integer, 
operationcode_1 integer,
userid_1 integer, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
insert into DirAccessControlList(dirid, dirtype, userid, operationcode, permissiontype) values(dirid_1, dirtype_1, userid_1, operationcode_1, 5);
end;
/
CREATE OR REPLACE PROCEDURE Doc_DirAcl_Insert_Type6
(dirid_1         integer,
dirtype_1       integer,
operationcode_1 integer,
subcompanyid_1  integer,
seclevel_1      integer,
flag            out integer,
msg             out varchar2,
thecursor       IN OUT cursor_define.weavercursor) AS 
userid_1 integer;
count_1  integer;
begin
  insert into DirAccessControlList
    (dirid, dirtype, subcompanyid, seclevel, operationcode, permissiontype)
  values
    (dirid_1, dirtype_1, subcompanyid_1, seclevel_1, operationcode_1, 6);
end;
/
CREATE or REPLACE procedure Doc_GetPermittedCategory
(
userid_1 integer,
usertype_1 integer, 
seclevel_1 integer,
operationcode_1 integer,
departmentid_1 integer,
subcompanyid_1 integer,
roleid_1 varchar2,  
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as 
secdirid_1 integer;
secdirname_1 varchar2(200);
subdirid_1 integer;
subdirid1_1 integer;
superdirid_1 integer;
superdirtype_1 integer;
maindirid_1 integer;
subdirname_1 varchar2(200);
count_1 integer;
orderid_1 float;
begin
if usertype_1 = 0 then
        for secdir_cursor in(select id mainid, categoryname, subcategoryid, secorder from DocSecCategory where id in (select distinct sourceid from DirAccessControlDetail where sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and to_char(content) in (roleid_1) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or		(type=4 and content=usertype_1 and seclevel<=seclevel_1) or		(type=5 and content=userid_1) or		(type=6 and content=subcompanyid_1 and seclevel<=seclevel_1))))        
        loop
            secdirid_1 := secdir_cursor.mainid;
            secdirname_1 := secdir_cursor.categoryname;
            subdirid_1 := secdir_cursor.subcategoryid;
            orderid_1 :=secdir_cursor.secorder;
            insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1);
            if subdirid_1 is null then
            subdirid_1 := -1 ;
            end if;
            if subdirid_1 = 0 then
            subdirid_1 := -1 ;
            end if;
                while subdirid_1 <> -1 loop
                    select subcategoryid,categoryname,subcategoryid,maincategoryid,suborder into subdirid1_1,subdirname_1,superdirid_1,maindirid_1,orderid_1  from DocSubCategory where  id = subdirid_1 ;
                    if superdirid_1 = -1 then
                        superdirid_1 := maindirid_1 ;
                        superdirtype_1 := 0 ;        
                    else 
                        superdirtype_1 := 1 ;
                    end if;
                    count_1 := 0 ;        
                    select count(categoryid) into count_1 from temp_4 where categoryid = subdirid_1 and categorytype = 1 ;
                    if count_1 <= 0 then
                        insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(subdirid_1, 1, superdirid_1, superdirtype_1, subdirname_1, orderid_1);
                    end if;
                    subdirid_1 := subdirid1_1 ;
                end loop;
            end loop;
else 
    for secdir_cursor in (select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct dirid mainid from DirAccessControlList where dirtype=2 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1))))    
        loop
            secdirid_1 := secdir_cursor.mainid;
            secdirname_1 := secdir_cursor.categoryname;
            subdirid_1 := secdir_cursor.subcategoryid;
            orderid_1 := secdir_cursor.secorder;
            insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1);
            if subdirid_1 is null then
            subdirid_1 := -1 ;
            end if;
            if subdirid_1 = 0 then
            subdirid_1 := -1 ;
            end if;
            while subdirid_1 <> -1 loop
                select subcategoryid,categoryname,subcategoryid,maincategoryid,suborder into subdirid1_1,subdirname_1,superdirid_1,maindirid_1,orderid_1  from DocSubCategory where id = subdirid_1;
                if superdirid_1 = -1 then
                    superdirid_1 := maindirid_1 ;
                    superdirtype_1 := 0 ;        
                else 
                    superdirtype_1 := 1 ;
                end if;
                count_1 := 0 ;        
                select count(categoryid) into count_1 from temp_4 where categoryid = subdirid_1 and categorytype = 1 ;
                if count_1 <= 0 then
                    insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(subdirid_1, 1, superdirid_1, superdirtype_1, subdirname_1, orderid_1);
                    end if;
                    subdirid_1 := subdirid1_1 ;
            end loop;
        end loop;  
end if;
for maindir_cursor in(select id, categoryname, categoryorder from DocMainCategory where id in (select distinct superdirid from temp_4 where superdirtype = 0))
loop
    subdirid_1 := maindir_cursor.id;
    subdirname_1 := maindir_cursor.categoryname;
    orderid_1 := maindir_cursor.categoryorder;
    insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(subdirid_1, 0, -1, -1, subdirname_1, orderid_1);
end loop;
open thecursor for 
select * from temp_4 order by orderid,categoryid ;
end;
/
CREATE OR REPLACE PROCEDURE Doc_MainCategory_FindByUser 
(
userid_1 integer, 
usertype_1 integer,
seclevel_1 integer,
operationcode_1 integer, 
departmentid_1 integer,
subcompanyid_1 integer,
roleid_1 varchar2,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as 
begin
if operationcode_1 = 0 then
open thecursor for
    select  id   mainid from DocMainCategory where id in (
        select distinct maincategoryid from DocSubCategory where id in (
            select distinct subcategoryid from DocSecCategory where id in (
		   select distinct  sourceid from DirAccessControlDetail where sourcetype=2 and  sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and to_char(content) in (roleid_1) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1))
                )
            )
        )
    order by categoryorder;
else  
open thecursor for
    select  id   mainid from DocMainCategory where id in (
               select distinct  sourceid from DirAccessControlDetail where sourcetype=0 and  sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and to_char(content) in (roleid_1) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1))
        )
    order by categoryorder;
end if;
end;
/
CREATE OR REPLACE PROCEDURE Doc_SecCategory_FindByUser 
(
userid_1 integer, 
usertype_1 integer,
seclevel_1 integer,
operationcode_1 integer, 
departmentid_1 integer,
subcompanyid_1 integer,
roleid_1 integer,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as 
begin
open thecursor for
    select distinct id mainid from DocSecCategory where id in (select distinct  sourceid from DirAccessControlDetail where sourcetype=2 and  sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and to_char(content) in (roleid_1) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1)));
end;
/
CREATE OR REPLACE PROCEDURE Doc_SubCategory_FindByUser
(
userid_1 integer, 
usertype_1 integer,
seclevel_1 integer,
operationcode_1 integer, 
departmentid_1 integer,
subcompanyid_1 integer,
roleid_1 integer,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as 
begin
if operationcode_1 = 0 then
open thecursor for
    select distinct subcategoryid mainid from DocSecCategory where id in (select distinct  sourceid from DirAccessControlDetail where sourcetype=2 and  sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and to_char(content) in (roleid_1) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1)));
else
open thecursor for
    select distinct  sourceid mainid from DirAccessControlDetail where sourcetype=1 and  sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and to_char(content) in (roleid_1) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1));	
end if;
end;
/
drop PROCEDURE Doc_DirAccessPermission_Delete
/
drop PROCEDURE Doc_DirAccessPermission_Insert
/
drop PROCEDURE  Doc_DirAcl_DUserP_RoleChange
/
drop PROCEDURE  Doc_DirAcl_DUserP_BasicChange
/
drop PROCEDURE Doc_DirAcl_DUserPermission
/
drop PROCEDURE Doc_DirAcl_GrantUserPermission
/
drop PROCEDURE Doc_DirAcl_GUserP_BasicChange
/
drop PROCEDURE Doc_DirAcl_GUserP_RoleChange
/
drop PROCEDURE Doc_DirAcl_CPermissionForUser
/

CREATE OR REPLACE procedure HrmResourceShare(
	resourceid_1 integer,
	departmentid_1 integer,
	subcompanyid_1 integer,
	managerid_1 integer,
	seclevel_1 integer,
	managerstr_1 varchar2,
	olddepartmentid_1 integer,
	oldsubcompanyid_1 integer,
	oldmanagerid_1 integer,
	oldseclevel_1 integer,
	oldmanagerstr_1 varchar2,
	flag_1 integer,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)  AS
	supresourceid_1 integer;
	docid_1     integer;
	crmid_1     integer;
	prjid_1     integer;
	cptid_1     integer;
	sharelevel_1  integer;
	countrec      integer;
	managerstr_11 varchar2(500);
	mainid_1    integer;
	subid_1    integer;
	secid_1    integer;
	members_1 varchar2(200);
	contractid_1     integer;
	contractroleid_1 integer;
	sharelevel_Temp integer;
	workPlanId_1 integer;
	m_countworkid integer;
	docid_2 integer;
	sharelevel_2  integer;
	countrec_2 integer;
	managerId_2s_2 varchar2(50);
	sepindex_2 integer;
	managerId_2 varchar2(200);
	tempDownOwnerId_2 integer;
	oldsubcompanyid_1_this integer;
begin
if oldsubcompanyid_1 is null then
    oldsubcompanyid_1_this := 0;
else
    oldsubcompanyid_1_this := oldsubcompanyid_1;
end if;
if (seclevel_1 <> oldseclevel_1) then
update HrmResource_Trigger set
seclevel =seclevel_1
where id =resourceid_1;
end if;
if ( departmentid_1 <> olddepartmentid_1 ) then
update HrmResource_Trigger set
departmentid =departmentid_1
where id =resourceid_1;
end if;
if ( managerstr_1 <> oldmanagerstr_1 ) then
update HrmResource_Trigger set
managerstr =managerstr_1
where id =resourceid_1;
end if;
if (subcompanyid_1 <> oldsubcompanyid_1_this) then
update HrmResource_Trigger set
subcompanyid1 =subcompanyid_1
where id =resourceid_1;
end if;
if((flag_1 = 1 and (departmentid_1<>olddepartmentid_1 or oldsubcompanyid_1_this<>subcompanyid_1 or seclevel_1<>oldseclevel_1) ) or flag_1 = 0) then
    delete from DocUserCategory where userid= resourceid_1 and usertype= '0';
    for all_cursor in(
    select distinct t1.id t1id from docseccategory t1,HrmResource_Trigger t2,hrmrolemembers t5
    where t1.cusertype='0' and t2.id= resourceid_1
    and(( t2.seclevel>= t1.cuserseclevel)
    or( t2.seclevel >= t1.cdepseclevel1 and t2.departmentid=t1.cdepartmentid1)
    or( t2.seclevel >= t1.cdepseclevel2 and t2.departmentid=t1.cdepartmentid2)
    or( t5.roleid=t1.croleid1 and t5.rolelevel=t1.crolelevel1 and t2.id=t5.resourceid )
    or( t5.roleid=t1.croleid2 and t5.rolelevel=t1.crolelevel2 and t2.id=t5.resourceid )
    or( t5.roleid=t1.croleid3 and t5.rolelevel=t1.crolelevel3 and t2.id=t5.resourceid ))
    )
    loop
        secid_1 := all_cursor.t1id;
        select  subcategoryid INTO subid_1 from docseccategory where id=secid_1;
        select  maincategoryid INTO mainid_1 from docsubcategory where id=subid_1;
        insert into  docusercategory (secid,mainid,subid,userid,usertype)
        values (secid_1,mainid_1,subid_1,resourceid_1,'0');
    end loop;
	if ((flag_1 = 1 and departmentid_1 <>olddepartmentid_1) or flag_1=0 ) then
		update shareinnerdoc set content=departmentid_1 where type=3 and  srcfrom=85 and opuser=resourceid_1;
	end if;
	if ((flag_1 = 1 and subcompanyid_1<>oldsubcompanyid_1_this) or flag_1 = 0) then
		update shareinnerdoc set content=subcompanyid_1 where type=2 and srcfrom=84 and opuser=resourceid_1;
	end if;
    for crmid_cursor IN (select id from CRM_CustomerInfo where manager = resourceid_1 )
    loop
    crmid_1 :=crmid_cursor.id;
    insert into temptablevaluecrm values(crmid_1, 2);
    end loop;
    managerstr_11 := concat( concat('%,' , to_char(resourceid_1)) , ',%' );
    for subcrmid_cursor IN (select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ))
    loop
    crmid_1 :=subcrmid_cursor.id;
        select count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0 then
        insert into temptablevaluecrm values(crmid_1, 3);
        end if;
    end loop;
    for rolecrmid_cursor IN (   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
    loop
    crmid_1:=rolecrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0 then
        insert into temptablevaluecrm values(crmid_1, 4);
        end if;
    end loop;
    for sharecrmid_cursor IN (select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
    loop
    crmid_1 := sharecrmid_cursor.relateditemid;
     sharelevel_1:=sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1 ;
        if countrec = 0  then
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
    end loop;
    for sharecrmid_cursor IN (   select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department=departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) )
    )
    loop
    crmid_1 :=sharecrmid_cursor.relateditemid;
    sharelevel_1 :=sharecrmid_cursor.sharelevel;
        select count(crmid) INTO countrec from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
    end loop;
    for allcrmid_cursor IN (select * from temptablevaluecrm)
    loop
    crmid_1 :=allcrmid_cursor.crmid;
    sharelevel_1 := allcrmid_cursor.sharelevel;
        for ccwp_cursor in(
        SELECT id FROM WorkPlan WHERE type_n = '3' AND ','||crmid||',' like '%,'||to_char(crmid_1)||',%') 
        loop
        workPlanId_1 := ccwp_cursor.id;
        select count(workid)     into  m_countworkid FROM WorkPlanShareDetail WHERE workid = workPlanId_1
            AND userid = resourceid_1 AND usertype = 1;
        if m_countworkid  = 0 then
        INSERT INTO WorkPlanShareDetail(workid, userid, usertype, sharelevel) VALUES (
            workPlanId_1, resourceid_1, 1, 1);
        end if;
        end loop;
    end loop;
    for prjid_cursor IN (select id from Prj_ProjectInfo where manager = resourceid_1 )
    loop
    prjid_1:=prjid_cursor.id;
    insert into temptablevaluePrj values(prjid_1, 2);
    end loop;
     managerstr_11 :=  concat(concat('%,' , to_char(resourceid_1)) , ',%' );
    for subprjid_cursor IN (select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ))
    loop
    prjid_1 :=subprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
        insert into temptablevaluePrj values(prjid_1, 3);
        end if;
    end loop;
    for roleprjid_cursor IN (   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
    loop
    prjid_1 :=roleprjid_cursor.id;
        select count(prjid) INTO  countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
        insert into temptablevaluePrj values(prjid_1, 4);
        end if;
    end loop;
    for shareprjid_cursor IN ( select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
    loop
    prjid_1 :=shareprjid_cursor.relateditemid;
    sharelevel_1 :=shareprjid_cursor.sharelevel;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then
            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
    end loop;
    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and  t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department=departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) )
    )
    loop
     prjid_1 :=shareprjid_cursor.relateditemid;
     sharelevel_1:=shareprjid_cursor.sharelevel;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0 then
            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
    end loop;
    members_1 := concat(concat('%,' , to_char(resourceid_1)), ',%' );
    for inuserprjid_cursor IN (  SELECT  id FROM Prj_ProjectInfo   WHERE  ( concat(concat(',',members),',')  LIKE  members_1)  and isblock='1'  )
    loop
    prjid_1 :=inuserprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then
            insert into temptablevaluePrj values(prjid_1, 5);
        end if;
    end loop;
    delete from PrjShareDetail where userid = resourceid_1 and usertype = 1;
    for allprjid_cursor IN (select * from temptablevaluePrj)
    loop
    prjid_1 :=allprjid_cursor.prjid;
    sharelevel_1 :=allprjid_cursor.sharelevel;
       insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(prjid_1, resourceid_1,1,sharelevel_1);
    end loop;
    for cptid_cursor IN (select id from CptCapital where resourceid = resourceid_1 )
    loop
    cptid_1 :=cptid_cursor.id;
    insert into temptablevalueCpt values(cptid_1, 2);
    end loop;
    for cptid_cursor IN (select id from CptCapital where lastmoderid = resourceid_1 )
    loop
    cptid_1 :=cptid_cursor.id;
    insert into temptablevalueCpt values(cptid_1, 1);
    end loop;
     managerstr_11 := concat(concat( '%,' , to_char(resourceid_1)),',%');
    for subcptid_cursor IN (
    select id from CptCapital where ( resourceid in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ))
    loop
    cptid_1 := subcptid_cursor.id;
        select  count(cptid) INTO countrec  from temptablevalueCpt where cptid = cptid_1;
        if countrec = 0  then
        insert into temptablevalueCpt values(cptid_1, 1);
        end if;
    end loop;
    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
    loop
    cptid_1 :=sharecptid_cursor.relateditemid;
    sharelevel_1 := sharecptid_cursor.sharelevel;
        select  count(cptid) into  countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end if;
    end loop;
    for  sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1 ) or (t3.rolelevel=2) ))
    loop
    cptid_1:= sharecptid_cursor.relateditemid;
    sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec  from temptablevalueCpt where cptid = cptid_1;
        if countrec = 0 then
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end  if;
    end loop;
    delete from CptShareDetail where userid = resourceid_1 and usertype = 1;
    for allcptid_cursor IN (select * from temptablevalueCpt)
    loop
    cptid_1 :=allcptid_cursor.cptid;
    sharelevel_1 := allcptid_cursor.sharelevel;
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1, resourceid_1,1,sharelevel_1);
    end loop;
    managerstr_11:=Concat ('%,' ,Concat(to_char(resourceid_1),',%'));
    for subcontractid_cursor in(
    select id from CRM_Contract where ( manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ))
    loop
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0  then
            insert into temptablevaluecontract values(contractid_1, 3);
        end if;
    end loop;
    for contractid_cursor in
    (select id from CRM_Contract where manager = resourceid_1 )
    loop
        contractid_1 := contractid_cursor.id;
        insert into temptablevaluecontract values(contractid_1, 2);
    end loop;
    for roleids_cursor in
    (select roleid from SystemRightRoles where rightid = 396)
    loop
       for rolecontractid_cursor in
 (select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2
 where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1
 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1 )
 or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
      loop
            contractid_1 := rolecontractid_cursor.id;
            select count(contractid) into countrec from temptablevaluecontract
            where contractid = contractid_1;
            if countrec = 0  then
                insert into temptablevaluecontract values(contractid_1, 2);
            else
                select sharelevel into sharelevel_1 from ContractShareDetail where
                contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                if sharelevel_1 = 1 then
                     update ContractShareDetail set sharelevel = 2
                     where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                end if;
            end if;
        end loop;
    end loop;
    for sharecontractid_cursor in
    (select distinct t2.relateditemid , t2.sharelevel from Contract_ShareInfo  t2
    where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 )
    or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
    loop
        contractid_1 := sharecontractid_cursor.relateditemid;
        sharelevel_1 := sharecontractid_cursor.sharelevel;
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0 then
            insert into temptablevaluecontract values(contractid_1, sharelevel_1);
        else
            select sharelevel into sharelevel_Temp from temptablevaluecontract where contractid = contractid_1;
            if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
                update temptablevaluecontract set sharelevel = sharelevel_1 where contractid = contractid_1;
            end if;
        end if;
    end loop;
    for sharecontractid_cursor in
    (select distinct t2.relateditemid , t2.sharelevel from
    CRM_Contract t1 ,  Contract_ShareInfo  t2,  HrmRoleMembers  t3
    where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and
    t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and
    ( (t2.rolelevel=0  and t1.department=departmentid_1) or
    (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ))
    loop
        contractid_1 := sharecontractid_cursor.relateditemid;
        sharelevel_1 := sharecontractid_cursor.sharelevel;
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0 then
            insert into temptablevaluecontract values(contractid_1, sharelevel_1);
        else
            select sharelevel into sharelevel_Temp from temptablevaluecontract where contractid = contractid_1;
            if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
                update temptablevaluecontract set sharelevel = sharelevel_1 where contractid = contractid_1;
            end if;
        end if;
    end loop;
    managerstr_11:=concat( '%,',concat(to_char(resourceid_1),',%'));
    for subcontractid_cursor in
    (select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2
    where ( t1.manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) )
    and (t2.crmId = t1.id))
    loop
        contractid_1 := subcontractid_cursor.id;
        select count(contractid)  into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0 then
            insert into temptablevaluecontract values(contractid_1, 1);
        end if;
    end loop;
    for contractid_cursor in
    (select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2
    where (t1.manager = resourceid_1 ) and (t2.crmId = t1.id))
    loop
        contractid_1 := contractid_cursor.id;
        insert into temptablevaluecontract values(contractid_1, 1);
    end loop;
    delete from ContractShareDetail where userid = resourceid_1 and usertype = 1;
    for allcontractid_cursor in
    (select * from temptablevaluecontract)
    loop
        contractid_1 := allcontractid_cursor.contractid;
        sharelevel_1 := allcontractid_cursor.sharelevel;
        insert into ContractShareDetail( contractid, userid, usertype, sharelevel)
        values(contractid_1, resourceid_1,1,sharelevel_1);
    end loop;
    for creater_cursor in(
    SELECT id FROM WorkPlan WHERE createrid = resourceid_1)
    loop
    workPlanId_1 := creater_cursor.id;
        INSERT INTO TmpTableValueWP( workPlanId , shareLevel ) VALUES (workPlanId_1, 2);
    end loop;
    managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );
    for underling_cursor in(
    SELECT id FROM WorkPlan WHERE (createrid IN (SELECT DISTINCT id FROM HrmResource_Trigger WHERE concat(',' , MANAGERSTR) LIKE managerstr_11)))
    loop
         workPlanId_1 := underling_cursor.id;
        SELECT COUNT(workPlanId) into countrec  FROM TmpTableValueWP WHERE workPlanId = workPlanId_1;
        IF (countrec = 0) then
        INSERT INTO TmpTableValueWP(workPlanId , shareLevel) VALUES (workPlanId_1, 1);
        end if;
   end loop;
   for sharewp_cursor1 in(
    SELECT DISTINCT workPlanId, shareLevel FROM WorkPlanShare WHERE ((forAll = 1 AND securityLevel <= seclevel_1) OR (userId like '%,'||resourceid_1||',%') OR (deptId like  concat( concat('%,' , to_char(departmentid_1)) , ',%' ) AND securityLevel <= seclevel_1)))
    loop
        workPlanId_1 := sharewp_cursor1.workPlanId;
        sharelevel_1 := sharewp_cursor1.shareLevel;
        SELECT count(workPlanId) into countrec  FROM TmpTableValueWP WHERE workPlanId = workPlanId_1 ;
        IF (countrec = 0) then
            INSERT INTO TmpTableValueWP( workPlanId , shareLevel ) VALUES (workPlanId_1, sharelevel_1);
        end if;
    end loop;
     for  sharewp_cursor2 in(
    SELECT DISTINCT t2.workPlanId as t2workPlanId, t2.shareLevel as t2shareLevel FROM WorkPlan t1, WorkPlanShare t2, HrmRoleMembers t3 WHERE t1.id = t2.workPlanId AND t3.resourceid = resourceid_1 AND t3.roleid = t2.roleId AND t3.rolelevel >= t2.roleLevel AND t2.securityLevel <= seclevel_1 AND ((t2.roleLevel = 0  AND t1.deptId = departmentid_1) OR (t2.roleLevel = 1 AND t1.subcompanyId = subcompanyid_1) OR (t3.rolelevel = 2)) )
    loop
        workPlanId_1 := sharewp_cursor2.t2workPlanId;
        sharelevel_1 := sharewp_cursor2.t2shareLevel;
        SELECT COUNT(workPlanId) into countrec  FROM TmpTableValueWP WHERE workPlanId = workPlanId_1;
        IF (countrec = 0 ) then
            INSERT INTO TmpTableValueWP( workPlanId , shareLevel ) VALUES (workPlanId_1, sharelevel_1);
       end if;
    end loop;
    for allwp_cursor in (SELECT * FROM TmpTableValueWP)
    loop
    workPlanId_1 := allwp_cursor.workPlanId;
    sharelevel_1 := allwp_cursor.shareLevel;
        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
    end loop;
end if;
if ( flag_1 = 1 and managerstr_1 <> oldmanagerstr_1 and length(managerstr_1) > 1) then 
         managerId_2 := concat( ',' , managerstr_1);
    update shareinnerdoc set content = managerid_1 where srcfrom = 81 and opuser = resourceid_1;
        for supuserid_cursor IN (select distinct t1.id  id_1, t2.id id_2 from HrmResource_Trigger t1, CRM_CustomerInfo t2 where managerId_2 like concat(concat('%,',to_char(t1.id)),',%') and  t2.manager = resourceid_1  )
        loop
        supresourceid_1:= supuserid_cursor.id_1;
        crmid_1 := supuserid_cursor.id_2;
            select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0 then
                insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(crmid_1,supresourceid_1,1,3);
            end if;
        for ccwp_cursor in(
        SELECT id FROM WorkPlan WHERE type_n = '3' AND ','||crmid||',' like '%,'||to_char(crmid_1)||',%')
        loop
           workPlanId_1 := ccwp_cursor.id;
               select count(workid) into m_countworkid FROM WorkPlanShareDetail WHERE workid = workPlanId_1
            AND userid = resourceid_1 AND usertype = 1;
              if m_countworkid  = 0 then
              INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
            workPlanId_1, resourceid_1, 1, 1);
              end if;
         end loop;
        end loop;
        for supuserid_cursor IN (    select distinct t1.id  id_1, t2.id id_2 from HrmResource_Trigger t1, Prj_ProjectInfo t2 where managerId_2 like concat(concat('%,',to_char(t1.id)),',%')  and  t2.manager = resourceid_1 )
        loop
        supresourceid_1:= supuserid_cursor.id_1;
        prjid_1 :=supuserid_cursor.id_2;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0  then
                insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(prjid_1,supresourceid_1,1,3);
            end if;
        end loop;
        for supuserid_cursor IN (select distinct  t1.id  id_1, t2.id id_2 from HrmResource_Trigger t1, CptCapital t2 where managerId_2 like concat(concat('%,',to_char(t1.id)),',%') and  t2.resourceid = resourceid_1  )
        loop
        supresourceid_1:=supuserid_cursor.id_1;
        cptid_1:=supuserid_cursor.id_2;
            select  count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0  then
                insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1,supresourceid_1,1,1);
            end if;
        end loop;
        for supuserid_cursor in
        (select distinct t1.id id_1, t2.id id_2 from HrmResource_Trigger t1, CRM_Contract t2
        where managerId_2 like concat('%,',concat(to_char(t1.id),',%')) and  t2.manager = resourceid_1)
        loop
            supresourceid_1 := supuserid_cursor.id_1;
            contractid_1 := supuserid_cursor.id_2;
            select count(contractid) into countrec from ContractShareDetail where contractid = contractid_1 and
            userid= supresourceid_1 and usertype=1;
            if countrec = 0  then
                insert into ContractShareDetail( contractid, userid, usertype, sharelevel)
                values(contractid_1,supresourceid_1,1,3);
            end if;
        end loop;
        for supuserid_cursor in
        (select distinct t1.id id_1, t3.id id_2 from HrmResource_Trigger t1, CRM_CustomerInfo t2 ,CRM_Contract t3 where managerId_2
        like concat('%,',concat(to_char(t1.id),',%')) and  t2.manager = resourceid_1  and t2.id = t3.crmId)
        loop
            supresourceid_1 := supuserid_cursor.id_1;
            contractid_1 := supuserid_cursor.id_2;
            select count(contractid) into countrec from ContractShareDetail
            where contractid = contractid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0  then
                insert into ContractShareDetail( contractid, userid, usertype, sharelevel)
                values(contractid_1,supresourceid_1,1,1);
            end if;
        end loop;
       for  supuserid_cursor in(
        SELECT DISTINCT t1.id  id_1, t2.id  id_2 FROM HrmResource_Trigger t1, WorkPlan t2 WHERE managerId_2 LIKE concat(concat('%,' , to_char(t1.id)) ,',%') AND t2.createrid = resourceid_1)
        loop
        supresourceid_1 := supuserid_cursor.id_1;
        workPlanId_1 := supuserid_cursor.id_2;
            SELECT COUNT(workid) into countrec  FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = supresourceid_1 AND usertype = 1;
            IF (countrec = 0) then
                INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) values(workPlanId_1, supresourceid_1, 1, 1);
            end if;
       end loop;
    end  if;
end;
/
create or replace procedure HrmRoleMembersShare
(resourceid_1 integer,
roleid_1     integer,
rolelevel_1 integer,
rolelevel_2 integer,
flag_1 integer,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) AS
    oldrolelevel_1 char(1);
    oldresourceid_1 integer;
    oldroleid_1 integer;
    docid_1	 integer;
    crmid_1	 integer;
    prjid_1	 integer;
    cptid_1	 integer;
    sharelevel_1  integer;
    departmentid_1 integer;
    subcompanyid_1 integer;
    seclevel_1	 integer;
    countrec      integer;
    countdelete   integer;
    countinsert   integer;
    managerstr_11 varchar2(500);
    contractid_1	 integer;
    contractroleid_1 integer;
    sharelevel_Temp integer;
    workPlanId_1 integer;
    m_countworkid integer;
    tempresourceid integer;
begin
oldrolelevel_1 := rolelevel_2;
oldroleid_1 :=  roleid_1;
oldresourceid_1 := resourceid_1;
	select count(id) into tempresourceid  from hrmresourcemanager where id = resourceid_1 ;
	if tempresourceid >0 then
		return ;
	end if ;
if ( flag_1=0 or (flag_1=1 and rolelevel_1>rolelevel_2) )  then
    select  departmentid ,  subcompanyid1 ,  seclevel INTO  departmentid_1 ,subcompanyid_1 ,seclevel_1
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null  then
	departmentid_1 := 0;
	end if;
    if subcompanyid_1 is null  then
	subcompanyid_1 := 0;
	end if;
    if rolelevel_1 = '2'   then 
		if roleid_1=8 then
		    INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) select id,resourceid_1,1,0 from WorkPlan where type_n = '3';
		else 
		for sharecrmid_cursor IN (     select distinct relateditemid , sharelevel from CRM_ShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		crmid_1:=sharecrmid_cursor.relateditemid;
		sharelevel_1 := sharecrmid_cursor.sharelevel;
			select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
			if countrec = 0  then
				insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
			else if sharelevel_1 = 2  then
				update CrmShareDetail set sharelevel = 2 where crmid=crmid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */
			end if;
			end if;
	    for ccwp_cursor in(
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND ','||crmid||',' like '%,'||to_char(crmid_1)||',%')
	      loop
               workPlanId_1 := ccwp_cursor.id ;
                 select count(workid) into m_countworkid  FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1;
	    	 if m_countworkid  = 0 then
		INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			workPlanId_1, resourceid_1, 1, 1);
                 end if;
           end loop;
		end loop;
		end if;
		for shareprjid_cursor IN (      select distinct relateditemid , sharelevel from Prj_ShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		prjid_1 := shareprjid_cursor.relateditemid;
		sharelevel_1 := shareprjid_cursor.sharelevel;
            select count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
            else if sharelevel_1 = 2  then
                update PrjShareDetail set sharelevel = 2 where prjid=prjid_1 and userid = resourceid_1 and usertype = 1;
            end if;
			end if;
		end loop;
		for sharecptid_cursor IN (select distinct relateditemid , sharelevel from CptCapitalShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		cptid_1 :=sharecptid_cursor.relateditemid;
		sharelevel_1 :=sharecptid_cursor.sharelevel;
            select count(cptid) INTO  countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            else if sharelevel_1 = 2 then
                update CptShareDetail set sharelevel = 2 where cptid=cptid_1 and userid = resourceid_1 and usertype = 1;
            end if;
			end if;
		end loop;
        for roleids_cursor in
        (select roleid from SystemRightRoles where rightid = 396)
        loop
            for rolecontractid_cursor in
            (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2
            where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1 and t2.rolelevel=2)
            loop
	       contractid_1 := rolecontractid_cursor.id;
               select count(contractid) into countrec from ContractShareDetail
               where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                if countrec = 0 then
                    insert into ContractShareDetail values(contractid_1, resourceid_1, 1, 2);
                else
                    select sharelevel into sharelevel_1 from ContractShareDetail
                    where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    if sharelevel_1 = 1 then
                         update ContractShareDetail set sharelevel = 2
                         where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    end if;
                end if;
            end loop;
        end loop;
	    for sharewp_cursor in(
         SELECT  DISTINCT workPlanId, shareLevel FROM WorkPlanShare WHERE roleId = roleid_1 AND roleLevel <= rolelevel_1 AND securityLevel <= seclevel_1 )
         loop
         workPlanId_1 := sharewp_cursor.workPlanId;
         sharelevel_1 := sharewp_cursor.shareLevel;
	     SELECT COUNT(workid) into countrec FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1;
             IF  countrec = 0 then
                 INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel)   VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
             ELSE IF sharelevel_1 = 2 then
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1;
                end if;
             end if;
          end loop;
    end if;
    if rolelevel_1 = '1' then 
       for sharecrmid_cursor IN (      select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department = t4.id and t4.subcompanyid1= subcompanyid_1)
	   loop
	   crmid_1 :=sharecrmid_cursor.relateditemid;
	   sharelevel_1 :=sharecrmid_cursor.sharelevel;
            select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1;
            if countrec = 0  then
                insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
            else if sharelevel_1 = 2  then
                update CrmShareDetail set sharelevel = 2 where crmid = crmid_1 and userid = resourceid_1 and usertype = 1;
            end if;
			end if;
	    for ccwp_cursor in(
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND ','||crmid||',' like '%,'||to_char(crmid_1)||',%')
	    loop
            workPlanId_1 := ccwp_cursor.id ;
                select count(workid) into m_countworkid  FROM WorkPlanShareDetail WHERE workid = workPlanId_1
			AND userid = resourceid_1 AND usertype = 1;
                if  m_countworkid = 0 then
		        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			workPlanId_1, resourceid_1, 1, 1);
		     end if;
        end loop;
	   end loop;
		for shareprjid_cursor IN (        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department=t4.id and t4.subcompanyid1= subcompanyid_1)
		loop
		prjid_1 := shareprjid_cursor.relateditemid;
		sharelevel_1 :=shareprjid_cursor.sharelevel;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
            else if sharelevel_1 = 2  then
                update PrjShareDetail set sharelevel = 2 where prjid=prjid_1 and userid = resourceid_1 and usertype = 1;
            end if;
			end if;
		end loop;
		for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1)
		loop
		cptid_1 :=sharecptid_cursor.relateditemid;
		sharelevel_1 :=sharecptid_cursor.sharelevel;
            select  count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            else if sharelevel_1 = 2  then
                update CptShareDetail set sharelevel = 2 where cptid=cptid_1 and userid = resourceid_1 and usertype = 1;
            end if;
			end if;
		end loop;
        for roleids_cursor in
        (select roleid from SystemRightRoles where rightid = 396)
        loop
            for rolecontractid_cursor in
            (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2
            where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1
            and (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 ))
            loop
	       contractid_1 := rolecontractid_cursor.id;
               select count(contractid) into countrec from ContractShareDetail
               where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                if countrec = 0 then
                    insert into ContractShareDetail values(contractid_1, resourceid_1, 1, 2);
                else
                    select sharelevel into sharelevel_1 from ContractShareDetail
                    where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    if sharelevel_1 = 1 then
                         update ContractShareDetail set sharelevel = 2
                         where contractid = contractid_1 and userid = resourceid_1 and usertype = 1  ;
                    end if;
                end if;
            end loop;
        end loop;
	 for sharewp_cursor in(
         SELECT DISTINCT t2.workPlanId, t2.shareLevel FROM WorkPlan t1, WorkPlanShare t2 WHERE t1.id = t2.workPlanId AND t2.roleId = roleid_1 AND t2.roleLevel <= rolelevel_1 AND t2.securityLevel <= seclevel_1 AND t1.subcompanyId = subcompanyid_1)
         loop
         workPlanId_1 := sharewp_cursor.workPlanId;
         sharelevel_1 := sharewp_cursor.shareLevel;
	     SELECT COUNT(workid) into countrec  FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1  ;
             IF (countrec = 0) then
                 INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel)  VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
             ELSE IF (sharelevel_1 = 2) then
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1 ;
             end if;
             end if;
         end loop;
    end if;
    if rolelevel_1 = '0'     then 
		for sharecrmid_cursor IN (select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department = departmentid_1)
		loop
		crmid_1 :=sharecrmid_cursor.relateditemid;
		sharelevel_1 :=sharecrmid_cursor.sharelevel;
          select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
                insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
            else if sharelevel_1 = 2  then
                update CrmShareDetail set sharelevel = 2 where crmid = crmid_1 and userid = resourceid_1 and usertype = 1 ;
            end if;
			end if;
	    for ccwp_cursor in(
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND ','||crmid||',' like '%,'||to_char(crmid_1)||',%')
	    loop
            workPlanId_1 := ccwp_cursor.id ;
            select count(workid) into m_countworkid FROM WorkPlanShareDetail WHERE workid = workPlanId_1
			AND userid = resourceid_1 AND usertype = 1;
            if m_countworkid =0 then
		INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			workPlanId_1, resourceid_1, 1, 1);
	    end if;
            end loop;
 end loop;
		for shareprjid_cursor IN (       select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department= departmentid_1)
		loop
		prjid_1 :=shareprjid_cursor.relateditemid;
		sharelevel_1 := shareprjid_cursor.sharelevel;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
            else if sharelevel_1 = 2  then
                update PrjShareDetail set sharelevel = 2 where prjid = prjid_1 and userid = resourceid_1 and usertype = 1;
            end if;
			end if;
		end loop;
		for sharecptid_cursor IN (       select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.departmentid= departmentid_1)
		loop
		 cptid_1 :=sharecptid_cursor.relateditemid;
		 sharelevel_1 := sharecptid_cursor.sharelevel;
            select count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            else if sharelevel_1 = 2  then
                update CptShareDetail set sharelevel = 2 where cptid = cptid_1 and userid = resourceid_1 and usertype = 1 ;
            end if;
			end if;
		end loop;
        for roleids_cursor in
        (select roleid from SystemRightRoles where rightid = 396)
        loop
            for rolecontractid_cursor in
            (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2
            where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1 and
            (t2.rolelevel=0 and t1.department=departmentid_1 ))
            loop
	       contractid_1 := rolecontractid_cursor.id;
               select count(contractid) into countrec from ContractShareDetail
               where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                if countrec = 0  then
                    insert into ContractShareDetail values(contractid_1, resourceid_1, 1, 2);
                else
                    select sharelevel into sharelevel_1 from ContractShareDetail
                    where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    if sharelevel_1 = 1 then
                         update ContractShareDetail set sharelevel = 2
                         where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    end if;
                end if;
            end loop;
        end loop;
	 for sharewp_cursor in (
         SELECT  t2.workPlanId, t2.shareLevel FROM WorkPlan t1, WorkPlanShare t2 WHERE t1.id = t2.workPlanId AND t2.roleId = roleid_1 AND t2.roleLevel <= rolelevel_1 AND t2.securityLevel <= seclevel_1 AND t1.deptId like  concat( concat('%,' , to_char(departmentid_1)) , ',%') )
         loop
         workPlanId_1 := sharewp_cursor.workPlanId;
         sharelevel_1 := sharewp_cursor.shareLevel;
	     SELECT COUNT(workid) into countrec  FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1  ;
             IF (countrec = 0) then
                 INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel)  VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
             ELSE IF (sharelevel_1 = 2) then
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1 ;
            end if;
             end if;
          end loop;
    end if;
else
if (  flag_1=2 or (flag_1=1 and rolelevel_1<rolelevel_2)  )  then
    select  departmentid ,  subcompanyid1 ,  seclevel INTO departmentid_1 ,subcompanyid_1 ,seclevel_1
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null then
	departmentid_1 := 0;
    end if;
	if subcompanyid_1 is null then
	subcompanyid_1 := 0;
	end if;
    for crmid_cursor IN (   select id from CRM_CustomerInfo where manager = resourceid_1 )
	loop
	crmid_1 := crmid_cursor.id;
	insert into temptablevaluecrm values(crmid_1, 2);
	end loop;
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)) , ',%' );
    for subcrmid_cursor IN (  select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
	loop
	crmid_1 :=  subcrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0  then
		insert into temptablevaluecrm values(crmid_1, 3);
		end if;
	end loop;
    for rolecrmid_cursor IN (   select distinct t1.id from CRM_CustomerInfo  t1, HrmRoleMembers_Tri  t2  where t2.roleid=8 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	crmid_1 := rolecrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0 then
		insert into temptablevaluecrm values(crmid_1, 4);
		end if;
	end loop;
    for sharecrmid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid = departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	crmid_1:= sharecrmid_cursor.relateditemid;
	sharelevel_1 :=sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
	end loop;
    for sharecrmid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers_Tri  t3  where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department = departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ) )
	loop
	crmid_1 :=sharecrmid_cursor.relateditemid;
	sharelevel_1 := sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
	end loop;
    for allcrmid_cursor IN (    select * from temptablevaluecrm)
	loop
	crmid_1 :=allcrmid_cursor.crmid;
	sharelevel_1  := allcrmid_cursor.sharelevel;
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(crmid_1, resourceid_1,1,sharelevel_1);
        for ccwp_cursor in(
        SELECT id FROM WorkPlan WHERE type_n = '3' AND ','||crmid||',' like '%,'||to_char(crmid_1)||',%')
        loop
        workPlanId_1 := ccwp_cursor.id ;
            select count(workid) into m_countworkid FROM WorkPlanShareDetail WHERE workid = workPlanId_1
			AND userid = resourceid_1 AND usertype = 1;
            if m_countworkid = 0 then
	    INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			workPlanId_1, resourceid_1, 1, 1);
	    end if;
        end loop;
	end loop;
    for prjid_cursor IN (select id from Prj_ProjectInfo where manager = resourceid_1 )
	loop
	prjid_1 := prjid_cursor.id;
      insert into temptablevaluePrj values(prjid_1, 2);
	end loop;
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );
    for subprjid_cursor IN (    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
	loop
	prjid_1 :=subprjid_cursor.id;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 3);
		end if;
	end loop;
    for roleprjid_cursor IN (   select distinct t1.id from Prj_ProjectInfo  t1, HrmRoleMembers_Tri  t2  where t2.roleid=9 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	prjid_1:=roleprjid_cursor.id;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 4);
		end if;
	end loop;
    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	prjid_1 := shareprjid_cursor.relateditemid;
	sharelevel_1 :=  shareprjid_cursor.sharelevel;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then
            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
	end loop;
    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers_Tri  t3  where  t1.id = t2.relateditemid and  t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department=departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) )
	)
	loop
	prjid_1 := shareprjid_cursor.relateditemid;
	sharelevel_1 := shareprjid_cursor.sharelevel;
        select  count(prjid) INTO countrec from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0 then

            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
	end loop;
    for inuserprjid_cursor IN (    SELECT distinct t2.id FROM Prj_TaskProcess  t1,Prj_ProjectInfo  t2 WHERE  t1.hrmid =resourceid_1 and t2.id=t1.prjid and t1.isdelete<>'1' and t2.isblock='1' )
	loop
	prjid_1 :=inuserprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1 ;
        if countrec = 0  then
            insert into temptablevaluePrj values(prjid_1, 5);
        end if;
	end loop;
    delete from PrjShareDetail where userid = resourceid_1 and usertype = 1;
    for allprjid_cursor IN (select * from temptablevaluePrj)
	loop
	prjid_1 := allprjid_cursor.prjid;
	sharelevel_1 := allprjid_cursor.sharelevel;
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(prjid_1, resourceid_1,1,sharelevel_1);
	end loop;
    for cptid_cursor IN (    select id from CptCapital where resourceid = resourceid_1 )
	loop
	cptid_1 := cptid_cursor.id;
	  insert into temptablevalueCpt values(cptid_1, 2);
	end loop;
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );
    for subcptid_cursor IN ( select id from CptCapital where ( resourceid in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
	loop
	cptid_1 := subcptid_cursor.id;
        select  count(cptid) INTO countrec  from temptablevalueCpt where cptid = cptid_1;
        if countrec = 0 then
		insert into temptablevalueCpt values(cptid_1, 1);
		end if;
	end loop;
    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	cptid_1 := sharecptid_cursor.relateditemid;
	sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end if;
	end loop;
    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers_Tri  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1 ) or (t3.rolelevel=2) ))
	loop
	cptid_1 := sharecptid_cursor.relateditemid;
	sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end    if;
	end loop;
    delete from CptShareDetail where userid = resourceid_1 and usertype = 1;
    for allcptid_cursor IN (select * from temptablevalueCpt)
	loop
	cptid_1 :=allcptid_cursor.cptid;
	sharelevel_1 :=allcptid_cursor.sharelevel;
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1, resourceid_1,1,sharelevel_1);
	end loop;
    managerstr_11:=concat('%,',concat(to_char(resourceid_1), ',%' ));
    for subcontractid_cursor in
    (select id from CRM_Contract
    where (manager in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
    loop
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0  then
            insert into temptablevaluecontract values(contractid_1, 3);
        end if;
    end loop;
    for contractid_cursor in
    (select id from CRM_Contract where manager = resourceid_1)
    loop
        contractid_1 := contractid_cursor.id;
        insert into temptablevaluecontract values(contractid_1, 2);
    end loop;
    for roleids_cursor in
    (select roleid from SystemRightRoles where rightid = 396)
    loop
       for rolecontractid_cursor in
       (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2
       where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1
       and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1 )
       or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
         loop
	    contractid_1 := rolecontractid_cursor.id;
            select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
            if countrec = 0 then
                insert into temptablevaluecontract values(contractid_1, 2);
            else
                select sharelevel into sharelevel_1 from ContractShareDetail where contractid = contractid_1
                and userid = resourceid_1 and usertype = 1;
                if sharelevel_1 = 1 then
                     update ContractShareDetail
                     set sharelevel = 2 where contractid = contractid_1
                     and userid = resourceid_1 and usertype = 1;
                end if;
            end if;
         end loop;
    end loop;
    for sharecontractid_cursor in
    (select distinct t2.relateditemid , t2.sharelevel from Contract_ShareInfo  t2
     where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)
     or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)))
    loop
        contractid_1 := sharecontractid_cursor.relateditemid;
        sharelevel_1 := sharecontractid_cursor.sharelevel;
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0 then
            insert into temptablevaluecontract values(contractid_1, sharelevel_1);
        else
            select sharelevel into sharelevel_Temp from temptablevaluecontract
            where contractid = contractid_1;
            if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
               update temptablevaluecontract set sharelevel = sharelevel_1
               where contractid = contractid_1;
            end if;
         end if;
    end loop;
    for sharecontractid_cursor in
    (select distinct t2.relateditemid , t2.sharelevel
    from CRM_Contract t1 ,  Contract_ShareInfo  t2,  HrmRoleMembers_Tri  t3
    where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1
    and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel
    and t2.seclevel<=seclevel_1
    and ( (t2.rolelevel=0  and t1.department=departmentid_1)
    or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ))
        loop
        contractid_1 := sharecontractid_cursor.relateditemid;
        sharelevel_1 := sharecontractid_cursor.sharelevel;
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0 then
            insert into temptablevaluecontract values(contractid_1, sharelevel_1);
        else
            select sharelevel into sharelevel_Temp from temptablevaluecontract where contractid = contractid_1;
            if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
              update temptablevaluecontract set sharelevel = sharelevel_1 where contractid = contractid_1;
            end if;
         end if;
         end loop;
    managerstr_11:= concat('%,',concat(to_char(resourceid_1),',%'));
    for subcontractid_cursor in
    (select t2.id from CRM_CustomerInfo t1, CRM_Contract t2 where ( t1.manager in
    (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11) )
    and (t2.crmId = t1.id))
    loop
        contractid_1 := subcontractid_cursor.id;
        select count(contractid) into countrec from temptablevaluecontract
        where contractid = contractid_1;
        if countrec = 0  then
              insert into temptablevaluecontract values(contractid_1, 1);
        end if;
    end loop;
    for contractid_cursor in
    (select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2
    where (t1.manager = resourceid_1 ) and (t2.crmId = t1.id))
        loop
	contractid_1 := contractid_cursor.id;
          insert into temptablevaluecontract values(contractid_1, 1);
        end loop;
    delete from ContractShareDetail where userid = resourceid_1 and usertype = 1;
    for allcontractid_cursor in
    (select * from temptablevaluecontract)
    loop
        contractid_1 := allcontractid_cursor.contractid;
        sharelevel_1 := allcontractid_cursor.sharelevel;
        insert into ContractShareDetail( contractid, userid, usertype, sharelevel)
        values(contractid_1, resourceid_1,1,sharelevel_1);
    end loop;
    end if;
    for  creater_cursor in (SELECT id FROM WorkPlan WHERE createrid = resourceid_1)
    loop
         workPlanId_1 := creater_cursor.id;
        INSERT INTO TmpTableValueWP VALUES (workPlanId_1, 2);
    end loop;
    managerstr_11 := concat(concat('%,', to_char(resourceid_1)), ',%' );
    for  underling_cursor in(
    SELECT id FROM WorkPlan WHERE (createrid IN (SELECT DISTINCT id FROM HrmResource WHERE concat(',', MANAGERSTR) LIKE managerstr_11)))
    loop
    workPlanId_1 := underling_cursor.id;
        SELECT COUNT(workPlanId) into countrec  FROM TmpTableValueWP WHERE workPlanId = workPlanId_1;
        IF (countrec = 0)  then
        INSERT INTO TmpTableValueWP VALUES (workPlanId_1, 1);
        end if;
     end loop;
    for sharewp_cursor in
    (
        SELECT DISTINCT workPlanShare.workPlanId, workPlanShare.shareLevel
        FROM WorkPlanShare workPlanShare
        WHERE
        (
            (workPlanShare.forAll = 1 AND workPlanShare.securityLevel <= seclevel_1)
            OR (workPlanShare.userId LIKE '%,'||cast(resourceid_1 as varchar2(10))||',%')
            OR (workPlanShare.deptId LIKE '%,'||cast(departmentid_1 as varchar2(10))||',%' AND workPlanShare.securityLevel <= seclevel_1)
            OR (workPlanShare.subCompanyId LIKE '%,'||cast(subcompanyid_1 as varchar2(10))||',%' AND workPlanShare.securityLevel <= seclevel_1)
            )
        )
    loop
    workPlanId_1 := sharewp_cursor.workPlanId;
    sharelevel_1 := sharewp_cursor.shareLevel;
        SELECT COUNT(workPlanId) into countrec   FROM TmpTableValueWP WHERE workPlanId = workPlanId_1  ;
        IF (countrec = 0) then
            INSERT INTO TmpTableValueWP VALUES (workPlanId_1, sharelevel_1);
        end if;
     end loop;
    for sharewp_cursor in
    (
        SELECT DISTINCT workPlanShare.workPlanId, workPlanShare.shareLevel
        FROM WorkPlan workPlan, WorkPlanShare workPlanShare, HrmRoleMembers_Tri hrmRoleMembers_Tri
        WHERE
        (
            workPlan.id = workPlanShare.workPlanId
            AND workPlanShare.roleId = hrmRoleMembers_Tri.roleId
            AND hrmRoleMembers_Tri.resourceid = resourceid_1
            AND hrmRoleMembers_Tri.rolelevel >= workPlanShare.roleLevel
            AND workPlanShare.securityLevel <= seclevel_1
            )
        )
    loop
    workPlanId_1 := sharewp_cursor.workPlanId;
    sharelevel_1 := sharewp_cursor.shareLevel;
        SELECT COUNT(workPlanId) into countrec   FROM TmpTableValueWP WHERE workPlanId = workPlanId_1  ;
        IF (countrec = 0) then
            INSERT INTO TmpTableValueWP VALUES (workPlanId_1, sharelevel_1);
        end if;
     end loop;
    for  allwp_cursor in(SELECT * FROM TmpTableValueWP)
    loop
    workPlanId_1 := allwp_cursor.workPlanId;
	sharelevel_1 := allwp_cursor.shareLevel;
	SELECT COUNT(workid) into countrec FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1  ;
			IF (countrec = 0) then
			    INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel)  VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
			ELSE IF (sharelevel_1 = 2) then
			    UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1 ;
			end if;
			end if;
    end loop;
end if ;
end;
/
CREATE OR REPLACE PROCEDURE IDirAccessControlDetailP as
  id_1    integer;
  dirid_1         integer;
  dirtype_1      integer;
  seclevel_1     integer;
  subcompanyid_1      integer;
    departmentid_1      integer;
  userid_1            integer;
  usertype_1        integer;
  rolelevel_1         integer;
  roleid_1             integer;
  permissiontype_1  integer;
  operationcode_1 integer;
 docSecCategoryTemplateId_1 integer;
 sourceid_1           integer;
 type_1        integer;
 content_1        integer;
 sharelevel_1          integer;
 sourcetype_1        integer;
 srcfrom_1           integer;
begin
    DELETE DirAccessControlDetail ;
    for shareuserid_cursor in (select mainid,dirid,
                                    dirtype,
                                    seclevel,
                                    userid,
                                    subcompanyid,
                                    departmentid,
                                    usertype,
                                    roleid,
                                    rolelevel,
                                    operationcode,
                                    permissiontype,
            DocSecCategoryTemplateId
                               from DirAccessControlList
                              where dirtype >0
          and dirid >0 ) loop
        id_1:=shareuserid_cursor.mainid;
        dirid_1:=shareuserid_cursor.dirid;
        dirtype_1:=shareuserid_cursor.dirtype;
        seclevel_1:=shareuserid_cursor.seclevel;
        userid_1:=shareuserid_cursor.userid;
        subcompanyid_1:=shareuserid_cursor.subcompanyid;
        departmentid_1:=shareuserid_cursor.departmentid;
        usertype_1:=shareuserid_cursor.usertype;
        roleid_1:=shareuserid_cursor.roleid;
        rolelevel_1:=shareuserid_cursor.rolelevel;
        operationcode_1:=shareuserid_cursor.operationcode;
        permissiontype_1:=shareuserid_cursor.permissiontype;
        docSecCategoryTemplateId_1:=shareuserid_cursor.DocSecCategoryTemplateId;
        sourceid_1:=dirid_1;
        sourcetype_1:=dirtype_1;
        srcfrom_1:=id_1;
        type_1:=permissiontype_1;
        sharelevel_1:=operationcode_1;
        if permissiontype_1=1 then  
          content_1:=departmentid_1;
        end if;
        if  permissiontype_1=2  then 
          content_1:=  to_number(to_char(roleid_1) || to_char(rolelevel_1));
        end if;
        if  permissiontype_1=3  then   
	   begin
           content_1:=0;
           seclevel_1:=seclevel_1;
          end;
        end if;
        if  permissiontype_1=4  then 
          content_1:=usertype_1;
        end if;
        if  permissiontype_1=5  then 
          begin
          content_1:=userid_1;
          seclevel_1:=0;
          end;
        end if;
        if  permissiontype_1=6  then  
          content_1:=subcompanyid_1;
        end if;
         insert into DirAccessControlDetail
        (
          sourceid,
          type,
          content,
          seclevel,
          sharelevel,
          sourcetype,
          srcfrom
         )values(
          sourceid_1,
          type_1,
          content_1,
          seclevel_1,
          sharelevel_1,
          sourcetype_1,
          srcfrom_1
         );
      end loop;
end;
/
call IDirAccessControlDetailP()
/
create or replace trigger Tri_D_DirAccessControlList
  after DELETE ON DirAccessControlList
  for each row
begin
    DELETE FROM DirAccessControlDetail where srcfrom=:OLD.mainid;
end;
/
create or replace trigger Tri_I_DirAccessControlList
  after insert ON DirAccessControlList
  for each row
declare
     id_1    integer;
  dirid_1         integer;
  dirtype_1      integer;
  seclevel_1     integer;
  subcompanyid_1      integer;
    departmentid_1      integer;
  userid_1            integer;
  usertype_1        integer;
  rolelevel_1         integer;
  roleid_1             integer;
  permissiontype_1  integer;
  operationcode_1 integer;
 docSecCategoryTemplateId_1 integer;
 sourceid_1           integer;
 type_1        integer;
 content_1        integer;
 sharelevel_1          integer;
 sourcetype_1        integer;
 srcfrom_1           integer;
begin
     id_1:=:new.mainid;
        dirid_1:=:new.dirid;
        dirtype_1:=:new.dirtype;
        seclevel_1:=:new.seclevel;
        userid_1:=:new.userid;
        subcompanyid_1:=:new.subcompanyid;
        departmentid_1:=:new.departmentid;
        usertype_1:=:new.usertype;
        roleid_1:=:new.roleid;
        rolelevel_1:=:new.rolelevel;
        operationcode_1:=:new.operationcode;
        permissiontype_1:=:new.permissiontype;
        docSecCategoryTemplateId_1:=:new.DocSecCategoryTemplateId;
        sourceid_1:=dirid_1;
        sourcetype_1:=dirtype_1;
        srcfrom_1:=id_1;
        type_1:=permissiontype_1;
        sharelevel_1:=operationcode_1;
        if permissiontype_1=1 then  
          content_1:=departmentid_1;
        end if;
        if  permissiontype_1=2  then 
          content_1:=  to_number(to_char(roleid_1) || to_char(rolelevel_1));
        end if;
        if  permissiontype_1=3  then 
	begin
          seclevel_1:=seclevel_1;
	  content_1:=0;
	  end;
        end if;
        if  permissiontype_1=4  then 
          content_1:=usertype_1;
        end if;
        if  permissiontype_1=5  then 
          begin
          content_1:=userid_1;
          seclevel_1:=0;
          end;
        end if;
        if  permissiontype_1=6  then 
          content_1:=subcompanyid_1;
        end if;
         insert into DirAccessControlDetail
        (
          sourceid,
          type,
          content,
          seclevel,
          sharelevel,
          sourcetype,
          srcfrom
         )values(
          sourceid_1,
          type_1,
          content_1,
          seclevel_1,
          sharelevel_1,
          sourcetype_1,
          srcfrom_1
         );
end;
/