CREATE OR REPLACE PROCEDURE init_subategory_parent as
       id_1 integer;
       subid_1 integer;
       mainid_1 integer;
  begin
    for secdir_cursor in(select id,dirid from DocSecCategory where dirtype=1)
    loop
        id_1 := secdir_cursor.id;
        subid_1 := secdir_cursor.dirid;
        for subdir_cursor in(select maincategoryid from DocSubCategory where id=subid_1)
          loop
            mainid_1 := subdir_cursor.maincategoryid;
            update DocSecCategory set parentid = (select id from DocSecCategory where dirid=mainid_1 and dirType=0) where id=id_1;
          end loop;
    end loop;
end;
/

call init_subategory_parent()
 /

drop PROCEDURE init_subategory_parent
/