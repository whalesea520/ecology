update mode_batchset set isshortcutbutton=1 where expandid in (select id from mode_pageexpand where isbatch in(1,2) and issystemflag=101)
go