alter PROCEDURE FnaLoanLog_Insert
	(@loantypeid_1 	int,
	 @resourceid_2 	int,
	 @departmentid_3 	int,
	 @crmid_4 	int,
	 @projectid_5 	int,
	 @amount_6 	decimal(18,3),
	 @description_7 	varchar(4000),
	 @credenceno_8 	varchar(60),
	 @occurdate_9 	char(10),
	 @releatedid_10 	int,
	 @releatedname_11 	varchar(255),
     @returndate_12 	char(10),
     @dealuser_13   integer ,
     @flag          integer output, 
     @msg           varchar(80) output)

AS INSERT INTO FnaLoanLog 
	 ( loantypeid,
	 resourceid,
	 departmentid,
	 crmid,
	 projectid,
	 amount,
	 description,
	 credenceno,
	 occurdate,
	 releatedid,
	 releatedname,
     returndate,
     dealuser) 
 
VALUES 
	( @loantypeid_1,
	 @resourceid_2,
	 @departmentid_3,
	 @crmid_4,
	 @projectid_5,
	 @amount_6,
	 @description_7,
	 @credenceno_8,
	 @occurdate_9,
	 @releatedid_10,
	 @releatedname_11,
     @returndate_12,
     @dealuser_13)
GO
