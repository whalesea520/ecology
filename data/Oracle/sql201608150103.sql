DELETE from FnaCostCenterDtl 
where not exists (select 1 from FnaCostCenter where FnaCostCenter.id = FnaCostCenterDtl.fccId)
/