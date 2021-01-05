alter table cptcapital add( temploss  number(18,2))     
/
update cptcapital set temploss = alertnum 
/
update cptcapital set alertnum = '' 
/
ALTER TABLE cptcapital modify alertnum  number(18,2)
/
update cptcapital set alertnum = temploss 
/
alter table cptcapital drop column temploss
/

insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) values(-37,0,'alertnum',15294,'decimal(18,2)','1',3,0,'','',0,'1037',0,0,0,'1','0','1','1','0',1)
/
update cptDefineField set id=-37 where fieldname='alertnum'
/
insert into SysPoppupInfo(type,link,description,statistic,typedescription) values(21,'/cpt/search/cptalertnumsearch.jsp','82901','y','82901')
/