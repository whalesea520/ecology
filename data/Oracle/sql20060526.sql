declare docid integer;
begin
for initdocid_cursor in(select id from (select id from docdetail order by id desc) WHERE rownum <=500)
loop
	docid := initdocid_cursor.id;
	Share_forDoc_init (docid);
end loop;
end;
/
