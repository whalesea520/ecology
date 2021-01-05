CREATE TABLE workflow_texttopdfconfig (
	id int NOT NULL IDENTITY(1,1) ,
	workflowid int null,
	topdfnodeid int  null,
	pdfsavesecid int null,
	catalogtype2 char(1) null,
	selectcatalog2 int null,
	pdfdocstatus  int null,
	pdffieldid  int null,
	decryptpdfsavesecid int null,
	decryptcatalogtype2 char(1) null,
	decryptselectcatalog2 int null,
	decryptpdfdocstatus  int null,
	decryptpdffieldid  int null
)
GO




CREATE TABLE workflow_texttopdf (
	id int NOT NULL IDENTITY(1,1) ,
	topdfnodeid int  null,
	pdfsavesecid int null,
	catalogtype2 char(1) null,
	selectcatalog2 int null,
	pdfdocstatus  int null,
	decryptpdfsavesecid int null,
	decryptcatalogtype2 char(1) null,
	decryptselectcatalog2 int null,
	decryptpdfdocstatus  int null
)
GO