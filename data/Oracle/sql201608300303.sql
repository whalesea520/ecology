alter table HistoryMsg ADD fullAmount clob
/
alter table social_IMConversation add isopenfire int
/
update social_IMConversation set isopenfire = 0
/
alter table mobile_rongGroup add isopenfire int
/
update mobile_rongGroup set isopenfire = 0
/