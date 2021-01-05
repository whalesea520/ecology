alter table CPCONSTITUTIONVERSION  modify currencyid varchar2(50)
/
alter table CPBOARDOFFICERVERSION add sessions_temp varchar2(200)
/
update CPBOARDOFFICERVERSION set sessions_temp=sessions
/
alter table CPBOARDOFFICERVERSION  drop column sessions
/
alter table CPBOARDOFFICERVERSION  rename column sessions_temp to sessions
/