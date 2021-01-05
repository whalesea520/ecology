CREATE OR REPLACE PROCEDURE HrmLocations_Delete 
(id_1 	integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as 
count0 int;
begin
select count(*) into count0  from HrmLocations a join HrmResource b on a.id=b.locationid and a.id=id_1;
if count0>0 then
flag :=2;
msg :='办公地点在使用中';
return;
end if;
DELETE HrmLocations WHERE (id=id_1);
end;
/