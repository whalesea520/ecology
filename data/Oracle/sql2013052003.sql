CREATE TABLE HrmRefuseCount
	(
	id           INT NOT NULL,
	refuse_date  VARCHAR (10) NULL,
	refuse_year  INT NULL,
	refuse_month INT NULL,
	refuse_hour  INT NULL,
	refuse_loginid   varchar(100) NULL
	)
/
create sequence HrmRefuseCount_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmRefuseCount_id_trigger
before insert on HrmRefuseCount
for each row
begin
select HrmRefuseCount_id.nextval into :new.id from dual;
end;
/

CREATE INDEX HrmRefuseCount_index1 ON HrmRefuseCount (refuse_date)
/
CREATE INDEX HrmRefuseCount_index2 ON HrmRefuseCount (refuse_year)
/
CREATE INDEX HrmRefuseCount_index3 ON HrmRefuseCount (refuse_date,refuse_hour)
/ 

CREATE TABLE HrmRefuseAvg
	(
	id           INT  NOT NULL,
	refuse_date  VARCHAR (10) NULL,
	refuse_year  int NULL,
	refuse_month INT NULL,
	refuse_hour   INT NULL,
	refuse_num   INT NULL
	)
/
create sequence HrmRefuseAvg_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmRefuseAvg_id_trigger
before insert on HrmRefuseAvg
for each row
begin
select HrmRefuseAvg_id.nextval into :new.id from dual;
end;
/

CREATE INDEX HrmRefuseAvg_index1 ON HrmRefuseAvg (refuse_date)
/
CREATE INDEX HrmRefuseAvg_index2 ON HrmRefuseAvg (refuse_year)
/
CREATE INDEX HrmRefuseAvg_index3 ON HrmRefuseAvg (refuse_date,refuse_hour)
/ 
CREATE INDEX HrmRefuseAvg_index4 ON HrmRefuseAvg (refuse_year,refuse_month)
/




