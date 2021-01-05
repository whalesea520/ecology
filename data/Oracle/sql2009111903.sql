ALTER table  Bill_HrmFinance  ADD test varchar2(500)
/
update Bill_HrmFinance set test = name 
/
ALTER table  Bill_HrmFinance  drop column name
/
ALTER TABLE Bill_HrmFinance RENAME COLUMN test TO name
/
