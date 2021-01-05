declare 
    TYPE arr IS VARRAY(10) of varchar(25);
    num number ;
    i number ;
    index2 number ;
    myArr arr;
    colsArr arr ;
    tb varchar(25) ;
    col varchar(25);
    tp varchar(25) ;
begin
  myArr := arr('HrmSubCompany', 'HrmDepartment', 'HrmJobTitles','HrmJobActivities','HrmJobGroups','HrmResource','HrmResourceManager') ;
  colsArr := arr('created','creater','modified','modifier');
  for i in 1 .. 7 loop
    tb :=myArr(i) ;
    for index2 in 1 .. 4 loop
      col :=colsArr(index2) ;
      select count(1) into num  from user_tab_columns where TABLE_NAME = upper(tb) and COLUMN_NAME=upper(col) ;
      if num <= 0 then 
        if instr(col,'ed') > 0 then
           tp := 'TIMESTAMP' ;        
        else
           tp := 'INT' ;
        end if ;
		execute immediate 'ALTER TABLE '||tb||' ADD (  '||col||' '||tp||')' ;
      end if ;
    end loop ;
  end loop;
end;
/
drop view HRMRESOURCEALLVIEW
/
create VIEW HRMRESOURCEALLVIEW  as SELECT id,loginid,workcode,lastname,pinyinlastname,sex,email,resourcetype,locationid,departmentid,subcompanyid1, costcenterid,jobtitle,managerid,assistantid,joblevel,seclevel,status,account,mobile,password,systemLanguage, telephone,managerstr,messagerurl,dsporder,accounttype,belongto, mobileshowtype,creater,created,modified,modifier FROM HrmResource UNION ALL SELECT id,loginid,'' AS workcode,lastname,'' as pinyinlastname ,'' AS sex, '' AS email,'' AS resourcetype,0 AS locationid,0 AS departmentid,0 AS subcompanyid1, 0 AS costcenterid,0 AS jobtitle,0 AS managerid,0 AS assistantid,0 AS joblevel,seclevel,status,'' AS account,mobile,password,systemLanguage, '' AS telephone,'' AS managerstr,'' AS messagerurl , id AS dsporder,0 AS accounttype, 0 AS belongto, 0 as mobileshowtype,creater,created,modified,modifier FROM HrmResourceManager
/
UPDATE HrmSubCompany SET created = SYSDATE
/
UPDATE HrmSubCompany SET modified  = SYSDATE
/
UPDATE HrmDepartment SET created  = SYSDATE
/
UPDATE HrmDepartment SET modified  = SYSDATE
/
UPDATE HrmJobTitles SET created  = SYSDATE
/
UPDATE HrmJobTitles SET modified  = SYSDATE
/
UPDATE HrmJobActivities SET created  = SYSDATE
/
UPDATE HrmJobActivities SET modified  = SYSDATE
/
UPDATE HrmJobGroups SET created  = SYSDATE
/
UPDATE HrmJobGroups SET modified  = SYSDATE
/
UPDATE HrmResource SET created  = SYSDATE
/
UPDATE HrmResource SET modified  = SYSDATE
/
UPDATE HrmResourceManager SET created  = SYSDATE
/
UPDATE HrmResourceManager SET modified  = SYSDATE
/