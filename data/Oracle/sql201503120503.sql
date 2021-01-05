insert into workflow_bill(id,namelabel,tablename,detailkeyfield) values((select min(id)-1 as id from workflow_bill),82558,'uf_Reply','mainid')
/
create table uf_Reply(id int primary key, requestId int)
/
create sequence uf_Reply_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger uf_Reply_id_Tri
before insert on uf_Reply
for each row
begin
select uf_Reply_id.nextval into :new.id from dual;
end;
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
values ((select min(id) as id from workflow_bill),'rqid',82559,'varchar2(50)',1,1,0,0,'',1,0,0,100,100,0,0)
/
alter table uf_Reply add rqid varchar2(50)
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
values ((select min(id) as id from workflow_bill),'rqmodeid',82560,'varchar2(50)',1,1,0,0,'',1,0,0,100,100,0,0)
/
alter table uf_Reply add rqmodeid varchar2(50)
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
values ((select min(id) as id from workflow_bill),'replyor',33286,'int',3,1,0,0,'',1,0,0,100,100,0,0)
/
alter table uf_Reply add replyor int
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
values ((select min(id) as id from workflow_bill),'replydate',82561,'char(10)',3,2,0,0,'',1,0,0,100,100,0,0)
/
alter table uf_Reply add replydate char(10)
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
values ((select min(id) as id from workflow_bill),'replytime',33287,'char(10)',3,19,0,0,'',1,0,0,100,100,0,0)
/
alter table uf_Reply add replytime char(10)
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
values ((select min(id) as id from workflow_bill),'replycontent',82562,'varchar2(4000)',2,2,0,0,'',1,4,0,100,100,0,0)
/
alter table uf_Reply add replycontent varchar2(4000)
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
values ((select min(id) as id from workflow_bill),'rattach',22194,'varchar2(4000)',6,1,0,0,'',1,5,0,100,100,0,0)
/
alter table uf_Reply add rattach varchar2(4000)
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
values ((select min(id) as id from workflow_bill),'Quotesid',19422,'varchar2(50)',1,1,0,0,'',1,0,0,100,100,0,0)
/
alter table uf_Reply add Quotesid varchar2(50)
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
values ((select min(id) as id from workflow_bill),'Commentid',675,'varchar2(50)',1,1,0,0,'',1,0,0,100,100,0,0)
/
alter table uf_Reply add Commentid varchar2(50)
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws)
values ((select min(id) as id from workflow_bill),'CommentTopid',82563,'varchar2(50)',1,1,0,0,'',1,0,0,100,100,0,0)
/
alter table uf_Reply add CommentTopid varchar2(50)
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
values ((select min(id) as id from workflow_bill),'CommentUsersid',82564,'varchar2(50)',3,1,0,0,'',1,0,0,100,100,0,0)
/
alter table uf_Reply add CommentUsersid int
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws)
values ((select min(id) as id from workflow_bill),'floorNum',27520,'int',1,2,0,0,'',1,0,0,100,100,0,0)
/
alter table uf_Reply add floorNum int
/
alter table modeinfo add isAllowReply int
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
values ((select min(id) as id from workflow_bill),'rdocument',857,'varchar2(4000)',3,37,0,0,'',1,0,0,100,100,0,0)
/
alter table uf_Reply add rdocument varchar2(4000)
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
values ((select min(id) as id from workflow_bill),'rworkflow',22105,'varchar2(4000)',3,152,0,0,'',1,0,0,100,100,0,0)
/
alter table uf_Reply add rworkflow varchar2(4000)
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
values ((select min(id) as id from workflow_bill),'rcustomer',783,'varchar2(4000)',3,18,0,0,'',1,0,0,100,100,0,0)
/
alter table uf_Reply add rcustomer varchar2(4000)
/
insert into workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,fromuser,textheight,childfieldid,imgwidth,imgheight,places,qfws) 
values ((select min(id) as id from workflow_bill),'rproject',782,'varchar2(4000)',3,135,0,0,'',1,0,0,100,100,0,0)
/
alter table uf_Reply add rproject varchar2(4000)
/
create table formEngineSet(
	id int primary key,
	appid int,
	modeid int,
	initformModeReply int,
	isEnFormModeReply int,
	isdelete int
)
/
create sequence formEngineSet_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger formEngineSet_id_Tri
before insert on formEngineSet
for each row
begin
select formEngineSet_id.nextval into :new.id from dual;
end;
/