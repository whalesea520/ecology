CREATE OR REPLACE PROCEDURE bill_Discard_Detail_Insert 
    (detailrequestid_1 integer,
    capitalid_2 integer,
    numbers_3 number,
    date_4 char,
    fee_5 number,
    remark_6 varchar2,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO bill_Discard_Detail
    (detailrequestid,
    capitalid,
    numbers,
    dates,
    fee,
    remark)
VALUES 
    (detailrequestid_1,
    capitalid_2,
    numbers_3,
    date_4,
    fee_5,
    remark_6);
end;
/


alter table bill_Discard_Detail add tempnumbers number(15,3)
/
update bill_Discard_Detail set tempnumbers = numbers
/
alter table bill_Discard_Detail drop column numbers
/
alter table bill_Discard_Detail add numbers number(15,3)
/
update bill_Discard_Detail set numbers = tempnumbers
/
alter table bill_Discard_Detail drop column tempnumbers
/