alter table T_OutReport add modulefilename  varchar2(100)  
/

CREATE OR REPLACE PROCEDURE T_OutReport_Insert(
         outrepname_1 	varchar2,
	 outreprow_2 	integer,
	 outrepcolumn_3 	integer,
	 outrepdesc_4 	varchar2,
         modulefilename_5  varchar2,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
INSERT INTO T_OutReport(outrepname,outreprow,outrepcolumn,outrepdesc,modulefilename) 
VALUES(outrepname_1,outreprow_2,outrepcolumn_3,outrepdesc_4,modulefilename_5 );
end;
/

CREATE OR REPLACE PROCEDURE T_OutReport_Update(
         outrepid_1 	integer,
	 outrepname_2 	varchar2,
	 outrepdesc_3 	varchar2,
         modulefilename_5  varchar2,
	 flag out integer, 
	 msg out varchar2,
         thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
UPDATE T_OutReport 
SET  outrepname	 = outrepname_2,
     outrepdesc	 = outrepdesc_3,
     modulefilename = modulefilename_5 
WHERE(outrepid = outrepid_1);
/

create table outrepmodule (
id  integer primary key not null,     
outrepid   integer,     
modulename varchar2(100),     
moduledesc varchar2(200),    
userid     integer,   
usertype   integer   
)
/
create sequence outrepmodule_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER outrepmodule_Id_Trigger
       before insert on outrepmodule
	     for each row
	     begin
	     select outrepmodule_Id.nextval into :new.id from dual;
	     end;
/

create table modulecondition (
id integer primary key not null,     
moduleid       integer , 
conditionid    integer,  
conditionname   varchar2(60),
isuserdefine     integer,
conditionvalue varchar2(255) 
)
/

create sequence modulecondition_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER modulecondition_Id_Trigger
       before insert on modulecondition
	     for each row
	     begin
	     select modulecondition_Id.nextval into :new.id from dual;
	     end;

/

CREATE OR REPLACE PROCEDURE T_outrepmodule_Insert(
	outrepid_1 integer,
	modulename_2 varchar2,
	moduledesc_3 varchar2,
	userid_4 integer,
	usertype_5 integer,
	flag out integer, 
	msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
INSERT INTO outrepmodule( 
	 outrepid,
	 modulename,
	 moduledesc,
	 userid,
	 usertype) 
VALUES(
	 outrepid_1,
	 modulename_2,
	 moduledesc_3,
	 userid_4,
	 usertype_5); 
open thecursor for
select max(id) from outrepmodule;
end;
/

CREATE OR REPLACE PROCEDURE T_modulecondition_Insert(
	moduleid_1       integer ,
	conditionid_2    integer, 
	conditionname_3   varchar2,
	isuserdefine_4     integer,
	conditionvalue_5 varchar2,
	flag out integer, 
	msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
INSERT INTO modulecondition(
	moduleid,
	conditionid,
	conditionname ,
	isuserdefine,
	conditionvalue)
VALUES(
	moduleid_1,
	conditionid_2,
	conditionname_3 ,
	isuserdefine_4,
	conditionvalue_5);
end;
/

CREATE OR REPLACE PROCEDURE T_outrepmodule_Update(
     id_1 	integer,
     modulename_2 	varchar2,
     moduledesc_3 	varchar2,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
UPDATE outrepmodule 
SET  modulename	= modulename_2,moduledesc = moduledesc_3 WHERE (id = id_1);
end;
/

CREATE PROCEDURE T_outrepmodule_Delete(
     id_1  integer,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
DELETE outrepmodule WHERE(id = id_1);
end;
/

CREATE OR REPLACE PROCEDURE T_modulecondition_Delete(
     id_1 integer,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
DELETE modulecondition WHERE(moduleid = id_1);
end;
/

create table T_Statitem (
statitemid  integer primary key not null,     
statitemname     varchar2(100),                           
statitemexpress       varchar2(200) ,                     
statitemdesc     varchar2(100)                            
)
/

create sequence statitem_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER statitem_Id_Trigger
       before insert on T_Statitem
	     for each row
	     begin
	     select statitem_Id.nextval into :new.statitemid from dual;
	     end;
/

CREATE OR REPLACE PROCEDURE T_Statitem_SelectAll(
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
open thecursor for
select * from  T_Statitem;
end;
/

CREATE OR REPLACE PROCEDURE T_Statitem_Select(
     statitemid_1 integer,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
open thecursor for
select * from  T_Statitem WHERE(statitemid = statitemid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_Statitem_Insert(
     statitemname_1 	varchar2,
     statitemexpress_2 	varchar2,
     statitemdesc_3 	varchar2,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
INSERT INTO T_Statitem(statitemname,statitemexpress,statitemdesc) 
VALUES(statitemname_1,statitemexpress_2,statitemdesc_3);
end;
/

CREATE OR REPLACE PROCEDURE T_Statitem_Update(
     statitemid_1 	integer,
     statitemname_2 	varchar2,
     statitemexpress_3 	varchar2,
     statitemdesc_4 	varchar2,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
)
AS
begin
UPDATE T_Statitem 
SET  statitemname = statitemname_2,
     statitemexpress = statitemexpress_3,
     statitemdesc = statitemdesc_4 
WHERE(statitemid = statitemid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_Statitem_Delete(
     statitemid_1 integer,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
DELETE T_Statitem WHERE(statitemid = statitemid_1);
end;
/

alter table T_OutReport add outreptype char(1)
/
alter table T_OutReport add outrepcategory char(1) default '0' 
/
update T_OutReport set outrepcategory = '0' 
/

CREATE OR REPLACE PROCEDURE T_OutReport_SelectAll(
    outrepcategory_1 char,
    flag out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
open thecursor for
select * from T_OutReport where outrepcategory = outrepcategory_1;
end;
/

CREATE OR REPLACE PROCEDURE T_OutReport_Insert(
     outrepname_1 	varchar2,
     outreprow_2 	integer,
     outrepcolumn_3 	integer,
     outrepdesc_4 	varchar2,
     modulefilename_5   varchar2,
     outreptype_6       char,
     outrepcategory_7   char,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_OutReport(
         outrepname,
	 outreprow,
	 outrepcolumn,
	 outrepdesc,
         modulefilename,
         outreptype,
         outrepcategory) 
 
VALUES(  
         outrepname_1,
	 outreprow_2,
	 outrepcolumn_3,
	 outrepdesc_4,
         modulefilename_5,
         outreptype_6,
         outrepcategory_7);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReport_Update(
     outrepid_1 	integer,
     outrepname_2 	varchar2,
     outrepdesc_3 	varchar2,
     modulefilename_5  varchar2,
     outreptype_6 char,
     outrepcategory_7 char,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
UPDATE T_OutReport 
SET  outrepname	 = outrepname_2,
     outrepdesc	 = outrepdesc_3,
     modulefilename = modulefilename_5 ,
     outreptype = outreptype_6 ,
     outrepcategory = outrepcategory_7 
WHERE(outrepid = outrepid_1);
end;
/

create table T_ReportStatitemTable (
itemtableid  integer primary key not null,   
outrepid     integer ,
itemtable   varchar2(60),
itemtablealter  varchar2(20) 
)
/

create sequence reportStatitemTable_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER reportStatitemTable_Id_Trigger
       before insert on T_ReportStatitemTable
	     for each row
	     begin
	     select reportStatitemTable_Id.nextval into :new.itemtableid from dual;
	     end;
/

CREATE OR REPLACE PROCEDURE T_ReportStatitemTable_SById(
        outrepid_1 integer ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
open thecursor for
select * from T_ReportStatitemTable where outrepid = outrepid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_ReportStatitemTable_Insert(
        outrepid_1 	integer,
	itemtable_2     varchar2,
	itemtablealter_3  varchar2,
	flag out integer, 
	msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_ReportStatitemTable( 
         outrepid,
	 itemtable,
	 itemtablealter) 
VALUES(
         outrepid_1,
	 itemtable_2,
	 itemtablealter_3);
end;
/

CREATE PROCEDURE T_ReportStatitemTable_Delete(
        outrepid_1 	integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
Delete T_ReportStatitemTable where outrepid = outrepid_1;
end;
/

create table T_OutReportStatitem (
outrepitemid  integer primary key not null,    
outrepid     integer ,
statitemid   integer ,
dsporder  integer 
)
/

create sequence outReportStatitem_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER outReportStatitem_Id_Trigger
       before insert on T_OutReportStatitem
	     for each row
	     begin
	     select outReportStatitem_Id.nextval into :new.outrepitemid from dual;
	     end;
/

CREATE OR REPLACE PROCEDURE T_OutReportStatitem_SById(
        outrepid_1 integer ,
	flag out integer, 
	msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
open thecursor for
select * from T_OutReportStatitem where outrepid = outrepid_1 order by dsporder;
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportStatitem_Insert(
        outrepid_1 	integer,
	statitemid_2    integer,
	flag out integer, 
	msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor
) 
AS 
maxdsporder integer;
begin
select max(dsporder) into maxdsporder from T_OutReportStatitem where outrepid = outrepid_1; 
if maxdsporder is null or maxdsporder = 0 then
    maxdsporder := 1; 
else 
    maxdsporder := maxdsporder + 1;
end if;
INSERT INTO T_OutReportStatitem(outrepid,statitemid,dsporder) 
VALUES(outrepid_1,statitemid_2,maxdsporder);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportStatitem_Delete(
        outrepitemid_1 	integer,
	flag out integer, 
	msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor
) 
AS 
thedsporder integer;
theoutrepid integer; 
begin
select dsporder into thedsporder from T_OutReportStatitem where outrepitemid = outrepitemid_1;
select outrepid into theoutrepid from T_OutReportStatitem where outrepitemid = outrepitemid_1;

update T_OutReportStatitem set dsporder = dsporder-1 where outrepid = theoutrepid and dsporder > thedsporder; 

Delete T_OutReportStatitem where outrepitemid = outrepitemid_1;
end;
/


CREATE OR REPLACE PROCEDURE T_OutReportStatitem_Uorder(
        outrepitemid_1  integer,
        upordown  	integer, /* upordown 为1的时候向上走，upordown 为2的时候向下走 */
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
thedsporder integer;
theoutrepid integer; 
begin 
select dsporder into thedsporder from T_OutReportStatitem where outrepitemid = outrepitemid_1;
select outrepid into thedsporder from T_OutReportStatitem where outrepitemid = outrepitemid_1;

if upordown = 1 then
    update T_OutReportStatitem set dsporder = dsporder+1 where outrepid = theoutrepid and dsporder = thedsporder-1; 
    update T_OutReportStatitem set dsporder = dsporder-1 where outrepitemid = outrepitemid_1;
else 
    update T_OutReportStatitem set dsporder = dsporder-1 where outrepid = theoutrepid and dsporder = thedsporder+1; 
    update T_OutReportStatitem set dsporder = dsporder+1 where outrepitemid = outrepitemid_1;
end if;
end;
/

CREATE OR REPLACE PROCEDURE T_OutReport_Delete(
        outrepid_1 integer ,
	flag out integer, 
	msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
DELETE T_OutReport WHERE(outrepid = outrepid_1);
DELETE T_OutReportCondition WHERE(outrepid = outrepid_1);
DELETE T_OutReportShare WHERE(outrepid = outrepid_1);
DELETE T_OutReportItem WHERE(outrepid	= outrepid_1);
DELETE T_ReportStatitemTable WHERE(outrepid = outrepid_1);
DELETE T_OutReportStatitem WHERE(outrepid = outrepid_1);
end;
/

create table T_ReportStatSqlValue(
outrepid     integer ,
sqlfromvalue   varchar2(200),
sqlwherevalue  varchar2(4000) 
)
/

alter table T_InputReport add modulefilename varchar2(100)
/
alter table T_InputReport add helpdocid int  
/

CREATE OR REPLACE PROCEDURE T_InputReport_Insert(
         inprepname_1 	varchar2,
	 inpreptablename_2 	varchar2,
	 inprepbugtablename_3 	varchar2,
	 inprepfrequence_4 	char,
	 inprepbudget_5 	char,
	 inprepforecast_6	char,
         startdate_7	char,
         enddate_8	char,
         modulefilename_9	varchar2,
         helpdocid_10	integer,
	 flag out integer, 
	 msg out varchar2,
         thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
INSERT INTO T_InputReport(
         inprepname,
	 inpreptablename,
	 inprepbugtablename,
	 inprepfrequence,
	 inprepbudget,
	 inprepforecast,
         startdate,
         enddate,
         modulefilename,
         helpdocid) 
VALUES( 
         inprepname_1,
	 inpreptablename_2,
	 inprepbugtablename_3,
	 inprepfrequence_4,
	 inprepbudget_5,
	 inprepforecast_6,
         startdate_7,
         enddate_8,
         modulefilename_9,
         helpdocid_10);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReport_Update(
         inprepid_1 	integer,
	 inprepname_2 	varchar2,
	 inpreptablename_3 	varchar2,
	 inprepbugtablename_4 	varchar2,
	 inprepfrequence_5 	char,
	 inprepbudget_6 	char,
	 inprepforecast_7	char,
	 startdate_8	char,
	 enddate_9	char,
	 modulefilename_10	varchar2,
	 helpdocid_11	integer,
	 flag out integer, 
	 msg out varchar2,
         thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
UPDATE T_InputReport 
SET  inprepname	 = inprepname_2,
     inpreptablename = inpreptablename_3,
     inprepbugtablename	= inprepbugtablename_4,
     inprepfrequence = inprepfrequence_5,
     inprepbudget  = inprepbudget_6 ,
     inprepforecast = inprepforecast_7 , 
     startdate	= startdate_8 , 
     enddate  = enddate_9 ,
     modulefilename = modulefilename_10 ,
     helpdocid = helpdocid_11 
WHERE(inprepid = inprepid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReport_Copy(
  outrepid_1 	integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
newoutrepid_1 integer;
theoutrepcategory_1 integer;
itemid_1 integer;
newitemid_1 integer;
moduleid_1 integer;
newmoduleid_1 integer;
begin
select outrepcategory into theoutrepcategory_1 from T_OutReport where outrepid = outrepid_1; 

INSERT INTO T_OutReport(outrepname,outreprow,outrepcolumn,outrepdesc,modulefilename,outreptype,outrepcategory )
(select concat('复制_',outrepname),outreprow,outrepcolumn,outrepdesc,modulefilename,outreptype,outrepcategory from T_OutReport where outrepid = outrepid_1);

select max(outrepid) into newoutrepid_1 from T_OutReport; 

INSERT INTO T_OutReportCondition(outrepid,conditionid)
(select newoutrepid_1,conditionid from T_OutReportCondition where outrepid = outrepid_1); 

INSERT INTO T_OutReportShare(outrepid,userid,usertype)
(select newoutrepid_1,userid,usertype from T_OutReportShare where outrepid = outrepid_1); 

for module_cursor in(select id from outrepmodule where outrepid = outrepid_1)
loop
    moduleid_1 := module_cursor.id;
    INSERT INTO outrepmodule(outrepid,modulename,moduledesc,userid,usertype ) 
    (select newoutrepid_1,modulename,moduledesc,userid,usertype from outrepmodule where id = moduleid_1); 
    select max(id) into newmoduleid_1 from outrepmodule; 
    INSERT INTO modulecondition(moduleid,conditionid,conditionname,isuserdefine,conditionvalue)
    (select newmoduleid_1,conditionid,conditionname,isuserdefine,conditionvalue from modulecondition where moduleid = moduleid_1); 
end loop;

if theoutrepcategory_1 = 0 then
    INSERT INTO T_OutReportItemRow(outrepid,itemrow)
    (select newoutrepid_1,itemrow from T_OutReportItemRow where outrepid = outrepid_1); 

    for itemid_cursor in(select itemid from T_OutReportItem where outrepid = outrepid_1)
    loop 
        itemid_1 := itemid_cursor.itemid;
        INSERT INTO T_OutReportItem(outrepid,itemrow,itemcolumn,itemtype,picstat,itemexpress,itemtable,
        itemcondition,itemdesc,itemexpresstype,picstatbudget,picstatlast,itemmodtype)
        (select newoutrepid_1,itemrow,itemcolumn,itemtype,picstat,itemexpress,itemtable,
        itemcondition,itemdesc,itemexpresstype,picstatbudget,picstatlast,itemmodtype 
        from T_OutReportItem where itemid = itemid_1); 

        select max(itemid) into newitemid_1 from T_OutReportItem; 
        
        INSERT INTO T_OutReportItemTable(itemid,itemtable,itemtablealter)
        (select newitemid_1,itemtable,itemtablealter from T_OutReportItemTable where itemid = itemid_1); 

        INSERT INTO T_OutReportItemCondition(itemid,conditionid,conditionvalue)
        (select newitemid_1,conditionid,conditionvalue from T_OutReportItemCondition where itemid = itemid_1); 

        INSERT INTO T_OutReportItemCoordinate(itemid,coordinatename,coordinatevalue)
        (select newitemid_1,coordinatename,coordinatevalue from T_OutReportItemCoordinate where itemid = itemid_1); 
     end loop;
else
    INSERT INTO T_OutReportStatitem(outrepid,statitemid,dsporder)
    (select newoutrepid_1,statitemid,dsporder from T_OutReportStatitem where outrepid = outrepid_1); 
end if;
end;
/

alter table T_InputReportItemtype add dsporder integer 
/

create OR REPLACE PROCEDURE T_IRItemtype_SelectByInprepid(
        inprepid_1  integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
open thecursor for
select * from T_InputReportItemtype where inprepid = inprepid_1 order by dsporder;
end;
/

create OR REPLACE PROCEDURE T_InputReportItemtype_Insert(
         inprepid_1 	integer,
	 itemtypename_2 	varchar2,
	 itemtypedesc_3 	varchar2,
         dsporder_4 	integer,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_InputReportItemtype(inprepid,itemtypename,itemtypedesc,dsporder)  
  VALUES(inprepid_1,itemtypename_2,itemtypedesc_3,dsporder_4);
end;
/

create OR REPLACE PROCEDURE T_InputReportItemtype_Update(
         itemtypeid_1 	integer,
	 itemtypename_2 	varchar2,
	 itemtypedesc_3 	varchar2,
         dsporder_4 	integer,
	 flag out integer, 
	 msg out varchar2,
         thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
UPDATE T_InputReportItemtype 
SET      itemtypename = itemtypename_2,
	 itemtypedesc = itemtypedesc_3 ,
         dsporder = dsporder_4 
WHERE(itemtypeid = itemtypeid_1);
end;
/

alter table T_OutReport add enmodulefilename  varchar2(100)   
/
alter table T_OutReportCondition add conditioncnname  varchar2(100)   
/
alter table T_OutReportCondition add conditionenname  varchar2(100)   
/

create OR REPLACE PROCEDURE T_OutReport_Insert(
         outrepname_1 	varchar2,
	 outreprow_2 	integer,
	 outrepcolumn_3 integer,
	 outrepdesc_4 	varchar2 ,
	 modulefilename_5  varchar2 ,
	 outreptype_6 char ,
	 outrepcategory_7 char,
	 enmodulefilename_8  varchar2,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_OutReport 
	 (outrepname,
	 outreprow,
	 outrepcolumn,
	 outrepdesc,
         modulefilename,
         outreptype,
         outrepcategory,
         enmodulefilename) 
VALUES (
         outrepname_1,
	 outreprow_2,
	 outrepcolumn_3,
	 outrepdesc_4,
         modulefilename_5,
         outreptype_6,
         outrepcategory_7,
         enmodulefilename_8);
end;
/

create OR REPLACE PROCEDURE T_OutReport_Update(
         outrepid_1 	integer,
	 outrepname_2 	varchar2,
	 outrepdesc_3 	varchar2 ,
	 modulefilename_5  varchar2,
	 outreptype_6 char,
	 outrepcategory_7 char,
	 enmodulefilename_8  varchar2,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
UPDATE T_OutReport 
SET  outrepname	 = outrepname_2,
     outrepdesc	 = outrepdesc_3,
     modulefilename = modulefilename_5 ,
     outreptype = outreptype_6 ,
     outrepcategory = outrepcategory_7 ,
     enmodulefilename = enmodulefilename_8 
WHERE(outrepid = outrepid_1);
end;
/
create OR REPLACE PROCEDURE T_OutReportCondition_Insert(
         outrepid_1 	integer,
	 conditionid_2 	integer ,
	 conditioncnname_3 	varchar2,
	 conditionenname_4 	varchar2,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_OutReportCondition(outrepid,conditionid,conditioncnname,conditionenname) 
VALUES(outrepid_1,conditionid_2,conditioncnname_3,conditionenname_4);
end;
/

alter table T_InputReportItem add (itemgongsi varchar(4000),inputablefact char(1),inputablebudg char(1),inputablefore char(1))      
/
update T_InputReportItem set inputablefact = '1' , inputablebudg = '1' , inputablefore = '1' 
/
update T_InputReportItem set inputablefact = '0' where itemfieldtype = '5'
/
update T_InputReportItem set itemgongsi = itemexcelsheet , itemexcelsheet = '' where itemfieldtype = '5'
/

create OR REPLACE PROCEDURE T_InputReportItem_Insert(
         inprepid_1 	integer,
	 itemdspname_2 	varchar2,
	 itemfieldname_3 	varchar2,
	 itemfieldtype_4 	char,
	 itemfieldscale_5 	integer,
	 itemtypeid_6 	integer,
	 itemexcelsheet_7 	varchar2,
	 itemexcelrow_8 	integer,
	 itemexcelcolumn_9 	integer ,
	 itemfieldunit_10   varchar2,
	 dsporder_11        integer ,
	 itemgongsi_12 	varchar2,
	 inputablefact_13 	char,
	 inputablebudg_14 	char,
	 inputablefore_15 	char,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_InputReportItem 
	 (inprepid,
	 itemdspname,
	 itemfieldname,
	 itemfieldtype,
	 itemfieldscale,
	 itemtypeid,
	 itemexcelsheet,
	 itemexcelrow,
	 itemexcelcolumn,
	 itemfieldunit,
	 dsporder,
	 itemgongsi,
	 inputablefact,
	 inputablebudg,
	 inputablefore) 
VALUES 
	(inprepid_1,
	 itemdspname_2,
	 itemfieldname_3,
	 itemfieldtype_4,
	 itemfieldscale_5,
	 itemtypeid_6,
	 itemexcelsheet_7,
	 itemexcelrow_8,
	 itemexcelcolumn_9,
	 itemfieldunit_10,
	 dsporder_11,
	 itemgongsi_12,
         inputablefact_13,
         inputablebudg_14,
         inputablefore_15);
end;
/

create OR REPLACE PROCEDURE T_InputReportItem_Update(
         itemid_1 	integer,
	 itemdspname_2 	varchar2,
	 itemfieldname_3 	varchar2,
	 itemfieldtype_4 	char,
	 itemfieldscale_5 	integer,
	 itemtypeid_6 	integer,
	 itemexcelsheet_7 	varchar2,
	 itemexcelrow_8 	integer,
	 itemexcelcolumn_9 	integer ,
	 itemfieldunit_10   varchar2 ,
	 dsporder_11        integer ,
	 itemgongsi_12 	varchar2,
         inputablefact_13 	char,
	 inputablebudg_14 	char,
	 inputablefore_15 	char,
	 flag out integer, 
	 msg out varchar2,
         thecursor IN OUT cursor_define.weavercursor
	 ) 
AS 
begin
UPDATE T_InputReportItem 
SET      itemdspname	 = itemdspname_2,
	 itemfieldname	 = itemfieldname_3,
	 itemfieldtype	 = itemfieldtype_4,
	 itemfieldscale	 = itemfieldscale_5,
	 itemtypeid	 = itemtypeid_6,
	 itemexcelsheet	 = itemexcelsheet_7,
	 itemexcelrow	 = itemexcelrow_8,
	 itemexcelcolumn = itemexcelcolumn_9 ,
	 itemfieldunit = itemfieldunit_10 ,
	 dsporder = dsporder_11 ,
         itemgongsi = itemgongsi_12 ,
         inputablefact = inputablefact_13 ,
         inputablebudg = inputablebudg_14 ,
         inputablefore = inputablefore_15 
WHERE(itemid = itemid_1);
end;
/

create OR REPLACE PROCEDURE T_IRItem_SelectByInprepid(
        inprepid_1  integer ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
open thecursor for 
select * from T_InputReportItem where inprepid = inprepid_1 order by dsporder;
end;
/

update T_Condition set conditionname = '填报修正' , conditiondesc = '填报修正' where conditionitemfieldname = 'modify' 
/
insert into T_Condition(conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('月修正','月修正','monthmodify',null,'1')
/
insert into T_Condition(conditionname,conditiondesc,conditionitemfieldname,conditiontype,issystemdef) values('年修正','年修正','yearmodify',null,'1')
/

create table T_InputReportCrmModer (                
inprepcontacterid  integer primary key not null,      
inprepcrmid     integer,
contacterid        integer 
)
/

create sequence inputReportCrmModer_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER inputReportCrmModer_Id_Trigger
	before insert on T_InputReportCrmModer
	for each row
	begin
	select inputReportCrmModer_Id.nextval into :new.inprepcontacterid from dual;
	end;
/

alter table T_OutReportItem add firstaltertablename varchar2(10)
/
delete T_ReportStatSqlValue
/

create OR REPLACE PROCEDURE T_OutReportStatitem_Uorder(
        outrepitemid_1 	integer,
        upordown  	integer, 
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
thedsporder integer;
theoutrepid integer;
begin 
select thedsporder into dsporder from T_OutReportStatitem where outrepitemid = outrepitemid_1;
select theoutrepid into outrepid from T_OutReportStatitem where outrepitemid = outrepitemid_1;

if upordown = 1 then
    update T_OutReportStatitem set dsporder = dsporder+1 where outrepid = theoutrepid and dsporder = thedsporder-1; 
    update T_OutReportStatitem set dsporder = dsporder-1 where outrepitemid = outrepitemid_1;
else 
    update T_OutReportStatitem set dsporder = dsporder-1 where outrepid = theoutrepid and dsporder = thedsporder+1;
    update T_OutReportStatitem set dsporder = dsporder+1 where outrepitemid = outrepitemid_1;
end if;
end;
/

alter table T_OutReportStatitem 
add (needthismonth char(1) , 
needthisyear char(1) , 
needlastmonth char(1) , 
needlastyear char(1))
/

alter table T_OutReport add outrepenname  varchar2(100)   
/

create OR REPLACE PROCEDURE T_OutReport_Insert(
     outrepname_1 	varchar2,
     outreprow_2 	integer,
     outrepcolumn_3 	integer,
     outrepdesc_4 	varchar2,
     modulefilename_5  varchar2,
     outreptype_6 char,
     outrepcategory_7 char,
     enmodulefilename_8  varchar2,
     outrepenname_9  varchar2,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_OutReport(
     outrepname,
     outreprow,
     outrepcolumn,
     outrepdesc,
     modulefilename,
     outreptype,
     outrepcategory,
     enmodulefilename,
     outrepenname) 
VALUES(
     outrepname_1,
     outreprow_2,
     outrepcolumn_3,
     outrepdesc_4,
     modulefilename_5,
     outreptype_6,
     outrepcategory_7,
     enmodulefilename_8,
     outrepenname_9 );
end;
/

create OR REPLACE PROCEDURE T_OutReport_Update(
     outrepid_1 	integer,
     outrepname_2 	varchar2,
     outrepdesc_3 	varchar2,
     modulefilename_5  varchar2,
     outreptype_6 char,
     outrepcategory_7 char,
     enmodulefilename_8  varchar2,
     outrepenname_9  varchar2,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
UPDATE T_OutReport 
SET  outrepname	 = outrepname_2,
     outrepdesc	 = outrepdesc_3,
     modulefilename = modulefilename_5 ,
     outreptype = outreptype_6 ,
     outrepcategory = outrepcategory_7 ,
     enmodulefilename = enmodulefilename_8 ,
     outrepenname = outrepenname_9 
WHERE(outrepid = outrepid_1);
end;
/

alter table outrepmodule add moduleenname  varchar2(100)   
/

create OR REPLACE PROCEDURE T_outrepmodule_Insert(
	outrepid_1 integer,
	modulename_2 varchar2,
	moduledesc_3 varchar2,
	userid_4 integer,
	usertype_5 integer,
	moduleenname_6 varchar2,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO outrepmodule(
	 outrepid,
	 modulename,
	 moduledesc,
	 userid,
	 usertype,
	 moduleenname) 
VALUES (
	 outrepid_1,
	 modulename_2,
	 moduledesc_3,
	 userid_4,
	 usertype_5,
	 moduleenname_6);
open thecursor for
select max(id) from outrepmodule;
end;
/

create OR REPLACE PROCEDURE T_outrepmodule_Update(
     id_1 	integer,
     modulename_2 	varchar2,
     moduledesc_3 	varchar2,
     moduleenname_4    varchar2,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
UPDATE outrepmodule 
SET  modulename	 = modulename_2,
     moduledesc	 = moduledesc_3,
     moduleenname = moduleenname_4 
WHERE(id = id_1);
end;
/

alter table T_ConditionDetail add conditionendsp  varchar2(100)   
/

create OR REPLACE PROCEDURE T_ConditionDetail_Insert(
         conditionid_1 	integer,
	 conditiondsp_2 	varchar2,
	 conditionvalue_3 	varchar2,
         conditionendsp_4 	varchar2,
	 flag out integer, 
	 msg out varchar2,
         thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_ConditionDetail(conditionid,conditiondsp,conditionvalue,conditionendsp) 
 VALUES(conditionid_1,conditiondsp_2,conditionvalue_3,conditionendsp_4);
end;
/

delete T_ReportStatSqlValue
/
alter table T_ReportStatSqlValue modify (sqlwherevalue varchar2(4000))
/

alter table T_OutReport add outrependesc  varchar2(100)   
/

create OR REPLACE PROCEDURE T_OutReport_Insert(
     outrepname_1 	varchar2,
     outreprow_2 	integer,
     outrepcolumn_3 	integer,
     outrepdesc_4 	varchar2,
     modulefilename_5  varchar2,
     outreptype_6 char,
     outrepcategory_7 char,
     enmodulefilename_8  varchar2,
     outrepenname_9  varchar2,
     outrependesc_10  varchar2,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_OutReport( 
     outrepname,
     outreprow,
     outrepcolumn,
     outrepdesc,
     modulefilename,
     outreptype,
     outrepcategory,
     enmodulefilename,
     outrepenname,
     outrependesc) 
VALUES( 
     outrepname_1,
     outreprow_2,
     outrepcolumn_3,
     outrepdesc_4,
     modulefilename_5,
     outreptype_6,
     outrepcategory_7,
     enmodulefilename_8,
     outrepenname_9 ,
     outrependesc_10 );
end;    
/

create OR REPLACE PROCEDURE T_OutReport_Update(
      outrepid_1 	integer,
      outrepname_2 	varchar2,
      outrepdesc_3 	varchar2,
      modulefilename_5  varchar2,
      outreptype_6 char,
      outrepcategory_7 char,
      enmodulefilename_8  varchar2,
      outrepenname_9  varchar2,
      outrependesc_10 varchar2,
      flag out integer, 
      msg out varchar2,
      thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
UPDATE T_OutReport 
SET  outrepname	 = outrepname_2,
     outrepdesc	 = outrepdesc_3,
     modulefilename = modulefilename_5 ,
     outreptype = outreptype_6 ,
     outrepcategory = outrepcategory_7 ,
     enmodulefilename = enmodulefilename_8 ,
     outrepenname = outrepenname_9 ,
     outrependesc = outrependesc_10 
WHERE(outrepid = outrepid_1);
end;
/

create OR REPLACE PROCEDURE T_OutReport_Copy(
  outrepid_1 	integer,
	flag out integer, 
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
) 
AS 
newoutrepid_1 integer;
theoutrepcategory_1 integer;
itemid_1 integer;
newitemid_1 integer;
moduleid_1 integer;
newmoduleid_1 integer;
begin
select outrepcategory into theoutrepcategory_1 from T_OutReport where outrepid = outrepid_1; 

INSERT INTO T_OutReport(outrepname,outreprow,outrepcolumn,outrepdesc,modulefilename,outreptype,outrepcategory,enmodulefilename,outrepenname,outrependesc)
(select concat('复制_',outrepname),outreprow,outrepcolumn,outrepdesc,modulefilename,outreptype,outrepcategory,enmodulefilename,outrepenname,outrependesc 
 from T_OutReport where outrepid = outrepid_1); 

select max(outrepid) into newoutrepid_1 from T_OutReport; 

INSERT INTO T_OutReportCondition(outrepid,conditionid,conditioncnname,conditionenname)
(select newoutrepid_1,conditionid,conditioncnname,conditionenname from T_OutReportCondition where outrepid = outrepid_1); 

INSERT INTO T_OutReportShare(outrepid,userid,usertype)
(select newoutrepid_1,userid,usertype from T_OutReportShare where outrepid = outrepid_1); 

for module_cursor in(select id from outrepmodule where outrepid = outrepid_1) 
  loop
    moduleid_1 := module_cursor.id;
    INSERT INTO outrepmodule(outrepid,modulename,moduledesc,userid,usertype,moduleenname) 
    (select newoutrepid_1,modulename,moduledesc,userid,usertype,moduleenname from outrepmodule where id = moduleid_1); 
    select max(id) into newmoduleid_1 from outrepmodule; 
    INSERT INTO modulecondition(moduleid,conditionid,conditionname,isuserdefine,conditionvalue)
    (select newmoduleid_1,conditionid,conditionname,isuserdefine,conditionvalue from modulecondition where moduleid = moduleid_1); 
  end loop; 

if theoutrepcategory_1 = 0 or theoutrepcategory_1 = 2 then  
    INSERT INTO T_OutReportItemRow(outrepid,itemrow)
    (select newoutrepid_1,itemrow from T_OutReportItemRow where outrepid = outrepid_1);
    
    for itemid_cursor in(select itemid from T_OutReportItem where outrepid = outrepid_1)
      loop
        itemid_1 := itemid_cursor.itemid;
        INSERT INTO T_OutReportItem(outrepid,itemrow,itemcolumn,itemtype,picstat,itemexpress,itemtable,
        itemcondition,itemdesc,itemexpresstype,picstatbudget,picstatlast,itemmodtype)
        (select newoutrepid_1,itemrow,itemcolumn,itemtype,picstat,itemexpress,itemtable,
        itemcondition,itemdesc,itemexpresstype,picstatbudget,picstatlast,itemmodtype 
        from T_OutReportItem where itemid = itemid_1); 

        select max(itemid) into newitemid_1 from T_OutReportItem;
        
        INSERT INTO T_OutReportItemTable(itemid,itemtable,itemtablealter)
        (select newitemid_1,itemtable,itemtablealter from T_OutReportItemTable where itemid = itemid_1); 

        INSERT INTO T_OutReportItemCondition(itemid,conditionid,conditionvalue)
        (select newitemid_1,conditionid,conditionvalue from T_OutReportItemCondition where itemid = itemid_1);

        INSERT INTO T_OutReportItemCoordinate(itemid,coordinatename,coordinatevalue)
        (select newitemid_1,coordinatename,coordinatevalue from T_OutReportItemCoordinate where itemid = itemid_1); 
      end loop; 
else
    INSERT INTO T_OutReportStatitem(outrepid,statitemid,dsporder)
    (select newoutrepid_1,statitemid,dsporder from T_OutReportStatitem where outrepid = outrepid_1);
end if;     
end;
/

alter table T_OutReportItem add itemendesc varchar(200) 
/
CREATE OR REPLACE PROCEDURE T_OutReportItem_Insert(
         itemid_1 	integer,
	 outrepid_2 	integer,
	 itemrow_2 	integer,
	 itemcolumn_2 	integer,
	 itemtype       char,
	 itemexpress    varchar2 ,
	 itemdesc       varchar2,
	 itemexpresstype char,
	 picstatbudget char,
	 picstatlast   char,
	 picstat       char,
	 itemmodtype       char,
	 itemendesc       varchar2,
	 flag out integer, 
	 msg	varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
itemid_temp integer;
begin
itemid_temp := itemid_1;
if itemid_temp = 0 then
insert into T_OutReportItem(outrepid,itemrow,itemcolumn,itemtype,itemexpress,itemdesc, itemexpresstype, picstatbudget, picstatlast, picstat,itemtable,itemcondition,itemmodtype,itemendesc) 
values(outrepid_2,itemrow_2,itemcolumn_2,itemtype,itemexpress,itemdesc,itemexpresstype,picstatbudget,picstatlast,picstat, '', '',itemmodtype,itemendesc);
select max(itemid) into itemid_temp from T_OutReportItem;
else 
update T_OutReportItem set itemtype = itemtype,itemexpress = itemexpress,itemdesc = itemdesc, 
                           itemexpresstype = itemexpresstype,picstatbudget = picstatbudget, 
                           picstatlast = picstatlast,picstat = picstat, itemtable = ''  , 
                           itemcondition = '' , itemmodtype = itemmodtype , itemendesc = itemendesc 
                           where itemid = itemid_temp;
end if;
DELETE T_OutReportItemTable WHERE(itemid = itemid_temp);
DELETE T_OutReportItemCondition WHERE(itemid	 = itemid_temp);
DELETE T_OutReportItemCoordinate WHERE(itemid = itemid_temp);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportItem_Copy(
   outrepid_2 	integer,
	 itemrow_2 	integer,
	 itemcolumn_2 	integer,
	 fromitemrow_2      integer,
	 fromitemcolumn_2    integer,
	 flag	out integer, 
	 msg out varchar2,
         thecursor IN OUT cursor_define.weavercursor
) 
AS
itemid integer;
itemid1 integer;
itemtype char(1);
begin
select itemid into itemid from T_OutReportItem where itemrow = fromitemrow_2 and itemcolumn = fromitemcolumn_2 and outrepid = outrepid_2;
select itemtype into itemtype from T_OutReportItem where itemrow = fromitemrow_2 and itemcolumn = fromitemcolumn_2 and outrepid = outrepid_2;
if itemid is null then
return;
end if;
select itemid into itemid1 from T_OutReportItem where itemrow = itemrow_2 and itemcolumn = itemcolumn_2 and outrepid = outrepid_2;

if itemid1 is not null then
delete T_OutReportItem where itemid = itemid1;
delete T_OutReportItemTable where itemid = itemid1;
delete T_OutReportItemCondition where itemid = itemid1;
delete T_OutReportItemCoordinate where itemid = itemid1;
end if;

insert into T_OutReportItem(outrepid,itemrow,itemcolumn,itemtype,itemexpress,itemtable,itemcondition,itemdesc,itemexpresstype,picstatbudget,picstatlast,picstat,itemendesc) 
 (select outrepid,itemrow_2,itemcolumn_2,itemtype,itemexpress,itemtable,itemcondition,itemdesc,itemexpresstype,picstatbudget,picstatlast,picstat,itemendesc from T_OutReportItem where itemid = itemid);

if itemtype = '2' then
	select max(itemid) into itemid1 from T_OutReportItem;

	insert into T_OutReportItemTable(itemid,itemtable,itemtablealter) 
   (select itemid1,itemtable,itemtablealter from T_OutReportItemTable where itemid = itemid);

	insert into T_OutReportItemCondition(itemid,conditionid,conditionvalue) 
   (select itemid1,conditionid,conditionvalue from T_OutReportItemCondition where itemid = itemid); 

	insert into T_OutReportItemCoordinate(itemid,coordinatename,coordinatevalue) 
   (select itemid1,coordinatename,coordinatevalue from T_OutReportItemCoordinate where itemid = itemid); 
end if;
end;
/

alter table T_Statitem add statitemenname varchar2(200) 
/

CREATE OR REPLACE PROCEDURE T_Statitem_Insert(
     statitemname_1 	varchar2,
     statitemexpress_2 	varchar2,
     statitemdesc_3 	varchar2,
     statitemenname_4 	varchar2,
     flag out integer, 
     msg	varchar2,
     thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
INSERT INTO T_Statitem(statitemname,statitemexpress,statitemdesc,statitemenname) 
VALUES(statitemname_1,statitemexpress_2,statitemdesc_3,statitemenname_4);
end;
/

CREATE OR REPLACE PROCEDURE T_Statitem_Update(
     statitemid_1 	integer,
     statitemname_2 	varchar2,
     statitemexpress_3 	varchar2,
     statitemdesc_4 	varchar2,
     statitemenname_5 	varchar2,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
UPDATE T_Statitem 
SET  statitemname = statitemname_2,
     statitemexpress = statitemexpress_3,
     statitemdesc = statitemdesc_4 ,
     statitemenname = statitemenname_5
WHERE(statitemid = statitemid_1);
end;
/

create table T_InputReportCrmSel (               
inprepcontacterid integer primary key not null,      
inprepcrmid     integer,
contacterid     integer,
selcrm          varchar2(200)
)
/

create sequence inputReportCrmSel_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER inputReportCrmSel_Id_Trigger
       before insert on T_InputReportCrmSel
	     for each row
	     begin
	     select inputReportCrmSel_Id.nextval into :new.inprepcontacterid from dual;
	     end;
/

drop PROCEDURE T_IReportConfirm_SelectByCrmid
/

CREATE OR REPLACE PROCEDURE T_InputReportConfirm_SByUID(
      crmid_1  integer ,
      contactid_2  varchar2,
      flag out integer,
      msg out varchar2,
      thecursor IN OUT cursor_define.weavercursor
)
AS
begin
open thecursor for
select distinct * from 
(select a.inprepname, b.* 
 from T_InputReport a, T_InputReportConfirm b,T_InputReportCrm c 
 where a.inprepid = b.inprepid 
   and b.inprepid=c.inprepid 
   and b.crmid=c.crmid 
   and b.crmid = crmid_1
 union
 select distinct a.inprepname, b.* 
 from T_InputReport a,T_InputReportConfirm b,T_InputReportCrmSel c,T_InputReportCrm d
 where d.inprepcrmid = c.inprepcrmid 
   and a.inprepid = b.inprepid
   and a.inprepid = d.inprepid
   and c.contacterid = contactid_2
   and  ','||c.SELCRM||',' like ','||b.crmid||',') a;
end;
/

alter table T_InputReportCrmSel modify (selcrm  varchar2(1000))
/

create table T_OutReportItemRowGroup (
outrepid       integer ,  
itemrow	 integer ,
rowgroup  varchar2(1000)  
)
/

alter table T_OutReportShare add sharelevel integer default 0 
/

CREATE OR REPLACE PROCEDURE T_OutReport_Copy(
  outrepid_1 	integer,
	flag out integer, 
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
) 
AS 
newoutrepid_1 integer;
theoutrepcategory_1 integer;
itemid_1 integer;
newitemid_1 integer;
moduleid_1 integer;
newmoduleid_1 integer;
begin
select outrepcategory into theoutrepcategory_1 from T_OutReport where outrepid = outrepid_1; 

INSERT INTO T_OutReport(outrepname,outreprow,outrepcolumn,outrepdesc,modulefilename,outreptype,outrepcategory )
(select concat('复制_',outrepname),outreprow,outrepcolumn,outrepdesc modulefilename,outreptype,outrepcategory from T_OutReport where outrepid = outrepid_1); 

select max(outrepid) into newoutrepid_1 from T_OutReport;

INSERT INTO T_OutReportCondition(outrepid,conditionid)
(select newoutrepid_1,conditionid from T_OutReportCondition where outrepid = outrepid_1); 

INSERT INTO T_OutReportShare(outrepid,userid,usertype,sharelevel)
(select newoutrepid_1,userid,usertype,sharelevel from T_OutReportShare where outrepid = outrepid_1); 

for module_cursor in(select id from outrepmodule where outrepid = outrepid_1)
  loop
    moduleid_1 := module_cursor.id;
    INSERT INTO outrepmodule(outrepid,modulename,moduledesc,userid,usertype) 
    (select newoutrepid_1,modulename,moduledesc,userid,usertype from outrepmodule where id = moduleid_1); 
    select max(id) into newmoduleid_1 from outrepmodule; 
    INSERT INTO modulecondition(moduleid,conditionid,conditionname,isuserdefine,conditionvalue)
    (select newmoduleid_1,conditionid,conditionname,isuserdefine,conditionvalue from modulecondition where moduleid = moduleid_1); 
  end loop;  
if theoutrepcategory_1 = 0 then
    INSERT INTO T_OutReportItemRow(outrepid,itemrow)
    (select newoutrepid_1,itemrow from T_OutReportItemRow where outrepid = outrepid_1); 

    for itemid_cursor in(select itemid from T_OutReportItem where outrepid = outrepid_1)
      loop 
        itemid_1 := itemid_cursor.itemid;
        INSERT INTO T_OutReportItem(outrepid,itemrow,itemcolumn,itemtype,picstat,itemexpress,itemtable,
        itemcondition,itemdesc,itemexpresstype,picstatbudget,picstatlast,itemmodtype)
        (select newoutrepid_1,itemrow,itemcolumn,itemtype,picstat,itemexpress,itemtable,
        itemcondition,itemdesc,itemexpresstype,picstatbudget,picstatlast,itemmodtype 
        from T_OutReportItem where itemid = itemid_1); 

        select max(itemid) into newitemid_1 from T_OutReportItem;
        
        INSERT INTO T_OutReportItemTable(itemid,itemtable,itemtablealter)
        (select newitemid_1,itemtable,itemtablealter from T_OutReportItemTable where itemid = itemid_1); 

        INSERT INTO T_OutReportItemCondition(itemid,conditionid,conditionvalue)
        (select newitemid_1,conditionid,conditionvalue from T_OutReportItemCondition where itemid = itemid_1); 

        INSERT INTO T_OutReportItemCoordinate( itemid,  coordinatename , coordinatevalue )
        (select newitemid_1,  coordinatename,  coordinatevalue from T_OutReportItemCoordinate where itemid = itemid_1 ); 
       end loop;   
else
    INSERT INTO T_OutReportStatitem( outrepid,  statitemid , dsporder )
    ( select newoutrepid_1,  statitemid,  dsporder from T_OutReportStatitem where outrepid = outrepid_1 ); 
end if;
end;
/

alter table T_OutReport add (autocolumn char(1),autorow  char(1))    
/

CREATE OR REPLACE PROCEDURE T_OutReport_Insert(
     outrepname_1 	varchar2,
     outreprow_2 	integer,
     outrepcolumn_3 	integer,
     outrepdesc_4 	varchar2,
     modulefilename_5  varchar2,
     outreptype_6 char,
     outrepcategory_7 char,
     enmodulefilename_8  varchar2,
     outrepenname_9  varchar2,
     outrependesc_10  varchar2,
     autocolumn_11 char,
     autorow_12 char,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
) 
AS
begin
INSERT INTO T_OutReport 
	 ( outrepname,
	 outreprow,
	 outrepcolumn,
	 outrepdesc,
     modulefilename,
     outreptype,
     outrepcategory,
     enmodulefilename,
     outrepenname,
     outrependesc,
     autocolumn,
     autorow) 
VALUES 
	( outrepname_1,
	 outreprow_2,
	 outrepcolumn_3,
	 outrepdesc_4,
     modulefilename_5,
     outreptype_6,
     outrepcategory_7,
     enmodulefilename_8,
     outrepenname_9 ,
     outrependesc_10 ,
     autocolumn_11,
     autorow_12);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReport_Update
	(outrepid_1 	integer,
	 outrepname_2 	varchar2,
	 outrepdesc_3 	varchar2 ,
     modulefilename_5  varchar2 ,
     outreptype_6 char ,
     outrepcategory_7 char,
     enmodulefilename_8  varchar2,
     outrepenname_9  varchar2 ,
     outrependesc_10  varchar2,
     autocolumn_11 char ,
     autorow_12 char ,
	flag out integer, 
	msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
UPDATE T_OutReport 
SET  outrepname	 = outrepname_2,
	 outrepdesc	 = outrepdesc_3,
     modulefilename	 = modulefilename_5 ,
     outreptype = outreptype_6 ,
     outrepcategory = outrepcategory_7 ,
     enmodulefilename	 = enmodulefilename_8 ,
     outrepenname	 = outrepenname_9 ,
     outrependesc	 = outrependesc_10 ,
     autocolumn	 = autocolumn_11 ,
     autorow	 = autorow_12 
WHERE 
	( outrepid = outrepid_1);
end;
/

update T_OutReport set autocolumn = '0',autorow = '0'
/

CREATE OR REPLACE PROCEDURE T_OutReport_Copy(
        outrepid_1 	integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	) 
AS 
newoutrepid_1 integer;
theoutrepcategory_1 integer;
itemid_1 integer;
newitemid_1 integer;
moduleid_1 integer;
newmoduleid_1 integer;
begin
select outrepcategory into theoutrepcategory_1 from T_OutReport where outrepid = outrepid_1; 

INSERT INTO T_OutReport( outrepname,  outreprow , outrepcolumn , outrepdesc , modulefilename , outreptype , outrepcategory ,enmodulefilename,outrepenname,outrependesc )
( select concat('复制_',outrepname),  outreprow , outrepcolumn , outrepdesc , modulefilename , outreptype , outrepcategory  ,enmodulefilename,outrepenname,outrependesc from T_OutReport where outrepid = outrepid_1 ); 

select max(outrepid) into newoutrepid_1 from T_OutReport; 

INSERT INTO T_OutReportCondition( outrepid,  conditionid , conditioncnname, conditionenname )
( select newoutrepid_1,  conditionid , conditioncnname, conditionenname from T_OutReportCondition where outrepid = outrepid_1 ); 

INSERT INTO T_OutReportShare( outrepid,  userid , usertype , sharelevel)
( select newoutrepid_1,  userid,  usertype , sharelevel from T_OutReportShare where outrepid = outrepid_1 ); 

for module_cursor in(select id from outrepmodule where outrepid = outrepid_1)
  loop
    moduleid_1 := module_cursor.id;
    INSERT INTO outrepmodule( outrepid,  modulename , moduledesc , userid , usertype , moduleenname ) 
    ( select newoutrepid_1,  modulename,  moduledesc , userid , usertype , moduleenname from outrepmodule where id = moduleid_1 ); 
    select max(id) into newmoduleid_1 from outrepmodule; 
    INSERT INTO modulecondition( moduleid,  conditionid , conditionname , isuserdefine , conditionvalue )
    ( select newmoduleid_1,  conditionid , conditionname , isuserdefine , conditionvalue from modulecondition where moduleid = moduleid_1 ); 
  end loop;  

if theoutrepcategory_1 = 0 or theoutrepcategory_1 = 2  then 
    INSERT INTO T_OutReportItemRow( outrepid,  itemrow )
    ( select newoutrepid_1,  itemrow from T_OutReportItemRow where outrepid = outrepid_1 ); 

    for itemid_cursor in(select itemid from T_OutReportItem where outrepid = outrepid_1) 
      loop
        itemid_1 := itemid_cursor.itemid;
        INSERT INTO T_OutReportItem( outrepid,  itemrow , itemcolumn , itemtype , picstat, itemexpress, itemtable,
        itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast , itemmodtype )
        ( select newoutrepid_1,  itemrow , itemcolumn , itemtype , picstat, itemexpress, itemtable,
        itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast , itemmodtype 
        from T_OutReportItem where itemid = itemid_1 ); 

        select max( itemid ) into newitemid_1 from T_OutReportItem; 
        
        INSERT INTO T_OutReportItemTable( itemid,  itemtable , itemtablealter )
        ( select newitemid_1,  itemtable,  itemtablealter from T_OutReportItemTable where itemid = itemid_1 ); 

        INSERT INTO T_OutReportItemCondition( itemid,  conditionid , conditionvalue )
        ( select newitemid_1,  conditionid,  conditionvalue from T_OutReportItemCondition where itemid = itemid_1 ); 

        INSERT INTO T_OutReportItemCoordinate( itemid,  coordinatename , coordinatevalue )
        ( select newitemid_1,  coordinatename,  coordinatevalue from T_OutReportItemCoordinate where itemid = itemid_1 ); 
      end loop;  
else
    INSERT INTO T_OutReportStatitem( outrepid,  statitemid , dsporder )
    ( select newoutrepid_1,  statitemid,  dsporder from T_OutReportStatitem where outrepid = outrepid_1 ); 
end if;
end;
/

alter table T_InputReport add isInputMultiLine char(1) null
/
alter table T_InputReport add billId integer null
/
update T_InputReport set isInputMultiLine='1' where inprepfrequence='0'
/
alter table T_inputReport add deleted integer  default 0
/
update T_inputReport set deleted=0 where deleted is null
/
alter table workflow_base add isShowOnReportInput char(1)  default '0'
/
update workflow_base set isShowOnReportInput='0' 
/
alter table Workflow_Report add isShowOnReportOutput char(1)  default '0'
/
update Workflow_Report set isShowOnReportOutput='0' 
/
ALTER TABLE T_InputReportItem ADD  tempDspOrder decimal(15,2) null
/
update T_InputReportItem set tempDspOrder=dspOrder
/
ALTER TABLE T_InputReportItem DROP COLUMN dspOrder
/
ALTER TABLE T_InputReportItem ADD  dspOrder decimal(15,2) null
/
update T_InputReportItem set dspOrder=tempDspOrder
/
ALTER TABLE T_InputReportItem DROP COLUMN tempDspOrder
/
ALTER TABLE T_InputReportItemType ADD  tempDspOrder decimal(15,2) null
/
update T_InputReportItemType set tempDspOrder=dspOrder
/
ALTER TABLE T_InputReportItemType DROP COLUMN dspOrder
/
ALTER TABLE T_InputReportItemType ADD  dspOrder decimal(15,2) null
/
update T_InputReportItemType set dspOrder=tempDspOrder
/
ALTER TABLE T_InputReportItemType DROP COLUMN tempDspOrder
/

CREATE TABLE T_InputReportHrm (
	id integer PRIMARY key NOT NULL,
	inprepId integer  ,
	crmId varchar2(1000),
	hrmId integer ,
	workflowId integer,
	moduleFileName varchar2(250) 
)
/

create sequence inputReportHrm_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER inputReportHrm_Id_Trigger
       before insert on T_InputReportHrm
	     for each row
	     begin
	     select inputReportHrm_Id.nextval into :new.id from dual;
	     end;
/

CREATE TABLE T_InputReportHrmFields (
	id integer PRIMARY key NOT NULL ,
	reportHrmId integer NOT NULL ,
	fieldId integer NOT NULL 
)
/

create sequence inputReportHrmFields_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER inputRHrmFields_Id_Trigger
       before insert on T_InputReportHrmFields
	     for each row
	     begin
	     select inputReportHrmFields_Id.nextval into :new.id from dual;
	     end;
/


CREATE TABLE T_CollectSettingInfo(
    id integer,
    reporthrmid integer, 
    crmids varchar2(1000),
    cycle   char, 
    sortfields   varchar2(4000), 
    sqlwhere varchar2(4000)
)
/

create sequence collectSettingInfo_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER collectSettingInfo_Id_Trigger
       before insert on T_CollectSettingInfo
	     for each row
	     begin
	     select collectSettingInfo_Id.nextval into :new.id from dual;
	     end;
/

CREATE TABLE T_CollectTableInfo(
    id integer,
    collectid integer, 
    inprepid integer, 
    tablealia    varchar2(2) 
)
/

create sequence collectTableInfo_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER collectTableInfo_Id_Trigger
       before insert on T_CollectTableInfo
	     for each row
	     begin
	     select collectTableInfo_Id.nextval into :new.id from dual;
	     end;
/	   

CREATE TABLE T_FieldComparisonInfo(
    id integer,
    collectid integer, 
    sourcefield varchar2(1000), 
    desfield    varchar2(50) 
)
/

create sequence fieldComparisonInfo_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/

CREATE OR REPLACE TRIGGER fieldComparisonInfo_Id_Trigger
       before insert on T_FieldComparisonInfo
	     for each row
	     begin
	     select fieldComparisonInfo_Id.nextval into :new.id from dual;
	     end;
/
update mainmenuconfig set visible=0 where infoid >=187 and infoid<=199
/

CREATE OR REPLACE PROCEDURE T_InputReport_Insert (
inprepname_1 	varchar2,
inpreptablename_2 	varchar2,
inprepbugtablename_3 	varchar2,
inprepfrequence_4 	char,
inprepbudget_5 	char,
inprepforecast_6	char,
startdate_7	char,
enddate_8	char,
modulefilename_9	varchar2,
helpdocid_10	integer,
isInputMultiLine_11	char,
billId_12	integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)  
AS
begin
INSERT INTO T_InputReport ( 
inprepname,
inpreptablename,
inprepbugtablename,
inprepfrequence,
inprepbudget,
inprepforecast,
startdate,
enddate,
modulefilename,
helpdocid,
isInputMultiLine,
billId
)  
VALUES ( 
inprepname_1,
inpreptablename_2,
inprepbugtablename_3,
inprepfrequence_4,
inprepbudget_5,
inprepforecast_6,
startdate_7,
enddate_8,
modulefilename_9,
helpdocid_10,
isInputMultiLine_11,
billId_12
);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReport_SelectAll (
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)  
AS 
begin
open thecursor for
select * from T_InputReport where deleted=0;
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportItem_Update (
itemid_1 	integer, 
itemdspname_2 	varchar2, 
itemfieldname_3 	varchar2, 
itemfieldtype_4 	char, 
itemfieldscale_5 	integer, 
itemtypeid_6 	integer, 
itemexcelsheet_7 	varchar2, 
itemexcelrow_8 	integer, 
itemexcelcolumn_9 	integer , 
itemfieldunit_10   varchar2, 
dsporder_11        decimal, 
itemgongsi_12 	varchar2, 
inputablefact_13 	char, 
inputablebudg_14 	char, 
inputablefore_15 	char, 
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)  
AS 
begin
UPDATE T_InputReportItem  
SET  
itemdspname	 = itemdspname_2, 
itemfieldname	 = itemfieldname_3, 
itemfieldtype	 = itemfieldtype_4, 
itemfieldscale	 = itemfieldscale_5, 
itemtypeid	 = itemtypeid_6, 
itemexcelsheet	 = itemexcelsheet_7, 
itemexcelrow	 = itemexcelrow_8, 
itemexcelcolumn	 = itemexcelcolumn_9 , 
itemfieldunit = itemfieldunit_10 , 
dsporder = dsporder_11 , 
itemgongsi = itemgongsi_12 , 
inputablefact = inputablefact_13 , 
inputablebudg = inputablebudg_14 , 
inputablefore = inputablefore_15  
WHERE ( itemid	 = itemid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportItemtype_Delete (
itemtypeid_1 	integer, 
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)  
AS 
begin
DELETE T_InputReportItemtype WHERE ( itemtypeid	 = itemtypeid_1);  
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportItemtype_Insert (
inprepid_1 	integer, 
itemtypename_2 	varchar2, 
itemtypedesc_3 	varchar2 , 
dsporder_4 	decimal , 
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)  
AS 
begin
INSERT INTO T_InputReportItemtype ( 
inprepid, 
itemtypename, 
itemtypedesc, 
dsporder)  
VALUES ( 
inprepid_1, 
itemtypename_2, 
itemtypedesc_3, 
dsporder_4);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportItemtype_Update (
itemtypeid_1 	integer, 
itemtypename_2 	varchar2, 
itemtypedesc_3 	varchar2, 
dsporder_4 	decimal, 
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)  
AS 
begin
UPDATE T_InputReportItemtype  
SET  
itemtypename	 = itemtypename_2, 
itemtypedesc	 = itemtypedesc_3 , 
dsporder	 = dsporder_4  
WHERE ( itemtypeid = itemtypeid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportItem_Insert (
inprepid_1 	integer, 
itemdspname_2 	varchar2, 
itemfieldname_3 	varchar2, 
itemfieldtype_4 	char, 
itemfieldscale_5 	integer, 
itemtypeid_6 	integer, 
itemexcelsheet_7 	varchar2, 
itemexcelrow_8 	integer, 
itemexcelcolumn_9 	integer , 
itemfieldunit_10   varchar2, 
dsporder_11        decimal, 
itemgongsi_12 	varchar, 
inputablefact_13 	char, 
inputablebudg_14 	char, 
inputablefore_15 	char, 
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)  
AS  
begin
INSERT INTO T_InputReportItem ( 
inprepid, 
itemdspname, 
itemfieldname, 
itemfieldtype, 
itemfieldscale, 
itemtypeid, 
itemexcelsheet, 
itemexcelrow, 
itemexcelcolumn, 
itemfieldunit, 
dsporder, 
itemgongsi, 
inputablefact, 
inputablebudg, 
inputablefore) 
VALUES ( 
inprepid_1, 
itemdspname_2, 
itemfieldname_3, 
itemfieldtype_4, 
itemfieldscale_5, 
itemtypeid_6, 
itemexcelsheet_7, 
itemexcelrow_8, 
itemexcelcolumn_9, 
itemfieldunit_10, 
dsporder_11, 
itemgongsi_12, 
inputablefact_13, 
inputablebudg_14, 
inputablefore_15);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReport_Update (
inprepid_1 	integer,
inprepname_2 	varchar2,
inpreptablename_3 	varchar2,
inprepbugtablename_4 	varchar2,
inprepfrequence_5 	char,
inprepbudget_6 	char,
inprepforecast_7	char,
startdate_8	char,
enddate_9	char,
modulefilename_10	varchar2,
helpdocid_11	integer,
isInputMultiLine_12	char,
billId_13	integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
AS
begin
UPDATE T_InputReport
SET
inprepname	 = inprepname_2,
inpreptablename	 = inpreptablename_3,
inprepbugtablename	 = inprepbugtablename_4,
inprepfrequence	 = inprepfrequence_5, 
inprepbudget	 = inprepbudget_6 ,
inprepforecast	 = inprepforecast_7 ,
startdate	 = startdate_8 ,
enddate	 = enddate_9 ,
modulefilename	 = modulefilename_10 ,
helpdocid	 = helpdocid_11 ,
isInputMultiLine	 = isInputMultiLine_12 ,
billId	 = billId_13
WHERE ( inprepid = inprepid_1);
end;
/

delete from sequenceindex  where  indexDesc='dataCenterWorkflowTypeId'
/
insert into workflow_type(typeName,typeDesc,dspOrder) values('报表填报','报表填报',-2)
/
insert into sequenceindex(indexDesc,currentId) select 'dataCenterWorkflowTypeId',max(id)  from workflow_type
/
update workflow_base set workflowType=(select currentId from sequenceindex where indexDesc='dataCenterWorkflowTypeId') where workflowType=-2
/

