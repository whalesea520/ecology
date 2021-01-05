ALTER TABLE WorkflowReportShare ADD allowlook INTEGER
/
ALTER TABLE WorkflowReportShare ADD seclevel2 INTEGER
/
alter table rule_expressionbase add dbtype varchar2(50)
/
CREATE TABLE workflow_requestlogAtInfo (
	id              integer,
	REQUESTID       integer,
	WORKFLOWID      integer,
	nodeid          integer,
	LOGTYPE         CHAR (1),
	OPERATEDATE     VARCHAR2 (10),
	OPERATETIME     VARCHAR2(8),
	OPERATOR        integer,
	atuserid        integer,
	forwardresource VARCHAR2(4000)
)
/
create sequence workflow_requestlogAtInfo_seq
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_reqlogAtInfo_tri
before insert on workflow_requestlogAtInfo
for each row
begin
select workflow_requestlogAtInfo.nextval into :new.id from dual;
end;
/

CREATE or replace PROCEDURE WorkflowReportShare_Insert
(
	reportid_1 			INTEGER, 
	sharetype_1			INTEGER,
	seclevel_1 			INTEGER,
  	seclevel_2 			INTEGER,
	rolelevel_1			SMALLINT,
	sharelevel_1 		SMALLINT,
	userid_1 			VARCHAR2, 
	subcompanyid_1		VARCHAR2,
	departmentid_1		VARCHAR2, 
	roleid_1 			VARCHAR2, 
	foralluser_1 		SMALLINT,
	crmid_1				INTEGER,
	mutidepartmentid_1 	VARCHAR2,
	allowlook_1 		INTEGER,
	flag 				OUT INTEGER, 
	msg 				out	VARCHAR2,
	thecursor IN OUT cursor_define.weavercursor
)
AS BEGIN INSERT INTO WorkflowReportShare
(
	reportid,
	sharetype,
	seclevel,
  	seclevel2,
	rolelevel,
	sharelevel,
	userid,
	subcompanyid,
	departmentid,
	roleid,
	foralluser,
	crmid,
	mutidepartmentid,
	allowlook
) 
VALUES
(
	reportid_1,
	sharetype_1,
	seclevel_1,
  	seclevel_2 
	rolelevel_1,
	sharelevel_1,
	userid_1,
	subcompanyid_1,
	departmentid_1,
	roleid_1,
	foralluser_1,
	crmid_1,
	mutidepartmentid_1,
	allowlook_1
);
END;
/

alter table workflow_base add isfree char(1) default '0'
/
update workflow_base set isfree = '0'
/

CREATE OR REPLACE PROCEDURE Workflow_ReportDspField_INSERT 
(
	reportid_1 			INTEGER, 
	fieldid_2 			INTEGER, 
	dsporder_3 			VARCHAR2, 
	isstat_4 			CHAR, 
	dborder_5  			CHAR, 
	dbordertype_6  		CHAR, 
	compositororder  	INTEGER,
	reportcondition_9 	INTEGER,
	fieldwidth_10 		NUMBER,
	valueone_11 		VARCHAR2,
	valuetwo_12 		VARCHAR2,
	valuethree_13 		VARCHAR2,
	valuefour_14 		VARCHAR2,
	httype_15 			VARCHAR2,
	htdetailtype_16 	VARCHAR2,
	flag 				OUT INTEGER, 
	msg 				OUT VARCHAR2, 
	thecursor IN OUT cursor_define.weavercursor
 )  
 AS BEGIN INSERT INTO Workflow_ReportDspField 
 ( 
	reportid, 
	fieldid, 
	dsporder, 
	isstat, 
	dborder,
	dbordertype,
	compositororder,
	reportcondition,
	fieldwidth,
	valueone,
	valuetwo,
	valuethree,
	valuefour,
	httype,
	htdetailtype
 )  
 VALUES 
 ( 
    reportid_1, 
  	fieldid_2, 
  	dsporder_3, 
  	isstat_4, 
  	dborder_5,
  	dbordertype_6, 
  	compositororder,
  	reportcondition_9,
  	fieldwidth_10,
  	valueone_11,
  	valuetwo_12,
  	valuethree_13,
  	valuefour_14,
  	httype_15,
  	htdetailtype_16
 ); 
 END;
/

