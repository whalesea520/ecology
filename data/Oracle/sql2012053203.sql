ALTER TABLE hpelement ADD newstemplate VARCHAR2(10)
/
update hpElement set newstemplate =''
/
update hpElement set newstemplate = (select max(newstemplate) from hpFieldLength where eid = hpElement.id and (usertype=3 or (userid=1 and usertype=0))  and newstemplate is not null)
/
