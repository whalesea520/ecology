delete from HtmlLabelIndex where id=25775 
GO
delete from HtmlLabelInfo where indexid=25775 
GO
INSERT INTO HtmlLabelIndex values(25775,'节点名称不能包含,<>''\"特殊字符，请重新输入！') 
GO
INSERT INTO HtmlLabelInfo VALUES(25775,'节点名称不能包含,<>''\"特殊字符，请重新输入！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(25775,'Node name can not contain ,<>''\"special characters, please try again!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(25775,'節點名稱不能包含,<>''\"特殊字符，請重新輸入！',9) 
GO
