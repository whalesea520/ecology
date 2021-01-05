

alter table Prj_ProjectType add insertWorkPlan char(1)
go
update Prj_ProjectType set insertWorkPlan='1'
go

Alter PROCEDURE Prj_ProjectType_Update
(
	@id	 	int, 
	@fullname 	varchar(50),
	@description 	varchar(150), 
	@protypecode varchar(50), 
	@wfid	 	int, 
	@insertWorkPlan char(1),
	@flag	int	output,
	@msg	varchar(80)	output
)  AS
	UPDATE Prj_ProjectType  
	SET  fullname	 = @fullname, description	 = @description, wfid	 = @wfid ,protypecode=@protypecode, insertWorkPlan=@insertWorkPlan
	WHERE ( id	 = @id)  
set @flag = 1 
set @msg = 'OK!'

GO


alter PROCEDURE Prj_ProjectType_Insert (
    @fullname  varchar(50),
    @description    varchar(150),
    @wfid       int,
    @protypecode varchar(50),
    @insertWorkPlan char(1),
    @flag   int output,
    @msg    varchar(80) output) 
 AS 

    INSERT INTO Prj_ProjectType 
    ( fullname, description, wfid, protypecode, insertWorkPlan) 
    VALUES ( @fullname, @description, @wfid, @protypecode, @insertWorkPlan)  

    set @flag = 1 set @msg = 'OK!'
GO