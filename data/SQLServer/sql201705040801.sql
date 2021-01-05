delete from HtmlLabelIndex where id=130459 
GO
delete from HtmlLabelInfo where indexid=130459 
GO
INSERT INTO HtmlLabelIndex values(130459,'当增加了人员A的预算额度100时，依次增加：部门A、分部A、总部A预算额度100；') 
GO
delete from HtmlLabelIndex where id=130460 
GO
delete from HtmlLabelInfo where indexid=130460 
GO
INSERT INTO HtmlLabelIndex values(130460,'当减少了人员A的预算额度60时，依次增加：部门A、分部A、总部A预算额度-60；') 
GO
delete from HtmlLabelIndex where id=130461 
GO
delete from HtmlLabelInfo where indexid=130461 
GO
INSERT INTO HtmlLabelIndex values(130461,'自上而下编制预算') 
GO
delete from HtmlLabelIndex where id=130462 
GO
delete from HtmlLabelInfo where indexid=130462 
GO
INSERT INTO HtmlLabelIndex values(130462,'下级预算总额') 
GO
delete from HtmlLabelIndex where id=130463 
GO
delete from HtmlLabelInfo where indexid=130463 
GO
INSERT INTO HtmlLabelIndex values(130463,'下级预算总额：当前预算单位（总部、分部、部门、个人）所有下级（所有下级分部、部门、所属个人）的预算额度。') 
GO
delete from HtmlLabelIndex where id=130464 
GO
delete from HtmlLabelInfo where indexid=130464 
GO
INSERT INTO HtmlLabelIndex values(130464,'可用预算：总预算 减 审批中预算 减 已发生预算。（数据库中没有字段保存该值，始终实时计算）') 
GO
INSERT INTO HtmlLabelInfo VALUES(130464,'可用预算：总预算 减 审批中预算 减 已发生预算。（数据库中没有字段保存该值，始终实时计算）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130464,'Available budget: the total budget reduction in the budget has been approved budget. There is no field in the database to save this value, always in real time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130464,'可用預算：總預算减審批中預算减已發生預算。（資料庫中沒有欄位保存該值，始終實时計算）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(130463,'下级预算总额：当前预算单位（总部、分部、部门、个人）所有下级（所有下级分部、部门、所属个人）的预算额度。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130463,'The total budget of the current budget unit (headquarters, divisions, departments, individuals) all lower levels (all subordinate divisions, departments, individuals) budget.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130463,'下級預算總額：當前預算單位（總部、分部、部門、個人）所有下級（所有下級分部、部門、所屬個人）的預算額度。',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(130462,'下级预算总额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130462,'Lower budget',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130462,'下級預算總額',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(130461,'自上而下编制预算',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130461,'Budgeting from top to bottom',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130461,'自上而下編制預算',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(130460,'当减少了人员A的预算额度60时，依次增加：部门A、分部A、总部A预算额度-60；',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130460,'When reducing the budget amount of personnel A 60, followed by an increase: sector A, segment A, headquarters A budget limit -60;',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130460,'當减少了人員A的預算額度60時，依次新增：部門A、分部A、總部A預算額度-60；',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(130459,'当增加了人员A的预算额度100时，依次增加：部门A、分部A、总部A预算额度100；',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130459,'When increasing the budget amount of personnel A 100, followed by an increase: sector A, segment A, headquarters A budget limit of 100;',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130459,'當新增了人員A的預算額度100時，依次新增：部門A、分部A、總部A預算額度100；',9) 
GO

delete from HtmlLabelIndex where id=130465 
GO
delete from HtmlLabelInfo where indexid=130465 
GO
INSERT INTO HtmlLabelIndex values(130465,'当调整了【编制预算方式】后，预算统计口径与勾稽关系会发生相应变动，详见下面的说明描述！') 
GO
INSERT INTO HtmlLabelInfo VALUES(130465,'当调整了【编制预算方式】后，预算统计口径与勾稽关系会发生相应变动，详见下面的说明描述！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130465,'When the budget adjustment [way], budget statistics caliber and Gouji will change accordingly, as shown in the following description!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130465,'當調整了【編制預算管道】後，預算統計口徑與勾稽關係會發生相應變動，詳見下麵的說明描述！',9) 
GO

delete from HtmlLabelIndex where id=130466 
GO
delete from HtmlLabelInfo where indexid=130466 
GO
INSERT INTO HtmlLabelIndex values(130466,'总预算：分配给分部、部门、个人的预算总额，所含额度只包含自身的预算额度，不包含任何下级的预算额度') 
GO
INSERT INTO HtmlLabelInfo VALUES(130466,'总预算：分配给分部、部门、个人的预算总额，所含额度只包含自身的预算额度，不包含任何下级的预算额度',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130466,'The total budget: allocated to the Department, Department, the total budget of individuals, including the amount of the budget includes only its own budget, does not contain any lower budget',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130466,'總預算：分配給分部、部門、個人的預算總額，所含額度只包含自身的預算額度，不包含任何下級的預算額度',9) 
GO
