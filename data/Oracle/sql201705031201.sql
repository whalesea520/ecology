delete from HtmlLabelIndex where id=130419 
/
delete from HtmlLabelInfo where indexid=130419 
/
INSERT INTO HtmlLabelIndex values(130419,'当修改了人员A的预算额度-60时，增依次增加：部门A、分部A、总部A预算额度-60；') 
/
delete from HtmlLabelIndex where id=130420 
/
delete from HtmlLabelInfo where indexid=130420 
/
INSERT INTO HtmlLabelIndex values(130420,'2、当编制了下级预算时，会依据以下口径，有条件的增减直线上级的预算额度。') 
/
delete from HtmlLabelIndex where id=130421 
/
delete from HtmlLabelInfo where indexid=130421 
/
INSERT INTO HtmlLabelIndex values(130421,'当修改了人员A的预算额度+100时，会先检查部门A当前可用预算额度') 
/
delete from HtmlLabelIndex where id=130422 
/
delete from HtmlLabelInfo where indexid=130422 
/
INSERT INTO HtmlLabelIndex values(130422,'1)如果大于等于100则不会追加部门A的额度，且停止继续追加其余上级额度；') 
/
delete from HtmlLabelIndex where id=130423 
/
delete from HtmlLabelInfo where indexid=130423 
/
INSERT INTO HtmlLabelIndex values(130423,'2)如果小于100则会追加不足的额度（加入部门A的可用额度是30，则会追加70），') 
/
delete from HtmlLabelIndex where id=130424 
/
delete from HtmlLabelInfo where indexid=130424 
/
INSERT INTO HtmlLabelIndex values(130424,'且会按照相同的口径继续追加其余上级额度（继续检查分部A当前可用预算额度是否大于等于70或小于70）；') 
/
delete from HtmlLabelIndex where id=130425 
/
delete from HtmlLabelInfo where indexid=130425 
/
INSERT INTO HtmlLabelIndex values(130425,'如果人员A本次预算变更额度是减少，则上级额度不会发生变化，此时上级可用额度会相应增加。') 
/
delete from HtmlLabelIndex where id=130426 
/
delete from HtmlLabelInfo where indexid=130426 
/
INSERT INTO HtmlLabelIndex values(130426,'预算模块中常用的预算额度统计的口径：') 
/
delete from HtmlLabelIndex where id=130427 
/
delete from HtmlLabelInfo where indexid=130427 
/
INSERT INTO HtmlLabelIndex values(130427,'总预算：分配给总部、分部、部门、个人的预算总额，总部额度中包含直接下级分部的所有预算额度，分部额度中包含直接下级分部与直接下级部门的所有预算额度，部门额度中包含直接下级部门和所属个人的预算额度。') 
/
delete from HtmlLabelIndex where id=130428 
/
delete from HtmlLabelInfo where indexid=130428 
/
INSERT INTO HtmlLabelIndex values(130428,'已分配预算：当前预算单位（总部、分部、部门、个人）直接下级（直接下级分部、部门、所属个人）的预算额度。') 
/
delete from HtmlLabelIndex where id=130429 
/
delete from HtmlLabelInfo where indexid=130429 
/
INSERT INTO HtmlLabelIndex values(130429,'审批中预算：当前预算单位（总部、分部、部门、个人）费用表中记录的预算状态为在途的金额之合。（不包含下级预算单位的额度）') 
/
delete from HtmlLabelIndex where id=130430 
/
delete from HtmlLabelInfo where indexid=130430 
/
INSERT INTO HtmlLabelIndex values(130430,'已发生预算：当前预算单位（总部、分部、部门、个人）费用表中记录的预算状态为生效的金额之合。（不包含下级预算单位的额度）') 
/
delete from HtmlLabelIndex where id=130431 
/
delete from HtmlLabelInfo where indexid=130431 
/
INSERT INTO HtmlLabelIndex values(130431,'可用预算：总预算 减 已分配预算 减 审批中预算 减 已发生预算。（数据库中没有字段保存该值，始终实时计算）') 
/
INSERT INTO HtmlLabelInfo VALUES(130431,'可用预算：总预算 减 已分配预算 减 审批中预算 减 已发生预算。（数据库中没有字段保存该值，始终实时计算）',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130431,'Available budget: the total budget minus the budget has been allocated to reduce the budget approved by the budget. There is no field in the database to save this value, always in real time',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130431,'可用預算：總預算减已分配預算减審批中預算减已發生預算。（資料庫中沒有欄位保存該值，始終實时計算）',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130430,'已发生预算：当前预算单位（总部、分部、部门、个人）费用表中记录的预算状态为生效的金额之合。（不包含下级预算单位的额度）',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130430,'Budget: the sum of the amounts recorded in the budget of the current budget unit (headquarters, divisions, departments, individuals). (does not include the amount of lower budget units)',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130430,'已發生預算：當前預算單位（總部、分部、部門、個人）費用錶中記錄的預算狀態為生效的金額之合。（不包含下級預算單位的額度）',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130429,'审批中预算：当前预算单位（总部、分部、部门、个人）费用表中记录的预算状态为在途的金额之合。（不包含下级预算单位的额度）',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130429,'Approval budget: the current budget unit (headquarters, divisions, departments, individuals) in the form of the state budget recorded in the amount of the sum of the transit. (does not include the amount of lower budget units)',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130429,'審批中預算：當前預算單位（總部、分部、部門、個人）費用錶中記錄的預算狀態為在途的金額之合。（不包含下級預算單位的額度）',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130428,'已分配预算：当前预算单位（总部、分部、部门、个人）直接下级（直接下级分部、部门、所属个人）的预算额度。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130428,'Allocated budget: the current budget unit (headquarters, divisions, departments, individuals) directly subordinate (direct subordinate divisions, departments, individuals) budget.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130428,'已分配預算：當前預算單位（總部、分部、部門、個人）直接下級（直接下級分部、部門、所屬個人）的預算額度。',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130427,'总预算：分配给总部、分部、部门、个人的预算总额，总部额度中包含直接下级分部的所有预算额度，分部额度中包含直接下级分部与直接下级部门的所有预算额度，部门额度中包含直接下级部门和所属个人的预算额度。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130427,'Total budget: total budget allocated to the headquarters, divisions, departments and individuals, all included in the budget quota headquarters directly subordinate branch, branch line contains all the budget line directly subordinate branch with directly subordinate departments, departments included in the amount of direct subordinate departments and subordinate personal budget.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130427,'總預算：分配給總部、分部、部門、個人的預算總額，總部額度中包含直接下級分部的所有預算額度，分部額度中包含直接下級分部與直接下級部門的所有預算額度，部門額度中包含直接下級部門和所屬個人的預算額度。',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130426,'预算模块中常用的预算额度统计的口径：',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130426,'Budget in the budget module commonly used statistical caliber:',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130426,'預算模塊中常用的預算額度統計的口徑：',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130425,'如果人员A本次预算变更额度是减少，则上级额度不会发生变化，此时上级可用额度会相应增加。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130425,'If the staff A this budget is to reduce the amount of change, then the upper limit does not change, this time the amount of the corresponding increase in the upper limit.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130425,'如果人員A本次預算變更額度是减少，則上級額度不會發生變化，此時上級可用額度會相應新增。',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130424,'且会按照相同的口径继续追加其余上级额度（继续检查分部A当前可用预算额度是否大于等于70或小于70）；',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130424,'And will continue to add the remaining amount of the same line in accordance with the same caliber (continue to check whether the current budget A segment is greater than or equal to 70 or less than $70);',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130424,'且會按照相同的口徑繼續追加其餘上級額度（繼續檢查分部A當前可用預算額度是否大於等於70或小於70）；',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130423,'2)如果小于100则会追加不足的额度（加入部门A的可用额度是30，则会追加70），',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130423,'2) if less than 100 will be added to the amount of insufficient (to join the Department of A available amount is 30, it will be an additional 70),',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130423,'2）如果小於100則會追加不足的額度（加入部門A的可用額度是30，則會追加70），',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130422,'1)如果大于等于100则不会追加部门A的额度，且停止继续追加其余上级额度；',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130422,'1) if the ratio is greater than or equal to 100 will not increase the amount of department A, and continue to increase the amount of the remaining additional;',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130422,'1）如果大於等於100則不會追加部門A的額度，且停止繼續追加其餘上級額度；',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130421,'当修改了人员A的预算额度+100时，会先检查部门A当前可用预算额度',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130421,'When you modify the budget amount of personnel +100 A, you will first check the Department of A currently available budget limit',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130421,'當修改了人員A的預算額度+100時，會先檢查部門A當前可用預算額度',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130420,'2、当编制了下级预算时，会依据以下口径，有条件的增减直线上级的预算额度。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130420,'2, when the preparation of the lower budget, will be based on the following caliber, conditional increase or decrease the line of the budget line.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130420,'2、當編制了下級預算時，會依據以下口徑，有條件的增减直線上級的預算額度。',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130419,'当修改了人员A的预算额度-60时，增依次增加：部门A、分部A、总部A预算额度-60；',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130419,'When modifying the budget amount of personnel -60 A, increase by increasing: sector A, segment A, headquarters A budget limit -60;',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130419,'當修改了人員A的預算額度-60時，增依次新增：部門A、分部A、總部A預算額度-60；',9) 
/


