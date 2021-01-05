delete from HtmlLabelIndex where id=82807 
GO
delete from HtmlLabelInfo where indexid=82807 
GO
INSERT INTO HtmlLabelIndex values(82807,'安全级别下限的值不能大于上限的值！') 
GO
INSERT INTO HtmlLabelInfo VALUES(82807,'安全级别下限的值不能大于上限的值！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(82807,'Security levels minimum value cannot be greater than maximum value!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(82807,'安全級别下限的值不能大于上限的值！',9) 
GO

delete from HtmlLabelIndex where id=82808 
GO
delete from HtmlLabelInfo where indexid=82808 
GO
INSERT INTO HtmlLabelIndex values(82808,'安全级别上限的值不能小于下限的值！') 
GO
INSERT INTO HtmlLabelInfo VALUES(82808,'安全级别上限的值不能小于下限的值！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(82808,'Security level value cannot be less than the upper limit lower limit value!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(82808,'安全級别上限的值不能小于下限的值！',9) 
GO
