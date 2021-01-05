

alter PROCEDURE [cowork_items_insert]
	(@name_1 	[varchar](100),
	 @typeid_2 	[int],
	 @levelvalue_3 	[int],
	 @creater_4 	[int],
	 @coworkers_5 	[varchar](255),
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

alter PROCEDURE [cowork_discuss_insert]
	(@coworkid_1 	[int],
	 @discussant_2 	[int],
	 @createdate_3 	[char](10),
	 @createtime_4 	[char](8),
	 @remark_5 	[text],
	 @relatedprj_6  [varchar](500),
	 @relatedcus_7  [varchar](500),
	 @relatedwf_8 	[varchar](500),
	 @relateddoc_9  [varchar](500),
	 @flag integer output , 
  	 @msg varchar(80) output)

AS INSERT INTO [cowork_discuss] 
	 ( [coworkid],
	 [discussant],
	 [createdate],
	 [createtime],
	 [remark],
	 [relatedprj],
	 [relatedcus],
	 [relatedwf],
	 [relateddoc]) 
 
VALUES 
	( @coworkid_1,
	 @discussant_2,
	 @createdate_3,
	 @createtime_4,
	 @remark_5,
	 @relatedprj_6,
	 @relatedcus_7,
	 @relatedwf_8,
	 @relateddoc_9)
	 


GO

alter table cowork_items alter column createtime char(8)
GO
alter table cowork_discuss alter column createtime char(8)
GO