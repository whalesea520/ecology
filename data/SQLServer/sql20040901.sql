/* td:993 by 刘煜 for 编辑‘福利’类型和‘税收’类型，自动翻倍增加加一行的记录 */
alter PROCEDURE HrmSalaryItem_Update
	(@id_1 	int,
	 @itemname_2 	varchar(50),
	 @itemcode_3 	varchar(50),
	 @itemtype_4 	char(1),
	 @personwelfarerate_5 	int,
	 @companywelfarerate_6 	int,
	 @taxrelateitem_7 	int,
	 @amountecp_8 	varchar(200),
	 @feetype_9 	int,
	 @isshow_10 	char(1),
	 @showorder_11 	int,
	 @ishistory_12 	char(1) ,
     @flag          integer output, 
     @msg           varchar(80) output)

AS 
declare @olditemtype_1 char(1) 
declare @benchid_1 int

select @olditemtype_1 = itemtype from HrmSalaryItem where id = @id_1 
UPDATE HrmSalaryItem 
SET  itemname	 = @itemname_2,
	 itemcode	 = @itemcode_3,
	 itemtype	 = @itemtype_4,
	 personwelfarerate	 = @personwelfarerate_5,
	 companywelfarerate	 = @companywelfarerate_6,
	 taxrelateitem	 = @taxrelateitem_7,
	 amountecp	 = @amountecp_8,
	 feetype	 = @feetype_9,
	 isshow	 = @isshow_10,
	 showorder	 = @showorder_11,
	 ishistory	 = @ishistory_12 

WHERE 
	( id	 = @id_1)

if @olditemtype_1 = '1' or @olditemtype_1 = '2'
begin
    delete from HrmSalaryRank where itemid = @id_1
    delete from HrmSalaryWelfarerate where itemid = @id_1
end
else if @olditemtype_1 = '5' or @olditemtype_1 = '6'
    delete from HrmSalarySchedule where itemid = @id_1
else if @olditemtype_1 = '7'
    delete from HrmSalaryShiftPay where itemid = @id_1
else if @olditemtype_1 = '3'
begin
    declare benchid_cursor cursor for
    select id from HrmSalaryTaxbench where itemid = @id_1 
    open benchid_cursor 
    fetch next from benchid_cursor into @benchid_1
    while @@fetch_status=0
    begin 
        delete from HrmSalaryTaxrate where benchid = @benchid_1
        delete from HrmSalaryTaxbench where id = @benchid_1
        fetch next from benchid_cursor into @benchid_1
    end
    close benchid_cursor deallocate benchid_cursor
end
GO
