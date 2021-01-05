create table shareinnerhp(
	id integer  NOT NULL,
	hpid integer not null,
	type integer not null, 
	content integer not null,
	seclevel integer  default 0 not null,
	sharelevel integer  default 1 not null
)
/

create sequence  shareinnerhp_id                                     
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger shareinnerhp_trigger		
	before insert on shareinnerhp
	for each row
	begin
	select shareinnerhp_id.nextval into :new.id from dual;
	end ;
/


create index sihp_type_contnet on shareinnerhp(type,content)
/

insert into shareinnerhp (hpid,type,content) values (1,5,1)
/
insert into shareinnerhp (hpid,type,content) values (2,5,1)
/
insert into shareinnerhp (hpid,type,content) select  id,2,subcompanyid from  hpinfo  where id not in (1,2)
/

alter table hpinfo add creatortype integer 
/
alter table hpinfo add creatorid integer 
/
update hpinfo set creatortype=4 where id in (1,2)
/
update hpinfo set creatorid=1 where id in (1,2)
/

update hpinfo set creatortype=3 where id not in (1,2)
/
update hpinfo set creatorid=subcompanyid where id not in (1,2)
/

drop table hpsubcompanyappiont
/

alter table hpinfo add showtype integer  default 1
/
alter table hpinfo add parentHpid integer  default 0
/
alter table hpinfo add ordernum varchar2(50) 
/
update hpinfo  set showtype=1
/
update hpinfo  set parenthpid=0
/
update hpinfo  set ordernum=cast(id as varchar(50))+'.0'
/

alter table hpinfo add isLocked integer  default 0
/
update hpinfo set isLocked=0
/
update hpinfo set isuse=1 where isuse=2
/

alter table  hpstyle add  navbgcolor varchar2(50) 
/
alter table  hpstyle add  navcolor varchar2(50) 
/
alter table  hpstyle add  navselectedbgcolor varchar2(50) 
/
alter table  hpstyle add  navselectedcolor varchar2(50) 
/
alter table  hpstyle add  navbackgroudimg varchar2(50) 
/
alter table  hpstyle add  navbordercolor varchar2(50) 
/
alter table  hpstyle add  navselectedbackgroudimg varchar2(50) 
/

update hpstyle set navbgcolor=''
/
update hpstyle set navcolor='#E2E7ED'
/
update hpstyle set navselectedbgcolor='#235EA7'
/
update hpstyle set navselectedcolor='#FFFFFF'
/
update hpstyle set navbordercolor='#235EA7'
/
update hpstyle set navbackgroudimg='/images/homepage/navgatebg.gif',navselectedbackgroudimg=''
/




create table hpcurrentuse(
	id integer   NOT NULL,
	hpid integer not null,
	userid integer not null, 
	usertype integer not null
)
/

create sequence  hpcurrentuse_id                                     
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger hpcurrentuse_trigger		
	before insert on hpcurrentuse
	for each row
	begin
	select hpcurrentuse_id.nextval into :new.id from dual;
	end ;
/


create index uid_utype_hpcurrentuse on hpcurrentuse(userid,usertype)
/

insert into hpbaseelement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc)
values(17,2,'多新闻中心','/images/homepage/element/news_m.gif',5,2,'getNews_m','可以设定多个新闻页')
/
insert into hpWhereElement(id,elementid,settingshowmethod,getwheremethod) 
values (17,17,'getNews_mSettingStr','')
/
insert into hpextelement(id,extsettinge,extopreate,extshow,description)
values(17,'','','News_M.jsp','多新闻页的处理')
/

INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 46,17,'229','docdocsubject','0','','*','/docs/docs/DocDsp.jsp?id=','id','1',1)
/
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 47,17,'19521','doclastmoddate','1','','76','','','',4)
/
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 48,17,'19520','doclastmodtime','1','','62','','','',5)
/
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 50,17,'74','img','0','','','','','0',3)
/

insert into hpbaseelement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc)
values(18,2,'期刊中心','/images/homepage/element/magazine.gif',5,2,'getMagazine','得到所有的期刊')
/
insert into hpWhereElement(id,elementid,settingshowmethod,getwheremethod) 
values (18,18,'getMagazineSettingStr','')
/
insert into hpextelement(id,extsettinge,extopreate,extshow,description)
values(18,'','','Magazine.jsp','期刊的处理')
/

INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 51,18,'229','docsubject','0','','*','','id','1',1)
/
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 52,18,'341','summary','0','','','','','1',2)
/
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 53,18,'74','img','0','','','','','0',3)
/
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 54,18,'20052','list','0','','','','','0',4)
/

insert into hpbaseelement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc)
values(19,2,'股票元素','/images/homepage/element/stock.gif',5,1,'getStockMore','可以查看设定的股票信息')
/
insert into hpWhereElement(id,elementid,settingshowmethod,getwheremethod) 
values (19,19,'getStockSettingStr','')
/
insert into hpextelement(id,extsettinge,extopreate,extshow,description)
values(19,'','','Stock.jsp','股票的处理')
/

create table WebMagazineType(
    id integer  NOT NULL ,
    name   varchar2(200),
    remark  varchar2(400)
)
/

create sequence  WebMagazineType_id                                     
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger WebMagazineType_trigger		
	before insert on WebMagazineType
	for each row
	begin
	select WebMagazineType_id.nextval into :new.id from dual;
	end ;
/



create table WebMagazine(
    id integer  NOT NULL ,
    typeID integer ,
    releaseYear   char(4),
    name   varchar2(200),    
    docID  varchar2(100),
    createDate char(10)
)
/

create sequence  WebMagazine_id                                     
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger WebMagazine_trigger		
	before insert on WebMagazine
	for each row
	begin
	select WebMagazine_id.nextval into :new.id from dual;
	end ;
/



create table WebMagazineDetail(
    id integer  NOT NULL ,
    mainID   integer,
    name varchar2(200),
    isView char(1) ,
    docID  varchar2(1000)
)
/

create sequence  WebMagazineDetail_id                                     
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger WebMagazineDetail_trigger		
	before insert on WebMagazineDetail
	for each row
	begin
	select WebMagazineDetail_id.nextval into :new.id from dual;
	end ;
/



alter table imagefile add  miniimgpath varchar2(200) null
/
