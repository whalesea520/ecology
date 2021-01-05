alter table FnaLoanLog alter column description varchar(8000)
go
alter table fnaloaninfo alter column remark varchar(8000)
go
alter table bill_HrmFinance alter column description text
go

alter TRIGGER Tri_importloan ON fnaloanlog
FOR INSERT
AS
declare
@relatedcrm_1 int,
 @relatedprj_1 int,
 @organizationid_1 int,
 @occurdate_1 char(10),
 @amount_1 decimal(15,3),
 @subject_1 int,
 @requestid_1 int,
 @description_1 varchar(8000),
 @loantype_1 int,
 @debitremark_1 varchar(60),
 @processorid_1 int
select @loantype_1=loantypeid,@organizationid_1=resourceid,@relatedcrm_1=crmid,@relatedprj_1=projectid,@amount_1=amount,@occurdate_1=occurdate,@requestid_1=releatedid,@description_1=description,@debitremark_1=credenceno,@processorid_1=dealuser FROM inserted
if(@loantype_1=1)
insert into fnaloaninfo(loantype,organizationtype,organizationid,relatedcrm,relatedprj,amount,occurdate,requestid,remark,debitremark,processorid) values(@loantype_1,3,@organizationid_1,@relatedcrm_1,@relatedprj_1,@amount_1,@occurdate_1,@requestid_1,@description_1,@debitremark_1,@processorid_1)
go

alter PROCEDURE FnaLoanLog_Insert
	(@loantypeid_1 	int,
	 @resourceid_2 	int,
	 @departmentid_3 	int,
	 @crmid_4 	int,
	 @projectid_5 	int,
	 @amount_6 	decimal(18,3),
	 @description_7 	varchar(8000),
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
