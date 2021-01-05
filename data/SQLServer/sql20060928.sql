INSERT INTO HtmlLabelIndex values(19756,'速算扣除数') 
GO
INSERT INTO HtmlLabelInfo VALUES(19756,'速算扣除数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19756,'Subtract Number',8) 
GO
alter table HrmSalaryTaxrate add subtractnum int
go


ALTER  PROCEDURE HrmSalaryTaxrate_Insert
	(@benchid_1 	int,
	 @ranknum_2 	int,
	 @ranklow_3 	int,
	 @rankhigh_4 	int,
	 @taxrate_5 	int,
     @subtractnum_6 	int,
     @flag          integer output, 
     @msg           varchar(80) output)

AS INSERT INTO HrmSalaryTaxrate 
	 ( benchid,
	 ranknum,
	 ranklow,
	 rankhigh,
	 taxrate,
     subtractnum) 
 
VALUES 
	( @benchid_1,
	 @ranknum_2,
	 @ranklow_3,
	 @rankhigh_4,
	 @taxrate_5,
     @subtractnum_6)

GO