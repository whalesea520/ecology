
CREATE TABLE [BPMGoalGroup] (
	[id] [int] NOT NULL ,
	[goalName] [varchar] (150) NULL ,
	[objId] [int] NULL ,
	[goalType] [char] (1)  NULL ,
	[goalDate] [varchar] (10)  NULL ,
	[cycle] [char] (1)  NULL ,
	[status] [char] (1)  NULL ,
	[requestid] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [BillBPMApproveGoal] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[requestid] [int] NULL ,
	[paraID] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [BillBPMApprovePlan] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[requestid] [int] NULL ,
	[paraID] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [BillBPMGrade] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[requestid] [int] NULL ,
	[paraID] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [GradeGroup] (
	[id] [int] NOT NULL ,
	[gradeName] [varchar] (100)  NULL ,
	[cycle] [char] (1)  NULL ,
	[checkType] [char] (1)  NULL ,
	[checkDate] [varchar] (10)  NULL ,
	[type_c] [char] (1)  NULL ,
	[objId] [int] NULL ,
	[item] [int] NULL ,
	[requestId] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmCheckSchemeContent] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[schemeId] [int] NULL ,
	[type_c] [char] (1)  NULL ,
	[percent_n] [int] NULL ,
	[cycle] [char] (1)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmCheckSchemeDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[contentId] [int] NULL ,
	[item] [int] NULL ,
	[checkFlow] [int] NULL ,
	[percent_n] [int] NULL ,
	[nodePercent_n] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmCheckSchemeTargetV] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[schemeId] [int] NULL ,
	[targetId] [int] NULL ,
	[type_c] [char] (1)  NULL ,
	[typeM] [char] (1)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceAppendRule] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[ruleName] [varchar] (100)  NULL ,
	[memo] [varchar] (200)  NULL ,
	[conditions] [varchar] (200)  NULL ,
	[conditionsum] [varchar] (200)  NULL ,
	[formula] [varchar] (200)  NULL ,
	[formulasum] [varchar] (200)  NULL ,
	[status] [char] (1)  NULL ,
	[deptId] [varchar] (1000)  NULL ,
	[hrmId] [varchar] (1000)  NULL ,
	[postid] [varchar] (1000)  NULL ,
	[formulaDeptId] [varchar] (1000)  NULL ,
	[formulaHrmId] [varchar] (1000)  NULL ,
	[formulaPostId] [varchar] (1000)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceAppendRuleTarget] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[ruleId] [int] NULL ,
	[objId] [int] NULL ,
	[type_t] [char] (1)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceBeforePoint] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[planId] [int] NULL ,
	[point1] [varchar] (200)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceCheckDetail] (
	[id] [int] NOT NULL ,
	[checkId] [int] NULL ,
	[targetName] [varchar] (100)  NULL ,
	[percent_n] [int] NULL ,
	[stdName] [varchar] (2000)  NULL ,
	[crmCode] [varchar] (50)  NULL ,
	[parentId] [int] NULL ,
	[levels] [int] NULL ,
	[depath] [varchar] (2000)  NULL ,
	[targetIndex] [varchar] (50)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceCheckFlow] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[objId] [int] NULL ,
	[objType] [char] (1)  NULL ,
	[goalFlowId] [int] NULL ,
	[planFlowId] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceCheckPoint] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[cycle] [char] (1)  NULL ,
	[checkType] [char] (1)  NULL ,
	[checkDate] [varchar] (10)  NULL ,
	[objId] [int] NULL ,
	[point1] [numeric](10, 3) NULL ,
	[point2] [numeric](10, 3) NULL ,
	[point3] [numeric](10, 3) NULL ,
	[point4] [numeric](10, 3) NULL ,
	[point5] [numeric](10, 3) NULL ,
	[point6] [numeric](10, 3) NULL ,
	[point7] [numeric](10, 1) NULL ,
	[point8] [varchar] (200)  NULL ,
	[content] [text]  NULL ,
	[memo] [text]  NULL ,
	[ruleIds] [varchar] (1000)  NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceCheckPointDetail] (
	[id] [int] NOT NULL ,
	[checkId] [int] NULL ,
	[targetName] [varchar] (100)  NULL ,
	[percent_n] [int] NULL ,
	[stdName] [varchar] (2000)  NULL ,
	[crmCode] [varchar] (50)  NULL ,
	[parentId] [int] NULL ,
	[levels] [int] NULL ,
	[depath] [varchar] (2000)  NULL ,
	[targetIndex] [varchar] (50)  NULL ,
	[point] [numeric](10, 1) NULL ,
	[nodePointId] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceCheckRule] (
	[id] [int] NOT NULL ,
	[ruleName] [varchar] (100)  NULL ,
	[memo] [varchar] (200)  NULL ,
	[status] [char] (1)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceCheckScheme] (
	[id] [int] NOT NULL ,
	[schemeName] [varchar] (100)  NULL ,
	[memo] [varchar] (100)  NULL ,
	[checkBranchId] [varchar] (1000)  NULL ,
	[checkDeptId] [varchar] (1000)  NULL ,
	[checkPostId] [varchar] (1000)  NULL ,
	[checkHrmId] [varchar] (1000)  NULL ,
	[viewSuperiorId] [char] (1)  NULL ,
	[viewSeSuperiorId] [char] (1)  NULL ,
	[viewPostId] [varchar] (1000)  NULL ,
	[viewHrmId] [varchar] (1000)  NULL ,
	[status] [char] (1)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceDiyCheckPoint] (
	[id] [int] NOT NULL ,
	[checkId] [int] NULL ,
	[targetName] [varchar] (100)  NULL ,
	[percent_n] [int] NULL ,
	[stdName] [varchar] (2000)  NULL ,
	[crmCode] [varchar] (50)  NULL ,
	[parentId] [int] NULL ,
	[levels] [int] NULL ,
	[depath] [varchar] (2000)  NULL ,
	[targetIndex] [varchar] (50)  NULL ,
	[point] [numeric](10, 1) NULL ,
	[nodePointId] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceFlow] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[type_1] [char] (1)  NULL ,
	[relatingFlow] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceGoal] (
	[id] [int] NOT NULL ,
	[goalName] [varchar] (100)  NULL ,
	[objId] [int] NULL ,
	[goalCode] [varchar] (25)  NULL ,
	[parentId] [int] NULL ,
	[goalDate] [varchar] (10)  NULL ,
	[workUnit] [int] NULL ,
	[operations] [int] NULL ,
	[type_t] [int] NULL ,
	[startDate] [varchar] (50)  NULL ,
	[endDate] [varchar] (50)  NULL ,
	[goalType] [char] (1)  NULL ,
	[cycle] [char] (1)  NULL ,
	[property] [char] (1)  NULL ,
	[unit] [varchar] (10)  NULL ,
	[targetValue] [decimal](15, 3) NULL ,
	[previewValue] [decimal](15, 3) NULL ,
	[memo] [varchar] (1000)  NULL ,
	[percent_n] [int] NULL ,
	[pointStdId] [int] NULL ,
	[status] [char] (1)  NULL ,
	[allShare] [char] (1)  NULL ,
	[requestId] [int] NULL ,
	[groupId] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceGoalShare] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[objId] [int] NULL ,
	[type_t] [char] (1)  NULL ,
	[type_s] [char] (1)  NULL ,
	[logs] [varchar] (100)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceGoalStd] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[goalId] [int] NULL ,
	[stdName] [varchar] (200)  NULL ,
	[point] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceGrade] (
	[id] [int] NOT NULL ,
	[gradeName] [varchar] (100)  NULL ,
	[source] [char] (1)  NULL ,
	[memo] [varchar] (200)  NULL ,
	[status] [char] (1)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceGradeDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[gradeId] [int] NULL ,
	[grade] [varchar] (10)  NULL ,
	[condition1] [int] NULL ,
	[condition2] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceNodePoint] (
	[id] [int] NOT NULL ,
	[cycle] [char] (1)  NULL ,
	[reportId] [int] NULL ,
	[checkType] [char] (1)  NULL ,
	[checkDate] [varchar] (10)  NULL ,
	[objId] [int] NULL ,
	[requestId] [int] NULL ,
	[nodeId] [int] NULL ,
	[operationId] [int] NULL ,
	[point1] [varchar] (200)  NULL ,
	[point2] [varchar] (200)  NULL ,
	[point3] [varchar] (200)  NULL ,
	[point4] [varchar] (200)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformancePlanDown] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[planId] [int] NULL ,
	[objId] [int] NULL ,
	[status] [char] (1)  NULL ,
	[logs] [varchar] (200)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformancePlanEffort] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[planId] [int] NULL ,
	[effortName] [varchar] (200)  NULL ,
	[viewSort] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformancePlanEffortModul] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[planId] [int] NULL ,
	[effortName] [varchar] (200)  NULL ,
	[viewSort] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformancePlanKey] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[planId] [int] NULL ,
	[keyName] [varchar] (200)  NULL ,
	[viewSort] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformancePlanKeyModul] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[planId] [int] NULL ,
	[keyName] [varchar] (200)  NULL ,
	[viewSort] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformancePlanKind] (
	[id] [int] NOT NULL ,
	[headers] [varchar] (100)  NULL ,
	[planName] [varchar] (50)  NULL ,
	[sort] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformancePlanKindDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[planId] [int] NULL ,
	[headers] [varchar] (100)  NULL ,
	[planName] [varchar] (50)  NULL ,
	[sort] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformancePlanModul] (
	[id] [int] NOT NULL ,
	[groupId] [int] NULL ,
	[type_n] [char] (1)  NULL ,
	[name] [varchar] (200)  NULL ,
	[objId] [int] NULL ,
	[resourceid] [varchar] (200)  NULL ,
	[oppositeGoal] [int] NULL ,
	[begindate] [char] (10)  NULL ,
	[planProperty] [int] NULL ,
	[principal] [varchar] (200)  NULL ,
	[cowork] [varchar] (200)  NULL ,
	[upPrincipal] [varchar] (400)  NULL ,
	[downPrincipal] [varchar] (400)  NULL ,
	[teamRequest] [text]  NULL ,
	[begintime] [char] (8)  NULL ,
	[enddate] [char] (10)  NULL ,
	[endtime] [char] (8)  NULL ,
	[rbeginDate] [char] (10)  NULL ,
	[rendDate] [char] (10)  NULL ,
	[rbeginTime] [char] (8)  NULL ,
	[rendTime] [char] (8)  NULL ,
	[cycle] [char] (1)  NULL ,
	[planType] [char] (1)  NULL ,
	[percent_n] [int] NULL ,
	[color] [char] (6)  NULL ,
	[description] [text]  NULL ,
	[requestIdn] [int] NULL ,
	[requestid] [varchar] (100)  NULL ,
	[projectid] [varchar] (100)  NULL ,
	[crmid] [varchar] (100)  NULL ,
	[docid] [varchar] (100)  NULL ,
	[meetingid] [varchar] (100)  NULL ,
	[status] [char] (1)  NULL ,
	[isremind] [int] NULL ,
	[waketime] [int] NULL ,
	[createrid] [int] NULL ,
	[createdate] [char] (10)  NULL ,
	[createtime] [char] (8)  NULL ,
	[deleted] [char] (1)  NULL ,
	[taskid] [int] NULL ,
	[urgentLevel] [char] (1)  NULL ,
	[agentId] [int] NULL ,
	[deptId] [int] NULL ,
	[subcompanyId] [int] NULL ,
	[createrType] [char] (1)  NULL ,
	[finishRemind] [int] NULL ,
	[relatedprj] [varchar] (500)  NULL ,
	[relatedcus] [varchar] (500)  NULL ,
	[relatedwf] [varchar] (500)  NULL ,
	[relateddoc] [varchar] (500)  NULL ,
	[allShare] [char] (1)  NULL ,
	[planDate] [varchar] (20)  NULL ,
	[timeModul] [char] (1)  NULL ,
	[frequency] [int] NULL ,
	[frequencyy] [int] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [HrmPerformancePointAdjust] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pointId] [int] NULL ,
	[content] [text]  NULL ,
	[adjustDate] [varchar] (10)  NULL ,
	[adjustPerson] [int] NULL ,
	[point_before] [numeric](10, 0) NULL ,
	[point_after] [numeric](10, 3) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [HrmPerformancePointRule] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[minPoint] [int] NULL ,
	[maxPoint] [int] NULL ,
	[pointMethod] [char] (1)  NULL ,
	[pointModul] [char] (1)  NULL ,
	[pointModify] [char] (1)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceReport] (
	[id] [int] NOT NULL ,
	[reportGroupId] [int] NULL ,
	[planId] [int] NULL ,
	[objId] [int] NULL ,
	[cycle] [char] (1)  NULL ,
	[docId] [varchar] (100)  NULL ,
	[allShare] [char] (1)  NULL ,
	[reportDate] [varchar] (10)  NULL ,
	[reportType] [char] (1)  NULL ,
	[status] [char] (1)  NULL ,
	[percent_n] [int] NULL ,
	[pointSelf] [numeric](10, 3) NULL ,
	[reportTypep] [char] (1)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceReportLog] (
	[id] [int] NOT NULL ,
	[reportName] [varchar] (100)  NULL ,
	[reportLog] [text]  NULL ,
	[cycle] [char] (1)  NULL ,
	[reportDate] [varchar] (50)  NULL ,
	[reportType] [char] (1)  NULL ,
	[objId] [int] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceSchemeContent] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[schemeId] [int] NULL ,
	[type_c] [char] (1)  NULL ,
	[percent_n] [int] NULL ,
	[cycle] [char] (1)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceSchemeDetail] (
	[id] [int] NOT NULL ,
	[contentId] [int] NULL ,
	[item] [int] NULL ,
	[checkFlow] [int] NULL ,
	[percent_n] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceSchemePercent] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[itemId] [int] NULL ,
	[nodeId] [int] NULL ,
	[groupId] [int] NULL ,
	[percent_n] [int] NULL ,
	[type_n] [char] (1)  NULL ,
	[type_d] [char] (1)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceTargetDetail] (
	[id] [int] NOT NULL ,
	[targetId] [int] NULL ,
	[targetName] [varchar] (100)  NULL ,
	[targetCode] [varchar] (20)  NULL ,
	[type_l] [char] (1)  NULL ,
	[cycle] [char] (1)  NULL ,
	[Type_t] [char] (1)  NULL ,
	[unit] [varchar] (10)  NULL ,
	[targetValue] [decimal](15, 1) NULL ,
	[previewValue] [decimal](15, 1) NULL ,
	[memo] [varchar] (200)  NULL ,
	[others] [varchar] (100)  NULL ,
	[owner] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceTargetStd] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[targetDetailId] [int] NULL ,
	[stdName] [varchar] (100)  NULL ,
	[point] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [HrmPerformanceTargetType] (
	[id] [int] NOT NULL ,
	[targetName] [varchar] (100)  NULL ,
	[memo] [varchar] (200)  NULL ,
	[num] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [hrmPerformanceAlert] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[type_a] [char] (1)  NULL ,
	[yearCondition1] [int] NULL ,
	[yearCondition2] [int] NULL ,
	[yearConCount] [int] NULL ,
	[yearAlertCount] [int] NULL ,
	[yearAlertUnit] [char] (1)  NULL ,
	[yearFrequency] [int] NULL ,
	[yearInterval] [int] NULL ,
	[monthCondition1] [int] NULL ,
	[monthCondition2] [int] NULL ,
	[monthConCount] [int] NULL ,
	[monthAlertCount] [int] NULL ,
	[monthAlertUnit] [char] (1)  NULL ,
	[monthFrequency] [int] NULL ,
	[monthInterval] [int] NULL ,
	[quarterCondition1] [int] NULL ,
	[quarterCondition2] [int] NULL ,
	[quarterConCount] [int] NULL ,
	[quarterAlertCount] [int] NULL ,
	[quarterAlertUnit] [char] (1)  NULL ,
	[quarterFrequency] [int] NULL ,
	[quarterInterval] [int] NULL ,
	[weekCondition1] [int] NULL ,
	[weekCondition2] [int] NULL ,
	[weekConCount] [int] NULL ,
	[weekAlertCount] [int] NULL ,
	[weekAlertUnit] [char] (1)  NULL ,
	[weekFrequency] [int] NULL ,
	[weekInterval] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [hrmPerformanceCheckStd] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[checkDetailId] [int] NULL ,
	[stdName] [varchar] (100)  NULL ,
	[point] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [workPlanGroup] (
	[id] [int] NOT NULL ,
	[planName] [varchar] (100)  NULL ,
	[cycle] [char] (1)  NULL ,
	[planDate] [varchar] (50)  NULL ,
	[objId] [int] NULL ,
	[status] [char] (1)  NULL ,
	[type_d] [char] (1)  NULL ,
	[requestId] [int] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [GradeGroup] WITH NOCHECK ADD 
	CONSTRAINT [PK_GradeGroup] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceAppendRule] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceAppendRule] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceAppendRuleTarget] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceAppendRuleTarget] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceBeforePoint] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceBeforePoint] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceCheckDetail] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceCheckDetail] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceCheckPoint] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceCheckPoint] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceCheckPointDetail] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceCheckPointDetail] PRIMARY KEY  CLUSTERED 
	(
		[id],
		[nodePointId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceCheckRule] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceCheckRule] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceCheckScheme] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceCheckScheme] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceDiyCheckPoint] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceDiyCheckPoint] PRIMARY KEY  CLUSTERED 
	(
		[id],
		[nodePointId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceFlow] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceFlow] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceGrade] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceGrade] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceGradeDetail] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceGradeDetail] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceNodePoint] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceNodePoint] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformancePlanDown] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformancePlanDown] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformancePlanEffort] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformancePlanEffort] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformancePlanKey] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformancePlanKey] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformancePlanKind] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformancePlanKind] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformancePlanKindDetail] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformancePlanKindDetail] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformancePlanModul] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformancePlanModul] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformancePointAdjust] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformancePointAdjust] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformancePointRule] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformancePointRule] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceReport] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceReport] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceReportLog] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceReportLog] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceSchemeContent] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceSchemeContent] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceSchemeDetail] WITH NOCHECK ADD 
	CONSTRAINT [PK_HrmPerformanceSchemeDetail] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceTargetDetail] WITH NOCHECK ADD 
	CONSTRAINT [PK_hrmPerformanceTargetDetail] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceTargetType] WITH NOCHECK ADD 
	CONSTRAINT [PK_hrmPerformanceTargetType] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [hrmPerformanceCheckStd] WITH NOCHECK ADD 
	CONSTRAINT [PK_hrmPerformanceCheckStd] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [workPlanGroup] WITH NOCHECK ADD 
	CONSTRAINT [PK_workPlanGroup] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [HrmPerformanceCheckDetail] WITH NOCHECK ADD 
	CONSTRAINT [DF_HrmPerformanceCheckDetail_targetIndex] DEFAULT ((-1)) FOR [targetIndex]
