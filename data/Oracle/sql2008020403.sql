alter table DirAccessControlList add subcompanyid integer null
/

CREATE OR REPLACE PROCEDURE Doc_DirAcl_Insert_Type6(dirid_1         integer,
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
  for users_cursor in (select distinct id
                         from HrmResource
                        where subcompanyid1 = subcompanyid_1
                          and seclevel >= seclevel_1) loop
    userid_1 := users_cursor.id;
    Doc_DirAccessPermission_Insert(dirid_1,
                                   dirtype_1,
                                   userid_1,
                                   0,
                                   operationcode_1);
  end loop;
end;
/

CREATE OR REPLACE PROCEDURE Doc_DirAcl_GUserP_BasicChange
(
userid_1 integer, 
departmentid_1 integer, 
subcompanyid_1 integer, 
seclevel_1 integer)  
AS
mainid_1 integer;
dirid_1 integer;
dirtype_1 integer;
operationcode_1 integer;
roleid_1 integer;
rolelevel_1 integer;
begin

for permission_cursor in(select mainid, dirid, dirtype, operationcode from DirAccessControlList 
where (permissiontype=1 and departmentid=departmentid_1 and seclevel<=seclevel_1) or 
      (permissiontype=3 and seclevel<=seclevel_1) or
      (permissiontype=4 and usertype=0 and seclevel<=seclevel_1) or 
      (permissiontype=5 and userid=userid_1) or
      (permissiontype=6 and subcompanyid=subcompanyid_1 and seclevel<=seclevel_1)
      )
loop
    mainid_1 := permission_cursor.mainid ; 
    dirid_1 := permission_cursor.dirid ; 
    dirtype_1 := permission_cursor.dirtype ; 
    operationcode_1 := permission_cursor.operationcode ; 
    Doc_DirAccessPermission_Insert (dirid_1,dirtype_1,userid_1,0,operationcode_1);
end loop;


for user_role_cursor in(select roleid, rolelevel from HrmRoleMembers where resourceid = userid_1)
loop
roleid_1 := user_role_cursor.roleid ;
rolelevel_1 := user_role_cursor.rolelevel ;
    for permission_cursor1 in(  select mainid, dirid, dirtype, operationcode from DirAccessControlList   where (permissiontype=2 and roleid=roleid_1 and rolelevel<=rolelevel_1 and seclevel<=seclevel_1))
    loop
    mainid_1 := permission_cursor1.mainid ;
    dirid_1:= permission_cursor1.dirid ;
    dirtype_1:= permission_cursor1.dirtype ;
    operationcode_1 :=permission_cursor1.operationcode ;
    Doc_DirAccessPermission_Insert (dirid_1,dirtype_1,userid_1,0,operationcode_1);
    end loop;
end loop;

end;
/

CREATE OR REPLACE PROCEDURE Doc_DirAcl_GrantUserPermission
(userid_1 integer, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
departmentid_1 integer;
subcompanyid_1 integer;
seclevel_1 integer;
mainid_1 integer;
dirid_1 integer;
dirtype_1 integer;
operationcode_1 integer;
isValidUser integer;
roleid_1 integer;
rolelevel_1 integer;
begin

isValidUser := 0 ;
for user_cursor in(select departmentid, subcompanyid1, seclevel from HrmResource where id = userid_1)
loop
    departmentid_1 := user_cursor.departmentid ;
    subcompanyid_1 := user_cursor.subcompanyid1;
    seclevel_1 := user_cursor.seclevel;
    isValidUser := 1;
    for permission_cursor in(  select mainid, dirid, dirtype, operationcode from DirAccessControlList 
            where (permissiontype=1 and departmentid=departmentid_1 and seclevel<=seclevel_1) or 
        (permissiontype=3 and seclevel<=seclevel_1) or
        (permissiontype=4 and usertype=0 and seclevel<=seclevel_1) or
        (permissiontype=5 and userid=userid_1) or
        (permissiontype=6 and subcompanyid=subcompanyid_1 and seclevel<=seclevel_1)
        )
    loop
        mainid_1 := permission_cursor.mainid;
        dirid_1 := permission_cursor.dirid ;
        dirtype_1 := permission_cursor.dirtype ;
        operationcode_1 := permission_cursor.operationcode;
        Doc_DirAccessPermission_Insert (dirid_1,dirtype_1,userid_1,0,operationcode_1);
    end loop;

end loop;



if isValidUser = 1 then
  
for user_role_cursor in (select roleid, rolelevel from HrmRoleMembers where resourceid = userid_1) 
loop      
    roleid_1 := user_role_cursor.roleid;
    rolelevel_1 := user_role_cursor.rolelevel;
    for permission_cursor in(select mainid, dirid, dirtype, operationcode from DirAccessControlList  where (permissiontype=2 and roleid=roleid_1 and rolelevel<=rolelevel_1 and seclevel<=seclevel_1))
        loop
            mainid_1 :=permission_cursor.mainid; 
            dirid_1 :=permission_cursor.dirid;
            dirtype_1 :=permission_cursor.dirtype;
            operationcode_1 :=permission_cursor.operationcode;
            Doc_DirAccessPermission_Insert (dirid_1,dirtype_1,userid_1,0,operationcode_1);
        end loop;

end loop;
end if;

end;
/

CREATE OR REPLACE PROCEDURE Doc_DirAcl_DUserPermission
(
userid_1 integer, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
departmentid_1 integer;
subcompanyid_1 integer;
seclevel_1 integer;
mainid_1 integer;
dirid_1 integer;
dirtype_1 integer;
operationcode_1 integer;
isValidUser integer;
roleid_1 integer;
rolelevel_1 integer;
begin
isValidUser := 0;
for user_cursor in(select departmentid, subcompanyid1, seclevel from HrmResource where id = userid_1)
loop
    departmentid_1 :=user_cursor.departmentid;
    subcompanyid_1 :=user_cursor.subcompanyid1;
    seclevel_1:=user_cursor.seclevel;
    isValidUser := 1;
    for permission_cursor in(  select mainid, dirid, dirtype, operationcode from DirAccessControlList     where (permissiontype=1 and departmentid=departmentid_1 and seclevel<=seclevel_1) or         (permissiontype=3 and seclevel<=seclevel_1) or  (permissiontype=4 and usertype=0 and seclevel<=seclevel_1) or   (permissiontype=5 and userid=userid_1) or (permissiontype=6 and subcompanyid=subcompanyid_1 and seclevel<=seclevel_1))
    loop
    mainid_1 := permission_cursor.mainid;
    dirid_1 :=permission_cursor.dirid;
    dirtype_1 :=permission_cursor.dirtype;
    operationcode_1 := permission_cursor.operationcode;
    Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,0,operationcode_1);
    end loop;
end loop;


if isValidUser = 1 then
    for user_role_cursor in (select roleid, rolelevel from HrmRoleMembers where resourceid = userid_1)
    loop
        roleid_1 := user_role_cursor.roleid;
        rolelevel_1 := user_role_cursor.rolelevel;
        for permission_cursor in (select mainid, dirid, dirtype, operationcode from DirAccessControlList     where (permissiontype=2 and roleid=roleid_1 and rolelevel<=rolelevel_1 and seclevel<=seclevel_1))
        loop
        mainid_1 :=permission_cursor.mainid ;
        dirid_1 :=permission_cursor.dirid ;
        dirtype_1 :=permission_cursor.dirtype  ;
        operationcode_1 :=permission_cursor.operationcode ;
        Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,0,operationcode_1);
        end loop;
    end loop;
end if;
end;
/

CREATE OR REPLACE PROCEDURE Doc_DirAcl_DUserP_BasicChange
(
userid_1 integer, 
departmentid_1 integer,
subcompanyid_1 integer,
seclevel_1 integer) 
AS

mainid_1 integer;
dirid_1 integer;
dirtype_1 integer;
operationcode_1 integer;
roleid_1 integer;
rolelevel_1 integer;
begin

for  permission_cursor in(select mainid, dirid, dirtype, operationcode from DirAccessControlList 
where (permissiontype=1 and departmentid=departmentid_1 and seclevel<=seclevel_1) or 
      (permissiontype=3 and seclevel<=seclevel_1) or
      (permissiontype=4 and usertype=0 and seclevel<=seclevel_1) or 
      (permissiontype=5 and userid=userid_1) or
      (permissiontype=6 and subcompanyid=subcompanyid_1 and seclevel<=seclevel_1))
loop
    mainid_1 :=permission_cursor.mainid ;
    dirid_1:=permission_cursor.dirid ;
    dirtype_1:=permission_cursor.dirtype ;
    operationcode_1 :=permission_cursor.operationcode ;
    Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,0,operationcode_1);

