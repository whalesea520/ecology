CREATE OR REPLACE TRIGGER trg_cptfrozennum_update
before UPDATE OF frozennum ON cptcapital
FOR EACH ROW
declare
  i_cptid int;
  i_isdata int;
  i_oldfrozennum decimal(15,2);
  i_newfrozennum decimal(15,2);
begin
    i_cptid:=:new.id;
    i_isdata:=:new.isdata;
    i_oldfrozennum:=:old.frozennum;
    i_newfrozennum:=:new.frozennum;

    if i_isdata!=2 THEN RETURN; end if;
     select  sum(t.num) into :new.frozennum  from
  (
  select d.number_n as num from bill_cptfetchmain m,bill_cptfetchdetail d where d.cptfetchid=m.id and d.capitalid=i_cptid and exists(select 1 from workflow_requestbase r where r.requestid=m.requestid and r.currentnodetype>0 and r.currentnodetype<3)
  union
  select d.numbers as num from bill_discard_detail d where d.capitalid=i_cptid and exists(select 1 from workflow_requestbase r where r.requestid=d.detailrequestid and r.currentnodetype>0 and r.currentnodetype<3)
  union
  select m.losscount as num from bill_cptloss m where m.losscpt=i_cptid and exists(select 1 from workflow_requestbase r where r.requestid=m.requestid and r.currentnodetype>0 and r.currentnodetype<3)
  ) t ;

end;
/