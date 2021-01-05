CREATE TABLE HrmOnlineAvg
	(
	id           INT  NOT NULL,
	online_year  int NULL,
	online_month INT NULL,
	online_date  VARCHAR (10) NULL,
	point_time   INT NULL,
	online_num   INT NULL
	)
/
create sequence HrmOnlineAvg_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmOnlineAvg_id_trigger
before insert on HrmOnlineAvg
for each row
begin
select HrmOnlineAvg_id.nextval into :new.id from dual;
end;
/

CREATE INDEX HrmOnlineAvg_index1 ON HrmOnlineAvg (online_date)
/
CREATE INDEX HrmOnlineAvg_index2 ON HrmOnlineAvg (online_year)
/

CREATE TABLE HrmOnlineCount
	(
	id           INT NOT NULL,
	online_date  VARCHAR (10) NULL,
	online_time  VARCHAR (8) NULL,
	online_num   INT NULL,
	online_month INT NULL,
	online_year  INT NULL
	)
/
create sequence HrmOnlineCount_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmOnlineCount_id_trigger
before insert on HrmOnlineCount
for each row
begin
select HrmOnlineCount_id.nextval into :new.id from dual;
end;
/
CREATE INDEX HrmOnlineCount_index1 ON HrmOnlineCount (online_date)
/
CREATE INDEX HrmOnlineCount_index2 ON HrmOnlineCount (online_year)
/