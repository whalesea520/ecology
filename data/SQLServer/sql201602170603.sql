create table FnaBudgetfeeTypeUsed(
  subjectId int, 
  userId int, 
  orderId int 
)
GO

CREATE NONCLUSTERED INDEX [idx_FnaBudgetfeeTypeUsed1] ON [FnaBudgetfeeTypeUsed] 
(
	[subjectId] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_FnaBudgetfeeTypeUsed2] ON [FnaBudgetfeeTypeUsed] 
(
	[userId] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_FnaBudgetfeeTypeUsed3] ON [FnaBudgetfeeTypeUsed] 
(
	[orderId] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


create table FnaBudgetfeeTypeBwTab(
  bwTabId int, 
  userId int 
)
GO

CREATE NONCLUSTERED INDEX [idx_FnaBudgetfeeTypeBwTab1] ON [FnaBudgetfeeTypeBwTab] 
(
	[bwTabId] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_FnaBudgetfeeTypeBwTab2] ON [FnaBudgetfeeTypeBwTab] 
(
	[userId] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO