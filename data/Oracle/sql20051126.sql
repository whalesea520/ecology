INSERT INTO HtmlLabelIndex values(18011,'是否跟随文档关联人赋权') 
/
INSERT INTO HtmlLabelInfo VALUES(18011,'是否跟随文档关联人赋权',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18011,'set doc right by operator',8) 
/

ALTER TABLE workflow_base ADD docRightByOperator integer
/

CREATE TABLE Workflow_DocSource (
	id		     int            not null,
	requestId	     int			null,
	nodeId		int			null,
	fieldId		int 			null,
	docId		int			null,
	userId		int			null,
  	userType		int			null
)
/
create sequence T_wf_docsor_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger T_wf_docsource_Trigger
before insert on Workflow_DocSource
for each row
begin
select T_wf_docsor_id.nextval into :new.id from dual;
end;
/

CREATE OR REPLACE PROCEDURE Workflow_DocSource_Insert
(requestid1 int,nodeid1 int,fieldid1 int,docid1 int,userid1 int,usertype1 int,flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
AS 
mcount int;
begin
select count(*)into mcount from Workflow_DocSource where requestid =requestid1 and fieldid =fieldid1 and docid=docid1;

if mcount=0 then
	insert into Workflow_DocSource(requestId,nodeId,fieldId,docId,userId,userType) 
	values(requestid1,nodeid1,fieldid1,docid1,userid1,usertype1);
end if;
end;
/

