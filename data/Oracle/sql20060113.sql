UPDATE SystemTemplate SET menubtnFontColor='#FFFFFF' WHERE id=1
/

Call MMConfig_U_ByInfoInsert (11,15)
/
Call MMInfo_Insert (428,18022,'模板维护','/systeminfo/template/templateList.jsp','mainFrame',11,1,15,0,'',0,'',0,'','',0,'','',9)
/

Call MMConfig_U_ByInfoInsert (11,15)
/
Call MMInfo_Insert (429,18024,'登录页模板','/systeminfo/template/LoginTemplateFrame.jsp','mainFrame',11,1,15,0,'',0,'',0,'','',0,'','',9)
/

/*提醒信息*/
Call LMConfig_U_ByInfoInsert (1,NULL,5)
/
Call LMInfo_Insert (115,18121,NULL,NULL,1,NULL,5,3)
/
UPDATE LeftMenuInfo SET parentId=111 WHERE id=115
/
/*新闻公告*/
Call LMConfig_U_ByInfoInsert (2,111,2)
/
Call LMInfo_Insert (118,18124,'/images_face/ecologyFace_2/LeftMenuIcon/NewsBulletin.gif','javascript:void(0);',2,111,2,1) 
/
/*网上调查*/
Call LMConfig_U_ByInfoInsert (2,111,3)
/
Call LMInfo_Insert (119,17599,'/images_face/ecologyFace_2/LeftMenuIcon/Invest.gif','javascript:void(0);',2,111,3,1) 
/



UPDATE LeftMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/CheckTask.gif' WHERE id=38
/
UPDATE LeftMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/CheckProject.gif' WHERE id=37
/
UPDATE LeftMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/NewProject.gif' WHERE id=35
/
UPDATE LeftMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/SearchProject.gif' WHERE id=41
/
UPDATE LeftMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/ProjectPerform.gif' WHERE id=36
/
UPDATE LeftMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/CurrentTask.gif' WHERE id=39
/
UPDATE LeftMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/OverdueTask.gif' WHERE id=40
/
UPDATE LeftMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/MyMail.gif' WHERE id=10
/



UPDATE LeftMenuInfo SET parentId=11,menuLevel=3 WHERE id=77
/
UPDATE LeftMenuInfo SET parentId=11,menuLevel=3 WHERE id=79
/
UPDATE LeftMenuInfo SET parentId=11,menuLevel=3 WHERE id=78
/
/*由于 LeftMenuInfo 表的更改，更新所有用户 LeftMenuConfig 配置信息*/
CREATE or replace TRIGGER Tri_ULeftMenuConfig_ByInfo after  insert or update or delete ON LeftMenuInfo 
for each row
Declare 
        id_1 integer;
        defaultIndex_1 integer;
        countdelete   integer;
        countinsert   integer;
        userId_1 integer;
		isCustom_1 char(1);
begin
    countdelete := :old.id;
    countinsert := :new.id;
    /*插入时 countinsert >0 AND countdelete is null */
    /*删除时 countinsert is null */
    /*更新时 countinsert >0 AND countdelete > 0 */

    /*插入*/
    IF (countinsert > 0 AND countdelete is null) then
        id_1 := :new.id;
        defaultIndex_1 := :new.defaultIndex;
		isCustom_1 := :new.isCustom;
		if(isCustom_1!='1') then
		  /*系统管理员*/
		FOR hrmResourcemanager_cursor in( 
		SELECT id FROM HrmResourceManager order by id)
		loop
			userId_1 := hrmResourcemanager_cursor.id;
			INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex) VALUES(userId_1,id_1,1,defaultIndex_1);
		END loop; 
		
		
		/*用户*/    
        FOR hrmResource_cursor in( 
        SELECT id FROM HrmResource order by id)   
        loop
            userId_1:=hrmResource_cursor.id;
            INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex) VALUES(userId_1,id_1,1,defaultIndex_1);
        END loop;
		end if;
    END if;

    /*删除*/
    IF (countinsert is null) then
       id_1 := :old.id;            
       DELETE FROM LeftMenuConfig WHERE infoId = id_1;
    END if;
