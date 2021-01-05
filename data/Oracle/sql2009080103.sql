declare
 requestid_1 integer;
 currentnodeid_1 integer;
begin
  for initdocid_cursor in
	(select requestid,currentnodeid from workflow_requestbase)
	loop
		requestid_1 := initdocid_cursor.requestid;
		currentnodeid_1 := initdocid_cursor.currentnodeid;

		update 	workflow_currentoperator  set nodeid=currentnodeid_1 where requestid=requestid_1 and isremark=0 and nodeid is null;
	end loop;
end;
/
