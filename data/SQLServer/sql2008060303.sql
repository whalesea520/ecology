alter table T_OutReport add modulefilename  varchar(100) 
GO

alter PROCEDURE T_OutReport_Insert
	(@outrepname_1 	varchar(200),
	 @outreprow_2 	int,
	 @outrepcolumn_3 	int,
	 @outrepdesc_4 	varchar(255) ,
     @modulefilename_5  varchar(100) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_OutReport 
	 ( outrepname,
	 outreprow,
	 outrepcolumn,
	 outrepdesc,
     modulefilename) 
 
VALUES 
	( @outrepname_1,
	 @outreprow_2,
	 @outrepcolumn_3,
	 @outrepdesc_4,
     @modulefilename_5 )
GO

alter PROCEDURE T_OutReport_Update
	(@outrepid_1 	int,
	 @outrepname_2 	varchar(200),
	 @outrepdesc_3 	varchar(255) ,
     @modulefilename_5  varchar(100) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS UPDATE T_OutReport 

SET  outrepname	 = @outrepname_2,
	 outrepdesc	 = @outrepdesc_3,
     modulefilename	 = @modulefilename_5 
WHERE 
	( outrepid	 = @outrepid_1)
GO


create table outrepmodule (
id  int IDENTITY(1,1) primary key CLUSTERED,     
outrepid   int,     
modulename varchar(100),     
moduledesc varchar(200),    
userid     int,   
usertype   int    
)
go


create table modulecondition (
id    int IDENTITY(1,1) primary key CLUSTERED,     
moduleid       int , 
conditionid    int,  
conditionname   varchar(60),
isuserdefine     int,
conditionvalue varchar(255)
)
go


CREATE PROCEDURE T_outrepmodule_Insert
(@outrepid_1 int,
@modulename_2 varchar(100),
@moduledesc_3 varchar(200),
@userid_4 int,
@usertype_5 int,
@flag	int	output, 
@msg	varchar(80)	output) 

AS INSERT INTO outrepmodule
 ( outrepid,
 modulename,
 moduledesc,
 userid,
 usertype) 
 
VALUES 
(@outrepid_1,
 @modulename_2,
 @moduledesc_3,
 @userid_4,
 @usertype_5) 
select max(id) from outrepmodule
GO


CREATE PROCEDURE T_modulecondition_Insert
(
@moduleid_1       int ,
@conditionid_2    int, 
@conditionname_3   varchar(60),
@isuserdefine_4     int,
@conditionvalue_5 varchar(255),
@flag	int	output, 
@msg	varchar(80)	output) 

AS INSERT INTO modulecondition
(moduleid,
conditionid,
conditionname ,
isuserdefine,
conditionvalue 
)VALUES(
@moduleid_1,
@conditionid_2,
@conditionname_3 ,
@isuserdefine_4,
@conditionvalue_5)
GO

CREATE PROCEDURE T_outrepmodule_Update
	(@id_1 	int,
	 @modulename_2 	varchar(100),
	 @moduledesc_3 	varchar(200),
     @flag	int	output, 
     @msg	varchar(80)	output) 

AS UPDATE outrepmodule 

SET  modulename	 = @modulename_2,
	 moduledesc	 = @moduledesc_3 

WHERE 
	( id	 = @id_1)
GO


CREATE PROCEDURE T_outrepmodule_Delete
	(@id_1 	int,
     @flag	int	output, 
     @msg	varchar(80)	output) 

AS DELETE outrepmodule 

WHERE 
	( id	 = @id_1)
GO


CREATE PROCEDURE T_modulecondition_Delete
	(@id_1 	int,
     @flag	int	output, 
     @msg	varchar(80)	output) 

AS DELETE modulecondition 

WHERE 
	( moduleid	 = @id_1)
GO


create table T_Statitem (
statitemid  int IDENTITY(1,1) primary key CLUSTERED,     
statitemname     varchar(100),                           
statitemexpress       varchar(200) ,                     
statitemdesc     varchar(100)                            
)
GO


CREATE PROCEDURE T_Statitem_SelectAll
	(@flag	int	output, 
     @msg	varchar(80)	output)

AS select * from  T_Statitem 
GO


CREATE PROCEDURE T_Statitem_Select
	(@statitemid_1 	int,
     @flag	int	output, 
     @msg	varchar(80)	output)

AS select * from  T_Statitem 

WHERE 
	( statitemid	 = @statitemid_1)
GO


CREATE PROCEDURE T_Statitem_Insert
	(@statitemname_1 	varchar(100),
	 @statitemexpress_2 	varchar(200),
	 @statitemdesc_3 	varchar(100),
     @flag	int	output, 
     @msg	varchar(80)	output)

AS INSERT INTO T_Statitem 
	 ( statitemname,
	 statitemexpress,
	 statitemdesc) 
 
VALUES 
	( @statitemname_1,
	 @statitemexpress_2,
	 @statitemdesc_3)
GO


CREATE PROCEDURE T_Statitem_Update
	(@statitemid_1 	int,
	 @statitemname_2 	varchar(100),
	 @statitemexpress_3 	varchar(200),
	 @statitemdesc_4 	varchar(100),
     @flag	int	output, 
     @msg	varchar(80)	output)

AS UPDATE T_Statitem 

SET  statitemname	 = @statitemname_2,
	 statitemexpress	 = @statitemexpress_3,
	 statitemdesc	 = @statitemdesc_4 

WHERE 
	( statitemid	 = @statitemid_1)
GO


CREATE PROCEDURE T_Statitem_Delete
	(@statitemid_1 	int,
     @flag	int	output, 
     @msg	varchar(80)	output)

AS DELETE T_Statitem 

WHERE 
	( statitemid	 = @statitemid_1)
GO


alter table T_OutReport add outreptype       char(1) , outrepcategory char(1) default '0' 
GO

update T_OutReport set outrepcategory = '0' 
GO


alter PROCEDURE T_OutReport_SelectAll
	(@outrepcategory_1 char(1) ,
    @flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_OutReport where outrepcategory = @outrepcategory_1 
GO


alter PROCEDURE T_OutReport_Insert
	(@outrepname_1 	varchar(200),
	 @outreprow_2 	int,
	 @outrepcolumn_3 	int,
	 @outrepdesc_4 	varchar(255) ,
     @modulefilename_5  varchar(100) ,
     @outreptype_6 char(1) ,
     @outrepcategory_7 char(1) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_OutReport 
	 ( outrepname,
	 outreprow,
	 outrepcolumn,
	 outrepdesc,
     modulefilename,
     outreptype,
     outrepcategory) 
 
VALUES 
	( @outrepname_1,
	 @outreprow_2,
	 @outrepcolumn_3,
	 @outrepdesc_4,
     @modulefilename_5,
     @outreptype_6,
     @outrepcategory_7)
GO


alter PROCEDURE T_OutReport_Update
	(@outrepid_1 	int,
	 @outrepname_2 	varchar(200),
	 @outrepdesc_3 	varchar(255) ,
     @modulefilename_5  varchar(100) ,
     @outreptype_6 char(1) ,
     @outrepcategory_7 char(1) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS UPDATE T_OutReport 

SET  outrepname	 = @outrepname_2,
	 outrepdesc	 = @outrepdesc_3,
     modulefilename	 = @modulefilename_5 ,
     outreptype = @outreptype_6 ,
     outrepcategory = @outrepcategory_7 
WHERE 
	( outrepid	 = @outrepid_1)
GO


create table T_ReportStatitemTable (
itemtableid  int IDENTITY(1,1) primary key CLUSTERED,     
outrepid     int ,
itemtable   varchar(60) ,
itemtablealter  varchar(20) 
)
GO


CREATE PROCEDURE T_ReportStatitemTable_SById
	(@outrepid_1 int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_ReportStatitemTable where outrepid = @outrepid_1 
GO


CREATE PROCEDURE T_ReportStatitemTable_Insert
	(@outrepid_1 	int,
	 @itemtable_2     varchar(60),
	 @itemtablealter_3  varchar(20),
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 

INSERT INTO T_ReportStatitemTable 
	 ( outrepid,
	 itemtable,
	 itemtablealter) 
 
VALUES 
	( @outrepid_1,
	 @itemtable_2,
	 @itemtablealter_3)

GO


CREATE PROCEDURE T_ReportStatitemTable_Delete
	(@outrepid_1 	int,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 

Delete T_ReportStatitemTable where outrepid = @outrepid_1
GO


create table T_OutReportStatitem (
outrepitemid  int IDENTITY(1,1) primary key CLUSTERED,    
outrepid     int ,
statitemid   int ,
dsporder  int 
)
GO


CREATE PROCEDURE T_OutReportStatitem_SById
	(@outrepid_1 int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_OutReportStatitem where outrepid = @outrepid_1 order by dsporder 
GO


CREATE PROCEDURE T_OutReportStatitem_Insert
	(@outrepid_1 	int,
	 @statitemid_2     int,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
declare @maxdsporder int 
select @maxdsporder = max(dsporder) from T_OutReportStatitem where outrepid = @outrepid_1 
if @maxdsporder is null or @maxdsporder = 0 
    set @maxdsporder = 1 
else 
    set @maxdsporder = @maxdsporder + 1

INSERT INTO T_OutReportStatitem 
	 ( outrepid,
	 statitemid,
	 dsporder) 
 
VALUES 
	( @outrepid_1,
	 @statitemid_2,
	 @maxdsporder)
GO


CREATE PROCEDURE T_OutReportStatitem_Delete
	(@outrepitemid_1 	int,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
declare @thedsporder int , @theoutrepid int 
select @thedsporder = dsporder , @theoutrepid = outrepid 
from T_OutReportStatitem where outrepitemid = @outrepitemid_1

update T_OutReportStatitem set dsporder = dsporder-1 where outrepid = @theoutrepid and dsporder > @thedsporder 

Delete T_OutReportStatitem where outrepitemid = @outrepitemid_1
GO


CREATE PROCEDURE T_OutReportStatitem_Uorder
	(@outrepitemid_1 	int,
     @upordown  	int, 
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
declare @thedsporder int , @theoutrepid int 
select @thedsporder = dsporder , @theoutrepid = outrepid 
from T_OutReportStatitem where outrepitemid = @outrepitemid_1

if @upordown = 1 
begin
    update T_OutReportStatitem set dsporder = dsporder+1 where outrepid = @theoutrepid and dsporder = @thedsporder-1 
    update T_OutReportStatitem set dsporder = dsporder-1 where outrepitemid = @outrepitemid_1
end
else 
begin
    update T_OutReportStatitem set dsporder = dsporder-1 where outrepid = @theoutrepid and dsporder = @thedsporder+1 
    update T_OutReportStatitem set dsporder = dsporder+1 where outrepitemid = @outrepitemid_1
end
GO

alter PROCEDURE T_OutReport_Delete
	(@outrepid_1 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
DELETE T_OutReport WHERE ( outrepid	 = @outrepid_1)
DELETE T_OutReportCondition WHERE ( outrepid	 = @outrepid_1)
DELETE T_OutReportShare WHERE ( outrepid	 = @outrepid_1)
DELETE T_OutReportItem WHERE ( outrepid	 = @outrepid_1)
DELETE T_ReportStatitemTable WHERE ( outrepid	 = @outrepid_1)
DELETE T_OutReportStatitem WHERE ( outrepid	 = @outrepid_1)
GO

create table T_ReportStatSqlValue (
outrepid     int ,
sqlfromvalue   varchar(200) ,
sqlwherevalue  text 
)
GO
 

alter table T_InputReport add modulefilename  varchar(100) , helpdocid int 
GO


alter PROCEDURE T_InputReport_Insert
	(@inprepname_1 	varchar(200),
	 @inpreptablename_2 	varchar(60),
	 @inprepbugtablename_3 	varchar(60),
	 @inprepfrequence_4 	char(1),
	 @inprepbudget_5 	char(1),
	 @inprepforecast_6	char(1),
     @startdate_7	char(10),
     @enddate_8	char(10),
     @modulefilename_9	varchar(100),
     @helpdocid_10	int,
	 @flag	int	output, 
	 @msg	varchar(80)	output)

AS INSERT INTO T_InputReport 
	 ( inprepname,
	 inpreptablename,
	 inprepbugtablename,
	 inprepfrequence,
	 inprepbudget,
	 inprepforecast,
     startdate,
     enddate,
     modulefilename,
     helpdocid) 
 
VALUES 
	( @inprepname_1,
	 @inpreptablename_2,
	 @inprepbugtablename_3,
	 @inprepfrequence_4,
	 @inprepbudget_5,
	 @inprepforecast_6,
     @startdate_7,
     @enddate_8,
     @modulefilename_9,
     @helpdocid_10)
GO

alter PROCEDURE T_InputReport_Update
	(@inprepid_1 	int,
	 @inprepname_2 	varchar(200),
	 @inpreptablename_3 	varchar(60),
	 @inprepbugtablename_4 	varchar(60),
	 @inprepfrequence_5 	char(1),
	 @inprepbudget_6 	char(1),
	 @inprepforecast_7	char(1),
     @startdate_8	char(10),
     @enddate_9	char(10),
     @modulefilename_10	varchar(100),
     @helpdocid_11	int,
	 @flag	int	output, 
	 @msg	varchar(80)	output)

AS UPDATE T_InputReport 

SET  inprepname	 = @inprepname_2,
	 inpreptablename	 = @inpreptablename_3,
	 inprepbugtablename	 = @inprepbugtablename_4,
	 inprepfrequence	 = @inprepfrequence_5,
	 inprepbudget	 = @inprepbudget_6 ,
	 inprepforecast	 = @inprepforecast_7 , 
     startdate	 = @startdate_8 , 
     enddate	 = @enddate_9 ,
     modulefilename	 = @modulefilename_10 ,
     helpdocid	 = @helpdocid_11 

WHERE 
	( inprepid	 = @inprepid_1)
GO

alter PROCEDURE T_OutReport_Copy
	(@outrepid_1 	int,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
declare @newoutrepid_1 int
declare @theoutrepcategory_1 int
declare @itemid_1 int
declare @newitemid_1 int
declare @moduleid_1 int
declare @newmoduleid_1 int

select @theoutrepcategory_1 = outrepcategory from T_OutReport where outrepid = @outrepid_1 

INSERT INTO T_OutReport( outrepname,  outreprow , outrepcolumn , outrepdesc , modulefilename , outreptype , outrepcategory )
( select '复制_'+outrepname,  outreprow , outrepcolumn , outrepdesc , modulefilename , outreptype , outrepcategory from T_OutReport where outrepid = @outrepid_1 ) 

select @newoutrepid_1 = max(outrepid) from T_OutReport 

INSERT INTO T_OutReportCondition( outrepid,  conditionid )
( select @newoutrepid_1,  conditionid from T_OutReportCondition where outrepid = @outrepid_1 ) 

INSERT INTO T_OutReportShare( outrepid,  userid , usertype )
( select @newoutrepid_1,  userid,  usertype from T_OutReportShare where outrepid = @outrepid_1 ) 

declare module_cursor cursor for 
select id from outrepmodule where outrepid = @outrepid_1
open module_cursor 
fetch next from module_cursor into @moduleid_1 
while @@fetch_status=0 
begin 
    INSERT INTO outrepmodule( outrepid,  modulename , moduledesc , userid , usertype ) 
    ( select @newoutrepid_1,  modulename,  moduledesc , userid , usertype from outrepmodule where id = @moduleid_1 ) 
    select @newmoduleid_1 = max( id ) from outrepmodule 
    INSERT INTO modulecondition( moduleid,  conditionid , conditionname , isuserdefine , conditionvalue )
    ( select @newmoduleid_1,  conditionid , conditionname , isuserdefine , conditionvalue from modulecondition where moduleid = @moduleid_1 ) 
    fetch next from module_cursor into @moduleid_1 
end 
close module_cursor 
deallocate module_cursor


if @theoutrepcategory_1 = 0 
begin
    INSERT INTO T_OutReportItemRow( outrepid,  itemrow )
    ( select @newoutrepid_1,  itemrow from T_OutReportItemRow where outrepid = @outrepid_1 ) 

    declare itemid_cursor cursor for 
    select itemid from T_OutReportItem where outrepid = @outrepid_1
    open itemid_cursor 
    fetch next from itemid_cursor into @itemid_1 
    while @@fetch_status=0 
    begin 
        INSERT INTO T_OutReportItem( outrepid,  itemrow , itemcolumn , itemtype , picstat, itemexpress, itemtable,
        itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast , itemmodtype )
        ( select @newoutrepid_1,  itemrow , itemcolumn , itemtype , picstat, itemexpress, itemtable,
        itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast , itemmodtype 
        from T_OutReportItem where itemid = @itemid_1 ) 

        select @newitemid_1 = max( itemid ) from T_OutReportItem 
        
        INSERT INTO T_OutReportItemTable( itemid,  itemtable , itemtablealter )
        ( select @newitemid_1,  itemtable,  itemtablealter from T_OutReportItemTable where itemid = @itemid_1 ) 

        INSERT INTO T_OutReportItemCondition( itemid,  conditionid , conditionvalue )
        ( select @newitemid_1,  conditionid,  conditionvalue from T_OutReportItemCondition where itemid = @itemid_1 ) 

        INSERT INTO T_OutReportItemCoordinate( itemid,  coordinatename , coordinatevalue )
        ( select @newitemid_1,  coordinatename,  coordinatevalue from T_OutReportItemCoordinate where itemid = @itemid_1 ) 
        
        fetch next from itemid_cursor into @itemid_1 
    end 
    close itemid_cursor 
    deallocate itemid_cursor
end
else
begin
    INSERT INTO T_OutReportStatitem( outrepid,  statitemid , dsporder )
    ( select @newoutrepid_1,  statitemid,  dsporder from T_OutReportStatitem where outrepid = @outrepid_1 ) 
end
GO

alter table T_InputReportItemtype add dsporder  int  
GO

alter PROCEDURE T_InputReportItemtype_SelectByInprepid
	(@inprepid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_InputReportItemtype where inprepid = @inprepid_1 order by dsporder
GO

alter PROCEDURE T_InputReportItemtype_Insert
	(@inprepid_1 	int,
	 @itemtypename_2 	varchar(100),
	 @itemtypedesc_3 	varchar(200) ,
     @dsporder_4 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_InputReportItemtype 
	 ( inprepid,
	 itemtypename,
	 itemtypedesc,
     dsporder) 
 
VALUES 
	( @inprepid_1,
	 @itemtypename_2,
	 @itemtypedesc_3,
     @dsporder_4)
GO

alter PROCEDURE T_InputReportItemtype_Update
	(@itemtypeid_1 	int,
	 @itemtypename_2 	varchar(100),
	 @itemtypedesc_3 	varchar(200),
     @dsporder_4 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS UPDATE T_InputReportItemtype 

SET  itemtypename	 = @itemtypename_2,
	 itemtypedesc	 = @itemtypedesc_3 ,
     dsporder	 = @dsporder_4 

WHERE 
	( itemtypeid	 = @itemtypeid_1)
GO

alter table T_OutReport add enmodulefilename  varchar(100)   
GO

alter table T_OutReportCondition add conditioncnname  varchar(100)   
GO
alter table T_OutReportCondition add conditionenname  varchar(100)  
GO


alter PROCEDURE T_OutReport_Insert
	(@outrepname_1 	varchar(200),
	 @outreprow_2 	int,
	 @outrepcolumn_3 	int,
	 @outrepdesc_4 	varchar(255) ,
     @modulefilename_5  varchar(100) ,
     @outreptype_6 char(1) ,
     @outrepcategory_7 char(1) ,
     @enmodulefilename_8  varchar(100) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_OutReport 
	 ( outrepname,
	 outreprow,
	 outrepcolumn,
	 outrepdesc,
     modulefilename,
     outreptype,
     outrepcategory,
     enmodulefilename) 
 
VALUES 
	( @outrepname_1,
	 @outreprow_2,
	 @outrepcolumn_3,
	 @outrepdesc_4,
     @modulefilename_5,
     @outreptype_6,
     @outrepcategory_7,
     @enmodulefilename_8)
GO

alter PROCEDURE T_OutReport_Update
	(@outrepid_1 	int,
	 @outrepname_2 	varchar(200),
	 @outrepdesc_3 	varchar(255) ,
     @modulefilename_5  varchar(100) ,
     @outreptype_6 char(1) ,
     @outrepcategory_7 char(1) ,
     @enmodulefilename_8  varchar(100) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS UPDATE T_OutReport 

SET  outrepname	 = @outrepname_2,
	 outrepdesc	 = @outrepdesc_3,
     modulefilename	 = @modulefilename_5 ,
     outreptype = @outreptype_6 ,
     outrepcategory = @outrepcategory_7 ,
     enmodulefilename	 = @enmodulefilename_8 
WHERE 
	( outrepid	 = @outrepid_1)
GO

alter PROCEDURE T_OutReportCondition_Insert
	(@outrepid_1 	int,
	 @conditionid_2 	int ,
     @conditioncnname_3 	varchar(100) ,
     @conditionenname_4 	varchar(100) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_OutReportCondition 
	 ( outrepid,
	 conditionid,
     conditioncnname ,
     conditionenname) 
 
VALUES 
	( @outrepid_1,
	 @conditionid_2,
     @conditioncnname_3,
     @conditionenname_4)
GO


alter table T_InputReportItem add itemgongsi  text , inputablefact char(1), 
                                  inputablebudg char(1), inputablefore char(1)      
GO

update T_InputReportItem set inputablefact = '1' , inputablebudg = '1' , inputablefore = '1' 
GO

update T_InputReportItem set inputablefact = '0' where itemfieldtype = '5'
GO

update T_InputReportItem set itemgongsi = itemexcelsheet , itemexcelsheet = '' where itemfieldtype = '5'
GO

alter PROCEDURE T_InputReportItem_Insert
	(@inprepid_1 	int,
	 @itemdspname_2 	varchar(60),
	 @itemfieldname_3 	varchar(60),
	 @itemfieldtype_4 	char(1),
	 @itemfieldscale_5 	int,
	 @itemtypeid_6 	int,
	 @itemexcelsheet_7 	varchar(100),
	 @itemexcelrow_8 	int,
	 @itemexcelcolumn_9 	int ,
	 @itemfieldunit_10   varchar(60) ,
	 @dsporder_11        int ,
     @itemgongsi_12 	text,
     @inputablefact_13 	char(1),
     @inputablebudg_14 	char(1),
     @inputablefore_15 	char(1),
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 

INSERT INTO T_InputReportItem 
	 ( inprepid,
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
	( @inprepid_1,
	 @itemdspname_2,
	 @itemfieldname_3,
	 @itemfieldtype_4,
	 @itemfieldscale_5,
	 @itemtypeid_6,
	 @itemexcelsheet_7,
	 @itemexcelrow_8,
	 @itemexcelcolumn_9,
	 @itemfieldunit_10,
	 @dsporder_11,
     @itemgongsi_12,
     @inputablefact_13,
     @inputablebudg_14,
     @inputablefore_15)
GO


alter PROCEDURE T_InputReportItem_Update
	(@itemid_1 	int,
	 @itemdspname_2 	varchar(60),
	 @itemfieldname_3 	varchar(60),
	 @itemfieldtype_4 	char(1),
	 @itemfieldscale_5 	int,
	 @itemtypeid_6 	int,
	 @itemexcelsheet_7 	varchar(100),
	 @itemexcelrow_8 	int,
	 @itemexcelcolumn_9 	int ,
	 @itemfieldunit_10   varchar(60) ,
	 @dsporder_11        int ,
     @itemgongsi_12 	text,
     @inputablefact_13 	char(1),
     @inputablebudg_14 	char(1),
     @inputablefore_15 	char(1),
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS UPDATE T_InputReportItem 

SET  itemdspname	 = @itemdspname_2,
	 itemfieldname	 = @itemfieldname_3,
	 itemfieldtype	 = @itemfieldtype_4,
	 itemfieldscale	 = @itemfieldscale_5,
	 itemtypeid	 = @itemtypeid_6,
	 itemexcelsheet	 = @itemexcelsheet_7,
	 itemexcelrow	 = @itemexcelrow_8,
	 itemexcelcolumn	 = @itemexcelcolumn_9 ,
	 itemfieldunit = @itemfieldunit_10 ,
	 dsporder = @dsporder_11 ,
     itemgongsi = @itemgongsi_12 ,
     inputablefact = @inputablefact_13 ,
     inputablebudg = @inputablebudg_14 ,
     inputablefore = @inputablefore_15 

WHERE 
	( itemid	 = @itemid_1)
GO
 
alter PROCEDURE T_InputReportItem_SelectByInprepid
	(@inprepid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_InputReportItem where inprepid = @inprepid_1 order by dsporder
GO

update T_Condition set conditionname = '填报修正' , conditiondesc = '填报修正' where conditionitemfieldname = 'modify' 
GO

insert into T_Condition values('月修正','月修正','monthmodify',null,'1')
GO

insert into T_Condition values('年修正','年修正','yearmodify',null,'1')
GO

create table T_InputReportCrmModer (                
inprepcontacterid  int IDENTITY(1,1) primary key CLUSTERED,       
inprepcrmid     int ,
contacterid        int 
)
GO

alter table T_OutReportItem add firstaltertablename varchar(10)
GO

delete T_ReportStatSqlValue
GO

alter PROCEDURE T_OutReportStatitem_Uorder
	(@outrepitemid_1 	int,
     @upordown  	int, 
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
declare @thedsporder int , @theoutrepid int 
select @thedsporder = dsporder , @theoutrepid = outrepid 
from T_OutReportStatitem where outrepitemid = @outrepitemid_1

if @upordown = 1 
begin
    update T_OutReportStatitem set dsporder = dsporder+1 where outrepid = @theoutrepid and dsporder = @thedsporder-1 
    update T_OutReportStatitem set dsporder = dsporder-1 where outrepitemid = @outrepitemid_1
end
else 
begin
    update T_OutReportStatitem set dsporder = dsporder-1 where outrepid = @theoutrepid and dsporder = @thedsporder+1 
    update T_OutReportStatitem set dsporder = dsporder+1 where outrepitemid = @outrepitemid_1
end
GO

alter table T_OutReportStatitem 
add needthismonth char(1) , 
needthisyear char(1) , 
needlastmonth char(1) , 
needlastyear char(1)
go

alter table T_OutReport add outrepenname  varchar(100)  
GO


alter PROCEDURE T_OutReport_Insert
	(@outrepname_1 	varchar(200),
	 @outreprow_2 	int,
	 @outrepcolumn_3 	int,
	 @outrepdesc_4 	varchar(255) ,
     @modulefilename_5  varchar(100) ,
     @outreptype_6 char(1) ,
     @outrepcategory_7 char(1) ,
     @enmodulefilename_8  varchar(100) ,
     @outrepenname_9  varchar(100) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_OutReport 
	 ( outrepname,
	 outreprow,
	 outrepcolumn,
	 outrepdesc,
     modulefilename,
     outreptype,
     outrepcategory,
     enmodulefilename,
     outrepenname) 
 
VALUES 
	( @outrepname_1,
	 @outreprow_2,
	 @outrepcolumn_3,
	 @outrepdesc_4,
     @modulefilename_5,
     @outreptype_6,
     @outrepcategory_7,
     @enmodulefilename_8,
     @outrepenname_9 )
GO


alter PROCEDURE T_OutReport_Update
	(@outrepid_1 	int,
	 @outrepname_2 	varchar(200),
	 @outrepdesc_3 	varchar(255) ,
     @modulefilename_5  varchar(100) ,
     @outreptype_6 char(1) ,
     @outrepcategory_7 char(1) ,
     @enmodulefilename_8  varchar(100) ,
     @outrepenname_9  varchar(100) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS UPDATE T_OutReport 

SET  outrepname	 = @outrepname_2,
	 outrepdesc	 = @outrepdesc_3,
     modulefilename	 = @modulefilename_5 ,
     outreptype = @outreptype_6 ,
     outrepcategory = @outrepcategory_7 ,
     enmodulefilename	 = @enmodulefilename_8 ,
     outrepenname	 = @outrepenname_9 
WHERE 
	( outrepid	 = @outrepid_1)
GO


alter table outrepmodule add moduleenname  varchar(100)   
GO


alter PROCEDURE T_outrepmodule_Insert
(@outrepid_1 int,
@modulename_2 varchar(100),
@moduledesc_3 varchar(200),
@userid_4 int,
@usertype_5 int,
@moduleenname_6 varchar(100),
@flag	int	output, 
@msg	varchar(80)	output) 

AS INSERT INTO outrepmodule
 ( outrepid,
 modulename,
 moduledesc,
 userid,
 usertype,
 moduleenname) 
 
VALUES 
(@outrepid_1,
 @modulename_2,
 @moduledesc_3,
 @userid_4,
 @usertype_5,
 @moduleenname_6) 
select max(id) from outrepmodule
GO


alter PROCEDURE T_outrepmodule_Update
	(@id_1 	int,
	 @modulename_2 	varchar(100),
	 @moduledesc_3 	varchar(200),
     @moduleenname_4 varchar(100),
     @flag	int	output, 
     @msg	varchar(80)	output) 

AS UPDATE outrepmodule 

SET  modulename	 = @modulename_2,
	 moduledesc	 = @moduledesc_3,
     moduleenname	 = @moduleenname_4 
WHERE 
	( id	 = @id_1)
GO


alter table T_ConditionDetail add conditionendsp  varchar(100)   
GO


alter PROCEDURE T_ConditionDetail_Insert
	(@conditionid_1 	int,
	 @conditiondsp_2 	varchar(100),
	 @conditionvalue_3 	varchar(100) ,
     @conditionendsp_4 	varchar(100),
	 @flag	int	output, 
	 @msg	varchar(80)	output) 

AS INSERT INTO T_ConditionDetail 
	 ( conditionid,
	 conditiondsp,
	 conditionvalue,
     conditionendsp) 
 
VALUES 
	( @conditionid_1,
	 @conditiondsp_2,
	 @conditionvalue_3,
     @conditionendsp_4)
GO


delete T_ReportStatSqlValue
GO

alter table T_ReportStatSqlValue alter column sqlfromvalue   text
GO

alter table T_OutReport add outrependesc  varchar(100)  
GO

alter PROCEDURE T_OutReport_Insert
	(@outrepname_1 	varchar(200),
	 @outreprow_2 	int,
	 @outrepcolumn_3 	int,
	 @outrepdesc_4 	varchar(255) ,
     @modulefilename_5  varchar(100) ,
     @outreptype_6 char(1) ,
     @outrepcategory_7 char(1) ,
     @enmodulefilename_8  varchar(100) ,
     @outrepenname_9  varchar(100) ,
     @outrependesc_10  varchar(100) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_OutReport 
	 ( outrepname,
	 outreprow,
	 outrepcolumn,
	 outrepdesc,
     modulefilename,
     outreptype,
     outrepcategory,
     enmodulefilename,
     outrepenname,
     outrependesc) 
 
VALUES 
	( @outrepname_1,
	 @outreprow_2,
	 @outrepcolumn_3,
	 @outrepdesc_4,
     @modulefilename_5,
     @outreptype_6,
     @outrepcategory_7,
     @enmodulefilename_8,
     @outrepenname_9 ,
     @outrependesc_10 )
GO


alter PROCEDURE T_OutReport_Update
	(@outrepid_1 	int,
	 @outrepname_2 	varchar(200),
	 @outrepdesc_3 	varchar(255) ,
     @modulefilename_5  varchar(100) ,
     @outreptype_6 char(1) ,
     @outrepcategory_7 char(1) ,
     @enmodulefilename_8  varchar(100) ,
     @outrepenname_9  varchar(100) ,
     @outrependesc_10 varchar(100) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS UPDATE T_OutReport 

SET  outrepname	 = @outrepname_2,
	 outrepdesc	 = @outrepdesc_3,
     modulefilename	 = @modulefilename_5 ,
     outreptype = @outreptype_6 ,
     outrepcategory = @outrepcategory_7 ,
     enmodulefilename	 = @enmodulefilename_8 ,
     outrepenname	 = @outrepenname_9 ,
     outrependesc	 = @outrependesc_10 
WHERE 
	( outrepid	 = @outrepid_1)
GO

alter PROCEDURE T_OutReport_Copy
	(@outrepid_1 	int,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
declare @newoutrepid_1 int
declare @theoutrepcategory_1 int
declare @itemid_1 int
declare @newitemid_1 int
declare @moduleid_1 int
declare @newmoduleid_1 int

select @theoutrepcategory_1 = outrepcategory from T_OutReport where outrepid = @outrepid_1 

INSERT INTO T_OutReport( outrepname,  outreprow , outrepcolumn , outrepdesc , modulefilename , outreptype , outrepcategory ,enmodulefilename,outrepenname,outrependesc )
( select '复制_'+outrepname,  outreprow , outrepcolumn , outrepdesc , modulefilename , outreptype , outrepcategory  ,enmodulefilename,outrepenname,outrependesc from T_OutReport where outrepid = @outrepid_1 ) 

select @newoutrepid_1 = max(outrepid) from T_OutReport 

INSERT INTO T_OutReportCondition( outrepid,  conditionid , conditioncnname, conditionenname )
( select @newoutrepid_1,  conditionid , conditioncnname, conditionenname from T_OutReportCondition where outrepid = @outrepid_1 ) 

INSERT INTO T_OutReportShare( outrepid,  userid , usertype )
( select @newoutrepid_1,  userid,  usertype from T_OutReportShare where outrepid = @outrepid_1 ) 

declare module_cursor cursor for 
select id from outrepmodule where outrepid = @outrepid_1
open module_cursor 
fetch next from module_cursor into @moduleid_1 
while @@fetch_status=0 
begin 
    INSERT INTO outrepmodule( outrepid,  modulename , moduledesc , userid , usertype , moduleenname ) 
    ( select @newoutrepid_1,  modulename,  moduledesc , userid , usertype , moduleenname from outrepmodule where id = @moduleid_1 ) 
    select @newmoduleid_1 = max( id ) from outrepmodule 
    INSERT INTO modulecondition( moduleid,  conditionid , conditionname , isuserdefine , conditionvalue )
    ( select @newmoduleid_1,  conditionid , conditionname , isuserdefine , conditionvalue from modulecondition where moduleid = @moduleid_1 ) 
    fetch next from module_cursor into @moduleid_1 
end 
close module_cursor 
deallocate module_cursor


if @theoutrepcategory_1 = 0 or @theoutrepcategory_1 = 2 
begin
    INSERT INTO T_OutReportItemRow( outrepid,  itemrow )
    ( select @newoutrepid_1,  itemrow from T_OutReportItemRow where outrepid = @outrepid_1 ) 

    declare itemid_cursor cursor for 
    select itemid from T_OutReportItem where outrepid = @outrepid_1
    open itemid_cursor 
    fetch next from itemid_cursor into @itemid_1 
    while @@fetch_status=0 
    begin 
        INSERT INTO T_OutReportItem( outrepid,  itemrow , itemcolumn , itemtype , picstat, itemexpress, itemtable,
        itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast , itemmodtype )
        ( select @newoutrepid_1,  itemrow , itemcolumn , itemtype , picstat, itemexpress, itemtable,
        itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast , itemmodtype 
        from T_OutReportItem where itemid = @itemid_1 ) 

        select @newitemid_1 = max( itemid ) from T_OutReportItem 
        
        INSERT INTO T_OutReportItemTable( itemid,  itemtable , itemtablealter )
        ( select @newitemid_1,  itemtable,  itemtablealter from T_OutReportItemTable where itemid = @itemid_1 ) 

        INSERT INTO T_OutReportItemCondition( itemid,  conditionid , conditionvalue )
        ( select @newitemid_1,  conditionid,  conditionvalue from T_OutReportItemCondition where itemid = @itemid_1 ) 

        INSERT INTO T_OutReportItemCoordinate( itemid,  coordinatename , coordinatevalue )
        ( select @newitemid_1,  coordinatename,  coordinatevalue from T_OutReportItemCoordinate where itemid = @itemid_1 ) 
        
        fetch next from itemid_cursor into @itemid_1 
    end 
    close itemid_cursor 
    deallocate itemid_cursor
end
else
begin
    INSERT INTO T_OutReportStatitem( outrepid,  statitemid , dsporder )
    ( select @newoutrepid_1,  statitemid,  dsporder from T_OutReportStatitem where outrepid = @outrepid_1 ) 
end
GO

alter table T_OutReportItem add itemendesc varchar(200) 
GO

alter PROCEDURE T_OutReportItem_Insert
	(@itemid_1 	int,
	 @outrepid_2 	int,
	 @itemrow_2 	int,
	 @itemcolumn_2 	int,
	 @itemtype       char(1),
	 @itemexpress    text ,
	 @itemdesc       varchar(200),
	 @itemexpresstype char(1) ,
	 @picstatbudget char(1) ,
	 @picstatlast   char(1) ,
	 @picstat       char(1) ,
	 @itemmodtype       char(1) ,
	 @itemendesc       varchar(200),
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
if @itemid_1 = 0
begin
insert into T_OutReportItem(outrepid,itemrow,itemcolumn,itemtype,itemexpress,itemdesc, itemexpresstype, picstatbudget, picstatlast, picstat,itemtable,itemcondition,itemmodtype,itemendesc) 
values(@outrepid_2, @itemrow_2, @itemcolumn_2, @itemtype, @itemexpress, @itemdesc, @itemexpresstype, @picstatbudget, @picstatlast, @picstat, '', '', @itemmodtype, @itemendesc)
select @itemid_1 = max(itemid) from T_OutReportItem
end

else 
begin
update T_OutReportItem set itemtype = @itemtype , itemexpress = @itemexpress , itemdesc = @itemdesc , 
                           itemexpresstype = @itemexpresstype , picstatbudget = @picstatbudget , 
                           picstatlast = @picstatlast , picstat = @picstat  , itemtable = ''  , 
                           itemcondition = '' , itemmodtype=@itemmodtype , itemendesc = @itemendesc 
                           where itemid = @itemid_1
end

DELETE T_OutReportItemTable WHERE  ( itemid	 = @itemid_1)
DELETE T_OutReportItemCondition WHERE  ( itemid	 = @itemid_1)
DELETE T_OutReportItemCoordinate WHERE  ( itemid	 = @itemid_1)

select @itemid_1 
GO


alter PROCEDURE T_OutReportItem_Copy
	(@outrepid_2 	int,
	 @itemrow_2 	int,
	 @itemcolumn_2 	int,
	 @fromitemrow_2      int,
	 @fromitemcolumn_2    int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS
declare @itemid int , @itemid1 int , @itemtype char(1)

select @itemid = itemid , @itemtype = itemtype from T_OutReportItem where itemrow = @fromitemrow_2 and itemcolumn = @fromitemcolumn_2 and outrepid = @outrepid_2

if @itemid is null
return

select @itemid1 = itemid from T_OutReportItem where itemrow = @itemrow_2 and itemcolumn = @itemcolumn_2 and outrepid = @outrepid_2

if @itemid1 is not null
begin
delete T_OutReportItem where itemid = @itemid1
delete T_OutReportItemTable where itemid = @itemid1
delete T_OutReportItemCondition where itemid = @itemid1
delete T_OutReportItemCoordinate where itemid = @itemid1
end

insert into T_OutReportItem( outrepid, itemrow, itemcolumn, itemtype, itemexpress, itemtable, itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast, picstat , itemendesc) select outrepid, @itemrow_2, @itemcolumn_2, itemtype, itemexpress, itemtable, itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast, picstat , itemendesc from T_OutReportItem where itemid = @itemid

if @itemtype = '2' 
begin
	select @itemid1 = max(itemid) from T_OutReportItem

	insert into T_OutReportItemTable(itemid,itemtable,itemtablealter) select @itemid1, itemtable, itemtablealter from T_OutReportItemTable where itemid = @itemid 

	insert into T_OutReportItemCondition(itemid,conditionid,conditionvalue) select @itemid1, conditionid, conditionvalue from T_OutReportItemCondition where itemid = @itemid 

	insert into T_OutReportItemCoordinate(itemid,coordinatename,coordinatevalue) select @itemid1, coordinatename, coordinatevalue from T_OutReportItemCoordinate where itemid = @itemid 
end

GO

alter table T_Statitem add statitemenname 	varchar(200) 
GO


alter PROCEDURE T_Statitem_Insert
	(@statitemname_1 	varchar(100),
	 @statitemexpress_2 	varchar(200),
	 @statitemdesc_3 	varchar(100),
     @statitemenname_4 	varchar(200),
     @flag	int	output, 
     @msg	varchar(80)	output)

AS INSERT INTO T_Statitem 
	 ( statitemname,
	 statitemexpress,
	 statitemdesc,
     statitemenname) 
 
VALUES 
	( @statitemname_1,
	 @statitemexpress_2,
	 @statitemdesc_3,
     @statitemenname_4)
GO


alter PROCEDURE T_Statitem_Update
	(@statitemid_1 	int,
	 @statitemname_2 	varchar(100),
	 @statitemexpress_3 	varchar(200),
	 @statitemdesc_4 	varchar(100),
     @statitemenname_5 	varchar(200),
     @flag	int	output, 
     @msg	varchar(80)	output)

AS UPDATE T_Statitem 

SET  statitemname	 = @statitemname_2,
	 statitemexpress	 = @statitemexpress_3,
	 statitemdesc	 = @statitemdesc_4 ,
     statitemenname	 = @statitemenname_5

WHERE 
	( statitemid	 = @statitemid_1)
GO


create table T_InputReportCrmSel (               
inprepcontacterid  int IDENTITY(1,1) primary key CLUSTERED,     
inprepcrmid     int ,
contacterid        int ,
selcrm          varchar(200)
)
GO

drop PROCEDURE T_InputReportConfirm_SelectByCrmid
GO


create PROCEDURE T_InputReportConfirm_SByUID
(@crmid_1  int ,
@contactid_2  varchar(200) ,
@flag	int	output, 
@msg	varchar(80)	output) 
AS 
    Declare @inprepid_1 int, @selcrm_1 varchar(200)
    Declare @temptablevalue  table (
                                inprepname varchar(200) ,
                                confirmid  int ,    
                                inprepid              int ,
                                inprepbudget          char(1) ,
                                thetable             varchar(60) ,
                                inputid		     int ,
                                inprepdspdate         varchar(80) ,
                                crmid              int ,
                                confirmuserid           int ,
                                reportuserid int
                              )

insert into @temptablevalue select a.inprepname , b.* 
from T_InputReport a, T_InputReportConfirm b , T_InputReportCrm c 
where a.inprepid = b.inprepid and b.inprepid=c.inprepid and b.crmid=c.crmid and b.crmid = @crmid_1 

declare inputcrm_cursor cursor for
select distinct a.inprepid , b.selcrm from T_InputReportCrm a , T_InputReportCrmSel b 
where a.inprepcrmid = b.inprepcrmid and b.contacterid = @contactid_2 
open inputcrm_cursor 
fetch next from inputcrm_cursor into @inprepid_1 , @selcrm_1
while @@fetch_status=0
begin 
    insert into @temptablevalue select a.inprepname , b.* 
          from T_InputReport a, T_InputReportConfirm b 
          where a.inprepid = b.inprepid and b.inprepid = @inprepid_1  
          and (','+@selcrm_1+',') like ('%,'+convert(varchar(10),b.crmid) + ',%') 
    fetch next from inputcrm_cursor into @inprepid_1 , @selcrm_1
end
close inputcrm_cursor deallocate inputcrm_cursor

select * from @temptablevalue order by inprepid , inputid 
GO

alter table T_InputReportCrmSel alter column selcrm  varchar(1000)
GO

create table T_OutReportItemRowGroup (
outrepid       int ,  
itemrow	 int ,
rowgroup  varchar(1000)  
)
GO


alter table T_OutReportShare add sharelevel int not null default 0 
GO


alter PROCEDURE T_OutReport_Copy
	(@outrepid_1 	int,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
declare @newoutrepid_1 int
declare @theoutrepcategory_1 int
declare @itemid_1 int
declare @newitemid_1 int
declare @moduleid_1 int
declare @newmoduleid_1 int

select @theoutrepcategory_1 = outrepcategory from T_OutReport where outrepid = @outrepid_1 

INSERT INTO T_OutReport( outrepname,  outreprow , outrepcolumn , outrepdesc , modulefilename , outreptype , outrepcategory )
( select '复制_'+outrepname,  outreprow , outrepcolumn , outrepdesc , modulefilename , outreptype , outrepcategory from T_OutReport where outrepid = @outrepid_1 ) 

select @newoutrepid_1 = max(outrepid) from T_OutReport 

INSERT INTO T_OutReportCondition( outrepid,  conditionid )
( select @newoutrepid_1,  conditionid from T_OutReportCondition where outrepid = @outrepid_1 ) 

INSERT INTO T_OutReportShare( outrepid,  userid , usertype , sharelevel)
( select @newoutrepid_1,  userid,  usertype , sharelevel from T_OutReportShare where outrepid = @outrepid_1 ) 

declare module_cursor cursor for 
select id from outrepmodule where outrepid = @outrepid_1
open module_cursor 
fetch next from module_cursor into @moduleid_1 
while @@fetch_status=0 
begin 
    INSERT INTO outrepmodule( outrepid,  modulename , moduledesc , userid , usertype ) 
    ( select @newoutrepid_1,  modulename,  moduledesc , userid , usertype from outrepmodule where id = @moduleid_1 ) 
    select @newmoduleid_1 = max( id ) from outrepmodule 
    INSERT INTO modulecondition( moduleid,  conditionid , conditionname , isuserdefine , conditionvalue )
    ( select @newmoduleid_1,  conditionid , conditionname , isuserdefine , conditionvalue from modulecondition where moduleid = @moduleid_1 ) 
    fetch next from module_cursor into @moduleid_1 
end 
close module_cursor 
deallocate module_cursor


if @theoutrepcategory_1 = 0 
begin
    INSERT INTO T_OutReportItemRow( outrepid,  itemrow )
    ( select @newoutrepid_1,  itemrow from T_OutReportItemRow where outrepid = @outrepid_1 ) 

    declare itemid_cursor cursor for 
    select itemid from T_OutReportItem where outrepid = @outrepid_1
    open itemid_cursor 
    fetch next from itemid_cursor into @itemid_1 
    while @@fetch_status=0 
    begin 
        INSERT INTO T_OutReportItem( outrepid,  itemrow , itemcolumn , itemtype , picstat, itemexpress, itemtable,
        itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast , itemmodtype )
        ( select @newoutrepid_1,  itemrow , itemcolumn , itemtype , picstat, itemexpress, itemtable,
        itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast , itemmodtype 
        from T_OutReportItem where itemid = @itemid_1 ) 

        select @newitemid_1 = max( itemid ) from T_OutReportItem 
        
        INSERT INTO T_OutReportItemTable( itemid,  itemtable , itemtablealter )
        ( select @newitemid_1,  itemtable,  itemtablealter from T_OutReportItemTable where itemid = @itemid_1 ) 

        INSERT INTO T_OutReportItemCondition( itemid,  conditionid , conditionvalue )
        ( select @newitemid_1,  conditionid,  conditionvalue from T_OutReportItemCondition where itemid = @itemid_1 ) 

        INSERT INTO T_OutReportItemCoordinate( itemid,  coordinatename , coordinatevalue )
        ( select @newitemid_1,  coordinatename,  coordinatevalue from T_OutReportItemCoordinate where itemid = @itemid_1 ) 
        
        fetch next from itemid_cursor into @itemid_1 
    end 
    close itemid_cursor 
    deallocate itemid_cursor
end
else
begin
    INSERT INTO T_OutReportStatitem( outrepid,  statitemid , dsporder )
    ( select @newoutrepid_1,  statitemid,  dsporder from T_OutReportStatitem where outrepid = @outrepid_1 ) 
end
GO


alter table T_OutReport add autocolumn  char(1) , autorow  char(1)   
GO


alter PROCEDURE T_OutReport_Insert
	(@outrepname_1 	varchar(200),
	 @outreprow_2 	int,
	 @outrepcolumn_3 	int,
	 @outrepdesc_4 	varchar(255) ,
     @modulefilename_5  varchar(100) ,
     @outreptype_6 char(1) ,
     @outrepcategory_7 char(1) ,
     @enmodulefilename_8  varchar(100) ,
     @outrepenname_9  varchar(100) ,
     @outrependesc_10  varchar(100) ,
     @autocolumn_11 char(1) ,
     @autorow_12 char(1) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_OutReport 
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
	( @outrepname_1,
	 @outreprow_2,
	 @outrepcolumn_3,
	 @outrepdesc_4,
     @modulefilename_5,
     @outreptype_6,
     @outrepcategory_7,
     @enmodulefilename_8,
     @outrepenname_9 ,
     @outrependesc_10 ,
     @autocolumn_11,
     @autorow_12)
GO



alter PROCEDURE T_OutReport_Update
	(@outrepid_1 	int,
	 @outrepname_2 	varchar(200),
	 @outrepdesc_3 	varchar(255) ,
     @modulefilename_5  varchar(100) ,
     @outreptype_6 char(1) ,
     @outrepcategory_7 char(1) ,
     @enmodulefilename_8  varchar(100) ,
     @outrepenname_9  varchar(100) ,
     @outrependesc_10  varchar(100) ,
     @autocolumn_11 char(1) ,
     @autorow_12 char(1) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS UPDATE T_OutReport 

SET  outrepname	 = @outrepname_2,
	 outrepdesc	 = @outrepdesc_3,
     modulefilename	 = @modulefilename_5 ,
     outreptype = @outreptype_6 ,
     outrepcategory = @outrepcategory_7 ,
     enmodulefilename	 = @enmodulefilename_8 ,
     outrepenname	 = @outrepenname_9 ,
     outrependesc	 = @outrependesc_10 ,
     autocolumn	 = @autocolumn_11 ,
     autorow	 = @autorow_12 
WHERE 
	( outrepid	 = @outrepid_1)
GO

update T_OutReport set autocolumn = '0' , autorow = '0'
GO

alter PROCEDURE T_OutReport_Copy
	(@outrepid_1 	int,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
declare @newoutrepid_1 int
declare @theoutrepcategory_1 int
declare @itemid_1 int
declare @newitemid_1 int
declare @moduleid_1 int
declare @newmoduleid_1 int

select @theoutrepcategory_1 = outrepcategory from T_OutReport where outrepid = @outrepid_1 

INSERT INTO T_OutReport( outrepname,  outreprow , outrepcolumn , outrepdesc , modulefilename , outreptype , outrepcategory ,enmodulefilename,outrepenname,outrependesc )
( select '复制_'+outrepname,  outreprow , outrepcolumn , outrepdesc , modulefilename , outreptype , outrepcategory  ,enmodulefilename,outrepenname,outrependesc from T_OutReport where outrepid = @outrepid_1 ) 

select @newoutrepid_1 = max(outrepid) from T_OutReport 

INSERT INTO T_OutReportCondition( outrepid,  conditionid , conditioncnname, conditionenname )
( select @newoutrepid_1,  conditionid , conditioncnname, conditionenname from T_OutReportCondition where outrepid = @outrepid_1 ) 

INSERT INTO T_OutReportShare( outrepid,  userid , usertype , sharelevel)
( select @newoutrepid_1,  userid,  usertype , sharelevel from T_OutReportShare where outrepid = @outrepid_1 ) 

declare module_cursor cursor for 
select id from outrepmodule where outrepid = @outrepid_1
open module_cursor 
fetch next from module_cursor into @moduleid_1 
while @@fetch_status=0 
begin 
    INSERT INTO outrepmodule( outrepid,  modulename , moduledesc , userid , usertype , moduleenname ) 
    ( select @newoutrepid_1,  modulename,  moduledesc , userid , usertype , moduleenname from outrepmodule where id = @moduleid_1 ) 
    select @newmoduleid_1 = max( id ) from outrepmodule 
    INSERT INTO modulecondition( moduleid,  conditionid , conditionname , isuserdefine , conditionvalue )
    ( select @newmoduleid_1,  conditionid , conditionname , isuserdefine , conditionvalue from modulecondition where moduleid = @moduleid_1 ) 
    fetch next from module_cursor into @moduleid_1 
end 
close module_cursor 
deallocate module_cursor


if @theoutrepcategory_1 = 0 or @theoutrepcategory_1 = 2 
begin
    INSERT INTO T_OutReportItemRow( outrepid,  itemrow )
    ( select @newoutrepid_1,  itemrow from T_OutReportItemRow where outrepid = @outrepid_1 ) 

    declare itemid_cursor cursor for 
    select itemid from T_OutReportItem where outrepid = @outrepid_1
    open itemid_cursor 
    fetch next from itemid_cursor into @itemid_1 
    while @@fetch_status=0 
    begin 
        INSERT INTO T_OutReportItem( outrepid,  itemrow , itemcolumn , itemtype , picstat, itemexpress, itemtable,
        itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast , itemmodtype )
        ( select @newoutrepid_1,  itemrow , itemcolumn , itemtype , picstat, itemexpress, itemtable,
        itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast , itemmodtype 
        from T_OutReportItem where itemid = @itemid_1 ) 

        select @newitemid_1 = max( itemid ) from T_OutReportItem 
        
        INSERT INTO T_OutReportItemTable( itemid,  itemtable , itemtablealter )
        ( select @newitemid_1,  itemtable,  itemtablealter from T_OutReportItemTable where itemid = @itemid_1 ) 

        INSERT INTO T_OutReportItemCondition( itemid,  conditionid , conditionvalue )
        ( select @newitemid_1,  conditionid,  conditionvalue from T_OutReportItemCondition where itemid = @itemid_1 ) 

        INSERT INTO T_OutReportItemCoordinate( itemid,  coordinatename , coordinatevalue )
        ( select @newitemid_1,  coordinatename,  coordinatevalue from T_OutReportItemCoordinate where itemid = @itemid_1 ) 
        
        fetch next from itemid_cursor into @itemid_1 
    end 
    close itemid_cursor 
    deallocate itemid_cursor
end
else
begin
    INSERT INTO T_OutReportStatitem( outrepid,  statitemid , dsporder )
    ( select @newoutrepid_1,  statitemid,  dsporder from T_OutReportStatitem where outrepid = @outrepid_1 ) 
end
GO

alter table T_InputReport add isInputMultiLine char(1) null
GO
alter table T_InputReport add billId int null
GO
update T_InputReport set isInputMultiLine='1' where inprepfrequence='0'
GO


alter table T_inputReport add deleted int  default 0
GO
update T_inputReport set deleted=0 where deleted is null
GO

alter table workflow_base add isShowOnReportInput char(1)  default '0'
GO
update workflow_base set isShowOnReportInput='0' 
GO

alter table Workflow_Report add isShowOnReportOutput char(1)  default '0'
GO
update Workflow_Report set isShowOnReportOutput='0' 
GO

ALTER TABLE T_InputReportItem ADD  tempDspOrder decimal(15,2) null
GO
update T_InputReportItem set tempDspOrder=dspOrder
GO
ALTER TABLE T_InputReportItem DROP COLUMN dspOrder
GO
ALTER TABLE T_InputReportItem ADD  dspOrder decimal(15,2) null
GO
update T_InputReportItem set dspOrder=tempDspOrder
GO
ALTER TABLE T_InputReportItem DROP COLUMN tempDspOrder
GO

ALTER TABLE T_InputReportItemType ADD  tempDspOrder decimal(15,2) null
GO
update T_InputReportItemType set tempDspOrder=dspOrder
GO
ALTER TABLE T_InputReportItemType DROP COLUMN dspOrder
GO
ALTER TABLE T_InputReportItemType ADD  dspOrder decimal(15,2) null
GO
update T_InputReportItemType set dspOrder=tempDspOrder
GO
ALTER TABLE T_InputReportItemType DROP COLUMN tempDspOrder
GO


CREATE TABLE [T_InputReportHrm] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[inprepId] [int] NULL ,
	[crmId] [varchar] (1000) COLLATE Chinese_PRC_CI_AS NULL ,
	[hrmId] [int] NULL ,
	[workflowId] [int] NULL ,
	[moduleFileName] [varchar] (250) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [T_InputReportHrmFields] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[reportHrmId] [int] NOT NULL ,
	[fieldId] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE T_CollectSettingInfo(
    id int NOT NULL IDENTITY (1, 1),
    reporthrmid int,
    crmids varchar(1000), 
    cycle    char(1), 
    sortfields   text, 
    sqlwhere text 
)
GO

CREATE TABLE T_CollectTableInfo(
    id int NOT NULL IDENTITY (1, 1),
    collectid int, 
    inprepid int, 
    tablealia    varchar(2) 
)
GO

CREATE TABLE T_FieldComparisonInfo(
    id int NOT NULL IDENTITY (1, 1),
    collectid int, 
    sourcefield varchar(1000), 
    desfield    varchar(50) 
)
GO

update mainmenuconfig set visible=0 where infoid >=187 and infoid<=199
GO


ALTER PROCEDURE T_InputReport_Insert (
@inprepname_1 	varchar(200),
@inpreptablename_2 	varchar(60),
@inprepbugtablename_3 	varchar(60),
@inprepfrequence_4 	char(1),
@inprepbudget_5 	char(1),
@inprepforecast_6	char(1),
@startdate_7	char(10),
@enddate_8	char(10),
@modulefilename_9	varchar(100),
@helpdocid_10	int,
@isInputMultiLine_11	char(1),
@billId_12	int,
@flag	int	output,
@msg	varchar(80)	output)  
AS
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
@inprepname_1,
@inpreptablename_2,
@inprepbugtablename_3,
@inprepfrequence_4,
@inprepbudget_5,
@inprepforecast_6,
@startdate_7,
@enddate_8,
@modulefilename_9,
@helpdocid_10,
@isInputMultiLine_11,
@billId_12
)
GO

ALTER PROCEDURE T_InputReport_SelectAll (
@flag	int	output, 
@msg	varchar(80)	output)  
AS 
select * from T_InputReport where deleted=0
GO


ALTER PROCEDURE T_InputReportItem_Update (
@itemid_1 	int, 
@itemdspname_2 	varchar(60), 
@itemfieldname_3 	varchar(60), 
@itemfieldtype_4 	char(1), 
@itemfieldscale_5 	int, 
@itemtypeid_6 	int, 
@itemexcelsheet_7 	varchar(100), 
@itemexcelrow_8 	int, 
@itemexcelcolumn_9 	int , 
@itemfieldunit_10   varchar(60) , 
@dsporder_11        decimal(15,2) , 
@itemgongsi_12 	text, 
@inputablefact_13 	char(1), 
@inputablebudg_14 	char(1), 
@inputablefore_15 	char(1), 
@flag	int	output, 
@msg	varchar(80)	output)  
AS 
UPDATE T_InputReportItem  
SET  
itemdspname	 = @itemdspname_2, 
itemfieldname	 = @itemfieldname_3, 
itemfieldtype	 = @itemfieldtype_4, 
itemfieldscale	 = @itemfieldscale_5, 
itemtypeid	 = @itemtypeid_6, 
itemexcelsheet	 = @itemexcelsheet_7, 
itemexcelrow	 = @itemexcelrow_8, 
itemexcelcolumn	 = @itemexcelcolumn_9 , 
itemfieldunit = @itemfieldunit_10 , 
dsporder = @dsporder_11 , 
itemgongsi = @itemgongsi_12 , 
inputablefact = @inputablefact_13 , 
inputablebudg = @inputablebudg_14 , 
inputablefore = @inputablefore_15  
WHERE ( itemid	 = @itemid_1)
GO


ALTER PROCEDURE T_InputReportItemtype_Delete (
@itemtypeid_1 	int, 
@flag	int	output, 
@msg	varchar(80)	output
)  
AS 
DELETE T_InputReportItemtype WHERE ( itemtypeid	 = @itemtypeid_1)  
GO


ALTER PROCEDURE T_InputReportItemtype_Insert (
@inprepid_1 	int, 
@itemtypename_2 	varchar(100), 
@itemtypedesc_3 	varchar(200) , 
@dsporder_4 	decimal(15,2) , 
@flag	int	output, 
@msg	varchar(80)	output)  
AS 
INSERT INTO T_InputReportItemtype ( 
inprepid, 
itemtypename, 
itemtypedesc, 
dsporder)  
VALUES ( 
@inprepid_1, 
@itemtypename_2, 
@itemtypedesc_3, 
@dsporder_4)
GO


ALTER PROCEDURE T_InputReportItemtype_Update (
@itemtypeid_1 	int, 
@itemtypename_2 	varchar(100), 
@itemtypedesc_3 	varchar(200), 
@dsporder_4 	decimal(15,2) , 
@flag	int	output, 
@msg	varchar(80)	output)  
AS 
UPDATE T_InputReportItemtype  
SET  
itemtypename	 = @itemtypename_2, 
itemtypedesc	 = @itemtypedesc_3 , 
dsporder	 = @dsporder_4  
WHERE ( itemtypeid	 = @itemtypeid_1)
GO


ALTER PROCEDURE T_InputReportItem_Insert (
@inprepid_1 	int, 
@itemdspname_2 	varchar(60), 
@itemfieldname_3 	varchar(60), 
@itemfieldtype_4 	char(1), 
@itemfieldscale_5 	int, 
@itemtypeid_6 	int, 
@itemexcelsheet_7 	varchar(100), 
@itemexcelrow_8 	int, 
@itemexcelcolumn_9 	int , 
@itemfieldunit_10   varchar(60) , 
@dsporder_11        decimal(15,2) , 
@itemgongsi_12 	text, 
@inputablefact_13 	char(1), 
@inputablebudg_14 	char(1), 
@inputablefore_15 	char(1), 
@flag	int	output, 
@msg	varchar(80)	output)  
AS  
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
@inprepid_1, 
@itemdspname_2, 
@itemfieldname_3, 
@itemfieldtype_4, 
@itemfieldscale_5, 
@itemtypeid_6, 
@itemexcelsheet_7, 
@itemexcelrow_8, 
@itemexcelcolumn_9, 
@itemfieldunit_10, 
@dsporder_11, 
@itemgongsi_12, 
@inputablefact_13, 
@inputablebudg_14, 
@inputablefore_15)
GO

ALTER PROCEDURE T_InputReport_Update (
@inprepid_1 	int,
@inprepname_2 	varchar(200),
@inpreptablename_3 	varchar(60),
@inprepbugtablename_4 	varchar(60),
@inprepfrequence_5 	char(1),
@inprepbudget_6 	char(1),
@inprepforecast_7	char(1),
@startdate_8	char(10),
@enddate_9	char(10),
@modulefilename_10	varchar(100),
@helpdocid_11	int,
@isInputMultiLine_12	char(1),
@billId_13	int,
@flag	int	output,
@msg	varchar(80)	output
)
AS
UPDATE T_InputReport
SET
inprepname	 = @inprepname_2,
inpreptablename	 = @inpreptablename_3,
inprepbugtablename	 = @inprepbugtablename_4,
inprepfrequence	 = @inprepfrequence_5, 
inprepbudget	 = @inprepbudget_6 ,
inprepforecast	 = @inprepforecast_7 ,
startdate	 = @startdate_8 ,
enddate	 = @enddate_9 ,
modulefilename	 = @modulefilename_10 ,
helpdocid	 = @helpdocid_11 ,
isInputMultiLine	 = @isInputMultiLine_12 ,
billId	 = @billId_13
WHERE ( inprepid	 = @inprepid_1)
GO

delete from sequenceindex  where  indexDesc='dataCenterWorkflowTypeId'
GO
insert into workflow_type(typeName,typeDesc,dspOrder) values('报表填报','报表填报',-2)
GO
insert into sequenceindex(indexDesc,currentId) select 'dataCenterWorkflowTypeId',max(id)  from workflow_type
GO
update workflow_base set workflowType=(select currentId from sequenceindex where indexDesc='dataCenterWorkflowTypeId') where workflowType=-2
GO


if exists(select * from  sysobjects where name='T_InputReportItemtype_SelectByInprepid' and xtype='p') 
  DROP PROCEDURE T_InputReportItemtype_SelectByInprepid
GO
if exists(select * from  sysobjects where name='T_InputReportItemtype_SelectByItemtypeid' and xtype='p') 
  DROP PROCEDURE T_InputReportItemtype_SelectByItemtypeid
GO
if exists(select * from  sysobjects where name='T_InputReportItem_SelectByInprepid' and xtype='p') 
  DROP PROCEDURE T_InputReportItem_SelectByInprepid
GO
if exists(select * from  sysobjects where name='T_InputReportItem_SelectByItemtypeid' and xtype='p') 
  DROP PROCEDURE T_InputReportItem_SelectByItemtypeid
GO
if exists(select * from  sysobjects where name='T_InputReport_SelectByContacterid' and xtype='p') 
  DROP PROCEDURE T_InputReport_SelectByContacterid
GO
if exists(select * from  sysobjects where name='T_InputReportItemDetail_SelectByItemid' and xtype='p') 
  DROP PROCEDURE T_InputReportItemDetail_SelectByItemid
GO
if exists(select * from  sysobjects where name='T_InputReportCrm_SelectByInprepid' and xtype='p') 
  DROP PROCEDURE T_InputReportCrm_SelectByInprepid
GO
if exists(select * from  sysobjects where name='T_InputReportConfirm_SelectByConfirmid' and xtype='p') 
  DROP PROCEDURE T_InputReportConfirm_SelectByConfirmid
GO
if exists(select * from  sysobjects where name='T_Condition_SelectByConditionid' and xtype='p') 
  DROP PROCEDURE T_Condition_SelectByConditionid
GO
if exists(select * from  sysobjects where name='T_ConditionDetail_SelectByConditionid' and xtype='p') 
  DROP PROCEDURE T_ConditionDetail_SelectByConditionid
GO
if exists(select * from  sysobjects where name='T_OutReportCondition_SelectByOutrepid' and xtype='p') 
  DROP PROCEDURE T_OutReportCondition_SelectByOutrepid
GO
if exists(select * from  sysobjects where name='T_OutReportShare_SelectByOutrepid' and xtype='p') 
  DROP PROCEDURE T_OutReportShare_SelectByOutrepid
GO
if exists(select * from  sysobjects where name='T_OutReportItem_SelectByOutrepid' and xtype='p') 
  DROP PROCEDURE T_OutReportItem_SelectByOutrepid
GO
if exists(select * from  sysobjects where name='T_OutReportItemTable_SelectByItemid' and xtype='p') 
  DROP PROCEDURE T_OutReportItemTable_SelectByItemid
GO
if exists(select * from  sysobjects where name='T_OutReportItemCondition_SelectByItemid' and xtype='p') 
  DROP PROCEDURE T_OutReportItemCondition_SelectByItemid
GO
if exists(select * from  sysobjects where name='T_OutReportItemCondition_Insert' and xtype='p') 
  DROP PROCEDURE T_OutReportItemCondition_Insert
GO
if exists(select * from  sysobjects where name='T_OutReportItemCondition_Delete' and xtype='p') 
  DROP PROCEDURE T_OutReportItemCondition_Delete
GO
if exists(select * from  sysobjects where name='T_OutReportItemCoordinate_Delete' and xtype='p') 
  DROP PROCEDURE T_OutReportItemCoordinate_Delete
GO
if exists(select * from  sysobjects where name='T_OutReportItemCoordinate_SelectByItemid' and xtype='p') 
  DROP PROCEDURE T_OutReportItemCoordinate_SelectByItemid
GO
if exists(select * from  sysobjects where name='T_OutReportItemCoordinate_Insert' and xtype='p') 
  DROP PROCEDURE T_OutReportItemCoordinate_Insert
GO
if exists(select * from  sysobjects where name='T_InputReportConfirm_SelectByCrmid' and xtype='p') 
  DROP PROCEDURE T_InputReportConfirm_SelectByCrmid
GO
if exists(select * from  sysobjects where name='T_InputReportConfirm_SelectByUserid' and xtype='p') 
  DROP PROCEDURE T_InputReportConfirm_SelectByUserid
GO
exec sp_rename 'T_OutReportItemRow.[rowid]','row_id','column'
GO


CREATE PROCEDURE T_IRItemtype_SelectByInprepid(
	@inprepid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select * from T_InputReportItemtype where inprepid = @inprepid_1 order by dsporder
GO

CREATE PROCEDURE T_IRIT_SelectByItemtypeid(
        @itemtypeid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_InputReportItemtype where itemtypeid = @itemtypeid_1
GO

CREATE PROCEDURE T_IRItem_SelectByInprepid(
        @inprepid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select * from T_InputReportItem where inprepid = @inprepid_1 order by dsporder
GO

CREATE PROCEDURE T_IRItem_SelectByItemtypeid(
        @itemtypeid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select * from T_InputReportItem where itemtypeid = @itemtypeid_1 order by dsporder 
GO

CREATE PROCEDURE T_IReport_SelectByContacterid(
        @contacter_1  int ,
        @currentdate_2 char(10) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select a.inprepid, a.inprepname from T_InputReport a, T_InputReportCrm b , T_InputReportCrmContacter c 
where a.inprepid = b.inprepid and b.inprepcrmid = c.inprepcrmid and c.contacterid = @contacter_1 and 
(a.startdate = '' or a.startdate is null or a.startdate <= @currentdate_2 ) and 
(a.enddate = '' or a.enddate is null or a.enddate >= @currentdate_2 )
GO

CREATE PROCEDURE T_IRItemDetail_SelectByItemid(
        @itemid_1  int,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select * from T_InputReportItemDetail where itemid = @itemid_1
GO

CREATE PROCEDURE T_IReportCrm_SelectByInprepid(
        @inprepid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select * from T_InputReportCrm where inprepid = @inprepid_1
GO

CREATE PROCEDURE T_IRConfirm_SelectByConfirmid(
        @confirmid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select b.* , a.inprepname from T_InputReport a,  T_InputReportConfirm b 
where a.inprepid = b.inprepid and confirmid = @confirmid_1
GO

CREATE PROCEDURE T_CT_SelectByConditionid(
        @conditionid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select * from T_Condition where conditionid = @conditionid_1
GO

CREATE PROCEDURE T_CDetail_SelectByConditionid(
        @conditionid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select * from T_ConditionDetail where conditionid = @conditionid_1
GO

CREATE PROCEDURE T_OutRC_SelectByOutrepid(
        @outrepid int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select * from T_OutReportCondition where outrepid = @outrepid
GO

CREATE PROCEDURE T_OutRShare_SelectByOutrepid(
        @outrepid int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select * from T_OutReportShare where outrepid = @outrepid
GO

CREATE PROCEDURE T_OutRItem_SelectByOutrepid(
        @outrepid int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select * from T_OutReportItem where outrepid = @outrepid 
GO

CREATE PROCEDURE T_OutRItemTable_SelectByItemid(
        @itemid int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select * from T_OutReportItemTable where itemid = @itemid 
GO

CREATE PROCEDURE T_OutRICondition_SByItemid(
        @itemid int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select * from T_OutReportItemCondition where itemid = @itemid 
GO

CREATE PROCEDURE T_OutRItemCondition_Insert(
        @itemid_1 	int,
	@conditionid     int,
	@conditionvalue  varchar(100),
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
INSERT INTO T_OutReportItemCondition ( 
         itemid,
	 conditionid,
	 conditionvalue) 
VALUES ( @itemid_1,
	 @conditionid,
	 @conditionvalue)
GO

CREATE PROCEDURE T_OutRItemCondition_Delete(
        @itemid 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS DELETE T_OutReportItemCondition 
WHERE (itemid = @itemid)
GO

CREATE PROCEDURE T_OutRItemCoordinate_Delete(
        @itemid 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS DELETE T_OutReportItemCoordinate 
WHERE( itemid	 = @itemid)
GO

CREATE PROCEDURE T_OutRICdinate_SelectByItemid(
        @itemid int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select * from T_OutReportItemCoordinate where itemid = @itemid 
GO

CREATE PROCEDURE T_OutReportICoordinate_Insert(
        @itemid_1 	int,
	@coordinatename     varchar(100),
	@coordinatevalue  varchar(100),
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
INSERT INTO T_OutReportItemCoordinate (
         itemid,
	 coordinatename,
	 coordinatevalue) 
VALUES ( @itemid_1,
	 @coordinatename,
	 @coordinatevalue)
GO

CREATE PROCEDURE T_IRConfirm_SelectByUserid(
        @confirmuserid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select b.confirmid ,b.inputid ,a.inprepname ,b.inprepdspdate, b.inprepbudget , b.crmid ,b.thetable from T_InputReport a, T_InputReportConfirm b 
where a.inprepid = b.inprepid and b.confirmuserid = @confirmuserid_1
GO


ALTER PROCEDURE T_InputReportConfirm_SByUID(
        @crmid_1  int ,
	@contactid_2  varchar(200) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS 
select distinct * from 
(select a.inprepname, b.* 
 from T_InputReport a, T_InputReportConfirm b,T_InputReportCrm c 
 where a.inprepid = b.inprepid 
   and b.inprepid=c.inprepid 
   and b.crmid=c.crmid 
   and b.crmid = @crmid_1
 union
 select distinct a.inprepname, b.* 
 from T_InputReport a,T_InputReportConfirm b,T_InputReportCrmSel c,T_InputReportCrm d
 where d.inprepcrmid = c.inprepcrmid 
   and a.inprepid = b.inprepid
   and a.inprepid = d.inprepid
   and c.contacterid = @contactid_2
   and  ','+c.SELCRM+',' like ','+b.crmid+',') a
GO
