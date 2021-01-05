CREATE OR REPLACE PROCEDURE FnaCurrency_Insert (currencyname_1 	varchar2, currencydesc_2 	varchar2, 
activable_3 	char, isdefault_4 	char, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
AS count_1 integer; 
begin 
select count(id) into count_1 from FnaCurrency where currencyname = currencyname_1; 
if (count_1 <> 0) then 
open thecursor for select -1 from dual; 
return; 
end if; 
if (isdefault_4 = '1') then 
update FnaCurrency set isdefault = '0'; 
end if;
INSERT INTO FnaCurrency ( currencyname, currencydesc, activable, isdefault) 
VALUES ( currencyname_1, currencydesc_2, activable_3, isdefault_4); 
open thecursor for select max(id) from FnaCurrency;  
end;
/
insert into ErrorMsgIndex (id,indexdesc) values (33,'该币种已存在，请使用其他名称。') 
/

insert into ErrorMsgInfo (indexid,msgname,languageid) values (33, '该币种已存在，请使用其他名称。', 7) 
/
insert into ErrorMsgInfo (indexid,msgname,languageid) values (33, 'This currency exists, please use the other name.', 8) 
/