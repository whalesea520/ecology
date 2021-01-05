CREATE or replace PROCEDURE CRM_Share_WorkPlan_AllCheck
AS 
 crmId_1 varchar2(100);
 m_workid integer;
 m_userid integer;
 m_usertype integer;
 m_countId integer;
begin
FOR crm_cursor in( 
select id from CRM_CustomerInfo)
loop
	crmId_1 := crm_cursor.id;
	FOR all_cursor in( 
	SELECT id FROM WorkPlan WHERE type_n = '3' AND concat(concat(',',crmid),',') LIKE concat(concat('%,',crmId_1),',%'))
		loop 
			m_workid := all_cursor.id;
			FOR m_cursor in(SELECT userid, usertype FROM CrmShareDetail WHERE crmid = crmId_1)
				loop
					m_userid := m_cursor.userid;
					m_usertype := m_cursor.usertype;
					SELECT count(workid) into m_countId FROM WorkPlanShareDetail WHERE workid = m_workid 
					AND userid = m_userid AND usertype = m_usertype;
					if m_countId = 0 then
					INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
					m_workid, m_userid, m_usertype, 0);
					end if;
				end loop;
		end loop;
end loop;
end;
/
call CRM_Share_WorkPlan_AllCheck()
/
DROP PROCEDURE CRM_Share_WorkPlan_AllCheck
/