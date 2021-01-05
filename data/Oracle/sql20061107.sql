delete from CptCapitalShareInfo where relateditemid not in (select id from CptCapital)
/
delete from CptShareDetail where cptid not in (select id from CptCapital)
/