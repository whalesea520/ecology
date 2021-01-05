INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(200,21527,'Bill_DocPrintApply','','','','','','') 
/
 
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (200,'resourceId',368,'integer',3,1,1,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (200,'deptId',17895,'integer',3,4,2,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (200,'relatedDocId',857,'integer',3,9,3,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (200,'printNum',20219,'integer',1,2,4,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (200,'applyReason',859,'varchar2(4000)',2,0,5,0,'')
/ 

CREATE TABLE Bill_DocPrintApply ( 
    id integer NOT NULL ,
    resourceId integer NULL,
    deptId integer NULL,
    relatedDocId integer NULL,
    printNum integer NULL,
    applyReason varchar2(4000) NULL,
    requestid integer NULL
)  
/

create sequence Bill_DocPrintApply_id
start with 1
increment by 1
nomaxvalue
nocycle
/


create or replace trigger Bill_DocPrintApply_Tri
before insert on Bill_DocPrintApply
for each row
begin
select Bill_DocPrintApply_id.nextval into :new.id from dual;
end;
/

CREATE TABLE DocPrintLog ( 
    id integer NOT NULL ,
    printUserId integer NULL,
    printDocId integer NULL,
    printDate char(10) NULL,
    printTime char(8) NULL,
    printNum integer NULL,
    clientAddress varchar(15) NULL 
)
/

create sequence DocPrintLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/


create or replace trigger DocPrintLog_Tri
before insert on DocPrintLog
for each row
begin
select DocPrintLog_id.nextval into :new.id from dual;
end;
/

ALTER TABLE DocSecCategory ADD  isPrintControl char(1) null
/
ALTER TABLE DocSecCategory ADD  printApplyWorkflowId integer null
/
ALTER TABLE DocDetail ADD  canPrintedNum integer null
/
ALTER TABLE DocDetail ADD  hasPrintedNum integer   default 0  not null
/
ALTER TABLE workflow_createdoc ADD  printNodes varchar2(200) null
/
ALTER TABLE DocSecCategoryTemplate ADD  isPrintControl char(1) null
/
ALTER TABLE DocSecCategoryTemplate ADD  printApplyWorkflowId integer null
/

ALTER TABLE Bill_DocPrintApply ADD  hasPrintNum integer   default 0  not null
/

insert into DocSecCategoryDocProperty(secCategoryId,viewindex,type,labelid,visible,customName,columnWidth,mustInput,isCustom,scope,scopeid,fieldid)
select id,25,25,21535,0,'',1,0,0,'',0,0
 from DocSecCategory
where exists(
  select 1
    from DocSecCategoryDocProperty
   where secCategoryId=DocSecCategory.id
    and (isCustom <> 1 or isCustom is null)
	and secCategoryId>0
)
and not exists(
  select 1
    from DocSecCategoryDocProperty
	where secCategoryId=DocSecCategory.id
    and (isCustom <> 1 or isCustom is null)
	and secCategoryId>0
	and type=25	
)
/
