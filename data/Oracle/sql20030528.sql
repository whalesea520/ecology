alter table license add multilanguage char
/
update license set multilanguage='n'
/
alter table license add email char
/
update license set email='n'
/
alter table license add meeting char
/
update license set meeting='n'
/
alter table license add project char
/
update license set project='n'
/
alter table license add crm char
/
update license set crm='n'
/
alter table license add cpt char
/
update license set cpt='n'
/
alter table license add finance char
/
update license set finance='n'
/
alter table license add hrm char
/
update license set hrm='n'
/
alter table license add workflow char
/
update license set workflow='n'
/
alter table license add document char
/
update license set document='n'
/


CREATE OR REPLACE PROCEDURE HrmResourceBasicInfo_Insert 
 (id_1 integer, 
  workcode_2 varchar2, 
  lastname_3 varchar2, 
  sex_5 char, 
  resoureimageid_6 integer, 
  departmentid_7 integer, 
  costcenterid_8 integer, 
  jobtitle_9 integer, 
  joblevel_10 integer, 
  jobactivitydesc_11 varchar2, 
  managerid_12 integer, 
  assistantid_13 integer, 
  status_14 char, 
  locationid_15 integer, 
  workroom_16 varchar2, 
  telephone_17 varchar2, 
  mobile_18 varchar2, 
  mobilecall_19 varchar2 , 
  fax_20 varchar2, 
  jobcall_21 integer, 
    flag	out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
    ) 
AS 
begin
INSERT INTO HrmResource 
(id, 
 workcode, 
 lastname, 
 sex, 
 resourceimageid, 
 departmentid, 
 costcenterid, 
 jobtitle, 
 joblevel, 
 jobactivitydesc, 
 managerid, 
 assistantid, 
 status, 
 locationid, 
 workroom, 
 telephone, 
 mobile, 
 mobilecall, 
 fax, 
 jobcall,
 seclevel) 
VALUES 
(id_1, 
 workcode_2, 
 lastname_3, 
 sex_5, 
 resoureimageid_6, 
 departmentid_7, 
 costcenterid_8, 
 jobtitle_9, 
 joblevel_10, 
 jobactivitydesc_11, 
 managerid_12, 
 assistantid_13, 
 status_14, 
 locationid_15, 
 workroom_16, 
 telephone_17, 
 mobile_18, 
 mobilecall_19, 
 fax_20, 
 jobcall_21,
 0);
end;
/


