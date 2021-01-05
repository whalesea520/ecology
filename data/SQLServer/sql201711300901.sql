delete from HtmlLabelIndex where id=132223 
GO
delete from HtmlLabelInfo where indexid=132223 
GO
INSERT INTO HtmlLabelIndex values(132223,'参数名包含特殊字符，请重新输入！') 
GO
INSERT INTO HtmlLabelInfo VALUES(132223,'参数名包含特殊字符，请重新输入！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132223,'The name contains special characters, please re-enter!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132223,'參數名包含特殊字符，請重新輸入！',9) 
GO
