delete from HtmlLabelIndex where id=23043 
GO
delete from HtmlLabelInfo where indexid=23043 
GO
INSERT INTO HtmlLabelIndex values(23043,'该节点为签章节点，您未执行签章操作，是否确定提交？') 
GO
INSERT INTO HtmlLabelInfo VALUES(23043,'该节点为签章节点，您未执行签章操作，是否确定提交？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23043,'The node is signature node,you do not implement signature operations,to determine whether or not to submit?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23043,'該節點為簽章節點，您未執行簽章操作，是否確定提交？',9) 
GO
