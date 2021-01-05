ALTER TABLE CptStockInDetail  modify innumber  number
/
ALTER TABLE CptStockInDetail  modify plannumber  number
/

CREATE OR REPLACE PROCEDURE CptStockInDetail_Insert ( 
    cptstockinid_1 integer  ,
    cpttype_1 integer  ,
    plannumber_1 number,
    innumber_1 number,
    price_1 number ,
	customerid_1		integer  ,
	SelectDate_1		char ,
	capitalspec_1		varchar2  ,
	location_1		varchar2  ,
	invoice_1		varchar2  ,	
    flag	out integer,
    msg   out	varchar2,
    thecursor IN OUT cursor_define.weavercursor )  AS 
begin 
    INSERT INTO CptStockInDetail (
        cptstockinid,
        cpttype,
        plannumber,
        innumber,
        price,
		customerid,
		SelectDate,
		capitalspec,
		location,
		invoice) 
    VALUES (
        cptstockinid_1,
        cpttype_1,
        plannumber_1,
        innumber_1 ,
        price_1,
		customerid_1,
		SelectDate_1,
		capitalspec_1,
		location_1,
		invoice_1); 
    
    open thecursor for 
    select max(id) from CptStockInDetail; 
end;
/

CREATE or REPLACE PROCEDURE CptStockInDetail_Update (
	id_1 integer ,
	innumber_1 number, 
    flag	out integer, 
    msg   out	varchar2, 
    thecursor IN OUT cursor_define.weavercursor )

AS 
begin
update CptStockInDetail set  innumber=innumber_1  where id = id_1;
end;
/