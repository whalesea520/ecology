update systemrights set detachable=1 where id=109
GO

alter table hrmsalaryitem add applyscope int
GO
alter table hrmsalaryitem add subcompanyid int
GO
alter table HrmSalaryItem add calMode int
GO
alter table HrmSalaryItem add  directModify int
GO
alter table HrmSalaryItem add  companyPercent float
GO
alter table HrmSalaryItem add  personalPercent float
GO
declare @detachable int
declare @defaultsubcom int
declare @minsubcom int
select @detachable=detachable,@defaultsubcom=dftsubcomid  from systemset
if(@detachable<>null and @defaultsubcom<>null)
update  hrmsalaryitem set applyscope=0,subcompanyid=@defaultsubcom
else
begin
select @minsubcom=min(id)  from hrmsubcompany
update  hrmsalaryitem set applyscope=0,subcompanyid=@minsubcom
end
GO



INSERT INTO HtmlLabelIndex values(19467,'范围')
GO
INSERT INTO HtmlLabelInfo VALUES(19467,'范围',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19467,'scope',8)
GO
create table HrmSalaryTaxscope ( itemid int,
                                   benchid int,
                                   scopetype int,
                                   objectid int)
GO


INSERT INTO HtmlLabelIndex values(19482,'时间范围')
GO
INSERT INTO HtmlLabelInfo VALUES(19482,'时间范围',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19482,'time scope',8)
GO

INSERT INTO HtmlLabelIndex values(19483,'半年度')
GO
INSERT INTO HtmlLabelInfo VALUES(19483,'半年度',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19483,'half year',8)
GO

create table HrmSalaryCalBench(id int identity,
                                 itemid int,
                                 scopetype int)
GO
create table HrmSalaryCalRate( id int identity,
                                 benchid int,
                                 timescope int,
                                 condition varchar(500),
                                 formular varchar(500))
GO
create table HrmSalaryCalScope(itemid int,
                                 benchid int,
                                 objectid int)
GO



INSERT INTO HtmlLabelIndex values(19530,'分别计算')
GO
INSERT INTO HtmlLabelIndex values(19529,'按百分比计算')
GO
INSERT INTO HtmlLabelInfo VALUES(19529,'按百分比计算',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19529,'calculate by percent',8)
GO
INSERT INTO HtmlLabelInfo VALUES(19530,'分别计算',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19530,'calculate seperately',8)
GO
INSERT INTO HtmlLabelIndex values(19531,'直接修改工资单')
GO
INSERT INTO HtmlLabelInfo VALUES(19531,'直接修改工资单',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19531,'directly modify salary bill',8)
GO
INSERT INTO HtmlLabelIndex values(19545,'当前页面数据将会丢失')
GO
INSERT INTO HtmlLabelInfo VALUES(19545,'当前页面数据将会丢失，是否继续？',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19545,'the data of current page will lost,be sure?',8)
GO


 delete from HrmSalaryItem  where (itemtype>1  and itemtype<5) or itemtype=8
 GO
 delete from HrmSalaryWelfarerate
 GO
 delete from HrmSalaryTaxscope
 GO
 delete from HrmSalaryTaxrate
 GO
 delete from HrmSalaryTaxbench
 GO

alter table HrmSalaryCalrate add   conditiondsp varchar(500)
go
alter table HrmSalaryCalrate add   formulardsp varchar(500)
go
alter table HrmSalarypaydetail add   condition varchar(500)
go
alter table HrmSalarypaydetail add   formular varchar(500)
go
alter table HrmSalarypaydetail add   conditiondsp varchar(500)
go
alter table HrmSalarypaydetail add   formulardsp varchar(500)
go



