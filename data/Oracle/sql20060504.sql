INSERT INTO HtmlLabelIndex values(18903,'多明细') 
/
INSERT INTO HtmlLabelInfo VALUES(18903,'多明细',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18903,'multidetail',8) 
/
INSERT INTO HtmlLabelIndex values(18909,'字段不属于同一明细！') 
/
INSERT INTO HtmlLabelInfo VALUES(18909,'字段不属于同一明细！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18909,'field is not belong to the same detail',8) 
/

alter table workflow_formdetail add groupId integer null
/
alter table workflow_formfield add groupId integer null
/
update workflow_formdetail set groupId=0
/
update workflow_formfield  set groupId=0
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
		dictdetail.fieldname,dictdetail.fielddbtype,dictdetail.fieldhtmltype,dictdetail.type       
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
