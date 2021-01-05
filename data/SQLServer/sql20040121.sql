ALTER PROCEDURE Meeting_Topic_SelectAll 
( @meetingid [int],  @flag	[int]	output, @msg	[varchar](80)	output) 
AS 
SELECT * FROM [Meeting_Topic] where meetingid = @meetingid ORDER BY id set @flag = 1 set @msg = 'OK!' 
GO
UPDATE license set cversion = '2.62'
go