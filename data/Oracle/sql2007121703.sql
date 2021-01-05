alter table workflow_code add workflowSeqAlone char(1) null
/
update workflow_code set workflowSeqAlone='0'
/
alter table workflow_code add dateSeqAlone char(1) null
/
update workflow_code set dateSeqAlone='0'
/

update workflow_code set dateSeqAlone='1'
where exists 
(
select 1
  from workflow_CodeDetail
  where mainId=workflow_code.formId
    and isBill=workflow_code.isBill
    and (showId=445 or showId=6076)
    and codeValue='1'
)
/


alter table workflow_code add dateSeqSelect char(1) null
/
update workflow_code set dateSeqSelect='1'
/
update workflow_code set dateSeqSelect='2'
where exists 
(
select 1
  from workflow_CodeDetail
  where mainId=workflow_code.formId
    and isBill=workflow_code.isBill
    and showId=6076
    and codeValue='1'
)
/

alter table workflow_CodeDetail add workflowId integer null
/
update workflow_CodeDetail set workflowId=-1
/

alter table workflow_CodeSeq add workflowId integer null
/
update workflow_CodeSeq set workflowId=-1
/

alter table workflow_CodeSeq add monthId integer null
/
update workflow_CodeSeq set monthId=-1
/

alter table workflow_CodeSeq add dateId integer null
/
update workflow_CodeSeq set dateId=-1
/

delete from workflow_codeSet where showName='18811'
/
insert into workflow_codeSet values(4,390,'1')
/
insert into workflow_codeSet values(5,18811,'2')
/
insert into workflow_codeSet values(6,20571,'2')
/
insert into workflow_codeSet values(7,20572,'2')
/
insert into workflow_codeSet values(8,20573,'2')
/
insert into workflow_codeSet values(10,20574,'2')
/
insert into workflow_codeSet values(12,20575,'2')
/
insert into workflow_codeSet values(13,20770,'2')
/
insert into workflow_codeSet values(14,20771,'2')
/
update workflow_Code set flowId=-1
/
