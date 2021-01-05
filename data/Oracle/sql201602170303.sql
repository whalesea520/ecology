create table fnaFeeWfInfoLogicReverse(
  id INTEGER primary key, 
  MAINID INTEGER, 

  rule1 INTEGER, 
  rule1INTENSITY INTEGER, 

  rule2 INTEGER, 
  rule2INTENSITY INTEGER, 

  rule3 INTEGER, 
  rule3INTENSITY INTEGER, 

  rule4 INTEGER, 
  rule4INTENSITY INTEGER, 

  rule5 INTEGER, 
  rule5INTENSITY INTEGER, 

  PROMPTSC VARCHAR2(4000), 
  PROMPTTC VARCHAR2(4000), 
  PROMPTEN VARCHAR2(4000), 
  
  PROMPTSC2 VARCHAR2(4000), 
  PROMPTTC2 VARCHAR2(4000), 
  PROMPTEN2 VARCHAR2(4000), 
  
  PROMPTSC3 VARCHAR2(4000), 
  PROMPTTC3 VARCHAR2(4000), 
  PROMPTEN3 VARCHAR2(4000), 
  
  PROMPTSC4 VARCHAR2(4000), 
  PROMPTTC4 VARCHAR2(4000), 
  PROMPTEN4 VARCHAR2(4000), 
  
  PROMPTSC5 VARCHAR2(4000), 
  PROMPTTC5 VARCHAR2(4000), 
  PROMPTEN5 VARCHAR2(4000) 
)
/


create sequence seq_fnaFeeWfInfoLogicR_id 
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20 
/

create or replace trigger fnaFeeWfInfoLogicR_trigger 
before insert 
on fnaFeeWfInfoLogicReverse 
for each row 
begin 
	select seq_fnaFeeWfInfoLogicR_id.nextval into :new.id from dual; 
end;
/