
/*一下是刘煜的《Ecology产品开发-人力资源工资BUG修改V1.0提交测试报告2003-08-15》的脚本*/




CREATE or replace PROCEDURE HrmSalaryPaydetail_Update
	(payid_1 	integer,
	 itemid_2 	varchar2,
	 hrmid_3 	integer,
	 salary_4 	number,
     flag	out integer,
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor)

AS 
count_1 integer;
begin
select count(payid) into count_1 from HrmSalaryPaydetail where 
( payid	 = payid_1 AND itemid = itemid_2 AND hrmid = hrmid_3);
if count_1 is null or count_1 = 0
then
    INSERT INTO HrmSalaryPaydetail 
	 ( payid,
	 itemid,
	 hrmid,
	 salary) 
     VALUES 
        ( payid_1,
         itemid_2,
         hrmid_3,
         salary_4);
else 
    UPDATE HrmSalaryPaydetail 
    SET  salary=salary_4 
    WHERE 
        ( payid	= payid_1 AND
         itemid	= itemid_2 AND
         hrmid	= hrmid_3) ;
end if;
end;
/


update SystemRightDetail set rightdetail='HrmJobCallAdd:Add' where id = 418
/
update SystemRightDetail set rightdetail='HrmJobCallEdit:Edit' where id = 419
/
update SystemRightDetail set rightdetail='HrmJobCallEdit:Delete' where id = 420
/
update SystemRightDetail set rightdetail='HrmJobCall:Log' where id = 421
/


insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (382,7,'学历维护','学历维护')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (382,8,'','')
/