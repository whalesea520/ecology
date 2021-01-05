INSERT INTO HtmlLabelIndex values(18903,'多明细') 
GO
INSERT INTO HtmlLabelInfo VALUES(18903,'多明细',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18903,'multidetail',8) 
GO
INSERT INTO HtmlLabelIndex values(18909,'字段不属于同一明细！') 
GO
INSERT INTO HtmlLabelInfo VALUES(18909,'字段不属于同一明细！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18909,'field is not belong to the same detail',8) 
GO

alter table workflow_formdetail add groupId int null
Go

alter table workflow_formfield add groupId int null
Go
update workflow_formdetail set groupId=0
Go
update workflow_formfield  set groupId=0
Go

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
              formfield.isdetail = '1' and 
	       formfield.groupId = @groupid   	      
	Order by formfield.fieldorder

	

GO

