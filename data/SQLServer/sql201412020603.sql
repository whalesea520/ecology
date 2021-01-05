INSERT INTO MainMenuInfo
(id,labelid,parentid,menuName,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t) 
SELECT 10157,81719,10078,menuName,'/hrm/city/HrmCityTwo.jsp',parentFrame,defaultParentId,defaultLevel,1,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t FROM MainMenuInfo 
WHERE  id = 10004
GO

INSERT INTO mainmenuconfig (infoid,visible,viewindex,resourceid,resourcetype) VALUES(10157,1,1,1,1)
GO

INSERT INTO mainmenuconfig (infoid,visible,resourceid,resourcetype,viewIndex) 
SELECT b.id, 1, a.id,2,b.defaultIndex FROM HrmSubCompany a , MainMenuInfo b WHERE b.id>10156
GO

update MainMenuInfo set defaultIndex = 2 where id= 351
GO
update mainmenuconfig set viewindex = 2 where infoid= 351
GO
update MainMenuInfo set defaultIndex = 3 where id= 1328
GO
update mainmenuconfig set viewindex = 3 where infoid= 1328
GO
