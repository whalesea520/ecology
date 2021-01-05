insert into workflow_bill(id,namelabel,tablename,detailkeyfield) select min(id)-1 as id,82558,'uf_Reply','mainid' from workflow_bill
GO
create table uf_Reply(id int identity(1,1) primary key clustered, requestId int)
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'rqid',82559,'varchar(50)',1,1,0,0,'',1,0,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add rqid varchar(50)
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'rqmodeid',82560,'varchar(50)',1,1,0,0,'',1,0,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add rqmodeid varchar(50)
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'replyor',33286,'int',3,1,0,0,'',1,0,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add replyor int
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'replydate',82561,'char(10)',3,2,0,0,'',1,0,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add replydate char(10)
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'replytime',33287,'char(10)',3,19,0,0,'',1,0,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add replytime char(10)
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'replycontent',82562,'text',2,2,0,0,'',1,4,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add replycontent text
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'rattach',22194,'text',6,1,0,0,'',1,5,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add rattach text
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'Quotesid',19422,'varchar(50)',1,1,0,0,'',1,0,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add Quotesid varchar(50)
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'Commentid',675,'varchar(50)',1,1,0,0,'',1,0,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add Commentid varchar(50)
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'CommentTopid',82563,'varchar(50)',1,1,0,0,'',1,0,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add CommentTopid varchar(50)
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'CommentUsersid',82564,'varchar(50)',3,1,0,0,'',1,0,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add CommentUsersid int
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'floorNum',27520,'int',1,2,0,0,'',1,0,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add floorNum int
GO
alter table modeinfo add isAllowReply int
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'rdocument',857,'text',3,37,0,0,'',1,0,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add rdocument text
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'rworkflow',22105,'text',3,152,0,0,'',1,0,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add rworkflow text
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'rcustomer',783,'text',3,18,0,0,'',1,0,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add rcustomer text
GO
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
select min(id) as id,'rproject',782,'text',3,135,0,0,'',1,0,0,100,100,0,0 from workflow_bill
GO
alter table uf_Reply add rproject text
GO
create table formEngineSet(
	id int identity(1,1) primary key clustered,
	appid int,
	modeid int,
	initformModeReply int,
	isEnFormModeReply int,
	isdelete int
)
GO