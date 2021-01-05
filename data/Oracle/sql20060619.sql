INSERT INTO HtmlLabelIndex values(19330,'警告：数据太大，无法保存！') 
/
INSERT INTO HtmlLabelInfo VALUES(19330,'警告：数据太大，无法保存！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19330,'Alert:the data is too large,and it can''t be saved!',8) 
/

alter table CRM_ContractProduct add tempcol number(10,2)
/
update CRM_ContractProduct set tempcol = number_n
/
alter table CRM_ContractProduct drop column number_n
/
alter table CRM_ContractProduct add number_n number(10,2)
/
update CRM_ContractProduct set number_n = tempcol
/
alter table CRM_ContractProduct drop column tempcol
/

CREATE or REPLACE  PROCEDURE CRM_ContractProduct_Insert ( 
	contractId_1  integer  , 
	productId_1  integer  , 
	unitId_1  integer  , 
	number_n_1  number  , 
	price_1  number  , 
	currencyId_1  integer  , 
	depreciation_1  integer  , 
	sumPrice_1  number  , 
	planDate_1  char    , 
	factnumber_n_1   integer  , 
	factDate_1  char  , 
	isFinish_1  integer  , 
	isRemind_1  integer  , 
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
 ) 
AS 
begin
INSERT INTO CRM_ContractProduct (
	contractId , 
	productId , 
	unitId , 
	number_n , 
	price , 
	currencyId , 
	depreciation , 
	sumPrice , 
	planDate , 
	factnumber_n , 
	factDate , 
	isFinish , 
	isRemind )  
VALUES ( 
	contractId_1, 
	productId_1, 
	unitId_1, 
	number_n_1 , 
	price_1 , 
	currencyId_1 , 
	depreciation_1 , 
	sumPrice_1 , 
	planDate_1 , 
	factnumber_n_1 , 
	factDate_1 , 
	isFinish_1 , 
	isRemind_1) ;
end;
/


CREATE or REPLACE  PROCEDURE CRM_ContractProduct_Update1 ( 
	id_1 	integer , 
	productId_1  integer  , 
	unitId_1  integer  , 
	currencyId_1  integer  , 
	price_1  number , 
	depreciation_1  integer  , 
	number_n_1  number  , 
	sumPrice_1  number  , 
	planDate_1  char    , 
	isRemind_1  integer  , 
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
 ) 
AS 
begin
UPDATE CRM_ContractProduct SET 
	productId = productId_1 , 
	unitId = unitId_1, 
	currencyId = currencyId_1, 
	price = price_1, 
	depreciation = depreciation_1, 
	number_n = number_n_1 , 
	sumPrice = sumPrice_1, 
	planDate = planDate_1 , 
	isRemind = isRemind_1 
	where id = id_1 ;
end;
/

