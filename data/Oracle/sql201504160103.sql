drop PROCEDURE bill_BudgetDetail_Insert
/


drop PROCEDURE bill_BudgetDetail_SAllMonth
/ 


drop PROCEDURE bill_BudgetDetail_SelectOne
/ 


drop PROCEDURE bill_BudgetDetail_SMonthToByf
/ 


drop PROCEDURE bill_BudgetDetail_SMonthTotal
/ 


drop PROCEDURE Bill_TotalBudget_SelectByID
/ 


drop PROCEDURE bill_TotalBudget_UpdateStatus 
/ 

CREATE OR REPLACE PROCEDURE FnaLedger_InsertAuto(crmname_1 varchar2,
                                                 crmtype_1 char,
                                                 crmcode_1 varchar2,
                                                 flag      out integer,
                                                 msg       out varchar2,
                                                 thecursor IN OUT cursor_define.weavercursor) AS
  count_1          integer;
  init_1           number(18, 3);
  ledgermark_1     varchar2(4000);
  ledgername_2     varchar2(4000);
  ledgertype_3     char(1);
  ledgergroup_4    char(1);
  ledgerbalance_5  char(1);
  ledgercurrency_7 char(1);
  supledgerid_8    integer;
  Categoryid_9     integer;
  supledgerall_10  varchar2(4000);
  ledgerid1_1      integer;
  ledgerid2_1      integer;
  ledgermark_count integer;
  recordcount_2    integer;
  recordcount_1    integer;
