delete from system_default_col where pageid='MT:meetingroom'
GO
update meetingroom set hrmids='' where hrmids='0' or hrmids='-1'
GO
delete from user_default_col where pageid='MT:meetingroom'
GO