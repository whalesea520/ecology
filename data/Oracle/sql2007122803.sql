create or replace trigger T_AlbumSubcompanyIns 
after insert  or delete
on HrmSubcompany
FOR each row
Declare

countdelete_1 integer;
countinsert_1 integer;
id_1 integer;

begin

countdelete_1 := :old.id ;
countinsert_1 := :new.id ; 

if countdelete_1 is null and countinsert_1>0 then 
     id_1 := :new.id ;
	insert into AlbumSubcompany (subcompanyId,albumSize,albumSizeUsed) values (id_1,1000000,0);
end if;

if countinsert_1 is null then
     id_1 := :old.id ;
	delete from AlbumSubcompany where subcompanyId=id_1;
end if;


end;
/

insert into albumsubcompany  select id,1000000,0 from(select id from hrmsubcompany where id not in (select subcompanyid from albumsubcompany))
/