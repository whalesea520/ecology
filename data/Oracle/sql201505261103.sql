ALTER TABLE outter_sys MODIFY requesttype varchar2(5)
/
update outter_sys set requesttype='POST' where requesttype='2'
/
update outter_sys set requesttype='GET' where requesttype='1'
/
