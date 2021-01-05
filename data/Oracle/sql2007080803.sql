alter table HrmLocations add showOrder number(15,2) null
/
update HrmLocations set showOrder=0
/
update SystemLogItem set lableId=15712,itemDesc='办公地点' where itemId=23
/

CREATE OR REPLACE PROCEDURE HrmLocations_Insert (
locationname_1 	varchar2, 
locationdesc_2 	varchar2, 
address1_3 	varchar2,
address2_4 	varchar2,
locationcity_5 	varchar2,
postcode_6 	varchar2,
countryid_7 	integer,
telephone_8 	varchar2,
fax_9 	varchar2,
showOrder_10    number,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin 
  insert into HrmLocations (
  locationname,
  locationdesc,
  address1,
  address2,
  locationcity,
  postcode,
  countryid,
  telephone,
  fax,
  showOrder)
  VALUES (
  locationname_1,
  locationdesc_2,
  address1_3,
  address2_4,
  locationcity_5,
  postcode_6,
  countryid_7,
  telephone_8,
  fax_9,
  showOrder_10);
  open thecursor for select max(id) from HrmLocations;
end;
/

CREATE OR REPLACE PROCEDURE HrmLocations_Update (
id_1 	integer,
locationname_2 	varchar2,
locationdesc_3 	varchar2,
address1_4 	varchar2,
address2_5 	varchar2,
locationcity_6 	varchar2,
postcode_7 	varchar2,
countryid_8 	integer,
telephone_9 	varchar2,
fax_10 	varchar2,
showOrder_11    number,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
begin
update HrmLocations
SET  locationname=locationname_2,
locationdesc=locationdesc_3,
address1=address1_4,
address2=address2_5,
locationcity=locationcity_6,
postcode=postcode_7,
countryid=countryid_8,
telephone=telephone_9,
fax=fax_10,
showOrder=showOrder_11
WHERE ( id=id_1);
end;
/