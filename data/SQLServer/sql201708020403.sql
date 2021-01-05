IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('smspropertis'))
ALTER TABLE smspropertis ALTER COLUMN val varchar(1000) 
GO