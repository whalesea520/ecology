delete from HtmlLabelIndex where id=21818 
GO
delete from HtmlLabelInfo where indexid=21818 
GO
INSERT INTO HtmlLabelIndex values(21818,'如果勾选，流程分叉节点的操作人可以查看其它分叉的副本的内容。') 
GO
delete from HtmlLabelIndex where id=21815 
GO
delete from HtmlLabelInfo where indexid=21815 
GO
INSERT INTO HtmlLabelIndex values(21815,'是否创建正文副本') 
GO
delete from HtmlLabelIndex where id=21819 
GO
delete from HtmlLabelInfo where indexid=21819 
GO
INSERT INTO HtmlLabelIndex values(21819,'副本') 
GO
delete from HtmlLabelIndex where id=21816 
GO
delete from HtmlLabelInfo where indexid=21816 
GO
INSERT INTO HtmlLabelIndex values(21816,'在流程分叉中，每个分叉有一个独立的正文副本，流程分叉节点操作人对副本进行编辑操作。') 
GO
delete from HtmlLabelIndex where id=21817 
GO
delete from HtmlLabelInfo where indexid=21817 
GO
INSERT INTO HtmlLabelIndex values(21817,'副本间是否可看') 
GO
INSERT INTO HtmlLabelInfo VALUES(21815,'是否创建正文副本',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21815,'Whether Create copies for Text',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21816,'在流程分叉中，每个分叉有一个独立的正文副本，流程分叉节点操作人对副本进行编辑操作。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21816,'In workflow bifurcation, every bifurcation has a copy. The operator operates himself''s copy!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21817,'副本间是否可看',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21817,'Whether can see other''s copy',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21818,'如果勾选，流程分叉节点的操作人可以查看其它分叉的副本的内容。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21818,'If choosed, the workflow operator can see other''''s copy.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21819,'副本',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21819,'Copy',8) 
GO
delete from HtmlLabelIndex where id=21821 
GO
delete from HtmlLabelInfo where indexid=21821 
GO
INSERT INTO HtmlLabelIndex values(21821,'（曾被您处理过）') 
GO
INSERT INTO HtmlLabelInfo VALUES(21821,'（曾被您处理过）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21821,'(Has been processed by yourself)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21821,'',0) 
GO
