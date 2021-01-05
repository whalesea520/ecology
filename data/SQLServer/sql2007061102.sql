CREATE TABLE Meeting_View_Status
(
	id                int IDENTITY(1, 1)   PRIMARY KEY NOT NULL,
	meetingId 	      int                  NULL,
	userId 	          int                  NULL,
	userType          char(1)              NULL,
	status		      char(1)              NULL
)
GO

INSERT INTO HPFieldElement(id, elementId, fieldName, fieldColumn, isDate, transMethod, fieldWidth, linkUrl, valueColumn, isLimitLength, orderNum)
VALUES(64, 12, '602', 'meetingStatus', '0', 'getMeetingStatus', '15', '', '', '', 3)
GO

UPDATE HPFieldElement SET orderNum = 4 WHERE id = 29
GO

UPDATE HPFieldElement SET orderNum = 5 WHERE id = 30
GO