Create OR REPLACE PROCEDURE Workflow_RepDspFld_Insert_New 
 (
	 reportid_1  		INTEGER, 
	 dsporder_3  		VARCHAR2, 
	 isstat_4    		CHAR, 
	 dborder_5    		CHAR, 
	 dbordertype_6     	CHAR, 
	 compositororder_7  INTEGER, 
	 fieldidbak_8 		INTEGER,
	 reportcondition_9 	INTEGER,
	 fieldwidth_10 		NUMBER,
	 valueone_11 		VARCHAR2,
	 valuetwo_12 		VARCHAR2,
	 valuethree_13 		VARCHAR2,
	 valuefour_14 		VARCHAR2,
	 httype_15 			VARCHAR2,
	 htdetailtype_16 	VARCHAR2,
	 flag  				OUT INTEGER, 
	 msg   				OUT VARCHAR2,
	 thecursor IN OUT cursor_define.weavercursor 
 )  
 AS BEGIN INSERT INTO Workflow_ReportDspField 
 ( 
	reportid, 
	dsporder, 
	isstat, 
	dborder,
	dbordertype,
	compositororder,
	fieldidbak,
	reportcondition,
	fieldwidth,
	valueone,
	valuetwo,
	valuethree,
	valuefour,
	httype,
	htdetailtype
 ) 
  VALUES 
 ( 
	reportid_1, 
	dsporder_3, 
	isstat_4, 
	dborder_5, 
	dbordertype_6,
	compositororder_7, 
	fieldidbak_8,
	reportcondition_9
	fieldwidth_10,
	valueone_11,
	valuetwo_12,
	valuethree_13,
	valuefour_14,
	httype_15,
	htdetailtype_16
 ); 
END;
/





CREATE TABLE workflow_requestdeletelog (
	request_id int not null,
	request_name varchar2(440),
	operate_userid int not null,
	operate_date char(10) not null,
	operate_time char(8) not null,
	workflow_id int not null,
	client_address char(15)
)
/

alter table workflow_rquestBrowseFunction add jsqjtype_readonly char(1)
/
alter table workflow_rquestBrowseFunction add gdtype_readonly char(1)
/
alter table workflow_rquestBrowseFunction add xgkhid_readonly char(1)
/
alter table workflow_rquestBrowseFunction add xgxmid_readonly char(1)
/
alter table workflow_rquestBrowseFunction add createdate_readonly char(1)
/
alter table workflow_rquestBrowseFunction add createsubid_readonly char(1)
/
alter table workflow_rquestBrowseFunction add createdeptid_readonly char(1)
/
alter table workflow_rquestBrowseFunction add createtypeid_readonly char(1)
/
alter table workflow_rquestBrowseFunction add Processnumber_readonly char(1)
/
alter table workflow_rquestBrowseFunction add workflowtype_readonly char(1)
/
alter table workflow_rquestBrowseFunction add requestname_readonly char(1)
/
CREATE TABLE workflow_codeRegulate
	(
	id       INTEGER   NOT NULL,
	formid     INTEGER   NOT NULL,
	showId     INTEGER   NOT NULL,
	showType CHAR (1),
	codeValue  VARCHAR2 (100),
	codeOrder  INTEGER,    
	isBill     CHAR (1),
	workflowId INTEGER,
	constraint workflow_codeRegulate_pk primary key (id) 
	)
/
    create sequence workflow_codeRegulate_seq minvalue 1 maxvalue 99999999
    increment by 1
    start with 1
/
create or replace trigger workflow_codeRegulate_tri
 before insert on workflow_codeRegulate
 for each row      
 begin      
     select workflow_codeRegulate_seq.nextval into :new.id from dual;
 END
/

