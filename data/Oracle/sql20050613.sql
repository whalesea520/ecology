alter table docdetail add  docExtendName char(10)
/

CREATE OR REPLACE  PROCEDURE initDocDetail_docExtendName	
as
	docid_1 integer;
	doctype_2 integer;
 	docfiletype_3 integer;
begin
	FOR all_cursor in(
	select d1.id,d1.doctype,d2.docfiletype from docdetail d1 left join docimagefile d2 on d1.id=d2.docid)	
	loop
    docid_1 := all_cursor.id;
    doctype_2 := all_cursor.doctype;
    docfiletype_3 := all_cursor.docfiletype;
		if doctype_2 = 2 then
                if docfiletype_3 = 3  then
                    update docdetail set docExtendName='doc' where id = docid_1;
                    else if  docfiletype_3 = 4 then 
                                 update docdetail set docExtendName='xls' where id = docid_1;
                             else  
                                 update docdetail set docExtendName='html' where id = docid_1;	
                         end if;
                end if;    
             else 
                update docdetail set docExtendName='html' where id = docid_1;
         end if;
	end loop;
end;
/
CALL initDocDetail_docExtendName()
/
