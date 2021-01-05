Declare
@id int,
@managerid varchar(8000),
@members varchar(8000),
@all_cursor cursor
	
SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
select id,managerid,members from cowork_types
OPEN @all_cursor
FETCH NEXT FROM @all_cursor INTO @id,@managerid,@members
WHILE @@FETCH_STATUS = 0
BEGIN		
	set @managerid = ','+@managerid+','
	set @members = ','+@members+','
	update cowork_types set managerid=@managerid,members=@members where id=@id
	FETCH NEXT FROM @all_cursor INTO @id,@managerid,@members
END
CLOSE @all_cursor
DEALLOCATE @all_cursor
go



alter table cowork_items alter column coworkers text
go
Declare
@id2 int,
@coworkers varchar(8000),
@all_cursor2 cursor
	
SET @all_cursor2 = CURSOR FORWARD_ONLY STATIC FOR
select id,coworkers from cowork_items
OPEN @all_cursor2
FETCH NEXT FROM @all_cursor2 INTO @id2,@coworkers
WHILE @@FETCH_STATUS = 0
BEGIN		
	set @coworkers = ','+@coworkers+','
	update cowork_items set coworkers=@coworkers where id=@id2
	FETCH NEXT FROM @all_cursor2 INTO @id2,@coworkers
END
CLOSE @all_cursor2
DEALLOCATE @all_cursor2
go


alter PROCEDURE [cowork_items_insert]
	(@name_1 	[varchar](100),
	 @typeid_2 	[int],
	 @levelvalue_3 	[int],
	 @creater_4 	[int],
	 @coworkers_5 	[text],
	 @createdate_6 	[char](10),
	 @createtime_7 	[char](8),
	 @begindate_8 	[char](10),
	 @beingtime_9 	[char](5),
	 @enddate_10 	[char](10),
	 @endtime_11 	[char](5),
	 @relatedprj_12 [varchar](500),
	 @relatedcus_13 [varchar](500),
	 @relatedwf_14 	[varchar](500),
	 @relateddoc_15 [varchar](500),
	 @remark_16 	[text],
	 @status_17 	[int],
	 @isnew 	[varchar](255),
 	 @flag integer output , 
  	 @msg varchar(80) output)
AS INSERT INTO [cowork_items] 
	 ( [name],
	 [typeid],
	 [levelvalue],
	 [creater],
	 [coworkers],
	 [createdate],
	 [createtime],
	 [begindate],
	 [beingtime],
	 [enddate],
	 [endtime],
	 [relatedprj],
	 [relatedcus],
	 [relatedwf],
	 [relateddoc],
	 [remark],
	 [status],
	 [isnew]) 
VALUES 
	( @name_1,
	 @typeid_2,
	 @levelvalue_3,
	 @creater_4,
	 @coworkers_5,
	 @createdate_6,
	 @createtime_7,
	 @begindate_8,
	 @beingtime_9,
	 @enddate_10,
	 @endtime_11,
	 @relatedprj_12,
	 @relatedcus_13,
	 @relatedwf_14,
	 @relateddoc_15,
	 @remark_16,
	 @status_17,
	 @isnew)
select max(id) from cowork_items
GO

alter PROCEDURE [cowork_items_update]
	(@id_1 	[int],
	 @name_2 	[varchar](100),
	 @typeid_3 	[int],
	 @levelvalue_4 	[int],
	 @creater_5 	[int],
	 @coworkers_6 	[text],
	 @begindate_7 	[char](10),
	 @beingtime_8 	[char](5),
	 @enddate_9 	[char](10),
	 @endtime_10 	[char](5),
	 @relatedprj_11 [varchar](500),
	 @relatedcus_12 [varchar](500),
	 @relatedwf_13 	[varchar](500),
	 @relateddoc_14 [varchar](500),
	 @remark_15 	[text],
	 @isnew_16 	[varchar](255),
	 @flag integer output , 
  	 @msg varchar(80) output)
AS UPDATE [cowork_items] 
SET  [name]	 = @name_2,
	 [typeid]	 = @typeid_3,
	 [levelvalue]	 = @levelvalue_4,
	 [creater]	 = @creater_5,
	 [coworkers]	 = @coworkers_6,
	 [begindate]	 = @begindate_7,
	 [beingtime]	 = @beingtime_8,
	 [enddate]	 = @enddate_9,
	 [endtime]	 = @endtime_10,
	 [relatedprj]	 = @relatedprj_11,
	 [relatedcus]	 = @relatedcus_12,
	 [relatedwf]	 = @relatedwf_13,
	 [relateddoc]	 = @relateddoc_14,
	 [remark]	 = @remark_15,
	 [isnew]	 = @isnew_16 
WHERE 
	( [id]	 = @id_1)
GO


Declare
@id2 int,
@readers varchar(8000),
@isnew varchar(8000),
@all_cursor2 cursor
	
SET @all_cursor2 = CURSOR FORWARD_ONLY STATIC FOR
select id,isnew,readers from cowork_items
OPEN @all_cursor2
FETCH NEXT FROM @all_cursor2 INTO @id2,@readers,@isnew
WHILE @@FETCH_STATUS = 0
BEGIN		
	set @readers = ','+@readers+','
	set @isnew = ','+@isnew+','
	update cowork_items set readers=@readers,isnew=@isnew where id=@id2
	FETCH NEXT FROM @all_cursor2 INTO @id2,@readers,@isnew
END
CLOSE @all_cursor2
DEALLOCATE @all_cursor2
go


INSERT INTO HtmlLabelIndex values(19780,'标记为重要协作事件') 
GO
INSERT INTO HtmlLabelIndex values(19779,'标记为不重要协作事件') 
GO
INSERT INTO HtmlLabelInfo VALUES(19779,'标记为不重要协作事件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19779,'Sign Not Importent',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19780,'标记为重要协作事件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19780,'Sign importent',8) 
GO

