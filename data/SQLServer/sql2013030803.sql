update mode_pageexpandtemplate set expendname = '保存' where issystemflag = 1
go
update mode_pageexpandtemplate set expendname = '保存' where issystemflag = 2
go
update mode_pageexpandtemplate set expendname = '编辑' where issystemflag = 3
go
update mode_pageexpandtemplate set expendname = '共享' where issystemflag = 4
go
update mode_pageexpandtemplate set expendname = '删除' where issystemflag = 5
go
update mode_pageexpandtemplate set expendname = '删除' where issystemflag = 6
go
update mode_pageexpand set expendname = '保存' where issystemflag = 1
go
update mode_pageexpand set expendname = '保存' where issystemflag = 2
go
update mode_pageexpand set expendname = '编辑' where issystemflag = 3
go
update mode_pageexpand set expendname = '共享' where issystemflag = 4
go
update mode_pageexpand set expendname = '删除' where issystemflag = 5
go
update mode_pageexpand set expendname = '删除' where issystemflag = 6
go

alter table mode_customsearch add opentype int
go

create table mode_batchSet(
	id int identity,
	expandid int,
	showorder decimal(15,2),
	customsearchid int,
	isuse int
)
go
alter table mode_pageexpandtemplate add expenddesc varchar(4000)
go
alter table mode_pageexpandtemplate add isbatch int default 0
go
alter table mode_pageexpandtemplate add defaultenable int default 0
go
alter table mode_pageexpand add expenddesc varchar(4000)
go
alter table mode_pageexpand add isbatch int default 0
go
alter table mode_pageexpand add defaultenable int default 0
go
alter table mode_batchSet add listbatchname varchar(100)
go
alter table mode_pageexpand add createpage int default 0
go
alter table mode_pageexpand add managepage int default 0
go
alter table mode_pageexpand add viewpage int default 0
go
alter table mode_pageexpand add moniterpage int default 0
go
alter table mode_customsearch add norightlist char(1) default 0
go


update mode_pageexpandtemplate set isbatch = 0,defaultenable=0
go
update mode_pageexpand set isbatch = 0,defaultenable=0
go
update mode_pageexpand set createpage=1,managepage=1,viewpage=1,moniterpage=0 where issystem = 0
go



insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('搜索','2','3','0','0','','1','100','1','100','搜索','1','1')
go
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('新建','2','3','0','0','','1','101','1','101','新建','1','1')
go
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('删除','2','3','0','0','','1','102','1','102','删除','1','1')
go
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('批量导入','2','3','0','0','','1','103','1','103','批量导入','1','1')
go
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('批量共享','2','3','0','0','','1','104','1','104','批量共享','1','1')
go

insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'搜索','2','3','0','0','','1','100','1','100','搜索','1','1' from modeinfo
go
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'新建','2','3','0','0','','1','101','1','101','新建','1','1' from modeinfo
go
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'删除','2','3','0','0','','1','102','1','102','删除','1','1' from modeinfo
go
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'批量导入','2','3','0','0','','1','103','1','103','批量导入','1','1' from modeinfo
go
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'批量共享','2','3','0','0','','1','104','1','104','批量共享','1','1' from modeinfo
go

alter table mode_customtree add defaultaddress varchar(4000)
go
alter table mode_customtree add expandfirstnode char(1)
go
alter table mode_customtreedetail add iconField varchar(100)
go
alter table mode_customtreedetail add dataorder varchar(1000)
go
alter table mode_customtreedetail add datacondition varchar(4000)
go
alter table mode_customtreedetail add hrefField varchar(100)
go

Delete from MainMenuInfo where id=1239
GO
EXECUTE MMConfig_U_ByInfoInsert 1207,3
GO
EXECUTE MMInfo_Insert 1239,30063,'自定义页面设置','/formmode/custompage/CustomList.jsp','mainFrame',1207,2,3,0,'',0,'',0,'','',0,'','',9
GO

create PROCEDURE mode_createviewlog_p 
AS 
DECLARE
	@TableIndex sysname, 
	@tablename varchar(100), 
	@sql varchar(1000),
	@existstable int
DECLARE 
	tableindex_cur CURSOR FOR 
select id from modeinfo
OPEN tableindex_cur 
FETCH NEXT FROM tableindex_cur INTO @TableIndex
WHILE @@fetch_status = 0
	BEGIN 
	    IF @@fetch_status = -2
	      CONTINUE
	      	SELECT @tablename = 'ModeViewLog_' + @TableIndex
	      	select @existstable=count(*) from sysobjects where name=@tablename
	      	if @existstable = 0
	      	begin
				set @sql='CREATE TABLE '+@tablename+' (
					id int IDENTITY (1, 1) NOT NULL ,
					relatedid int NOT NULL ,
					relatedname varchar (1000)  NOT NULL ,
					operatetype int  NOT NULL ,
					operatedesc text  NULL ,
					operateuserid int NOT NULL ,
					operatedate char (10)  NOT NULL ,
					operatetime char (8)  NOT NULL ,
					clientaddress varchar (30)  NULL,
					CONSTRAINT PK_'+@tablename+' PRIMARY KEY NONCLUSTERED (id ASC)
				)' 
				exec (@sql)
				set @sql='create clustered index '+@tablename+'_operatetype on '+@tablename+' (relatedid,operatetype,operateuserid)'
				exec (@sql)
			end
		FETCH NEXT FROM tableindex_cur INTO @TableIndex
	END
close tableindex_cur
DEALLOCATE tableindex_cur
GO
EXEC mode_createviewlog_p
go       
drop PROCEDURE mode_createviewlog_p 
go