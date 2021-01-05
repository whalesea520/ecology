alter table BudgetAuditMapping add fccId integer
/

create table FnaRuleSetDtlFcc(
  id integer NOT NULL PRIMARY KEY,
  mainid integer not null,
  showid integer not null,
	showidtype integer not null
)
/

create sequence seq_FnaRuleSetDtlFcc_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create table FnaCostCenter(
  id integer not null PRIMARY KEY,
  supFccId integer,
  type integer,
  name char(100),
  code char(50),
  Archive integer,
  description varchar2(4000)
)
/

create index idx_FnaCostCenter_1 on FnaCostCenter (name)
/

create index idx_FnaCostCenter_2 on FnaCostCenter (code)
/

create sequence seq_FnaCostCenter_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create table FnaCostCenterDtl(
  id integer not null PRIMARY KEY,
  fccId integer,
  type integer,
  objId integer
)
/

create index idx_FnaCostCenterDtl_1 on FnaCostCenterDtl (fccId)
/

create index idx_FnaCostCenterDtl_2 on FnaCostCenterDtl (type,fccId)
/

create sequence seq_FnaCostCenterDtl_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

ALTER TABLE FnaSystemSet ADD fnaBudgetOAOrg integer
/

ALTER TABLE FnaSystemSet ADD fnaBudgetCostCenter integer
/

update FnaSystemSet set fnaBudgetOAOrg=1
/

update FnaSystemSet set fnaBudgetCostCenter=0
/

CREATE OR REPLACE FUNCTION getFccArchive1(pId IN INTEGER) RETURN INTEGER is 
    pCnt INTEGER;
BEGIN

		select count(*) into pCnt from FnaCostCenter
		where archive = 1
		start with id=pId
		connect by prior supFccId = id;

    RETURN pCnt;
END;
/

create or replace trigger FnaCostCenterDtl_trigger 
before insert 
on FnaCostCenterDtl 
for each row 
begin 
	select seq_FnaCostCenterDtl_id.nextval into :new.id from dual; 
end;
/

create or replace trigger FnaCostCenter_trigger 
before insert 
on FnaCostCenter 
for each row 
begin 
	select seq_FnaCostCenter_id.nextval into :new.id from dual; 
end;
/



INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) 
VALUES (158,'fccremain',515,'varchar2(4000)',1,1,246,1,'Bill_FnaWipeApplyDetail')
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) 
VALUES (156,'fccremain',515,'varchar2(4000)',1,1,61,1,'Bill_FnaPayApplyDetail')
/


INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) 
VALUES ( 251,515,'int','/systeminfo/BrowserMain.jsp?url=/fna/browser/costCenter/single/FccBrowser.jsp','FnaCostCenter','name','id','')
/


INSERT INTO workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault, isaccordtosubcom) 
VALUES (717, 1, 18004, '成本中心', 3.00, 'n', 0)
/



INSERT INTO workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault, isaccordtosubcom) 
VALUES (715, 1, 18004, '成本中心', 3.00, 'n', 0)
/



INSERT INTO workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault, isaccordtosubcom) 
VALUES (716, 1, 18004, '成本中心', 3.00, 'n', 0)
/



ALTER TABLE Bill_FnaWipeApplyDetail ADD fccremain varchar2(4000)
/



ALTER TABLE Bill_FnaPayApplyDetail ADD fccremain varchar2(4000)
/

create or replace trigger FnaRuleSetDtlFcc_trigger 
before insert 
on FnaCostCenter 
for each row 
begin 
	select seq_FnaRuleSetDtlFcc_id.nextval into :new.id from dual; 
end;
/

