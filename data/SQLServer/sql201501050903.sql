
update MainMenuInfo set id = 10158 where id=10157 AND labelId = 81719
GO

delete from mainmenuconfig where infoid=10157
GO

INSERT INTO mainmenuconfig (infoid,visible,viewindex,resourceid,resourcetype) VALUES(10157,1,18,1,1)
GO

INSERT INTO mainmenuconfig (infoid,visible,resourceid,resourcetype,viewIndex) 
SELECT b.id, 1, a.id,2,b.defaultIndex FROM HrmSubCompany a , MainMenuInfo b WHERE b.id=10157
GO


INSERT INTO mainmenuconfig (infoid,visible,viewindex,resourceid,resourcetype) VALUES(10158,1,1,1,1)
GO

INSERT INTO mainmenuconfig (infoid,visible,resourceid,resourcetype,viewIndex) 
SELECT b.id, 1, a.id,2,b.defaultIndex FROM HrmSubCompany a , MainMenuInfo b WHERE b.id=10158
GO




INSERT INTO MainMenuInfo
(id,labelid,parentid,menuName,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t) 
SELECT 10159,81856,1353,menuName,'/proj/ffield/prjtskfreefieldtab.jsp',parentFrame,defaultParentId,defaultLevel,4,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t FROM MainMenuInfo 
WHERE  id = 10004
GO

INSERT INTO mainmenuconfig (infoid,visible,viewindex,resourceid,resourcetype) VALUES(10159,1,4,1,1)
GO

INSERT INTO mainmenuconfig (infoid,visible,resourceid,resourcetype,viewIndex) 
SELECT b.id, 1, a.id,2,b.defaultIndex FROM HrmSubCompany a , MainMenuInfo b WHERE b.id=10159
GO

INSERT INTO MainMenuInfo
(id,labelid,parentid,menuName,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t) 
SELECT 10160,81757,6,menuName,'/proj/imp/prjimp.jsp',parentFrame,defaultParentId,defaultLevel,5,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t FROM MainMenuInfo 
WHERE  id = 10004
GO

INSERT INTO mainmenuconfig (infoid,visible,viewindex,resourceid,resourcetype) VALUES(10160,1,5,1,1)
GO

INSERT INTO mainmenuconfig (infoid,visible,resourceid,resourcetype,viewIndex) 
SELECT b.id, 1, a.id,2,b.defaultIndex FROM HrmSubCompany a , MainMenuInfo b WHERE b.id=10160
GO


update mainmenuconfig set viewIndex = 1 where infoid = 1258
GO
update MainMenuInfo set defaultIndex = 1 where id = 1258
GO

update mainmenuconfig set viewIndex = 2 where infoid = 67
GO
update MainMenuInfo set defaultIndex = 2 where id = 67
GO

update mainmenuconfig set viewIndex = 3 where infoid = 68
GO
update MainMenuInfo set defaultIndex = 3 where id = 68
GO

update mainmenuconfig set viewIndex = 4 where infoid = 1305
GO
update MainMenuInfo set defaultIndex = 4 where id = 1305
GO