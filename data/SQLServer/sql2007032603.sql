insert into DocSecCategoryMould
(secCategoryId,mouldType,mouldId,isDefault,mouldBind)
(
select id,1,docmouldid,0,1 from DocSecCategory t1
where docmouldid > 0 
and exists (select 1 from docmould where mouldType in (0,1) and id = t1.docmouldid and issysdefault='0')
and not exists (select 1 from DocSecCategoryMould where secCategoryId = t1.id and mouldType=1 and mouldId=t1.docmouldid)
UNION ALL
select id,3,wordmouldid,0,1 from DocSecCategory t1
where wordmouldid > 0 
and exists (select 1 from docmould where mouldType = 2 and id = t1.wordmouldid and issysdefault='0')
and not exists (select 1 from DocSecCategoryMould where secCategoryId = t1.id and mouldType=3 and mouldId=docmouldid)
UNION ALL
select t1.id,2,t2.id,0,1 from DocSecCategory t1,docmouldfile t2
where t2.mouldType in (0,1) 
and t2.id NOT IN (Select TEMPLETDOCID From HrmContractTemplet)
and not exists (select 1 from DocSecCategoryMould where secCategoryId = t1.id and mouldType=2 and mouldId=t2.id)
UNION ALL
select t1.id,4,t2.id,0,1 from DocSecCategory t1,docmouldfile t2
where t2.mouldType =2 
and t2.id NOT IN (Select TEMPLETDOCID From HrmContractTemplet)
and not exists (select 1 from DocSecCategoryMould where secCategoryId = t1.id and mouldType=4 and mouldId=t2.id)
)
GO
