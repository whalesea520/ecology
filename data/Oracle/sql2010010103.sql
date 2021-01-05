alter table CRM_ContacterLog_Remind modify lastestContactDate char(20)
/

CREATE or REPLACE PROCEDURE CRMRLOGDATE_UPDATE_BY_CRMID
    (crmid_1 number,
flag	out integer, 
msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor )

AS 
m_begindate varchar2(4000);
BEGIN
    SELECT MAX(begindate) INTO m_begindate
      FROM WorkPlan 
      WHERE type_n = '3' and concat(concat(',' , crmid), ',') LIKE concat(concat('%,' ,crmid_1),',%');

    UPDATE CRM_ContacterLog_Remind 
       SET lastestContactDate = m_begindate 
     WHERE customerid = crmid_1;
END;
/