CREATE OR REPLACE PROCEDURE HrmCareerApply_CreateInfo
(id_1 integer,
createrid_2 integer,
createdate_3 char,
lastmodid_4 integer,
lastmoddate_5 char,
flag	out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as
begin
update HrmCareerApply set
 createrid = createrid_2,
 createdate = createdate_3,
 lastmodid = lastmodid_4,
 lastmoddate = lastmoddate_5
where
 id = id_1;
end;
/



CREATE OR REPLACE PROCEDURE HrmCareerApply_ModInfo
(id_1 integer,
lastmodid_2 integer,
lastmoddate_3 char,
flag	out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
update HrmCareerApply set
 lastmodid = lastmodid_2,
 lastmoddate = lastmoddate_3
where
 id = id_1;
end;
/

CREATE OR REPLACE PROCEDURE HrmResourceMaxId_Get
(
flag	out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
id_1 integer;
begin
select currentid into id_1 from SequenceIndex where indexdesc='resourceid';
update SequenceIndex 
set currentid = id_1+1 where indexdesc='resourceid';
open thecursor for
select id_1 from dual;
end;
/


CREATE OR REPLACE PROCEDURE SequenceIndexRes_Init
as 
id_1 integer;
resid_2 integer;
curid_3 integer;
num integer;
begin

select max(id) into id_1 from HrmResource;
select count(id) into num  from HrmCareerApply;
if num >0 then 
select max(id) into resid_2  from HrmCareerApply;
else resid_2 := 0;
end if;

if( id_1>resid_2) then
curid_3 := id_1+1 ;
else  
curid_3 := resid_2+1 ;
end if;
update SequenceIndex set currentid = curid_3 where indexdesc='resourceid';
end;
/

call SequenceIndexRes_Init()
/
INSERT INTO HtmlLabelInfo(indexid, labelname, languageid)
VALUES (7171, '泛微插件下载', 7)
/         
INSERT  INTO HtmlLabelInfo(indexid, labelname, languageid)
VALUES (7171, 'weaverPlugin_download', 8)
/
INSERT  INTO htmllabelindex(id, indexdesc)
VALUES (7171, '泛微插件下载')
/


CREATE TABLE docReadTag (
	id integer  NOT NULL ,
	userType integer NULL ,
	docid integer NULL ,
	userid integer   NULL ,
	readCount integer NULL 
)
/
create sequence docReadTag_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger docReadTag_Trigger     
before insert on docReadTag                        
for each row                                               
begin                                                      
select docReadTag_id.nextval INTO :new.id from dual;
end;                                                       
/  

CREATE OR REPLACE PROCEDURE docReadTag_SelectByuserid
	(
    docid_1 	integer ,
    userid_2 	integer ,
    userType_3	integer ,
    flag	out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
    )

AS
begin
open thecursor for
select  userid   from docReadTag where docid = docid_1 and userid = userid_2 and userType = userType_3;
end;
/



CREATE OR REPLACE PROCEDURE docDetail_QueryByDocid
	(docid_1 	integer ,
    flag	out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
    )
AS
begin
open thecursor for
select DocSubject,maincategory,docdepartmentid,doccreaterid  from Docdetail where id = docid_1 ;
end;
/




CREATE OR REPLACE PROCEDURE docDetailLog_QueryByDate
	(fromdate_1 	char ,
	 todate_1 	char ,
    flag	out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
    )
AS
begin
open thecursor for
SELECT docid, SUM(readCount) AS COUNT FROM docReadTag where docid in (SELECT docid FROM DocDetailLog WHERE (operatedate >= fromdate_1) AND (operatedate <= todate_1))GROUP BY docid ORDER BY COUNT DESC ;

end;
/


/*谭晓鹏*/


CREATE TABLE DirAccessControlList (
	mainid integer  NOT NULL ,
	dirid integer NOT NULL ,
	dirtype integer NOT NULL ,
	seclevel integer NULL ,
	departmentid integer NULL ,
	roleid integer NULL ,
	rolelevel integer NULL ,
	usertype integer NULL ,
	permissiontype integer NOT NULL ,
	operationcode integer NOT NULL ,
	userid integer NULL 
)
/
create sequence DirAccessControlList_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DirAccessControlList_Trigger
before insert on DirAccessControlList
for each row
begin
select DirAccessControlList_id.nextval into :new.mainid from dual;
end;
/


CREATE TABLE DirAccessPermission (
	dirid integer NOT NULL ,
	dirtype integer NOT NULL ,
	userid integer NOT NULL ,
	usertype integer NOT NULL ,
	createdoc integer NOT NULL ,
	createdir integer NOT NULL ,
	movedoc integer NOT NULL 
)
/

ALTER TABLE DirAccessControlList  ADD  PRIMARY KEY   
	(
		mainid
	) 
/

ALTER TABLE DirAccessPermission  add PRIMARY KEY  
	(
		dirid,
		dirtype,
		userid,
		usertype
	)
/




/*
    2003年6月3日增加
*/

ALTER TABLE DirAccessPermission ADD
    copydoc integer DEFAULT 0 NOT NULL
/


/* 增加一个用户-资源访问许可（仅限存储过程调用） */
CREATE OR REPLACE PROCEDURE Doc_DirAccessPermission_Insert
(
dirid_1 integer,
dirtype_1 integer, 
userid_1 integer,
usertype_1 integer,
operationcode_1 integer)
AS
count_1 integer;
count_num integer;
begin


if operationcode_1 = 0 then

  select count(createdoc) into count_num from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
  if count_num =0 then
      insert into DirAccessPermission(dirid, dirtype, userid, usertype, createdoc, createdir, movedoc, copydoc) values(dirid_1, dirtype_1, userid_1, usertype_1, 1, 0, 0, 0);
  else
      select createdoc into count_1 from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
      update DirAccessPermission set createdoc = (count_1+1) where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
      end if;

elsif operationcode_1 = 1 then

    select count(createdir) into count_num  from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
    if count_num =0 then
        insert into DirAccessPermission(dirid, dirtype, userid, usertype, createdoc, createdir, movedoc, copydoc) values(dirid_1, dirtype_1, userid_1, usertype_1, 0, 1, 0, 0);
    else
        select createdir into count_1  from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
        update DirAccessPermission set createdir = (count_1+1) where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
        end if;
        
elsif operationcode_1 = 2 then
    select count(movedoc) into count_num  from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
    if count_num =0 then
        insert into DirAccessPermission(dirid, dirtype, userid, usertype, createdoc, createdir, movedoc, copydoc) values(dirid_1, dirtype_1, userid_1, usertype_1, 0, 0, 1, 0);
    else
        select movedoc into count_1  from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
        update DirAccessPermission set movedoc = (count_1+1) where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
        end if;

elsif operationcode_1 = 3 then
    select  count(copydoc) into count_num  from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
    if count_num =0 then
        insert into DirAccessPermission(dirid, dirtype, userid, usertype, createdoc, createdir, movedoc, copydoc) values(dirid_1, dirtype_1, userid_1, usertype_1, 0, 0, 0, 1);
    else
        select  copydoc into count_1  from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
        update DirAccessPermission set copydoc = (count_1+1) where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
        end if;
end if;
end;
/


/* 删除一个用户-资源访问许可（仅限存储过程调用） */
CREATE OR REPLACE PROCEDURE Doc_DirAccessPermission_Delete
(
dirid_1 integer,
dirtype_1 integer, 
userid_1 integer,
usertype_1 integer,
operationcode_1 integer)
AS

count_1 integer;
count_num integer;
begin

if operationcode_1 = 0 then
  select count(createdoc) into count_num from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
  if  (count_num > 0)  then    
    select createdoc into count_1 from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
    if (count_1 >0) then
    update DirAccessPermission set createdoc = (count_1-1) where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
    end if;
  end if;

elsif operationcode_1 = 1 then
  select count(createdir) into count_num from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
  if  (count_num >0 )  then
    select createdir into count_1 from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
    if( count_1 >0) then
    update DirAccessPermission set createdir = (count_1-1) where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
    end if;
  end if;

elsif operationcode_1 = 2 then
  select count(movedoc) into count_num from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
  if  (count_num > 0 )  then
    select movedoc into count_1 from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
    if( count_1 >0) then
    update DirAccessPermission set movedoc = (count_1-1) where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
    end if;
  end if;

elsif operationcode_1 = 3 then
  select  count(copydoc) into count_num from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
  if  (count_num >0)  then
    select  copydoc into count_1 from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
    if( count_1 >0) then
    update DirAccessPermission set copydoc = (count_1-1) where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
    end if;
  end if;

end if;
end;
/



/* 以部门＋安全级别的方式增加权限 */
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

for users_cursor in (select distinct id from HrmResource where departmentid = departmentid_1 and seclevel >= seclevel_1)
loop
    userid_1 := users_cursor.id;
    Doc_DirAccessPermission_Insert (dirid_1,dirtype_1,userid_1,0,operationcode_1);

end loop;
end;
/





/* 以角色＋角色级别+安全级别的方式增加权限 */

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

for users_cursor in(select distinct HrmResource.id h_id from HrmResource, HrmRoleMembers 
where roleid = roleid_1 and rolelevel >= rolelevel_1 and HrmResource.id = HrmRoleMembers.resourceid and seclevel >= seclevel_1)
loop
    userid_1 := users_cursor.h_id;
    Doc_DirAccessPermission_Insert (dirid_1,dirtype_1,userid_1,0,operationcode_1);
end loop;

end;
/



/* 以所有人＋安全级别的方式增加权限 */
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

for users_cursor in(select distinct id from HrmResource where seclevel >= seclevel_1)
loop
    userid_1 := users_cursor.id;
    Doc_DirAccessPermission_Insert (dirid_1,dirtype_1,userid_1,0,operationcode_1);
end loop;

end;
/



/* 以用户类型＋安全级别的方式增加权限 */
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

if usertype_1 = 0 then

    for users_cursor in( select distinct id from HrmResource where seclevel >= seclevel_1)
    loop
        userid_1 := users_cursor.id;
        Doc_DirAccessPermission_Insert (dirid_1,dirtype_1,userid_1,0,operationcode_1);
    end loop;
end if;
end;
/




/* 以人力资源的方式增加权限 */
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
Doc_DirAccessPermission_Insert (dirid_1,dirtype_1,userid_1,0,operationcode_1);
end;
/



/* 删除权限 */
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
roleid_1 integer;
rolelevel_1 integer;
seclevel_1 integer;
permissiontype_1 integer;
usertype_1 integer;
mainuserid_1 integer;
userid_1 integer;
count_1 integer;
begin
    for permission_cursor in(select dirid, dirtype, seclevel, departmentid, roleid, rolelevel, usertype, permissiontype, operationcode, userid from DirAccessControlList where mainid = mainid_1)
    loop
        dirid_1 :=permission_cursor.dirid ;
        dirtype_1 :=permission_cursor.dirtype;
        seclevel_1 :=permission_cursor.seclevel;
        departmentid_1 :=permission_cursor.departmentid;
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

        delete from DirAccessControlList where mainid = mainid_1;
    end loop;
end;
/





/* 删除了目录后清理权限 */
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
delete from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1;
end ;
/



/* 删除了用户后清理权限 */
CREATE OR REPLACE PROCEDURE Doc_DirAcl_CPermissionForUser
(
userid_1 integer, 
usertype_1 integer, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
if usertype_1 = 0 then
    delete from DirAccessPermission where userid = userid_1 and usertype = usertype_1;
end if;
end;
/




/* 为单个用户授予所有被权限表允许的权限 */
CREATE OR REPLACE PROCEDURE Doc_DirAcl_GrantUserPermission
(userid_1 integer, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
departmentid_1 integer;
seclevel_1 integer;
mainid_1 integer;
dirid_1 integer;
dirtype_1 integer;
operationcode_1 integer;
isValidUser integer;
roleid_1 integer;
rolelevel_1 integer;
begin
/*  处理和HrmResource表的字段相关的权限判断，此时读出的安全级别也会在后面使用 */

isValidUser := 0 ;
for user_cursor in(select departmentid, seclevel from HrmResource where id = userid_1)
loop
    departmentid_1 := user_cursor.departmentid ;
    seclevel_1 := user_cursor.seclevel;
    isValidUser := 1;
    for permission_cursor in(  select mainid, dirid, dirtype, operationcode from DirAccessControlList 
            where (permissiontype=1 and departmentid=departmentid_1 and seclevel<=seclevel_1) or 
        (permissiontype=3 and seclevel<=seclevel_1) or
        (permissiontype=4 and usertype=0 and seclevel<=seclevel_1) or
        (permissiontype=5 and userid=userid_1))
    loop
        mainid_1 := permission_cursor.mainid;
        dirid_1 := permission_cursor.dirid ;
        dirtype_1 := permission_cursor.dirtype ;
        operationcode_1 := permission_cursor.operationcode;
        Doc_DirAccessPermission_Insert (dirid_1,dirtype_1,userid_1,0,operationcode_1);
    end loop;

end loop;


/* 处理角色相关的权限判断 */

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




/* 为单个用户剥夺所有被权限表允许的权限 */
CREATE OR REPLACE PROCEDURE Doc_DirAcl_DUserPermission
(
userid_1 integer, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
departmentid_1 integer;
seclevel_1 integer;
mainid_1 integer;
dirid_1 integer;
dirtype_1 integer;
operationcode_1 integer;
isValidUser integer;
roleid_1 integer;
rolelevel_1 integer;
begin
/*  处理和HrmResource表的字段相关的权限判断，此时读出的安全级别也会在后面使用 */
isValidUser := 0;
for user_cursor in(select departmentid, seclevel from HrmResource where id = userid_1)
loop
    departmentid_1 :=user_cursor.departmentid;
    seclevel_1:=user_cursor.seclevel;
    isValidUser := 1;
    for permission_cursor in(  select mainid, dirid, dirtype, operationcode from DirAccessControlList     where (permissiontype=1 and departmentid=departmentid_1 and seclevel<=seclevel_1) or         (permissiontype=3 and seclevel<=seclevel_1) or  (permissiontype=4 and usertype=0 and seclevel<=seclevel_1) or   (permissiontype=5 and userid=userid_1))
    loop
    mainid_1 := permission_cursor.mainid;
    dirid_1 :=permission_cursor.dirid;
    dirtype_1 :=permission_cursor.dirtype;
    operationcode_1 := permission_cursor.operationcode;
    Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,0,operationcode_1);
    end loop;
end loop;

/* 处理角色相关的权限判断 */

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




/* 检查是否拥有权限 */
CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermission
(
dirid_1 integer,
dirtype_1 integer,
userid_1 integer,
usertype_1 integer,
seclevel_1 integer, 
operationcode_1 integer, 
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
    if operationcode_1 = 0 then
        select count(createdoc) into count_num from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
        if(count_num >0) then
            select createdoc into count_1 from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
        else count_1 := 0 ;
        end if;    
    elsif operationcode_1 = 1 then
        select count(createdir) into count_num from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
        if(count_num >0) then
            select createdir into count_1 from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
        else count_1 := 0 ;
        end if;          
    elsif operationcode_1 = 2 then
        select count(movedoc) into count_num from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
        if(count_num >0) then
            select movedoc into count_1 from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
        else count_1 := 0 ;
        end if;      
    elsif operationcode_1 = 3 then
        select  count(copydoc) into count_num from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
        if(count_num >0) then
            select  copydoc into count_1 from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1;
        else count_1 := 0 ;
        end if;
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


/* 查找用户拥有权限的主目录 */
CREATE OR REPLACE PROCEDURE Doc_MainCategory_FindByUser 
(
userid_1 integer, 
usertype_1 integer,
operationcode_1 integer, 
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
                select distinct dirid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=2 and createdoc > 0
                )
            )
        )
    order by categoryorder;

elsif operationcode_1 = 1 then
open thecursor for
    select  id   mainid from DocMainCategory where id in (
                select distinct dirid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=0 and createdir > 0
        )
    order by categoryorder;

elsif operationcode_1 = 2 then
open thecursor for
    select id   mainid from DocMainCategory where id in (
                select distinct dirid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=0 and movedoc > 0
        )
    order by categoryorder;

elsif operationcode_1 = 3 then
open thecursor for
    select id   mainid from DocMainCategory where id in (
                select distinct dirid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=0 and copydoc > 0
        )
    order by categoryorder;
end if;
end;
/



/* 查找用户拥有权限的分目录 */
CREATE OR REPLACE PROCEDURE Doc_SubCategory_FindByUser
(
userid_1 integer, 
usertype_1 integer,
operationcode_1 integer, 
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as 
begin

if operationcode_1 = 0 then
open thecursor for
    select distinct subcategoryid mainid from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=2 and createdoc>0);

elsif operationcode_1 = 1 then
open thecursor for
    select distinct dirid mainid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=1 and createdir>0;

elsif operationcode_1 = 2 then
open thecursor for
    select distinct dirid mainid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=1 and movedoc>0;

elsif operationcode_1 = 3 then
open thecursor for
    select distinct dirid mainid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=1 and copydoc>0;
end if;
end;
/


/* 查找用户拥有权限的子目录 */
CREATE OR REPLACE PROCEDURE Doc_SecCategory_FindByUser 
(
userid_1 integer, 
usertype_1 integer,
operationcode_1 integer, 
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as 
begin
if operationcode_1 = 0 then
open thecursor for
    select distinct id mainid from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=2 and createdoc>0);

elsif operationcode_1 = 1 then
open thecursor for
    select distinct id mainid from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=2 and createdir>0);

elsif operationcode_1 = 2 then
open thecursor for
    select distinct id mainid from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=2 and movedoc>0);

elsif operationcode_1 = 3 then
open thecursor for
    select distinct id mainid from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=2 and copydoc>0);
end  if;
end;
/




/* 查找外部用户拥有权限的主目录 */
CREATE OR REPLACE PROCEDURE Doc_MainCategory_FByUser_Out 
(
usertype_1 integer,
seclevel_1 integer,
operationcode_1 integer,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as 
begin
if operationcode_1 = 0 then
open thecursor for
    select  id mainid from DocMainCategory where id in (
        select distinct maincategoryid from DocSubCategory where id in (
            select distinct subcategoryid from DocSecCategory where id in (
                select distinct dirid from DirAccessControlList where dirtype=2 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1))
                )
            )
        )
    order by categoryorder;

