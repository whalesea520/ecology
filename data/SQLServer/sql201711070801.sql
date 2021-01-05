delete from HtmlLabelIndex where id=132005 
GO
delete from HtmlLabelInfo where indexid=132005 
GO
INSERT INTO HtmlLabelIndex values(132005,'标题包含全角字符，请重新输入！') 
GO
INSERT INTO HtmlLabelInfo VALUES(132005,'标题包含全角字符，请重新输入！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132005,'The title contains the full Angle character, please re-enter!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132005,'標題包含全角字符，請重新輸入！',9) 
GO