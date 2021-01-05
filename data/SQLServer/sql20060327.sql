DECLARE @minLeftMenuId int
SELECT @minLeftMenuId=ISNULL(MIN(id)-1,-1) FROM LeftMenuInfo WHERE id<0
INSERT INTO SequenceIndex (indexdesc,currentid) VALUES ('leftmenuid',@minLeftMenuId)
GO


/*»ñÈ¡×ó²Ëµ¥SequenceID*/
CREATE PROCEDURE LeftMenuSequenceId_Get(
	@flag int output, 
	@msg varchar(60) output
)
AS 
DECLARE @id_1 INT
SELECT @id_1=currentid FROM SequenceIndex WHERE indexdesc='leftmenuid'
UPDATE SequenceIndex SET currentid=currentid-1 WHERE indexdesc='leftmenuid'
SELECT @id_1
GO

