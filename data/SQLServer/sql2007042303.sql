UPDATE WorkPlan 
SET description = REPLACE(CAST(description AS varchar(8000)), char(10), '<br>') 
WHERE description LIKE '%'+char(10)+'%'
GO

UPDATE WorkPlan 
SET description = REPLACE(CAST(description AS varchar(8000)), char(13), '') 
WHERE description LIKE '%'+char(13)+'%'
GO
