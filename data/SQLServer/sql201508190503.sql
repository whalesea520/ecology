CREATE TABLE mobile_ChatResourceShare (
	ID INTEGER PRIMARY KEY IDENTITY,   
	resourceType INT,
	resourceid INT,
	sharer INT,
	sharertype INT,
	shareGroupID INT
)
GO
CREATE INDEX mobile_ChatResourceShare_index ON mobile_ChatResourceShare(sharer, resourceType, resourceid)
GO
CREATE TABLE mobile_ChatResourceShareScope(
	shareid INT, 
	resoueceid INT,
	resouecetype INT
)
GO