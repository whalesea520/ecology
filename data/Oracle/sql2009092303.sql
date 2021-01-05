CREATE OR REPLACE PROCEDURE MostExceedPerson_Get(
sqlStr_1  varchar2,
flag      out integer,
msg       out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
create_sql varchar2(7000);
orderby_sql varchar2(2000);
sqlstr_sql varchar2(8000);
begin
   create_sql :='select userid,
           count(distinct workflow_requestbase.requestid) counts,
           (select count(requestid)
              from workflow_requestbase b
             where exists (select 1
                      from workflow_currentoperator a
                     where a.requestid = b.requestid
                       and a.userid = workflow_currentoperator.userid)
               and b.status is not null) countall,
           to_number(count(distinct workflow_requestbase.requestid) * 100) /
           to_number((select count(requestid)
                       from workflow_requestbase b
                      where exists (select 1
                               from workflow_currentoperator a
                              where a.requestid = b.requestid
                                and a.userid =
                                    workflow_currentoperator.userid)
                        and b.status is not null)) percents
      from workflow_currentoperator, workflow_requestbase
     where workflow_currentoperator.requestid =
           workflow_requestbase.requestid
       and (24 * (to_date(NVL2(lastoperatedate,
                               lastoperatedate || '|| ' || lastoperatetime,
                               to_char(sysdate, '||'YYYY-MM-DD HH24:MI:SS'||')),
                          '||'YYYY-MM-DD HH24:MI:SS'||') -
           to_date(createdate || '|| ' || createtime,
                          '||'YYYY-MM-DD HH24:MI:SS'||')) -
           (select sum(NVL(to_number(nodepasshour), 0) +
                        NVL(to_number(nodepassminute), 0) / 24)
               from workflow_nodelink
              where workflowid = workflow_requestbase.workflowid)

           ) > 0
       and workflow_requestbase.status is not null
       and exists
     (select 1
              from workflow_nodelink
             where workflowid = workflow_requestbase.workflowid
               and (workflow_currentoperator.usertype = 0)
               and exists
             (select 1
                      from hrmresource
                     where hrmresource.id = workflow_currentoperator.userid
                       and hrmresource.status in (0, 1, 2, 3))
               and (to_number(NVL(nodepasshour, 0)) > 0 or
                   to_number(nvl(nodepassminute, 0)) > 0))
       and workflow_currentoperator.isremark <> 4';
    orderby_sql:='group by userid order by percents desc';
    sqlstr_sql := create_sql || sqlStr_1 || orderby_sql;
    execute immediate create_sql;
end;
/

CREATE OR REPLACE PROCEDURE WorkFlowPending_Get(
sqlStr_1  varchar2,
flag      out integer,
msg       out varchar2,
thecursor IN OUT cursor_define.weavercursor) AS

create_sql  varchar2(7000);
orderby_sql varchar2(2000);
sqlstr_sql  varchar2(8000);

begin
  create_sql  := 'SELECT userid, COUNT(requestid) AS Expr1 FROM workflow_currentoperator WHERE (isremark IN (' ||
                 '0||'', '||'1||'', '||'5||''))
                 AND (islasttimes = 1) AND (usertype = 0) and exists (select 1 from hrmresource where hrmresource.id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3) )';
  orderby_sql := 'GROUP BY userid ORDER BY COUNT(requestid) desc';
  sqlstr_sql  := create_sql || sqlStr_1 || orderby_sql;
  execute immediate create_sql;
end;
/