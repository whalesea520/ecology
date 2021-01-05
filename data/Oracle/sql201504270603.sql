create table fnabudgetfeetypeFcc(
	id integer NOT NULL PRIMARY KEY,
	subject integer,
	fccId integer
)
/

create sequence seq_fnabudgetfeetypeFcc_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create index idx_fnabudgetfeetypeFcc1 on fnabudgetfeetypeFcc (subject)
/

create index idx_fnabudgetfeetypeFcc2 on fnabudgetfeetypeFcc (fccId)
/


create table FnaBudgetInfoPageSize(
	id integer NOT NULL PRIMARY KEY,
  userId integer,
  pageSize integer
)
/

create sequence seq_FnaBudgetInfoPageSize_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create index idx_FnaBudgetInfoPageSize1 on FnaBudgetInfoPageSize (userId)
/

CREATE OR REPLACE FUNCTION checkSubjectById(pSupId IN INTEGER, pBottomId IN INTEGER)
    RETURN VARCHAR2
    IS 
    pCnt INTEGER;
BEGIN
    
		select count(*) into pCnt from FnaBudgetfeeType
		where id = pBottomId 
		start with id = pSupId
		connect by prior id = supsubject ;
		
    RETURN (pCnt);
END;
/

create or replace trigger fnabudgetfeetypeFcc_trigger 
before insert 
on fnabudgetfeetypeFcc 
for each row 
begin 
	select seq_fnabudgetfeetypeFcc_id.nextval into :new.id from dual; 
end;
/

create or replace trigger FnaBudgetInfoPageSize_trigger 
before insert 
on FnaBudgetInfoPageSize 
for each row 
begin 
	select seq_FnaBudgetInfoPageSize_id.nextval into :new.id from dual; 
end;
/
