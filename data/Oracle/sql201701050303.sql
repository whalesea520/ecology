create table fnaFccDimension(
	id integer not null primary key, 
	name VARCHAR2(4000), 
	type VARCHAR2(50), 
	fielddbtype VARCHAR2(500), 
	displayOrder DECIMAL(6,3) 
)
/

CREATE INDEX idx_fnaFccDimension_1 ON fnaFccDimension (displayOrder)
/

create sequence seq_fccDimension minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 50 order
/

create or replace trigger fnaFccDimension_trigger 
before insert 
on fnaFccDimension 
for each row 
begin 
	select seq_fccDimension.nextval into :new.id from dual; 
end;
/

alter table FnaCostCenterDtl add objValue varchar2(100)
/

update FnaCostCenterDtl set objValue = to_char(objId) where objId is not null
/

CREATE INDEX idx_FnaCostCenterDtl_3 ON FnaCostCenterDtl (objId)
/
CREATE INDEX idx_FnaCostCenterDtl_4 ON FnaCostCenterDtl (objValue)
/