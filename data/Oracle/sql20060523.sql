update MainMenuInfo set linkAddress='/hrm/career/HrmCareerApply_frm.jsp' where id=96
/
alter table HrmCareerApply add subCompanyId integer
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
 subCompanyId_12 int,
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
 picture,
subCompanyId)
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
 picture_11,
 subCompanyId_12);
 end;
/

CREATE or replace procedure HrmCareerApply_Init
as 
dftsubcomid_1 integer;
begin
delete from HrmCareerApply where id in(select id from HrmCareerApply where id not in(select applyid from HrmCareerApplyOtherInfo));
select  max(dftsubcomid) into dftsubcomid_1 from SystemSet;
update HrmCareerApply set subcompanyid = dftsubcomid_1 where subcompanyid=0 or subcompanyid is null;
end;
/

call HrmCareerApply_Init()
/