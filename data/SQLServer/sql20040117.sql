CREATE TABLE [bill_InnerSendDoc] (
    [id] [int] IDENTITY (1, 1) NOT NULL ,
    [requestid] [int] NULL ,
    [resourceId] [int] NULL ,
    [departmentId] [int] NULL ,
    [docId] [int] NULL ,
    [pieces] [int] NULL ,
    [subjectWord] [varchar] (300) NULL ,
    [docKind] [int] NULL ,
    [docInstancyLevel] [int] NULL ,
    [docSecretLevel] [int] NULL ,
    [docNumber] [int] NULL ,
    [docNumberYear] [int] NULL ,
    [docNumberIssue] [int] NULL ,
    [finishDate] [char] (10) NULL ,
    [sendDate] [char] (10) NULL ,
    [phone] [varchar] (100) NULL ,
    [department_1] [varchar] (100) NULL ,
    [department_2] [varchar] (100) NULL ,
    [department_3] [varchar] (100) NULL ,
    [department_4] [varchar] (100) NULL
)
GO

INSERT INTO HtmlLabelIndex values(17005,'系统内部发文流转单')
GO
INSERT INTO HtmlLabelInfo VALUES(17005,'系统内部发文流转单',7)
GO
INSERT INTO HtmlLabelInfo VALUES(17005,'',8)
GO
INSERT INTO HtmlLabelIndex values(17006,'多部门')
GO
INSERT INTO HtmlLabelInfo VALUES(17006,'多部门',7)
GO
INSERT INTO HtmlLabelInfo VALUES(17006,'',8)
GO
INSERT INTO HtmlLabelIndex values(17007,'多系统收发文')
GO
INSERT INTO HtmlLabelInfo VALUES(17007,'多系统收发文',7)
GO
INSERT INTO HtmlLabelInfo VALUES(17007,'',8)
GO


INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES (57,17006,'varchar(100)','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp','HrmDepartment','departmentmark','id','/hrm/company/HrmDepartmentDsp.jsp?id=')
GO

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(67,17005,'bill_InnerSendDoc','','BillInnerSendDocManage.jsp','','','','BillInnerSendDocOperation.jsp')
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'resourceId',16975,'int',3,1,1,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'departmentId',16976,'int',3,4,2,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'docId',857,'int',3,9,3,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'pieces',16977,'int',1,2,4,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'subjectWord',16978,'varchar(300)',1,1,5,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'docKind',16973,'int',3,52,6,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'docInstancyLevel',15534,'int',3,53,7,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'docSecretLevel',16972,'int',3,54,8,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'docNumber',16980,'int',3,55,9,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'docNumberYear',16981,'int',1,2,10,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'docNumberIssue',16982,'int',1,2,11,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'finishDate',16983,'char(10)',3,2,12,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'sendDate',16984,'char(10)',3,2,13,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'phone',421,'varchar(100)',1,1,14,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'department_1',16985,'varchar(100)',3,57,15,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'department_2',16986,'varchar(100)',3,57,16,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'department_3',16987,'varchar(100)',3,57,17,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (67,'department_4',16988,'varchar(100)',3,57,18,0)
GO