CREATE TABLE fnaRptRuleSet(
	id integer primary key,
	roleid integer NOT NULL,
	allowZb integer NOT NULL,
	name varchar2(4000) NULL
)
/

alter table fnaRptRuleSet add allowFb integer 
/
alter table fnaRptRuleSet add allowBm integer 
/
alter table fnaRptRuleSet add allowFcc integer 
/

CREATE INDEX idx_fnaRptRuleSet_1 ON fnaRptRuleSet (roleid) 
/
CREATE INDEX idx_fnaRptRuleSet_2 ON fnaRptRuleSet (allowZb) 
/
CREATE INDEX idx_fnaRptRuleSet_3 ON fnaRptRuleSet (allowFb) 
/
CREATE INDEX idx_fnaRptRuleSet_4 ON fnaRptRuleSet (allowBm) 
/
CREATE INDEX idx_fnaRptRuleSet_5 ON fnaRptRuleSet (allowFcc) 
/

create sequence seq_fnaRptRuleSet_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

CREATE TABLE fnaRptRuleSetDtl(
	id integer primary key,
	mainid integer NOT NULL,
	showid integer NOT NULL,
	showidtype integer NOT NULL
)
/

CREATE INDEX idx_fnaRptRuleSetDtl_1 ON fnaRptRuleSetDtl (mainid) 
/
CREATE INDEX idx_fnaRptRuleSetDtl_2 ON fnaRptRuleSetDtl (showid) 
/
CREATE INDEX idx_fnaRptRuleSetDtl_3 ON fnaRptRuleSetDtl (showidtype) 
/

create sequence seq_fnaRptRuleSetDtl_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/


alter table FnaSystemSet add enableRptCtrl integer 
/

update FnaSystemSet set enableRptCtrl = 0
/

create or replace trigger fnaRptRuleSet_trigger 
before insert 
on fnaRptRuleSet 
for each row 
begin 
	select seq_fnaRptRuleSet_id.nextval into :new.id from dual; 
end;
/

create or replace trigger fnaRptRuleSetDtl_trigger 
before insert 
on fnaRptRuleSetDtl 
for each row 
begin 
	select seq_fnaRptRuleSetDtl_id.nextval into :new.id from dual; 
end;
/