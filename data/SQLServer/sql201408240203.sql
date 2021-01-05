alter table cowork_items add  replyNum int DEFAULT 0
GO
alter table cowork_items add  readNum int DEFAULT 0
GO
alter table cowork_items add  lastupdatedate VARCHAR(10)
GO
alter table cowork_items add  lastupdatetime VARCHAR(10)
GO
alter table cowork_discuss add topdiscussid int DEFAULT 0
GO
alter table cowork_discuss add commentid int DEFAULT 0
GO
alter table cowork_discuss add commentuserid int DEFAULT 0
GO
alter table cowork_discuss add istop int DEFAULT 0
GO
update cowork_discuss set topdiscussid=0,commentid=0,commentuserid=0,istop=0
GO

declare @coworkid INT
declare @replyNum INT
declare @readNum INT
declare @lastupdatedate VARCHAR(10)
declare @lastupdatetime VARCHAR(10)
declare cursor0 cursor for SELECT id FROM cowork_items ORDER BY id
open cursor0
fetch next from cursor0 into @coworkid
while(@@fetch_status=0)
BEGIN

select @replyNum=count(*) from cowork_discuss where coworkid=@coworkid and commentid=0

select @readNum=count(*) from cowork_log where coworkid=@coworkid and type=2

select @lastupdatedate=createdate,@lastupdatetime=createtime from cowork_discuss 
where id=(select max(id) from cowork_discuss where coworkid=@coworkid)


if @lastupdatedate='' or @lastupdatetime=''
	 BEGIN
   update cowork_items set replyNum=@replyNum,readNum=@readNum,lastupdatedate=createdate,lastupdatetime=createtime where id=@coworkid
	 END
ELSE
	 BEGIN
   update cowork_items set replyNum=@replyNum,readNum=@readNum,lastupdatedate=@lastupdatedate,lastupdatetime=@lastupdatetime where id=@coworkid
   END
fetch next from cursor0 into @coworkid
end
close cursor0
deallocate cursor0
GO


alter table cowork_types add isApproval int DEFAULT 0
GO
alter table cowork_types add isAnonymous int DEFAULT 0
GO
update cowork_types set isApproval=0,isAnonymous=0
GO

alter table cowork_items add isApproval int DEFAULT 0 --协作是否需要审批
GO
alter table cowork_items add isAnonymous int DEFAULT 0 --协作是否允许匿名
GO
alter table cowork_items add approvalAtatus int DEFAULT 0 --协作审批状态
GO
update cowork_items set isApproval=0,isAnonymous=0,approvalAtatus=0
GO
alter table cowork_discuss add approvalAtatus int DEFAULT 0 --留言审批状态
GO
alter table cowork_discuss add isAnonymous int DEFAULT 0 --留言是否匿名
GO
alter table cowork_discuss add isDel int DEFAULT 0
GO
update cowork_discuss set approvalAtatus=0,isAnonymous=0,isDel=0 
GO


alter table cowork_items add isTop int DEFAULT 0 --协作是否顶置协作
GO
update cowork_items set isTop=0
GO


update leftmenuconfig set visible=0  where infoid='81'
GO
update leftmenuconfig set visible=0  where infoid='99'
GO
update leftmenuconfig set visible=0  where infoid='100'
GO
update leftmenuconfig set visible=0  where infoid='495'
GO

ALTER TABLE cowork_maintypes ADD  sequence INT
GO

DECLARE @id INT 
DECLARE @num INT 
DECLARE mycursor CURSOR FOR SELECT id FROM  cowork_maintypes ORDER BY id asc 
SET @num = 0
OPEN mycursor 
FETCH next FROM mycursor INTO @id
WHILE(@@FETCH_STATUS=0)
BEGIN
SET @num = @num+1;
SELECT @num
UPDATE cowork_maintypes SET sequence = @num WHERE id = @id
FETCH next FROM mycursor INTO @id
END
CLOSE mycursor
DEALLOCATE mycursor
GO


CREATE TABLE dbo.cowork_app
	(
	id       INT IDENTITY NOT NULL,
	name     VARCHAR (20) NULL,
	isActive INT NULL,
	appType  VARCHAR (50) NULL,
	sort     INT NULL,
	iconPath VARCHAR (255) NULL
	)
GO


INSERT INTO cowork_app (name, isActive, appType, sort, iconPath) VALUES ('58', 1, 'doc', 1, 'images/app-doc.png')
GO
INSERT INTO cowork_app (name, isActive, appType, sort, iconPath) VALUES ('18015', 1, 'workflow', 2, 'images/app-wl.png')
GO
INSERT INTO cowork_app (name, isActive, appType, sort, iconPath) VALUES ('136', 1, 'crm', 3, 'images/app-crm.png')
GO
INSERT INTO cowork_app (name, isActive, appType, sort, iconPath) VALUES ('101', 1, 'project', 4, 'images/app-project.png')
GO
INSERT INTO cowork_app (name, isActive, appType, sort, iconPath) VALUES ('1332', 1, 'task', 5, 'images/app-task.png')
GO
INSERT INTO cowork_app (name, isActive, appType, sort, iconPath) VALUES ('156', 1, 'attachment', 6, '')
GO
INSERT INTO cowork_app (name, isActive, appType, sort, iconPath) VALUES ('2211', 1, 'workplan', 7, 'images/app-workplan.png')
GO

create table cowork_remind(
	id int IDENTITY,
	reminderid int,
	discussid int,
	coworkid int,
	createdate varchar(10),
	createtime varchar(8)
)
GO

update leftmenuconfig set visible=0  where infoid='351'
GO