elsif (operationcode_1 = 1) or (operationcode_1 = 2) or (operationcode_1 = 3) then
open thecursor for
    select  id mainid from DocMainCategory where id in (
        select distinct dirid from DirAccessControlList where dirtype=0 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1))
        )
    order by categoryorder;
end if;
end;
/




/* 查找外部用户拥有权限的分目录 */
CREATE OR REPLACE PROCEDURE Doc_SubCategory_FindByUser_Out 
(
usertype_1 integer,
seclevel_1 integer,
operationcode_1 integer,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)

as 
begin
if operationcode_1 = 0 then
open thecursor for
    select distinct subcategoryid mainid from DocSecCategory where id in (
        select distinct dirid from DirAccessControlList where dirtype=2 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1))
        );

elsif (operationcode_1 = 1) or (operationcode_1 = 2) or (operationcode_1 = 3) then
open thecursor for
    select distinct id mainid from DocSubCategory where id in (
        select distinct dirid from DirAccessControlList where dirtype=1 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1))
        );
end if;
end;
/



/* 查找外部用户拥有权限的子目录 */
CREATE OR REPLACE PROCEDURE Doc_SecCategory_FindByUser_Out
(
usertype_1 integer, 
seclevel_1 integer, 
operationcode_1 integer, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
select distinct dirid mainid from DirAccessControlList where dirtype=2 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1));
end;
/


