alter table  cowork_items add  lastdiscussant int
GO

create  PROCEDURE Init_cowork_discussant	
	@flag		int	output, 
	@msg		varchar(80) output
as
	Declare
	@coworkid_1 int,
	@discussant_1 int,
	@all_cursor cursor

	SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
	select id from cowork_items 
	OPEN @all_cursor 
	FETCH NEXT FROM @all_cursor INTO @coworkid_1
	WHILE @@FETCH_STATUS = 0
	begin
		
		select top 1 @discussant_1=discussant   from  cowork_discuss where coworkid=@coworkid_1 order by  createdate desc,createtime desc		
		update cowork_items set lastdiscussant=@discussant_1 where id=@coworkid_1
		FETCH NEXT FROM @all_cursor INTO   @coworkid_1
	end 
	CLOSE @all_cursor
	DEALLOCATE @all_cursor  	
GO

Init_cowork_discussant '',''
GO


CREATE TRIGGER Tri_cowork_discuss_ByDiscussant ON cowork_discuss WITH ENCRYPTION
FOR INSERT 
AS
    DECLARE @discussant_1 int
    DECLARE @coworkid_1 int

    SELECT @discussant_1 = discussant,@coworkid_1=coworkid FROM inserted

    update cowork_items set lastdiscussant=@discussant_1 where id=@coworkid_1
GO


INSERT INTO HPFieldElement(id, elementId, fieldName, fieldColumn, isDate, transMethod, fieldWidth, linkUrl, valueColumn, isLimitLength, orderNum)
VALUES(70, 13, '20899', 'lastdiscussant', '0', 'getLastdiscussant', '70', '', '', '', 2)
GO
