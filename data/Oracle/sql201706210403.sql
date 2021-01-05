
  CREATE OR REPLACE PROCEDURE CRM_SHAREBYHRM_WORKPLAN ( crmId_1 varchar2, userId_1 integer, flag out integer  , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS m_workid integer; m_counworkPlanId integer; begin for  all_cursor in( SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmId_1)) loop m_workid := all_cursor.id; select count(workid) into m_counworkPlanId FROM WorkPlanShareDetail WHERE workid = m_workid AND userid = userId_1 AND usertype = 1; if m_counworkPlanId  = 0 then INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel , sharetype , objid) VALUES ( m_workid, userId_1, 1, 0 , 1 , userId_1); end if; end loop; end ;

/

  CREATE OR REPLACE PROCEDURE WORKPLANSHARE_INSERT ( workid_1 integer  , userid_1 integer   , usertype_1 integer   , sharelevel_1 integer   , flag out integer  , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS begin /* IF EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workid_1 AND userid = @userid_1 AND usertype = @usertype_1 AND sharelevel = @sharelevel_1) RETURN IF (@sharelevel_1 = 2 AND EXISTS(SELECT workid FROM WorkPlanShareDetail WHERE workid = @workid_1 AND userid = @userid_1 AND usertype = @usertype_1 AND sharelevel = 1)) BEGIN UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = @workid_1 AND userid = @userid_1 AND usertype = @usertype_1 RETURN END */ INSERT INTO WorkPlanShareDetail (workid , userid , usertype , sharelevel , sharetype , objid) VALUES (workid_1 , userid_1 , usertype_1 , sharelevel_1 , 1 , userid_1); end;

/
