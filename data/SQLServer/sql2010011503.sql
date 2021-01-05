create table HrmPSLManagement(
   id int IDENTITY,
   resourceid int,   
   pslyear varchar(30),   
   psldays float,
   status int
)
GO

create table HrmPSLBatchProcess(
   id int IDENTITY,
   workingage float,
   psldays float,
   subcompanyid int
)
GO

create table HrmPSLPeriod(
   id int IDENTITY,
   PSLyear varchar(30),
   startdate varchar(30),
   enddate varchar(30),
   subcompanyid int
)
GO

INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,11,'´øÐ½²¡¼Ù',11,'n' from workflow_billfield where billid=180 and fieldname='otherLeaveType'
GO

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'lastyearpsldays',24039,'float',1,3,16,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'thisyearpsldays',24040,'float',1,3,10,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'allpsldays',24041,'float',1,3,13,0,'')
GO 

update workflow_billfield set dsporder=40 where billid=180 and fieldname='leaveReason'
GO

alter table bill_bohaileave add lastyearpsldays float
GO
alter table bill_bohaileave add thisyearpsldays float
GO
alter table bill_bohaileave add allpsldays float
GO
