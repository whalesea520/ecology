alter PROCEDURE wrkcrt_mutidel
(@flag integer output,
 @msg varchar(80) output
 )
as
declare @requestid_1 integer,@userid_1 integer,@isremark_1 integer,@isremark_2 integer,
@groupid_1 integer,@workflowid_1 integer,@workflowtype_1 integer

delete from workflow_requestViewLog where (convert(varchar(10),id)+','+convert(varchar(10),currentnodeid)) in 
( select (convert(varchar(10),a.id)+','+convert(varchar(10),a.currentnodeid)) from 
  workflow_requestViewLog a, workflow_requestbase b
  where a.currentnodeid != b.currentnodeid and a.id = b.requestid ) 
GO