/* 根据目录选择权限 */
CREATE OR REPLACE PROCEDURE Doc_DirAcl_SByDirID 
(
dirid_1 integer, 
dirtype_1 integer, 
operationcode_1 integer,
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
open thecursor for
    select * from DirAccessControlList where dirid=dirid_1 and dirtype=dirtype_1 and operationcode=operationcode_1;
end;
/


/* 当用户基本信息发生变化时用来取消权限 */
CREATE OR REPLACE PROCEDURE Doc_DirAcl_DUserP_BasicChange
(
userid_1 integer, 
departmentid_1 integer,
seclevel_1 integer) 
AS

mainid_1 integer;
dirid_1 integer;
dirtype_1 integer;
operationcode_1 integer;
roleid_1 integer;
rolelevel_1 integer;
begin

/* 处理对1,3,4,5类权限的影响 */
for  permission_cursor in(select mainid, dirid, dirtype, operationcode from DirAccessControlList 
where (permissiontype=1 and departmentid=departmentid_1 and seclevel<=seclevel_1) or 
      (permissiontype=3 and seclevel<=seclevel_1) or
      (permissiontype=4 and usertype=0 and seclevel<=seclevel_1) or 
      (permissiontype=5 and userid=userid_1))
loop
    mainid_1 :=permission_cursor.mainid ;
    dirid_1:=permission_cursor.dirid ;
    dirtype_1:=permission_cursor.dirtype ;
    operationcode_1 :=permission_cursor.operationcode ;
    Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,0,operationcode_1);

end loop;


/* 处理对2类权限的影响 */
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





/* 当用户角色发生变化时用来取消相关权限 */
CREATE OR REPLACE PROCEDURE Doc_DirAcl_DUserP_RoleChange
(
userid_1 integer,
roleid_1 integer, 
rolelevel_1 integer,
seclevel_1 integer)
AS
mainid_1 integer;
dirid_1 integer;
dirtype_1 integer;
operationcode_1 integer;
begin
for permission_cursor in(select mainid, dirid, dirtype, operationcode from DirAccessControlList 
where (permissiontype=2 and roleid=roleid_1 and rolelevel<=rolelevel_1 and seclevel<=seclevel_1))
loop
    mainid_1 := permission_cursor.mainid ; 
    dirid_1 := permission_cursor.dirid ; 
    dirtype_1 := permission_cursor.dirtype ; 
    operationcode_1 := permission_cursor.operationcode ; 
    Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,0,operationcode_1);
end loop;
end;
/




/* 当用户基本信息发生变化时用来授予权限 */
CREATE OR REPLACE PROCEDURE Doc_DirAcl_GUserP_BasicChange
(
userid_1 integer, 
departmentid_1 integer, 
seclevel_1 integer)  
AS
mainid_1 integer;
dirid_1 integer;
dirtype_1 integer;
operationcode_1 integer;
roleid_1 integer;
rolelevel_1 integer;
begin
/* 处理对1,3,4,5类权限的影响 */
for permission_cursor in(select mainid, dirid, dirtype, operationcode from DirAccessControlList 
where (permissiontype=1 and departmentid=departmentid_1 and seclevel<=seclevel_1) or 
      (permissiontype=3 and seclevel<=seclevel_1) or
      (permissiontype=4 and usertype=0 and seclevel<=seclevel_1) or 
      (permissiontype=5 and userid=userid_1))
loop
    mainid_1 := permission_cursor.mainid ; 
    dirid_1 := permission_cursor.dirid ; 
    dirtype_1 := permission_cursor.dirtype ; 
    operationcode_1 := permission_cursor.operationcode ; 
    Doc_DirAccessPermission_Insert (dirid_1,dirtype_1,userid_1,0,operationcode_1);
end loop;


/* 处理对2类权限的影响 */ 
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



/* 当用户角色发生变化时用来取消权限 */
CREATE OR REPLACE PROCEDURE Doc_DirAcl_GUserP_RoleChange
(
userid_1 integer,
roleid_1 integer, 
rolelevel_1 integer, 
seclevel_1 integer) 
AS
mainid_1 integer;
dirid_1 integer;
dirtype_1 integer;
operationcode_1 integer;
begin

for permission_cursor in(select mainid, dirid, dirtype, operationcode from DirAccessControlList 
where (permissiontype=2 and roleid=roleid_1 and rolelevel<=rolelevel_1 and seclevel<=seclevel_1))
loop
    mainid_1 := permission_cursor.mainid ; 
    dirid_1 := permission_cursor.dirid ; 
    dirtype_1 := permission_cursor.dirtype ; 
    operationcode_1 := permission_cursor.operationcode ; 
    Doc_DirAccessPermission_Insert (dirid_1,dirtype_1,userid_1,0,operationcode_1);
end loop;
end;
/


/* 从旧表插入数据 */
CREATE OR REPLACE PROCEDURE Doc_DirAcl_InsertFromOldTable
 
as 
secid_1 integer;
usertype_1 integer;
seclevel_1 integer;
department1_1 integer;
dseclevel1_1 integer;
department2_1 integer;
dseclevel2_1 integer;
roleid1_1 integer;
rolelevel1_1 integer;
roleid2_1 integer;
rolelevel2_1 integer;
roleid3_1 integer;
rolelevel3_1 integer;
userid_1 integer;
begin
for oldpermission_cursor in(select id,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3 from DocSecCategory)
loop
    secid_1 := oldpermission_cursor.id;
    usertype_1 := oldpermission_cursor.cusertype;
    seclevel_1 := oldpermission_cursor.cuserseclevel;
    department1_1 := oldpermission_cursor.cdepartmentid1;
    dseclevel1_1:= oldpermission_cursor.cdepseclevel1; 
    department2_1:= oldpermission_cursor.cdepartmentid2;
    dseclevel2_1:= oldpermission_cursor.cdepseclevel2;
    roleid1_1:= oldpermission_cursor.croleid1;
    rolelevel1_1:= oldpermission_cursor.crolelevel1;
    roleid2_1:= oldpermission_cursor.croleid2;
    rolelevel2_1:= oldpermission_cursor.crolelevel2;
    roleid3_1:= oldpermission_cursor.croleid3;
    rolelevel3_1:= oldpermission_cursor.crolelevel3;  

    insert into DirAccessControlList(dirid, dirtype, usertype, seclevel, operationcode, permissiontype) values(secid_1, 2, usertype_1, seclevel_1, 0, 4);
    if usertype_1 = 0 then
    for users_cursor in( select distinct id from HrmResource where seclevel >= seclevel_1)
        loop
            userid_1 := users_cursor.id;
            Doc_DirAccessPermission_Insert (secid_1,2,userid_1,0,0);
        end loop;
    end if;


    if  (department1_1<>0) then
        insert into DirAccessControlList(dirid, dirtype, departmentid, seclevel, operationcode, permissiontype) values(secid_1, 2, department1_1, dseclevel1_1, 0, 1);
        for users_cursor in (select distinct id from HrmResource where departmentid = department1_1 and seclevel >= dseclevel1_1)
        loop
            userid_1 := users_cursor.id;
            Doc_DirAccessPermission_Insert (secid_1,2,userid_1,0,0);
        end loop;
    end if;

    if  (department2_1<>0) then
        insert into DirAccessControlList(dirid, dirtype, departmentid, seclevel, operationcode, permissiontype) values(secid_1, 2, department2_1, dseclevel2_1, 0, 1);
        for users_cursor in (select distinct id from HrmResource where departmentid = department2_1 and seclevel >= dseclevel2_1)
        loop
            userid_1 := users_cursor.id;
            Doc_DirAccessPermission_Insert (secid_1,2,userid_1,0,0);
        end loop;
    end if;

    if  (roleid1_1 <>0) then        
        insert into DirAccessControlList(dirid, dirtype, roleid, rolelevel, seclevel, operationcode, permissiontype) values(secid_1, 2, roleid1_1, rolelevel1_1, 0, 0, 2);

        for users_cursor in(select distinct HrmResource.id h_id from HrmResource, HrmRoleMembers 
        where roleid = roleid1_1 and rolelevel >= rolelevel1_1 and HrmResource.id = HrmRoleMembers.resourceid and seclevel >= 0)
        loop
            userid_1 := users_cursor.h_id;
            Doc_DirAccessPermission_Insert (secid_1,2,userid_1,0,0);
        end loop;
    end if;

    if  (roleid2_1<>0) then           
        insert into DirAccessControlList(dirid, dirtype, roleid, rolelevel, seclevel, operationcode, permissiontype) values(secid_1, 2, roleid2_1, rolelevel2_1, 0, 0, 2);

        for users_cursor in(select distinct HrmResource.id h_id from HrmResource, HrmRoleMembers 
        where roleid = roleid2_1 and rolelevel >= rolelevel2_1 and HrmResource.id = HrmRoleMembers.resourceid and seclevel >= 0)
        loop
            userid_1 := users_cursor.h_id;
            Doc_DirAccessPermission_Insert (secid_1,2,userid_1,0,0);
        end loop;
    end if;

    if  (roleid3_1<>0) then        
        insert into DirAccessControlList(dirid, dirtype, roleid, rolelevel, seclevel, operationcode, permissiontype) values(secid_1, 2, roleid3_1, rolelevel3_1, 0, 0, 2);

        for users_cursor in(select distinct HrmResource.id h_id from HrmResource, HrmRoleMembers 
        where roleid = roleid3_1 and rolelevel >= rolelevel3_1 and HrmResource.id = HrmRoleMembers.resourceid and seclevel >= 0)
        loop
            userid_1 := users_cursor.h_id;
            Doc_DirAccessPermission_Insert (secid_1,2,userid_1,0,0);
        end loop;
    end if;

