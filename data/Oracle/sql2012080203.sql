CREATE OR REPLACE PROCEDURE Prj_ProjectInfo_UpdateForMoney(id_1             integer,                                                  
                                                   budgetmoney_11   varchar2,
                                                   moneyindeed_12   varchar2,
                                                   budgetincome_13  varchar2,
                                                   imcomeindeed_14  varchar2,
                                                   flag             out integer,
                                                   msg              out varchar2,
                                                   thecursor        IN OUT cursor_define.weavercursor) AS
begin
  UPDATE Prj_ProjectInfo
     SET 
        
         budgetmoney   = to_number(budgetmoney_11),
         moneyindeed   = to_number(moneyindeed_12),
         budgetincome  = to_number(budgetincome_13),
         imcomeindeed  = to_number(imcomeindeed_14)
   WHERE (id = id_1);
end;
/