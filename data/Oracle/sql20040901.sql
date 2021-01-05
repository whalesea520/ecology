/* td:993 by 刘煜 for 编辑‘福利’类型和‘税收’类型，自动翻倍增加加一行的记录 */

create or replace PROCEDURE HrmSalaryItem_Update
	(id_1 	integer,
	 itemname_2 	varchar2,
	 itemcode_3 	varchar2,
	 itemtype_4 	char,
	 personwelfarerate_5 	integer,
	 companywelfarerate_6 	integer,
	 taxrelateitem_7 	integer,
	 amountecp_8 	varchar2,
	 feetype_9 	integer,
	 isshow_10 	char,
	 showorder_11 	integer,
	 ishistory_12 	char ,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 

olditemtype_1 char(1) ;
benchid_1 integer;
begin
select itemtype into olditemtype_1 from HrmSalaryItem where id = id_1 ;
UPDATE HrmSalaryItem 
SET  itemname	 = itemname_2,
	 itemcode	 = itemcode_3,
	 itemtype	 = itemtype_4,
	 personwelfarerate	 = personwelfarerate_5,
	 companywelfarerate	 = companywelfarerate_6,
	 taxrelateitem	 = taxrelateitem_7,
	 amountecp	 = amountecp_8,
	 feetype	 = feetype_9,
	 isshow	 = isshow_10,
	 showorder	 = showorder_11,
	 ishistory	 = ishistory_12 

WHERE 
	( id	 = id_1);

if olditemtype_1 = '1' or olditemtype_1 = '2' then
    delete from HrmSalaryRank where itemid = id_1;
    delete from HrmSalaryWelfarerate where itemid = id_1;
else 
    if olditemtype_1 = '5' or olditemtype_1 = '6' then
        delete from HrmSalarySchedule where itemid = id_1;
    else 
        if olditemtype_1 = '7' then
            delete from HrmSalaryShiftPay where itemid = id_1 ;
        else 
            if olditemtype_1 = '3' then
            for benchid_cursor in
            (select id from HrmSalaryTaxbench where itemid = id_1)
            loop
                benchid_1 := benchid_cursor.id ;
                delete from HrmSalaryTaxrate where benchid = benchid_1;
                delete from HrmSalaryTaxbench where id = benchid_1;
            end loop;
            end if;
        end if;
    end if;
end if;
end;
/

