CREATE or REPLACE PROCEDURE Workflow_ReportDspField_ByRp 
(id_1 	integer,
language_2 integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
isbill_3 char(1);
isbill_count integer;
begin
select  count(isbill) INTO   isbill_count  from workflow_base a , Workflow_Report b 
where b.id = id_1 and a.id = b.reportwfid;
if isbill_count>0 then
    select  isbill INTO  isbill_3  from workflow_base a , Workflow_Report b where b.id = id_1 and a.id = b.reportwfid;
end if;

if isbill_3 = '0' then
    open thecursor for
    select a.id , (select distinct fieldlable from workflow_fieldlable b where b.langurageid = language_2 and b.fieldid=a.fieldid  and b.formid=d.formid ) as fieldlable , a.dsporder , a.isstat ,a.dborder from Workflow_ReportDspField a , Workflow_Report c , workflow_base d where a.reportid = c.id  and c.reportwfid = d.id  and c.id = id_1 and  a.fieldid not in (-1,-2) order by a.dsporder;
else 
    open thecursor for
    select a.id , d.labelname , a.dsporder , a.isstat ,a.dborder from Workflow_ReportDspField a , workflow_billfield b ,Workflow_Report c ,HtmlLabelInfo d where a.reportid = c.id and a.fieldid= b.id and c.id = id_1 and b.fieldlabel = d.indexid and d.languageid = language_2  order by a.dsporder;
end if;
end;
/
