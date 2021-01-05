alter table CRM_ContractPayMethod alter column payPrice decimal(17,2)
alter table CRM_ContractPayMethod alter column factPrice decimal(17,2)

if exists (select * from sysobjects where id = object_id(N'[CRM_ContractPayMethod_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [CRM_ContractPayMethod_Insert]
GO

if exists (select * from sysobjects where id = object_id(N'[CRM_ContractPayMethod_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [CRM_ContractPayMethod_Update]
GO

if exists (select * from sysobjects where id = object_id(N'[CRM_ContractPayMethod_Update1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [CRM_ContractPayMethod_Update1]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE CRM_ContractPayMethod_Insert 
	(
	 @contractId_1  int  ,	
	 @prjName_1  varchar (100)   ,
	 @typeId_1  int  ,
	 @payPrice_1  decimal(17, 2)  ,
	 @payDate_1  char (10)   ,
	 @factPrice_1  decimal(17, 2)  ,
	 @factDate_1  char (10)  ,
	 @qualification_1 varchar (200) ,
	 @isFinish_1  int  ,
	 @isRemind_1  int  ,
	 @feetypeid_1 int,
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO CRM_ContractPayMethod 
	 (contractId , 
	 prjName , 
	 typeId , payPrice , payDate , factPrice , factDate , qualification , isFinish , isRemind,feetypeid ) 
 
VALUES 
	(@contractId_1,
	 @prjName_1,
	 @typeId_1, @payPrice_1 , @payDate_1 , @factPrice_1 , @factDate_1 , @qualification_1 , @isFinish_1 , @isRemind_1,@feetypeid_1)


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE CRM_ContractPayMethod_Update 
	(@id_1 	[int] ,
	 @factPrice_1  [decimal](17, 2)  ,
	 @factDate_1  [char] (10)  ,	
	 @isFinish_1  [int]  ,
	 @isRemind_1  [int] , 
	 @flag integer output,
	 @msg varchar(80) output)

AS
UPDATE CRM_ContractPayMethod SET factPrice = @factPrice_1, factDate = @factDate_1 , isFinish = @isFinish_1 , isRemind = @isRemind_1  where id = @id_1


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE PROCEDURE CRM_ContractPayMethod_Update1
	(
	 @id_1 	[int] ,	
	 @prjName_1  [varchar] (100)   ,
	 @typeId_1  [int]  ,
	 @feetypeid_1 [int]  ,
	 @payPrice_1  [decimal](17, 2)  ,
	 @payDate_1  [char] (10)   ,
	 @qualification_1 [varchar] (200) ,
	 @isRemind_1  [int]  ,	
	 @flag integer output,
	 @msg varchar(80) output)

AS UPDATE CRM_ContractPayMethod SET 
	 prjName = @prjName_1 , 
	 typeId = @typeId_1, 
	 feetypeid = @feetypeid_1,
	 payPrice = @payPrice_1, 
	 payDate = @payDate_1,
	 qualification = @qualification_1 , 
	 isRemind = @isRemind_1 where id = @id_1 


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

