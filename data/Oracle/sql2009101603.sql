CREATE or REPLACE PROCEDURE CptBorrowBuffer_Check (
currDate char, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS
 m_recId integer;
 m_cptId integer;
 m_useDate char(10);
 m_deptId integer;
 m_userId integer;
 m_depositary varchar2(200);
 m_remark varchar2(4000);
begin
for all_cursor in
(SELECT id, cptId, useDate, deptId, userId, depositary, remark FROM CptBorrowBuffer)
loop
    m_recId:=all_cursor.id;
    m_cptId:=all_cursor.cptid;
    m_useDate:=all_cursor.useDate;
    m_deptId:=all_cursor.deptId;
    m_userId:=all_cursor.userId;
    m_depositary:=all_cursor.depositary;
    m_remark:=all_cursor.remark;
    
    IF (currDate >= m_useDate) then
    	CptUseLogLend_IBCHK (m_cptId, m_useDate, m_deptId, m_userId, 1, m_depositary, 0, '', 0, '3', m_remark, 0 ) ;
		DELETE CptBorrowBuffer WHERE id = m_recId;
	END if;
	
end loop;    
end;
/
