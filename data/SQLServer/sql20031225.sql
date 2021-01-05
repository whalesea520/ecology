ALTER PROCEDURE WorkFlow_BrowserUrl_Insert
	(@id_1 	int,
	 @labelid_2 	int,
	 @fielddbtype_3 	varchar(40),
	 @browserurl_4 	varchar(255),
	 @tablename_5 	varchar(50),
	 @columname_6 	varchar(50),
	 @keycolumname_7 	varchar(50),
	 @linkurl_8 	varchar(255),
	 @flag int output,
	 @msg varchar(60) output
)
AS INSERT INTO workflow_browserurl 
	 ( id,
	 labelid,
	 fielddbtype,
	 browserurl,
	 tablename,
	 columname,
	 keycolumname,
	 linkurl) 
 
VALUES 
	(@id_1, 
	@labelid_2,
	 @fielddbtype_3,
	 @browserurl_4,
	 @tablename_5,
	 @columname_6,
	 @keycolumname_7,
	 @linkurl_8)
GO




CREATE TABLE Tmp_workflow_browserurl
	(
	id int NOT NULL,
	labelid int NULL,
	fielddbtype varchar(40) NULL,
	browserurl varchar(255) NULL,
	tablename varchar(50) NULL,
	columname varchar(50) NULL,
	keycolumname varchar(50) NULL,
	linkurl varchar(255) NULL
	)  
GO

IF EXISTS(SELECT * FROM workflow_browserurl)
	 EXEC('INSERT INTO Tmp_workflow_browserurl (id, labelid, fielddbtype, browserurl, tablename, columname, keycolumname, linkurl)
		SELECT id, labelid, fielddbtype, browserurl, tablename, columname, keycolumname, linkurl FROM workflow_browserurl TABLOCKX')
GO
DROP TABLE workflow_browserurl
GO
EXECUTE sp_rename N'Tmp_workflow_browserurl', N'workflow_browserurl', 'OBJECT'
GO


