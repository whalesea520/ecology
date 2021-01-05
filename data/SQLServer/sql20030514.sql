alter table HrmStatusHistory add
  status int default(1)
go

create procedure HrmSchedule_Select_ByDepID
(@id_1 int,
 @flag int output, @msg varchar(60) output)
as select * from HrmSchedule 
where 
  relatedid = @id_1
and
  scheduletype =1
go

alter PROCEDURE HrmResource_Extend 
(@id_1 int, 
 @changedate_2 char(10), 
 @changeenddate_3 char(10), 
 @changereason_4 char(10), 
 @changecontractid_5 int, 
 @infoman_6 varchar(255), 
 @oldjobtitleid_7 int, 
 @type_n_8 char(1),
 @status_9 int,
 @flag int output, 
 @msg varchar(60) output) 
AS INSERT INTO HrmStatusHistory 
(resourceid, 
 changedate, 
 changeenddate, 
 changereason, 
 changecontractid, 
 infoman, 
 oldjobtitleid, 
 type_n,
 status) 
VALUES 
(@id_1, 
 @changedate_2, 
 @changeenddate_3, 
 @changereason_4, 
 @changecontractid_5, 
 @infoman_6, 
 @oldjobtitleid_7 , 
 @type_n_8,
 @status_9) 
UPDATE HrmResource SET enddate = @changeenddate_3 WHERE id = @id_1
GO


alter PROCEDURE HrmResource_SelectAll 
 (@flag integer output, @msg   varchar(80) output ) 
AS select 
  id,
  loginid,  
  lastname,
  sex,
  resourcetype,
  email,
  locationid,
  workroom, 
  departmentid,
  costcenterid,
  jobtitle,
  managerid,
  assistantid ,
  seclevel,
  joblevel,
  status
from HrmResource  
if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end 
GO



alter table workflow_form alter column  document varchar(200)
GO

alter table workflow_form alter column  relateddocument varchar(200)
GO

update workflow_formdict set fielddbtype='varchar(200)', type =37 where fieldname = 'document' 
GO

update workflow_formdict set fielddbtype='varchar(200)', type =37 where fieldname = 'relateddocument' 
GO

update workflow_bill set createpage='', managepage='',viewpage='' where id = 13
GO


INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (7,'relatedate',97,'char(10)',3,2,30,1)
GO

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (7,'invoicenum',900,'varchar(250)',1,1,38,1)
GO


alter PROCEDURE Bill_ExpenseDetail_Insert 
	@expenseid_1		int,
    @relatedate_1       char(10),
    @feetypeid_1		int,
	@detailremark_1	    varchar(250),
    @accessory_1		int,
    @relatedcrm_1       int,
    @relatedproject_1   int,
	@feesum_1			decimal(10,2),
    @realfeesum_1		decimal(10,2),
    @invoicenum_1       varchar(250),
	@flag			int	output, 
	@msg			varchar(80) output
as
	insert into bill_expensedetail 
	(expenseid,relatedate,feetypeid,detailremark,accessory,relatedcrm,relatedproject,feesum,realfeesum,invoicenum)
	values
	(@expenseid_1,@relatedate_1,@feetypeid_1,@detailremark_1,@accessory_1,@relatedcrm_1,@relatedproject_1,@feesum_1,@realfeesum_1,@invoicenum_1)
GO

/*2003-05-20建立考核项目表*/
CREATE TABLE HrmCheckItem (
id int IDENTITY (1, 1) NOT NULL PRIMARY KEY,
checkitemname varchar (60) NULL,
checkitemexplain varchar (200) NULL 
)
GO

/*2003-05-20建立考核项目的存储过程*/

CREATE PROCEDURE HrmCheckItem_Insert
(@checkitemname_2 varchar (60),
 @checkitemexplain_3 varchar(200),
 @flag int output, @msg varchar(60) output)
 AS
 insert into HrmCheckItem (checkitemname, checkitemexplain) values (@checkitemname_2,@checkitemexplain_3)
 GO
/*2003-05-20建立修改考核项目的存储过程*/

CREATE PROCEDURE HrmCheckItem_Update
(@id_1 int,
 @checkitemname_2 varchar(60),
 @checkitemexplain_3 varchar(200),
 @flag int output, @msg varchar(60) output)
AS 
UPDATE HrmCheckItem set
checkitemname = @checkitemname_2,
checkitemexplain = @checkitemexplain_3
WHERE
 id = @id_1
GO

/*2003-05-20建立删除考核项目表的存储过程*/
CREATE PROCEDURE HrmCheckItem_Delete
(@id_1 int,
@flag int output, @msg varchar(60) output)
AS
DELETE HrmCheckItem WHERE id = @id_1
GO

/*2003-05-20建立查看考核项目表的存储过程*/
CREATE PROCEDURE HrmCheckItem_SByid
(@id_1 int,
@flag int output, @msg varchar(60) output)
AS
SELECT * FROM HrmCheckItem WHERE id = @id_1
GO