end loop;


for user_role_cursor in(select roleid, rolelevel from HrmRoleMembers where resourceid = userid_1
)
loop
    roleid_1 :=user_role_cursor.roleid;
    rolelevel_1  :=user_role_cursor.rolelevel;

    for permission_cursor1 in (  select mainid, dirid, dirtype, operationcode from DirAccessControlList   where (permissiontype=2 and roleid=roleid_1 and rolelevel<=rolelevel_1 and seclevel<=seclevel_1))
    loop
    mainid_1 := permission_cursor1.mainid ;
    dirid_1:= permission_cursor1.dirid ;
    dirtype_1:= permission_cursor1.dirtype ;
    operationcode_1 :=permission_cursor1.operationcode ;
    Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,0,operationcode_1);
    end loop;

end loop;
end ;
/

CREATE OR REPLACE PROCEDURE Doc_DirAcl_Delete
(
mainid_1 integer, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
dirid_1 integer;
dirtype_1 integer;
operationcode_1 integer;
departmentid_1 integer;
subcompanyid_1 integer;
roleid_1 integer;
rolelevel_1 integer;
seclevel_1 integer;
permissiontype_1 integer;
usertype_1 integer;
mainuserid_1 integer;
userid_1 integer;
count_1 integer;
begin
    for permission_cursor in(select dirid, dirtype, seclevel, departmentid, subcompanyid, roleid, rolelevel, usertype, permissiontype, operationcode, userid from DirAccessControlList where mainid = mainid_1)
    loop
        dirid_1 :=permission_cursor.dirid ;
        dirtype_1 :=permission_cursor.dirtype;
        seclevel_1 :=permission_cursor.seclevel;
        departmentid_1 :=permission_cursor.departmentid;
        subcompanyid_1 :=permission_cursor.subcompanyid;
        roleid_1 :=permission_cursor.roleid;
        rolelevel_1 :=permission_cursor.rolelevel;
        usertype_1 :=permission_cursor.usertype;
        permissiontype_1 :=permission_cursor.permissiontype;
        operationcode_1 :=permission_cursor.operationcode;
        mainuserid_1 :=permission_cursor.userid;
        if permissiontype_1 = 1 then
            for users_cursor in(select distinct id from HrmResource where departmentid = departmentid_1 and seclevel >= seclevel_1)
            loop
                userid_1 := users_cursor.id;
                Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,0,operationcode_1);
            end loop;
        end if;

        if permissiontype_1 = 2 then
            for users_cursor in(select distinct HrmResource.id h_id from HrmResource, HrmRoleMembers where roleid = roleid_1 and rolelevel >= rolelevel_1 and HrmResource.id = HrmRoleMembers.resourceid and seclevel >= seclevel_1)
            loop
                userid_1 := users_cursor.h_id;
                Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,0,operationcode_1);
            end loop;
        end if;

        if permissiontype_1 = 3 then
        for users_cursor in(select distinct id from HrmResource where seclevel >= seclevel_1)
        loop
            userid_1 := users_cursor.id;
            Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,0,operationcode_1);
        end loop;
        end if;

        if permissiontype_1 = 4 then
        for users_cursor in(select distinct id from HrmResource where seclevel >= seclevel_1)
        loop
            userid_1 := users_cursor.id;
            Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,usertype_1,operationcode_1);
        end loop;        
        end if;
        
        if permissiontype_1 = 5 then
            Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,mainuserid_1,0,operationcode_1);
        end if;

        if permissiontype_1 = 6 then
            for users_cursor in(select distinct id from HrmResource where subcompanyid1 = subcompanyid_1 and seclevel >= seclevel_1)
            loop
                userid_1 := users_cursor.id;
                Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,0,operationcode_1);
            end loop;
        end if;

        delete from DirAccessControlList where mainid = mainid_1;
    end loop;
