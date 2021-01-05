alter table cptcapital alter column alertnum decimal(18,2)
go
SET IDENTITY_INSERT cptDefineField ON
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) values(-37,0,'alertnum',15294,'decimal(18,2)','1',3,0,'','',0,'1037',0,0,0,'1','0','1','1','0',1)
go
SET IDENTITY_INSERT cptDefineField OFF
GO
insert into SysPoppupInfo(type,link,description,statistic,typedescription) values(21,'/cpt/search/cptalertnumsearch.jsp','82901','y','82901')
go