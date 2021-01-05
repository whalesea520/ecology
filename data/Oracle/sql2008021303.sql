alter table DocSubCategory add suborder float default 0
/
update DocSubCategory set suborder = 0
/
alter table DocSecCategory add secorder float default 0
/
update DocSecCategory set secorder = 0
/
alter table temp_4 modify(orderid float)
/
alter table DocMainCategory modify (categoryorder float)
/

CREATE or REPLACE procedure Doc_GetPermittedCategory
(
userid_1 integer,
usertype_1 integer, 
seclevel_1 integer,
operationcode_1 integer,  
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as 
secdirid_1 integer;
secdirname_1 varchar2(200);
subdirid_1 integer;
subdirid1_1 integer;
superdirid_1 integer;
superdirtype_1 integer;
maindirid_1 integer;
subdirname_1 varchar2(200);
count_1 integer;
orderid_1 float;
begin
if usertype_1 = 0 then
    if operationcode_1 = 0 then
        for secdir_cursor in(select id mainid, categoryname, subcategoryid, secorder from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=2 and createdoc>0))        
        loop
            secdirid_1 := secdir_cursor.mainid;
            secdirname_1 := secdir_cursor.categoryname;
            subdirid_1 := secdir_cursor.subcategoryid;
            orderid_1 :=secdir_cursor.secorder;
            insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1);
            if subdirid_1 is null then
            subdirid_1 := -1 ;
            end if;
            if subdirid_1 = 0 then
            subdirid_1 := -1 ;
            end if;
         
                while subdirid_1 <> -1 loop
                    select subcategoryid,categoryname,subcategoryid,maincategoryid,suborder into subdirid1_1,subdirname_1,superdirid_1,maindirid_1,orderid_1  from DocSubCategory where  id = subdirid_1 ;
                    if superdirid_1 = -1 then
                        superdirid_1 := maindirid_1 ;
                        superdirtype_1 := 0 ;        
                    else 
                        superdirtype_1 := 1 ;
                    end if;
                    count_1 := 0 ;        
                    select count(categoryid) into count_1 from temp_4 where categoryid = subdirid_1 and categorytype = 1 ;
                    if count_1 <= 0 then
                        insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(subdirid_1, 1, superdirid_1, superdirtype_1, subdirname_1, orderid_1);
                    end if;
                    subdirid_1 := subdirid1_1 ;
                end loop;
            end loop;        
    elsif operationcode_1 = 1 then
        for secdir_cursor in (select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=2 and createdir>0))        
        loop
            secdirid_1 := secdir_cursor.mainid;
            secdirname_1 := secdir_cursor.categoryname;
            subdirid_1 := secdir_cursor.subcategoryid;
            orderid_1 := secdir_cursor.secorder;
            insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1);
            if subdirid_1 is null then
            subdirid_1 := -1 ;
            end if;
            if subdirid_1 = 0 then
            subdirid_1 := -1 ;
            end if;
         
            while subdirid_1 <> -1 loop
                select subcategoryid,categoryname,subcategoryid,maincategoryid,suborder into subdirid1_1,subdirname_1,superdirid_1,maindirid_1,orderid_1  from DocSubCategory where id = subdirid_1;
                if superdirid_1 = -1 then
                    superdirid_1 := maindirid_1 ;
                    superdirtype_1 := 0 ;        
                else 
                    superdirtype_1 := 1 ;
                end if;
                count_1 := 0 ;        
                select count(categoryid) into count_1 from temp_4 where categoryid = subdirid_1 and categorytype = 1 ;
                if count_1 <= 0 then
                    insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(subdirid_1, 1, superdirid_1, superdirtype_1, subdirname_1, orderid_1);
                    end if;
                    subdirid_1 := subdirid1_1 ;
            end loop;
        end loop;        
    
    elsif operationcode_1 = 2 then
        for secdir_cursor in (select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=2 and movedoc>0))        
        loop
            secdirid_1 := secdir_cursor.mainid;
            secdirname_1 := secdir_cursor.categoryname;
            subdirid_1 := secdir_cursor.subcategoryid;
            orderid_1 := secdir_cursor.secorder;
            insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1);
            if subdirid_1 is null then
            subdirid_1 := -1 ;
            end if;
            if subdirid_1 = 0 then
            subdirid_1 := -1 ;
            end if;
         
            while subdirid_1 <> -1 loop
                select subcategoryid,categoryname,subcategoryid,maincategoryid,suborder into subdirid1_1,subdirname_1,superdirid_1,maindirid_1,orderid_1  from DocSubCategory where id = subdirid_1;
                if superdirid_1 = -1 then
                    superdirid_1 := maindirid_1 ;
                    superdirtype_1 := 0 ;        
                else 
                    superdirtype_1 := 1 ;
                end if;
                count_1 := 0 ;        
                select count(categoryid) into count_1 from temp_4 where categoryid = subdirid_1 and categorytype = 1 ;
                if count_1 <= 0 then
                    insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(subdirid_1, 1, superdirid_1, superdirtype_1, subdirname_1, orderid_1);
                    end if;
                    subdirid_1 := subdirid1_1 ;
            end loop;
        end loop;        
    
    elsif operationcode_1 = 3 then
        for secdir_cursor in (select id mainid, categoryname, subcategoryid, secorder from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=userid_1 and usertype=usertype_1 and dirtype=2 and copydoc>0))  
        loop
            secdirid_1 := secdir_cursor.mainid;
            secdirname_1 := secdir_cursor.categoryname;
            subdirid_1 := secdir_cursor.subcategoryid;
            insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1);
            if subdirid_1 is null then
            subdirid_1 := -1 ;
            end if;
            if subdirid_1 = 0 then
            subdirid_1 := -1 ;
            end if;
         
            while subdirid_1 <> -1 loop
                select subcategoryid,categoryname,subcategoryid,maincategoryid,suborder into subdirid1_1,subdirname_1,superdirid_1,maindirid_1,orderid_1  from DocSubCategory where id = subdirid_1;
                if superdirid_1 = -1 then
                    superdirid_1 := maindirid_1 ;
                    superdirtype_1 := 0 ;        
                else 
                    superdirtype_1 := 1 ;
                end if;
                count_1 := 0 ;        
                select count(categoryid) into count_1 from temp_4 where categoryid = subdirid_1 and categorytype = 1 ;
                if count_1 <= 0 then
                    insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(subdirid_1, 1, superdirid_1, superdirtype_1, subdirname_1, orderid_1);
                    end if;
                    subdirid_1 := subdirid1_1 ;
            end loop;
        end loop;    
    end if;