end loop;
end;
/


call Doc_DirAcl_InsertFromOldTable()
/



insert into htmllabelinfo values(7175, '部门＋安全级别', 7)
/
insert into htmllabelinfo values(7175, 'department+security level', 8)
/
insert into htmllabelinfo values(7176, '角色＋安全级别＋级别', 7)
/
insert into htmllabelinfo values(7176, 'role+security level+role level', 8)
/
insert into htmllabelinfo values(7177, '安全级别', 7)
/
insert into htmllabelinfo values(7177, 'security level', 8)
/
insert into htmllabelinfo values(7178, '用户类型＋安全级别', 7)
/
insert into htmllabelinfo values(7178, 'usertype+security level', 8)
/
insert into htmllabelinfo values(7179, '用户类型', 7)
/
insert into htmllabelinfo values(7179, 'usertype', 8)
/

/* 修改hrmresource的trigger */



/*trigger*/




/* 对于人力资源表的更新 */
CREATE or REPLACE  TRIGGER Tri_Update_HrmresourceShare 
after  update  ON Hrmresource 
FOR each row

Declare resourceid_1 integer;
		subresourceid_1 integer;
		supresourceid_1 integer;
		olddepartmentid_1 integer;
		departmentid_1 integer;
		subcompanyid_1 integer;
		oldseclevel_1	 integer;
		seclevel_1	 integer;
		docid_1	 integer;
		crmid_1	 integer;
		prjid_1	 integer;
		cptid_1	 integer;
		sharelevel_1  integer;
		countrec      integer;
		countdelete   integer;
		oldmanagerstr_1    varchar2(200);
		managerstr_1    varchar2(200);
		managerstr_11 varchar2(200) ;
		mainid_1	integer;
		subid_1	integer;
		secid_1	integer;
		members_1 varchar2(200);

begin
        
/* 从刚修改的行中查找修改的resourceid 等 */

 olddepartmentid_1 := :old.departmentid;
 oldseclevel_1 := :old.seclevel ; 
 oldmanagerstr_1 := :old.managerstr;
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




/* 如果部门和安全级别信息被修改(在新建的时候这两个信息肯定被修改) */
  
