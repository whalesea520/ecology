ALTER table Workflow_SubwfSet add triggerSource int
GO
ALTER table Workflow_SubwfSet add triggerSourceType varchar(10)
GO
ALTER table Workflow_SubwfSet add triggerSourceOrder int
GO
alter table Workflow_SubwfSet add triggerCondition varchar(200)
GO
ALTER table Workflow_SubwfSet add isreadNodes varchar(255)
GO
ALTER table Workflow_SubwfSet add isreadMainwf char(1)
GO
alter table Workflow_SubwfSet add isreadMainWfNodes varchar(255)
GO
ALTER table Workflow_SubwfSet add isreadParallelwf char(1)
GO
ALTER table Workflow_SubwfSet add isreadParallelwfNodes varchar(255)
GO
ALTER table Workflow_SubwfSet add enable char(1)
GO
ALTER table Workflow_SubwfSet add isStopCreaterNode char(1)
GO
ALTER table Workflow_TriDiffWfDiffField add enable char(1)
GO
ALTER table Workflow_TriDiffWfDiffField add triggerSource char(1)
GO
ALTER table Workflow_TriDiffWfDiffField add triggerSourceType varchar(10)
GO
ALTER table Workflow_TriDiffWfDiffField add triggerSourceOrder int
GO
alter table Workflow_TriDiffWfDiffField add triggerCondition varchar(200)
GO
ALTER table workflow_subwfsetdetail add isCreateDocAgain char(1)
GO
ALTER table workflow_subwfsetdetail add isCreateAttachmentAgain char(1)
GO
ALTER table workflow_subwfsetdetail add isCreateForAnyone char(1)
GO
ALTER table Workflow_TriDiffWfSubWf alter column fieldValue varchar(1000)
GO
ALTER table Workflow_TriDiffWfSubWf add isreadNodes varchar(255)
GO
ALTER table Workflow_TriDiffWfSubWf add isreadMainwf char(1)
GO
alter table Workflow_TriDiffWfSubWf add isreadMainWfNodes varchar(255)
GO
ALTER table Workflow_TriDiffWfSubWf add isreadParallelwf char(1)
GO
ALTER table Workflow_TriDiffWfSubWf add isreadParallelwfNodes varchar(255)
GO
ALTER table Workflow_TriDiffWfSubWf add ifSplitField char(1)
GO
ALTER table Workflow_TriDiffWfSubWf add isStopCreaterNode char(1)
GO
alter table Workflow_TriDiffWfSubWfField add isCreateAttachmentAgain char(1)
GO
ALTER table workflow_function_manage add isDeleSubWf char(1)
GO
ALTER table workflow_flownode add issubwfAllEnd char(1)
GO
ALTER table workflow_flownode add subwfscope varchar(100)
GO
ALTER table workflow_flownode add subwfdiffscope varchar(100)
GO
ALTER table workflow_flownode add issubwfremind char(1)
GO
ALTER table workflow_flownode add subwfremindtype varchar(10)
GO
ALTER table workflow_flownode add subwfremindoperator varchar(1)
GO
ALTER table workflow_flownode add subwfremindobject varchar(1)
GO
ALTER table workflow_flownode add subwfremindperson varchar(500)
GO
ALTER table workflow_flownode add subwffreeforword char(1)
GO
CREATE TABLE Workflow_RequestSubwfRead (
	requestid int null,
	mainrequestid int null,
	isread char(1) null,
	isreadNodes varchar(255) null,
	isreadMainwf char(1) null,
	isreadMainWfNodes varchar(255) null,
	isreadParallelwf char(1) null,
	isreadParallelwfNodes varchar(255) null
)
GO
CREATE TABLE Workflow_SubwfRequest (
	subwfid int null,
	subrequestid int null,
	mainrequestid int null,
	isSame char(1) null
)
GO
update Workflow_SubwfSet set isreadMainwf=isread,isreadParallelwf=isread
GO
update Workflow_SubwfSet set enable='1'
GO
update Workflow_SubwfSet set isStopCreaterNode='0'
GO
update Workflow_TriDiffWfSubWf set isreadMainwf=isread,isreadParallelwf=isread
GO
update Workflow_TriDiffWfDiffField set enable='1'
GO
update Workflow_TriDiffWfSubWf set isStopCreaterNode='0'
GO
alter table Workflow_TriDiffWfDiffField drop column triggerSource
GO
alter table Workflow_TriDiffWfDiffField add triggerSource int
GO

update Workflow_SubwfSet set isreadNodes='all',isreadMainWfNodes='all',isreadParallelwfNodes='all'
GO

update Workflow_TriDiffWfSubWf set isreadNodes='all',isreadMainWfNodes='all',isreadParallelwfNodes='all'
GO

