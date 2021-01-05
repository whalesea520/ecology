
ALTER PROCEDURE Workflow_ReportDspField_ByRp (
@id_1 	[int], 
@language_2 	[int], 
@flag	[int]	output, 
@msg	[varchar](80)	output) 
AS
declare 
@isbill_3 char(1) 
select @isbill_3 = isbill from workflow_base a , Workflow_Report b where b.id = @id_1 and a.id = b.reportwfid  
/*
, workflow_fieldlable b 
and  b.langurageid = @language_2
and a.fieldid= b.fieldid
and d.formid = b.formid
用子查询代替上述内容，能限制主表和明细id相同时重复出现的情况，但是无法保证显示名唯一
*/
if @isbill_3 = '0' 
select a.id , (select distinct fieldlable from workflow_fieldlable b where b.langurageid = @language_2 and b.fieldid=a.fieldid  and b.formid=d.formid ) as fieldlable , a.dsporder , a.isstat ,a.dborder from Workflow_ReportDspField a , Workflow_Report c , workflow_base d where a.reportid = c.id  and c.reportwfid = d.id  and c.id = @id_1  order by a.dsporder  
else 
select a.id , d.labelname , a.dsporder , a.isstat ,a.dborder from Workflow_ReportDspField a , workflow_billfield b ,Workflow_Report c ,HtmlLabelInfo d where a.reportid = c.id and a.fieldid= b.id and c.id = @id_1 and b.fieldlabel = d.indexid and d.languageid = @language_2  order by a.dsporder
GO
