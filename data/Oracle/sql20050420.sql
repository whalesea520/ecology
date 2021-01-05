/* 主菜单自定义信息 顶级菜单
   新闻中心，知识管理，人力资源，工作流程，客户管理，项目管理，财务管理，资产管理，数据中心，报表中心，设置中心
 */
INSERT INTO MainMenuInfo (id,labelId,defaultLevel,defaultIndex,relatedModuleId) VALUES (1,16356,0,1,9)
/

INSERT INTO MainMenuInfo (id,labelId,defaultLevel,defaultIndex,relatedModuleId) VALUES (2,2115,0,2,1)
/

INSERT INTO MainMenuInfo (id,labelId,defaultLevel,defaultIndex,relatedModuleId) VALUES (3,179,0,3,2)
/

INSERT INTO MainMenuInfo (id,labelId,defaultLevel,defaultIndex,relatedModuleId) VALUES (4,2118,0,4,3)
/

INSERT INTO MainMenuInfo (id,labelId,defaultLevel,defaultIndex,relatedModuleId) VALUES (5,2113,0,5,4)
/

INSERT INTO MainMenuInfo (id,labelId,defaultLevel,defaultIndex,relatedModuleId) VALUES (6,2114,0,6,5)
/

INSERT INTO MainMenuInfo (id,labelId,defaultLevel,defaultIndex,relatedModuleId) VALUES (7,2117,0,7,6)
/

INSERT INTO MainMenuInfo (id,labelId,defaultLevel,defaultIndex,relatedModuleId) VALUES (8,2116,0,8,7)
/

INSERT INTO MainMenuInfo (id,labelId,defaultLevel,defaultIndex,relatedModuleId) VALUES (9,16371,0,9,8)
/

INSERT INTO MainMenuInfo (id,labelId,defaultLevel,defaultIndex,relatedModuleId) VALUES (10,16372,0,10,9)
/

INSERT INTO MainMenuInfo (id,labelId,defaultLevel,defaultIndex,relatedModuleId) VALUES (11,16373,0,11,9)
/

/*新闻中心 子菜单 BEGIN*/
create or replace PROCEDURE NewPageInfo_Insert_All

AS
        id_1 integer;
        frontpagename_1 varchar2(100);
        defaultIndex_1 integer;
