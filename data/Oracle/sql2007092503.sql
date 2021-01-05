alter table  cowork_items add  lastdiscussant int
/

Create or replace  PROCEDURE Init_cowork_discussant		
as	
	coworkid_1 integer;
	discussant_1 integer;
begin
	FOR all_cursor in(select id from cowork_items )
	loop
		coworkid_1 := all_cursor.id;
		select t1.discussant  into discussant_1 from (select  discussant,rownum from  cowork_discuss order by  createdate desc,createtime desc) t1 where rownum=1;			
		update cowork_items set lastdiscussant=discussant_1 where id=coworkid_1;
	END loop;
	
end;
/

call Init_cowork_discussant()
/

Create or replace TRIGGER Tri_cow_dis_ByDis
after insert  ON cowork_discuss 
FOR each row
Declare discussant_1 integer;
	coworkid_1 integer;
begin
    discussant_1 := :new.discussant;
    coworkid_1 := :new.coworkid;

    update cowork_items set lastdiscussant=discussant_1 where id=coworkid_1;
end;
/

INSERT INTO HPFieldElement(id, elementId, fieldName, fieldColumn, isDate, transMethod, fieldWidth, linkUrl, valueColumn, isLimitLength, orderNum)
VALUES(70, 13, '20899', 'lastdiscussant', '0', 'getLastdiscussant', '70', '', '', '', 2)
/
