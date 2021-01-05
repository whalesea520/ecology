update hpBaseElement set title='建模查询中心' where id='FormModeCustomSearch'
/
CREATE TABLE formmodeelement(
	id int PRIMARY KEY NOT NULL,
	eid int NULL,
	reportId int NULL,
	isshowunread int NULL,
	fields varchar2(400) NULL,
	fieldsWidth varchar2(400) NULL,
	disorder float NULL,
	searchtitle varchar2(400) NULL
)
/
create sequence formmodeelement_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create or replace trigger formmodeelement_Trigger before insert on formmodeelement for each row 
begin select formmodeelement_ID.nextval into :new.id from dual; end;
/
