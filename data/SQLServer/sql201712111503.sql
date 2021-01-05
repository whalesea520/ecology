create table CRM_customercontacter_mind(id int identity(1,1) primary key,customerid varchar(100), contacterid varchar(100) ,parentid varchar(100),direction varchar(10))
GO
CREATE TABLE CRM_customercontacter_mind_log (
	id INT IDENTITY (1, 1) PRIMARY KEY,
	customerid VARCHAR (100),
	contacterid VARCHAR (100),
	operate_usr VARCHAR (20),
	operate_date VARCHAR (50),
	operate_time VARCHAR (50),
	operate_type VARCHAR (10),
	operate_value VARCHAR (2000)
)
GO
create index idx_crmcontacterMind_1 on crm_customercontacter_mind_log(customerid)
GO