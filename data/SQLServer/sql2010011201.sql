delete from HtmlLabelIndex where id=24125 
GO
delete from HtmlLabelInfo where indexid=24125 
GO
INSERT INTO HtmlLabelIndex values(24125,'不能选择自己为自己的上级或者下级科目！') 
GO
INSERT INTO HtmlLabelInfo VALUES(24125,'不能选择自己为自己的上级或者下级科目！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24125,'Can not choose for themselves the superior or subordinate subjects!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24125,'不能选择自己为自己的上级或者下级科目！',9) 
GO