end;
/

CREATE OR REPLACE TRIGGER TRI_UPDATE_HRMRESOURCESHARE
AFTER UPDATE or insert
ON HRMRESOURCE
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Declare
	resourceid_1 integer;
	subresourceid_1 integer;
	supresourceid_1 integer;
	olddepartmentid_1 integer;
	oldsubcompanyid_1  integer;
	departmentid_1 integer;
	subcompanyid_1 integer;
	oldseclevel_1     integer;
	seclevel_1     integer;
	docid_1     integer;
	crmid_1     integer;
	prjid_1     integer;
	cptid_1     integer;
	sharelevel_1  integer;
	countrec      integer;
	oldmanagerstr_1    varchar2(200);
	managerstr_1    varchar2(200);
	managerstr_11 varchar2(200) ;
	mainid_1    integer;
	subid_1    integer;
	secid_1    integer;
	members_1 varchar2(200);
	contractid_1     integer; /*2003-11-06杨国生*/
	contractroleid_1 integer ;   /*2003-11-06杨国生*/
	sharelevel_Temp integer; /*2003-11-06杨国生*/

	workPlanId_1 integer;    /* added by lupeng 2004-07-22 */
	m_countworkid integer;  /* 2004-10-27 dongyuqin*/

	docid_2 integer;   /* 2004-11-02 modify Doc_setDocShareByHrm(sql20051102)*/
	sharelevel_2  integer;
	countrec_2 integer;
	managerId_2s_2 varchar2(50);
	sepindex_2 integer;
	managerId_2 integer;
	tempDownOwnerId_2 integer;

