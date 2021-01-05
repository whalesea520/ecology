CREATE TABLE DocUserselfCategory (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[userid] int NULL ,
	[name] [varchar] (255)  NULL ,
	[parentid] int NULL ,
	[parentids] [varchar] (255)  NULL ,
	[createdate] [varchar] (10) NULL ,
	[createtime] [varchar] (8) NULL 
) 
GO


CREATE PROCEDURE [DocUserselfCategory_Insert]
	(@userid_1 	[int],
	 @name_2 	[varchar](255),
	 @parentid_3 	[int],
	 @parentids_4 	[varchar](255),
	@createdate [varchar] (10)  ,
	@createtime [varchar] (8) , 
 @flag	[int]	output, 
 @msg	[varchar](80)	output)

AS INSERT INTO [DocUserselfCategory] 
	 ( [userid],
	 [name],
	 [parentid],
	 [parentids],
	 [createdate],
	 [createtime]) 
 
VALUES 
	( @userid_1,
	 @name_2,
	 @parentid_3,
	 @parentids_4,
	 @createdate,
	 @createtime)

select max(id) from DocUserselfCategory 
set @flag = 1 set @msg = 'OK!'

go


CREATE PROCEDURE [DocUserselfCategory_Update]
	(@id_1 	[int],
	 @userid_2 	[int],
	 @name_3 	[varchar](255),
	 @parentid_4 	[int],
	 @parentids_5 	[varchar](255), 
 @flag	[int]	output, 
 @msg	[varchar](80)	output)

AS UPDATE [DocUserselfCategory] 

SET  [userid]	 = @userid_2,
	 [name]	 = @name_3,
	 [parentid]	 = @parentid_4,
	 [parentids]	 = @parentids_5 

WHERE 
	( [id]	 = @id_1)

set @flag = 1 set @msg = 'OK!'

go


CREATE PROCEDURE [DocUserselfCategory_Delete]
	(@id_1 	[int], 
 @flag	[int]	output, 
 @msg	[varchar](80)	output)

AS DELETE [DocUserselfCategory] 

WHERE 
	( [id]	 = @id_1)
	
	go


CREATE PROCEDURE [DocUserselfCategory_SelectByID]
	(@id_1 	[int], 
 @flag	[int]	output, 
 @msg	[varchar](80)	output)

AS 
select * from [DocUserselfCategory] 

WHERE 
	( [id]	 = @id_1)
	
	go


CREATE TABLE DocUserselfDocs (
	docid int NOT NULL ,
	userCatalogId int NULL,
	userid int NULL,
	doctype int NULL,
    usertype int null
) 
GO
 