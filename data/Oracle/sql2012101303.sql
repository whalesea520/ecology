ALTER TABLE HrmSalaryResourcePay ADD isBatch char(1) null
/

CREATE OR REPLACE PROCEDURE HrmSalaryResourcePay_Insert(itemid_1      integer,
                                                        resourceid_2  integer,
                                                        resourcepay_3 number,
                                                        isBatch_4     char,
                                                        flag          out integer,
                                                        msg           out varchar2,
                                                        thecursor     IN OUT cursor_define.weavercursor) AS
begin
  INSERT INTO HrmSalaryResourcePay
    (itemid, resourceid, resourcepay,isBatch)
  VALUES
    (itemid_1, resourceid_2, resourcepay_3,isBatch_4);
end;
/