begin
	defaultIndex_1 := 1;
    FOR docFrontpage_cursor in( 
     SELECT id, frontpagename 
       FROM DocFrontpage 
      WHERE isactive = 1 and publishtype = 1 
      ORDER BY id)
    /*主菜单信息表 插入记录 新闻中心子菜单*/
    loop
		id_1 := docFrontpage_cursor.id;
		frontpagename_1 := docFrontpage_cursor.frontpagename;
		INSERT INTO MainMenuInfo (id,menuName,linkAddress,parentFrame,defaultLevel,defaultParentId,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(-id_1,frontpagename_1,Concat('/docs/news/NewsDsp.jsp?id=',trunc(id_1)),'mainFrame',1,1,defaultIndex_1,0,0,0,9);
         defaultIndex_1:= defaultIndex_1+1;
    END loop;
    /*新闻中心 子菜单 新闻设置*/
		INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(-id_1-1,16390,'/docs/news/DocNews.jsp','mainFrame',1,1,defaultIndex_1,0,0,0,9); 
end;
/


/*新闻中心 子菜单 END*/

/*知识管理 子菜单 BEGIN 目录设置 模版设置 页面设置 签章设置 用户定义 图片上传 复制移动 泛微插件 收文发文 文档监控 文档批量共享 文档日志下载 网上调查 个人文档 网站管理 多系统收发文*/

/*目录设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(12,16447,'/docs/category/DocMainCategory.jsp','mainFrame',2,1,1,0,0,0,1)
/

/*模版设置*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(13,16448,2,1,2,0,0,0,1)
/

/*页面设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(14,16451,'/docs/tools/DocSysDefaults.jsp','mainFrame',2,1,3,0,0,0,1)
/

/*签章设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(15,16473,'/docs/docs/SignatureList.jsp','mainFrame',2,1,4,0,1,'SignatureList:List',0,1)
/

/*用户定义*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(16,16452,'/docs/tools/DocUserDefault.jsp','mainFrame',2,1,5,0,0,0,1)
/

/*图片上传*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(17,507,'/docs/tools/DocPicUpload.jsp','mainFrame',2,1,6,0,0,0,1)
/

/*复制移动*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(18,16453,'/docs/tools/DocCopyMove.jsp?Action=INPUT','mainFrame',2,1,7,0,0,0,1)
/

/*泛微插件*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(19,16454,'/weaverplugin/PluginMaintenance.jsp','mainFrame',2,1,8,0,0,0,1)
/

/*收文发文*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(20,16990,2,1,9,0,0,0,1)
/

/*文档监控*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(21,16757,'/system/systemmonitor/docs/DocMonitor.jsp','mainFrame',2,1,10,0,1,'DocEdit:Delete',0,1)
/

/*文档批量共享*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(22,17220,'/docs/search/DocSearch.jsp?from=shareMutiDoc','mainFrame',2,1,11,0,0,0,1)
/

/*文档日志下载*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(23,17515,'/docs/docs/DocDownloadLog.jsp','mainFrame',2,1,12,0,0,0,1)
/

/*网上调查*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(24,17599,'/voting/VotingList.jsp','mainFrame',2,1,13,0,0,0,1)
/

/*个人文档*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(25,17600,'/docs/docs/PersonalDocMain.jsp','mainFrame',2,1,14,0,0,0,1)
/

/*网站管理*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,relatedModuleId) VALUES(26,17066,2,1,15,0,0,1,'MenuSwitch','isOpenWeb',1)
/

/*多系统收发文*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,relatedModuleId) VALUES(27,17007,2,1,16,0,0,1,'MenuSwitch','isOpenSendDoc',1)
/

/*模版设置 二级子菜单 新闻设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) 
VALUES(28,16390,'/docs/news/DocNews.jsp','mainFrame',13,2,1,0,0,0,1)
/
/*模版设置 二级子菜单 编辑模版*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(29,16449,'/docs/mouldfile/DocMould.jsp','mainFrame',13,2,2,0,0,0,1)
/
/*模版设置 二级子菜单 显示模版*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(30,16450,'/docs/mould/DocMould.jsp','mainFrame',13,2,3,0,0,0,1)
/
/*模版设置 二级子菜单 邮件模版*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(31,16218,'/docs/mail/DocMould.jsp','mainFrame',13,2,4,0,0,0,1)
/

/*收文发文 二级子菜单 发文字号*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) 
VALUES(32,16980,'/docs/sendDoc/docNumber.jsp','mainFrame',20,2,1,0,0,0,1)
/
/*收文发文 二级子菜单 秘密等级*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(33,16972,'/docs/sendDoc/docSecretLevel.jsp','mainFrame',20,2,2,0,0,0,1)
/
/*收文发文 二级子菜单 公文种类*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(34,16973,'/docs/sendDoc/docKind.jsp','mainFrame',20,2,3,0,0,0,1)
/
/*收文发文 二级子菜单 紧急程度*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(35,15534,'/docs/sendDoc/docInstancyLevel.jsp','mainFrame',20,2,4,0,0,0,1)
/

/*网站管理 二级子菜单 网站栏目*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) 
VALUES(36,17067,'/web/data/WebSite.jsp','mainFrame',26,2,1,0,0,0,1)
/
/*网站管理 二级子菜单 评论管理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(37,17069,'/web/comment/CommentList.jsp','mainFrame',26,2,2,0,1,'WebSiteView:View',0,1)
/
/*网站管理 二级子菜单 邮件列表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(38,17065,'/web/mailList/MailList.jsp','mainFrame',26,2,3,0,0,0,1)
/
/*网站管理 二级子菜单 新建调查*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(39,15110,'/CRM/investigate/InputReport.jsp','mainFrame',26,2,4,0,1,'DataCenter:Maintenance',0,1)
/
/*网站管理 二级子菜单 查看调查*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(40,17068,'/CRM/investigate/WebSurveyForm.jsp','mainFrame',26,2,5,0,0,0,1)
/

/*多系统收发文 二级子菜单 来文处理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(41,16991,'/docs/sendDoc/docCheckList.jsp','mainFrame',27,2,3,0,1,'SendDoc:Manage',0,1)
/
/*多系统收发文 二级子菜单 默认信息*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(42,16997,'/docs/sendDoc/docSetTempCategory.jsp','mainFrame',27,2,4,0,0,0,1)
/
/*多系统收发文 二级子菜单 系统地址*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(43,16989,'/docs/sendDoc/systemIp.jsp','mainFrame',27,2,5,0,0,0,1)
/

/*知识管理 子菜单 END*/

/*人力资源 子菜单 BEGIN*/

/*组织结构*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(44,16455,3,1,1,0,0,0,2)
/
/*基本设置*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(45,16261,3,1,2,0,0,0,2)
/
/*人事管理*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(46,15882,3,1,3,0,0,0,2)
/
/*考勤管理*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(47,16252,3,1,4,0,0,0,2)
/
/*招聘管理*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(48,6133,3,1,5,0,0,0,2)
/
/*合同管理*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(49,16260,3,1,6,0,0,0,2)
/
/*工资福利*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(50,16480,3,1,7,0,0,0,2)
/
/*培训管理*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(51,16264,3,1,8,0,0,0,2)
/
/*奖惩考核*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(52,16065,3,1,9,0,0,0,2)
/
/*私人组*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(53,17618,'/hrm/group/HrmGroup.jsp','mainFrame',3,1,10,0,0,0,2)
/
/*自定义信息*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(54,17088,'/hrm/resource/HrmCustomFieldManager.jsp','mainFrame',3,1,11,0,0,0,2)
/

/*组织结构 二级子菜单 总部设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(55,16456,'/hrm/company/HrmCompany.jsp','mainFrame',44,2,1,0,0,0,2)
/
/*组织结构 二级子菜单 分部设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(56,16457,'/hrm/company/HrmSubCompany.jsp','mainFrame',44,2,2,0,0,0,2)
/
/*组织结构 二级子菜单 部门设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(57,16458,'/hrm/company/HrmDepartment.jsp','mainFrame',44,2,3,0,0,0,2)
/
/*组织结构 二级子菜单 图形编辑*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(58,16459,'/hrm/company/HrmDepartLayoutEdit.jsp','mainFrame',44,2,4,0,1,'HrmDepartLayoutEdit:Edit',0,2)
/
/*组织结构 二级子菜单 办公地点*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(59,15712,'/hrm/location/HrmLocation.jsp','mainFrame',44,2,5,0,0,0,2)
/
/*组织结构 二级子菜单 职务类别*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(60,805,'/hrm/jobgroups/HrmJobGroups.jsp','mainFrame',44,2,6,0,0,0,2)
/
/*组织结构 二级子菜单 职务设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(61,16460,'/hrm/jobactivities/HrmJobActivities.jsp','mainFrame',44,2,7,0,0,0,2)
/
/*组织结构 二级子菜单 岗位设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(62,16461,'/hrm/jobtitles/HrmJobTitles.jsp','mainFrame',44,2,8,0,0,0,2)
/

/*基本设置 二级子菜单 职称设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(63,16462,'/hrm/jobcall/HrmJobCall.jsp','mainFrame',45,2,1,0,0,0,2)
/
/*基本设置 二级子菜单 专业设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(64,16463,'/hrm/speciality/HrmSpeciality.jsp','mainFrame',45,2,2,0,0,0,2)
/
/*基本设置 二级子菜单 学历设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(65,16464,'/hrm/educationlevel/HrmEduLevel.jsp','mainFrame',45,2,3,0,0,0,2)
/
/*基本设置 二级子菜单 用工性质*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(66,804,'/hrm/usekind/HrmUseKind.jsp','mainFrame',45,2,4,0,0,0,2)
/
/*基本设置 二级子菜单 自定义信息*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(67,17088,'/base/ffield/ListHrmResourceFreeField.jsp','mainFrame',45,2,5,0,0,0,2)
/
/*基本设置 二级子菜单 显示栏目*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(68,6002,'/hrm/tools/HrmValidate.jsp','mainFrame',45,2,6,0,1,'ShowColumn:Operate',0,2)
/
/*基本设置 二级子菜单 显示顺序*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(69,15513,'/hrm/tools/Hrmdsporder.jsp','mainFrame',45,2,7,0,1,'Hrmdsporder:Add',0,2)
/
/*基本设置 二级子菜单 其它*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(70,375,'/hrm/setting/Settings.jsp','mainFrame',45,2,8,0,0,0,2)
/

/*人事管理 二级子菜单 人员入职*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(71,16465,'/hrm/employee/EmployeeView.jsp','mainFrame',46,2,1,0,1,'HrmResourceAdd:Add',0,1,'MenuSwitch','canMaintenanceHrmInfo',2)
/
/*人事管理 二级子菜单 人员转正*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(72,16466,'/hrm/resource/HrmResourceHire.jsp','mainFrame',46,2,2,0,1,'HrmResourceAdd:Add',0,2)
/
/*人事管理 二级子菜单 人员续签*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(73,16467,'/hrm/resource/HrmResourceExtend.jsp','mainFrame',46,2,3,0,1,'HrmResourceAdd:Add',0,2)
/
/*人事管理 二级子菜单 人员调动*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(74,16468,'/hrm/resource/HrmResourceRedeploy.jsp','mainFrame',46,2,4,0,1,'HrmResourceAdd:Add',0,2)
/
/*人事管理 二级子菜单 人员离职*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(75,16469,46,2,5,0,0,0,2)
/
/*人事管理 二级子菜单 人员退休*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(76,16470,'/hrm/resource/HrmResourceRetire.jsp','mainFrame',46,2,6,0,1,'HrmResourceAdd:Add',0,2)
/
/*人事管理 二级子菜单 人员返聘*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(77,16471,'/hrm/resource/HrmResourceRehire.jsp','mainFrame',46,2,7,0,1,'HrmResourceAdd:Add',0,2)
/
/*人事管理 二级子菜单 人员解聘*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(78,16472,'/hrm/resource/HrmResourceFire.jsp','mainFrame',46,2,8,0,1,'HrmResourceAdd:Add',0,2)
/
/*人事管理 二级子菜单 人员试用*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(79,17513,'/hrm/resource/HrmResourceTry.jsp','mainFrame',46,2,9,0,1,'HrmResourceAdd:Add',0,2)
/
/*人事管理 二级子菜单 入职维护*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(80,6137,'/hrm/employee/EmployeeInfoMaintenance.jsp','mainFrame',46,2,10,0,1,'HrmResourceAdd:Add',0,2)
/

/*考勤管理 二级子菜单 考勤系统设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(81,16738,'/hrm/schedule/HrmkqSystemSetEdit.jsp','mainFrame',47,2,1,0,1,'HrmkqSystemSetEdit:Edit',0,2)
/
/*考勤管理 二级子菜单 考勤种类*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(82,6139,'/hrm/schedule/HrmScheduleDiff.jsp','mainFrame',47,2,2,0,0,2)
/
/*考勤管理 二级子菜单 考勤维护*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(83,6138,'/hrm/schedule/HrmScheduleMaintance.jsp','mainFrame',47,2,3,0,1,'HrmScheduleMaintanceView:View',0,2)
/
/*考勤管理 二级子菜单 一般时间*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(84,16687,'/hrm/schedule/HrmDefaultScheduleList.jsp','mainFrame',47,2,4,0,0,2)
/
/*考勤管理 二级子菜单 工作日期调整*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(85,16750,'/hrm/schedule/HrmPubHoliday.jsp','mainFrame',47,2,5,0,0,2)
/
/*考勤管理 二级子菜单 排班种类*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(86,16255,'/hrm/schedule/HrmArrangeShiftList.jsp','mainFrame',47,2,6,0,0,2)
/
/*考勤管理 二级子菜单 排班维护*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(87,16256,'/hrm/schedule/HrmArrangeShiftMaintance.jsp','mainFrame',47,2,7,0,1,'HrmArrangeShiftMaintance:Maintance',0,2)
/
/*考勤管理 二级子菜单 打卡用户接口*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(88,16257,'/hrm/schedule/HrmTimecardUser.jsp','mainFrame',47,2,8,0,1,'HrmTimecardUser:Maintenance',0,2)
/
/*考勤管理 二级子菜单 获取打卡数据*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(89,16737,'/hrm/schedule/HrmTimecardGetData.jsp','mainFrame',47,2,9,0,1,'HrmDefaultScheduleEdit:Edit',0,2)
/
/*考勤管理 二级子菜单 打卡数据导入*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(90,16259,'/hrm/schedule/HrmInTimecard.jsp','mainFrame',47,2,10,0,1,'HrmDefaultScheduleEdit:Edit',0,2)
/
/*考勤管理 二级子菜单 打卡数据偏差管理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(91,16887,'/hrm/schedule/HrmTimeCardWarpList.jsp','mainFrame',47,2,11,0,1,'HrmWorktimeWarp:Maintenance',0,2)
/
/*考勤管理 二级子菜单 工作时间偏差管理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(92,16675,'/hrm/schedule/HrmWorkTimeWarpList.jsp','mainFrame',47,2,12,0,1,'HrmWorktimeWarp:Maintenance',0,2)
/
/*考勤管理 二级子菜单 员工出勤管理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(93,16731,'/hrm/schedule/HrmWorkTimeList.jsp','mainFrame',47,2,13,0,1,'HrmWorktimeWarp:Maintenance',0,2)
/

/*招聘管理 二级子菜单 用工需求*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(94,6131,'/hrm/career/usedemand/HrmUseDemand.jsp','mainFrame',48,2,1,0,1,'HrmUseDemandAdd:Add',0,2)
/
/*招聘管理 二级子菜单 招聘计划*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(95,6132,'/hrm/career/careerplan/HrmCareerPlan.jsp','mainFrame',48,2,2,0,1,'HrmCareerPlanAdd:Add',0,2)
/
/*招聘管理 二级子菜单 应聘库*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(96,16251,'/hrm/career/HrmCareerApply.jsp','mainFrame',48,2,3,0,0,2)
/
/*招聘管理 二级子菜单 招聘管理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(97,6133,'/hrm/career/HrmCareerManager.jsp','mainFrame',48,2,4,0,1,'HrmCareerPlanAdd:Add',0,2)
/
/*招聘管理 二级子菜单 网上发布*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(98,15719,'/pweb/index.htm','_blank',48,2,5,0,0,2)
/

/*合同管理 二级子菜单 合同模版*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(99,16479,'/docs/mouldfile/DocMould.jsp?urlfrom=hr','mainFrame',49,2,1,0,0,2)
/
/*合同管理 二级子菜单 合同种类*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(100,6158,'/hrm/contract/contracttype/HrmContractType.jsp','mainFrame',49,2,2,0,0,2)
/
/*合同管理 二级子菜单 合同管理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(101,16260,'/hrm/contract/contract/HrmContract.jsp','mainFrame',49,2,3,0,1,'HrmContractTypeAdd:Add||HrmContractAdd:Add',0,2)
/

/*工资福利 二级子菜单 薪酬设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(102,16481,'/hrm/finance/salary/HrmSalaryItem.jsp','mainFrame',50,2,1,0,1,'HrmResourceComponentAdd:Add',0,2)
/
/*工资福利 二级子菜单 工资银行*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(103,15812,'/hrm/finance/bank/HrmBankList.jsp','mainFrame',50,2,2,0,0,2)
/
/*工资福利 二级子菜单 薪酬管理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(104,16263,'/hrm/finance/salary/HrmSalaryManage.jsp','mainFrame',50,2,3,0,1,'HrmResourceComponentEdit:Edit',0,2)
/

/*培训管理 二级子菜单 培训种类*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(105,6130,'/hrm/train/traintype/HrmTrainType.jsp','mainFrame',51,2,1,0,0,2)
/
/*培训管理 二级子菜单 培训规划*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(106,6128,'/hrm/train/trainlayout/HrmTrainLayout.jsp','mainFrame',51,2,2,0,0,2)
/
/*培训管理 二级子菜单 培训资源*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(107,15879,'/hrm/train/trainresource/HrmTrainResource.jsp','mainFrame',51,2,3,0,0,2)
/
/*培训管理 二级子菜单 培训安排*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(108,6156,'/hrm/train/trainplan/HrmTrainPlan.jsp','mainFrame',51,2,4,0,0,2)
/
/*培训管理 二级子菜单 培训活动*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(109,6136,'/hrm/train/train/HrmTrain.jsp','mainFrame',51,2,5,0,0,2)
/

/*奖惩考核 二级子菜单 奖惩种类*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(110,6099,'/hrm/award/HrmAwardType.jsp','mainFrame',52,2,1,0,0,2)
/
/*奖惩考核 二级子菜单 奖惩管理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(111,6100,'/hrm/award/HrmAward.jsp','mainFrame',52,2,2,0,0,2)
/
/*奖惩考核 二级子菜单 考核种类*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(112,6118,'/hrm/check/HrmCheckKind.jsp','mainFrame',52,2,3,0,0,2)
/
/*奖惩考核 二级子菜单 考核项目*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(113,6117,'/hrm/check/HrmCheckItem.jsp','mainFrame',52,2,4,0,0,2)
/
/*奖惩考核 二级子菜单 考核实施*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(114,6124,'/hrm/actualize/HrmCheckInfo.jsp','mainFrame',52,2,5,0,1,'HrmCheckInfo:Maintenance',0,2)
/

/*人员离职 三级子菜单 离职事宜*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(115,17568,'/hrm/resign/Resign.jsp','mainFrame',75,3,1,0,1,'Resign:Main',0,2)
/
/*人员离职 三级子菜单 人员离职处理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(116,17576,'/hrm/resource/HrmResourceDismiss.jsp','mainFrame',75,3,2,0,1,'HrmResourceAdd:Add',0,2)
/
/*人力资源 子菜单 END*/

/*工作流程 子菜单 BEGIN*/
/*类型设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(117,16482,'/workflow/workflow/ListWorkType.jsp','mainFrame',4,1,1,0,0,3)
/
/*字段管理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(118,684,'/workflow/field/managefield.jsp','mainFrame',4,1,2,0,0,3)
/
/*表单管理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(119,699,'/workflow/form/manageform.jsp','mainFrame',4,1,3,0,0,3)
/
/*路径设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(120,16483,'/workflow/workflow/managewf.jsp','mainFrame',4,1,4,0,0,3)
/
/*图形编辑*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(121,16459,'/workflow/request/WorkflowLayoutEdit.jsp','mainFrame',4,1,5,0,1,'WorkflowManage:All',0,3)
/
/*报表种类*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(122,15434,'/workflow/report/ReportTypeManage.jsp','mainFrame',4,1,6,0,0,3)
/
/*报表定义*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(123,15435,'/workflow/report/ReportManage.jsp','mainFrame',4,1,7,0,0,3)
/
/*用户定义*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(124,16452,'/workflow/request/RequestUserDefault.jsp','mainFrame',4,1,8,0,0,3)
/
/*流程监控*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(125,16758,'/system/systemmonitor/workflow/WorkflowMonitor.jsp','mainFrame',4,1,9,0,1,'WorkflowManage:All',0,3)
/
/*流程短语设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(126,17561,'/workflow/sysPhrase/PhraseList.jsp','mainFrame',4,1,10,0,0,3)
/
/*流程代理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(127,17564,'/workflow/workflow/WfAgentList.jsp','mainFrame',4,1,11,0,0,3)
/


/*工作流程 子菜单 END*/

/*客户管理 子菜单 BEGIN*/
/*基础设置*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(128,16484,5,1,1,0,0,4)
/
/*分类设置*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(129,16490,5,1,2,0,0,4)
/
/*价值设置*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(130,16496,5,1,3,0,0,4)
/
/*销售机会*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(131,2227,5,1,4,0,0,4)
/
/*合同信用*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(132,16501,5,1,5,0,0,4)
/
/*产品设置*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(133,16512,5,1,6,0,0,4)
/
/*客户批量共享*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(134,17221,'/CRM/search/SearchSimple.jsp?actionKey=batchShare','mainFrame',5,1,7,0,0,4)
/
/*联系人查询*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(135,572,'/CRM/search/ContacterSearch.jsp','mainFrame',5,1,8,0,0,4)
/

/*基础设置 二级子菜单 称呼设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(136,16485,'/CRM/Maint/ListContacterTitle.jsp','mainFrame',128,2,1,0,0,4)
/
/*基础设置 二级子菜单 地址类型*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(137,16486,'/CRM/Maint/ListAddressType.jsp','mainFrame',128,2,2,0,0,4)
/
/*基础设置 二级子菜单 联系方法*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(138,569,'/CRM/Maint/ListContactWay.jsp','mainFrame',128,2,3,0,0,4)
/
/*基础设置 二级子菜单 送货类型*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(139,16375,'/CRM/Maint/ListDeliveryType.jsp','mainFrame',128,2,4,0,0,4)
/
/*基础设置 二级子菜单 自定义信息*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(140,17088,'/base/ffield/ListCustomerFreeField.jsp','mainFrame',128,2,5,0,0,4)
/
/*基础设置 二级子菜单 联系定义*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(141,16488,'/base/ffield/ListContacterFreeField.jsp','mainFrame',128,2,6,0,0,4)
/
/*基础设置 二级子菜单 地址定义*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(142,16489,'/base/ffield/ListAddressFreeField.jsp','mainFrame',128,2,7,0,0,4)
/

/*分类设置 二级子菜单 行业设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(143,16491,'/CRM/Maint/ListSectorInfo.jsp','mainFrame',129,2,1,0,0,4)
/
/*分类设置 二级子菜单 规模设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(144,16492,'/CRM/Maint/ListCustomerSize.jsp','mainFrame',129,2,2,0,0,4)
/
/*分类设置 二级子菜单 类型设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(145,16482,'/CRM/Maint/ListCustomerType.jsp','mainFrame',129,2,3,0,0,4)
/
/*分类设置 二级子菜单 描述设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(146,16494,'/CRM/Maint/ListCustomerDesc.jsp','mainFrame',129,2,4,0,0,4)
/
/*分类设置 二级子菜单 状态设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(147,16495,'/CRM/Maint/ListCustomerStatus.jsp','mainFrame',129,2,5,0,0,4)
/

/*价值设置 二级子菜单 评估标准*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(148,16328,'/CRM/Maint/EvaluationLevelList.jsp','mainFrame',130,2,1,0,0,4)
/
/*价值设置 二级子菜单 评估项目*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(149,16497,'/CRM/Maint/EvaluationList.jsp','mainFrame',130,2,2,0,0,4)
/

/*销售机会 二级子菜单 状态设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(150,16495,'/CRM/sellchance/ListCRMStatus.jsp','mainFrame',130,2,1,0,0,4)
/
/*销售机会 二级子菜单 时间设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(151,16498,'/CRM/sellchance/ListCRMTimespan.jsp','mainFrame',131,2,2,0,0,4)
/
/*销售机会 二级子菜单 成功因素*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(152,16499,'/CRM/sellchance/ListCRMSuccessfactor.jsp','mainFrame',131,2,3,0,0,4)
/
/*销售机会 二级子菜单 失败因素*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(153,16500,'/CRM/sellchance/ListCRMFailfactor.jsp','mainFrame',131,2,4,0,0,4)
/

/*合同信用 二级子菜单 合同性质*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(154,6083,'/CRM/Maint/CRMContractTypeList.jsp?propertyOfApproveWorkFlow=contract','mainFrame',132,2,1,0,0,4)
/
/*合同信用 二级子菜单 额度期间*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(155,16502,'/CRM/Maint/CustomerCredit.jsp','mainFrame',132,2,2,0,1,'CRM_CustomerCreditAdd:Add',0,4)
/
/*合同信用 二级子菜单 信用等级*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(156,580,'/CRM/Maint/ListCreditInfo.jsp','mainFrame',132,2,3,0,0,4)
/
/*合同信用 二级子菜单 合同金额*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(157,6146,'/CRM/Maint/ListTradeInfo.jsp','mainFrame',132,2,4,0,0,4)
/

/*产品设置 二级子菜单 类别设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(158,16493,'/lgc/maintenance/LgcAssortment.jsp?addorsub=3','mainFrame',133,2,1,0,0,4)
/
/*产品设置 二级子菜单 产品新建*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(159,16513,'/lgc/asset/LgcAssetAdd.jsp','mainFrame',133,2,2,0,1,'CrmProduct:Add',0,4)
/
/*产品设置 二级子菜单 产品列表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(160,15108,'/lgc/search/LgcSearchProduct.jsp','mainFrame',133,2,3,0,0,4)
/

/*客户管理 子菜单 END*/

/*项目管理 子菜单 BEGIN*/
/*项目类型*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(161,586,'/proj/Maint/ListProjectType.jsp','mainFrame',6,1,1,0,0,5)
/
/*工作类型*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(162,432,'/proj/Maint/ListWorkType.jsp','mainFrame',6,1,2,0,0,5)
/
/*字段定义*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(163,16503,'/base/ffield/ListProjectFreeField.jsp','mainFrame',6,1,3,0,0,5)
/
/*项目管理 子菜单 END*/

/*财务管理 子菜单 BEGIN*/
/*期间设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(164,16504,'/fna/maintenance/FnaYearsPeriods.jsp','mainFrame',7,1,1,0,0,6)
/
/*预算设置*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(165,16505,7,1,2,0,0,6)
/
/*财务销帐*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(166,16506,'/fna/maintenance/FnaPersonalReturn.jsp','mainFrame',7,1,3,0,1,'FinanceWriteOff:Maintenance',0,6)
/
/*指标设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(167,16507,'/fna/indicator/FnaIndicator.jsp','mainFrame',7,1,4,0,0,6)
/

/*预算设置 二级子菜单 费用类型*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(168,1462,'/fna/maintenance/FnaBudgetfeeType.jsp','mainFrame',165,2,1,0,0,6)
/
/*预算设置 二级子菜单 预算设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(169,16505,'/fna/budget/FnaBudget.jsp','mainFrame',165,2,2,0,1,'FnaBudget:Approve',0,6)
/
/*财务管理 子菜单 END*/

/*资产管理 子菜单 BEGIN*/
/*资产组设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(170,16617,'/cpt/maintenance/CptAssortment.jsp','mainFrame',8,1,1,0,0,7)
/
/*属性设置*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(171,16510,8,1,2,0,0,7)
/
/*新建资料*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(172,16509,'/cpt/capital/CptCapitalAdd.jsp','mainFrame',8,1,3,0,1,'Capital:Maintenance',0,7)
/
/*资产管理*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(173,2116,8,1,4,0,0,7)
/

/*属性设置 二级子菜单 类型设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(174,16482,'/cpt/maintenance/CptCapitalType.jsp','mainFrame',171,2,1,0,0,7)
/
/*属性设置 二级子菜单 单位设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(175,16511,'/lgc/maintenance/LgcAssetUnit.jsp','mainFrame',171,2,2,0,0,7)
/
/*属性设置 二级子菜单 字段定义*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(176,16503,'/base/ffield/ListCptFreeField.jsp','mainFrame',171,2,3,0,0,7)
/

/*资产管理 二级子菜单 资产领用*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(177,886,'/cpt/capital/CptCapitalUse.jsp','mainFrame',173,2,1,0,1,'CptCapital:MoveIn',0,7)
/
/*资产管理 二级子菜单 资产调拨*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(178,883,'/cpt/capital/CptCapitalMove.jsp','mainFrame',173,2,2,0,1,'CptCapital:MoveIn',0,7)
/
/*资产管理 二级子菜单 资产借用*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(179,6051,'/cpt/capital/CptCapitalLend.jsp','mainFrame',173,2,3,0,1,'CptCapital:Lend',0,7)
/
/*资产管理 二级子菜单 资产减损*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(180,6054,'/cpt/capital/CptCapitalLoss.jsp','mainFrame',173,2,4,0,1,'CptCapital:Loss',0,7)
/
/*资产管理 二级子菜单 资产报废*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(181,6052,'/cpt/capital/CptCapitalDiscard.jsp','mainFrame',173,2,5,0,1,'CptCapital:Discard',0,7)
/
/*资产管理 二级子菜单 资产维修*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(182,6053,'/cpt/capital/CptCapitalMend.jsp','mainFrame',173,2,6,0,1,'CptCapital:Mend',0,7)
/
/*资产管理 二级子菜单 资产变更*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(183,6055,'/cpt/capital/CptCapitalModify.jsp','mainFrame',173,2,7,0,0,7)
/
/*资产管理 二级子菜单 资产归还*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(184,15305,'/cpt/capital/CptCapitalBack.jsp','mainFrame',173,2,8,0,1,'CptCapital:Discard',0,7)
/
/*资产管理 二级子菜单 入库申请*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(185,15306,'/cpt/capital/CptCapitalInstock1.jsp','mainFrame',173,2,9,0,0,7)
/
/*资产管理 二级子菜单 入库验收*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(186,15307,'/cpt/search/CptInstockSearch.jsp','mainFrame',173,2,10,0,1,'CptCapital:InStock',0,7)
/

/*资产管理 子菜单 END*/

/*数据中心 子菜单 BEGIN*/
/*调查设置*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(187,16514,9,1,1,0,0,8)
/
/*报表设定*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(188,16515,9,1,2,0,0,8)
/
/*报表管理*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(189,15514,9,1,3,0,0,8)
/
/*用户管理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(190,16521,'/datacenter/maintenance/user/UserManager.jsp','mainFrame',9,1,4,0,1,'DataCenter:Maintenance',0,8)
/

/*调查设置 二级子菜单 新建调查*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(191,15110,'/CRM/investigate/InputReport.jsp','mainFrame',187,2,1,0,1,'DataCenter:Maintenance',0,8)
/
/*调查设置 二级子菜单 后台管理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(192,15111,'/CRM/investigate/SurveyForm.jsp','mainFrame',187,2,2,0,1,'DataCenter:Maintenance',0,8)
/
/*报表设定 二级子菜单 输入维护*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(193,16516,'/datacenter/maintenance/inputreport/InputReport.jsp','mainFrame',188,2,1,0,1,'DataCenter:Maintenance',0,8)
/
/*报表设定 二级子菜单 条件维护*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(194,16517,'/datacenter/maintenance/condition/OutReportCondition.jsp','mainFrame',188,2,2,0,1,'DataCenter:Maintenance',0,8)
/
/*报表设定 二级子菜单 统计项维护*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(195,16890,'/datacenter/maintenance/statitem/ReportStatItem.jsp','mainFrame',188,2,3,0,1,'DataCenter:Maintenance',0,8)
/
/*报表设定 二级子菜单 输出维护*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(196,16518,'/datacenter/maintenance/outreport/OutReport.jsp','mainFrame',188,2,4,0,1,'DataCenter:Maintenance',0,8)
/
/*报表设定 二级子菜单 模版设计*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(197,17496,'/datacenter/design/index.htm','mainFrame',187,8,5,0,0,8)
/

/*报表管理 二级子菜单 输入确认*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(198,16519,'/datacenter/maintenance/reportstatus/ReportConfirm.jsp','mainFrame',189,2,1,0,0,8)
/
/*报表管理 二级子菜单 输入监控*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(199,16520,'/datacenter/maintenance/reportstatus/ReportStatus.jsp','mainFrame',189,2,2,0,0,8)
/
/*数据中心 子菜单 END*/

/*报表中心 子菜单 BEGIN*/
/*人事报表*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(200,16530,10,1,1,0,0,2)
/
/*工资报表*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(201,17536,10,1,2,0,0,2)
/
/*项目报表*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(202,16531,10,1,3,0,0,5)
/
/*流程报表*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(203,16532,10,1,4,0,0,3)
/
/*客户报表*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(204,16533,10,1,5,0,0,4)
/
/*财务报表*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(205,16534,10,1,6,0,0,6)
/
/*资产报表*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(206,16535,10,1,7,0,0,7)
/
/*知识报表*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(207,16536,10,1,8,0,0,1)
/
/*会议报表*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(208,16613,10,1,9,0,0,9)
/
/*数据中心*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(209,16371,'/datacenter/report/OutReport.jsp','mainFrame',10,1,10,0,1,'DataCenter:Maintenance',0,8)
/
/*短信报表*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(210,17008,10,1,11,0,0,9)
/
/*登录日志*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(211,2059,'/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=60','mainFrame',10,1,12,0,1,'LogView:View',0,9)
/

/*人事报表 二级子菜单 通讯录本*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(212,16537,'/hrm/report/HrmRpContact.jsp','mainFrame',200,2,1,0,0,2)
/
/*人事报表 二级子菜单 明细报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(213,16538,'/hrm/report/resource/HrmRpResource.jsp','mainFrame',200,2,2,0,0,1,'','',2)
/
/*人事报表 二级子菜单 统计子表*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(214,17602,200,2,3,0,0,2)
/
/*人事报表 二级子菜单 工作时间*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(215,16253,200,2,4,0,0,2)
/
/*人事报表 二级子菜单 计划任务*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(216,16539,200,2,5,0,0,2)
/
/*人事报表 二级子菜单 人员状况*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(217,16543,200,2,6,0,0,2)
/
/*人事报表 二级子菜单 培训相关*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(218,16556,200,2,7,0,0,2)
/
/*人事报表 二级子菜单 考勤相关*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(219,16557,200,2,8,0,0,2)
/
/*人事报表 二级子菜单 变动相关*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(220,16563,200,2,9,0,0,2)
/
/*人事报表 二级子菜单 合同情况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(221,16572,'/hrm/report/contract/HrmRpContract.jsp','mainFrame',200,2,10,0,0,2)
/
/*人事报表 二级子菜单 招聘管理*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(222,6133,200,2,11,0,0,2)
/

/*工资报表 二级子菜单 时间工资汇总*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(223,17537,'/hrm/report/HrmRpMonthSalarySum.jsp','mainFrame',201,2,1,0,0,1,'','',2)
/
/*工资报表 二级子菜单 人员工资汇总*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(224,17538,'/hrm/report/HrmRpResourceSalarySum.jsp','mainFrame',201,2,2,0,0,1,'','',2)
/

/*项目报表 二级子菜单 项目类型*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(225,586,'/proj/report/ProjectTypeRpSum.jsp','mainFrame',202,2,1,0,0,5)
/
/*项目报表 二级子菜单 工作类型*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(226,432,'/proj/report/WorkTypeRpSum.jsp','mainFrame',202,2,2,0,0,5)
/
/*项目报表 二级子菜单 项目状态*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(227,587,'/proj/report/ProjectStatusRpSum.jsp','mainFrame',202,2,3,0,0,5)
/
/*项目报表 二级子菜单 项目经理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(228,16573,'/proj/report/ManagerRpSum.jsp','mainFrame',202,2,4,0,0,5)
/
/*项目报表 二级子菜单 项目部门*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(229,16574,'/proj/report/DepartmentRpSum.jsp','mainFrame',202,2,5,0,0,5)
/
/*项目报表 二级子菜单 近期修改*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(230,16575,'/proj/report/ProjectModifyLogRp.jsp','mainFrame',202,2,6,0,1,'LogView:View',0,5)
/
/*项目报表 二级子菜单 近期读取*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(231,16576,'/proj/report/ProjectViewLogRp.jsp','mainFrame',202,2,7,0,1,'LogView:View',0,5)
/

/*流程报表 二级子菜单 未完流程*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(232,16577,'/workflow/report/PendingRequestRp.jsp','mainFrame',203,2,1,0,0,3)
/
/*流程报表 二级子菜单 近期读取*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(233,16576,'/workflow/report/ViewLogRp.jsp','mainFrame',203,2,2,0,1,'LogView:View',0,3)
/
/*流程报表 二级子菜单 近期操作*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(234,16578,'/workflow/report/OperateLogRp.jsp','mainFrame',203,2,3,0,1,'LogView:View',0,3)
/
/*流程报表 二级子菜单 流程类型*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(235,16579,'/workflow/report/WorkflowTypeRp.jsp','mainFrame',203,2,4,0,0,3)
/

/*流程报表 二级子菜单 定义报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(236,16580,'/workflow/report/CustomReportView.jsp','mainFrame',203,2,5,0,0,3)
/

/*客户报表 二级子菜单 联系情况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(237,16405,'/CRM/report/CRMContactLogRp.jsp','mainFrame',204,2,1,0,0,4)
/
/*客户报表 二级子菜单 地理分布*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(238,1220,'/CRM/report/AddressRpSum.jsp','mainFrame',204,2,2,0,0,4)
/
/*客户报表 二级子菜单 产品列表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(239,15108,'/lgc/search/LgcSearchProduct.jsp','mainFrame',204,2,3,0,0,4)
/
/*客户报表 二级子菜单 基本报表*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(240,16581,204,2,4,0,0,4)
/
/*客户报表 二级子菜单 共享情况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(241,16584,'/CRM/report/CRMShareLogRp.jsp','mainFrame',204,2,5,0,0,4)
/
/*客户报表 二级子菜单 销售机会*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(242,2227,204,2,6,0,0,4)
/
/*客户报表 二级子菜单 合同相关*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(243,16586,204,2,7,0,0,4)
/
/*客户报表 二级子菜单 客户价值*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(244,6073,'/CRM/report/CRMEvaluationRp.jsp','mainFrame',204,2,8,0,0,4)
/
/*客户报表 二级子菜单 日志报表*/
INSERT INTO MainMenuInfo (id,labelId,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(245,16595,204,2,9,0,0,4)
/

/*财务报表 二级子菜单 部门预算*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(246,15401,'fna/report/budget/FnaBudgetDepartment.jsp','mainFrame',205,2,1,0,1,'FnaBudget:All&&FnaBudgetEdit:Edit&&FnaBudget:Approve',0,6)
/
/*财务报表 二级子菜单 个人预算*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(247,15402,'/fna/report/budget/FnaBudgetResource.jsp','mainFrame',205,2,2,0,0,6)
/
/*财务报表 二级子菜单 部门收支*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(248,15403,'/fna/report/expense/FnaExpenseDepartment.jsp','mainFrame',205,2,3,0,1,'FnaTransaction:All',0,6)
/
/*财务报表 二级子菜单 个人收支*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(249,15404,'/fna/report/expense/FnaExpenseResource.jsp','mainFrame',205,2,4,0,0,6)
/
/*财务报表 二级子菜单 客户收支*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(250,15405,'/fna/report/expense/FnaExpenseCrm.jsp','mainFrame',205,2,5,0,0,6)
/
/*财务报表 二级子菜单 项目收支*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(251,15406,'/fna/report/expense/FnaExpenseProject.jsp','mainFrame',205,2,6,0,0,6)
/

/*资产报表 二级子菜单 类型报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(252,16597,'/cpt/report/CptRpCapitalGroupSum.jsp','mainFrame',206,2,1,0,0,7)
/
/*资产报表 二级子菜单 人员资产*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(253,16598,'/cpt/report/CptRpCapitalResourceSum.jsp','mainFrame',206,2,2,0,0,7)
/
/*资产报表 二级子菜单 部门资产*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(254,16599,'/cpt/report/CptRpCapitalDepartmentSum.jsp','mainFrame',206,2,3,0,0,7)
/
/*资产报表 二级子菜单 资产状态*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(255,830,'/cpt/report/CptRpCapitalStateSum.jsp','mainFrame',206,2,4,0,0,7)
/
/*资产报表 二级子菜单 资产情况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(256,1439,'/cpt/report/CptRpCapital.jsp','mainFrame',206,2,5,0,0,1,'','',7)
/
/*资产报表 二级子菜单 流转情况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(257,1501,'/cpt/report/CptRpCapitalFlow.jsp','mainFrame',206,2,6,0,0,1,'','',7)
/

/*知识报表 二级子菜单 著者文档数量*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(258,16600,'/docs/report/DocRpCreater.jsp','mainFrame',207,2,1,0,0,1)
/
/*知识报表 二级子菜单 部门文档数量*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(259,16601,'/docs/report/DocRpRelative.jsp','mainFrame',207,2,2,0,0,1)
/
/*知识报表 二级子菜单 最近阅读日志*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(260,16602,'/report/RpReadView.jsp?object=1','mainFrame',207,2,3,0,1,'RpReadView:View',0,1)
/
/*知识报表 二级子菜单 文档被阅报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(261,16604,'/docs/report/DocRpAllDocSum.jsp','mainFrame',207,2,4,0,0,1)
/
/*知识报表 二级子菜单 文档目录报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(262,16605,'/docs/report/DocRpMainCategorySum.jsp','mainFrame',207,2,5,0,0,1)
/
/*知识报表 二级子菜单 最多被阅文档*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(263,16606,'/docs/report/DocRpDocSum.jsp','mainFrame',207,2,6,0,0,1)
/
/*知识报表 二级子菜单 最多文档著者*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(264,16607,'/docs/report/DocRpCreaterSum.jsp','mainFrame',207,2,7,0,0,1)
/
/*知识报表 二级子菜单 最多文档语言*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(265,16608,'/docs/report/DocRpLanguageSum.jsp','mainFrame',207,2,8,0,0,1)
/
/*知识报表 二级子菜单 最多文档客户*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(266,16609,'/docs/report/DocRpCrmSum.jsp','mainFrame',207,2,9,0,0,1)
/
/*知识报表 二级子菜单 最多关联人员*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(267,16610,'/docs/report/DocRpResourceSum.jsp','mainFrame',207,2,10,0,0,1)
/
/*知识报表 二级子菜单 最多文档项目*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(268,16611,'/docs/report/DocRpProjectSum.jsp','mainFrame',207,2,11,0,0,1)
/
/*知识报表 二级子菜单 最多文档部门*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(269,16612,'/docs/report/DocRpDepartmentSum.jsp','mainFrame',207,2,12,0,0,1)
/
/*知识报表 二级子菜单 知识积累创新报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(270,17603,'/docs/docpile/DocPileRep.jsp','mainFrame',207,2,13,0,0,1)
/

/*会议报表 二级子菜单 会议室报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(271,16614,'/meeting/report/MeetingRoomPlan.jsp','mainFrame',208,2,1,0,0,9)
/

/*短信报表 二级子菜单 短信时间报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(272,17009,'/sms/SmsReport.jsp','mainFrame',210,2,1,0,0,9)
/

/*统计子表 三级子菜单 个人信息*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(273,15687,'/hrm/report/resource/HrmConstRpSubSearch.jsp?scopeid=1','mainFrame',214,3,1,0,0,1,'','',2)
/
/*统计子表 三级子菜单 工作信息*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(274,15688,'/hrm/report/resource/HrmConstRpSubSearch.jsp?scopeid=3','mainFrame',214,3,2,0,0,1,'','',2)
/
/*统计子表 三级子菜单 家庭情况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(275,814,'/hrm/report/resource/HrmConstRpSubSearch.jsp?scopeid=-10','mainFrame',214,3,3,0,0,1,'','',2)
/
/*统计子表 三级子菜单 语言能力*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(276,815,'/hrm/report/resource/HrmConstRpSubSearch.jsp?scopeid=-11','mainFrame',214,3,4,0,0,1,'','',2)
/
/*统计子表 三级子菜单 教育情况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(277,813,'/hrm/report/resource/HrmConstRpSubSearch.jsp?scopeid=-12','mainFrame',214,3,5,0,0,1,'','',2)
/
/*统计子表 三级子菜单 入职前工作简历*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(278,15716,'/hrm/report/resource/HrmConstRpSubSearch.jsp?scopeid=-13','mainFrame',214,3,6,0,0,1,'','',2)
/
/*统计子表 三级子菜单 入职前培训*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(279,15717,'/hrm/report/resource/HrmConstRpSubSearch.jsp?scopeid=-14','mainFrame',214,3,7,0,0,1,'','',2)
/
/*统计子表 三级子菜单 资格证书*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(280,1502,'/hrm/report/resource/HrmConstRpSubSearch.jsp?scopeid=-15','mainFrame',214,3,8,0,0,1,'','',2)
/
/*统计子表 三级子菜单 入职前奖惩*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(281,15718,'/hrm/report/resource/HrmConstRpSubSearch.jsp?scopeid=-16','mainFrame',214,3,9,0,0,1,'','',2)
/
/*统计子表 三级子菜单 自定义信息*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId) VALUES(282,17088,'/hrm/report/resource/HrmCustomFieldReport.jsp','mainFrame',214,3,10,0,0,1,'','',2)
/

/*工作时间 三级子菜单 一般时间*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(283,16687,'/hrm/schedule/HrmDefaultScheduleList.jsp','mainFrame',215,3,1,0,0,2)
/
/*工作时间 三级子菜单 工作日期调整*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(284,16750,'/hrm/schedule/HrmPubHoliday.jsp','mainFrame',215,3,2,0,0,2)
/

/*计划任务 三级子菜单 工作报告*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(285,16540,'/workplan/data/WorkPlan.jsp','mainFrame',216,3,1,0,0,2)
/
/*计划任务 三级子菜单 任务统计*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(286,16541,'/workplan/report/RpPlan.jsp','mainFrame',216,3,2,0,0,2)
/

/*人员状况 三级子菜单 人力列表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(287,16544,'/hrm/search/HrmResourceSearchTmp.jsp','mainFrame',217,3,1,0,0,2)
/
/*人员状况 三级子菜单 年龄报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(288,16545,'/hrm/report/hrmAgeRp.jsp','mainFrame',217,3,2,0,0,2)
/
/*人员状况 三级子菜单 职级报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(289,16546,'/hrm/report/HrmJobLevelRp.jsp','mainFrame',217,3,3,0,0,2)
/
/*人员状况 三级子菜单 请假报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(290,16547,'/hrm/report/HrmRpAbsense.jsp','mainFrame',217,3,4,0,0,2)
/
/*人员状况 三级子菜单 性别报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(291,16548,'/hrm/report/hrmSexRp.jsp','mainFrame',217,3,5,0,0,2)
/
/*人员状况 三级子菜单 工龄报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(292,16549,'/hrm/report/hrmWorkageRp.jsp','mainFrame',217,3,6,0,0,2)
/
/*人员状况 三级子菜单 学历报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(293,16550,'/hrm/report/hrmEducationLevelRp.jsp','mainFrame',217,3,7,0,0,2)
/
/*人员状况 三级子菜单 部门报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(294,16551,'/hrm/report/hrmDepartmentRp.jsp','mainFrame',217,3,8,0,0,2)
/
/*人员状况 三级子菜单 岗位报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(295,16552,'/hrm/report/HrmJobTitleRp.jsp','mainFrame',217,3,9,0,0,2)
/
/*人员状况 三级子菜单 职务报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(296,16553,'/hrm/report/HrmJobActivityRp.jsp','mainFrame',217,3,10,0,0,2)
/
/*人员状况 三级子菜单 职务类别*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(297,805,'/hrm/report/HrmJobGroupRp.jsp','mainFrame',217,3,11,0,0,2)
/
/*人员状况 三级子菜单 职称报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(298,16554,'/hrm/report/HrmJobCallRp.jsp','mainFrame',217,3,12,0,0,2)
/
/*人员状况 三级子菜单 状态报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(299,16555,'/hrm/report/hrmStatusRp.jsp','mainFrame',217,3,13,0,0,2)
/
/*人员状况 三级子菜单 用工性质*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(300,804,'/hrm/report/hrmUsekindRp.jsp','mainFrame',217,3,14,0,0,2)
/
/*人员状况 三级子菜单 婚姻状况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(301,469,'/hrm/report/hrmMarriedRp.jsp','mainFrame',217,3,15,0,0,2)
/
/*人员状况 三级子菜单 安全级别*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(302,683,'/hrm/report/hrmSecLevelRp.jsp','mainFrame',217,3,16,0,0,2)
/

/*培训相关 三级子菜单 培训规划*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(303,6128,'/hrm/report/HrmTrainLayoutReport.jsp','mainFrame',218,3,1,0,0,2)
/
/*培训相关 三级子菜单 培训活动*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(304,6136,'/hrm/report/HrmTrainReport.jsp','mainFrame',218,3,2,0,0,2)
/
/*培训相关 三级子菜单 培训参与*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(305,17535,'/hrm/report/HrmTrainAttendReport.jsp','mainFrame',218,3,3,0,0,2)
/
/*培训相关 三级子菜单 培训资源*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(306,15879,'/hrm/report/HrmTrainResourceReport.jsp','mainFrame',218,3,4,0,0,2)
/

/*考勤相关 三级子菜单 考勤统计*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(307,16558,'/hrm/report/schedulediff/HrmRpScheduleDiff.jsp','mainFrame',219,3,1,0,0,2)
/
/*考勤相关 三级子菜单 考勤报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(308,16559,'/hrm/report/schedulediff/HrmScheduleDiffReport.jsp','mainFrame',219,3,2,0,0,2)
/
/*考勤相关 三级子菜单 打卡数据报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(309,16673,'/hrm/report/schedulediff/HrmRpTimecard.jsp','mainFrame',219,3,3,0,0,2)
/
/*考勤相关 三级子菜单 无效打卡报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(310,16888,'/hrm/report/schedulediff/HrmRpValidateTimecard.jsp','mainFrame',219,3,4,0,0,2)
/
/*考勤相关 三级子菜单 排班管理报表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(311,16674,'/hrm/report/schedulediff/HrmArrangeShiftReport.jsp','mainFrame',219,3,5,0,0,2)
/

/*变动相关 三级子菜单 调动情况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(312,16564,'/hrm/report/redeploy/HrmRpRedeploy.jsp','mainFrame',220,3,1,0,0,2)
/
/*变动相关 三级子菜单 新增情况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(313,16565,'/hrm/report/resourceadd/HrmRpResourceAdd.jsp','mainFrame',220,3,2,0,0,2)
/
/*变动相关 三级子菜单 转正情况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(314,16566,'/hrm/report/hire/HrmRpHire.jsp','mainFrame',220,3,3,0,0,2)
/
/*变动相关 三级子菜单 续签情况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(315,16567,'/hrm/report/extend/HrmRpExtend.jsp','mainFrame',220,3,4,0,0,2)
/
/*变动相关 三级子菜单 返聘情况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(316,16568,'/hrm/report/rehire/HrmRpRehire.jsp','mainFrame',220,3,5,0,0,2)
/
/*变动相关 三级子菜单 退休情况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(317,16569,'/hrm/report/retire/HrmRpRetire.jsp','mainFrame',220,3,6,0,0,2)
/
/*变动相关 三级子菜单 离职情况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(318,16570,'/hrm/report/dismiss/HrmRpDismiss.jsp','mainFrame',220,3,7,0,0,2)
/
/*变动相关 三级子菜单 解聘情况*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(319,16571,'/hrm/report/fire/HrmRpFire.jsp','mainFrame',220,3,8,0,0,2)
/

/*招聘管理 三级子菜单 用工需求*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(320,6131,'/hrm/report/usedemand/HrmRpUseDemand.jsp','mainFrame',222,3,1,0,0,2)
/
/*招聘管理 三级子菜单 应聘人员*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(321,15885,'/hrm/report/careerapply/HrmRpCareerApply.jsp','mainFrame',222,3,2,0,0,2)
/

/*基本报表 三级子菜单 客户类型*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(322,1282,'/CRM/report/CustomerTypeRpSum.jsp','mainFrame',240,3,1,0,0,4)
/
/*基本报表 三级子菜单 客户状态*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(323,15078,'/CRM/report/CustomerStatusRpSum.jsp','mainFrame',240,3,2,0,0,4)
/
/*基本报表 三级子菜单 客户描述*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(324,1283,'/CRM/report/CustomerDescRpSum.jsp','mainFrame',240,3,3,0,0,4)
/
/*基本报表 三级子菜单 客户经理*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(325,1278,'/CRM/report/ManagerRpSum.jsp','mainFrame',240,3,4,0,0,4)
/
/*基本报表 三级子菜单 客户部门*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(326,15579,'/CRM/report/DepartmentRpSum.jsp','mainFrame',240,3,5,0,0,4)
/
/*基本报表 三级子菜单 获得方式*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(327,1219,'/CRM/report/ContactWayRpSum.jsp','mainFrame',240,3,6,0,0,4)
/
/*基本报表 三级子菜单 客户行业*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(328,16583,'/CRM/report/SectorInfoRpSum.jsp','mainFrame',240,3,7,0,0,4)
/
/*基本报表 三级子菜单 客户规模*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(329,1285,'/CRM/report/CustomerSizeRpSum.jsp','mainFrame',240,3,8,0,0,4)
/

/*销售机会 三级子菜单 机会列表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(330,16585,'/CRM/sellchance/SellChanceReport.jsp','mainFrame',242,3,1,0,0,4)
/
/*销售机会 三级子菜单 归档状态*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(331,15112,'/CRM/sellchance/SellChanceRpSum.jsp','mainFrame',242,3,2,0,0,4)
/
/*销售机会 三级子菜单 销售状态*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(332,2250,'/CRM/sellchance/SellStatusRpSum.jsp','mainFrame',242,3,3,0,0,4)
/
/*销售机会 三级子菜单 成功因素*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(333,16499,'/CRM/sellchance/SuccessRpSum.jsp','mainFrame',242,3,4,0,0,4)
/
/*销售机会 三级子菜单 失败因素*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(334,16500,'/CRM/sellchance/FailureRpSum.jsp','mainFrame',242,3,5,0,0,4)
/
/*销售机会 三级子菜单 时间分布*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(335,15113,'/CRM/sellchance/SellTimeRpSum.jsp','mainFrame',242,3,6,0,0,4)
/

/*合同相关 三级子菜单 合同列表*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(336,16587,'/CRM/report/ContractReport.jsp','mainFrame',243,3,1,0,0,4)
/
/*合同相关 三级子菜单 应收应付*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(337,16588,'/CRM/report/ContractFnaReport.jsp','mainFrame',243,3,2,0,0,4)
/
/*合同相关 三级子菜单 合同产品*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(338,16589,'/CRM/report/ContractProReport.jsp','mainFrame',243,3,3,0,0,4)
/
/*合同相关 三级子菜单 区域金额*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(339,16590,'/CRM/sellchance/SellAreaProRpSum.jsp','mainFrame',243,3,4,0,0,4)
/
/*合同相关 三级子菜单 产品金额*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(340,16591,'/CRM/sellchance/SellProductRpSum.jsp','mainFrame',243,3,5,0,0,4)
/
/*合同相关 三级子菜单 人员金额*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(341,16592,'/CRM/sellchance/SellManagerRpSum.jsp','mainFrame',243,3,6,0,0,4)
/
/*合同相关 三级子菜单 客户金额*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(342,16593,'/CRM/sellchance/SellClientRpSum.jsp','mainFrame',243,3,7,0,0,4)
/
/*合同相关 三级子菜单 信用等级*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(343,580,'/CRM/report/CreditInfoRpSum.jsp','mainFrame',243,3,8,0,0,4)
/
/*合同相关 三级子菜单 累计金额*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(344,16594,'/CRM/report/TradeInfoRpSum.jsp','mainFrame',243,3,9,0,0,4)
/

/*日志报表 三级子菜单 近期登录*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(345,16596,'/CRM/report/CRMLoginLogRp.jsp','mainFrame',245,3,1,0,1,'LogView:View',0,9)
/
/*日志报表 三级子菜单 近期修改*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(346,16575,'/CRM/report/CRMModifyLogRp.jsp','mainFrame',245,3,2,0,1,'LogView:View',0,9)
/
/*日志报表 三级子菜单 近期读取*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(347,16576,'/CRM/report/CRMViewLogRp.jsp','mainFrame',245,3,3,0,1,'LogView:View',0,9)
/

/*报表中心 子菜单 END*/

/*设置中心 子菜单 BEGIN*/
/*国家设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(348,16522,'/hrm/country/HrmCountries.jsp','mainFrame',11,1,1,0,0,9)
/
/*省份设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(349,16523,'/hrm/province/HrmProvince.jsp','mainFrame',11,1,2,0,0,9)
/
/*城市设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(350,16524,'/hrm/city/HrmCity.jsp','mainFrame',11,1,3,0,0,9)
/
/*币种设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(351,16525,'/fna/maintenance/FnaCurrencies.jsp','mainFrame',11,1,4,0,0,9)
/
/*权限设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(352,16526,'/systeminfo/systemright/SystemRightGroup.jsp','mainFrame',11,1,5,0,0,9)
/
/*角色设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(353,16527,'/hrm/roles/HrmRoles.jsp','mainFrame',11,1,6,0,0,9)
/
/*权限转移*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,rightDetailToView,needSwitchToVisible,relatedModuleId) VALUES(354,16528,'/hrm/transfer/HrmRightTransfer.jsp','mainFrame',11,1,7,0,1,'HrmRrightTransfer:Tran',0,9)
/
/*系统设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(355,16686,'/system/SystemSetEdit.jsp','mainFrame',11,1,8,0,0,9)
/
/*会议室设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(356,16615,'/meeting/Maint/MeetingRoom.jsp','mainFrame',11,1,9,0,0,9)
/
/*会议类型设置*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(357,16616,'/meeting/Maint/ListMeetingType.jsp','mainFrame',11,1,10,0,0,9)
/
/*会议监控*/
INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needSwitchToVisible,relatedModuleId) VALUES(358,17625,'/meeting/search/Search.jsp?from=monitor','mainFrame',11,1,11,0,0,9)
/
/*设置中心 子菜单 END*/

/*执行 NewPageInfo_Insert_All 的存储过程*/
call NewPageInfo_Insert_All ()
/

/*初始化每个用户的主菜单配置信息*/
create or replace  PROCEDURE MainMenuConfig_Insert_All
AS
	id_1 integer;
	defaultParentId_1 integer;
	defaultIndex_1 integer;
	defaultLevel_1 integer;
	userId integer;
begin
    for mainMenuInfo_cursor in( 
    SELECT id,defaultParentId, defaultIndex, defaultLevel FROM MainMenuInfo)
    /*系统管理员*/
    loop
	   id_1 :=mainMenuInfo_cursor.id;
	   defaultParentId_1:=mainMenuInfo_cursor.defaultParentId;
	   defaultIndex_1:=mainMenuInfo_cursor.defaultIndex;
	   defaultLevel_1:=mainMenuInfo_cursor.defaultLevel;
       INSERT INTO MainMenuConfig (userId,infoId,visible,parentId,viewIndex,menuLevel) VALUES(1,id_1,1,defaultParentId_1,defaultIndex_1,defaultLevel_1);
    END loop;
    /*用户*/
    FOR hrmResource_cursor in( 
    SELECT id FROM HrmResource order by id)
    loop
	userId := hrmResource_cursor.id;
        FOR mainMenuInfo_cursor_1 in(
        SELECT id,defaultParentId, defaultIndex, defaultLevel FROM MainMenuInfo)   
        loop
			id_1:=mainMenuInfo_cursor_1.id;
			defaultParentId_1:=mainMenuInfo_cursor_1.defaultParentId;
			defaultIndex_1:=mainMenuInfo_cursor_1.defaultIndex;
			defaultLevel_1:=mainMenuInfo_cursor_1.defaultLevel;
            INSERT INTO MainMenuConfig (userId,infoId,visible,parentId,viewIndex,menuLevel) VALUES(userId,id_1,1,defaultParentId_1,defaultIndex_1,defaultLevel_1);
        END loop;
    END loop;
end;
/

/*执行 MainMenuConfig_Insert_All 的存储过程*/
call MainMenuConfig_Insert_All()
/



