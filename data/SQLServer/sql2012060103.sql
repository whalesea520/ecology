create table DocCategoryUseCount(
	secid		int	NOT NULL,
	userid	int	not null,
	count	int	NOT NULL
)
GO
create table WorkflowUseCount(
	wfid		int	NOT NULL,
	userid	int	not null,
	count	int	NOT NULL
)
GO