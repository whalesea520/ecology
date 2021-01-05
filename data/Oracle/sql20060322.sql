delete from HtmlLabelIndex where id=18399
/
delete from HtmlLabelInfo where indexid=18399
/
delete from HtmlLabelInfo where indexid=18399
/
INSERT INTO HtmlLabelIndex values(18399,'提醒设置还没保存，如果离开，将会丢失数据，真的要离开吗？') 
/
INSERT INTO HtmlLabelInfo VALUES(18399,'提醒设置还没保存，如果离开，将会丢失数据，真的要离开吗？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18399,'the datas do not saved ,if you left ，you will lost data，sure？',8) 
/

delete from HtmlLabelIndex where id=18407
/
delete from HtmlLabelInfo where indexid=18407
/
delete from HtmlLabelInfo where indexid=18407
/
INSERT INTO HtmlLabelIndex values(18407,'所做的改动还没保存，如果离开，将会丢失数据，真的要离开吗？') 
/
INSERT INTO HtmlLabelInfo VALUES(18407,'所做的改动还没保存，如果离开，将会丢失数据，真的要离开吗？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18407,'you have not save data，sure to levave？',8) 
/


INSERT INTO HtmlLabelIndex values(17362,'结束日期必须大于或等于起始日期！') 
/
INSERT INTO HtmlLabelInfo VALUES(17362,'结束日期必须大于或等于起始日期！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17362,'',8) 
/
INSERT INTO HtmlLabelIndex values(17363,'起始日期必须小于或等于结束日期！') 
/
INSERT INTO HtmlLabelInfo VALUES(17363,'起始日期必须小于或等于结束日期！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17363,'',8) 
/

insert into SystemRightGroups (rightgroupmark,rightgroupname,rightgroupremark) values ('KPI','目标绩效权限组','目标绩效的管理审批')
/
insert into SystemRightToGroup (groupid,rightid) select max(id),600 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),601 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),602 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),603 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),604 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),605 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),606 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),607 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),608 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),609 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),610 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),619 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),626 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),632 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),633 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),634 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),635 from SystemRightGroups
/
insert into SystemRightToGroup (groupid,rightid) select max(id),636 from SystemRightGroups
/
