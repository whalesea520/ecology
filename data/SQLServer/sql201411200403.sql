ALTER TABLE CRM_T_ShareInfo ADD seclevelMax TINYINT DEFAULT 100
GO

ALTER TABLE CRM_ShareInfo ADD seclevelMax TINYINT DEFAULT 100
GO

ALTER TABLE Contract_ShareInfo ADD seclevelMax TINYINT DEFAULT 100
GO

ALTER TABLE Contract_ShareInfo ADD isdefault CHAR(1) 
GO

ALTER TABLE Contract_ShareInfo ADD subcompanyid INT 
GO

ALTER TABLE coworkshare ADD seclevelMax TINYINT DEFAULT 100
GO

ALTER TABLE cotype_sharemanager ADD seclevelMax TINYINT DEFAULT 100
GO

ALTER TABLE cotype_sharemembers ADD seclevelMax TINYINT DEFAULT 100
GO 

ALTER TABLE blog_share ADD seclevelMax TINYINT DEFAULT 100
GO

ALTER TABLE blog_tempShare ADD seclevelMax TINYINT DEFAULT 100
GO

ALTER TABLE blog_specifiedShare ADD seclevelMax TINYINT DEFAULT 100
GO

UPDATE CRM_T_ShareInfo SET seclevelMax = 100
GO

UPDATE CRM_ShareInfo SET seclevelMax = 100
GO

UPDATE Contract_ShareInfo SET seclevelMax = 100 , subcompanyid = 0
GO

UPDATE coworkshare SET seclevelMax = 100
GO

UPDATE cotype_sharemanager SET seclevelMax = 100
GO

UPDATE cotype_sharemembers SET seclevelMax = 100
GO

UPDATE blog_share SET seclevelMax = 100
GO

UPDATE blog_tempShare SET seclevelMax = 100
GO

UPDATE blog_specifiedShare SET seclevel = 0 , seclevelMax = 100
GO

ALTER PROCEDURE CRM_T_ShareInfo_Insert (
	@relateditemid INT,
	@sharetype tinyint,
	@seclevel tinyint,
	@seclevelMax tinyint,
	@rolelevel tinyint,
	@sharelevel tinyint,
	@userid INT,
	@departmentid INT,
	@roleid INT,
	@foralluser tinyint ,
	@subcompanyid INT,
	@flag INTEGER OUTPUT,
	@msg VARCHAR (80) OUTPUT
) AS INSERT INTO CRM_T_ShareInfo (
	relateditemid,
	sharetype,
	seclevel,
	seclevelMax,
	rolelevel,
	sharelevel,
	userid,
	departmentid,
	roleid,
	foralluser,
	subcompanyid
)
VALUES
	(
		@relateditemid,
		@sharetype,
		@seclevel,
		@seclevelMax,
		@rolelevel,
		@sharelevel,
		@userid,
		@departmentid,
		@roleid,
		@foralluser ,
		@subcompanyid
	)
SET @flag = 1
SET @msg = 'ok'
GO


ALTER PROCEDURE CRM_ShareInfo_Insert (@relateditemid int, @sharetype tinyint, @seclevel  tinyint,@seclevelMax  tinyint, @rolelevel tinyint, @sharelevel tinyint, @userid int, @departmentid int, @roleid int, @foralluser tinyint, @contents int, @flag integer output, @msg varchar(80) output ) AS INSERT INTO CRM_ShareInfo ( relateditemid, sharetype, seclevel, seclevelMax ,rolelevel, sharelevel, userid, departmentid, roleid, foralluser,contents ) VALUES ( @relateditemid , @sharetype , @seclevel , @seclevelMax ,@rolelevel , @sharelevel, @userid, @departmentid, @roleid, @foralluser, @contents  ) set @flag=1 set @msg='ok' 
GO

ALTER PROCEDURE Contract_ShareInfo_Ins ( @relateditemid int, @sharetype tinyint, @seclevel  tinyint, @seclevelMax  tinyint, @rolelevel tinyint, @sharelevel tinyint, @userid int, @departmentid int, @subcompanyid int ,@roleid int, @foralluser tinyint, @flag integer output, @msg varchar(80) output ) AS INSERT INTO Contract_ShareInfo ( relateditemid, sharetype, seclevel, seclevelMax, rolelevel, sharelevel, userid, departmentid, subcompanyid ,roleid, foralluser ) VALUES ( @relateditemid , @sharetype , @seclevel , @seclevelMax , @rolelevel , @sharelevel, @userid, @departmentid, @subcompanyid ,@roleid, @foralluser  ) set @flag=1 set @msg='ok'
GO

DECLARE @id INT 
DECLARE @manager INT 
DECLARE @crm_manager INT 

DECLARE contract_cursor CURSOR FOR SELECT id ,  manager ,(SELECT manager FROM CRM_CustomerInfo WHERE id = crmid) AS crm_manager FROM CRM_Contract 
OPEN contract_cursor
FETCH next FROM contract_cursor INTO @id ,@manager,@crm_manager
WHILE(@@FETCH_STATUS =0)
BEGIN

insert into Contract_ShareInfo (relateditemid,sharetype,seclevel,seclevelMax,rolelevel, sharelevel,userid,departmentid,subcompanyid,roleid,foralluser,isdefault)
 values (@id,1,0,0,0,2,@manager,0,0,0,0,1);


insert into Contract_ShareInfo (relateditemid,sharetype,seclevel,seclevelMax,rolelevel, sharelevel,userid,departmentid,subcompanyid,roleid,foralluser,isdefault)
SELECT  @id,1,0,0,0,3,id,0,0,0,0,1 FROM HrmResource WHERE 
	(SELECT managerstr FROM HrmResource WHERE id = @manager) LIKE '%,'+convert(VARCHAR(20), id)+',%';
	
IF (@crm_manager != @manager) BEGIN 
	insert into Contract_ShareInfo (relateditemid,sharetype,seclevel,seclevelMax,rolelevel, sharelevel,userid,departmentid,subcompanyid,roleid,foralluser,isdefault)
	 values (@id,1,0,0,0,1,@crm_manager,0,0,0,0,1);
	 
	insert into Contract_ShareInfo (relateditemid,sharetype,seclevel,seclevelMax,rolelevel, sharelevel,userid,departmentid,subcompanyid,roleid,foralluser,isdefault)
	SELECT  @id,1,0,0,0,1,id,0,0,0,0,1 FROM HrmResource WHERE 
		(SELECT managerstr FROM HrmResource WHERE id = @crm_manager) LIKE '%,'+convert(VARCHAR(20), id)+',%';
END

FETCH next FROM contract_cursor INTO @id ,@manager , @crm_manager
END 
CLOSE  contract_cursor
DEALLOCATE contract_cursor	
GO

