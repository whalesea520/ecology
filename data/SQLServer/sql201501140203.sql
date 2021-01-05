INSERT INTO MainMenuInfo
(id,labelid,parentid,menuName,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t) 
SELECT 10161,587,377,menuName,'/proj/Maint/ListProjectStatus.jsp',parentFrame,defaultParentId,defaultLevel,4,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t FROM MainMenuInfo 
WHERE  id = 10004
GO

INSERT INTO mainmenuconfig (infoid,visible,viewindex,resourceid,resourcetype) VALUES(10161,1,4,1,1)
GO

INSERT INTO mainmenuconfig (infoid,visible,resourceid,resourcetype,viewIndex) 
SELECT b.id, 1, a.id,2,b.defaultIndex FROM HrmSubCompany a , MainMenuInfo b WHERE b.id=10161
GO


INSERT INTO MainMenuInfo
(id,labelid,parentid,menuName,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t) 
SELECT 10162,21954,6,menuName,'',parentFrame,defaultParentId,defaultLevel,6,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t FROM MainMenuInfo 
WHERE  id = 10004
GO

INSERT INTO mainmenuconfig (infoid,visible,viewindex,resourceid,resourcetype) VALUES(10162,1,6,1,1)
GO

INSERT INTO mainmenuconfig (infoid,visible,resourceid,resourcetype,viewIndex) 
SELECT b.id, 1, a.id,2,b.defaultIndex FROM HrmSubCompany a , MainMenuInfo b WHERE b.id=10162
GO


INSERT INTO MainMenuInfo
(id,labelid,parentid,menuName,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t) 
SELECT 10163,81937,10162,menuName,'/proj/conf/prjcreatewfconf.jsp',parentFrame,defaultParentId,defaultLevel,1,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t FROM MainMenuInfo 
WHERE  id = 10004
GO

INSERT INTO mainmenuconfig (infoid,visible,viewindex,resourceid,resourcetype) VALUES(10163,1,1,1,1)
GO

INSERT INTO mainmenuconfig (infoid,visible,resourceid,resourcetype,viewIndex) 
SELECT b.id, 1, a.id,2,b.defaultIndex FROM HrmSubCompany a , MainMenuInfo b WHERE b.id=10163
GO

INSERT INTO MainMenuInfo
(id,labelid,parentid,menuName,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t) 
SELECT 10164,81938,10162,menuName,'/proj/conf/prjapprovewfconf.jsp',parentFrame,defaultParentId,defaultLevel,2,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t FROM MainMenuInfo 
WHERE  id = 10004
GO

INSERT INTO mainmenuconfig (infoid,visible,viewindex,resourceid,resourcetype) VALUES(10164,1,2,1,1)
GO

INSERT INTO mainmenuconfig (infoid,visible,resourceid,resourcetype,viewIndex) 
SELECT b.id, 1, a.id,2,b.defaultIndex FROM HrmSubCompany a , MainMenuInfo b WHERE b.id=10164
GO