if ( departmentid_1 <>olddepartmentid_1 or  seclevel_1 <> oldseclevel_1 or oldseclevel_1 is null )  then   
 
    if departmentid_1 is null   then
	departmentid_1 := 0;
	end if;
    if subcompanyid_1 is null   then
	subcompanyid_1 := 0;
	end if;


    /* 修改目录许可表 */
    if ((olddepartmentid_1 is not null) and (oldseclevel_1 is not null)) then
        Doc_DirAcl_DUserP_BasicChange (resourceid_1, olddepartmentid_1, oldseclevel_1);
    end if;
    if ((departmentid_1 is not null) and (seclevel_1 is not null)) then
        Doc_DirAcl_GUserP_BasicChange (resourceid_1, departmentid_1, seclevel_1);
    end if;


    /* 该人新建文档目录的列表 */
    


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

    /* DOC 部分*/
	
    /* 删除原有的该人的所有文档共享信息 */
	delete from DocShareDetail where userid = resourceid_1 and usertype = 1;



    /*  将所有的信息现放到 temptablevalue 中 */
    /*  自己创建的或者是 owner 的文章可以编辑 */
    for docid_cursor IN (select distinct id from DocDetail where ( doccreaterid = resourceid_1 or ownerid = resourceid_1 ) and usertype= '1')
	loop
	docid_1 := docid_cursor.id;
	insert into temptablevalue values(docid_1, 2);
	end loop;




    /* 自己下级的文档 */
    /* 查找下级 */
 
     managerstr_11 := concat( concat('%,' , to_char(resourceid_1)) , ',%'); 

    for subdocid_cursor IN ( select distinct id from DocDetail where ( doccreaterid in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) or ownerid in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ) and usertype= '1')
	loop
	docid_1 :=subdocid_cursor.id;
	     select  count(docid) INTO countrec  from temptablevalue where docid = docid_1;
        if countrec = 0 then
		insert into temptablevalue values(docid_1, 1);
		end if;
	end loop;
         


    /* 由文档的共享获得的权利 , 将共享分成两个部分, 角色共享一个部分.其它一个部分,否则查询太慢*/
    for  sharedocid_cursor IN (select distinct docid , sharelevel from DocShare  where  (foralluser=1 and seclevel<= seclevel_1 )  or ( userid= resourceid_1 ) or (departmentid= departmentid_1 and seclevel<= seclevel_1 ))
	loop 
	docid_1:=sharedocid_cursor.docid;
	sharelevel_1 :=sharedocid_cursor.sharelevel;
        select  count(docid) INTO countrec  from temptablevalue where docid = docid_1  ;
        if countrec = 0  then        
            insert into temptablevalue values(docid_1, sharelevel_1);        
        else if sharelevel_1 = 2  then        
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* 共享是可以编辑, 则都修改原有记录    */ end if;  
        end if;
	end loop;
    


    for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.docid and t3.resourceid= resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and t1.docdepartmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= subcompanyid_1 ) or (t3.rolelevel=2) ))
    loop
	docid_1 :=sharedocid_cursor.docid;
	sharelevel_1 :=sharedocid_cursor.sharelevel;
	select  count(docid) INTO countrec  from temptablevalue where docid = docid_1  ;
        if countrec = 0  then
        
            insert into temptablevalue values(docid_1, sharelevel_1);
        
        else if sharelevel_1 = 2  then        
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* 共享是可以编辑, 则都修改原有记录    */ end if;  
        end if;
	end loop;


 



    /* 将临时表中的数据写入共享表 */
    for alldocid_cursor IN (select * from temptablevalue)
	loop
	docid_1 :=alldocid_cursor.docid;
	sharelevel_1 := alldocid_cursor.sharelevel;
	insert into docsharedetail values(docid_1, resourceid_1,1,sharelevel_1);
	end loop;
    



    /* ------- CRM  部分 ------- */


    /* 删除原有的该人的所有客户共享信息 */
	delete from CrmShareDetail where userid = resourceid_1 and usertype = 1;



    /*  将所有的信息现放到 temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    for crmid_cursor IN (select id from CRM_CustomerInfo where manager = resourceid_1 )
	loop
	crmid_1 :=crmid_cursor.id;
	insert into temptablevaluecrm values(crmid_1, 2);
	end loop;
    

    /* 自己下级的客户 3 */
    /* 查找下级 */
     
     managerstr_11 := concat( concat('%,' , to_char(resourceid_1)) , ',%' );

    for subcrmid_cursor IN (select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ))
	loop
	crmid_1 :=subcrmid_cursor.id;
        select count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0 then
		insert into temptablevaluecrm values(crmid_1, 3);
		end if;
	end loop;
    

 
    /* 作为crm管理员能看到的客户 */
    for rolecrmid_cursor IN (   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	crmid_1:=rolecrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0 then
		insert into temptablevaluecrm values(crmid_1, 4);
		end if;
	end loop;




    /* 由客户的共享获得的权利 1 2 */
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



    /* 将临时表中的数据写入共享表 */
    for allcrmid_cursor IN (select * from temptablevaluecrm)
	loop
	crmid_1 :=allcrmid_cursor.crmid;
	sharelevel_1 := allcrmid_cursor.sharelevel;
	insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(crmid_1, resourceid_1,1,sharelevel_1);
	end loop;





    /* ------- PROJ 部分 ------- */



    /*  将所有的信息现放到 temptablevaluePrj 中 */
    /*  自己的项目2 */
    for prjid_cursor IN (select id from Prj_ProjectInfo where manager = resourceid_1 )
	loop
	prjid_1:=prjid_cursor.id;
	insert into temptablevaluePrj values(prjid_1, 2);
	end loop;
    



    /* 自己下级的项目3 */
    /* 查找下级 */
     
     managerstr_11 :=  concat(concat('%,' , to_char(resourceid_1)) , ',%' );

    for subprjid_cursor IN (select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ))
	loop
	prjid_1 :=subprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 3);
		end if;
	end loop;

    
 
    /* 作为项目管理员能看到的项目4 */
    for roleprjid_cursor IN (   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	prjid_1 :=roleprjid_cursor.id;
        select count(prjid) INTO  countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 4);
		end if;
	end loop;

	 


    /* 由项目的共享获得的权利 1 2 */
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
        end	if;
		end loop;





    /* 项目成员5 (内部用户) */
	members_1 := concat(concat('%,' , to_char(resourceid_1)), ',%' );
    for inuserprjid_cursor IN (  SELECT  id FROM Prj_ProjectInfo   WHERE  ( concat(concat(',',members),',')  LIKE  members_1)  and isblock='1'  )
	loop
	prjid_1 :=inuserprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluePrj values(prjid_1, 5);
        end	if;
	end loop;




    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allprjid_cursor IN (select * from temptablevaluePrj)
	loop
	prjid_1 :=allprjid_cursor.prjid;
	sharelevel_1 :=allprjid_cursor.sharelevel;
       insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(prjid_1, resourceid_1,1,sharelevel_1);
	end loop;



    /* ------- CPT 部分 ------- */



    /*  将所有的信息现放到 temptablevalueCpt 中 */
    /*  自己的资产2 */
    for cptid_cursor IN (select id from CptCapital where resourceid = resourceid_1 )
	loop
	cptid_1 :=cptid_cursor.id;
	insert into temptablevalueCpt values(cptid_1, 2);
	end loop;
    

    /* 自己下级的资产1 */
    /* 查找下级 */
     
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

    

 
   
    /* 由资产的共享获得的权利 1 2 */
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




    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allcptid_cursor IN (select * from temptablevalueCpt)
	loop
	cptid_1 :=allcptid_cursor.cptid;
	sharelevel_1 := allcptid_cursor.sharelevel;
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1, resourceid_1,1,sharelevel_1);
	end loop;

    




end if;       /* 结束修改了部门和安全级别的情况 */
            

       
/* 对于修改了经理字段,新的所有上级增加对该下级的文档共享,共享级别为可读 */
if ( countdelete > 0 and managerstr_1 <> oldmanagerstr_1 )  then /* 新建人力资源时候对经理字段的改变不考虑 */

    if ( managerstr_1 is not null and length(managerstr_1) > 1 ) then /* 有上级经理 */
     

         managerstr_1 := concat( ',' , managerstr_1);

	/* ------- DOC 部分 ------- */
        for supuserid_cursor in(select distinct t1.id id_1 , t2.id id_2 from HrmResource_Trigger t1, DocDetail t2 where managerstr_1 like concat(concat('%,',to_char(t1.id)),',%') and ( t2.doccreaterid = resourceid_1 or t2.ownerid = resourceid_1 ) and t2.usertype= '1' )
		loop
		supresourceid_1:= supuserid_cursor.id_1;
		docid_1 := supuserid_cursor.id_2;
            select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid= supresourceid_1 and usertype= 1 ;
            if countrec = 0  then
            
                insert into docsharedetail values(docid_1,supresourceid_1,1,1);
            end if;
		end loop;

	
	/* ------- CRM 部分 ------- */
        for supuserid_cursor IN (select distinct t1.id  id_1, t2.id id_2 from HrmResource_Trigger t1, CRM_CustomerInfo t2 where managerstr_1 like concat(concat('%,',to_char(t1.id)),',%') and  t2.manager = resourceid_1  )
		loop
		supresourceid_1:= supuserid_cursor.id_1;
		crmid_1 := supuserid_cursor.id_2;
            select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0 then
            
                insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(crmid_1,supresourceid_1,1,3);
            end if;
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
		for supuserid_cursor IN (      select distinct  t1.id  id_1, t2.id id_2 from HrmResource_Trigger t1, CptCapital t2 where managerstr_1 like concat(concat('%,',to_char(t1.id)),',%') and  t2.resourceid = resourceid_1  )
		loop
		supresourceid_1:=supuserid_cursor.id_1;
		cptid_1 :=supuserid_cursor.id_2;
		    select  count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0  then
            
                insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1,supresourceid_1,1,1);
            end if;
		end loop;

    end  if;           /* 有上级经理判定结束 */
end if;  /* 修改经理的判定结束 */            
end ;
/





/* 对于角色表的更新 */
CREATE or REPLACE TRIGGER Tri_Update_HrmRoleMembersShare
after insert or update or delete ON  HrmRoleMembers
FOR each row
Declare roleid_1 integer;
        resourceid_1 integer;
        oldrolelevel_1 char(1);
        rolelevel_1 char(1);
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
		managerstr_11 varchar2(200); 
        oldroleid_1 integer;
        oldresourceid_1 integer;
        
/* 某一个人加入一个角色或者在角色中的级别升高进行处理,这两种情况都是增加了共享的范围,不需要删除
原有共享信息,只需要判定增加的部分, 对于在角色中级别的降低或者删除某一个成员,只能删除全部共享细节,从作人力资源一个
人的部门或者安全级别改变的操作 */
begin
countdelete := :old.id;
countinsert := :new.id;
oldrolelevel_1 := :old.rolelevel;
oldroleid_1 :=  :old.roleid; 
oldresourceid_1 := :old.resourceid;

if countinsert > 0 then
	roleid_1 := :new.roleid;
	resourceid_1 := :new.resourceid;
	rolelevel_1 := :new.rolelevel;
