create table fnaVoucherObjInfo(
  id INTEGER not null PRIMARY KEY, 
  fnaVoucherInitTypeStr VARCHAR2(200),
  displayOrder INTEGER,
  
  fieldName VARCHAR2(200),
  fieldValueType1 VARCHAR2(200),
  fieldValueType2 VARCHAR2(200),
  
  fieldValue VARCHAR2(200),
  fieldDbTbName VARCHAR2(200),
  
  detailTable VARCHAR2(200),
  fieldDbName VARCHAR2(200),
  fieldDbType VARCHAR2(200),
  
  memo VARCHAR2(200),
  isShow VARCHAR2(200),
  isLockDefType VARCHAR2(200)
)
/

create sequence seq_fnaVoucherObjInfo minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 nocache 
/

create or replace trigger fnaVoucherObjInfo_trigger 
before insert 
on fnaVoucherObjInfo 
for each row 
begin 
	select seq_fnaVoucherObjInfo.nextval into :new.id from dual; 
end;
/
