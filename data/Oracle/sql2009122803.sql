alter table SystemSet add openPasswordLock integer
/
alter table SystemSet add sumPasswordLock integer
/
alter table SystemSet add passwordComplexity integer
/
alter table HrmResource add passwordlock integer
/
alter table HrmResource add sumpasswordwrong integer
/

ALTER TABLE HrmResource ADD oldpassword1 varchar2(100) NULL
/
ALTER TABLE HrmResource ADD oldpassword2 varchar2(100) NULL
/
