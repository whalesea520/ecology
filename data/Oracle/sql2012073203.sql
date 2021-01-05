CREATE OR REPLACE TYPE mytable AS TABLE OF varchar2(100)  
/  
CREATE OR REPLACE FUNCTION SplitStr  
   (src VARCHAR2, delimiter varchar2)  
  RETURN mytable IS  
  psrc VARCHAR2(500);  
  a mytable := mytable();  
  i NUMBER := 1;  
  j NUMBER := 1;  
BEGIN  
  psrc := RTrim(LTrim(src, delimiter), delimiter);  
  LOOP  
    i := InStr(psrc, delimiter, j);   
    IF i>0 THEN  
      a.extend;  
      a(a.Count) := Trim(SubStr(psrc, j, i-j));  
      j := i+1;  
    END IF;  
    EXIT WHEN i=0;  
  END LOOP;  
  IF j < Length(psrc) THEN  
    a.extend;  
    a(a.Count) := Trim(SubStr(psrc, j, Length(psrc)+1-j));  
  END IF;  
  RETURN a;  
END;
/
CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermission
(
dirid_1 integer,
dirtype_1 integer,
userid_1 integer,
usertype_1 integer,
seclevel_1 integer, 
operationcode_1 integer, 
departmentid_1 integer,
subcompanyid_1 integer,
roleid_1 varchar2,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
AS
count_1 integer;
result integer;
count_num integer;
begin
result := 0;
if usertype_1 = 0 then

	select count (sourceid) into count_num  from DirAccessControlDetail where sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and content in (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or(type=5 and content=userid_1) or(type=6 and content=subcompanyid_1 and seclevel<=seclevel_1));
        if(count_num >0) then
               count_1 := 1 ;
        else count_1 := 0 ;
        end if;    
else 
    select count(mainid) into count_1  from DirAccessControlList where dirid=dirid_1 and dirtype=dirtype_1 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1));
end if;
if (count_1 > 0)  then
     result := 1 ;
end if;
open thecursor for
select result result from dual;
end;
/
CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermissionEx1 ( 
 dirid_1 integer,
 dirtype_1 integer,
 userid_1 integer, 
 usertype_1 integer, 
 seclevel_1 integer,
 operationcode_1 integer,
 departmentid_1 integer,
 subcompanyid_1 integer,
 roleid_1 varchar2,
 haspermission_1 in out integer  
 )  AS  count_1 integer; result integer;  
 begin 
 result := 0;  
 if usertype_1 = 0 then 	
	  select count(sourceid) into count_1  from DirAccessControlDetail where sharelevel=operationcode_1 and sourceid=dirid_1 and sourcetype=dirtype_1  and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and content in (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or	(type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1));	
else 
	select  count(mainid) into  count_1 from DirAccessControlList where dirid=dirid_1 and dirtype=dirtype_1 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1)); 
 end if;  
 if  count_1 is not null and count_1>0 then result := 1; end if; 
 haspermission_1 := result; 
end;
/
CREATE or REPLACE procedure Doc_GetPermittedCategory
(
userid_1 integer,
usertype_1 integer, 
seclevel_1 integer,
operationcode_1 integer,
departmentid_1 integer,
subcompanyid_1 integer,
roleid_1 varchar2,  
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
        for secdir_cursor in(select id mainid, categoryname, subcategoryid, secorder from DocSecCategory where id in (select distinct sourceid from DirAccessControlDetail where sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and content in (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1))))        
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
CREATE OR REPLACE PROCEDURE Doc_MainCategory_FindByUser 
(
userid_1 integer, 
usertype_1 integer,
seclevel_1 integer,
operationcode_1 integer, 
departmentid_1 integer,
subcompanyid_1 integer,
roleid_1 varchar2,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as 
begin
if operationcode_1 = 0 then
open thecursor for
    select  id   mainid from DocMainCategory where id in (
        select distinct maincategoryid from DocSubCategory where id in (
            select distinct subcategoryid from DocSecCategory where id in (
		   select distinct  sourceid from DirAccessControlDetail where sourcetype=2 and  sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and content in (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1))
                )
            )
        )
    order by categoryorder;
else  
open thecursor for
    select  id   mainid from DocMainCategory where id in (select distinct  sourceid from DirAccessControlDetail where sourcetype=0 and  sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and content in (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or	(type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1))
        )
    order by categoryorder;
end if;
end;
/
CREATE OR REPLACE PROCEDURE Doc_SecCategory_FindByUser 
(
userid_1 integer, 
usertype_1 integer,
seclevel_1 integer,
operationcode_1 integer, 
departmentid_1 integer,
subcompanyid_1 integer,
roleid_1 integer,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as 
begin
open thecursor for
    select distinct id mainid from DocSecCategory where id in (select distinct  sourceid from DirAccessControlDetail where sourcetype=2 and  sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and content in (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1)));
end;
/
CREATE OR REPLACE PROCEDURE Doc_SubCategory_FindByUser
(
userid_1 integer, 
usertype_1 integer,
seclevel_1 integer,
operationcode_1 integer, 
departmentid_1 integer,
subcompanyid_1 integer,
roleid_1 integer,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as 
begin
if operationcode_1 = 0 then
open thecursor for
    select distinct subcategoryid mainid from DocSecCategory where id in (select distinct  sourceid from DirAccessControlDetail where sourcetype=2 and  sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and content in (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1)));
else
open thecursor for
    select distinct  sourceid mainid from DirAccessControlDetail where sourcetype=1 and  sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and content in (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1));	
end if;
end;
/