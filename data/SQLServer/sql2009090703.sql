ALTER TABLE cowork_items ADD mutil_prjs VARCHAR(500) NULL
go
ALTER TABLE cowork_discuss ADD mutil_prjs VARCHAR(500) NULL
go

ALTER PROCEDURE [cowork_discuss_insert]
	(@coworkid_1 	[int],
	 @discussant_2 	[int],
	 @createdate_3 	[char](10),
	 @createtime_4 	[char](8),
	 @remark_5 	[text],
	 @relatedprj_6  [varchar](500),
	 @relatedcus_7  [varchar](500),
	 @relatedwf_8 	[varchar](500),
	 @relateddoc_9  [varchar](500),
         @relatedacc_10 [varchar](500),
         @mutil_prjs_11 [varchar](500),
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
	 [relateddoc],
         [ralatedaccessory],
	 [mutil_prjs]) 
 
VALUES 
	( @coworkid_1,
	 @discussant_2,
	 @createdate_3,
	 @createtime_4,
	 @remark_5,
	 @relatedprj_6,
	 @relatedcus_7,
	 @relatedwf_8,
	 @relateddoc_9,
         @relatedacc_10,
	 @mutil_prjs_11)
	 


GO