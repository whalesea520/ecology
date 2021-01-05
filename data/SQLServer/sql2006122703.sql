create table shareinnerhp(
	id int IDENTITY (1, 1) NOT NULL,
	hpid int not null,
	type int not null, 
	content int not null,
	seclevel int not null default 0,
	sharelevel int not null default 1
)
create index sihp_type_contnet on shareinnerhp(type,content)
GO

insert into shareinnerhp (hpid,type,content) values (1,5,1)
GO
insert into shareinnerhp (hpid,type,content) values (2,5,1)
GO
insert into shareinnerhp (hpid,type,content) select  id,2,subcompanyid from  hpinfo  where id not in (1,2)
GO

alter table hpinfo add creatortype int 
go
alter table hpinfo add creatorid int 
go
update hpinfo set creatortype=4,creatorid=1 where id in (1,2)
go
update hpinfo set creatortype=3,creatorid=subcompanyid where id not in (1,2)
go

drop table hpsubcompanyappiont
go

alter table hpinfo add showtype int  default 1
go
alter table hpinfo add parentHpid int  default 0
go
alter table hpinfo add ordernum varchar(50) 
go
update hpinfo  set showtype=1,parenthpid=0,ordernum=cast(id as varchar(50))+'.0'
go

alter table hpinfo add isLocked int  default 0
GO
update hpinfo set isLocked=0
GO
update hpinfo set isuse=1 where isuse=2
GO

alter table  hpstyle add  navbgcolor varchar(50) 
go
alter table  hpstyle add  navcolor varchar(50) 
go
alter table  hpstyle add  navselectedbgcolor varchar(50) 
go
alter table  hpstyle add  navselectedcolor varchar(50) 
go
alter table  hpstyle add  navbackgroudimg varchar(50) 
go
alter table  hpstyle add  navbordercolor varchar(50) 
go
alter table  hpstyle add  navselectedbackgroudimg varchar(50) 
go

update hpstyle set navbgcolor='',navcolor='#E2E7ED',navselectedbgcolor='#235EA7',navselectedcolor='#FFFFFF',navbordercolor='#235EA7',navbackgroudimg='/images/homepage/navgatebg.gif',navselectedbackgroudimg=''
go

create table hpcurrentuse(
	id int IDENTITY (1, 1) NOT NULL,
	hpid int not null,
	userid int not null, 
	usertype int not null
)
GO
create index uid_utype_hpcurrentuse on hpcurrentuse(userid,usertype)
GO

insert into hpbaseelement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc)
values(17,2,'多新闻中心','/images/homepage/element/news_m.gif',5,2,'getNews_m','可以设定多个新闻页')
GO
insert into hpWhereElement(id,elementid,settingshowmethod,getwheremethod) 
values (17,17,'getNews_mSettingStr','')
go
insert into hpextelement(id,extsettinge,extopreate,extshow,description)
values(17,'','','News_M.jsp','多新闻页的处理')
GO

INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 46,17,'229','docdocsubject','0','','*','/docs/docs/DocDsp.jsp?id=','id','1',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 47,17,'19521','doclastmoddate','1','','76','','','',4)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 48,17,'19520','doclastmodtime','1','','62','','','',5)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 50,17,'74','img','0','','','','','0',3)
GO

insert into hpbaseelement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc)
values(18,2,'期刊中心','/images/homepage/element/magazine.gif',5,2,'getMagazine','得到所有的期刊')
GO
insert into hpWhereElement(id,elementid,settingshowmethod,getwheremethod) 
values (18,18,'getMagazineSettingStr','')
go
insert into hpextelement(id,extsettinge,extopreate,extshow,description)
values(18,'','','Magazine.jsp','期刊的处理')
GO

INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 51,18,'229','docsubject','0','','*','','id','1',1)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 52,18,'341','summary','0','','','','','1',2)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 53,18,'74','img','0','','','','','0',3)
GO
INSERT INTO hpFieldElement( id,elementid,fieldname,fieldColumn,isDate,transMethod,fieldwidth,linkurl,valuecolumn,isLimitLength,ordernum) 
VALUES ( 54,18,'20052','list','0','','','','','0',4)
GO

insert into hpbaseelement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc)
values(19,2,'股票元素','/images/homepage/element/stock.gif',5,1,'getStockMore','可以查看设定的股票信息')
GO
insert into hpWhereElement(id,elementid,settingshowmethod,getwheremethod) 
values (19,19,'getStockSettingStr','')
go
insert into hpextelement(id,extsettinge,extopreate,extshow,description)
values(19,'','','Stock.jsp','股票的处理')
GO

create table WebMagazineType(
    [id] int IDENTITY(1,1) NOT NULL ,
    [name]   varchar(200),
    [remark]  varchar(400)
)
go

create table WebMagazine(
    [id] int IDENTITY(1,1) NOT NULL ,
    [typeID] int ,
    [releaseYear]   char(4),
    [name]   varchar(200),    
    [docID]  varchar(100),
    [createDate] char(10)
)
go

create table WebMagazineDetail(
    [id] int IDENTITY(1,1) NOT NULL ,
    [mainID]   int,
    [name] varchar(200),
    [isView] char(1) ,
    [docID]  varchar(1000)
)
go

alter table imagefile add  miniimgpath varchar(200) null
go
