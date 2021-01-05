CREATE or REPLACE PROCEDURE FnaCurrency_Update 
 (id_1 	integer, 
 currencyname_1 	varchar2,
 currencydesc_2 	varchar2, 
 activable_3 	char, 
 isdefault 	char, 
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
count_1 integer;
begin
select count(id) into count_1 from FnaCurrency where currencyname = currencyname_1 ;
if count_1 <>0 then
    open thecursor for
    select -1 from dual;
end if;

if isdefault = '1' then
    update FnaCurrency set isdefault = '0';
    UPDATE FnaCurrency SET  
    currencyname	 = currencyname_1,
    currencydesc	 = currencydesc_2, 
    activable	 = activable_3 , 
    isdefault = '1' 
    WHERE ( id	 = id_1) ;
else 
    UPDATE FnaCurrency  SET  
    currencyname	 = currencyname_1,
    currencydesc	 = currencydesc_2, 
    activable	 = activable_3  
    WHERE ( id	 = id_1);
end if;
end;
/



update workflow_groupdetail set objid=5 where groupid = 1
/

update SystemRights set rightdesc = '财务预算通过' where id = 73 
/

update SystemRightsLanguage set rightname = '财务预算通过' , rightdesc = '财务预算通过' where id=73  and languageid=7 
/


/* 清理工作流提醒数据 */
delete SysRemindInfo 
/


