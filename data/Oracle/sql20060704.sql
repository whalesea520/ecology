INSERT INTO HtmlLabelIndex values(19018,'车辆使用情况') 
/
INSERT INTO HtmlLabelIndex values(19020,'查询车辆') 
/
INSERT INTO HtmlLabelIndex values(19021,'车辆信息维护') 
/
INSERT INTO HtmlLabelIndex values(19019,'车辆申请审批') 
/
INSERT INTO HtmlLabelInfo VALUES(19018,'车辆使用情况',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19018,'Car Use Situation',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19019,'车辆申请审批',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19019,'Car Apply Approve',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19020,'查询车辆',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19020,'Search Car',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19021,'车辆信息维护',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19021,'Car Info Maintenance',8) 
/


CALL LMConfig_U_ByInfoInsert (1,NULL,20)
/
CALL LMInfo_Insert (144,17629,'/images_face/ecologyFace_2/LeftMenuIcon/MyMeeting.gif',NULL,1,NULL,20,9)
/
update leftmenuinfo set iconURL='/images_face/ecologyFace_2/LeftMenuIcon/MyMeeting.gif' where id=144
/

CALL LMConfig_U_ByInfoInsert(2,144,0)
/
CALL LMInfo_Insert (145,19018,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_54.gif','/car/CarUseInfo.jsp',2,144,0,9) 
/

CALL LMConfig_U_ByInfoInsert (2,144,3)
/
CALL LMInfo_Insert (148,19021,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_53.gif','/car/CarInfoMaintenance_frm.jsp',2,144,3,9) 
/

CALL LMConfig_U_ByInfoInsert (2,144,1)
/
CALL LMInfo_Insert (146,19019,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_51.gif','/workflow/search/WFSearchTemp.jsp?method=reqeustbybill&billid=163&complete=0',2,144,1,9) 
/

CALL LMConfig_U_ByInfoInsert (2,144,2)
/
CALL LMInfo_Insert (147,19020,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_55.gif','/car/CarSearch.jsp',2,144,2,9) 
/

 
INSERT INTO HtmlLabelIndex values(19047,'用车申请审批单据') 
/
INSERT INTO HtmlLabelInfo VALUES(19047,'用车申请审批单据',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19047,'CarUseApproveBill',8) 
/
INSERT INTO HtmlLabelIndex values(19055,'里程') 
/
INSERT INTO HtmlLabelInfo VALUES(19055,'里程',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19055,'mileage',8) 
/

CREATE TABLE CarUseApprove ( 
    id integer ,
    carId integer,
    driver integer,
    userid integer,
    departmentId integer,
    applier integer,
    reason varchar2(200),
    mileage integer,
    startDate char(10),
    startTime char(8),
    endDate char(10),
    endTime char(8),
    requestid integer,
    remark varchar2(500),
    cancel char(1),
    cancelDate char(10),
    cancelTime char(8)) 
/

create sequence  CarUseApprove_id                                     
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger CarUseApprove_trigger		
	before insert on CarUseApprove
	for each row
	begin
	select CarUseApprove_id.nextval into :new.id from dual;
	end ;
/




CREATE TABLE CarInfo ( 
    id integer ,
    carNo varchar2(30),
    carType integer,
    factoryNo varchar2(50),
    price number(19,0),
    buyDate char(10),
    engineNo varchar2(30),
    driver integer,
    remark varchar2(300),
    createDate char(10),
    createTime char(8),
    creater integer,
    subCompanyId integer) 
/

create sequence  CarInfo_id                                     
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger CarInfo_trigger		
	before insert on CarInfo
	for each row
	begin
	select CarInfo_id.nextval into :new.id from dual;
	end ;
/

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 137,920,'varchar(30)','/systeminfo/BrowserMain.jsp?url=/car/CarInfoBrowser.jsp','CarInfo','carNo','id','')
/

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(163,19047,'CarUseApprove','AddBillCarUseApprove.jsp','BillCarUseApproveManage.jsp','ViewBillCarUseApprove.jsp','','','') 
/
update workflow_bill set hasfileup='1' where id=163
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'carId',920,'int',3,137,0,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'driver',17649,'int',3,1,1,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'userid',17670,'int',3,1,2,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'departmentId',17671,'int',3,4,3,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'applier',368,'int',3,1,4,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'reason',791,'varchar(200)',1,1,5,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'mileage',19055,'int',1,2,6,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'startDate',740,'char(10)',3,2,7,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'startTime',742,'char(8)',3,19,8,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'endDate',741,'char(10)',3,2,9,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'endTime',743,'char(8)',3,19,10,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (163,'remark',454,'varchar(500)',1,1,11,0,'')
/


delete from SystemRights where id=463
/
delete from SystemRightsLanguage where id=463
/
delete from SystemRightDetail where rightid=463
/

insert into SystemRights (id,rightdesc,righttype) values (463,'车辆管理维护','0') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (463,7,'车辆管理维护','车辆管理维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (463,8,'CarMaintenance','CarMaintenance') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3155,'车辆管理维护','Car:Maintenance',463) 
/