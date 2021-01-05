alter table fnaFeeWfInfoField add fieldValueWfSys INT
go

alter table fnaFeeWfInfoField add tabIndex INT
go

CREATE TABLE [FnaCostStandardErrorMsg](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NULL,
	[requestid] [int] NULL,
	[msg] [varchar](2000) NULL,
 CONSTRAINT [PK_FnaCostStandardErrorMsg] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO