delete from mainmenuinfo where id<0
go
delete from mainmenuconfig where infoid<0
go

delete from mainmenuinfo where id>=364
go

delete from mainmenuconfig where infoid>=364
go
alter PROCEDURE NewPageInfo_Insert_All(
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS
DECLARE @id_1 int,
        @frontpagename_1 varchar(100),
        @defaultIndex_1 int

	SET @defaultIndex_1 = 1

    DECLARE docFrontpage_cursor CURSOR FOR
     SELECT id, frontpagename 
       FROM DocFrontpage 
      WHERE isactive = 1 and publishtype = 1 
      ORDER BY id

    OPEN docFrontpage_cursor
    FETCH NEXT FROM docFrontpage_cursor INTO @id_1,@frontpagename_1

    /*主菜单信息表 插入记录 新闻中心子菜单*/
    WHILE @@FETCH_STATUS = 0

    BEGIN
        INSERT INTO MainMenuInfo (id,menuName,linkAddress,parentFrame,defaultLevel,defaultParentId,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(-@id_1,@frontpagename_1,'/docs/news/NewsDsp.jsp?id='+CAST(@id_1 AS varchar(12)),'mainFrame',1,1,@defaultIndex_1,0,0,0,9)
        SET @defaultIndex_1=@defaultIndex_1+1;
        FETCH NEXT FROM docFrontpage_cursor INTO @id_1,@frontpagename_1
    END

    /*新闻中心 子菜单 新闻设置*/
    INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(-1000,16390,'/docs/news/DocNews.jsp','mainFrame',1,1,1000,0,0,0,9)


    CLOSE docFrontpage_cursor
    DEALLOCATE docFrontpage_cursor

GO

EXEC NewPageInfo_Insert_All '',''
go

EXECUTE MMConfig_U_ByInfoInsert 6,1
GO
EXECUTE MMInfo_Insert 377,16484,'基础设置','','',6,1,1,0,'',0,'',0,'','',0,'','',5
GO

EXECUTE MMConfig_U_ByInfoInsert 377,1
GO
EXECUTE MMInfo_Insert 378,17852,'项目编码','/proj/CodeFormat/CodeFormatView.jsp','mainFrame',377,2,1,0,'',0,'',0,'','',0,'','',5
GO


EXECUTE MMConfig_U_ByInfoInsert 6,2
GO
EXECUTE MMInfo_Insert 379,17857,'模板管理','','mainFrame',6,1,2,0,'',0,'',0,'','',0,'','',5
GO

EXECUTE MMConfig_U_ByInfoInsert 379,2
GO
EXECUTE MMInfo_Insert 381,17858,'模板列表','/proj/templet/ProjTempletList.jsp','mainFrame',379,2,2,0,'',0,'',0,'','',0,'','',5
GO

EXECUTE MMConfig_U_ByInfoInsert 379,1
GO
EXECUTE MMInfo_Insert 380,16388,'新建模板','/proj/Templet/ProjTempletAdd.jsp','mainFrame',379,2,1,0,'',0,'',0,'','',0,'','',5
GO



EXECUTE MMConfig_U_ByInfoInsert 46,14
GO
EXECUTE MMInfo_Insert 375,17743,'同步Ldap数据','/hrm/resource/ExportHrmFromLdap.jsp','mainFrame',46,2,14,0,'HrmResourceAdd:Add',0,'',0,'MenuSwitch','canExportLdap',0,'','',2
GO
EXECUTE MMConfig_U_ByInfoInsert 4,5
GO
EXECUTE MMInfo_Insert 423,17996,'单据管理','/workflow/workflow/BillManagementList.jsp','mainFrame',4,1,5,0,'',0,'',0,'','',0,'','',3
GO
EXECUTE MMConfig_U_ByInfoInsert 11,13
GO
EXECUTE MMInfo_Insert 426,18014,'授权信息','/system/licenseInfo.jsp','mainFrame',11,1,13,0,'',0,'',0,'','',0,'','',9
GO
EXECUTE MMConfig_U_ByInfoInsert 8,7
GO
EXECUTE MMInfo_Insert 364,17629,'车辆管理','','',8,1,7,0,'',0,'',0,'','',0,'','',7
GO

EXECUTE MMConfig_U_ByInfoInsert 11,12
GO
EXECUTE MMInfo_Insert 368,17688,'基础数据','/system/basedata/basedata.jsp','mainFrame',11,1,12,0,'',0,'',0,'','',0,'','',9
GO

EXECUTE MMConfig_U_ByInfoInsert 364,1
GO
EXECUTE MMInfo_Insert 365,17632,'参数设置','/cpt/car/CarParameter.jsp','mainFrame',364,2,1,0,'',0,'',0,'','',0,'','',7
GO

EXECUTE MMConfig_U_ByInfoInsert 364,2
GO
EXECUTE MMInfo_Insert 366,17630,'车辆类型','/cpt/car/CarTypeList.jsp','mainFrame',364,2,2,0,'',0,'',0,'','',0,'','',7
GO

EXECUTE MMConfig_U_ByInfoInsert 364,3
GO
EXECUTE MMInfo_Insert 367,17631,'出车记录','/cpt/car/CarDriverDataList.jsp','mainFrame',364,2,3,0,'',0,'',0,'','',0,'','',7
GO

EXECUTE MMConfig_U_ByInfoInsert 206,10
GO
EXECUTE MMInfo_Insert 369,17677,'车辆报表','','',206,2,10,0,'',0,'',0,'','',0,'','',7
GO

EXECUTE MMConfig_U_ByInfoInsert 369,1
GO
EXECUTE MMInfo_Insert 370,17674,'出车报表','/cpt/car/CarUseRp.jsp','mainFrame',369,3,1,0,'',0,'',0,'','',0,'','',7
GO

EXECUTE MMConfig_U_ByInfoInsert 369,3
GO
EXECUTE MMInfo_Insert 372,17536,'工资报表','/cpt/car/CarDriverSalaryRp.jsp','mainFrame',369,3,3,0,'',0,'',0,'','',0,'','',7
GO

EXECUTE MMConfig_U_ByInfoInsert 369,2
GO
EXECUTE MMInfo_Insert 371,17675,'出车总表','/cpt/car/CarUseTotalRp.jsp','mainFrame',369,3,2,0,'',0,'',0,'','',0,'','',7
GO

EXECUTE MMConfig_U_ByInfoInsert 369,4
GO
EXECUTE MMInfo_Insert 373,17676,'工资总表','/cpt/car/CarDriverSalaryTotalRp.jsp','mainFrame',369,3,4,0,'',0,'',0,'','',0,'','',7
GO
EXECUTE MMConfig_U_ByInfoInsert 4,9
GO
EXECUTE MMInfo_Insert 421,17989,'监控设置','/system/systemmonitor/workflow/systemMonitorStatic.jsp','mainFrame',4,1,9,0,'',0,'',0,'','',0,'','',3
GO
EXECUTE	MMConfig_U_ByInfoInsert 46,13
go
EXECUTE MMInfo_Insert 387,17887,'人员导入','/hrm/resource/HrmImport.jsp','mainFrame',46,2,13,0,'',0,'',0,'','',0,'','',2
go