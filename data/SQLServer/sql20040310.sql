alter PROCEDURE workflow_FieldLabel_Select @formid		int, @flag integer output , @msg varchar(80) output AS select t1.* from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null) and t1.formid=@formid and t1.isdefault='1' order by t2.fieldid
GO


IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Workflow_formdetailfield_Sel' 
	   AND 	  type = 'P')
    DROP PROCEDURE Workflow_formdetailfield_Sel
GO

/*查询表单明细对应某个特定节点的值*/
CREATE PROCEDURE Workflow_formdetailfield_Sel
	@formid int,
	@nodeid int,
	@flag integer output , 
        @msg varchar(80) output
AS
	SELECT  formfield.fieldid,formfield.fieldorder,
	        fieldlable.fieldlable,fieldlable.langurageid,	
	        nodeform.isview,nodeform.isedit,nodeform.ismandatory,
		dictdetail.fieldname,dictdetail.fielddbtype,dictdetail.fieldhtmltype,dictdetail.type       
		 FROM   Workflow_formfield formfield,
			Workflow_nodeform nodeform,
			Workflow_fieldlable fieldlable,
		        Workflow_formdictdetail dictdetail
	where formfield.formid = @formid and nodeform.nodeid = @nodeid and
	      formfield.fieldid = nodeform.fieldid and 
              formfield.fieldid = fieldlable.fieldid and 
              formfield.formid = fieldlable.formid and
              formfield.fieldid = dictdetail.id and
              formfield.isdetail = '1'  /*只查出明细 部分*/
	Order by formfield.fieldorder

	
GO

IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Workflow_formdetailinfo_Sel' 
	   AND 	  type = 'P')
    DROP PROCEDURE Workflow_formdetailinfo_Sel
GO

CREATE PROCEDURE Workflow_formdetailinfo_Sel
	@formid int,
	@flag integer output , 
        @msg varchar(80) output
AS
	SELECT * FROM Workflow_formdetailinfo where formid = @formid
GO