end;
/



INSERT INTO HtmlLabelIndex values(18024,'登录页模板') 
/
INSERT INTO HtmlLabelInfo VALUES(18024,'登录页模板',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18024,'LoginTemplate',8) 
/

INSERT INTO HtmlLabelIndex values(18121,'提醒信息') 
/
INSERT INTO HtmlLabelIndex values(18124,'新闻公告') 
/
INSERT INTO HtmlLabelInfo VALUES(18121,'提醒信息',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18121,'RemindInfo',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18124,'新闻公告',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18124,'NewsBulletin',8) 
/


UPDATE LeftMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/MyReport.gif' WHERE id=110
/


UPDATE MainMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/FinReport.gif' WHERE id=205
/
UPDATE MainMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/ProjReport.gif' WHERE id=202
/
UPDATE MainMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/MsgReport.gif' WHERE id=210
/
UPDATE MainMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/CRMReport.gif' WHERE id=204
/
UPDATE MainMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/LgcReport.gif' WHERE id=206
/
UPDATE MainMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/DataCenterReport.gif' WHERE id=209
/
UPDATE MainMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/WorkflowReport.gif' WHERE id=203
/
UPDATE MainMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/DOCReport.gif' WHERE id=207
/
UPDATE MainMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/HRMReport.gif' WHERE id=200
/
UPDATE MainMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/MeetingReport.gif' WHERE id=208
/
INSERT INTO SystemLoginTemplate (LoginTemplateName,loginTemplateTitle,templateType,isCurrent) VALUES ('Ecology默认登录页模板V','泛微协同商务系统','V','0')
/
INSERT INTO SystemLoginTemplate (LoginTemplateName,loginTemplateTitle,templateType,isCurrent) VALUES ('Ecology默认登录页模板H','泛微协同商务系统','H','1')
/

UPDATE LeftMenuInfo SET parentId=107 WHERE id=11
/

UPDATE MainMenuInfo SET linkAddress='/systeminfo/template/loginTemplateList.jsp' WHERE id=429
/

UPDATE LeftMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/MyNote.gif' WHERE id=11
/

/*添加系统设置菜单*/
Call LMConfig_U_ByInfoInsert (1,NULL,18)
/
Call LMInfo_Insert (114,774,NULL,NULL,1,NULL,18,9)
/

UPDATE LeftMenuInfo SET linkAddress='javascript:void(0);' WHERE id=11
/




INSERT INTO HtmlLabelIndex values(18168,'人员登入日志') 
/
INSERT INTO HtmlLabelInfo VALUES(18168,'人员登入日志',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18168,'UserLoginLog',8) 
/

INSERT INTO HtmlLabelIndex values(18180,'客户登入日志') 
/
INSERT INTO HtmlLabelInfo VALUES(18180,'客户登入日志',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18180,'CRMLoginLog',8) 
/

