update docdetail
set ishistory = 0,docstatus = 1
where (
(
doceditionid < 1 or doceditionid is null) or
(
docedition = (select max(docedition) from docdetail d where d.doceditionid = docdetail.doceditionid and d.doceditionid >0) 
and doceditionid > 0 
and docedition > 0
and exists (select 1 from docseccategory where editionIsOpen <> 1 and id = docdetail.seccategory)
)
)
and ishistory = 1
and docstatus = 7

go