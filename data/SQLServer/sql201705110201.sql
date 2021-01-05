delete from HtmlLabelIndex where id=130560 
GO
delete from HtmlLabelInfo where indexid=130560 
GO
INSERT INTO HtmlLabelIndex values(130560,'新预算额必须大于已发生、审批中预算之和！') 
GO
INSERT INTO HtmlLabelInfo VALUES(130560,'新预算额必须大于已发生、审批中预算之和！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130560,'The new budget must be greater than the sum of the budget!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130560,'新預算額必須大於已發生、審批中預算之和！',9) 
GO