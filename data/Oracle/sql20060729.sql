alter table CptStockInDetail add customerid     integer
/
alter table CptStockInDetail add SelectDate	    char(10)
/
alter table CptStockInDetail add capitalspec    varchar2(60)
/
alter table CptStockInDetail add location	    varchar2(100)
/
alter table CptStockInDetail add invoice	varchar2(80)
/
alter table CptCapital add invoice varchar2(80)
/

CREATE OR REPLACE PROCEDURE CptCapital_Duplicate (
capitalid_1 	integer,
customerid_1	integer,
price_1			number,
capitalspec_1	varchar2,
location_1		varchar2,
invoice_1		varchar2,
flag out integer  ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) AS 
maxid integer; 
begin 
    INSERT INTO CptCapital (
    mark,
    name,
    barcode,
    startdate,
    enddate,
    seclevel,
    departmentid,
    costcenterid,
    resourceid,
    crmid,
    sptcount,
    currencyid ,
    capitalcost,
    startprice,
    depreendprice,
    capitalspec,
    capitallevel,
    manufacturer,
    manudate,
    capitaltypeid,
    capitalgroupid,
    unitid,
    capitalnum,
    currentnum,
    replacecapitalid,
    version,
    itemid,
    remark,
    capitalimageid,
    depremethod1,
    depremethod2,
    deprestartdate,
    depreenddate,
    customerid,
    attribute,
    stateid,
    location,
    usedhours,
    datefield1,
    datefield2,
    datefield3,
    datefield4,
    datefield5,
    numberfield1,
    numberfield2,
    numberfield3,
    numberfield4,
    numberfield5,
    textfield1,
    textfield2,
    textfield3,
    textfield4,
    textfield5,
    tinyintfield1,
    tinyintfield2,
    tinyintfield3,
    tinyintfield4,
    tinyintfield5,
    createrid,
    createdate,
    createtime,
    lastmoderid,
    lastmoddate,
    lastmodtime,
    isdata,
    datatype,
    relatewfid,
	invoice) 
    
    select 
    mark,
    name,
    barcode,
    startdate,
    enddate	,
    seclevel,
    departmentid,
    costcenterid,
    resourceid,
    crmid,
    sptcount,
    currencyid ,
    capitalcost,
    price_1,
    depreendprice,
    capitalspec_1,
    capitallevel,
    manufacturer,
    manudate,
    capitaltypeid,
    capitalgroupid,
    unitid,
    capitalnum,
    currentnum,
    replacecapitalid,
    version,
    itemid,
    remark,
    capitalimageid,
    depremethod1,
    depremethod2,
    deprestartdate,
    depreenddate,
    customerid_1,
    attribute,
    stateid,
    location_1,
    usedhours,
    datefield1,
    datefield2,
    datefield3,
    datefield4,
    datefield5,
    numberfield1,
    numberfield2,
    numberfield3,
    numberfield4,
    numberfield5,
    textfield1,
    textfield2,
    textfield3,
    textfield4,
    textfield5,
    tinyintfield1,
    tinyintfield2,
    tinyintfield3,
    tinyintfield4,
    tinyintfield5,
    createrid,
    createdate,
    createtime,
    lastmoderid,
    lastmoddate,
    lastmodtime,
    isdata,
    datatype,
    relatewfid,
	invoice_1 
    from CptCapital 
    where id = capitalid_1; 
    
    select  max(id) INTO maxid  from CptCapital; 
    update CptCapital set capitalnum = 0 where id = maxid; 
    open thecursor for 
        select maxid from dual; 
end;
/

CREATE OR REPLACE PROCEDURE CptCapital_SCountByDataType (
datatype_1 	integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) AS 

begin 
    open thecursor for 

		select mark 
		from CptCapital 
		where id=(select max(id) 
			  	  from CptCapital 
				  where datatype =datatype_1 and isdata='2');
 
end;
/


CREATE OR REPLACE PROCEDURE CptCapital_UpdatePrice (
id_1 	        integer,
price 	        number,
capitalspec_1	varchar2,
customerid_1	integer,
location_1		varchar2,
invoice_1		varchar2,
flag    out     integer ,
msg     out     varchar2,
thecursor IN OUT cursor_define.weavercursor) AS 

begin 
    UPDATE CptCapital 
    SET  startprice=price,
		 capitalspec=capitalspec_1,
		 customerid=customerid_1,
		 location=location_1,
		 invoice=invoice_1 	 
    WHERE ( id	= id_1) ; 
end;
/

CREATE OR REPLACE PROCEDURE CptStockInDetail_Insert ( 
    cptstockinid_1 integer  ,
    cpttype_1 integer  ,
    plannumber_1 integer  ,
    innumber_1 integer  ,
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

CREATE OR REPLACE PROCEDURE CptStockInDetail_SByStockid ( 
cptstockinid_1 integer , 
flag	out integer, 
msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor )  AS 

begin 
    open thecursor for 
        select * 
        from CptStockInDetail 
        where cptstockinid = cptstockinid_1
        order by id; 
end;
/
CREATE OR REPLACE PROCEDURE CRM_CustomerInfo_InsertByCpt (
name_1 	  		  varchar2, 
manager_1 		  integer, 
CreditAmount_1 	  number,
CreditTime_1 	  integer,
flag out  		  integer ,
msg out   		  varchar2,
thecursor IN OUT cursor_define.weavercursor ) AS 

begin  
	INSERT INTO CRM_CustomerInfo (
	name, 
	engname,
	manager,
	CreditAmount,
	CreditTime,
	status,	 
	deleted,
	type) 
VALUES ( 
	name_1, 
	name_1, 
	manager_1,
	CreditAmount_1,
	CreditTime_1,
	1,	 
	0,
	2);

open thecursor for 
	 SELECT max(id) as id from CRM_CustomerInfo;
	 
end;
/


