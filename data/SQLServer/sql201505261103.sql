ALTER TABLE outter_sys ALTER COLUMN requesttype varchar(5)
GO
update outter_sys set requesttype='POST' where requesttype='2'
GO
update outter_sys set requesttype='GET' where requesttype='1'
GO