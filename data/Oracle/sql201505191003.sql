ALTER TABLE HrmResource ADD accountname  varchar2(200) NULL
/
CREATE OR REPLACE PROCEDURE HrmResourceFinanceInfo_Insert(id_1               integer,
                                                          bankid1_2          integer,
                                                          accountid1_3       varchar2,
                                                          accumfundaccount_4 varchar2,
                                                          accountname_5      varchar2,
                                                          flag               out integer,
                                                          msg                out varchar2,
                                                          thecursor          IN OUT cursor_define.weavercursor) AS
begin
  UPDATE HrmResource
     SET bankid1          = bankid1_2,
         accountid1       = accountid1_3,
         accumfundaccount = accumfundaccount_4,
         accountname      = accountname_5
   WHERE id = id_1;
end;
/