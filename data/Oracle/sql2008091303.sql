CREATE OR REPLACE PROCEDURE T_Statitem_Delete(
     statitemid_1 integer,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
DELETE from T_Statitem WHERE(statitemid = statitemid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_ReportStatitemTable_Delete(
        outrepid_1 	integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
Delete from T_ReportStatitemTable where outrepid = outrepid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_OutRShare_SelectByOutrepid(
        outrepid_1 integer,
	flag out integer, 
	msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
open thecursor for
select * from T_OutReportShare where outrepid = outrepid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_OutRItemTable_SelectByItemid(
        itemid_1 integer,
	flag out integer, 
	msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
open thecursor for
select * from T_OutReportItemTable where itemid = itemid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_OutRItemCoordinate_Delete(
        itemid_1 	integer ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
DELETE from T_OutReportItemCoordinate WHERE (itemid = itemid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_OutRItemCondition_Insert(
        itemid_1 	integer,
	conditionid_1     integer,
	conditionvalue_1  varchar2,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_OutReportItemCondition(itemid,conditionid,conditionvalue)VALUES(itemid_1,conditionid_1,conditionvalue_1);
end;
/

CREATE OR REPLACE PROCEDURE T_OutRItemCondition_Delete(
        itemid_1  integer ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS
begin
DELETE from T_OutReportItemCondition WHERE(itemid = itemid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_OutRItem_SelectByOutrepid(
        outrepid_1 integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
open thecursor for
select * from T_OutReportItem where outrepid = outrepid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_OutRICondition_SByItemid(
        itemid_1 integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin 
open thecursor for
select * from T_OutReportItemCondition where itemid = itemid_1 order by conditionid;
end;
/

CREATE OR REPLACE PROCEDURE T_OutRICdinate_SelectByItemid(
        itemid_1 integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin 
open thecursor for
select * from T_OutReportItemCoordinate where itemid = itemid_1 ;
end;
/

create OR REPLACE PROCEDURE T_OutReportStatitem_Uorder(
        outrepitemid_1 	integer,
        upordown_1  	integer, 
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

if upordown_1 = 1 then
    update T_OutReportStatitem set dsporder = dsporder+1 where outrepid = theoutrepid and dsporder = thedsporder-1; 
    update T_OutReportStatitem set dsporder = dsporder-1 where outrepitemid = outrepitemid_1;
else 
    update T_OutReportStatitem set dsporder = dsporder-1 where outrepid = theoutrepid and dsporder = thedsporder+1;
    update T_OutReportStatitem set dsporder = dsporder+1 where outrepitemid = outrepitemid_1;
end if;
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

Delete from T_OutReportStatitem where outrepitemid = outrepitemid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportShare_Delete(
        outrepshareid_1 integer ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
DELETE from  T_OutReportShare WHERE(outrepshareid = outrepshareid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportItemTable_Insert(
     itemid_1 	integer,
     itemtable_1     varchar2,
     itemtablealter_1  varchar2,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_OutReportItemTable(itemid,itemtable,itemtablealter)VALUES(itemid_1,itemtable_1,itemtablealter_1);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportItemTable_Delete(
        itemid_1 	integer ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
DELETE from  T_OutReportItemTable WHERE(itemid = itemid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportItem_SelectByRowCol(
        outrepid_1 integer ,
	itemrow_1 integer,
	itemcolumn_1 integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
open thecursor for
select * from T_OutReportItem where outrepid = outrepid_1 and itemrow = itemrow_1 and itemcolumn= itemcolumn_1;
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportItem_SelectByItemid(
        itemid_1 integer ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
open thecursor for
select * from T_OutReportItem where itemid = itemid_1; 
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportItem_Insert( 
itemid_1     integer, 
outrepid_2     integer, 
itemrow_2     integer, 
itemcolumn_2     integer, 
itemtype_1       char, 
itemexpress_1    varchar2 , 
itemdesc_1       varchar2, 
itemexpresstype_1 char, 
picstatbudget_1 char, 
picstatlast_1   char, 
picstat_1       char, 
itemmodtype_1      char, 
itemendesc_1      varchar2, 
flag out integer, 
msg    varchar2, 
thecursor IN OUT cursor_define.weavercursor 
) AS 
itemid_temp integer; 
begin
 itemid_temp := itemid_1; 
 if itemid_temp = 0 then 
     insert into T_OutReportItem(outrepid,itemrow,itemcolumn,itemtype,itemexpress,itemdesc, itemexpresstype, picstatbudget, picstatlast, picstat,itemtable,itemcondition,itemmodtype,itemendesc) 
           values(outrepid_2,itemrow_2,itemcolumn_2,itemtype_1,itemexpress_1,itemdesc_1,itemexpresstype_1,picstatbudget_1,picstatlast_1,picstat_1, '', '',itemmodtype_1,itemendesc_1); 
     select max(itemid) into itemid_temp from T_OutReportItem;
  else 
      update T_OutReportItem set 
      itemtype = itemtype_1,itemexpress = itemexpress_1,itemdesc = itemdesc_1, itemexpresstype = itemexpresstype_1,picstatbudget = picstatbudget_1, picstatlast = picstatlast_1,picstat = picstat_1, itemtable = ''  , itemcondition = '' , itemmodtype = itemmodtype_1 , itemendesc = itemendesc_1 
      where itemid = itemid_temp; 
  end if; 
  DELETE from T_OutReportItemTable WHERE(itemid = itemid_temp); 
  DELETE from T_OutReportItemCondition WHERE(itemid	 = itemid_temp); 
  DELETE from T_OutReportItemCoordinate WHERE(itemid = itemid_temp); 
  open thecursor for
  select itemid from T_OutReportItem where itemid=itemid_temp;
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportItem_DeleteByRowCol(
  outrepid_1 integer ,
	itemrow_1 integer,
	itemcolumn_1 integer,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
AS
itemid integer;
begin
select itemid into itemid from T_OutReportItem where outrepid = outrepid_1 and itemrow = itemrow_1 and itemcolumn= itemcolumn_1;
delete from T_OutReportItem where itemid = itemid;
delete from T_OutReportItemTable where itemid = itemid;
delete from T_OutReportItemCondition where itemid = itemid;
delete from T_OutReportItemCoordinate where itemid = itemid;
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportItem_DeleteByRow(
        outrepid_1 integer,
	      itemrow_1 integer,
	      flag out integer, 
	      msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor
) 
AS 
itemid integer;
begin
 for itemid_cursor in(select itemid from T_OutReportItem where outrepid = outrepid_1 and itemrow = itemrow_1)
 loop
   itemid := itemid_cursor.itemid; 
	 delete from T_OutReportItem where itemid = itemid;
	 delete from T_OutReportItemTable where itemid = itemid;
	 delete from T_OutReportItemCondition where itemid = itemid;
	 delete from T_OutReportItemCoordinate where itemid = itemid;
 end loop;
end; 
/

CREATE OR REPLACE PROCEDURE T_OutReportItem_DeleteByCol(
  outrepid_1 integer,
	itemcolumn_1 integer ,
	flag	out integer,
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
)
AS
itemid integer;
begin
  for itemid_cursor in(select itemid from T_OutReportItem where outrepid = outrepid_1 and itemcolumn= itemcolumn_1)
  loop
    itemid := itemid_cursor.itemid;
	  delete from T_OutReportItem where itemid = itemid;
	  delete from T_OutReportItemTable where itemid = itemid;
	  delete from T_OutReportItemCondition where itemid = itemid;
	  delete from T_OutReportItemCoordinate where itemid = itemid;
  end loop;
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportItem_Delete(
        itemid_1 	integer ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
delete from T_OutReportItem where itemid = itemid_1;
delete from T_OutReportItemTable where itemid = itemid_1;
delete from T_OutReportItemCondition where itemid = itemid_1;
delete from T_OutReportItemCoordinate where itemid = itemid_1;
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportItem_Copy(
   outrepid_2     integer,
   itemrow_2     integer,
   itemcolumn_2     integer,
   fromitemrow_2      integer,
   fromitemcolumn_2    integer,
   flag    out integer, 
   msg out varchar2,
         thecursor IN OUT cursor_define.weavercursor
) 
AS
itemid2 integer;
itemid1 integer;
itemtype3 char;
begin
select itemid,itemtype into itemid2,itemtype3 from T_OutReportItem where itemrow=fromitemrow_2 and itemcolumn=fromitemcolumn_2 and outrepid=outrepid_2;
if itemid2 is not null then  
    delete from T_OutReportItemTable where exists(select 1 from T_OutReportItem where T_OutReportItem.itemid=T_OutReportItemTable.itemid and itemrow = itemrow_2 and itemcolumn = itemcolumn_2 and outrepid = outrepid_2);
    delete from T_OutReportItemCondition where  exists(select 1 from T_OutReportItem where T_OutReportItem.itemid=T_OutReportItemCondition.itemid and itemrow = itemrow_2 and itemcolumn = itemcolumn_2 and outrepid = outrepid_2);
    delete from T_OutReportItemCoordinate where  exists(select 1 from T_OutReportItem where T_OutReportItem.itemid=T_OutReportItemCoordinate.itemid and itemrow = itemrow_2 and itemcolumn = itemcolumn_2 and outrepid = outrepid_2);  
    delete from T_OutReportItem where itemrow=itemrow_2 and itemcolumn=itemcolumn_2 and outrepid=outrepid_2;
    insert into T_OutReportItem( outrepid, itemrow, itemcolumn, itemtype, itemexpress, itemtable, itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast, picstat , itemendesc) select outrepid, itemrow_2, itemcolumn_2, itemtype, itemexpress, itemtable, itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast, picstat , itemendesc from T_OutReportItem where itemid = itemid2;
    if itemtype3 = '2' then
        select max(itemid) into itemid1 from T_OutReportItem;
        insert into T_OutReportItemTable(itemid,itemtable,itemtablealter) select itemid1,itemtable,itemtablealter from T_OutReportItemTable where itemid = itemid2;
        insert into T_OutReportItemCondition(itemid,conditionid,conditionvalue) select itemid1,conditionid,conditionvalue from T_OutReportItemCondition where itemid = itemid2; 
        insert into T_OutReportItemCoordinate(itemid,coordinatename,coordinatevalue) select itemid1,coordinatename,coordinatevalue from T_OutReportItemCoordinate where itemid = itemid2; 
    end if;
end if;
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportICoordinate_Insert(
         itemid_1 	integer,
	 coordinatename_1     varchar2,
	 coordinatevalue_1  varchar2,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO T_OutReportItemCoordinate (itemid,coordinatename,coordinatevalue)VALUES (itemid_1,coordinatename_1,coordinatevalue_1);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReportCondition_Delete(
        outrepconditionid_1 	integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
DELETE from T_OutReportCondition WHERE(outrepconditionid = outrepconditionid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_OutReport_SelectByUserid(
        userid_1 integer ,
	usertype_1 char,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
AS
begin
open thecursor for
select a.* from T_OutReport a, T_OutReportShare b
where a.outrepid = b.outrepid and b.userid=userid_1 and b.usertype = usertype_1;
end;
/

CREATE OR REPLACE PROCEDURE T_OutReport_SelectByOutrepid(
        outrepid_1 integer ,
	flag out integer, 
	msg out	varchar2,
	thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
open thecursor for
select * from T_OutReport where outrepid = outrepid_1;
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
DELETE from T_OutReport WHERE(outrepid = outrepid_1);
DELETE from T_OutReportCondition WHERE(outrepid = outrepid_1);
DELETE from T_OutReportShare WHERE(outrepid = outrepid_1);
DELETE from T_OutReportItem WHERE(outrepid	= outrepid_1);
DELETE from T_ReportStatitemTable WHERE(outrepid = outrepid_1);
DELETE from T_OutReportStatitem WHERE(outrepid = outrepid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_outrepmodule_Delete(
     id_1  integer,
     flag out integer, 
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
DELETE from outrepmodule WHERE(id = id_1);
end;
/

CREATE OR REPLACE PROCEDURE T_OutRC_SelectByOutrepid(
        outrepid_1 integer ,
	flag out integer, 
	msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
open thecursor for
select * from T_OutReportCondition where outrepid = outrepid_1;
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
DELETE from modulecondition WHERE(moduleid = id_1);
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
DELETE from T_InputReportItemtype WHERE ( itemtypeid	 = itemtypeid_1);  
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportItemDetail_Delete(
  itemid_1 	integer ,
	flag out integer , 
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
   DELETE from T_InputReportItemDetail WHERE(itemid = itemid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportItemClose_Delete(
        closeid_1 	integer ,
	flag out integer, 
	msg out	varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
DELETE from T_InputReportItemClose WHERE(closeid = closeid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportItem_Delete(
  itemid_1 	integer,
	flag	out integer,
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
)
AS
begin
  DELETE from T_InputReportItem WHERE(itemid	= itemid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportCrm_Delete(
  inprepcrmid_1 integer ,
	flag out integer, 
	msg out	varchar2,
  thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
  DELETE from T_InputReportCrm WHERE (inprepcrmid = inprepcrmid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReportConfirm_Delete(
        confirmid_1 integer ,
	flag out integer, 
	msg out	varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
   DELETE from T_InputReportConfirm WHERE (confirmid	= confirmid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_InputReport_Delete(
   inprepid_1 integer,
   flag out integer, 
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
   DELETE from T_InputReport WHERE(inprepid = inprepid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_fItemDetail_SelectByItemid
	(itemid_1  integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor 
	) 
AS 
begin
open thecursor for
select * from T_fieldItemDetail where itemid = itemid_1;
end;
/

CREATE OR REPLACE PROCEDURE  T_fieldItemDetail_Delete 
	(itemid_1 integer,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS 
begin
DELETE from T_fieldItemDetail  WHERE (itemid = itemid_1);
end;
/

CREATE OR REPLACE PROCEDURE  T_fieldItem_Delete 
	(itemid_1 	 integer  ,
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
DELETE from T_fieldItem  WHERE (itemid  = itemid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_DatacenterUser_Delete(
         flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
DELETE from T_DatacenterUser;
end;
/

CREATE OR REPLACE PROCEDURE T_ConditionDetail_Delete(
         conditionid_1 	integer ,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
DELETE from T_ConditionDetail WHERE(conditionid = conditionid_1);
end;
/

CREATE OR REPLACE PROCEDURE T_Condition_Delete(
         conditionid_1 	integer ,
	 flag out integer, 
	 msg out varchar2,
         thecursor IN OUT cursor_define.weavercursor 
) 
AS 
begin
DELETE from T_Condition WHERE(conditionid = conditionid_1);
end;
/

CREATE OR REPLACE PROCEDURE  T_SurveyItem_Delete 
	(inprepid_1 integer,
	 flag out integer, 
	 msg out varchar2)
AS 
begin
DELETE from  T_SurveyItem  
WHERE( inprepid  = inprepid_1);
end;
/