begin


 olddepartmentid_1 := :old.departmentid;
 oldseclevel_1 := :old.seclevel ;
 oldmanagerstr_1 := :old.managerstr;
 oldsubcompanyid_1:= :old.subcompanyid1;
 resourceid_1 := :new.id ;
 departmentid_1 := :new.departmentid;
 subcompanyid_1 := :new.subcompanyid1;
 seclevel_1 := :new.seclevel ;
 managerstr_1 := :new.managerstr;

if seclevel_1 is not null then
update HrmResource_Trigger set
seclevel =seclevel_1
where id =resourceid_1;
end if;


if ( departmentid_1 is not null ) then
update HrmResource_Trigger set
departmentid =departmentid_1
where id =resourceid_1;
end if;

if (  managerstr_1 is not null) then
update HrmResource_Trigger set
managerstr =managerstr_1
where id =resourceid_1;
end if;

if subcompanyid_1 is not null then
update HrmResource_Trigger set
subcompanyid1 =subcompanyid_1
where id =resourceid_1;
end if;



if departmentid_1 is null   then
    departmentid_1 := 0;
    end if;
if subcompanyid_1 is null   then
    subcompanyid_1 := 0;
    end if;
if olddepartmentid_1 is null   then
    olddepartmentid_1 := 0;
    end if;


if  (departmentid_1 is not null  and (
		departmentid_1 <>olddepartmentid_1 
		or oldsubcompanyid_1 <> subcompanyid_1
		or seclevel_1 <> oldseclevel_1 
		or oldseclevel_1 is null))
