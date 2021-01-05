delete from HtmlLabelIndex where id=127805 
GO
delete from HtmlLabelInfo where indexid=127805 
GO
INSERT INTO HtmlLabelIndex values(127805,'MD5加密') 
GO
delete from HtmlLabelIndex where id=127806 
GO
delete from HtmlLabelInfo where indexid=127806 
GO
INSERT INTO HtmlLabelIndex values(127806,'HR 同步密码同步规则') 
GO
INSERT INTO HtmlLabelInfo VALUES(127806,'MD5加密：将中间表密码字段值做MD5加密后同步到OA人力资源表的密码字段，要求中间表密码字段值为明文。复制   ：将中间表的密码字段值同步到OA人力资源表的密码字段，要求中间表密码字段值为MD5加密。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127806,'MD5 encryption: the intermediate table password field values do the MD5 encrypted password field of the synchronization to OA human resources table, requires intermediate table password field value is clear.Replication: password sync field value to a table in the middle of OA human resources table password field requiring intermediate table value is MD5 encrypted password field.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127806,'MD5加密：將中間表密碼字段值做MD5加密後同步到OA人力資源表的密碼字段，要求中間表密碼字段值爲明文。複制   ：將中間表的密碼字段值同步到OA人力資源表的密碼字段，要求中間表密碼字段值爲MD5加密。',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(127805,'MD5加密',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127805,'MD5加密',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127805,'MD5 encryption',9) 
GO