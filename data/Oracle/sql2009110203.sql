CREATE TABLE workflow_customQuerytype (
	id integer NOT NULL ,
	typename varchar2(100) NULL ,
	typenamemark varchar2(4000) NULL,
    showorder number(10, 2) default (0)
)
/
CREATE SEQUENCE customquerytype_Id
    start with 1
    increment by 1
    nomaxvalue
    nocycle 
/

CREATE OR REPLACE TRIGGER customquerytype_Id_Trigger
	before insert on workflow_customQuerytype
	for each row
	begin
	select customquerytype_Id.nextval into :new.id from dual;
	end ;
/
INSERT INTO workflow_customQuerytype (typename, typenamemark, showorder)  VALUES ('自定义查询', '自定义查询',0)
/

alter table Workflow_Custom add Querytypeid integer
/
alter table Workflow_Custom add Customname varchar2(100)
/
alter table Workflow_Custom add Customdesc varchar2(4000)
/
alter table Workflow_Custom add workflowids varchar2(4000)
/
alter table Workflow_CustomDspField add queryorder integer default(0)
/
update Workflow_CustomDspField set queryorder=0
/
update Workflow_Custom set Querytypeid=1
/
update Workflow_Custom set Customname=(select formname from workflow_formbase where workflow_formbase.id=Workflow_Custom.formid) where isbill!='1' or isbill is null
/
update Workflow_Custom set Customname=(select HtmlLabelinfo.labelname from workflow_bill,HtmlLabelinfo where workflow_bill.namelabel=HtmlLabelinfo.indexid and HtmlLabelinfo.languageid=7 and workflow_bill.id=Workflow_Custom.formid) where isbill='1'
/

create or replace PROCEDURE Workflow_CustomDspField_Init
(reportid_1    integer, flag  out integer   , msg   OUT varchar2   ,thecursor IN OUT cursor_define.weavercursor) AS 

begin

INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( reportid_1, -9,'0','1',9,9) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder) 
VALUES ( reportid_1, -8,'0','1',8,8) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( reportid_1, -7,'0','1',7,7) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( reportid_1, -6,'0','1',6,6) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( reportid_1, -5,'1','1',5,5) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( reportid_1, -4,'1','1',4,4) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( reportid_1, -3,'1','1',3,3) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( reportid_1, -2,'1','1',2,2) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( reportid_1, -1,'1','1',1,1) ;
end ;
/

create or replace  PROCEDURE Workflow_CustomDspField_Insert
(reportid_1    integer, fieldid_2   integer,  dborder_3     char , shows char, compositororder  varchar2,queryorder_6 integer, flag  out integer   , msg   out varchar2 ,thecursor IN OUT cursor_define.weavercursor  ) AS
begin
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder) VALUES ( reportid_1, fieldid_2, dborder_3, shows, compositororder,queryorder_6) ;
end;
/

CREATE or REPLACE PROCEDURE Workflow_QueryType_Insert (
typename_1 varchar2,
typenamemark_2 varchar2,
showorder_3 varchar2,
flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor) AS 
begin
    INSERT INTO workflow_customQuerytype (typename, typenamemark, showorder)  VALUES ( typename_1, typenamemark_2, showorder_3);
end;
/

CREATE or REPLACE PROCEDURE Workflow_QueryType_Update (
id_1 	integer,
typename_2 	varchar2,
typenamemark_3 varchar2,
showorder_4 	varchar2,
flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor) AS 
begin
    UPDATE workflow_customQuerytype  SET  typename = typename_2, typenamemark = typenamemark_3, showorder = showorder_4  WHERE id= id_1 ;
end;
/

CREATE or REPLACE  PROCEDURE Workflow_QueryType_Delete (
 id_1 	integer,
 flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor) AS 
 count1 integer; 
 begin 
    select count(id) INTO count1 from Workflow_Custom where Querytypeid = id_1; 
    if count1 <> 0
     then 
     open thecursor for select 0 from dual; 
     else 
     DELETE workflow_customQuerytype WHERE ( id = id_1);
    end if;
 end;
/
