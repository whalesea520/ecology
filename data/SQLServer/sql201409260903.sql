create table CRM_CustomerTag (
   id                 int                  identity,
   customerid         int                  null,
   tag                varchar(100)         null,
   creater            int                  null,
   createdate         char(10)             null,
   createtime         char(8)              null,
   constraint PK_CRM_CustomerTag primary key (id)
)
go

create index CRM_CT_Index_1 on CRM_CustomerTag (
customerid ASC
)
go

ALTER table CRM_CustomerContacter add department VARCHAR(100)
go

create table CRM_Attention(
  id int IDENTITY,
  resourceid int,
  customerid int
)
GO

CREATE TABLE CRM_label (
	id int NOT NULL IDENTITY(1,1) ,
	userid int NULL ,
	name varchar(200) NULL ,
	labelColor  varchar(200) NULL ,
	createdate varchar(50) NULL ,
	createtime varchar(50) NULL ,
	isUsed int NULL ,
	labelOrder int NULL ,
	labelType varchar(100) NULL ,
	textColor varchar(20) NULL 
)
GO

CREATE TABLE CRM_customer_label (
	id int NOT NULL IDENTITY(1,1) ,
	userid int null,
	customerid int NULL ,
	labelid int NULL 
)
GO
