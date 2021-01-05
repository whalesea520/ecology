alter table mode_pagerelatefield add pageexpandid int
go
update mode_pagerelatefield set pageexpandid =  (
select id from (
	select max(b.id) as id,b.hrefid,b.hreftype,b.modeid from mode_pagerelatefield a , mode_pageexpand b 
	where a.hrefid=b.hrefid and a.hreftype=b.hreftype and a.modeid=b.modeid group by b.hrefid,b.hreftype,b.modeid
	)t 
	where  mode_pagerelatefield.hrefid=t.hrefid and mode_pagerelatefield.hreftype=t.hreftype and mode_pagerelatefield.modeid=t.modeid
)
where mode_pagerelatefield.modeid in (select id from modeinfo) 
go