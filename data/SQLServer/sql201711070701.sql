delete from HtmlLabelIndex where id=132004 
GO
delete from HtmlLabelInfo where indexid=132004 
GO
INSERT INTO HtmlLabelIndex values(132004,'标题包含特殊字符，请重新输入！') 
GO
INSERT INTO HtmlLabelInfo VALUES(132004,'标题包含特殊字符，请重新输入！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132004,'The title contains special characters, please re-enter!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132004,'標題包含特殊字符，請重新輸入！',9) 
GO