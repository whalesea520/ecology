CREATE PROCEDURE Workflow_MainField_Select
(
@userId INT, @requestId INT, @nodeId INT, @flag INTEGER OUTPUT, @msg VARCHAR(80) OUTPUT
)
AS

DECLARE
	@isBill char(1)  

SELECT @isBill = A.isBill 
FROM Workflow_Base A, Workflow_FlowNode B 
WHERE A.id = B.workflowId 
AND B.nodeId = @nodeId  

IF '1' = @isbill
	SELECT DISTINCT A.* , B.dspOrder
	FROM Workflow_NodeForm A, Workflow_BillField B
	WHERE A.fieldId = B.id
	AND nodeId = @nodeId
	ORDER BY B.dspOrder
ELSE 			
	SELECT workflowNodeForm.fieldId, max(workflowNodeForm.isView) isView, max(workflowNodeForm.isEdit) isEdit, max(workflowNodeForm.isMandatory) isMandatory
	FROM Workflow_NodeForm workflowNodeForm
	WHERE EXISTS
	(
		SELECT 1
		FROM Workflow_CurrentOperator workflowCurrentOperator
		WHERE workflowNodeForm.nodeId = workflowCurrentOperator.nodeId
		AND workflowCurrentOperator.requestId = @requestId
		AND workflowCurrentOperator.userId = @userId
	)
	GROUP BY workflowNodeForm.fieldId
	ORDER BY workflowNodeForm.fieldId
GO

CREATE PROCEDURE Workflow_DetailField_Select
(
@userId INT, @requestId INT, @formId INT, @groupId INT, @flag INTEGER OUTPUT, @msg VARCHAR(80) OUTPUT
)

AS

SELECT A.*, B.*
FROM
(
	SELECT workFlowFormField.fieldId, workFlowFormField.fieldOrder,
		   workFlowFieldLable.fieldLable, workFlowFieldLable.langurageId,	
		   workFlowFormDictDetail.fieldName, workFlowFormDictDetail.fieldDBType,
		   workFlowFormDictDetail.fieldHtmlType, workFlowFormDictDetail.type       
	FROM WorkFlow_FormField workflowFormField, WorkFlow_FieldLable workflowFieldLable, WorkFlow_FormDictDetail workflowFormDictDetail
	WHERE workflowFormField.formID = @formId
		AND workflowFormField.fieldId = workflowFieldLable.fieldId
		AND workflowFormField.formId = workflowFieldLable.formId
		AND workflowFormField.fieldId = workflowFormDictDetail.Id
		AND workflowFormField.isDetail = '1'
		AND workflowFormField.groupId = @groupId		
)
A,
(
	SELECT workflowNodeForm.fieldId, max(workflowNodeForm.isView) isView, max(workflowNodeForm.isEdit) isEdit, max(workflowNodeForm.isMandatory) isMandatory
	FROM WorkFlow_NodeForm workflowNodeForm
	WHERE EXISTS
	(
    	SELECT 1
		FROM Workflow_CurrentOperator workflowCurrentOperator
		WHERE workflowNodeForm.nodeId = workflowCurrentOperator.nodeId
		AND workflowCurrentOperator.requestId = @requestId
		AND workflowCurrentOperator.userId = @userId
  	)
	GROUP BY workflowNodeForm.fieldId
) B
WHERE A.fieldID = B.fieldId
ORDER BY A.fieldOrder
	
GO
