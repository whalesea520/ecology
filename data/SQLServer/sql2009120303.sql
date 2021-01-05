alter table workflow_formdict add childfieldid int
GO
alter table workflow_formdictdetail add childfieldid int
GO
alter table workflow_billfield add childfieldid int
GO
alter table workflow_SelectItem add childitemid varchar(2000)
GO

alter PROCEDURE Workflow_formdetailfield_Sel
	@formid int,
	@nodeid int,
	@groupid int,
	@flag integer output , 
        @msg varchar(80) output
AS
	SELECT  formfield.fieldid,formfield.fieldorder,
	        fieldlable.fieldlable,fieldlable.langurageid,	
	        nodeform.isview,nodeform.isedit,nodeform.ismandatory,
		dictdetail.fieldname,dictdetail.fielddbtype,dictdetail.fieldhtmltype,dictdetail.type,dictdetail.childfieldid       
		 FROM   Workflow_formfield formfield,
			Workflow_nodeform nodeform,
			Workflow_fieldlable fieldlable,
		        Workflow_formdictdetail dictdetail
	where formfield.formid = @formid and nodeform.nodeid = @nodeid and
	      formfield.fieldid = nodeform.fieldid and 
              formfield.fieldid = fieldlable.fieldid and 
              formfield.formid = fieldlable.formid and
              formfield.fieldid = dictdetail.id and
              formfield.isdetail = '1' and 
	       formfield.groupId = @groupid   	      /*只查出明细 部分*/
	Order by formfield.fieldorder


GO
