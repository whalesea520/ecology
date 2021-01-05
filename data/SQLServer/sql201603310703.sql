alter table HistoryMsg add msgid varchar(100);
GO

create table Social_historyMsgRight(
    id int IDENTITY,
    userId varchar(100),
    msgId varchar(100)
)
GO

CREATE INDEX historyMsgRight_userid_index ON Social_historyMsgRight (userId)
GO

CREATE INDEX historyMsgRight_msgid_index ON Social_historyMsgRight (msgId)
GO