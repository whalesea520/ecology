alter table HrmCareerApply add picture integer
/

create or replace  procedure HrmCareerApply_InsertBasic
(id_1 integer,
 lastname_2 varchar2,
 sex_3 char,
 jobtitle_4 integer,
 homepage_5 varchar2,
 email_6 varchar2,
 homeaddress_7 varchar2,
 homepostcode_8 varchar2,
 homephone_9 varchar2,
 inviteid_10 integer,
 picture_11 integer,
flag out integer,
msg  out  varchar2,
thecursor IN OUT cursor_define.weavercursor )
as 
begin
insert into HrmCareerApply
(id,
 lastname,
 sex,
 jobtitle,
 homepage,
 email,
 homeaddress,
 homepostcode,
 homephone,
 careerinviteid,
 picture)
values
(id_1,
 lastname_2,
 sex_3,
 jobtitle_4,
 homepage_5,
 email_6, 
 homeaddress_7,
 homepostcode_8,
 homephone_9,
 inviteid_10,
 picture_11);
 end;
/

create or replace  procedure HrmCareerApply_UpdateBasic
(id_1 integer,
 lastname_2 varchar2,
 sex_3 char,
 jobtitle_4 integer,
 homepage_5 varchar2,
 email_6 varchar2,
 homeaddress_7 varchar2,
 homepostcode_8 varchar2,
 homephone_9 varchar2,
 inviteid_10 integer,
 picture_11 integer,
flag out integer,
msg  out  varchar2,
thecursor IN OUT cursor_define.weavercursor )
as 
begin
Update HrmCareerApply Set
lastname = lastname_2,
sex = sex_3,
jobtitle = jobtitle_4,
homepage = homepage_5,
email = email_6,
homeaddress = homeaddress_7 ,
homepostcode = homepostcode_8,
homephone = homephone_9,
careerinviteid = inviteid_10,
picture = picture_11
WHERE id = id_1;
end;
/