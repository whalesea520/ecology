delete from HtmlLabelIndex where id=127277 
/
delete from HtmlLabelInfo where indexid=127277 
/
INSERT INTO HtmlLabelIndex values(127277,'是否排除非工作日') 
/
INSERT INTO HtmlLabelInfo VALUES(127277,'是否排除非工作日',7) 
/
INSERT INTO HtmlLabelInfo VALUES(127277,'Whether to exclude non working days',8) 
/
INSERT INTO HtmlLabelInfo VALUES(127277,'是否排除非工作日',9) 
/
alter table hrm_att_proc_set add field016 varchar(1)
/