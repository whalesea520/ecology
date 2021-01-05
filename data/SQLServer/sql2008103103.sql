ALTER  PROCEDURE MailResource_Insert (
@resourceid_2 	[int], 
@priority_3 	[char](1), 
@sendfrom_4 	[varchar](200), 
@sendcc_5 	[varchar](4000), 
@sendbcc_6 	[varchar](4000), 
@sendto_7 	[varchar](4000), 
@senddate_8 	[varchar](30), 
@size_9 	[int], 
@subject_10 	[varchar](250), 
@content_11 	[text], 
@mailtype_12	[char](1) , 
@hasHtmlImage_13	[char](1) ,
@mailAccountId_14 int,
@status_15 char(1), 
@folderId_16 int,
@flag	[int]	output, 
@msg	[varchar](80)	output)  
AS 
INSERT INTO [MailResource] ([resourceid], [priority], [sendfrom], [sendcc], [sendbcc], [sendto], [senddate], [size_n], [subject], [content], mailtype, [hasHtmlImage], mailAccountId, status, folderId)  
VALUES (@resourceid_2, @priority_3, @sendfrom_4, @sendcc_5, @sendbcc_6, @sendto_7, @senddate_8, @size_9, @subject_10, @content_11, @mailtype_12, @hasHtmlImage_13, @mailAccountId_14, @status_15, @folderId_16)   
select max(id) from MailResource 

GO