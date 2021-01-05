ALTER TABLE CRM_T_ShareInfo ADD seclevelMax SMALLINT DEFAULT 100
/

ALTER TABLE CRM_ShareInfo ADD seclevelMax SMALLINT DEFAULT 100
/

ALTER TABLE Contract_ShareInfo ADD seclevelMax SMALLINT DEFAULT 100
/

ALTER TABLE Contract_ShareInfo ADD isdefault CHAR(1) 
/

ALTER TABLE Contract_ShareInfo ADD subcompanyid INT 
/

ALTER TABLE coworkshare ADD seclevelMax SMALLINT DEFAULT 100
/

ALTER TABLE cotype_sharemanager ADD seclevelMax SMALLINT DEFAULT 100
/

ALTER TABLE cotype_sharemembers ADD seclevelMax SMALLINT DEFAULT 100
/ 

ALTER TABLE blog_share ADD seclevelMax SMALLINT DEFAULT 100
/

ALTER TABLE blog_tempShare ADD seclevelMax SMALLINT DEFAULT 100
/

ALTER TABLE blog_specifiedShare ADD seclevelMax SMALLINT DEFAULT 100
/

UPDATE CRM_T_ShareInfo SET seclevelMax = 100
/

UPDATE CRM_ShareInfo SET seclevelMax = 100
/

UPDATE Contract_ShareInfo SET seclevelMax = 100 , subcompanyid = 0
/

UPDATE coworkshare SET seclevelMax = 100
/

UPDATE cotype_sharemanager SET seclevelMax = 100
/

UPDATE cotype_sharemembers SET seclevelMax = 100
/

UPDATE blog_share SET seclevelMax = 100
/

UPDATE blog_tempShare SET seclevelMax = 100
/

UPDATE blog_specifiedShare SET seclevel = 0 , seclevelMax = 100
/


CREATE
OR REPLACE PROCEDURE CRM_T_SHAREINFO_INSERT (
	relateditemid_1 INTEGER,
	sharetype_1 SMALLINT,
	seclevel_1 SMALLINT,
	seclevelMax_1 SMALLINT,
	rolelevel_1 SMALLINT,
	sharelevel_1 SMALLINT,
	userid_1 INTEGER,
	departmentid_1 INTEGER,
	roleid_1 INTEGER,
	foralluser_1 SMALLINT,
	subcompanyid_1 INTEGER,
	flag out INTEGER,
	msg out VARCHAR2,
	thecursor IN OUT cursor_define.weavercursor
) AS
BEGIN
	INSERT INTO CRM_T_ShareInfo (
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
		relateditemid_1,
		sharetype_1,
		seclevel_1,
		seclevelMax_1,
		rolelevel_1,
		sharelevel_1,
		userid_1,
		departmentid_1,
		roleid_1,
		foralluser_1,
		subcompanyid_1
	) ;
END ;
/

CREATE
OR REPLACE PROCEDURE CRM_SHAREINFO_INSERT (
	relateditemid_1 INTEGER,
	sharetype_1 SMALLINT,
	seclevel_1 SMALLINT,
	seclevelMax_1 SMALLINT,
	rolelevel_1 SMALLINT,
	sharelevel_1 SMALLINT,
	userid_1 INTEGER,
	departmentid_1 INTEGER,
	roleid_1 INTEGER,
	foralluser_1 SMALLINT,
	contents_1 SMALLINT,
	flag out INTEGER,
	msg out VARCHAR2,
	thecursor IN OUT cursor_define.weavercursor
) AS
BEGIN
	INSERT INTO CRM_ShareInfo (
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
		CONTENTS
	)
VALUES
	(
		relateditemid_1,
		sharetype_1,
		seclevel_1,
		seclevelMax_1,
		rolelevel_1,
		sharelevel_1,
		userid_1,
		departmentid_1,
		roleid_1,
		foralluser_1,
		contents_1
	) ;
END ;
/

CREATE
OR REPLACE PROCEDURE CONTRACT_SHAREINFO_INS(
	relateditemid_1 INTEGER,
	sharetype_1 SMALLINT,
	seclevel_1 SMALLINT,
	seclevelMax_1 SMALLINT,
	rolelevel_1 SMALLINT,
	sharelevel_1 SMALLINT,
	userid_1 INTEGER,
	departmentid_1 INTEGER,
	subcompanyid_1 INTEGER,
	roleid_1 INTEGER,
	foralluser_1 SMALLINT,
	flag out INTEGER,
	msg out VARCHAR2,
	thecursor IN OUT cursor_define.weavercursor
) AS
BEGIN
	INSERT INTO Contract_ShareInfo (
		relateditemid,
		sharetype,
		seclevel,
		seclevelMax,
		rolelevel,
		sharelevel,
		userid,
		departmentid,
		subcompanyid,
		roleid,
		foralluser
	)
VALUES
	(
		relateditemid_1,
		sharetype_1,
		seclevel_1,
		seclevelMax_1,
		rolelevel_1,
		sharelevel_1,
		userid_1,
		departmentid_1,
		subcompanyid_1,
		roleid_1,
		foralluser_1
	) ; flag := 1 ; msg := 'ok' ;
END ;
/

DECLARE contract_id INT ;manager INT ;crm_manager INT ;
cursor contract_cursor is SELECT id ,  manager ,(SELECT manager FROM CRM_CustomerInfo WHERE id = crmid) AS crm_manager FROM CRM_Contract;
BEGIN
OPEN contract_cursor;
loop
FETCH  contract_cursor INTO contract_id ,manager,crm_manager;
exit when contract_cursor%notfound;

insert into Contract_ShareInfo (relateditemid,sharetype,seclevel,seclevelMax,rolelevel, sharelevel,userid,departmentid,subcompanyid,roleid,foralluser,isdefault)
 values (contract_id,1,0,0,0,2,manager,0,0,0,0,1);


insert into Contract_ShareInfo (relateditemid,sharetype,seclevel,seclevelMax,rolelevel, sharelevel,userid,departmentid,subcompanyid,roleid,foralluser,isdefault)
SELECT  contract_id,1,0,0,0,3,id,0,0,0,0,1 FROM HrmResource WHERE 
	(SELECT managerstr FROM HrmResource WHERE id = manager) LIKE '%,'||TO_CHAR(id)||',%';

IF crm_manager <> manager THEN 
	insert into Contract_ShareInfo (relateditemid,sharetype,seclevel,seclevelMax,rolelevel, sharelevel,userid,departmentid,subcompanyid,roleid,foralluser,isdefault)
	 values (contract_id,1,0,0,0,1,crm_manager,0,0,0,0,1);
	 
	insert into Contract_ShareInfo (relateditemid,sharetype,seclevel,seclevelMax,rolelevel, sharelevel,userid,departmentid,subcompanyid,roleid,foralluser,isdefault)
	SELECT  contract_id,1,0,0,0,1,id,0,0,0,0,1 FROM HrmResource WHERE 
		(SELECT managerstr FROM HrmResource WHERE id = crm_manager) LIKE '%,'||TO_CHAR(id)||',%';
END IF ;

END LOOP ;
CLOSE contract_cursor;
END ;
/