alter PROCEDURE HrmSalaryItem_Update (@id_1 	int, @itemname_2 	varchar(50), @itemcode_3 	varchar(50), @itemtype_4 	char(1), @personwelfarerate_5 	int, @companywelfarerate_6 	int, @taxrelateitem_7 	int, @amountecp_8 	varchar(200), @feetype_9 	int, @isshow_10 	char(1), @showorder_11 	int, @ishistory_12 	char(1) , @applyscope_13 	int ,@calMode_14 int, @directModify_15 int,@personalPercent_16 float,@companyPercent_17 float, @flag          integer output, @msg           varchar(80) output)  AS
declare @olditemtype_1 char(1)
declare @benchid_1 int
select @olditemtype_1 = itemtype from HrmSalaryItem where id = @id_1
UPDATE HrmSalaryItem SET  itemname	 = @itemname_2, itemcode	 = @itemcode_3, itemtype	 = @itemtype_4, personwelfarerate	 = @personwelfarerate_5, companywelfarerate	 = @companywelfarerate_6, taxrelateitem	 = @taxrelateitem_7, amountecp	 = @amountecp_8, feetype	 = @feetype_9, isshow	 = @isshow_10, showorder	 = @showorder_11, ishistory	 = @ishistory_12,applyscope=@applyscope_13,calMode=@calMode_14,directModify=@directModify_15,personalPercent=@personalPercent_16,companyPercent=@companyPercent_17  WHERE ( id	 = @id_1)
if @olditemtype_1 = '1'
begin
delete from HrmSalaryRank where itemid = @id_1
delete from HrmSalaryResourcePay where itemid = @id_1
delete from HrmSalaryTaxscope where itemid = @id_1
end
else if @olditemtype_1 = '2'
begin
delete from HrmSalaryRank where itemid = @id_1
delete from HrmSalaryWelfarerate where itemid = @id_1
delete from HrmSalaryResourcePay where itemid = @id_1
end
else if @olditemtype_1 = '5' or @olditemtype_1 = '6'
delete from HrmSalarySchedule where itemid = @id_1
else if @olditemtype_1 = '7'
delete from HrmSalaryShiftPay where itemid = @id_1
else if @olditemtype_1 = '8'
delete from HrmSalaryResourcePay where itemid = @id_1
else if @olditemtype_1 = '3'
begin
declare benchid_cursor cursor for select id from HrmSalaryTaxbench where itemid = @id_1
open benchid_cursor
fetch next from benchid_cursor into @benchid_1 while @@fetch_status=0
begin
delete from HrmSalaryTaxrate where benchid = @benchid_1
delete from HrmSalaryTaxbench where id = @benchid_1
fetch next from benchid_cursor into @benchid_1
end
close benchid_cursor
deallocate benchid_cursor
end
else if @olditemtype_1 = '4' or @olditemtype_1 = '9'
begin
declare benchid_cursor cursor for select id from HrmSalaryCalBench where itemid = @id_1
open benchid_cursor
fetch next from benchid_cursor into @benchid_1 while @@fetch_status=0
begin
delete from HrmSalaryCalRate where benchid = @benchid_1
delete from HrmSalaryCalBench where id = @benchid_1
fetch next from benchid_cursor into @benchid_1
end
close benchid_cursor
deallocate benchid_cursor
end
GO


alter PROCEDURE HrmSalaryItem_Insert
	(@itemname_1 	varchar(50),
	 @itemcode_2 	varchar(50),
	 @itemtype_3 	char(1),
	 @personwelfarerate_4 	int,
	 @companywelfarerate_5 	int,
	 @taxrelateitem_6 	int,
	 @amountecp_7 	varchar(200),
	 @feetype_8 	int,
	 @isshow_9 	char(1),
	 @showorder_10 	int,
	 @ishistory_11 	char(1),
	 @subcompanyid_12 int,
	 @applyscope_13 int,
	 @calMode_14 	int,
	 @directModify_15  int,
	 @personalPercent_16 float,
	 @companyPercent_17 float,
     @flag          integer output,
     @msg           varchar(80) output)

AS INSERT INTO HrmSalaryItem
	 (itemname,
	 itemcode,
	 itemtype,
	 personwelfarerate,
	 companywelfarerate,
	 taxrelateitem,
	 amountecp,
	 feetype,
	 isshow,
	 showorder,
	 ishistory,
	 subcompanyid,
	 applyscope,
	 calMode,
	 directModify,
	 personalPercent,
	 companyPercent)

