
CREATE TABLE workflow_nodeform_tmp (
	nodeid 		int 	NULL ,
	fieldid 	int 	NULL ,
	isview 		char (1)  NULL ,
	isedit 		char (1)  NULL ,
	ismandatory 	char (1)  NULL ,
	id			int NOT NULL
) 
/
create sequence T_wf_nodeform_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger T_wf_nodeform_Trigger
before insert on workflow_nodeform_tmp
for each row
begin
select T_wf_nodeform_id.nextval into :new.id from dual;
end;
/

INSERT INTO workflow_nodeform_tmp(nodeid,fieldid,isview,isedit,ismandatory)
SELECT nodeid,fieldid,isview,isedit,ismandatory
FROM workflow_nodeform ORDER BY nodeid,fieldid
/


declare cursor c1 is select nodeid,fieldid,min(id) as minid from workflow_nodeform_tmp group by nodeid,fieldid having count(fieldid)>1;
nodeid_1  integer;
fieldid_1 integer; 
minid_1   integer;
begin
	open c1;  
	fetch c1 into nodeid_1, fieldid_1, minid_1;
    while c1%found
    loop 
		 delete from workflow_nodeform_tmp where nodeid=nodeid_1 and fieldid=fieldid_1 and id>minid_1;
		 fetch c1 into nodeid_1, fieldid_1, minid_1;
	end loop;
	close c1; 
end;
/



delete from workflow_nodeform
/


INSERT INTO workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory)
SELECT nodeid,fieldid,isview,isedit,ismandatory
FROM workflow_nodeform_tmp ORDER BY nodeid,fieldid
/


drop table workflow_nodeform_tmp
/
drop sequence T_wf_nodeform_id
/



declare cursor c2 is select id from workflow_formbase; 
formid_2  integer;
begin
	open c2; 
	fetch c2 into formid_2;
	while c2%found
	loop 
		delete from workflow_nodeform 
		where nodeid in(select b.nodeid from workflow_base a,workflow_flownode b where a.id=b.workflowid and a.isbill=0 and a.formid=formid_2) 
		and fieldid not in(select fieldid from workflow_formfield where formid=formid_2);
		fetch c2 into formid_2;
	end loop;
	close c2; 
end;
/
