create table workflow_updatecolumnlenlog (
        tablename varchar(100),
        tablecolumn varchar(100),
        columnlength varchar(20)
        )
go
create  index ix_wfupdateclenlog_tbc on workflow_updatecolumnlenlog(tablecolumn)
go