alter table workflow_flownode add IsTakingOpinions char(1)
go
alter table workflow_flownode add IsHandleForward char(1)
go
alter table workflow_flownode add vtTakingOpinions char(1)
go
alter table workflow_flownode add vtHandleForward char(1)
go
alter table workflow_flownode add vttpostil char(1)
go
alter table workflow_flownode add vtrpostil char(1)
go
alter table workflow_flownode add vmobilesource char(1)
go

alter table workflow_currentoperator add handleforwardid int
go
alter table workflow_currentoperator add takisremark int
go


alter table workflow_nodecustomrcmenu add forhandName7 varchar(50)
go
alter table workflow_nodecustomrcmenu add forhandName8 varchar(50)
go
alter table workflow_nodecustomrcmenu add forhandName9 varchar(50)
go
alter table workflow_nodecustomrcmenu add forhandnobackName7 varchar(50)
go
alter table workflow_nodecustomrcmenu add forhandnobackName8 varchar(50)
go
alter table workflow_nodecustomrcmenu add forhandnobackName9 varchar(50)
go
alter table workflow_nodecustomrcmenu add forhandbackName7 varchar(50)
go
alter table workflow_nodecustomrcmenu add forhandbackName8 varchar(50)
go
alter table workflow_nodecustomrcmenu add forhandbackName9 varchar(50)
go

alter table workflow_nodecustomrcmenu add takingOpName7 varchar(50)
go
alter table workflow_nodecustomrcmenu add takingOpName8 varchar(50)
go
alter table workflow_nodecustomrcmenu add takingOpName9 varchar(50)
go

alter table workflow_nodecustomrcmenu add takingOpinionsName7 varchar(50)
go
alter table workflow_nodecustomrcmenu add takingOpinionsName8 varchar(50)
go
alter table workflow_nodecustomrcmenu add takingOpinionsName9 varchar(50)
go
alter table workflow_nodecustomrcmenu add takingOpinionsnobackName7 varchar(50)
go
alter table workflow_nodecustomrcmenu add takingOpinionsnobackName8 varchar(50)
go
alter table workflow_nodecustomrcmenu add takingOpinionsnobackName9 varchar(50)
go
alter table workflow_nodecustomrcmenu add takingOpinionsbackName7 varchar(50)
go
alter table workflow_nodecustomrcmenu add takingOpinionsbackName8 varchar(50)
go
alter table workflow_nodecustomrcmenu add takingOpinionsbackName9 varchar(50)
go
alter table workflow_nodecustomrcmenu add hasforhandback char(1)
go
alter table workflow_nodecustomrcmenu add hasforhandnoback char(1)
go
alter table workflow_nodecustomrcmenu add hastakingOpinionsback char(1)
go
alter table workflow_nodecustomrcmenu add hastakingOpinionsnoback char(1)
go