CREATE TABLE DocPreview ( 
    id int NOT NULL IDENTITY(1,1) PRIMARY key,
    imageFileId int,
    filePath varchar(500),
    pdfFileId int,
    pdfPath varchar(500),
    swfFileId int,
    swfPath varchar(500),
    swfPageCount int,
    previewCount int,
    systemtag varchar(100),
    fileTableName varchar(60),
    mustReconverted char(1)  default '0',
    createDate char(10),
    createTime char(8),
    lastAccessDate char(10),
    lastAccessTime char(8)
) 
GO
CREATE TABLE DocPreviewHistory ( 
    id int NOT NULL IDENTITY(1,1) PRIMARY key,
    imageFileId int,
    filePath varchar(500),
    pdfFileId int,
    pdfPath varchar(500),
    swfFileId int,
    swfPath varchar(500),
    swfPageCount int,
    previewCount int,
    systemtag varchar(100),
    fileTableName varchar(60),
    mustReconverted char(1)  default '0',
    createDate char(10),
    createTime char(8),
    lastAccessDate char(10),
    lastAccessTime char(8)
) 
GO
CREATE index DocPreview_fileId_in ON DocPreview(imageFileId)
GO
CREATE index DocPreviewHistory_fileId_in ON DocPreviewHistory(imageFileId)
GO

alter TRIGGER Tri_ImageFile_BackUp ON ImageFile WITH ENCRYPTION
FOR UPDATE
AS
Declare @imageFileId_1 int
select @imageFileId_1 = imageFileId from deleted
insert into ImageFileBackUp(imageFileId) values(@imageFileId_1)
update DocPreview set mustReconverted='1' where imageFileId=@imageFileId_1
GO