/*For Bug 256*/

INSERT INTO HtmlLabelIndex values(17370,'曾任职务') 
GO
INSERT INTO HtmlLabelInfo VALUES(17370,'曾任职务',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17370,'the former position',8) 
GO


/*CREATED BY Huang Yu On May 11th,2004 , 应聘 基本信息更新*/
Create  procedure HrmCareerApply_UpdateBasic
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
careerinviteid = @inviteid_10
WHERE id = @id_1

GO
/*CREATED BY Huang Yu On May 11th,2004 , 应聘其它信息更新*/

CREATE  PROCEDURE [HrmCareerApplyOtherInfo_Upd]
	(@applyid_2 	[int],
	 @category_3 	[char](1),
	 @contactor_4 	[varchar](30),
	 @salarynow_5 	[varchar](60),
	 @worktime_6 	[varchar](10),
	 @salaryneed_7 	[varchar](60),
	 @currencyid_8 	[int],
	 @reason_9 	[varchar](200),
	 @otherrequest_10 	[varchar](200),
	 @selfcomment_11 	[text],
         @flag int output, @msg varchar(60) output)
AS 

UPDATE [HrmCareerApplyOtherInfo] SET
	 [category] =@category_3,
	 [contactor]=@contactor_4,
	 [salarynow]=@salarynow_5,
	 [worktime]=@worktime_6,
	 [salaryneed]=@salaryneed_7,
	 [currencyid]=@currencyid_8,
	 [reason]=@reason_9,
	 [otherrequest]=@otherrequest_10,
	 [selfcomment]= @selfcomment_11
WHERE applyid = @applyid_2
 

GO

/*For Bug 266*/
ALTER  PROCEDURE [HrmInterviewResult_Insert]
	(@resourceid_1 	[int],
	 @stepid_2 	[int],
	 @result_3 	int,
	 @remark_4 	text,
	 @userid_5 	int,
	 @testdate_6 	char(10),
	 @flag int output, @msg varchar(60) output)
AS INSERT INTO [HrmInterviewResult] 
	 ([resourceid],
	 [stepid],
	 [result],
	 [remark],
	 [tester],
	 [testdate])
VALUES 
	(@resourceid_1,
	 @stepid_2,
	 @result_3,
	 @remark_4,
	 @userid_5,
	 @testdate_6)

update HrmInterview set 
  status = 1 WHERE ResourceID=@resourceid_1 and StepID = @stepid_2

GO

/*FOR BUG 256,更改字段height的类型为decimal  
  Oracle 中不能直接修改字段类型，除非该字段数据全为empty
*/
UPDATE HrmCareerApply SET height='0' where height=''
GO
ALTER TABLE HrmCareerApply
	Alter column height decimal(38,2)
go


