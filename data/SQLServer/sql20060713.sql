INSERT INTO HtmlLabelIndex values(19376,'计件工资设置') 
GO
INSERT INTO HtmlLabelIndex values(19377,'计件数据维护') 
GO
INSERT INTO HtmlLabelInfo VALUES(19376,'计件工资设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19376,'piece rate setting',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19377,'计件数据维护',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19377,'piece rate maintenance',8) 
GO
INSERT INTO HtmlLabelIndex values(19378,'计件数据') 
GO
INSERT INTO HtmlLabelInfo VALUES(19378,'计件数据',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19378,'piece rate data',8) 
GO
INSERT INTO HtmlLabelIndex values(19379,'计件数据查看') 
GO
INSERT INTO HtmlLabelInfo VALUES(19379,'计件数据查看',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19379,'piece rate data view',8) 
GO
INSERT INTO HtmlLabelIndex values(19382,'设置对象') 
GO
INSERT INTO HtmlLabelInfo VALUES(19382,'设置对象',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19382,'setting object',8) 
GO 
INSERT INTO HtmlLabelIndex values(19383,'计件编号') 
GO
INSERT INTO HtmlLabelInfo VALUES(19383,'计件编号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19383,'piece NO.',8) 
GO
INSERT INTO HtmlLabelIndex values(19384,'计件名称') 
GO
INSERT INTO HtmlLabelInfo VALUES(19384,'计件名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19384,'piece name',8) 
GO
INSERT INTO HtmlLabelIndex values(19385,'工序') 
GO
INSERT INTO HtmlLabelInfo VALUES(19385,'工序',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19385,'working procedure',8) 
GO
INSERT INTO HtmlLabelIndex values(19390,'服务器正在处理计件工资设置导入，请稍候...') 
GO
INSERT INTO HtmlLabelInfo VALUES(19390,'服务器正在处理计件工资设置导入，请稍候...',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19390,'piece rate setting loading,please wait...',8) 
GO
INSERT INTO HtmlLabelIndex values(19391,'计件工资设置导入成功！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19391,'计件工资设置导入成功！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19391,'piece rate setting loaded success!',8) 
GO
INSERT INTO HtmlLabelIndex values(19392,'导入前该分部下的计件工资设置信息将被全部删除，你确定要继续导入吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(19392,'导入前该分部下的计件工资设置信息将被全部删除，你确定要继续导入吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19392,'the piece rate setting will be deleted,are you sure continue load?',8) 
GO 
INSERT INTO HtmlLabelIndex values(19393,'只保留了最后一条记录，其它重复已被删除！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19393,'只保留了最后一条记录，其它重复已被删除！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19393,'leave last record,other repeated record have been deleted!',8) 
GO
INSERT INTO HtmlLabelIndex values(19398,'月度') 
GO
INSERT INTO HtmlLabelInfo VALUES(19398,'月度',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19398,'Monthly',8) 
GO
INSERT INTO HtmlLabelIndex values(19399,'计件对象') 
GO
INSERT INTO HtmlLabelInfo VALUES(19399,'计件对象',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19399,'piece object',8) 
GO
INSERT INTO HtmlLabelIndex values(19400,'计件工资年月') 
GO
INSERT INTO HtmlLabelInfo VALUES(19400,'计件工资年月',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19400,'piece rate year and month',8) 
GO
INSERT INTO HtmlLabelIndex values(19401,'员工编号') 
GO
INSERT INTO HtmlLabelInfo VALUES(19401,'员工编号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19401,'user code',8) 
GO
INSERT INTO HtmlLabelIndex values(19402,'服务器正在处理计件数据导入，请请稍候...') 
GO
INSERT INTO HtmlLabelInfo VALUES(19402,'服务器正在处理计件数据导入，请请稍候...',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19402,'loading piece data,please wait...',8) 
GO
INSERT INTO HtmlLabelIndex values(19403,'计件数据导入成功！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19403,'计件数据导入成功！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19403,'piece data loaded success!',8) 
GO 
INSERT INTO HtmlLabelIndex values(19404,'导入前该分部下的该月计件数据将全部删除，你确定要继续导入吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(19404,'导入前该分部下的该月计件数据将全部删除，你确定要继续导入吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19404,'the piece data will be deleted,are you sure continue load?',8) 
GO
INSERT INTO HtmlLabelIndex values(19409,'该月份数据已经存在不能再新建，请选择其它月份！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19409,'该月份数据已经存在不能再新建，请选择其它月份！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19409,'can not create because this data already existed,please select other monthly!',8) 
GO
INSERT INTO HtmlLabelIndex values(17138,'年度') 
GO
INSERT INTO HtmlLabelInfo VALUES(17138,'年度',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17138,'year',8) 
GO
insert into SystemRights (id,rightdesc,righttype,detachable) values (657,'计件工资设置','3',1) 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (657,7,'计件工资设置','计件工资设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (657,8,'piece rate setting','piece rate setting') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4157,'计件工资设置权限','PieceRate:setting',657) 
GO

insert into SystemRights (id,rightdesc,righttype,detachable) values (658,'计件工资维护','3',1) 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (658,8,'piece rate maintenance','piece rate maintenance') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (658,7,'计件工资维护','计件工资维护') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4158,'计件工资维护权限','PieceRate:maintenance',658) 
GO

EXECUTE MMConfig_U_ByInfoInsert 50,2
GO
EXECUTE MMInfo_Insert 512,19376,'','/hrm/finance/salary/PieceRateSetting_frm.jsp','mainFrame',50,2,2,0,'',0,'PieceRate:setting',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 50,3
GO
EXECUTE MMInfo_Insert 513,19377,'','/hrm/finance/salary/PieceRateMaintenance_frm.jsp','mainFrame',50,2,3,0,'',0,'PieceRate:maintenance',0,'','',0,'','',2
GO

EXECUTE LMConfig_U_ByInfoInsert 2,5,7
GO
EXECUTE LMInfo_Insert 161,19378,'/images_face/ecologyFace_2/LeftMenuIcon/HRMReport.gif','/hrm/finance/salary/MyPieceRateData.jsp',2,5,7,2 
GO

/* 计件工资设置信息表 */
CREATE TABLE HRM_PieceRateSetting(
    id  int NOT NULL IDENTITY (1, 1),
    subcompanyid    int,/*分部id*/
    PieceRateNo   varchar(30),/*计件编号*/
    PieceRateName varchar(50),/*计件名称*/
    workingpro  varchar(100),/*工序*/
    price decimal(15,2),/*单价*/
    memo varchar(500)/*备注*/
)
GO
/* 计件数据维护信息表 */
CREATE TABLE HRM_PieceRateInfo(
    id  int NOT NULL IDENTITY (1, 1),
    subcompanyid    int,/*分部id*/
    departmentid    int,/*部门id*/
    PieceYear   int,/*年*/
    PieceMonth  int,/*月*/
    UserCode   varchar(30),/*员工编号*/
    PieceRateNo   varchar(30),/*计件编号*/
    PieceRateDate varchar(10),/*日期*/
    PieceNum decimal(15,2),/*数量*/
    memo varchar(500)/*备注*/
)
GO