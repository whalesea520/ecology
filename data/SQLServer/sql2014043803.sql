update workflow_billfield  set qfws=2 where type=5 and fieldhtmltype=1  and qfws is null
go
update workflow_formdict  set qfws=2  where type=5 and fieldhtmltype=1  and qfws is null
go
update workflow_formdictdetail  set qfws=2  where type=5 and fieldhtmltype=1  and qfws is null
go