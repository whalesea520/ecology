CREATE TABLE excelStyleDec(
	id int NOT NULL,
	stylename varchar2(500) NULL,
	mainrowheight int NULL,
	mainlblwidth int NULL,
	mainlblwidthselect int NULL,
	mainfieldwidth int NULL,
	mainfieldwidthselect int NULL,
	mainborder varchar2(10) NULL,
	mainlblbgcolor varchar2(10) NULL,
	mainfieldbgcolor varchar2(10) NULL,
	detailrowheight int NULL,
	detailcolwidth int NULL,
	detailcolwidthselect int NULL,
	detailborder varchar2(10) NULL,
	detaillblbgcolor varchar2(10) NULL,
	detailfieldbgcolor varchar2(10) NULL
)
/
create sequence excelStyleDec_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger excelStyleDec_id_trigger
before insert on excelStyleDec
for each row 
begin
select excelStyleDec_id.nextval into :new.id from dual;
end;
/