drop TABLE workflow_texttopdf 
GO
CREATE TABLE workflow_texttopdf (
	id int NOT NULL IDENTITY(1,1) ,
	requestid int null,
	docId int  null,
	pdfDocId int null,
	pdfImageFileId int null,
	decryptPdfDocId  int null,
	decryptPdfImageFileId int null,
	transformDate char(10) null,
	transformTime char(8) null
)
GO