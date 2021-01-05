update workflow_currentoperator  set iscomplete=1
where iscomplete=0
  and islasttimes=1
  and isremark='2'
  and preisremark='8'
  and exists(select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype='3' )
/
