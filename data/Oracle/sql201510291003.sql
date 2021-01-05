alter table INT_SAPLOGTAB add  parvalue_temp varchar2(50)
/
update INT_SAPLOGTAB a  set a.parvalue_temp = (select b.parvalue from  int_saplogtab b where a.id = b.id)
/
alter table INT_SAPLOGTAB drop column  parvalue
/
alter table INT_SAPLOGTAB add parvalue varchar2(2000)
/
update INT_SAPLOGTAB a  set a.parvalue = (select b.parvalue_temp from  int_saplogtab b where a.id = b.id)
/
alter table INT_SAPLOGTAB drop column  parvalue_temp
/