VALUES
	( @itemname_1,
	 @itemcode_2,
	 @itemtype_3,
	 @personwelfarerate_4,
	 @companywelfarerate_5,
	 @taxrelateitem_6,
	 @amountecp_7,
	 @feetype_8,
	 @isshow_9,
	 @showorder_10,
	 @ishistory_11,
	 @subcompanyid_12,
	 @applyscope_13,
	 @calMode_14,
	 @directModify_15,
	 @personalPercent_16,
	 @companyPercent_17
	 )

select max(id) from HrmSalaryItem

GO


alter PROCEDURE HrmSalaryItem_Delete (@id_1 	int , @flag          integer output, @msg           varchar(80) output) AS
 declare @olditemtype_1 char(1)
 declare @benchid_1 int
 select @olditemtype_1 = itemtype from HrmSalaryItem where id = @id_1
 DELETE HrmSalaryItem WHERE ( id	 = @id_1)
 if @olditemtype_1 = '1'
 begin
 delete from HrmSalaryRank where itemid = @id_1
 delete from HrmSalaryResourcePay where itemid = @id_1
 delete from HrmSalaryTaxscope where itemid = @id_1
 end
 else if @olditemtype_1 = '5' or @olditemtype_1 = '6'
 delete from HrmSalarySchedule where itemid = @id_1
 else if @olditemtype_1 = '7'
 delete from HrmSalaryShiftPay where itemid = @id_1
 else if @olditemtype_1 = '8'
 delete from HrmSalaryResourcePay where itemid = @id_1
 else if @olditemtype_1 = '2'
 begin
 delete from HrmSalaryRank where itemid = @id_1
 delete from HrmSalaryWelfarerate where itemid = @id_1
 delete from HrmSalaryResourcePay where itemid = @id_1
 end
 else if @olditemtype_1 = '3'
 begin
 delete from HrmSalaryTaxscope where itemid=@id_1
 declare benchid_cursor cursor for select id from HrmSalaryTaxbench where itemid = @id_1
 open benchid_cursor
 fetch next from benchid_cursor into @benchid_1
 while @@fetch_status=0
 begin
 delete from HrmSalaryTaxrate where benchid = @benchid_1
 delete from HrmSalaryTaxbench where id = @benchid_1
 fetch next from benchid_cursor into @benchid_1
 end
 close benchid_cursor
 deallocate benchid_cursor
  end
else if @olditemtype_1 = '4' or @olditemtype_1 = '9'
begin
declare benchid_cursor cursor for select id from HrmSalaryCalBench where itemid = @id_1
open benchid_cursor
fetch next from benchid_cursor into @benchid_1 while @@fetch_status=0
begin
delete from HrmSalaryCalRate where benchid = @benchid_1
delete from HrmSalaryCalBench where id = @benchid_1
fetch next from benchid_cursor into @benchid_1
end
close benchid_cursor
deallocate benchid_cursor
end
GO


create PROCEDURE HrmSalaryCalRate_Insert
	(@benchid_1 	int,
	 @timescope_2 	int,
	 @condition_3 	varchar(500),
	 @formular_4 	varchar(500),
	 @conditiondsp_5 	varchar(500),
	 @formulardsp_6 	varchar(500),
     @flag          integer output,
     @msg           varchar(80) output)

AS INSERT INTO HrmSalaryCalrate
	 ( benchid,
	 timescope,
	 condition,
	 formular,
	 conditiondsp,
	 formulardsp
	 )

VALUES
	( @benchid_1,
	 @timescope_2,
	 @condition_3,
	 @formular_4,
	 @conditiondsp_5,
	 @formulardsp_6)

GO

CREATE PROCEDURE HrmSalaryCalBench_Insert
	(@itemid_1 	int,
	 @scopetype_2 	int,
     @flag          integer output,
     @msg           varchar(80) output)

AS INSERT INTO HrmSalaryCalBench
	 ( itemid,
	 scopetype)

VALUES
	( @itemid_1,
	 @scopetype_2)

select max(id) from HrmSalaryCalBench

GO