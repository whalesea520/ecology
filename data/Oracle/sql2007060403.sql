CREATE OR REPLACE PROCEDURE Workflow_MainField_Select (
   userIdPara           INTEGER,
   requestIdPara        INTEGER,
   nodeIdPara           INTEGER,
   flag        OUT      INTEGER,
   msg         OUT      VARCHAR2,
   thecursor   IN OUT   cursor_define.weavercursor
)
AS
   isBill   CHAR (1);
BEGIN
   SELECT A.isBill
     INTO isBill
     FROM Workflow_Base A, Workflow_FlowNode B
    WHERE A.id = B.workflowId AND B.nodeId = nodeIdPara;

   IF isBill = '1'
   THEN
      OPEN thecursor FOR
         SELECT DISTINCT A.*, B.dspOrder
                    FROM Workflow_NodeForm A, Workflow_BillField B
                   WHERE A.fieldId = B.id AND nodeId = nodeIdPara
                ORDER BY B.dspOrder;
   ELSE
      OPEN thecursor FOR
         SELECT   workflowNodeForm.fieldId,
                  MAX (workflowNodeForm.isView) isView,
                  MAX (workflowNodeForm.isEdit) isEdit,
                  MAX (workflowNodeForm.isMandatory) isMandatory
             FROM Workflow_NodeForm workflowNodeForm
            WHERE EXISTS (
                     SELECT 1
                       FROM Workflow_CurrentOperator workflowCurrentOperator
                      WHERE workflowNodeForm.nodeId =
                                               workflowCurrentOperator.nodeId
                        AND workflowCurrentOperator.requestId = requestIdPara
                        AND workflowCurrentOperator.userId = userIdPara)
         GROUP BY workflowNodeForm.fieldId
         ORDER BY workflowNodeForm.fieldId;
   END IF;
END;
/


CREATE OR REPLACE PROCEDURE Workflow_DetailField_Select (
   userIdPara            INTEGER,
   requestIdPara         INTEGER,
   formIdPara            INTEGER,
   groupIdPara           INTEGER,
   flag         OUT      INTEGER,
   msg          OUT      VARCHAR2,
   thecursor    IN OUT   cursor_define.weavercursor
)
AS
BEGIN
   OPEN thecursor FOR
      SELECT   A.*, B.*
          FROM (SELECT workFlowFormField.fieldId, workFlowFormField.fieldOrder, workFlowFieldLable.fieldLable,
                       workFlowFieldLable.langurageId, workFlowFormDictDetail.fieldName,
                       workFlowFormDictDetail.fieldDBType, workFlowFormDictDetail.fieldHtmlType,
                       workFlowFormDictDetail.TYPE
                  FROM WorkFlow_FormField workflowFormField,
                       WorkFlow_FieldLable workflowFieldLable,
                       WorkFlow_FormDictDetail workflowFormDictDetail
                 WHERE workflowFormField.formId = formIdPara
                   AND workflowFormField.fieldId = workflowFieldLable.fieldId
                   AND workflowFormField.formId = workflowFieldLable.formId
                   AND workflowFormField.fieldId = workflowFormDictDetail.ID
                   AND workflowFormField.isDetail = '1'
                   AND workflowFormField.groupId = groupIdPara) A,
               (SELECT   workflowNodeForm.fieldId, MAX (workflowNodeForm.isView) isView,
                         MAX (workflowNodeForm.isEdit) isEdit, MAX (workflowNodeForm.isMandatory) isMandatory
                    FROM WorkFlow_NodeForm workflowNodeForm
                   WHERE EXISTS (
                            SELECT 1
                              FROM Workflow_CurrentOperator workflowCurrentOperator
                             WHERE workflowNodeForm.nodeId = workflowCurrentOperator.nodeId
                               AND workflowCurrentOperator.requestId = requestIdPara
                               AND workflowCurrentOperator.userId = userIdPara)
                GROUP BY workflowNodeForm.fieldId) B
         WHERE A.fieldID = B.fieldId
      ORDER BY A.fieldOrder;
END;
/


