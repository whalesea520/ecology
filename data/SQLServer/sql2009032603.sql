ALTER table  HrmCareerApplyOtherInfo  ADD test varchar(200)
go
update   HrmCareerApplyOtherInfo set test = salaryneed
go
ALTER table  HrmCareerApplyOtherInfo  drop column salaryneed
go
EXEC   sp_rename   'HrmCareerApplyOtherInfo.[test]',   'salaryneed',   'COLUMN'   
go



ALTER table  HrmCareerApplyOtherInfo  ADD test2 varchar(200)
go
update   HrmCareerApplyOtherInfo set test2 = salarynow
go
ALTER table  HrmCareerApplyOtherInfo  drop column salarynow
go
EXEC   sp_rename   'HrmCareerApplyOtherInfo.[test2]',   'salarynow',   'COLUMN'   
go


ALTER PROCEDURE [HrmCareerApplyOtherIndo_In]
	(@applyid_2 	[int],
	 @category_3 	[char](1),
	 @contactor_4 	[varchar](30),
	 @salarynow_5 	[varchar](200),
	 @worktime_6 	[int],
	 @salaryneed_7 	[varchar](200),
	 @currencyid_8 	[int],
	 @reason_9 	[varchar](200),
	 @otherrequest_10 	[varchar](200),
	 @selfcomment_11 	[text],
        @flag int output, @msg varchar(60) output)
AS INSERT INTO [HrmCareerApplyOtherInfo] 
	 ([applyid],
	 [category],
	 [contactor],
	 [salarynow],
	 [worktime],
	 [salaryneed],
	 [currencyid],
	 [reason],
	 [otherrequest],
	 [selfcomment]) 
 
VALUES 
	(@applyid_2,
	 @category_3,
	 @contactor_4,
	 @salarynow_5,
	 @worktime_6,
	 @salaryneed_7,
	 @currencyid_8,
	 @reason_9,
	 @otherrequest_10,
	 @selfcomment_11)

GO
/*CREATED BY Huang Yu On May 11th,2004 , 应聘其它信息更新*/

ALTER  PROCEDURE [HrmCareerApplyOtherInfo_Upd]
	(@applyid_2 	[int],
	 @category_3 	[char](1),
	 @contactor_4 	[varchar](30),
	 @salarynow_5 	[varchar](200),
	 @worktime_6 	[int],
	 @salaryneed_7 	[varchar](200),
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