GO

ALTER TABLE [HrmPerformanceTargetType] WITH NOCHECK ADD 
	CONSTRAINT [DF_hrmPerformanceTargetType_num] DEFAULT (0) FOR [num]
GO


ALTER TABLE workPlan add 
groupId int NULL ,
objId	int	null,	

oppositeGoal	int	Null	,
planProperty	int	null	,
principal	varchar(200)	null	,
cowork	varchar(200)		null,
upPrincipal	varchar(200) null		,
downPrincipal	varchar(200) null		,
teamRequest	varchar(200) null,
rbeginDate	char(10)	null,
rendDate	char(10)	null,
rbeginTime	char(8)		null,
rendTime	char(8)		null,
cycle char (1)  NULL ,
planType char (1) NULL ,
percent_n int NULL ,
requestIdn int NULL ,
allShare char (1)  NULL ,
planDate varchar (20)  NULL

GO


CREATE TABLE [HrmPerformancePlanCheck] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[planModulId] [int] NULL ,
	[cycle] [char] (1)  NULL ,
	[planDate] [varchar] (10)  NULL ,
	[planDay] [varchar] (10)  NULL 
) ON [PRIMARY]
GO





INSERT INTO HtmlLabelIndex values(18057,'考核对象') 
GO
INSERT INTO HtmlLabelInfo VALUES(18057,'考核对象',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18057,'CHECK TARGET',8) 
GO

