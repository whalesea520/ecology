insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-15,-1,0,'procode',17852,'varchar(50)','1',1,0,'','',0,'-101',0,0,0,'1','1','1','1','0',1)
/
insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-16,-1,0,'status',602,'int','1',2,0,'','',0,'-86',0,0,0,'1','1','1','1','0',1)
/
alter table cus_formfield add groupid  int
/
update cus_formfield set groupid=3,fieldorder=1000 where scope='ProjCustomField'
/