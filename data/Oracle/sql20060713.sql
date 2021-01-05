INSERT INTO HtmlLabelIndex values(19376,'计件工资设置') 
/
INSERT INTO HtmlLabelIndex values(19377,'计件数据维护') 
/
INSERT INTO HtmlLabelInfo VALUES(19376,'计件工资设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19376,'piece rate setting',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19377,'计件数据维护',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19377,'piece rate maintenance',8) 
/
INSERT INTO HtmlLabelIndex values(19378,'计件数据') 
/
INSERT INTO HtmlLabelInfo VALUES(19378,'计件数据',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19378,'piece rate data',8) 
/
INSERT INTO HtmlLabelIndex values(19379,'计件数据查看') 
/
INSERT INTO HtmlLabelInfo VALUES(19379,'计件数据查看',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19379,'piece rate data view',8) 
/
INSERT INTO HtmlLabelIndex values(19382,'设置对象') 
/
INSERT INTO HtmlLabelInfo VALUES(19382,'设置对象',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19382,'setting object',8) 
/ 
INSERT INTO HtmlLabelIndex values(19383,'计件编号') 
/
INSERT INTO HtmlLabelInfo VALUES(19383,'计件编号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19383,'piece NO.',8) 
/
INSERT INTO HtmlLabelIndex values(19384,'计件名称') 
/
INSERT INTO HtmlLabelInfo VALUES(19384,'计件名称',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19384,'piece name',8) 
/
INSERT INTO HtmlLabelIndex values(19385,'工序') 
/
INSERT INTO HtmlLabelInfo VALUES(19385,'工序',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19385,'working procedure',8) 
/
INSERT INTO HtmlLabelIndex values(19390,'服务器正在处理计件工资设置导入，请稍候...') 
/
INSERT INTO HtmlLabelInfo VALUES(19390,'服务器正在处理计件工资设置导入，请稍候...',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19390,'piece rate setting loading,please wait...',8) 
/
INSERT INTO HtmlLabelIndex values(19391,'计件工资设置导入成功！') 
/
INSERT INTO HtmlLabelInfo VALUES(19391,'计件工资设置导入成功！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19391,'piece rate setting loaded success!',8) 
/
INSERT INTO HtmlLabelIndex values(19392,'导入前该分部下的计件工资设置信息将被全部删除，你确定要继续导入吗？') 
/
INSERT INTO HtmlLabelInfo VALUES(19392,'导入前该分部下的计件工资设置信息将被全部删除，你确定要继续导入吗？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19392,'the piece rate setting will be deleted,are you sure continue load?',8) 
/ 
INSERT INTO HtmlLabelIndex values(19393,'只保留了最后一条记录，其它重复已被删除！') 
/
INSERT INTO HtmlLabelInfo VALUES(19393,'只保留了最后一条记录，其它重复已被删除！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19393,'leave last record,other repeated record have been deleted!',8) 
/
INSERT INTO HtmlLabelIndex values(19398,'月度') 
/
INSERT INTO HtmlLabelInfo VALUES(19398,'月度',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19398,'Monthly',8) 
/
INSERT INTO HtmlLabelIndex values(19399,'计件对象') 
/
INSERT INTO HtmlLabelInfo VALUES(19399,'计件对象',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19399,'piece object',8) 
/
INSERT INTO HtmlLabelIndex values(19400,'计件工资年月') 
/
INSERT INTO HtmlLabelInfo VALUES(19400,'计件工资年月',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19400,'piece rate year and month',8) 
/
INSERT INTO HtmlLabelIndex values(19401,'员工编号') 
/
INSERT INTO HtmlLabelInfo VALUES(19401,'员工编号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19401,'user code',8) 
/
INSERT INTO HtmlLabelIndex values(19402,'服务器正在处理计件数据导入，请请稍候...') 
/
INSERT INTO HtmlLabelInfo VALUES(19402,'服务器正在处理计件数据导入，请请稍候...',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19402,'loading piece data,please wait...',8) 
/
INSERT INTO HtmlLabelIndex values(19403,'计件数据导入成功！') 
/
INSERT INTO HtmlLabelInfo VALUES(19403,'计件数据导入成功！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19403,'piece data loaded success!',8) 
/ 
INSERT INTO HtmlLabelIndex values(19404,'导入前该分部下的该月计件数据将全部删除，你确定要继续导入吗？') 
/
INSERT INTO HtmlLabelInfo VALUES(19404,'导入前该分部下的该月计件数据将全部删除，你确定要继续导入吗？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19404,'the piece data will be deleted,are you sure continue load?',8) 
/
INSERT INTO HtmlLabelIndex values(19409,'该月份数据已经存在不能再新建，请选择其它月份！') 
/
INSERT INTO HtmlLabelInfo VALUES(19409,'该月份数据已经存在不能再新建，请选择其它月份！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19409,'can not create because this data already existed,please select other monthly!',8) 
/
INSERT INTO HtmlLabelIndex values(17138,'年度') 
/
INSERT INTO HtmlLabelInfo VALUES(17138,'年度',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17138,'year',8) 
/
insert into SystemRights (id,rightdesc,righttype,detachable) values (657,'计件工资设置','3',1) 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (657,7,'计件工资设置','计件工资设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (657,8,'piece rate setting','piece rate setting') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4157,'计件工资设置权限','PieceRate:setting',657) 
/

insert into SystemRights (id,rightdesc,righttype,detachable) values (658,'计件工资维护','3',1) 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (658,8,'piece rate maintenance','piece rate maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (658,7,'计件工资维护','计件工资维护') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4158,'计件工资维护权限','PieceRate:maintenance',658) 
/

CALL MMConfig_U_ByInfoInsert (50,2)
/
CALL MMInfo_Insert (512,19376,'','/hrm/finance/salary/PieceRateSetting_frm.jsp','mainFrame',50,2,2,0,'',0,'PieceRate:setting',0,'','',0,'','',2)
/

CALL MMConfig_U_ByInfoInsert (50,3)
/
CALL MMInfo_Insert (513,19377,'','/hrm/finance/salary/PieceRateMaintenance_frm.jsp','mainFrame',50,2,3,0,'',0,'PieceRate:maintenance',0,'','',0,'','',2)
/

CALL LMConfig_U_ByInfoInsert (2,5,7)
/
CALL LMInfo_Insert (161,19378,'/images_face/ecologyFace_2/LeftMenuIcon/HRMReport.gif','/hrm/finance/salary/MyPieceRateData.jsp',2,5,7,2) 
/

/* 计件工资设置信息表 */
CREATE TABLE HRM_PieceRateSetting(
    id  integer NOT NULL ,
    subcompanyid    integer,/*分部id*/
    PieceRateNo   varchar2(30),/*计件编号*/
    PieceRateName varchar2(50),/*计件名称*/
    workingpro  varchar2(100),/*工序*/
    price number(15,2),/*单价*/
    memo varchar2(500)/*备注*/
)
/
create sequence  HRM_PieceRateSetting_id                                      
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/

create or replace trigger HRM_PieceRateSetting_trigger		
	before insert on HRM_PieceRateSetting
	for each row
	begin
	select HRM_PieceRateSetting_id.nextval into :new.id from dual;
	end ;
/

/* 计件数据维护信息表 */
CREATE TABLE HRM_PieceRateInfo(
    id  integer NOT NULL,
    subcompanyid    integer,/*分部id*/
    departmentid    integer,/*部门id*/
    PieceYear   integer,/*年*/
    PieceMonth  integer,/*月*/
    UserCode   varchar2(30),/*员工编号*/
    PieceRateNo   varchar2(30),/*计件编号*/
    PieceRateDate varchar2(10),/*日期*/
    PieceNum number(15,2),/*数量*/
    memo varchar2(500)/*备注*/
)
/
create sequence  HRM_PieceRateInfo_id                                      
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger HRM_PieceRateInfo_trigger		
	before insert on HRM_PieceRateInfo
	for each row
	begin
	select HRM_PieceRateInfo_id.nextval into :new.id from dual;
	end ;
/
