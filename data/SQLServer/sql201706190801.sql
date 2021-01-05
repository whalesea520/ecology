delete from HtmlLabelIndex where id=130844 
GO
delete from HtmlLabelInfo where indexid=130844 
GO
INSERT INTO HtmlLabelIndex values(130844,'该节点为签章节点，请先签章，再提交') 
GO
INSERT INTO HtmlLabelInfo VALUES(130844,'该节点为签章节点，请先签章，再提交',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130844,'here is sign node,please sign word before submit',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130844,'該節點為簽章節點，請先簽章，再提交',9) 
GO