alter table HrmCareerApply add picture int
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
 picture)
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
 @picture_11)
GO

alter  procedure HrmCareerApply_UpdateBasic
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
 @flag int output, @msg varchar(60) output)
as 

Update HrmCareerApply Set
lastname = @lastname_2,
sex = @sex_3,
jobtitle = @jobtitle_4,
homepage = @homepage_5,
email = @email_6,
homeaddress = @homeaddress_7 ,
homepostcode = @homepostcode_8,
homephone = @homephone_9,
careerinviteid = @inviteid_10,
picture = @picture_11
WHERE id = @id_1
GO