ALTER TABLE hpelement ADD newstemplate VARCHAR(10)
GO
update hpElement set newstemplate =''
GO
update hpElement set newstemplate = (select max(newstemplate)+'' from hpFieldLength where eid = hpElement.id and (usertype=3 or (userid=1 and usertype=0)) and newstemplate!='' and newstemplate is not null)
GO
