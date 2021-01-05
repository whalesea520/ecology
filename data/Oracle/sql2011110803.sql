create or replace PROCEDURE createIndexForEcology(indexname varchar,
                                                  tablename varchar,
                                                  tab_cols  varchar) as
  indexsql varchar(4000);
begin
  indexsql := 'create index ' || indexname || ' on ' || tablename || '(' ||
              tab_cols || ')';
  EXECUTE IMMEDIATE (indexsql);
  DBMS_OUTPUT.put_line('创建索引成功 : ' || indexsql);
exception
  when others then
    DBMS_OUTPUT.put_line('创建索引失败 : ' || indexsql);
end;
/

create or replace PROCEDURE dropIndexForEcology(indexname varchar) as
  indexsql varchar(4000);
begin
  indexsql := 'drop index ' || indexname;
  EXECUTE IMMEDIATE (indexsql);
  DBMS_OUTPUT.put_line('删除索引成功 : ' || indexsql);
exception
  when others then
    DBMS_OUTPUT.put_line('删除索引失败 : ' || indexsql);
end;
/

call createIndexForEcology('SysPoppupRemindInfo_rdx','SysPoppupRemindInfoNew','requestid')
/
call createIndexForEcology('remindindex','SysPoppupRemindInfoNew','userid,usertype')
/
call createIndexForEcology('sysfavourite_rdx','sysfavourite_favourite','sysfavouriteid')
/
call createIndexForEcology('HrmMessagerA_udx','HrmMessagerAccount','userid')
/
call createIndexForEcology('workplan_idx','workplan','id')
/
call createIndexForEcology('WorkPlanShareDetail_udx','WorkPlanShareDetail','userid')
/
call createIndexForEcology('WorkPlan_ridx','WorkPlan','remindDateBeforeEnd,remindTimeBeforeEnd,remindBeforeEnd')
/
call createIndexForEcology('WorkPlan_cidx','WorkPlan','crmid')
/
call createIndexForEcology('workflow_requestLog_odx','workflow_requestLog','operator,operatortype')
/
call dropIndexForEcology('sharetypes')
/
call createIndexForEcology('sharetypes','CRM_ShareInfo','contents,sharetype')
/
