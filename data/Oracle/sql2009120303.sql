alter table workflow_formdict add childfieldid integer
/
alter table workflow_formdictdetail add childfieldid integer
/
alter table workflow_billfield add childfieldid integer
/
alter table workflow_SelectItem add childitemid varchar(2000)
/

create or replace PROCEDURE Workflow_formdetailfield_Sel
	(formid_1 integer,
	nodeid_1 integer,
	groupid_1 int,
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
	SELECT  formfield.fieldid,formfield.fieldorder,
	        fieldlable.fieldlable,fieldlable.langurageid,	
	        nodeform.isview,nodeform.isedit,nodeform.ismandatory,
		dictdetail.fieldname,dictdetail.fielddbtype,dictdetail.fieldhtmltype,dictdetail.type,dictdetail.childfieldid       
		 FROM   Workflow_formfield formfield,
			Workflow_nodeform nodeform,
			Workflow_fieldlable fieldlable,
		        Workflow_formdictdetail dictdetail
	where formfield.formid = formid_1 and nodeform.nodeid = nodeid_1 and
	      formfield.fieldid = nodeform.fieldid and 
              formfield.fieldid = fieldlable.fieldid and 
              formfield.formid = fieldlable.formid and
              formfield.fieldid = dictdetail.id and
              formfield.isdetail = '1' and 
	       formfield.groupId = groupid_1 
	Order by formfield.fieldorder;
end;	
/