INSERT INTO HtmlLabelIndex values(18078,'计划性质') 
GO
INSERT INTO HtmlLabelInfo VALUES(18078,'计划性质',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18078,'ATTRIBUTE OF PLAN',8) 
GO

INSERT INTO HtmlLabelIndex values(18094,'考核表') 
GO
INSERT INTO HtmlLabelInfo VALUES(18094,'考核表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18094,'CHECK RESULT',8) 
GO

INSERT INTO HtmlLabelIndex values(18086,'指标') 
GO
INSERT INTO HtmlLabelInfo VALUES(18086,'指标',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18086,'TARGET',8) 
GO
INSERT INTO HtmlLabelIndex values(18093,'分值') 
GO
INSERT INTO HtmlLabelInfo VALUES(18093,'分值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18093,'VALUE OF OINT',8) 
GO
INSERT INTO HtmlLabelIndex values(18064,'考核项') 
GO
INSERT INTO HtmlLabelInfo VALUES(18064,'考核项',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18064,'CHECK ITEM',8) 
GO
INSERT INTO HtmlLabelIndex values(18067,'考核流程') 
GO
INSERT INTO HtmlLabelInfo VALUES(18067,'考核流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18067,'FLOW OF CHECK',8) 
GO

INSERT INTO HtmlLabelIndex values(18062,'述职总结') 
GO
INSERT INTO HtmlLabelInfo VALUES(18062,'述职总结',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18062,'REPORT WORK',8) 
GO

INSERT INTO HtmlLabelIndex values(18065,'考核权重') 
GO
INSERT INTO HtmlLabelInfo VALUES(18065,'考核权重',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18065,'PERCENT OF CHECK',8) 
GO
INSERT INTO HtmlLabelIndex values(18063,'权重') 
GO
INSERT INTO HtmlLabelInfo VALUES(18063,'权重',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18063,'PERCENT',8) 
GO
INSERT INTO HtmlLabelIndex values(18060,'目标考核') 
GO
INSERT INTO HtmlLabelInfo VALUES(18060,'目标考核',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18060,'TARGET CHECK',8) 
GO
INSERT INTO HtmlLabelIndex values(18056,'考核方案') 
GO
INSERT INTO HtmlLabelInfo VALUES(18056,'考核方案',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18056,'CHECK SCHEME',8) 
GO

INSERT INTO HtmlLabelIndex values(18053,'绩效考核得分') 
GO
INSERT INTO HtmlLabelIndex values(18054,'目标计划考核得分') 
GO
INSERT INTO HtmlLabelInfo VALUES(18053,'绩效考核得分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18053,'PKI CHECK POINT',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18054,'目标计划考核得分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18054,'PLAN CHECK POINT',8) 
GO
INSERT INTO HtmlLabelIndex values(18076,'数据源') 
GO
INSERT INTO HtmlLabelInfo VALUES(18076,'数据源',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18076,'DATA SOURCE',8) 
GO
INSERT INTO HtmlLabelIndex values(18076,'数据源') 
GO
INSERT INTO HtmlLabelInfo VALUES(18076,'数据源',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18076,'DATA SOURCE',8) 
GO
INSERT INTO HtmlLabelIndex values(18070,'得分修正') 
GO
INSERT INTO HtmlLabelInfo VALUES(18070,'得分修正',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18070,'MODIFY POINT',8) 
GO
INSERT INTO HtmlLabelIndex values(18073,'允许调整') 
GO
INSERT INTO HtmlLabelInfo VALUES(18073,'允许调整',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18073,'ALLOW ADJUST',8) 
GO


INSERT INTO HtmlLabelIndex values(18085,'指标类型') 
GO
INSERT INTO HtmlLabelInfo VALUES(18085,'指标类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18085,'TYPE OF TARGET',8) 
GO
INSERT INTO HtmlLabelIndex values(18071,'依据评分标准') 
GO
INSERT INTO HtmlLabelIndex values(18072,'手工评分') 
GO
INSERT INTO HtmlLabelIndex values(18068,'评分范围') 
GO
INSERT INTO HtmlLabelIndex values(18069,'评分方式') 
GO
INSERT INTO HtmlLabelInfo VALUES(18068,'评分范围',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18068,'RANGE OF POINT',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18069,'评分方式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18069,'METHOD OF GRADE',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18071,'依据评分标准',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18071,'BY GRADE STD',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18072,'手工评分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18072,'HANDWORK',8) 
GO
 

INSERT INTO HtmlLabelIndex values(18061,'自定义考核') 
GO
INSERT INTO HtmlLabelIndex values(18075,'定义') 
GO
INSERT INTO HtmlLabelIndex values(18090,'定性') 
GO
INSERT INTO HtmlLabelIndex values(18092,'标准定义') 
GO
INSERT INTO HtmlLabelIndex values(18055,'自定义考核得分') 
GO
INSERT INTO HtmlLabelIndex values(18074,'总分评定模式') 
GO
INSERT INTO HtmlLabelIndex values(18089,'定量') 
GO
INSERT INTO HtmlLabelInfo VALUES(18055,'自定义考核得分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18055,'CUSTOM CHECK POINT',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18061,'自定义考核',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18061,'CUSTOM CHECK',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18074,'总分评定模式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18074,'ALL ASSESS MODEL',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18075,'定义',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18075,'DEFINE',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18089,'定量',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18089,'RATION',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18090,'定性',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18090,'DETERMINE THE NATURE',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18092,'标准定义',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18092,'DEFINE OF STD',8) 
GO

INSERT INTO HtmlLabelIndex values(18058,'考核结果查看') 
GO
INSERT INTO HtmlLabelInfo VALUES(18058,'考核结果查看',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18058,'CHECK POINT VIEW',8) 
GO

INSERT INTO HtmlLabelIndex values(18280,'季') 
GO
INSERT INTO HtmlLabelInfo VALUES(18280,'季',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18280,'quarter',8) 
GO

INSERT INTO HtmlLabelIndex values(18041,'目标管理') 
GO
INSERT INTO HtmlLabelInfo VALUES(18041,'目标管理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18041,'PKI',8) 
GO

INSERT INTO HtmlLabelIndex values(18042,'考核等级划分') 
GO
INSERT INTO HtmlLabelInfo VALUES(18042,'考核等级划分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18042,'GRADESETTING',8) 
GO

INSERT INTO HtmlLabelIndex values(18043,'审批流程关联') 
GO
INSERT INTO HtmlLabelInfo VALUES(18043,'审批流程关联',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18043,'CHECKFLOWCONNECTION',8) 
GO

INSERT INTO HtmlLabelIndex values(18044,'计划性质设定') 
GO
INSERT INTO HtmlLabelInfo VALUES(18044,'计划性质设定',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18044,'PLANATTRIBUTE',8) 
GO

INSERT INTO HtmlLabelIndex values(18046,'提醒时间设定') 
GO
INSERT INTO HtmlLabelInfo VALUES(18046,'提醒时间设定',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18046,'ALERTTIME',8) 
GO
INSERT INTO HtmlLabelIndex values(18080,'提醒频率') 
GO
INSERT INTO HtmlLabelIndex values(18081,'提醒一次') 
GO
INSERT INTO HtmlLabelIndex values(18046,'提醒时间设定') 
GO
INSERT INTO HtmlLabelIndex values(18079,'提醒提前量') 
GO
INSERT INTO HtmlLabelInfo VALUES(18046,'提醒时间设定',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18046,'ALERTTIME',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18079,'提醒提前量',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18079,'NUMBER OF ALERT',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18080,'提醒频率',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18080,'FREQUENCY OF ALERT',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18081,'提醒一次',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18081,'ALERT ONCE',8) 
GO

INSERT INTO HtmlLabelIndex values(18047,'指标库') 
GO
INSERT INTO HtmlLabelInfo VALUES(18047,'指标库',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18047,'TARGET STORAGE',8) 
GO

INSERT INTO HtmlLabelIndex values(18048,'自定义考核表') 
GO
INSERT INTO HtmlLabelInfo VALUES(18048,'自定义考核表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18048,'CUSTOM CHECK LIST',8) 
GO

INSERT INTO HtmlLabelIndex values(18049,'考核方案设定') 
GO
INSERT INTO HtmlLabelInfo VALUES(18049,'考核方案设定',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18049,'CHECK SCHEME',8) 
GO

INSERT INTO HtmlLabelIndex values(18050,'评分规则') 
GO
INSERT INTO HtmlLabelInfo VALUES(18050,'评分规则',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18050,'POINT RULE',8) 
GO

INSERT INTO HtmlLabelIndex values(18097,'考核等级') 
GO
INSERT INTO HtmlLabelInfo VALUES(18097,'考核等级',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18097,'GRADE',8) 
GO
INSERT INTO HtmlLabelIndex values(18096,'禁用') 
GO
INSERT INTO HtmlLabelIndex values(18095,'启用') 
GO
INSERT INTO HtmlLabelInfo VALUES(18095,'启用',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18095,'OPEN',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18096,'禁用',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18096,'CLOSE',8) 
GO

INSERT INTO HtmlLabelIndex values(18098,'条件设置不合逻辑') 
GO
INSERT INTO HtmlLabelInfo VALUES(18098,'条件设置不合逻辑',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18098,'CONDITION ERROR',8) 
GO


INSERT INTO HtmlLabelIndex values(18102,'目标审批流程') 
GO
INSERT INTO HtmlLabelIndex values(18103,'计划审批流程') 
GO
INSERT INTO HtmlLabelInfo VALUES(18102,'目标审批流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18102,'TARGET CHECK FLOW',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18103,'计划审批流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18103,'PLAN CHECK FLOW',8) 
GO

INSERT INTO HtmlLabelIndex values(18104,'流程名称') 
GO
INSERT INTO HtmlLabelInfo VALUES(18104,'流程名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18104,'FLOW NAME',8) 
GO


INSERT INTO HtmlLabelIndex values(18105,'已有该类型的审批流程，不能添加') 
GO
INSERT INTO HtmlLabelInfo VALUES(18105,'已有该类型的审批流程，不能添加',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18105,'HAVE THE KIND OF FLOW',8) 
GO



INSERT INTO HtmlLabelIndex values(18106,'目标设定') 
GO
INSERT INTO HtmlLabelInfo VALUES(18106,'目标设定',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18106,'SET TARGET',8) 
GO

INSERT INTO HtmlLabelIndex values(18108,'报告提交') 
GO
INSERT INTO HtmlLabelIndex values(18107,'计划提交') 
GO
INSERT INTO HtmlLabelInfo VALUES(18107,'计划提交',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18107,'SUBMIT PLAN',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18108,'报告提交',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18108,'SUBMIT REPORT',8) 
GO

INSERT INTO HtmlLabelIndex values(18109,'前') 
GO
INSERT INTO HtmlLabelIndex values(18110,'后') 
GO
INSERT INTO HtmlLabelInfo VALUES(18109,'前',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18109,'AHEAD',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18110,'后',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18110,'BACK',8) 
GO


INSERT INTO HtmlLabelIndex values(18111,'截止时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(18111,'截止时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18111,'DEADLINE',8) 
GO

INSERT INTO HtmlLabelIndex values(18112,'计划性质分类') 
GO
INSERT INTO HtmlLabelInfo VALUES(18112,'计划性质分类',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18112,'THE KIND OF PLAN',8) 
GO

INSERT INTO HtmlLabelIndex values(18113,'计划性质列表') 
GO
INSERT INTO HtmlLabelInfo VALUES(18113,'计划性质列表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18113,'THE KIND OF PLAN LIST',8) 
GO

INSERT INTO HtmlLabelIndex values(18114,'指标数目') 
GO
INSERT INTO HtmlLabelInfo VALUES(18114,'指标数目',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18114,'TARGET NUMBERS',8) 
GO

INSERT INTO HtmlLabelIndex values(18115,'点击浏览详细指标') 
GO
INSERT INTO HtmlLabelInfo VALUES(18115,'点击浏览详细指标',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18115,'VIEW TARGET',8) 
GO

INSERT INTO HtmlLabelIndex values(18117,'美圆') 
GO
INSERT INTO HtmlLabelInfo VALUES(18117,'美圆',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18117,'DOLLAR',8) 
GO

INSERT INTO HtmlLabelIndex values(18119,'保存到指标库') 
GO
INSERT INTO HtmlLabelInfo VALUES(18119,'保存到指标库',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18119,'SAVE TO TARGET',8) 
GO

INSERT INTO HtmlLabelIndex values(18120,'返回到考核表') 
GO
INSERT INTO HtmlLabelInfo VALUES(18120,'返回到考核表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18120,'RETURN TO CUSTOM',8) 
GO
INSERT INTO HtmlLabelIndex values(18122,'自定义考核表指标') 
GO
INSERT INTO HtmlLabelInfo VALUES(18122,'自定义考核表指标',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18122,'TARGET OG CUSTOM CEHCK',8) 
GO

INSERT INTO HtmlLabelIndex values(18123,'同一层节点的总权重指数不能大于100') 
GO
INSERT INTO HtmlLabelInfo VALUES(18123,'同一层节点的总权重指数不能大于100',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18123,'The same level of sum power index can''''''''t be greater than 100%',8) 
GO


INSERT INTO HtmlLabelIndex values(18125,'公式') 
GO
INSERT INTO HtmlLabelInfo VALUES(18125,'公式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18125,'FORMULA',8) 
GO

INSERT INTO HtmlLabelIndex values(18126,'适用对象') 
GO
INSERT INTO HtmlLabelInfo VALUES(18126,'适用对象',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18126,'APPLY TO',8) 
GO


INSERT INTO HtmlLabelIndex values(18127,'条件对象') 
GO
INSERT INTO HtmlLabelInfo VALUES(18127,'条件对象',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18127,'THE TARGET OF CONDITION',8) 
GO

INSERT INTO HtmlLabelIndex values(18128,'个人考核得分') 
GO
INSERT INTO HtmlLabelIndex values(18129,'上级考核得分') 
GO
INSERT INTO HtmlLabelIndex values(18130,'所在部门考核得分') 
GO
INSERT INTO HtmlLabelInfo VALUES(18128,'个人考核得分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18128,'THE POINT OF PERSONAL',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18129,'上级考核得分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18129,'THE POINT OF SUPERIOR',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18130,'所在部门考核得分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18130,'THE POINT OF OWNER DEPARTMENT',8) 
GO

INSERT INTO HtmlLabelIndex values(18131,'请选择条件') 
GO
INSERT INTO HtmlLabelInfo VALUES(18131,'请选择条件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18131,'PELASE CHOOSE A CONDITION',8) 
GO


INSERT INTO HtmlLabelIndex values(18132,'隔级') 
GO
INSERT INTO HtmlLabelInfo VALUES(18132,'隔级',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18132,'SPACE SUPERIOR',8) 
GO

INSERT INTO HtmlLabelIndex values(18133,'查看对象') 
GO
INSERT INTO HtmlLabelInfo VALUES(18133,'查看对象',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18133,'THE OBJECT OF VIEW',8) 
GO

INSERT INTO HtmlLabelIndex values(18134,'评分权重') 
GO
INSERT INTO HtmlLabelIndex values(18135,'评分权重(含下游)') 
GO
INSERT INTO HtmlLabelInfo VALUES(18134,'评分权重',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18134,'POWER INDEX OF POINT',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18135,'评分权重(含下游)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18135,'POWER INDEX OF POINT (DOWN)',8) 
GO

INSERT INTO HtmlLabelIndex values(18136,'月工作计划') 
GO
INSERT INTO HtmlLabelIndex values(18137,'月考核汇总') 
GO
INSERT INTO HtmlLabelInfo VALUES(18136,'月工作计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18136,'the working plan the month',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18137,'月考核汇总',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18137,'SUM OF CHECK',8) 
GO

INSERT INTO HtmlLabelIndex values(18138,'请填写权重') 
GO
INSERT INTO HtmlLabelInfo VALUES(18138,'请填写权重',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18138,'PLEASE INPUT POWER INDEX',8) 
GO

INSERT INTO HtmlLabelIndex values(18139,'所选考核项的权重和应该是100') 
GO
INSERT INTO HtmlLabelInfo VALUES(18139,'所选考核项的权重和应该是100',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18139,'SUM OF THE SELECTED POWER INDEX MUST 100',8) 
GO

INSERT INTO HtmlLabelIndex values(18147,'请选择一个考核项') 
GO
INSERT INTO HtmlLabelInfo VALUES(18147,'请选择一个考核项',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18147,'PLEASE CHOOSE A ITEM',8) 
GO

INSERT INTO HtmlLabelIndex values(18170,'工作计划') 
GO
INSERT INTO HtmlLabelInfo VALUES(18170,'工作计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18170,'WORK PLAN',8) 
GO

INSERT INTO HtmlLabelIndex values(18174,'同一节点的操作者权重和必须是100') 
GO
INSERT INTO HtmlLabelInfo VALUES(18174,'同一节点的操作者权重和必须是100',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18174,'THE SUM OF THE POWER INDE OF of THE SAME POINT must 100',8) 
GO

INSERT INTO HtmlLabelIndex values(18175,'所有节点的权重和必须是100') 
GO
INSERT INTO HtmlLabelInfo VALUES(18175,'所有节点的权重和必须是100',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18175,'THE SUM OF POWER INDEX OF ALL POINT MUST 100',8) 
GO

INSERT INTO HtmlLabelIndex values(18087,'目标值') 
GO
INSERT INTO HtmlLabelInfo VALUES(18087,'目标值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18087,'VALUE OF TARGET',8) 
GO
INSERT INTO HtmlLabelIndex values(18088,'预警值') 
GO
INSERT INTO HtmlLabelInfo VALUES(18088,'预警值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18088,'VALUE OF ALERT',8) 
GO
INSERT INTO HtmlLabelIndex values(18075,'定义') 
GO
INSERT INTO HtmlLabelInfo VALUES(18075,'定义',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18075,'DEFINE',8) 
GO
INSERT INTO HtmlLabelIndex values(18091,'评分标准') 
GO
INSERT INTO HtmlLabelInfo VALUES(18091,'评分标准',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18091,'STD OF POINT',8) 
GO

INSERT INTO HtmlLabelIndex values(18176,'下游权重') 
GO
INSERT INTO HtmlLabelInfo VALUES(18176,'下游权重',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18176,'THE POWER OF NETX POINT',8) 
GO
 INSERT INTO HtmlLabelIndex values(18179,'权重指数必须为100') 
GO
INSERT INTO HtmlLabelInfo VALUES(18179,'权重指数必须为100',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18179,'THE POWER INDEX MUST 100%',8) 
GO







INSERT INTO HtmlLabelIndex values(18181,'目标计划') 
GO
INSERT INTO HtmlLabelInfo VALUES(18181,'目标计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18181,'TARGET PLAN',8) 
GO

INSERT INTO HtmlLabelIndex values(18182,'预计') 
GO
INSERT INTO HtmlLabelInfo VALUES(18182,'预计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18182,'estimate',8) 
GO

INSERT INTO HtmlLabelIndex values(18184,'下游部门') 
GO
INSERT INTO HtmlLabelIndex values(18183,'上游部门') 
GO
INSERT INTO HtmlLabelInfo VALUES(18183,'上游部门',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18183,'UP DEPARMENT',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18184,'下游部门',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18184,'DOWN DEPARTMENT',8) 
GO

INSERT INTO HtmlLabelIndex values(18185,'下游') 
GO
INSERT INTO HtmlLabelInfo VALUES(18185,'下游',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18185,'DOWN',8) 
GO
INSERT INTO HtmlLabelIndex values(18186,'同意') 
GO
INSERT INTO HtmlLabelInfo VALUES(18186,'同意',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18186,'agree',8) 
GO

INSERT INTO HtmlLabelIndex values(18187,'相关计划') 
GO
INSERT INTO HtmlLabelInfo VALUES(18187,'相关计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18187,'RELATIONS PLAN',8) 
GO

INSERT INTO HtmlLabelIndex values(18188,'配合') 
GO
INSERT INTO HtmlLabelInfo VALUES(18188,'配合',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18188,'assort',8) 
GO

INSERT INTO HtmlLabelIndex values(18189,'已确认') 
GO
INSERT INTO HtmlLabelInfo VALUES(18189,'已确认',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18189,'confirmed',8) 
GO

INSERT INTO HtmlLabelIndex values(18190,'') 
GO
INSERT INTO HtmlLabelInfo VALUES(18190,'协作计划（说明：包括下游部门的协作请求和自己做为配合责任人的计划）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18190,'协作计划（说明：包括下游部门的协作请求和自己做为配合责任人的计划）',8) 
GO

INSERT INTO HtmlLabelIndex values(18191,'对应目标') 
GO
INSERT INTO HtmlLabelIndex values(18192,'对上游部门/责任人的协作请求') 
GO
INSERT INTO HtmlLabelInfo VALUES(18191,'对应目标',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18191,'the corresponding target',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18192,'对上游部门/责任人的协作请求',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18192,'',8) 
GO

INSERT INTO HtmlLabelIndex values(18193,'请选择对应部门的责任人') 
GO
INSERT INTO HtmlLabelInfo VALUES(18193,'请选择对应部门的责任人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18193,'PLEASE SELECT PRINCIPAL OF THE DEPARTMENT',8) 
GO

INSERT INTO HtmlLabelIndex values(18196,'当前周期') 
GO
INSERT INTO HtmlLabelInfo VALUES(18196,'当前周期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18196,'CURREN CYCLE',8) 
GO

INSERT INTO HtmlLabelIndex values(18200,'工作关键点') 
GO
INSERT INTO HtmlLabelInfo VALUES(18200,'工作关键点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18200,'the key of the point of work',8) 
GO

INSERT INTO HtmlLabelIndex values(18201,'要求') 
GO
INSERT INTO HtmlLabelInfo VALUES(18201,'要求',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18201,'Request',8) 
GO

INSERT INTO HtmlLabelIndex values(18202,'成果要求') 
GO
INSERT INTO HtmlLabelInfo VALUES(18202,'成果要求',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18202,'achevement request',8) 
GO

INSERT INTO HtmlLabelIndex values(18212,'计划的权重和必须为100') 
GO
INSERT INTO HtmlLabelInfo VALUES(18212,'计划的权重和必须为100',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18212,'计划的权重和必须为100',8) 
GO

INSERT INTO HtmlLabelIndex values(18213,'导入本部门员工计划') 
GO
INSERT INTO HtmlLabelInfo VALUES(18213,'导入本部门员工计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18213,'input plan of the employee',8) 
GO
INSERT INTO HtmlLabelIndex values(18214,'请选择') 
GO
INSERT INTO HtmlLabelInfo VALUES(18214,'请选择',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18214,'PlEASE CHOOSE',8) 
GO
 
INSERT INTO HtmlLabelIndex values(18217,'导入本分部部门计划') 
GO
INSERT INTO HtmlLabelInfo VALUES(18217,'导入本分部部门计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18217,'import depatement plan',8) 
GO

INSERT INTO HtmlLabelIndex values(18219,'添加到分部计划') 
GO
INSERT INTO HtmlLabelIndex values(18218,'添加到部门计划') 
GO
INSERT INTO HtmlLabelInfo VALUES(18218,'添加到部门计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18218,'Apply to department plan',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18219,'添加到分部计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18219,'apply to branch plan',8) 
GO
INSERT INTO HtmlLabelIndex values(18220,'计划工作模板') 
GO
INSERT INTO HtmlLabelInfo VALUES(18220,'计划工作模板',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18220,'PLAN MODULE',8) 
GO

INSERT INTO HtmlLabelIndex values(18221,'定期模式') 
GO
INSERT INTO HtmlLabelInfo VALUES(18221,'定期模式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18221,'Wake mode',8) 
GO

INSERT INTO HtmlLabelIndex values(18222,'按') 
GO
INSERT INTO HtmlLabelInfo VALUES(18222,'按',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18222,'bases',8) 
GO
INSERT INTO HtmlLabelIndex values(18223,'不定期建立计划') 
GO
INSERT INTO HtmlLabelInfo VALUES(18223,'不定期建立计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18223,'Don''t set plan of frequency',8) 
GO
INSERT INTO HtmlLabelIndex values(18059,'年中') 
GO
INSERT INTO HtmlLabelInfo VALUES(18059,'年中',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18059,'MIDYEAR',8) 
GO
INSERT INTO HtmlLabelIndex values(18225,'调整权重') 
GO
INSERT INTO HtmlLabelInfo VALUES(18225,'调整权重',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18225,'adjust percent',8) 
GO

INSERT INTO HtmlLabelIndex values(18215,'分解') 
GO
INSERT INTO HtmlLabelInfo VALUES(18215,'分解',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18215,'break',8) 
GO

INSERT INTO HtmlLabelIndex values(18224,'分解情况') 
GO
INSERT INTO HtmlLabelInfo VALUES(18224,'分解情况',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18224,'Break Situation',8) 
GO

INSERT INTO HtmlLabelIndex values(18231,'导入指标') 
GO
INSERT INTO HtmlLabelInfo VALUES(18231,'导入指标',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18231,'Import KPI',8) 
GO

INSERT INTO HtmlLabelIndex values(18237,'保存至指标库') 
GO
INSERT INTO HtmlLabelInfo VALUES(18237,'保存至指标库',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18237,'Save to KPI room',8) 
GO

INSERT INTO HtmlLabelIndex values(18238,'目标名称') 
GO
INSERT INTO HtmlLabelInfo VALUES(18238,'目标名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18238,'KPI Name',8) 
GO

INSERT INTO HtmlLabelIndex values(18239,'负责单位') 
GO
INSERT INTO HtmlLabelInfo VALUES(18239,'负责单位',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18239,'Responsible Unit',8) 
GO

INSERT INTO HtmlLabelIndex values(18240,'同步') 
GO
INSERT INTO HtmlLabelInfo VALUES(18240,'同步',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18240,'synchronize',8) 
GO


INSERT INTO HtmlLabelIndex values(18248,'系统分值') 
GO
INSERT INTO HtmlLabelIndex values(18249,'当前分值') 
GO
INSERT INTO HtmlLabelIndex values(18250,'调整分值') 
GO
INSERT INTO HtmlLabelInfo VALUES(18248,'系统分值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18248,'System Point',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18249,'当前分值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18249,'Current Point',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18250,'调整分值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18250,'Modified Point',8) 
GO

INSERT INTO HtmlLabelIndex values(18251,'调整记录') 
GO
INSERT INTO HtmlLabelInfo VALUES(18251,'调整记录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18251,'Modified Log',8) 
GO

INSERT INTO HtmlLabelIndex values(18252,'调整前分值') 
GO
INSERT INTO HtmlLabelIndex values(18253,'调整后分值') 
GO
INSERT INTO HtmlLabelIndex values(18254,'调整时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(18252,'调整前分值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18252,'Point Before Modifing',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18253,'调整后分值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18253,'Point After Modifing',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18254,'调整时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18254,'Modified Time',8) 
GO

INSERT INTO HtmlLabelIndex values(18257,'分配人') 
GO
INSERT INTO HtmlLabelInfo VALUES(18257,'分配人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18257,'Deliverer',8) 
GO

INSERT INTO HtmlLabelIndex values(18258,'请先建立目标') 
GO
INSERT INTO HtmlLabelInfo VALUES(18258,'请先建立目标',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18258,'First you should add goal',8) 
GO

INSERT INTO HtmlLabelIndex values(18259,'确认提交审批吗') 
GO
INSERT INTO HtmlLabelInfo VALUES(18259,'确认提交审批吗',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18259,'Are you sure',8) 
GO

INSERT INTO HtmlLabelIndex values(18260,'是否同步下级单位') 
GO
INSERT INTO HtmlLabelInfo VALUES(18260,'是否同步下级单位',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18260,'Synchronize Sub Unit',8) 
GO

INSERT INTO HtmlLabelIndex values(18261,'分值超出评分范围') 
GO
INSERT INTO HtmlLabelInfo VALUES(18261,'分值超出评分范围',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18261,'Paranormal Point',8) 
GO

/*报告*/
INSERT INTO HtmlLabelIndex values(18229,'自评') 
GO
INSERT INTO HtmlLabelInfo VALUES(18229,'自评',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18229,'self check',8) 
GO

INSERT INTO HtmlLabelIndex values(18230,'未启动') 
GO
INSERT INTO HtmlLabelInfo VALUES(18230,'未启动',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18230,'don''t start',8) 
GO


INSERT INTO HtmlLabelIndex values(18232,'评分必须在评分规则设定范围内') 
GO
INSERT INTO HtmlLabelInfo VALUES(18232,'评分必须在评分规则设定范围内',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18232,'point must in point rule',8) 
GO

INSERT INTO HtmlLabelIndex values(18233,'请填写自评分') 
GO
INSERT INTO HtmlLabelInfo VALUES(18233,'请填写自评分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18233,'please input point',8) 
GO

INSERT INTO HtmlLabelIndex values(18234,'请填写进度') 
GO
INSERT INTO HtmlLabelInfo VALUES(18234,'请填写进度',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18234,'please input schedule',8) 
GO
INSERT INTO HtmlLabelIndex values(18235,'请选择述职总结文挡') 
GO
INSERT INTO HtmlLabelInfo VALUES(18235,'请选择述职总结文挡',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18235,'please choose document of report work',8) 
GO

INSERT INTO HtmlLabelIndex values(18236,'月报告汇总') 
GO
INSERT INTO HtmlLabelInfo VALUES(18236,'月报告汇总',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18236,'sum of report of month',8) 
GO

INSERT INTO HtmlLabelIndex values(18241,'同一周期下只能有唯一的月工作计划考核或月考核汇总') 
GO
INSERT INTO HtmlLabelInfo VALUES(18241,'同一周期下只能有唯一的月工作计划考核或月考核汇总',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18241,'',8) 
GO

INSERT INTO HtmlLabelIndex values(18242,'下游评分') 
GO
INSERT INTO HtmlLabelInfo VALUES(18242,'下游评分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18242,'down point',8) 
GO
INSERT INTO HtmlLabelIndex values(18243,'请填写评分') 
GO
INSERT INTO HtmlLabelInfo VALUES(18243,'请填写评分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18243,'PLEASE INPUT POINT',8) 
GO

INSERT INTO HtmlLabelIndex values(18246,'您还没有评分') 
GO
INSERT INTO HtmlLabelInfo VALUES(18246,'您还没有评分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18246,'please check',8) 
GO

INSERT INTO HtmlLabelIndex values(18247,'月度考核') 
GO
INSERT INTO HtmlLabelInfo VALUES(18247,'月度考核',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18247,'check of the month',8) 
GO
 
 INSERT INTO HtmlLabelIndex values(18255,'下级指标将一起删除，请确认！') 
GO
INSERT INTO HtmlLabelInfo VALUES(18255,'下级指标将一起删除，请确认！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18255,'will del childitem ,pleas confirm',8) 
GO
INSERT INTO HtmlLabelIndex values(17955,'总得分') 
GO
INSERT INTO HtmlLabelInfo VALUES(17955,'总得分',7) 
GO

INSERT INTO HtmlLabelIndex values(18263,'综合素质考核') 
GO
INSERT INTO HtmlLabelInfo VALUES(18263,'综合素质考核',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18263,'ability check',8) 
GO

INSERT INTO HtmlLabelIndex values(18264,'修正得分') 
GO
INSERT INTO HtmlLabelInfo VALUES(18264,'修正得分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18264,'modified point',8) 
GO
INSERT INTO HtmlLabelIndex values(18265,'面谈记录') 
GO
INSERT INTO HtmlLabelInfo VALUES(18265,'面谈记录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18265,'interview note',8) 
GO
INSERT INTO HtmlLabelIndex values(18266,'保存面谈记录') 
GO
INSERT INTO HtmlLabelInfo VALUES(18266,'保存面谈记录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18266,'save interview note',8) 
GO

INSERT INTO HtmlLabelIndex values(18267,'考核排名') 
GO
INSERT INTO HtmlLabelInfo VALUES(18267,'考核排名',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18267,'point order',8) 
GO

INSERT INTO HtmlLabelIndex values(18268,'尚未设置审批流程，请和管理员联系') 
GO
INSERT INTO HtmlLabelInfo VALUES(18268,'尚未设置审批流程，请和管理员联系',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18268,'flow not set',8) 
GO

INSERT INTO HtmlLabelIndex values(18118,'权重指数不能大于100') 
GO
INSERT INTO HtmlLabelInfo VALUES(18118,'权重指数不能大于100',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18118,'The power index can''''t be greater than 100%',8) 
GO



EXECUTE MMConfig_U_ByInfoInsert 3,5
GO
EXECUTE MMInfo_Insert 433,18041,'目标管理','','',3,1,5,0,'',0,'',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,1
GO
EXECUTE MMInfo_Insert 434,18042,'考核等级划分','hrm/performance/maintenance/checkGrade/GradeList.jsp','mainFrame',433,2,1,0,'',1,'CheckGradeInfo:Maintenance',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,2
GO
EXECUTE MMInfo_Insert 435,18043,'审批流程关联','hrm/performance/maintenance/checkFlow/checkFlowList.jsp','mainFrame',433,2,1,0,'',1,'CheckFlowInfo:Maintenance',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,3
GO
EXECUTE MMInfo_Insert 436,18044,'计划性质设定','hrm/performance/maintenance/planKind/PlanList.jsp','mainFrame',433,2,1,0,'',1,'PlanKindInfo:Maintenance',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,4
GO
EXECUTE MMInfo_Insert 437,18046,'提醒时间设定','hrm/performance/maintenance/alertTime/alertList.jsp','mainFrame',433,2,1,0,'',1,'AlertTimeInfo:Maintenance',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,5
GO
EXECUTE MMInfo_Insert 439,18048,'自定义考核表','hrm/performance/maintenance/diyCheck/CheckList.jsp','mainFrame',433,2,2,0,'',1,'DiyCheck:Maintenance',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,8
GO
EXECUTE MMInfo_Insert 441,18050,'评分规则','hrm/performance/pointRule/RuleView.jsp','mainFrame',433,2,2,0,'',1,'PointRule:Performance',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,6
GO
EXECUTE MMInfo_Insert 438,18047,'指标库','hrm/performance/maintenance/targetType/TargetTypeList.jsp','mainFrame',433,2,1,0,'',1,'TargetTypeInfo:Maintenance',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,7
GO
EXECUTE MMInfo_Insert 440,18049,'考核方案设定','hrm/performance/checkScheme/CheckSchemeList.jsp','mainFrame',433,2,2,0,'',1,'CheckScheme:Performance',0,'','',0,'','',2
GO




insert into SystemRights (id,rightdesc,righttype) values (600,'考核等级划分','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (600,7,'考核等级划分','考核等级划分，新增，删除，修改') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (600,8,'CHECK GRADE SET','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4099,'考核等级设定','CheckGradeInfo:Maintenance',600) 
GO

insert into SystemRights (id,rightdesc,righttype) values (601,'审批流程设定','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (601,7,'审批流程设定','审批流程设定') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (601,8,'CHECK FLOW SETTING','CHECK FLOW SETTING') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4100,'审批流程设定','CheckFlowInfo:Maintenance',601) 
GO

insert into SystemRights (id,rightdesc,righttype) values (602,'计划性质设定','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (602,7,'计划性质设定','计划性质设定') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (602,8,'PLAN ATTRIBUTE SETTING','PLAN ATTRIBUTE SETTING') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4101,'计划性质设定','PlanKindInfo:Maintenance',602) 
GO

insert into SystemRights (id,rightdesc,righttype) values (603,'提醒时间设定','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (603,7,'提醒时间设定','提醒时间设定') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (603,8,'ALERT TIME SETTING','ALERT TIME SETTING') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4102,'提醒时间设定','AlertTimeInfo:Maintenance',603) 
GO

insert into SystemRights (id,rightdesc,righttype) values (604,'指标库设定','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (604,7,'指标库设定','指标库设定') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (604,8,'TARGET LIST SETTING','TARGET LIST SETTING') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4103,'指标库设定','TargetTypeInfo:Maintenance',604) 
GO

insert into SystemRights (id,rightdesc,righttype) values (605,'自定义考核表设定','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (605,8,'CUSTOM CHECK SETTING','CUSTOM CHECK SETTING') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (605,7,'自定义考核表设定','自定义考核表设定') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4104,'自定义考核表设定','DiyCheck:Maintenance',605) 
GO

insert into SystemRights (id,rightdesc,righttype) values (606,'考核方案设定','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (606,7,'考核方案设定','考核方案设定') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (606,8,'CHECK SCHEME SETTING','CHECK SCHEME SETTING') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4105,'考核方案设定','CheckScheme:Performance',606) 
GO

insert into SystemRights (id,rightdesc,righttype) values (607,'评分规则设定','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (607,8,'POINT RULE SETTING','POINT RULE SETTING') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (607,7,'评分规则设定','评分规则设定') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4106,'评分规则设定','PointRule:Performance',607) 
GO
 




insert into SystemRights (id,rightdesc,righttype) values (619,'得分修正','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (619,8,'Modify Point','Modify Point') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (619,7,'得分修正','得分修正') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4123,'得分修正','ModifyPoint:Edit',619) 
GO

insert into SystemRights (id,rightdesc,righttype) values (626,'分部目标设定权限','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (626,7,'分部目标设定权限','分部目标设定权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (626,8,'SubCompany Goal Manage','SubCompany Goal Manage') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4108,'分部目标设定权限','SubCompanyGoal:Manage',626) 
GO

insert into SystemRights (id,rightdesc,righttype) values (608,'部门目标设定权限','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (608,7,'部门目标设定权限','部门目标设定权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (608,8,'Department Goal Manage','Department Goal Manage') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4109,'部门目标设定权限','DepartmentGoal:Manage',608) 
GO

insert into SystemRights (id,rightdesc,righttype) values (632,'集团目标设定权限','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (632,8,'Company Goal Manage','Company Goal Manage') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (632,7,'集团目标设定权限','集团目标设定权限') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4136,'集团目标设定权限','CompanyGoal:Manage',632) 
GO




insert into SystemRights (id,rightdesc,righttype) values (636,'集团报告生成权限','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (636,7,'集团报告生成权限','集团报告生成权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (636,8,'GROUP REPORT SETTING','GROUP REPORT SETTING') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4113,'集团报告生成权限','GroupReport:Performance',636) 
GO

 
insert into SystemRights (id,rightdesc,righttype) values (635,'分部报告生成权限','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (635,8,'BRANCH REPORT SETTING','BRANCH REPORT SETTING') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (635,7,'分部报告生成权限','分部报告生成权限') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4114,'分部报告生成权限','BranchReport:Performance',635) 
GO 


insert into SystemRights (id,rightdesc,righttype) values (634,'集团计划设定权限','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (634,8,'group plan setting','group plan setting') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (634,7,'集团计划设定权限','集团计划设定权限') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4110,'集团计划设定权限','GroupPlan:Performance',634) 
GO

insert into SystemRights (id,rightdesc,righttype) values (633,'分部计划设定权限','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (633,8,'branch plan setting','branch plan setting') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (633,7,'分部计划设定权限','分部计划设定权限') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4111,'分部计划设定权限','BranchPlan:Performance',633) 
GO


insert into SystemRights (id,rightdesc,righttype) values (610,'部门报告生成权限','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (610,7,'部门报告生成权限','部门报告生成权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (610,8,'DEPARTMENT REPORT SUBMIT','DEPARTMENT REPORT SUBMIT') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4115,'部门报告生成权限','DepartmentReport:Performance',610) 
GO

insert into SystemRights (id,rightdesc,righttype) values (609,'部门计划设定权限','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (609,7,'部门计划设定权限','部门计划设定权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (609,8,'Department PLAN SEETING','Department PLAN SEETING') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4112,'部门计划设定权限','DepartmentPlan:Performance',609) 
GO


/*生成sequence表*/
insert SequenceIndex (indexdesc,currentid) values('gradeid',1)
GO
insert SequenceIndex (indexdesc,currentid) values('planid',1)
GO
insert SequenceIndex (indexdesc,currentid) values('targettypeid',1)
GO
insert SequenceIndex (indexdesc,currentid) values('targetdetailid',1) 
GO
insert SequenceIndex (indexdesc,currentid) values('checkruleid',1) 
GO
insert SequenceIndex (indexdesc,currentid) values('checkdetailid',1)  
GO

insert SequenceIndex (indexdesc,currentid) values('appendruleid',1)   
GO

insert SequenceIndex (indexdesc,currentid) values('checkschemeid',1)
GO
insert SequenceIndex (indexdesc,currentid) values('chemecontentid',1)

GO
insert SequenceIndex (indexdesc,currentid) values('schemedetailid',1)

GO
/*
计划
*/
insert SequenceIndex (indexdesc,currentid) values('targetplanid',1)
Go
insert SequenceIndex (indexdesc,currentid) values('plangroupid',1)
GO

/*
报告
*/
insert SequenceIndex (indexdesc,currentid) values('reportid',1)
GO
insert SequenceIndex (indexdesc,currentid) values('reportlogid',1)
GO
/*
考核
*/

insert SequenceIndex (indexdesc,currentid) values('checkid',1)
insert SequenceIndex (indexdesc,currentid) values('nodepointid',1)
GO
insert SequenceIndex (indexdesc,currentid) values('checkpointid',1)
GO

/*目标*/
/*添加目标Sequence*/
INSERT INTO SequenceIndex(indexdesc, currentid)VALUES('goalid',1)
GO

/*添加目标GroupSequence*/
INSERT INTO SequenceIndex(indexdesc, currentid)VALUES('goalgroupid',1)
GO
/*
左边菜单
*/

 
INSERT INTO HtmlLabelIndex values(18408,'绩效计划') 
GO
INSERT INTO HtmlLabelIndex values(18409,'绩效报告') 
GO
INSERT INTO HtmlLabelInfo VALUES(18408,'绩效计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18408,'Performorce Plan',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18409,'绩效报告',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18409,'Perfomeroce Report',8) 
GO 

update leftmenuinfo set defaultindex=7 where id=97
go
update  leftmenuconfig set viewindex=7 where infoid=97 
go

EXECUTE LMConfig_U_ByInfoInsert 2,94,1
GO
EXECUTE LMInfo_Insert 95,18028,'/images_face/ecologyFace_2/LeftMenuIcon/MyKPI.gif','/hrm/performance/goal/myGoalFrame.jsp',2,94,1,9 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,94,3
GO
EXECUTE LMInfo_Insert 120,18220,'/images_face/ecologyFace_2/LeftMenuIcon/MyKPI.gif','/hrm/performance/targetPlan/PlanModulList.jsp',2,94,3,2 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,94,2
GO
EXECUTE LMInfo_Insert 125,18408,'/images_face/ecologyFace_2/LeftMenuIcon/MyPlan.gif','/hrm/performance/targetPlan/PlanMain.jsp',2,94,2,2 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,94,4
GO
EXECUTE LMInfo_Insert 126,16434,'/images_face/ecologyFace_2/LeftMenuIcon/MyAssess.gif','/hrm/performance/targetCheck/CheckMain.jsp',2,94,4,2 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,94,6
GO
EXECUTE LMInfo_Insert 124,18267,'/images_face/ecologyFace_2/LeftMenuIcon/MyKPI.gif','/hrm/performance/targetCheck/PointSort.jsp',2,94,6,2 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,94,5
GO
EXECUTE LMInfo_Insert 127,18409,'/images_face/ecologyFace_2/LeftMenuIcon/MyReport.gif','/hrm/performance/targetReport/ReportMain.jsp',2,94,5,2 
GO



/**/
INSERT INTO HrmPerformanceCheckFlow (objId,objType) VALUES (0,'0')
GO
INSERT INTO HrmPerformanceCheckFlow (objId,objType) SELECT id,'1' FROM HrmSubCompany
GO
INSERT INTO HrmPerformanceCheckFlow (objId,objType) SELECT id,'2' FROM HrmDepartment
GO
INSERT INTO HrmPerformanceCheckFlow (objId,objType) SELECT id,'3' FROM HrmDepartment
GO

INSERT INTO HtmlLabelIndex values(18197,'目标绩效计划审批') 
GO
INSERT INTO HtmlLabelIndex values(18198,'目标绩效目标审批') 
GO
INSERT INTO HtmlLabelIndex values(18199,'目标绩效考核评分') 
GO
INSERT INTO HtmlLabelInfo VALUES(18197,'目标绩效计划审批',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18198,'目标绩效目标审批',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18199,'目标绩效考核评分',7) 
GO

INSERT INTO HtmlLabelInfo VALUES(18197,'BPM Plan Approve',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18198,'BPM Target Approve',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18199,'BPM Grade',8) 
GO

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 124,407,'int','/systeminfo/BrowserMain.jsp?url=/hrm/performance/targetPlan/WorkPlanGroupBrowser.jsp','WorkPlanGroup','planName','id','/hrm/performance/targetPlan/PlanList.jsp?id=')
GO
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 125,330,'int','/systeminfo/BrowserMain.jsp?url=/htm/performance/goal/goalGroupBrowser.jsp','BPMGoalGroup','goalName','id','/hrm/performance/goal/myGoalList.jsp?id=')
GO
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 126,351,'int','/systeminfo/BrowserMain.jsp?url=/htm/performance/report/HrmPerformanceReportGroupBrowser.jsp','GradeGroup','gradeName','id','/hrm/performance/targetCheck/GradeList.jsp?id=')
GO

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(145,18197,'BillBPMApprovePlan','','','','','','BillBPMApprovePlanOperation.jsp') 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (145,'paraID',407,'int',3,124,1,0) 
GO

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(146,18198,'BillBPMApproveGoal','','','','','','BillBPMApproveGoalOperation.jsp') 
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (146,'paraID',330,'int',3,125,1,0) 
GO

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(147,18199,'BillBPMGrade','','','','','','BillBPMGradeOperation.jsp') 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (147,'paraID',351,'int',3,126,1,0) 
GO

CREATE PROCEDURE GetMaxId_PRO 
(@type varchar(20), @flag int output, @msg varchar(60) output)
as 
declare @id_1 integer
select @id_1=currentid from SequenceIndex where indexdesc= @type
update SequenceIndex set currentid = @id_1+1 where indexdesc= @type
select @id_1

GO

create procedure BPMSequenceId_Get
(@indexdesc varchar(40),@flag int output, @msg varchar(60) output)
as 
declare @id_1 integer
select @id_1=currentid from SequenceIndex where indexdesc=@indexdesc
update SequenceIndex set currentid = @id_1+1 where indexdesc=@indexdesc
select @id_1
GO




create procedure HrmBPMGoalMaxId_Get
(@flag int output, @msg varchar(60) output)
as 
declare @id_1 integer
select @id_1=currentid from SequenceIndex where indexdesc='goalid'
update SequenceIndex set currentid = @id_1+1 where indexdesc='goalid'
select @id_1
GO

/*由于 BPMGoalGroup 表的更改，更新所有该组目标的状态*/
CREATE TRIGGER Tri_UHrmPGoal_ByStatus ON BPMGoalGroup
FOR INSERT, UPDATE
AS
Declare 
@status 	char(1),
@groupid 	int,
@countdelete   	int,
@countinsert   	int

SELECT @countdelete = count(*) FROM deleted
SELECT @countinsert = count(*) FROM inserted

/*插入时 @countinsert >0 AND @countdelete = 0 */
/*删除时 @countinsert =0 */
/*更新时 @countinsert >0 AND @countdelete > 0 */

/*插入*/
IF (@countinsert>0 AND @countdelete=0)
BEGIN
	SELECT @groupid=id , @status=status FROM inserted
	UPDATE HrmPerformanceGoal SET status=@status WHERE groupid=@groupid
END

/*更新*/
IF (@countinsert>0 AND @countdelete>0)
BEGIN
	SELECT @groupid=id , @status=status FROM inserted
	UPDATE HrmPerformanceGoal SET status=@status WHERE groupid=@groupid
END

GO

CREATE TRIGGER  delCheckStd ON HrmPerformanceCheckDetail 
FOR  DELETE 
AS
DECLARE @id tinyint
select @id=id from deleted 
delete from  hrmPerformanceCheckStd   where checkDetailId=@id

GO

CREATE TRIGGER deletecontent ON HrmPerformanceSchemeContent
FOR DELETE 

AS
declare @id tinyint
select @id=id from deleted
delete from HrmPerformanceSchemeDetail where contentId=@id

GO

CREATE TRIGGER deleteItem ON HrmPerformanceSchemeDetail
FOR DELETE 

AS
declare @id tinyint
select @id=id from deleted
delete from HrmPerformanceSchemePercent where itemId=@id

GO

CREATE TRIGGER AddTargetToMain ON HrmPerformanceTargetDetail 
FOR INSERT
AS 
DECLARE @id tinyint
select @id=targetId from inserted
update hrmPerformanceTargetType set num=num+1 where id=@id

GO

CREATE TRIGGER  delTargetToMain ON HrmPerformanceTargetDetail 
FOR  DELETE 
AS
DECLARE @id tinyint
select @id=targetId from deleted 
update hrmPerformanceTargetType set num=num-1 where id=@id

GO

INSERT INTO HtmlLabelIndex values(18435,'：') 
GO
INSERT INTO HtmlLabelInfo VALUES(18435,'：',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18435,':',8) 
GO
