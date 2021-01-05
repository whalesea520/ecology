delete from HtmlLabelIndex where id=22160 
GO
delete from HtmlLabelInfo where indexid=22160 
GO
INSERT INTO HtmlLabelIndex values(22160,'登录用户数已到license上限,无法进行帐户类型修改操作！') 
GO
INSERT INTO HtmlLabelInfo VALUES(22160,'登录用户数已到license上限,无法进行帐户类型修改操作！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22160,'The number of users log on to the license limit has been unable to account for the type of revision operation!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22160,'登錄用戶數已到license上限,無法進行帳戶類型修改操作！',9) 
GO