then


    if ((olddepartmentid_1 is not null) and (oldseclevel_1 is not null)) then
        Doc_DirAcl_DUserP_BasicChange (resourceid_1, olddepartmentid_1, oldsubcompanyid_1, oldseclevel_1);
    end if;
    if ((departmentid_1 is not null) and (seclevel_1 is not null)) then
        Doc_DirAcl_GUserP_BasicChange (resourceid_1, departmentid_1, subcompanyid_1, seclevel_1);
    end if;




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

	if (departmentid_1 <>olddepartmentid_1 ) then
		update shareinnerdoc set content=departmentid_1 where type=3 and  srcfrom=85 and opuser=resourceid_1;
	end if; 

	if (subcompanyid_1<>oldsubcompanyid_1) then
		update shareinnerdoc set content=subcompanyid_1 where type=2 and srcfrom=84 and opuser=resourceid_1;
	end if;





    delete from CrmShareDetail where userid = resourceid_1 and usertype = 1;



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
    insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(crmid_1, resourceid_1,1,sharelevel_1);

    /* added by lupeng 2004-07-22 for customer contact work plan */
        for ccwp_cursor in(
        SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmid_1))
        loop
        workPlanId_1 := ccwp_cursor.id;
        select count(workid)     into  m_countworkid FROM WorkPlanShareDetail WHERE workid = workPlanId_1
            AND userid = resourceid_1 AND usertype = 1;
        if m_countworkid  = 0 then
        INSERT INTO WorkPlanShareDetail(workid, userid, usertype, sharelevel) VALUES (
            workPlanId_1, resourceid_1, 1, 1);
        end if;
        end loop;
    /* end */

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
        if countrec = 0  then

            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end    if;
        end loop;





    members_1 := concat(concat('%,' , to_char(resourceid_1)), ',%' );
    for inuserprjid_cursor IN (  SELECT  id FROM Prj_ProjectInfo   WHERE  ( concat(concat(',',members),',')  LIKE  members_1)  and isblock='1'  )
    loop
    prjid_1 :=inuserprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then

            insert into temptablevaluePrj values(prjid_1, 5);
        end    if;
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

    /*set managerstr_11 = '%,' + convert(varchar2(5),resourceid_1) + ',%' */
    managerstr_11:=Concat ('%,' ,Concat(to_char(resourceid_1),',%'));

    for subcontractid_cursor in(
    select id from CRM_Contract where ( manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ))
    loop
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0  then
            insert into temptablevaluecontract values(contractid_1, 3);
        end if;
    end loop;

     /*  自己是 manager 的客户合同 2 */
    for contractid_cursor in
    (select id from CRM_Contract where manager = resourceid_1 )
    loop
        insert into temptablevaluecontract values(contractid_1, 2);
    end loop;

       /* 作为客户合同管理员能看到的 */
    for roleids_cursor in
    (select roleid from SystemRightRoles where rightid = 396)
    loop

       for rolecontractid_cursor in
 (select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2
 where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1
 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1 )
 or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))

      loop
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

    /* 由客户合同的共享获得的权利 1 2 */
    for sharecontractid_cursor in
    (select distinct t2.relateditemid , t2.sharelevel from Contract_ShareInfo  t2
    where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 )
    or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
    loop
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

    /* 自己下级的客户合同  (客户经理及经理线)*/

    managerstr_11:=concat( '%,',concat(to_char(resourceid_1),',%'));

    for subcontractid_cursor in
    (select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2
    where ( t1.manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) )
    and (t2.crmId = t1.id))
    loop
        select count(contractid)  into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0 then
            insert into temptablevaluecontract values(contractid_1, 1);
        end if;
    end loop;
    /*  自己是 manager 的客户 (客户经理及经理线) */
    for contractid_cursor in
    (select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2
    where (t1.manager = resourceid_1 ) and (t2.crmId = t1.id))
    loop
        insert into temptablevaluecontract values(contractid_1, 1);
    end loop;

    /* 删除原有的与该人员相关的所有权 */
    delete from ContractShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allcontractid_cursor in
    (select * from temptablevaluecontract)
    loop
        insert into ContractShareDetail( contractid, userid, usertype, sharelevel)
        values(contractid_1, resourceid_1,1,sharelevel_1);
    end loop;


    /* for work plan */
    /* added by lupeng 2004-07-22 */
    /* delete all the work plan share info of this user */
    /* DELETE WorkPlanShareDetail WHERE userid = resourceid_1 AND usertype = 1 */

    /* write the data to the temporary table */
    /* a. the creater of the work plan is this user */
    for creater_cursor in(
    SELECT id FROM WorkPlan WHERE createrid = resourceid_1)
    loop
    workPlanId_1 := creater_cursor.id;
        INSERT INTO TmpTableValueWP( workPlanId , shareLevel ) VALUES (workPlanId_1, 2);
    end loop;

       /* b. the creater of the work plan is my underling */
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


      /* c. in the work plan share info */
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


/* write the temporary table data to the share detail table */
    for allwp_cursor in (SELECT * FROM TmpTableValueWP)
    loop
    workPlanId_1 := allwp_cursor.workPlanId;
    sharelevel_1 := allwp_cursor.shareLevel;
        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
    end loop;
    /* end */


end if;       /* 结束修改了部门和安全级别的情况 */



