ALTER TABLE SystemTemplate ADD skin VARCHAR(200)
GO
UPDATE MainMenuInfo SET linkAddress = '/systeminfo/template/templateFrame.jsp' WHERE id = 1283
GO

DELETE FROM MainMenuInfo WHERE id=10090
GO


create table ecology8theme(
	id int IDENTITY(1, 1)  PRIMARY KEY,
	name varchar(200),
	type varchar(50),
	style varchar(10),
	cssfile varchar(50),
	logocolor VARCHAR(12),
	hrmcolor VARCHAR(12),
	leftcolor VARCHAR(12),
	topcolor VARCHAR(12),
	lastdate varchar(12),
	lasttime varchar(12)
)
GO
insert into ecology8theme (name,type,cssfile,logocolor,hrmcolor,leftcolor,topcolor,lastdate,lasttime,style)
values('��ɫ����','sys','left','#008df6','#003667','#2a2e34','#0070c1','2014-10-16','12:00:00','bright')
GO
insert into ecology8theme (name,type,cssfile,logocolor,hrmcolor,leftcolor,topcolor,lastdate,lasttime,style)
values('��ɫ����','sys','left1','#ac2b2a','#542f53','#482a49','#d25151','2014-10-16','12:00:00','bright')
GO
insert into ecology8theme (name,type,cssfile,logocolor,hrmcolor,leftcolor,topcolor,lastdate,lasttime,style)
values('��ɫ����','sys','left2','#8790e8','#5c64c2','#061c46','#5c66d4','2014-10-16','12:00:00','bright')
GO
insert into ecology8theme (name,type,cssfile,logocolor,hrmcolor,leftcolor,topcolor,lastdate,lasttime,style)
values('��ɫ����','sys','left3','#82b444','#649044','#2c4230','#50833b','2014-10-16','12:00:00','bright')
GO
insert into ecology8theme (name,type,cssfile,logocolor,hrmcolor,leftcolor,topcolor,lastdate,lasttime,style)
values('��ɫ����','sys','left4','#d6c1a1','#a57447','#3f1f0e','#874d19','2014-10-16','12:00:00','bright')
GO
insert into ecology8theme (name,type,cssfile,logocolor,hrmcolor,leftcolor,topcolor,lastdate,lasttime,style)
values('��ɫ����','sys','left5','#fde189','#fdaf60','#d65863','#f46f43','2014-10-16','12:00:00','bright')
GO
insert into ecology8theme (name,type,cssfile,logocolor,hrmcolor,leftcolor,topcolor,lastdate,lasttime,style)
values('��ɫ����','sys','left6','#bbf8d2','#9aeae4','#22c9b2','#94edf0','2014-10-16','12:00:00','dark')
GO


insert into ecology8theme (name,type,cssfile,logocolor,hrmcolor,leftcolor,topcolor,lastdate,lasttime,style)
values('õ������','sys','left7','#b59fc1','#c15f8d','#635aa4','#b24079','2014-10-16','12:00:00','bright')
GO
insert into ecology8theme (name,type,cssfile,logocolor,hrmcolor,leftcolor,topcolor,lastdate,lasttime,style)
values('���Ⱥ�����','sys','left8','#b09790','#696882','#615363','#83686c','2014-10-16','12:00:00','bright')
GO
insert into ecology8theme (name,type,cssfile,logocolor,hrmcolor,leftcolor,topcolor,lastdate,lasttime,style)
values('��ҵ������','sys','left9','#85bfd6','#627998','#3f526d','#657081','2014-10-16','12:00:00','bright')
GO
insert into ecology8theme (name,type,cssfile,logocolor,hrmcolor,leftcolor,topcolor,lastdate,lasttime,style)
values('��ȡ������','sys','left10','#fd9273','#2ac5c0','#627f7e','#40555b','2014-10-16','12:00:00','bright')
GO




INSERT INTO MainMenuInfo
(id,labelid,parentid,menuName,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t) 
SELECT 10152,33387,10110,menuName,'/integration/integrationTab.jsp?urlType=18',parentFrame,defaultParentId,defaultLevel,11,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,needSwitchToView,switchclassNameToView,switchMethodNameToView,useCustomName,customname,relatedModuleId,iconUrl,customName_e,isCustom,menulevel,baseTarget,refersubid,module,customName_t,topmenuname,topname_e,topname_t FROM MainMenuInfo 
WHERE  id = 10120
GO



INSERT INTO mainmenuconfig (infoid,visible,viewindex,resourceid,resourcetype) VALUES(10152,1,1,1,1)
GO

INSERT INTO mainmenuconfig (infoid,visible,resourceid,resourcetype,viewIndex) 
SELECT b.id, 1, a.id,2,b.defaultIndex FROM HrmSubCompany a , MainMenuInfo b WHERE b.id>10151
GO