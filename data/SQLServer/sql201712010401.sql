delete from HtmlLabelIndex where id=132215 
GO
delete from HtmlLabelInfo where indexid=132215 
GO
INSERT INTO HtmlLabelIndex values(132215,'费用限额系数') 
GO
INSERT INTO HtmlLabelInfo VALUES(132215,'费用限额系数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132215,'Cost limit coefficient',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132215,'費用限額系數',9) 
GO

delete from HtmlLabelIndex where id=132218 
GO
delete from HtmlLabelInfo where indexid=132218 
GO
INSERT INTO HtmlLabelIndex values(132218,'费用标准系数') 
GO
INSERT INTO HtmlLabelInfo VALUES(132218,'费用标准系数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132218,'Cost standard coefficient',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132218,'費用标準系數',9) 
GO

delete from HtmlLabelIndex where id=132219 
GO
delete from HtmlLabelInfo where indexid=132219 
GO
INSERT INTO HtmlLabelIndex values(132219,'费用标准*费用标准系数（如不匹配费用标准系数字段，则默认按系数1参与计算）获取的值与费用限额字段进行比较，如果费用限额大于计算后的费用标准额度则会通过action阻止流程提交。') 
GO
INSERT INTO HtmlLabelInfo VALUES(132219,'费用标准*费用标准系数（如不匹配费用标准系数字段，则默认按系数1参与计算）获取的值与费用限额字段进行比较，如果费用限额大于计算后的费用标准额度则会通过action阻止流程提交。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132219,'The cost standard * the cost standard coefficient (such as the mismatched cost standard coefficient field, the default is calculated by coefficient 1), and the value obtained is compared with the cost limit field. If the cost limit is greater than the calculated cost standard amount, it will be submitted through the action blocking process.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132219,'費用标準*費用标準系數（如不匹配費用标準系數字段，則默認按系數1參與計算）獲取的值與費用限額字段進行比較，如果費用限額大于計算後的費用标準額度則會通過action阻止流程提交。',9) 
GO

delete from HtmlLabelIndex where id=132220 
GO
delete from HtmlLabelInfo where indexid=132220 
GO
INSERT INTO HtmlLabelIndex values(132220,'费用标准超额控制action配置信息：') 
GO
INSERT INTO HtmlLabelInfo VALUES(132220,'费用标准超额控制action配置信息：',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132220,'Cost standard excess control action configuration information:',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132220,'費用标準超額控制action配置信息：',9) 
GO

delete from HtmlLabelIndex where id=132224 
GO
delete from HtmlLabelInfo where indexid=132224 
GO
INSERT INTO HtmlLabelIndex values(132224,'生成字段属性SQL') 
GO
INSERT INTO HtmlLabelInfo VALUES(132224,'生成字段属性SQL',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132224,'Generate field property SQL',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132224,'生成字段屬性SQL',9) 
GO