if ( managerstr_1 <> oldmanagerstr_1 )  then /* 新建人力资源时候对经理字段的改变不考虑 */

    if ( managerstr_1 is not null and length(managerstr_1) > 1 ) then /* 有上级经理 */


         managerstr_1 := concat( ',' , managerstr_1);

    /* ------- DOC 部分 ------- */
    /*只需要把docshareinner表中相应的经理做改动就可以了 81：表创建者上级*/
    update shareinnerdoc set content = managerstr_1 where srcfrom = 81 and opuser = resourceid_1;

    /* ------- CRM 部分 ------- */
        for supuserid_cursor IN (select distinct t1.id  id_1, t2.id id_2 from HrmResource_Trigger t1, CRM_CustomerInfo t2 where managerstr_1 like concat(concat('%,',to_char(t1.id)),',%') and  t2.manager = resourceid_1  )
        loop
        supresourceid_1:= supuserid_cursor.id_1;
        crmid_1 := supuserid_cursor.id_2;
            select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0 then

                insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(crmid_1,supresourceid_1,1,3);
            end if;

 /* added by lupeng 2004-07-22 for customer contact work plan */
        for ccwp_cursor in(
        SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmid_1))
        loop
           workPlanId_1 := ccwp_cursor.id;
               select count(workid) into m_countworkid FROM WorkPlanShareDetail WHERE workid = workPlanId_1
            AND userid = resourceid_1 AND usertype = 1;
              if m_countworkid  = 0 then
              INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
            workPlanId_1, resourceid_1, 1, 1);
              end if;
         end loop;
        /* end */

        end loop;



    /* ------- PROJ 部分 ------- */
        for supuserid_cursor IN (    select distinct t1.id  id_1, t2.id id_2 from HrmResource_Trigger t1, Prj_ProjectInfo t2 where managerstr_1 like concat(concat('%,',to_char(t1.id)),',%')  and  t2.manager = resourceid_1 )
        loop
        supresourceid_1:= supuserid_cursor.id_1;
        prjid_1 :=supuserid_cursor.id_2;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0  then

                insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(prjid_1,supresourceid_1,1,3);
            end if;
        end loop;



    /* ------- CPT 部分 ------- */
        for supuserid_cursor IN (select distinct  t1.id  id_1, t2.id id_2 from HrmResource_Trigger t1, CptCapital t2 where managerstr_1 like concat(concat('%,',to_char(t1.id)),',%') and  t2.resourceid = resourceid_1  )
        loop
        supresourceid_1:=supuserid_cursor.id_1;
        cptid_1:=supuserid_cursor.id_2;
            select  count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0  then
                insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1,supresourceid_1,1,1);
            end if;
        end loop;

         /* ------- 客户合同部分 经理改变 2003-11-06杨国生------- */
        for supuserid_cursor in
        (select distinct t1.id id_1, t2.id id_2 from HrmResource_Trigger t1, CRM_Contract t2
        where managerstr_1 like concat('%,',concat(to_char(t1.id),',%')) and  t2.manager = resourceid_1)
        loop
            supresourceid_1:=supuserid_cursor.id_1;
           cptid_1:=supuserid_cursor.id_2;
            select count(contractid) into countrec from ContractShareDetail where contractid = contractid_1 and
            userid= supresourceid_1 and usertype=1;
            if countrec = 0  then
                insert into ContractShareDetail( contractid, userid, usertype, sharelevel)
                values(contractid_1,supresourceid_1,1,3);
            end if;
        end loop;

        for supuserid_cursor in
        (select distinct t1.id id_1, t3.id id_2 from HrmResource_Trigger t1, CRM_CustomerInfo t2 ,CRM_Contract t3 where managerstr_1
        like concat('%,',concat(to_char(t1.id),',%')) and  t2.manager = resourceid_1  and t2.id = t3.crmId)
        loop
            supresourceid_1:=supuserid_cursor.id_1;
           cptid_1:=supuserid_cursor.id_2;
            select count(contractid) into countrec from ContractShareDetail
            where contractid = contractid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0  then
                insert into ContractShareDetail( contractid, userid, usertype, sharelevel)
                values(contractid_1,supresourceid_1,1,1);
            end if;
        end loop;

      /* for work plan */
    /* added by lupeng 2004-07-22 */
       for  supuserid_cursor in(
        SELECT DISTINCT t1.id  id_1, t2.id  id_2 FROM HrmResource_Trigger t1, WorkPlan t2 WHERE managerstr_1 LIKE concat(concat('%,' , to_char(t1.id)) ,',%') AND t2.createrid = resourceid_1)
        loop
        supresourceid_1 := supuserid_cursor.id_1;
        workPlanId_1 := supuserid_cursor.id_2;
            SELECT COUNT(workid) into countrec  FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = supresourceid_1 AND usertype = 1;
            IF (countrec = 0) then
                INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) values(workPlanId_1, supresourceid_1, 1, 1);
            end if;
       end loop;
    /* end */


    end  if;           /* 有上级经理判定结束 */
end if;  /* 修改经理的判定结束 */
end;
/