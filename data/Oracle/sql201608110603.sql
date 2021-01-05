create table workflow_updatecolumnlenlog (
        tablename varchar2(100),
        tablecolumn varchar2(100),
        columnlength varchar2(20)
        )
/
create  index ix_wfupdateclenlog_tbc on workflow_updatecolumnlenlog(tablecolumn)
/