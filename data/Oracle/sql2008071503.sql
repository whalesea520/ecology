create table hpsetting_wfcenter(
   id  integer   PRIMARY KEY NOT NULL,
   eid int,
   viewType int,
   typeids varchar(800),
   flowids varchar(2500),
   nodeids varchar(4000)
)
/

CREATE SEQUENCE hpsetting_wfcenter_Id
    start with 1
    increment by 1
    nomaxvalue
    nocycle 
/

CREATE OR REPLACE TRIGGER hpsetting_wfcenter_Id_Trigger
	before insert on hpsetting_wfcenter
	for each row
	begin
	select hpsetting_wfcenter_Id.nextval into :new.id from dual;
	end ;
/

update hpbaseelement set elementtype=2 where id=8
/

insert into  hpextelement (id,extshow,description) values (8,'Workflow.jsp','流程中心')
/


INSERT INTO hpFieldElement(id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES (85,8,'19225','createrDept','0','','','','','0',5)
/

INSERT INTO hpFieldElement(id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES (86,8,'16579','workflowtype','0','','','','','0',6)
/

INSERT INTO hpFieldElement(id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES (87,8,'15534','importantleve','0','','','','','0',7)
/


update hpFieldElement set ordernum=3 where id=85
/

update hpFieldElement set ordernum=4 where id=86
/

update hpFieldElement set ordernum=5 where id=87
/

update hpFieldElement set  ordernum=6 where id=14
/

update hpFieldElement set ordernum=7 where id=15
/
