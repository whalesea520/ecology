delete from HtmlLabelIndex where id=382089 
GO
delete from HtmlLabelInfo where indexid=382089 
GO
INSERT INTO HtmlLabelIndex values(382089,'启用之后，若费用限额大于计算后费用标准额度，则流程不允许提交；不启用，则不影响流程提交。') 
GO
delete from HtmlLabelIndex where id=382091 
GO
delete from HtmlLabelInfo where indexid=382091 
GO
INSERT INTO HtmlLabelIndex values(382091,'费用标准总额度=费用标准*费用标准系数（ 无字段映射费用标准系数时，系数为1）') 
GO
INSERT INTO HtmlLabelInfo VALUES(382091,'费用标准总额度=费用标准*费用标准系数（ 无字段映射费用标准系数时，系数为1）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382091,'Total cost standard = cost standard * cost standard coefficient (when no field mapping cost standard coefficient, coefficient is 1)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382091,'費用标準總額度=費用标準*費用标準系數（ 無字段映射費用标準系數時，系數爲1）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(382089,'启用之后，若费用限额大于计算后费用标准额度，则流程不允许提交；不启用，则不影响流程提交。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382089,'After the operation, the process is not allowed to submit if the cost limit is larger than the amount of the calculated cost standard.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382089,'啓用之後，若費用限額大于計算後費用标準額度，則流程不允許提交；不啓用，則不影響流程提交。',9) 
GO