/*系统日志*/
Call MMConfig_U_ByInfoInsert (10,8)
/
Call MMInfo_Insert (444,775,'系统日志','','',10,1,8,0,'',0,'',0,'','',0,'','',9)
/
UPDATE MainMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/SysReport.gif',linkAddress='javascript:void(0);' WHERE id=444
/
/*文档下载日志*/
UPDATE MainMenuInfo SET defaultParentId=444 WHERE id=23
/
/*人员登入日志*/
UPDATE MainMenuInfo SET defaultParentId=444,labelId=18168 WHERE id=211
/
/*客户登入日志*/
Call MMConfig_U_ByInfoInsert (444,1)
/
Call MMInfo_Insert (447,18180,'客户登入日志','/CRM/report/CRMLoginLogRp.jsp','mainFrame',444,2,1,0,'',0,'',0,'','',0,'','',4)
/
/*调整顺序*/
UPDATE MainMenuInfo SET defaultIndex=1 WHERE id=23
/
UPDATE MainMenuInfo SET defaultIndex=2 WHERE id=447
/
UPDATE MainMenuInfo SET defaultIndex=3 WHERE id=211
/
/*调整左菜单顺序*/
UPDATE LeftMenuInfo SET defaultIndex=1 WHERE id=94
/
UPDATE LeftMenuInfo SET defaultIndex=2 WHERE id=111
/
UPDATE LeftMenuInfo SET defaultIndex=3 WHERE id=80
/
UPDATE LeftMenuInfo SET defaultIndex=4 WHERE id=1
/
UPDATE LeftMenuInfo SET defaultIndex=5 WHERE id=2
/
UPDATE LeftMenuInfo SET defaultIndex=6 WHERE id=3
/
UPDATE LeftMenuInfo SET defaultIndex=7 WHERE id=5
/
UPDATE LeftMenuInfo SET defaultIndex=8 WHERE id=4
/
UPDATE LeftMenuInfo SET defaultIndex=9 WHERE id=7
/
UPDATE LeftMenuInfo SET defaultIndex=10 WHERE id=6
/
UPDATE LeftMenuInfo SET defaultIndex=11 WHERE id=107
/
UPDATE LeftMenuInfo SET defaultIndex=12 WHERE id=110
/
UPDATE LeftMenuInfo SET defaultIndex=13 WHERE id=114
/



/*我的收藏*/
DELETE FROM LeftMenuInfo WHERE id=116
/
/*外部情报*/
DELETE FROM LeftMenuInfo WHERE id=117
/
/*提醒信息*/
DELETE FROM LeftMenuInfo WHERE id=115
/
/*我的目标*/
DELETE FROM LeftMenuInfo WHERE id=95
/
/*我的考核*/
DELETE FROM LeftMenuInfo WHERE id=96
/
/*我的计划*/
DELETE FROM LeftMenuInfo WHERE id=8
/
/*我的报告*/
DELETE FROM LeftMenuInfo WHERE id=9
/

/*更新系统设置图标*/
UPDATE leftmenuinfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/SystemSetting.gif' WHERE id=114
/

/*打开计划，报告，邮件，短信菜单*/
UPDATE LeftMenuConfig SET visible='1' WHERE infoid BETWEEN 59 AND 79
/


INSERT INTO HtmlLabelIndex values(18124,'新闻公告') 
/
INSERT INTO HtmlLabelInfo VALUES(18124,'新闻公告',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18124,'NewsBulletin',8) 
/
update mainmenuinfo set linkaddress='/systeminfo/template/templateFrame.jsp' where id=428
/

UPDATE LeftMenuInfo SET linkAddress='/hrm/resource/HrmResource.jsp' WHERE id=43
/

UPDATE LeftMenuInfo SET linkAddress='/hrm/search/HrmResourceView.jsp' WHERE id=44
/

UPDATE LeftMenuInfo SET linkAddress='/hrm/resource/HrmResourceTrainRecord.jsp' WHERE id=45
/

UPDATE LeftMenuInfo SET linkAddress='/hrm/resource/HrmResourceTrainRecord.jsp' WHERE id=46
/

UPDATE LeftMenuInfo SET linkAddress='/hrm/resource/HrmResourceFinanceView.jsp?isView=1' WHERE id=47
/

UPDATE LeftMenuInfo SET linkAddress='/hrm/resource/HrmResourceRewardsRecord.jsp' WHERE id=48
/

UPDATE LeftMenuInfo SET linkAddress='/workplan/data/WorkPlan.jsp?add=1' WHERE id=59
/

UPDATE LeftMenuInfo SET linkAddress='/workplan/data/WorkPlan.jsp' WHERE id=60
/