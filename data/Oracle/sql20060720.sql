DECLARE 
	formID_1 integer;

begin
FOR cur in( 
		SELECT ID FROM WorkFlow_FormBase)
	loop
		formID_1 := cur.ID;
		DELETE FROM WorkFlow_NodeForm 
			WHERE nodeID IN
			(
				SELECT WorkFlowflowNode.nodeID 
				FROM Workflow_base WorkFlowBase, Workflow_flownode WorkFlowflowNode 
				WHERE WorkFlowBase.ID = WorkFlowflowNode.workFlowID 
				AND WorkFlowBase.isBill = 0 
				AND WorkFlowBase.formID = formID_1
			) 
			AND fieldID NOT IN
			(
				SELECT fieldID FROM WorkFlow_FormField WHERE formID = formID_1
			);
	end loop;
end;
/

