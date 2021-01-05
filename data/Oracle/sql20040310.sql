create or replace PROCEDURE workflow_FieldLabel_Select 
(formid_1 integer, 
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
select t1.* from workflow_fieldlable t1,workflow_formfield t2 
where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null) 
and t1.formid=formid_1 and t1.isdefault='1' order by t2.fieldid;
end;
/
/* =============================================*/
/* Create procedure basic template*/
/* =============================================*/
/* creating the store procedure*/

/*查询表单明细对应某个特定节点的值*/
create or replace PROCEDURE Workflow_formdetailfield_Sel
	(formid_1 integer,
	nodeid_1 integer,
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
              formfield.isdetail = '1'  /*只查出明细 部分*/
	Order by formfield.fieldorder;
end;	
/  

	
/* =============================================*/
/* Create procedure basic template*/
/* =============================================*/
/* creating the store procedure*/
create or replace PROCEDURE Workflow_formdetailinfo_Sel
(formid_1 integer,
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
	SELECT * FROM Workflow_formdetailinfo where formid = formid_1;
end;
/
