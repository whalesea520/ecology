CREATE TABLE Workflow_DistributionSummary
(
	id              INTEGER,
	mainwfid        INTEGER,
	mainformid		INTEGER,
	mainfieldid		INTEGER,
	mainfieldname		varchar2(1000),
	maindetailnum		INTEGER,
	nodeid			INTEGER,
	subwfid			INTEGER,
	subformid		INTEGER,
	subfieldid		INTEGER,
	subfieldname		varchar2(1000),
	fieldhtmltype		char(1),
	type			INTEGER,
	subtype			INTEGER,
	iscreatedoc		char(1)
)
/
    create sequence Workflow_DbtSummary_seq minvalue 1 maxvalue 99999999
    increment by 1
    start with 1
/
create or replace trigger Workflow_DbtSummary_tri
 before insert on Workflow_DistributionSummary
 for each row      
 begin      
     select Workflow_DbtSummary_seq.nextval into :new.id from DUAL;
 END;
/