else 
	roleid_1 := :old.roleid;
	resourceid_1 := :old.resourceid;
	rolelevel_1 := :old.rolelevel;
end if;


/* 如果有删除原有数据，则将许可表中的权限许可数减一 */
if (countdelete > 0) then
    select seclevel into seclevel_1  from hrmresource where id = oldresourceid_1 ;
    if seclevel_1 is not null then
        Doc_DirAcl_DUserP_RoleChange (oldresourceid_1, oldroleid_1, oldrolelevel_1, seclevel_1);
    end if;
end if;
/* 如果有增加新数据，则将许可表中的权限许可数加一 */
if (countinsert > 0) then
    select  seclevel into seclevel_1 from hrmresource where id = resourceid_1;
    if seclevel_1 is not null then
        Doc_DirAcl_GUserP_RoleChange (resourceid_1, roleid_1, rolelevel_1, seclevel_1);
    end if;
end if;


if ( countinsert >0 and ( countdelete = 0 or rolelevel_1  > oldrolelevel_1 ) )  then   

    select  departmentid ,  subcompanyid1 ,  seclevel INTO  departmentid_1 ,subcompanyid_1 ,seclevel_1 
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null  then
	departmentid_1 := 0;
	end if;
    if subcompanyid_1 is null  then
	subcompanyid_1 := 0;
	end if;


    if rolelevel_1 = '2'   then    /* 新的角色级别为总部级 */
     

	/* ------- DOC 部分 ------- */

        for sharedocid_cursor IN (select distinct docid , sharelevel from DocShare where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
        
        loop 
			docid_1 := sharedocid_cursor.docid ;
			sharelevel_1 := sharedocid_cursor.sharelevel;
            select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then            
                insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);
            else if sharelevel_1 = 2 then            
                update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
				end if;
			end if;
        end loop;



	/* ------- CRM 部分 ------- */

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
		end loop;
	   


	/* ------- PROJ 部分 ------- */

		for shareprjid_cursor IN (      select distinct relateditemid , sharelevel from Prj_ShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		prjid_1 := shareprjid_cursor.relateditemid;
		sharelevel_1 := shareprjid_cursor.sharelevel;
            select count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
             
            else if sharelevel_1 = 2  then
            
                update PrjShareDetail set sharelevel = 2 where prjid=prjid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
	
  



	/* ------- CPT 部分 ------- */

		for sharecptid_cursor IN (select distinct relateditemid , sharelevel from CptCapitalShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		cptid_1 :=sharecptid_cursor.relateditemid;
		sharelevel_1 :=sharecptid_cursor.sharelevel;
            select count(cptid) INTO  countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2 then 
            
                update CptShareDetail set sharelevel = 2 where cptid=cptid_1 and userid = resourceid_1 and usertype = 1;  /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
    end if;

    if rolelevel_1 = '1' then        /* 新的角色级别为分部级 */
    

	/* ------- DOC 部分 ------- */
		for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2 ,
		hrmdepartment  t4 where t1.id=t2.docid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and
		t2.seclevel <= seclevel_1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= subcompanyid_1)
		
		loop 
			docid_1 := sharedocid_cursor.docid;
			sharelevel_1 := sharedocid_cursor.sharelevel;
			select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid = resourceid_1 and usertype = 1 ; 
			if countrec = 0  then            
				insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);            
			else if sharelevel_1 = 2  then            
				update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
			end if;
			end if;
		end loop;


	/* ------- CRM 部分 ------- */
       for sharecrmid_cursor IN (      select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department = t4.id and t4.subcompanyid1= subcompanyid_1)
	   loop
	   crmid_1 :=sharecrmid_cursor.relateditemid;
	   sharelevel_1 :=sharecrmid_cursor.sharelevel;
            select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CrmShareDetail set sharelevel = 2 where crmid = crmid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
	   end loop;

  

	/* ------- PRJ 部分 ------- */

		for shareprjid_cursor IN (        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department=t4.id and t4.subcompanyid1= subcompanyid_1)
		loop
		prjid_1 := shareprjid_cursor.relateditemid;
		sharelevel_1 :=shareprjid_cursor.sharelevel;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update PrjShareDetail set sharelevel = 2 where prjid=prjid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
	

      

	/* ------- CPT 部分 ------- */

		for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1)
		loop
		cptid_1 :=sharecptid_cursor.relateditemid;
		sharelevel_1 :=sharecptid_cursor.sharelevel;
            select  count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CptShareDetail set sharelevel = 2 where cptid=cptid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;

    end if;
    if rolelevel_1 = '0'     then     /* 为新建时候设定级别为部门级 */
    

        /* ------- DOC 部分 ------- */

		for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2
		where t1.id=t2.docid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <=
		seclevel_1 and t1.docdepartmentid= departmentid_1)
		
		loop 
			docid_1 := sharedocid_cursor.docid ;
			sharelevel_1 := sharedocid_cursor.sharelevel ;
			select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid =
			resourceid_1 and usertype = 1  ;
			if countrec = 0  then            
				insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);            
			else if sharelevel_1 = 2  then            
				update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and
				usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
			end if;
			end if;
		end loop;
	
	/* ------- CRM 部分 ------- */

		for sharecrmid_cursor IN (select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department = departmentid_1)
		loop
		crmid_1 :=sharecrmid_cursor.relateditemid;
		sharelevel_1 :=sharecrmid_cursor.sharelevel;
          select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CrmShareDetail set sharelevel = 2 where crmid = crmid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
        
  

	/* ------- PRJ 部分 ------- */

		for shareprjid_cursor IN (       select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department= departmentid_1)
		loop
		prjid_1 :=shareprjid_cursor.relateditemid;
		sharelevel_1 := shareprjid_cursor.sharelevel;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update PrjShareDetail set sharelevel = 2 where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
 


	/* ------- CPT 部分 ------- */

		for sharecptid_cursor IN (       select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.departmentid= departmentid_1)
		loop
		 cptid_1 :=sharecptid_cursor.relateditemid;
		 sharelevel_1 := sharecptid_cursor.sharelevel;
            select count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CptShareDetail set sharelevel = 2 where cptid = cptid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;    

    end if;


