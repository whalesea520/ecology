delete from system_default_col where pageid='MT:MeetingRoom'
/
update meetingroom set hrmids='' where hrmids='0' or hrmids='-1'
/
delete from user_default_col where pageid='MT:MeetingRoom'
/