Alter PROCEDURE [cowork_types_insert]
	(@typename_1 	[varchar](100),
	 @departmentid_2 	[int],
	 @managerid_3 	[varchar](3000),
	 @members_4 	[varchar](4900),
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

Alter PROCEDURE [cowork_types_update]
	(@id_1 	[int],
	 @typename_2 	[varchar](100),
	 @departmentid_3 	[int],
	 @managerid_4 	[varchar](3000),
	 @members_5 	[varchar](4900),
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

alter table cowork_types alter column managerid varchar(3000)
GO
alter table cowork_types alter column members varchar(4900)
GO

INSERT INTO HtmlLabelIndex values(17999,'δ�鵵') 
GO
INSERT INTO HtmlLabelInfo VALUES(17999,'δ�鵵',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17999,'not finished',8) 
GO