else 
    for secdir_cursor in (select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct dirid mainid from DirAccessControlList where dirtype=2 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1))))    
        loop
            secdirid_1 := secdir_cursor.mainid;
            secdirname_1 := secdir_cursor.categoryname;
            subdirid_1 := secdir_cursor.subcategoryid;
            orderid_1 := secdir_cursor.secorder;
            insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1);
            if subdirid_1 is null then
            subdirid_1 := -1 ;
            end if;
            if subdirid_1 = 0 then
            subdirid_1 := -1 ;
            end if;
         
            while subdirid_1 <> -1 loop
                select subcategoryid,categoryname,subcategoryid,maincategoryid,suborder into subdirid1_1,subdirname_1,superdirid_1,maindirid_1,orderid_1  from DocSubCategory where id = subdirid_1;
                if superdirid_1 = -1 then
                    superdirid_1 := maindirid_1 ;
                    superdirtype_1 := 0 ;        
                else 
                    superdirtype_1 := 1 ;
                end if;
                count_1 := 0 ;        
                select count(categoryid) into count_1 from temp_4 where categoryid = subdirid_1 and categorytype = 1 ;
                if count_1 <= 0 then
                    insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(subdirid_1, 1, superdirid_1, superdirtype_1, subdirname_1, orderid_1);
                    end if;
                    subdirid_1 := subdirid1_1 ;
            end loop;
        end loop;  
end if;


for maindir_cursor in(select id, categoryname, categoryorder from DocMainCategory where id in (select distinct superdirid from temp_4 where superdirtype = 0))
loop
    subdirid_1 := maindir_cursor.id;
    subdirname_1 := maindir_cursor.categoryname;
    orderid_1 := maindir_cursor.categoryorder;
    insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(subdirid_1, 0, -1, -1, subdirname_1, orderid_1);
end loop;
open thecursor for 
select * from temp_4 order by orderid,categoryid ;
end;
/
