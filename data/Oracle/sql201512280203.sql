alter table HistoryMsg add msgContent_temp clob
/
update HistoryMsg set msgContent_temp = msgContent
/
alter table HistoryMsg drop column msgContent
/
alter table HistoryMsg rename column msgContent_temp to msgContent
/