






create table workflow_custom (
id int  NOT NULL,
formID int null ,
isBill char(1) null
)
/

create sequence workflow_custom_seq
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_custom_Trigger
before insert on workflow_custom
for each row
begin
select workflow_custom_seq.nextval into :new.id from dual;
end;
/ 

CREATE TABLE Workflow_CustomDspField(
	id int NOT NULL,
	customid int NULL,
	fieldid int NULL,
	ifquery char(1)  NULL,
	ifshow char(1)  NULL,
	showorder int null
	)

/

create sequence Workflow_CustomDspField_seq
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Workflow_CustomDsp_Trigger
before insert on Workflow_CustomDspField
for each row
begin
select Workflow_CustomDspField_seq.nextval into :new.id from dual;
end;
/ 

 create or replace  PROCEDURE Workflow_CustomDspField_Insert
(reportid_1    integer, fieldid_2   integer,  dborder_3     char , shows char, compositororder  varchar2, flag  out integer   , msg   out varchar2 ,thecursor IN OUT cursor_define.weavercursor  ) AS 
begin
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder) VALUES ( reportid_1, fieldid_2, dborder_3, shows, compositororder) ;
end;
/


create or replace PROCEDURE Workflow_CustomDspField_Init
(reportid_1    integer, flag  out integer   , msg   OUT varchar2   ,thecursor IN OUT cursor_define.weavercursor) AS 

begin

INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder) 
VALUES ( reportid_1, -9,'0','1',9) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder) 
VALUES ( reportid_1, -8,'0','1',8) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder) 
VALUES ( reportid_1, -7,'0','1',7) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder) 
VALUES ( reportid_1, -6,'0','1',6) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder) 
VALUES ( reportid_1, -5,'1','1',5) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder) 
VALUES ( reportid_1, -4,'1','1',4) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder) 
VALUES ( reportid_1, -3,'1','1',3) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder) 
VALUES ( reportid_1, -2,'1','1',2) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder) 
VALUES ( reportid_1, -1,'1','1',1) ;
end ;
/


