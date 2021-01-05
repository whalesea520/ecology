ALTER TABLE HrmUserSetting   ADD theme varchar(100)
GO

ALTER TABLE cowork_label   ADD isUsed int null
GO

ALTER TABLE cowork_label   ADD labelOrder int null
GO

ALTER TABLE cowork_label   ADD labelType varchar(100) null
GO

EXEC sp_rename 'cowork_label.icon ', 'labelColor ', 'COLUMN '
GO

alter PROCEDURE [cowork_items_insert]
	(@name_1 	[varchar](100),
	 @typeid_2 	[int],
	 @levelvalue_3 	[int],
	 @creater_4 	[int],
	 @principal_5 	[int],
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
     @accessory_18 	[varchar](500),
     @mutil_prjs_19 	[varchar](500),
     @lastdiscussant_20 [int],
 	 @flag integer output , 
  	 @msg varchar(80) output)
AS INSERT INTO [cowork_items] 
	 ( [name],
	 [typeid],
	 [levelvalue],
	 [creater],
	 [principal],
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
	 [accessory],
     [mutil_prjs],
     [lastdiscussant]) 
VALUES 
	( @name_1,
	 @typeid_2,
	 @levelvalue_3,
	 @creater_4,
	 @principal_5,
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
     @accessory_18,
     @mutil_prjs_19,
     @lastdiscussant_20)
select max(id) from cowork_items
GO

alter PROCEDURE [cowork_items_update]
	(@id_1 	[int],
	 @name_2 	[varchar](100),
	 @typeid_3 	[int],
	 @levelvalue_4 	[int],
	 @principal_5 	[int],
	 @mutil_prjs_6 	[varchar](500),
	 @begindate_7 	[char](10),
	 @beingtime_8 	[char](5),
	 @enddate_9 	[char](10),
	 @endtime_10 	[char](5),
	 @relatedprj_11 [varchar](500),
	 @relatedcus_12 [varchar](500),
	 @relatedwf_13 	[varchar](500),
	 @relateddoc_14 [varchar](500),
	 @remark_15 	[text],
	 @accessory_16 	[varchar](500),
	 @flag integer output , 
  	 @msg varchar(80) output)
AS UPDATE [cowork_items] 
SET  [name]	 = @name_2,
	 [typeid]	 = @typeid_3,
	 [levelvalue]	 = @levelvalue_4,
	 [principal]	 = @principal_5,
	 [mutil_prjs]	 = @mutil_prjs_6,
	 [begindate]	 = @begindate_7,
	 [beingtime]	 = @beingtime_8,
	 [enddate]	 = @enddate_9,
	 [endtime]	 = @endtime_10,
	 [relatedprj]	 = @relatedprj_11,
	 [relatedcus]	 = @relatedcus_12,
	 [relatedwf]	 = @relatedwf_13,
	 [relateddoc]	 = @relateddoc_14,
	 [remark]	 = @remark_15,
	 [accessory]	 = @accessory_16 
WHERE 
	( [id]	 = @id_1)
GO