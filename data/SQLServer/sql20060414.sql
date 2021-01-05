alter table cowork_types alter column managerid text
go
alter table cowork_types alter column members text
go

alter PROCEDURE [cowork_types_update]
	(@id_1 	[int],
	 @typename_2 	[varchar](100),
	 @departmentid_3 	[int],
	 @managerid_4 	[text],
	 @members_5 	[text],
	@flag integer output , 
  	@msg varchar(80) output)

AS UPDATE [cowork_types] 

SET  [typename]	 = @typename_2,
	 [departmentid]	 = @departmentid_3,
	 [managerid]	 = @managerid_4,
	 [members]	 = @members_5 

WHERE 
	( [id]	 = @id_1)
GO

alter PROCEDURE [cowork_types_insert]
	(@typename_1 	[varchar](100),
	 @departmentid_2 	[int],
	 @managerid_3 	[text],
	 @members_4 	[text],
	@flag integer output , 
  	@msg varchar(80) output  )

AS INSERT INTO [cowork_types] 
	 ( [typename],
	 [departmentid],
	 [managerid],
	 [members]) 
 
VALUES 
	( @typename_1,
	 @departmentid_2,
	 @managerid_3,
	 @members_4)
	 

GO