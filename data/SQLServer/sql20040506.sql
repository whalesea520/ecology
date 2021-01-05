ALTER PROCEDURE FnaCurrency_Update (@id_1 int, @currencyname_2 varchar(60), @currencydesc_3 varchar(200), 
@activable_4 char(1), @isdefault_5 char(1), @flag integer output, @msg varchar(80) output)  
AS 
IF (@isdefault_5 = '1')
UPDATE FnaCurrency SET isdefault = '0' 
UPDATE FnaCurrency SET currencyname = @currencyname_2, currencydesc = @currencydesc_3, activable = @activable_4, 
isdefault = @isdefault_5 WHERE id = @id_1 
GO
insert into ErrorMsgIndex (id,indexdesc) values (33,'该币种已存在，请使用其他名称。') 
GO
insert into ErrorMsgInfo (indexid,msgname,languageid) values (33, '该币种已存在，请使用其他名称。', 7) 
GO
insert into ErrorMsgInfo (indexid,msgname,languageid) values (33, 'This currency exists, please use the other name.', 8) 
GO