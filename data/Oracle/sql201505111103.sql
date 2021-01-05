CREATE OR REPLACE PROCEDURE init_monitor IS
  n_infoid INTEGER;
  n_hrmid          INTEGER;
  n_jktype         INTEGER;
  n_count          INTEGER;
  n_ct             integer;
  n_typeid_defaule integer;
BEGIN
  DELETE FROM workflow_monitor_info;
  DELETE FROM workflow_monitor_detail;
  select min(id) into n_typeid_defaule from workflow_monitortype;

  update workflow_monitor_bound set monitortype = n_typeid_defaule  where (monitortype is null or monitortype = '');
  

  FOR cul IN (SELECT monitorhrmid, monitortype
                FROM workflow_monitor_bound where exists (select 1 from workflow_base where workflow_monitor_bound.workflowid = workflow_base.id)
               GROUP BY monitorhrmid, monitortype) loop

    SELECT monitor_infoid.nextval INTO n_infoid FROM dual;
    n_hrmid := cul.monitorhrmid;
    n_count := 0;
    SELECT COUNT(1) INTO n_count FROM hrmresource WHERE id = n_hrmid;
    IF n_count > 0 THEN
      n_jktype := 1;
    ELSE
      n_jktype := 3;
    END IF;
    
    select count(1) into n_ct from (select workflowid from workflow_monitor_bound where monitorhrmid = n_hrmid and monitortype = cul.monitortype and exists (select 1 from workflow_base where workflow_monitor_bound.workflowid = workflow_base.id) group by workflowid) t;

    INSERT INTO workflow_monitor_info
      (id,
       monitortype,
       flowcount,
       operatordate,
       operatortime,
       operator,
       subcompanyid,
       jktype,
       jkvalue,
       fwtype,
       fwvalue)
    VALUES
      (n_infoid,
       cul.monitortype,
       n_ct,
       to_char(sysdate, 'yyyy-mm-dd'),
       to_char(sysdate, 'hh24:mi:ss'),
       1,
       0,
       n_jktype,
       n_hrmid,
       1,
       '');

    insert into workflow_monitor_detail
      (INFOID,
       workflowid,
       operatordate,
       operatortime,
       isview,
       isedit,
       isintervenor,
       isdelete,
       isforcedrawback,
       isforceover,
       operator,
       monitortype,
       issooperator)
      select n_infoid,
             workflowid,
             to_char(sysdate, 'yyyy-mm-dd'),
             to_char(sysdate, 'hh24:mi:ss'),
             max(nvl(isview,0)),
             '0',
             max(nvl(isintervenor,0)),
             max(nvl(isdelete,0)),
             max(nvl(isforcedrawback,0)),
             max(nvl(isforceover,0)),
             1,
             cul.monitortype,
             max(nvl(issooperator,0))
        from workflow_monitor_bound a
       where MONITORTYPE = cul.monitortype
         and monitorhrmid = cul.monitorhrmid
         and exists (select 1 from workflow_base where a.workflowid = workflow_base.id)
         group by workflowid;
  END loop;
  COMMIT;
END init_monitor;
/
declare
begin
	init_monitor;
end;
/