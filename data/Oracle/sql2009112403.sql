CREATE OR REPLACE PROCEDURE GetDBDateAndTime (flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
AS
begin
	OPEN thecursor FOR select to_char(sysdate,'yyyy-mm-dd') as dbdate,to_char(sysdate,'hh24:mi:ss') as dbtime from dual;
end;
/
