insert into SysPoppupInfo values (9,'/cowork/coworkview.jsp?type=remind','新协作事件需要您处理','y','协作提醒')
go
INSERT INTO HtmlLabelIndex values(18822,'协作提醒') 
GO
INSERT INTO HtmlLabelIndex values(18831,'协作主题') 
GO
INSERT INTO HtmlLabelInfo VALUES(18822,'协作提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18822,'Cowork Remind',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18831,'协作主题',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18831,'Cowork Subject',8) 
GO

update SysPoppupInfo set link='/cowork/CoworkRemindLink.jsp' where type=9
GO

delete from SysPoppupRemindInfo where type=9
GO
Create Procedure init_CoworkRemind
as
	Declare
	@id int,
	@count int,
	@all_cursor cursor
	SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
	select id from HrmResource
	OPEN @all_cursor
	FETCH NEXT FROM @all_cursor INTO @id
	WHILE @@FETCH_STATUS = 0
	BEGIN		
		select @count=count(id) from cowork_items where (','+coworkers+',' like '%,'+CAST(@id AS varchar(50))+',%') and (','+isnew+',' not like '%,'+CAST(@id AS varchar(50))+',%') and status=1
		IF (@count <> 0)
		BEGIN
			insert into SysPoppupRemindInfo(userid,type,usertype,statistic,remindcount,count) values(@id,9,'0','y',@count,@count)
		END
		FETCH NEXT FROM @all_cursor INTO @id
	END
	CLOSE @all_cursor
	DEALLOCATE @all_cursor  
GO

init_CoworkRemind
GO

DROP PROCEDURE init_CoworkRemind
GO