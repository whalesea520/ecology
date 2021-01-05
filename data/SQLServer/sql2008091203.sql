if exists(select * from  sysobjects where name='T_InputReportItem_SelectByItemid' and xtype='p') 
  DROP PROCEDURE T_InputReportItem_SelectByItemid
GO

CREATE PROCEDURE T_IReportItem_SelectByItemid (
	@itemid_1  int , 
	@flag	int	output,
	@msg	varchar(80)	output
	) 
AS
	select * from T_InputReportItem where itemid = @itemid_1
GO

