delete from HtmlLabelIndex where id=130101 
GO
delete from HtmlLabelInfo where indexid=130101 
GO
INSERT INTO HtmlLabelIndex values(130101,'被退回的流程签字意见必填') 
GO
INSERT INTO HtmlLabelInfo VALUES(130101,'被退回的流程签字意见必填',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130101,'the remark is required when current process is rejected',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130101,'被退回的流程簽字意見必填',9) 
GO