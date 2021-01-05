alter PROCEDURE Meeting_Member2_SelectByType 
(@meetingId int, @memberType int, @flag	int output, @msg varchar(80) output) 
AS 
SELECT * FROM Meeting_Member2 
WHERE meetingId = @meetingId 
AND memberType = @memberType
ORDER BY id ASC
SET @flag = 1 
SET @msg = 'OK!' 

GO
