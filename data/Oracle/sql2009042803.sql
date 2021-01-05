create OR REPLACE PROCEDURE T_OutReportStatitem_Uorder(
        outrepitemid_1 	integer,
        upordown_1  	integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
thedsporder integer;
theoutrepid integer;
begin 
select dsporder into thedsporder from T_OutReportStatitem where outrepitemid = outrepitemid_1;
select outrepid into theoutrepid from T_OutReportStatitem where outrepitemid = outrepitemid_1;

if upordown_1 = 1 then
    update T_OutReportStatitem set dsporder = dsporder+1 where outrepid = theoutrepid and dsporder = thedsporder-1; 
    update T_OutReportStatitem set dsporder = dsporder-1 where outrepitemid = outrepitemid_1;
else 
    update T_OutReportStatitem set dsporder = dsporder-1 where outrepid = theoutrepid and dsporder = thedsporder+1;
    update T_OutReportStatitem set dsporder = dsporder+1 where outrepitemid = outrepitemid_1;
end if;
end;
/