begin
  if crmtype_1 = '1' then
    select count(ledgermark)
      into ledgermark_count
      from FnaLedger
     where autosubledger = '1';
    if ledgermark_count > 0 then
      select ledgermark
        into ledgermark_1
        from FnaLedger
       where autosubledger = '1';
    end if;
    select count(id)
      into count_1
      from FnaLedger
     where ledgermark = (ledgermark_1 || crmcode_1);
    if count_1 <> 0 then
      open thecursor for
        select 1, 0, 0 from dual;
      return;
    end if;
    select ledgermark
      into ledgermark_1
      from FnaLedger
     where autosubledger = '2';
    select count(id)
      into count_1
      from FnaLedger
     where ledgermark = (ledgermark_1 || crmcode_1);
    if count_1 <> 0 then
      open thecursor for
        select 1, 0, 0 from dual;
      return;
    end if;
    select count(*)
      into recordcount_1
      from FnaLedger
     where autosubledger = '1';
    if recordcount_1 > 0 then
      select ledgermark,
             ledgername,
             ledgertype,
             ledgergroup,
             ledgerbalance,
             ledgercurrency,
             id,
             Categoryid,
             supledgerall
        into ledgermark_1,
             ledgername_2,
             ledgertype_3,
             ledgergroup_4,
             ledgerbalance_5,
             ledgercurrency_7,
             supledgerid_8,
             Categoryid_9,
             supledgerall_10
        from FnaLedger
       where autosubledger = '1';
    end if;
    ledgermark_1    := ledgermark_1 || crmcode_1;
    ledgername_2    := ledgername_2 || '-' || crmname_1;
    supledgerall_10 := concat(supledgerall_10,
                              (to_char(supledgerid_8) || '|'));
    INSERT INTO FnaLedger
      (ledgermark,
       ledgername,
       ledgertype,
       ledgergroup,
       ledgerbalance,
       autosubledger,
       ledgercurrency,
       supledgerid,
       Categoryid,
       supledgerall)
    VALUES
      (ledgermark_1,
       ledgername_2,
       ledgertype_3,
       ledgergroup_4,
       ledgerbalance_5,
       '0',
       ledgercurrency_7,
       supledgerid_8,
       Categoryid_9,
       supledgerall_10);
    select max(id) into ledgerid1_1 from FnaLedger;
    update FnaLedger
       set subledgercount = subledgercount + 1
     where id = supledgerid_8;
    select ledgermark,
           ledgername,
           ledgertype,
           ledgergroup,
           ledgerbalance,
           ledgercurrency,
           id,
           Categoryid,
           supledgerall
      into ledgermark_1,
           ledgername_2,
           ledgertype_3,
           ledgergroup_4,
           ledgerbalance_5,
           ledgercurrency_7,
           supledgerid_8,
           Categoryid_9,
           supledgerall_10
      from FnaLedger
     where autosubledger = '2';
    ledgermark_1    := ledgermark_1 || crmcode_1;
    ledgername_2    := ledgername_2 || '-' || crmname_1;
    supledgerall_10 := supledgerall_10 || to_number(supledgerid_8) || '|';
    INSERT INTO FnaLedger
      (ledgermark,
       ledgername,
       ledgertype,
       ledgergroup,
       ledgerbalance,
       autosubledger,
       ledgercurrency,
       supledgerid,
       Categoryid,
       supledgerall)
    VALUES
      (ledgermark_1,
       ledgername_2,
       ledgertype_3,
       ledgergroup_4,
       ledgerbalance_5,
       '0',
       ledgercurrency_7,
       supledgerid_8,
       Categoryid_9,
       supledgerall_10);
    select max(id) into ledgerid2_1 from FnaLedger;
    update FnaLedger
       set subledgercount = subledgercount + 1
     where id = supledgerid_8;
  end if;
  if crmtype_1 = '2' then
    select count(ledgermark)
      into ledgermark_count
      from FnaLedger
     where autosubledger = '3';
    if ledgermark_count > 0 then
      select ledgermark
        into ledgermark_1
        from FnaLedger
       where autosubledger = '3';
    end if;
    select count(id)
      into count_1
      from FnaLedger
     where ledgermark = (ledgermark_1 || crmcode_1);
    if count_1 <> 0 then
      open thecursor for
        select 1, 0, 0 from dual;
      return;
    end if;
    select ledgermark
      into ledgermark_1
      from FnaLedger
     where autosubledger = '4';
    select count(id)
      into count_1
      from FnaLedger
     where ledgermark = (ledgermark_1 || crmcode_1);
    if count_1 <> 0 then
      open thecursor for
        select 1, 0, 0 from dual;
      return;
    end if;
    select count(*)
      into recordcount_2
      from FnaLedger
     where autosubledger = '3';
    if recordcount_2 > 0 then
      select ledgermark,
             ledgername,
             ledgertype,
             ledgergroup,
             ledgerbalance,
             ledgercurrency,
             id,
             Categoryid,
             supledgerall
        into ledgermark_1,
             ledgername_2,
             ledgertype_3,
             ledgergroup_4,
             ledgerbalance_5,
             ledgercurrency_7,
             supledgerid_8,
             Categoryid_9,
             supledgerall_10
        from FnaLedger
       where autosubledger = '3';
    end if;
    ledgermark_1    := ledgermark_1 || crmcode_1;
    ledgername_2    := ledgername_2 || '-' || crmname_1;
    supledgerall_10 := supledgerall_10 || to_char(supledgerid_8) || '|';
    INSERT INTO FnaLedger
      (ledgermark,
       ledgername,
       ledgertype,
       ledgergroup,
       ledgerbalance,
       autosubledger,
       ledgercurrency,
       supledgerid,
       Categoryid,
       supledgerall)
    VALUES
      (ledgermark_1,
       ledgername_2,
       ledgertype_3,
       ledgergroup_4,
       ledgerbalance_5,
       '0',
       ledgercurrency_7,
       supledgerid_8,
       Categoryid_9,
       supledgerall_10);
    select max(id) into ledgerid1_1 from FnaLedger;
    update FnaLedger
       set subledgercount = subledgercount + 1
     where id = supledgerid_8;
    select ledgermark,
           ledgername,
           ledgertype,
           ledgergroup,
           ledgerbalance,
           ledgercurrency,
           id,
           Categoryid,
           supledgerall
      into ledgermark_1,
           ledgername_2,
           ledgertype_3,
           ledgergroup_4,
           ledgerbalance_5,
           ledgercurrency_7,
           supledgerid_8,
           Categoryid_9,
           supledgerall_10
      from FnaLedger
     where autosubledger = '4';
    ledgermark_1    := ledgermark_1 || crmcode_1;
    ledgername_2    := ledgername_2 || '-' || crmname_1;
    supledgerall_10 := supledgerall_10 || to_char(supledgerid_8) || '|';
    INSERT INTO FnaLedger
      (ledgermark,
       ledgername,
       ledgertype,
       ledgergroup,
       ledgerbalance,
       autosubledger,
       ledgercurrency,
       supledgerid,
       Categoryid,
       supledgerall)
    VALUES
      (ledgermark_1,
       ledgername_2,
       ledgertype_3,
       ledgergroup_4,
       ledgerbalance_5,
       '0',
       ledgercurrency_7,
       supledgerid_8,
       Categoryid_9,
       supledgerall_10);
    select max(id) into ledgerid2_1 from FnaLedger;
    update FnaLedger
       set subledgercount = subledgercount + 1
     where id = supledgerid_8;
  end if;
  open thecursor for
    select 0, ledgerid1_1, ledgerid2_1 from dual;
end;
/
