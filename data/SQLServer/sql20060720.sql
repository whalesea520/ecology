DECLARE 
	@formID int
DECLARE
	cur CURSOR FOR
		SELECT ID FROM WorkFlow_FormBase
OPEN cur
FETCH NEXT FROM cur 
	INTO @formID
WHILE(@@FETCH_STATUS <> -1)
	BEGIN
		DELETE FROM WorkFlow_NodeForm 
			WHERE nodeID IN
			(
				SELECT WorkFlowflowNode.nodeID 
				FROM Workflow_base WorkFlowBase, Workflow_flownode WorkFlowflowNode 
				WHERE WorkFlowBase.ID = WorkFlowflowNode.workFlowID 
				AND WorkFlowBase.isBill = 0 
				AND WorkFlowBase.formID = @formID
			) 
			AND fieldID NOT IN
			(
				SELECT fieldID FROM WorkFlow_FormField WHERE formID = @formID
			)
		FETCH NEXT FROM cur
			INTO @formID
	END
CLOSE cur
DEALLOCATE cur

go

