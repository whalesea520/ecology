delete from syspoppupremindinfonew where (type=1 or type=0) and requestid not in (select requestid from workflow_requestbase)
GO