else if ( countdelete > 0 and ( countinsert = 0 or rolelevel_1  < oldrolelevel_1 ) )  then 
/* 当为删除或者级别降低 */


    select  departmentid ,  subcompanyid1 ,  seclevel INTO departmentid_1 ,subcompanyid_1 ,seclevel_1 
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null then
	departmentid_1 := 0;
    end if;
	if subcompanyid_1 is null then
	subcompanyid_1 := 0;
	end if;
	
    /* 删除原有的该人的所有文档共享信息 */
	delete from DocShareDetail where userid = resourceid_1 and usertype = 1;


    /*  将所有的信息现放到 temptablevalue 中 */
    /*  自己创建的或者是 owner 的文章可以编辑 */
    for docid_cursor IN (select distinct id from DocDetail where ( doccreaterid = resourceid_1 or ownerid = resourceid_1 ) and usertype= '1')
    
    loop 
		docid_1 := docid_cursor.id;
        insert into temptablevalue values(docid_1, 2);
    end loop;



    /* 自己下级的文档 */
    /* 查找下级 */
    managerstr_11 := concat( concat('%,' , to_char(resourceid_1)) , ',%' );

    for subdocid_cursor IN (select distinct id from DocDetail where ( doccreaterid in (select distinct id from
	HrmResource where concat(',' , managerstr) like managerstr_11 ) or ownerid in (select distinct id from
	HrmResource where concat(',' , managerstr) like managerstr_11 ) ) and usertype= '1')
    
    loop
		docid_1 := subdocid_cursor.id;
        select  count(docid) INTO countrec  from temptablevalue where docid = docid_1;
        if countrec = 0 then
		insert into temptablevalue values(docid_1, 1);
		end if;
    end loop;
         
         


    /* 由文档的共享获得的权利 , 将共享分成两个部分, 角色共享一个部分.其它一个部分,否则查询太慢*/
    for sharedocid_cursor IN (select distinct docid , sharelevel from DocShare  where  (foralluser=1 and
	seclevel<= seclevel_1 )  or ( userid= resourceid_1 ) or (departmentid= departmentid_1 and seclevel<=
	seclevel_1 ))
    
    loop 
		docid_1 :=sharedocid_cursor.docid;
		sharelevel_1 :=sharedocid_cursor.sharelevel;
        select count(docid) INTO countrec  from temptablevalue where docid = docid_1  ;
        if countrec = 0  then        
            insert into temptablevalue values(docid_1, sharelevel_1);        
        else if sharelevel_1 = 2  then        
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* 共享是可以编辑, 则都修改原有记录    */
        end if;
		end if;
    end loop;

    for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2, 
	HrmRoleMembers  t3 , hrmdepartment t4 where t1.id=t2.docid and t3.resourceid= resourceid_1 and
	t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and
	t1.docdepartmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1=
	subcompanyid_1 ) or (t3.rolelevel=2) ))

    loop
		docid_1 :=sharedocid_cursor.docid ;
		sharelevel_1 := sharedocid_cursor.sharelevel ;
        select  count(docid) INTO countrec  from temptablevalue where docid = docid_1 ; 
        if countrec = 0  then        
            insert into temptablevalue values(docid_1, sharelevel_1);        
        else if sharelevel_1 = 2  then        
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* 共享是可以编辑, 则都修改原有记录    */
			end if;
		end if;
    end loop ;

    /* 将临时表中的数据写入共享表 */
    for alldocid_cursor IN (select * from temptablevalue)    
    loop 
		docid_1 := alldocid_cursor.docid;
		sharelevel_1 := alldocid_cursor.sharelevel;
        insert into docsharedetail values(docid_1, resourceid_1,1,sharelevel_1);
    end loop;

    /* ------- CRM  部分 ------- */


    /* 删除原有的该人的所有客户共享信息 */
	delete from CrmShareDetail where userid = resourceid_1 and usertype = 1;



    /*  将所有的信息现放到 temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    for crmid_cursor IN (   select id from CRM_CustomerInfo where manager = resourceid_1 )
	loop
	crmid_1 := crmid_cursor.id;
	insert into temptablevaluecrm values(crmid_1, 2);
	end loop;
 


    /* 自己下级的客户 3 */
    /* 查找下级 */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)) , ',%' );

    for subcrmid_cursor IN (  select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
	loop
	crmid_1 :=  subcrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0  then
		insert into temptablevaluecrm values(crmid_1, 3);
		end if;
	end loop;
  

 
    /* 作为crm管理员能看到的客户 */
    for rolecrmid_cursor IN (   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	crmid_1 := rolecrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0 then
		insert into temptablevaluecrm values(crmid_1, 4);
		end if;
	end loop;



    /* 由客户的共享获得的权利 1 2 */
    for sharecrmid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid = departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	crmid_1:= sharecrmid_cursor.relateditemid;
	sharelevel_1 :=sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
	end loop;






    for sharecrmid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department = departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ) )
	loop
	crmid_1 :=sharecrmid_cursor.relateditemid;
	sharelevel_1 := sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
	end loop;




    /* 将临时表中的数据写入共享表 */
    for allcrmid_cursor IN (    select * from temptablevaluecrm)
	loop
	crmid_1 :=allcrmid_cursor.crmid;
	sharelevel_1  := allcrmid_cursor.sharelevel;
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(crmid_1, resourceid_1,1,sharelevel_1);
	end loop;





    /* ------- PROJ 部分 ------- */



    /*  将所有的信息现放到 temptablevaluePrj 中 */
    /*  自己的项目2 */
    for prjid_cursor IN (select id from Prj_ProjectInfo where manager = resourceid_1 )
	loop
	prjid_1 := prjid_cursor.id;
      insert into temptablevaluePrj values(prjid_1, 2);
	end loop;



    /* 自己下级的项目3 */
    /* 查找下级 */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );

    for subprjid_cursor IN (    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like managerstr_11 ) ))
	loop
	prjid_1 :=subprjid_cursor.id;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 3);
		end if;
	end loop;


 
    /* 作为项目管理员能看到的项目4 */
    for roleprjid_cursor IN (   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	prjid_1:=roleprjid_cursor.id;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 4);
		end if;
	end loop;

	 


    /* 由项目的共享获得的权利 1 2 */
    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	prjid_1 := shareprjid_cursor.relateditemid;
	sharelevel_1 :=  shareprjid_cursor.sharelevel;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
	end loop;



    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and  t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department=departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ) 
    
	)
	loop
	prjid_1 := shareprjid_cursor.relateditemid;
	sharelevel_1 := shareprjid_cursor.sharelevel;
        select  count(prjid) INTO countrec from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0 then 
        
            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
	end loop;

	

    /* 项目成员5 (内部用户) */
    for inuserprjid_cursor IN (    SELECT distinct t2.id FROM Prj_TaskProcess  t1,Prj_ProjectInfo  t2 WHERE  t1.hrmid =resourceid_1 and t2.id=t1.prjid and t1.isdelete<>'1' and t2.isblock='1' )
	loop
	prjid_1 :=inuserprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1 ; 
        if countrec = 0  then
        
            insert into temptablevaluePrj values(prjid_1, 5);
        end if;
	end loop;



    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allprjid_cursor IN (select * from temptablevaluePrj)
	loop
	prjid_1 := allprjid_cursor.prjid;
	sharelevel_1 := allprjid_cursor.sharelevel;
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(prjid_1, resourceid_1,1,sharelevel_1);
	end loop;
    



    /* ------- CPT 部分 ------- */


    /*  将所有的信息现放到 temptablevalueCpt 中 */
    /*  自己的资产2 */
    for cptid_cursor IN (    select id from CptCapital where resourceid = resourceid_1 )
	loop
	cptid_1 := cptid_cursor.id;
	  insert into temptablevalueCpt values(cptid_1, 2);
	end loop;





    /* 自己下级的资产1 */
    /* 查找下级 */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );

    for subcptid_cursor IN ( select id from CptCapital where ( resourceid in (select distinct id from HrmResource where ','+managerstr like managerstr_11 ) ))
	loop
	cptid_1 := subcptid_cursor.id;
        select  count(cptid) INTO countrec  from temptablevalueCpt where cptid = cptid_1;
        if countrec = 0 then
		insert into temptablevalueCpt values(cptid_1, 1);
		end if;
	end loop;

 
   
    /* 由资产的共享获得的权利 1 2 */
    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	cptid_1 := sharecptid_cursor.relateditemid;
	sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then
        
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end if;
	end loop;




    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1 ) or (t3.rolelevel=2) ))
	loop
	cptid_1 := sharecptid_cursor.relateditemid;
	sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then
        
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end    if;
	end loop;

    


    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allcptid_cursor IN (select * from temptablevalueCpt)
	loop
	cptid_1 :=allcptid_cursor.cptid;
	sharelevel_1 :=allcptid_cursor.sharelevel;
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1, resourceid_1,1,sharelevel_1);
	end loop;	

	end if;
end if; /* 结束角色删除或者级别降低的处理 */
end ;
/

