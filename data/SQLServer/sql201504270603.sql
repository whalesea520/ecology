
CREATE TABLE [fnabudgetfeetypeFcc](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[subject] [int] NULL,
	[fccId] [int] NULL,
 CONSTRAINT [PK_fnabudgetfeetypeFcc] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


CREATE NONCLUSTERED INDEX [idx_fnabudgetfeetypeFcc1] ON [fnabudgetfeetypeFcc] 
(
	[subject] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_fnabudgetfeetypeFcc2] ON [fnabudgetfeetypeFcc] 
(
	[fccId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE TABLE [FnaBudgetInfoPageSize](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userId] [int] NULL,
	[pageSize] [int] NULL,
 CONSTRAINT [PK_FnaBudgetInfoPageSize] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [idx_FnaBudgetInfoPageSize1] ON [FnaBudgetInfoPageSize] 
(
	[userId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE FUNCTION checkSubjectById(@pSupId int, @pBottomId int)
    RETURNS INT
AS
BEGIN
	declare @pCnt int;
    WITH allsub(id,supsubject) 
	as ( 
			SELECT id,supsubject  FROM FnaBudgetfeeType where id =  @pSupId
			UNION ALL SELECT a.id,a.supsubject FROM FnaBudgetfeeType a,allsub b where a.supsubject = b.id 
	) select DISTINCT @pCnt = COUNT(distinct id) from allsub where id = @pBottomId
		
    RETURN @pCnt;
END
GO




