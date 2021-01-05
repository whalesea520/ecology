INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(200,21527,'Bill_DocPrintApply','','','','','','') 
GO
 
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (200,'resourceId',368,'int',3,1,1,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (200,'deptId',17895,'int',3,4,2,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (200,'relatedDocId',857,'int',3,9,3,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (200,'printNum',20219,'int',1,2,4,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (200,'applyReason',859,'varchar(4000)',2,0,5,0,'')
GO 

CREATE TABLE Bill_DocPrintApply ( 
    id int identity (1, 1) NOT NULL ,
    resourceId int NULL,
    deptId int NULL,
    relatedDocId int NULL,
    printNum int NULL,
    applyReason varchar(4000) NULL,
    requestid int NULL
)  
GO



CREATE TABLE DocPrintLog ( 
    id int identity (1, 1) NOT NULL ,
    printUserId int NULL,
    printDocId int NULL,
    printDate char(10) NULL,
    printTime char(8) NULL,
    printNum int NULL,
    clientAddress varchar(15) NULL 
)
GO



ALTER TABLE DocSecCategory ADD  isPrintControl char(1) null
GO
ALTER TABLE DocSecCategory ADD  printApplyWorkflowId int null
GO
ALTER TABLE DocDetail ADD  canPrintedNum int null
GO
ALTER TABLE DocDetail ADD  hasPrintedNum int   default 0  not null
GO
ALTER TABLE workflow_createdoc ADD  printNodes varchar(200) null
GO
ALTER TABLE DocSecCategoryTemplate ADD  isPrintControl char(1) null
GO
ALTER TABLE DocSecCategoryTemplate ADD  printApplyWorkflowId int null
GO

ALTER TABLE Bill_DocPrintApply ADD  hasPrintNum int   default 0  not null
GO

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
GO
