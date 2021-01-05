Declare

id_1 integer;

begin
FOR all_cursor in( 
select id from codemain where id>1)
loop
id_1 := all_cursor.id;
insert into codedetail(codemainid,showname,showtype,value,codeorder) values(id_1,'19921','4','0',1);
END loop;
end;
/

alter table codedetail add issecdoc char(1)
/
