ALTER PROCEDURE bill_Discard_Detail_Insert 
    (@detailrequestid_1 int,
    @capitalid_2 int,
    @numbers_3 decimal(15,3),
    @date_4 char(10),
    @fee_5 decimal(15,3),
    @remark_6 varchar(100),
    @flag int output,
    @msg varchar(80) output)
AS INSERT INTO bill_Discard_Detail
    (detailrequestid,
    capitalid,
    numbers,
    dates,
    fee,
    remark)
VALUES 
    (@detailrequestid_1,
    @capitalid_2,
    @numbers_3,
    @date_4,
    @fee_5,
    @remark_6)
GO


alter table bill_Discard_Detail add tempnumbers decimal(15,3)
GO
update bill_Discard_Detail set tempnumbers = numbers
GO
alter table bill_Discard_Detail drop column numbers
GO
alter table bill_Discard_Detail add numbers decimal(15,3)
GO
update bill_Discard_Detail set numbers = tempnumbers
GO
alter table bill_Discard_Detail drop column tempnumbers
GO