CREATE OR REPLACE PROCEDURE CptCapital_Delete 
(id_1 	integer,
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
AS
isdata_1 integer;
begin
select isdata into isdata_1 from CptCapital where id = id_1;
if (isdata_1 = 1) then 
update CptCapitalAssortment set 
capitalcount = capitalcount-1 where id in (select capitalgroupid from CptCapital where id = id_1 );
end if;  
DELETE CptCapital WHERE ( id=id_1);
open thecursor for select max(id) from CptCapital;
end;
/

CREATE or REPLACE PROCEDURE CptCapital_ForcedDelete (
id_1 integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
AS
isdata_1 integer;
begin
select isdata into isdata_1 from CptCapital where id = id_1;
if (isdata_1 = 1) then
UPDATE CptCapitalAssortment SET capitalcount = capitalcount-1 
WHERE id IN (SELECT capitalgroupid FROM CptCapital WHERE id = id_1) ;
end if; 
DELETE CptCapital WHERE id = id_1 ;
end;
/

update CptCapitalAssortment set capitalcount = (select count(*) from CptCapital t1 where isdata = 1 and CptCapitalAssortment.id = t1.capitalgroupid )
/