delete from HtmlLabelIndex where id=130410 
/
delete from HtmlLabelInfo where indexid=130410 
/
INSERT INTO HtmlLabelIndex values(130410,'1、上级预算额度，一定包含了下级预算额度') 
/
delete from HtmlLabelIndex where id=130411 
/
delete from HtmlLabelInfo where indexid=130411 
/
INSERT INTO HtmlLabelIndex values(130411,'1)总部预算包含了直接下级分部的预算额度；') 
/
delete from HtmlLabelIndex where id=130412 
/
delete from HtmlLabelInfo where indexid=130412 
/
INSERT INTO HtmlLabelIndex values(130412,'2)分部预算包含了该分部的直接下级分部、直接下级部门的预算额度；') 
/
delete from HtmlLabelIndex where id=130413 
/
delete from HtmlLabelInfo where indexid=130413 
/
INSERT INTO HtmlLabelIndex values(130413,'3)部门预算包含了该部门的直接下级部门、所有该部门的人员的预算额度') 
/
delete from HtmlLabelIndex where id=130414 
/
delete from HtmlLabelInfo where indexid=130414 
/
INSERT INTO HtmlLabelIndex values(130414,'2、当编制了下级预算时，上级的预算额度不会自动发生变化。') 
/
delete from HtmlLabelIndex where id=130415 
/
delete from HtmlLabelInfo where indexid=130415 
/
INSERT INTO HtmlLabelIndex values(130415,'1、上下级预算之间没有关系，分部、部门、个人、成本中心：预算只包含自身的额度。') 
/
delete from HtmlLabelIndex where id=130416 
/
delete from HtmlLabelInfo where indexid=130416 
/
INSERT INTO HtmlLabelIndex values(130416,'2、当编制了下级预算时，会依次同步增减所有直线上级的预算额度。') 
/
delete from HtmlLabelIndex where id=130417 
/
delete from HtmlLabelInfo where indexid=130417 
/
INSERT INTO HtmlLabelIndex values(130417,'例如：组织机构：总部A->分部A->部门A->人员A') 
/
delete from HtmlLabelIndex where id=130418 
/
delete from HtmlLabelInfo where indexid=130418 
/
INSERT INTO HtmlLabelIndex values(130418,'当修改了人员A的预算额度+100时，增依次增加：部门A、分部A、总部A预算额度100；') 
/
INSERT INTO HtmlLabelInfo VALUES(130418,'当修改了人员A的预算额度+100时，增依次增加：部门A、分部A、总部A预算额度100；',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130418,'When modifying the budget amount of personnel +100 A, increase by increasing: sector A, segment A, headquarters A budget limit 100;',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130418,'當修改了人員A的預算額度+100時，增依次新增：部門A、分部A、總部A預算額度100；',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130417,'例如：组织机构：总部A->分部A->部门A->人员A',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130417,'For example: Organization: headquarters A-> division A-> Department A-> personnel A',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130417,'例如：組織機構：總部A->分部A->部門A->人員A',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130416,'2、当编制了下级预算时，会依次同步增减所有直线上级的预算额度。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130416,'2, when the preparation of the lower budget, will be synchronized to increase or decrease the budget line of all straight line.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130416,'2、當編制了下級預算時，會依次同步增减所有直線上級的預算額度。',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130415,'1、上下级预算之间没有关系，分部、部门、个人、成本中心：预算只包含自身的额度。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130415,'1, there is no relationship between the upper and lower budgets, segments, departments, individuals, cost centers: budget includes only their own amount.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130415,'1、上下級預算之間沒有關係，分部、部門、個人、成本中心：預算只包含自身的額度。',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130414,'2、当编制了下级预算时，上级的预算额度不会自动发生变化。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130414,'2, when the preparation of the lower budget, the budget does not automatically change the budget.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130414,'2、當編制了下級預算時，上級的預算額度不會自動發生變化。',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130413,'3)部门预算包含了该部门的直接下级部门、所有该部门的人员的预算额度',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130413,'3) the departmental budget includes the budget of the direct subordinate departments of the Department and the personnel of all departments',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130413,'3）部門預算包含了該部門的直接下級部門、所有該部門的人員的預算額度',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130412,'2)分部预算包含了该分部的直接下级分部、直接下级部门的预算额度；',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130412,'2) the departmental budget includes the direct subordinate divisions of the segment, and the budget of the immediate subordinates;',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130412,'2）分部預算包含了該分部的直接下級分部、直接下級部門的預算額度；',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130411,'1)总部预算包含了直接下级分部的预算额度；',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130411,'1) the headquarters budget includes the budget of the immediate lower divisions;',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130411,'1）總部預算包含了直接下級分部的預算額度；',9) 
/
INSERT INTO HtmlLabelInfo VALUES(130410,'1、上级预算额度，一定包含了下级预算额度',7) 
/
INSERT INTO HtmlLabelInfo VALUES(130410,'1, the upper limit of the budget, the budget must include a lower level',8) 
/
INSERT INTO HtmlLabelInfo VALUES(130410,'1、上級預算額度，一定包含了下級預算額度',9) 
/
