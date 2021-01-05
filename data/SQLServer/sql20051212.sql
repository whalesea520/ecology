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


UPDATE license set cversion = '3.100'
go