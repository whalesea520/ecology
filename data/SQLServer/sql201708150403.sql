CREATE INDEX index_HistoryMsgfromUserId ON HistoryMsg (fromUserId)
GO
CREATE INDEX index_HistoryMsgtargetId ON HistoryMsg (targetId)
GO
CREATE INDEX index_HistoryMsgGroupId ON HistoryMsg (GroupId)
GO
CREATE INDEX index_HistoryMsgdateTime ON HistoryMsg (dateTime)
GO
CREATE INDEX index_HistoryMsgmsgid ON HistoryMsg (msgid)
GO