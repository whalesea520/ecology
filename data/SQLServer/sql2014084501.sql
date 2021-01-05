delete from HtmlLabelIndex where id=23154 
GO
delete from HtmlLabelInfo where indexid=23154 
GO
INSERT INTO HtmlLabelIndex values(23154,'触发说明1''''') 
GO
INSERT INTO HtmlLabelInfo VALUES(23154,'主表中必须包含主键(默认为id)，流程标识(默认为requestid，整型)，触发成功标识(默认为FTriggerFlag，已读未读标记位，初始值必须为0，表示未读，读取后会自动更新为1)这三个字段；',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23154,'reamrk1.1',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23154,'主表中必須包含主鍵(默認爲id)，流程标識(默認爲requestid，整型)，觸發成功标識(默認爲FTriggerFlag，已讀未讀标記位，初始值必須爲0，表示未讀，讀取後會自動更新爲1)這三個字段；',9) 
GO