CREATE TABLE workflow_freeright(
	nodeid integer NOT NULL,
	isroutedit integer NOT NULL,
	istableedit integer NOT NULL
) 
/
UPDATE workflow_browserurl SET labelid=33569 WHERE id=16
/
UPDATE workflow_browserurl SET labelid=33924 WHERE id=152
/
UPDATE workflow_browserurl SET labelid=33925 WHERE id=171
/
create table rule_variablebase(
	id int  NOT NULL,
	name varchar2(500) NULL,
	ruleid int NULL,
	fieldtype int NULL,
	htmltype int NULL
)
/
create table rule_maplist
(
	id int NOT NULL,
	wfid int NULL,
	linkid int NULL,
	ruleid int NULL,
	isused int NULL,
	rulesrc int NULL,
	nm int NULL
)
/
create sequence rule_maplist_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger rule_maplist_id_trigger
before insert on rule_maplist
for each row 
begin
select rule_maplist_id.nextval into :new.id from dual;
end;
/
create table rule_mapitem
(
	id int NOT NULL,
	ruleid int NULL,
	rulesrc int NULL,
	linkid int NULL,
	rulevarid int NULL,
	formfieldid int NULL
)
/
create sequence rule_mapitem_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger rule_mapitem_id_trigger
before insert on rule_mapitem
for each row 
begin
select rule_mapitem_id.nextval into :new.id from dual;
end;
/

ALTER TABLE workflow_flownode ADD signfieldids VARCHAR2(255)
/
alter table rule_maplist add rowidenty int
/
alter table rule_mapitem add rowidenty int
/
CREATE TABLE workflow_groupdetail_matrix (
	groupdetailid INT NOT NULL,
	matrix INT NOT NULL,
	value_field INT NOT NULL
)
/
CREATE TABLE workflow_matrixdetail (
	groupdetailid INT NOT NULL,
	condition_field INT NOT NULL,
	workflow_field INT NOT NULL
)
/

ALTER TABLE workflow_createplan ADD changemode INTEGER
/

alter table rule_variablebase modify fieldtype varchar2(10)
/
CREATE OR REPLACE PROCEDURE Wf_Right_checkpermission(		   
dirid_1         INTEGER,
dirtype_1       INTEGER,
userid_1        INTEGER,
usertype_1      INTEGER,
seclevel_1      INTEGER,
operationcode_1 INTEGER,
departmentid_1  INTEGER,
subcompanyid_1  INTEGER,
roleid_1        VARCHAR2,
flag            OUT INTEGER,
msg             OUT VARCHAR2,
thecursor IN OUT cursor_define.weavercursor
)
AS
  count_1 INTEGER;
  result INTEGER:=0;
BEGIN
	SELECT COUNT(mainid) INTO count_1
	FROM   wfAccessControlList
	WHERE  dirid = dirid_1
		   AND dirtype = dirtype_1
		   AND operationcode = operationcode_1
		   AND ((permissiontype = 1 AND departmentid = departmentid_1 AND seclevel <= seclevel_1)
			  OR(permissiontype = 2 AND roleid IN (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) AND seclevel <= seclevel_1)
			  OR(permissiontype = 3 AND seclevel <= seclevel_1)
			  OR(permissiontype = 4 AND usertype = usertype_1 AND seclevel <= seclevel_1)
			  OR(permissiontype = 5 AND userid = userid_1)
			  OR(permissiontype = 6 AND subcompanyid = subcompanyid_1 AND seclevel <= seclevel_1));
	IF count_1 > 0 THEN
		result:=1;
	END IF;
OPEN thecursor FOR
SELECT result result FROM dual;
END;
/
CREATE OR REPLACE PROCEDURE Wf_Right_checkpermission2(		   
dirtype_1       INTEGER,
userid_1        INTEGER,
usertype_1      INTEGER,
seclevel_1      INTEGER,
operationcode_1 INTEGER,
departmentid_1  INTEGER,
subcompanyid_1  INTEGER,
roleid_1        VARCHAR2,
flag            OUT INTEGER,
msg             OUT VARCHAR2,
thecursor IN OUT cursor_define.weavercursor
)
AS
  count_1 INTEGER;
  result INTEGER:=0;
BEGIN
	SELECT COUNT(mainid) INTO count_1
	FROM   wfAccessControlList
	WHERE  dirtype = dirtype_1
		   AND operationcode = operationcode_1
		   AND ((permissiontype = 1 AND departmentid = departmentid_1 AND seclevel <= seclevel_1)
				  OR(permissiontype = 2 AND roleid IN (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) AND seclevel <= seclevel_1)
				  OR(permissiontype = 3 AND seclevel <= seclevel_1)
				  OR(permissiontype = 4 AND usertype = usertype_1 AND seclevel <= seclevel_1)
				  OR(permissiontype = 5 AND userid = userid_1)
				  OR(permissiontype = 6 AND subcompanyid = subcompanyid_1 AND seclevel <= seclevel_1));
	IF count_1 > 0 THEN
		result:=1;
	END IF;
