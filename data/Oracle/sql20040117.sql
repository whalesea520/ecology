CREATE TABLE bill_InnerSendDoc (
    id integer NOT NULL ,
    requestid integer NULL ,
    resourceId integer NULL ,
    departmentId integer NULL ,
    docId integer NULL ,
    pieces integer NULL ,
    subjectWord varchar2 (300) NULL ,
    docKind integer NULL ,
    docInstancyLevel integer NULL ,
    docSecretLevel integer NULL ,
    docNumber integer NULL ,
    docNumberYear integer NULL ,
    docNumberIssue integer NULL ,
    finishDate char (10) NULL ,
    sendDate char (10) NULL ,
    phone varchar2 (100) NULL ,
    department_1 varchar2 (100) NULL ,
    department_2 varchar2 (100) NULL ,
    department_3 varchar2 (100) NULL ,
    department_4 varchar2 (100) NULL
)
/
create sequence bill_InnerSendDoc_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger bill_InnerSendDoc_Tri
before insert on bill_InnerSendDoc
for each row
begin
select bill_InnerSendDoc_id.nextval into :new.id from dual;
end;
/

INSERT INTO HtmlLabelIndex values(17005,'系统内部发文流转单')
/
INSERT INTO HtmlLabelInfo VALUES(17005,'系统内部发文流转单',7)
/
INSERT INTO HtmlLabelInfo VALUES(17005,'',8)
/
INSERT INTO HtmlLabelIndex values(17006,'多部门')
/
INSERT INTO HtmlLabelInfo VALUES(17006,'多部门',7)
/
INSERT INTO HtmlLabelInfo VALUES(17006,'',8)
/
INSERT INTO HtmlLabelIndex values(17007,'多系统收发文')
/
INSERT INTO HtmlLabelInfo VALUES(17007,'多系统收发文',7)
/
INSERT INTO HtmlLabelInfo VALUES(17007,'',8)
/


INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES (57,17006,'varchar2(100)','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp','HrmDepartment','departmentmark','id','/hrm/company/HrmDepartmentDsp.jsp?id=')
/

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(67,17005,'bill_InnerSendDoc','','BillInnerSendDocManage.jsp','','','','BillInnerSendDocOperation.jsp')
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'resourceId',16975,'integer',3,1,1,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'departmentId',16976,'integer',3,4,2,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'docId',857,'integer',3,9,3,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'pieces',16977,'integer',1,2,4,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'subjectWord',16978,'varchar2(300)',1,1,5,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'docKind',16973,'integer',3,52,6,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'docInstancyLevel',15534,'integer',3,53,7,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'docSecretLevel',16972,'integer',3,54,8,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'docNumber',16980,'integer',3,55,9,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'docNumberYear',16981,'integer',1,2,10,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'docNumberIssue',16982,'integer',1,2,11,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'finishDate',16983,'char(10)',3,2,12,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'sendDate',16984,'char(10)',3,2,13,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'phone',421,'varchar2(100)',1,1,14,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'department_1',16985,'varchar2(100)',3,57,15,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'department_2',16986,'varchar2(100)',3,57,16,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'department_3',16987,'varchar2(100)',3,57,17,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'department_4',16988,'varchar2(100)',3,57,18,0)
/