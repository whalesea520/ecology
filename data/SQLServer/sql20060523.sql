update MainMenuInfo set linkAddress='/hrm/career/HrmCareerApply_frm.jsp' where id=96
GO
alter table HrmCareerApply add subCompanyId int
GO

alter procedure HrmCareerApply_InsertBasic
(@id_1 int,
 @lastname_2 varchar(60),
 @sex_3 char(1),
 @jobtitle_4 int,
 @homepage_5 varchar(60),
 @email_6 varchar(60),
 @homeaddress_7 varchar(100),
 @homepostcode_8 varchar(20),
 @homephone_9 varchar(60),
 @inviteid_10 int,
 @picture_11 int,
 @subCompanyId_12 int,
 @flag int output, @msg varchar(60) output)
as insert into HrmCareerApply
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
(@id_1,
 @lastname_2,
 @sex_3,
 @jobtitle_4,
 @homepage_5,
 @email_6, 
 @homeaddress_7,
 @homepostcode_8,
 @homephone_9,
 @inviteid_10,
 @picture_11,
 @subCompanyId_12)
GO

CREATE procedure HrmCareerApply_Init
as 
declare @dftsubcomid_1 integer
delete from HrmCareerApply where id in(select id from HrmCareerApply where id not in(select applyid from HrmCareerApplyOtherInfo))
select @dftsubcomid_1=max(dftsubcomid) from SystemSet
update HrmCareerApply set subcompanyid = @dftsubcomid_1 where subcompanyid=0 or subcompanyid is null
GO

HrmCareerApply_Init
GO
