 ALTER PROCEDURE CRM_SectorInfo_SelectAll 
 (@parentid	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_SectorInfo] WHERE	([parentid] = @parentid)  order by id asc  set @flag = 1 set @msg = 'OK!' 
GO

 ALTER PROCEDURE CRM_CustomerType_SelectAll 
 (@flag [int] output, @msg	[varchar](80) output) AS SELECT * FROM [CRM_CustomerType] order by id asc set @flag = 1 set @msg = 'OK!' 
GO

 ALTER PROCEDURE CRM_CustomerSize_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerSize] order by id asc  set @flag = 1 set @msg = 'OK!' 
GO

 ALTER PROCEDURE CRM_CustomerDesc_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_CustomerDesc] order by id asc  set @flag = 1 set @msg = 'OK!' 
GO

ALTER PROCEDURE CRM_ContactWay_SelectAll 
 (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_ContactWay]  order by id asc set @flag = 1 set @msg = 'OK!' 
GO
