delete from HtmlLabelIndex where id=31265 
GO
delete from HtmlLabelInfo where indexid=31265 
GO
INSERT INTO HtmlLabelIndex values(31265,'删除后，本文件夹连同本文件夹内所有邮件均会被删除。是否确认') 
GO
delete from HtmlLabelIndex where id=31266 
GO
delete from HtmlLabelInfo where indexid=31266 
GO
INSERT INTO HtmlLabelIndex values(31266,'清空后，本文件夹内所有邮件均会被删除。是否确认') 
GO
INSERT INTO HtmlLabelInfo VALUES(31265,'删除后，本文件夹连同本文件夹内所有邮件均会被删除。是否确认',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(31265,'Delete the folder together with the folder, all messages will be deleted.Are you sure',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(31265,'删除後，本文件夾連同本文件夾内所有郵件均會被删除。是否确認',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(31266,'清空后，本文件夹内所有邮件均会被删除。是否确认',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(31266,'Emptied, the folder, all messages will be deleted.to confirm',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(31266,'清空後，本文件夾内所有郵件均會被删除。是否确認',9) 
GO