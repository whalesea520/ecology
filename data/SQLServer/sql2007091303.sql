delete from hrmrolemembers where resourceid in (select id from hrmresource where status>3 and status<8)
GO