 CREATE or replace PROCEDURE CRM_ShareByHrm_WorkPlan (
crmId_1 varchar2, userId_1 integer, 
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
m_workid integer;
m_counworkPlanId integer;
begin
for  all_cursor in(
SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmId_1))
loop
m_workid := all_cursor.id;
select count(workid) into m_counworkPlanId FROM WorkPlanShareDetail WHERE workid = m_workid 
AND userid = userId_1 AND usertype = 1;
 if m_counworkPlanId  = 0 then
INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
m_workid, userId_1, 1, 0);
end if;
end loop;
end ;
/
