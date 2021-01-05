ALTER TABLE CRM_T_ShareInfo ADD subcompanyid INT 
GO

ALTER PROCEDURE CRM_T_ShareInfo_Insert (
	@relateditemid INT,
	@sharetype tinyint,
	@seclevel tinyint,
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

DECLARE @id INT 
DECLARE @sharetype int
DECLARE @value VARCHAR(4000)

DECLARE managercursor CURSOR FOR 
SELECT id ,sharetype , sharevalue FROM cotype_sharemanager WHERE sharevalue LIKE '%,%'
OPEN managercursor
	FETCH next FROM managercursor INTO @id ,@sharetype, @value
	WHILE(@@FETCH_STATUS=0)
	BEGIN
	
		IF(@sharetype =1) BEGIN 
			INSERT into cotype_sharemanager(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype , t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemanager t1,HrmResource t2
			WHERE  t1.id = @id AND ','+t1.sharevalue+',' LIKE '%,'+convert(VARCHAR(200) ,t2.id)+',%'
		END 
		
		IF(@sharetype =2) BEGIN 
			INSERT into cotype_sharemanager(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype ,t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemanager t1,HrmDepartment t2
			WHERE  t1.id = @id AND ','+t1.sharevalue+',' LIKE '%,'+convert(VARCHAR(200) ,t2.id)+',%'
		END 
		
		IF(@sharetype =3) BEGIN 
			INSERT into cotype_sharemanager(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype ,t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemanager t1,HrmSubCompany t2
			WHERE  t1.id = @id AND ','+t1.sharevalue+',' LIKE '%,'+convert(VARCHAR(200) ,t2.id)+',%'
		END 
		
		IF(@sharetype =4) BEGIN 
			INSERT into cotype_sharemanager(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype ,t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemanager t1,HrmRoles t2
			WHERE  t1.id = @id AND ','+t1.sharevalue+',' LIKE '%,'+convert(VARCHAR(200) ,t2.id)+',%'
		END 
	   	
	   	DELETE FROM cotype_sharemanager WHERE id = @id
	   	
	FETCH next FROM managercursor INTO @id , @sharetype , @value
	END
CLOSE managercursor
DEALLOCATE managercursor
GO

DECLARE @id INT 
DECLARE @sharetype int
DECLARE @value VARCHAR(4000)
DECLARE membercursor CURSOR FOR 
SELECT id ,sharetype , sharevalue FROM cotype_sharemembers WHERE sharevalue LIKE '%,%'
OPEN membercursor
	FETCH next FROM membercursor INTO @id ,@sharetype, @value
	WHILE(@@FETCH_STATUS=0)
	BEGIN
	
		IF(@sharetype =1) BEGIN 
			INSERT into cotype_sharemembers(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype ,t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemembers t1,HrmResource t2
			WHERE  t1.id = @id AND ','+t1.sharevalue+',' LIKE '%,'+convert(VARCHAR(200) ,t2.id)+',%'
		END 
		
		IF(@sharetype =2) BEGIN 
			INSERT into cotype_sharemembers(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype ,t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemembers t1,HrmDepartment t2
			WHERE  t1.id = @id AND ','+t1.sharevalue+',' LIKE '%,'+convert(VARCHAR(200) ,t2.id)+',%'
		END 
		
		IF(@sharetype =3) BEGIN 
			INSERT into cotype_sharemembers(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype ,t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemembers t1,HrmSubCompany t2
			WHERE  t1.id = @id AND ','+t1.sharevalue+',' LIKE '%,'+convert(VARCHAR(200) ,t2.id)+',%'
		END 
		
		IF(@sharetype =4) BEGIN 
			INSERT into cotype_sharemembers(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype ,t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemembers t1,HrmRoles t2
			WHERE  t1.id = @id AND ','+t1.sharevalue+',' LIKE '%,'+convert(VARCHAR(200) ,t2.id)+',%'
		END 
	   	
	   	DELETE FROM cotype_sharemembers WHERE id = @id
	   	
	FETCH next FROM membercursor INTO @id , @sharetype , @value
	END
CLOSE membercursor
DEALLOCATE membercursor
GO