OPEN thecursor FOR
SELECT result result FROM dual;
END;
/
CREATE OR REPLACE PROCEDURE Wf_Right_delete(
mainid_1 INTEGER,
flag OUT INTEGER,
msg OUT VARCHAR2
)
AS
begin
DELETE FROM wfAccessControlList WHERE mainid = mainid_1;
end;
/
CREATE OR REPLACE PROCEDURE Wf_Right_insert_type1(
dirid_1         INTEGER,
dirtype_1       INTEGER,
operationcode_1 INTEGER,
departmentid_1  INTEGER,
seclevel_1      INTEGER,
flag            OUT INTEGER,
msg             OUT VARCHAR2
)
AS
begin
INSERT INTO wfAccessControlList
              (dirid,
               dirtype,
               departmentid,
               seclevel,
               operationcode,
               permissiontype)
  VALUES     (dirid_1,
              dirtype_1,
              departmentid_1,
              seclevel_1,
              operationcode_1,
              1);
end;
/
CREATE OR REPLACE PROCEDURE Wf_Right_insert_type2(
dirid_1         INTEGER,
dirtype_1       INTEGER,
operationcode_1 INTEGER,
roleid_1        INTEGER,
rolelevel_1     INTEGER,
seclevel_1      INTEGER,
flag            OUT INTEGER,
msg             OUT VARCHAR2
)
AS
begin
INSERT INTO wfAccessControlList
              (dirid,
               dirtype,
               roleid,
               rolelevel,
               seclevel,
               operationcode,
               permissiontype)
  VALUES     (dirid_1,
              dirtype_1,
              roleid_1,
              rolelevel_1,
              seclevel_1,
              operationcode_1,
              2);
end;
/
CREATE OR REPLACE PROCEDURE Wf_Right_insert_type3(
dirid_1         INTEGER,
dirtype_1       INTEGER,
operationcode_1 INTEGER,
seclevel_1      INTEGER,
flag            OUT INTEGER,
msg             OUT VARCHAR2
)
AS
begin
INSERT INTO wfAccessControlList
              (dirid,
               dirtype,
               seclevel,
               operationcode,
               permissiontype)
  VALUES     (dirid_1,
              dirtype_1,
              seclevel_1,
              operationcode_1,
              3);
end;
/
CREATE OR REPLACE PROCEDURE Wf_Right_insert_type4(
dirid_1         INTEGER,
dirtype_1       INTEGER,
operationcode_1 INTEGER,
usertype_1      INTEGER,
seclevel_1      INTEGER,
flag            OUT INTEGER,
msg             OUT VARCHAR2
)
AS
begin
INSERT INTO wfAccessControlList
              (dirid,
               dirtype,
               usertype,
               seclevel,
               operationcode,
               permissiontype)
  VALUES     (dirid_1,
              dirtype_1,
              usertype_1,
              seclevel_1,
              operationcode_1,
              4);
end;
/
CREATE OR REPLACE PROCEDURE Wf_Right_insert_type5(
dirid_1         INTEGER,
dirtype_1       INTEGER,
operationcode_1 INTEGER,
userid_1        INTEGER,
flag            OUT INTEGER,
msg             OUT VARCHAR2
)
AS
begin
INSERT INTO wfAccessControlList
              (dirid,
               dirtype,
               userid,
               operationcode,
               permissiontype)
  VALUES     (dirid_1,
              dirtype_1,
              userid_1,
              operationcode_1,
              5);
end;
/
CREATE OR REPLACE PROCEDURE Wf_Right_insert_type6(
dirid_1         INTEGER,
dirtype_1       INTEGER,
operationcode_1 INTEGER,
subcompanyid_1  INTEGER,
seclevel_1      INTEGER,
flag            OUT INTEGER,
msg             OUT VARCHAR2
)
AS
begin
INSERT INTO wfAccessControlList
              (dirid,
               dirtype,
               subcompanyid,
               seclevel,
               operationcode,
               permissiontype)
  VALUES     (dirid_1,
              dirtype_1,
              subcompanyid_1,
              seclevel_1,
              operationcode_1,
              6);
end;
/

alter table workflow_nodelink add newrule varchar(200)
/