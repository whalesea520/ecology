ALTER table Workflow_SubwfSet add triggerSource integer
/
ALTER table Workflow_SubwfSet add triggerSourceType varchar2(10)
/
ALTER table Workflow_SubwfSet add triggerSourceOrder integer
/
alter table Workflow_SubwfSet add triggerCondition varchar2(200)
/
ALTER table Workflow_SubwfSet add isreadNodes varchar2(255)
/
ALTER table Workflow_SubwfSet add isreadMainwf char(1)
/
alter table Workflow_SubwfSet add isreadMainWfNodes varchar2(255)
/
ALTER table Workflow_SubwfSet add isreadParallelwf char(1)
/
ALTER table Workflow_SubwfSet add isreadParallelwfNodes varchar2(255)
/
ALTER table Workflow_SubwfSet add enable char(1)
/
ALTER table Workflow_SubwfSet add isStopCreaterNode char(1)
/
ALTER table Workflow_TriDiffWfDiffField add enable char(1)
/
ALTER table Workflow_TriDiffWfDiffField add triggerSource char(1)
/
ALTER table Workflow_TriDiffWfDiffField add triggerSourceType varchar2(10)
/
ALTER table Workflow_TriDiffWfDiffField add triggerSourceOrder integer
/
alter table Workflow_TriDiffWfDiffField add triggerCondition varchar2(200)
/
ALTER table workflow_subwfsetdetail add isCreateDocAgain char(1)
/
ALTER table workflow_subwfsetdetail add isCreateAttachmentAgain char(1)
/
ALTER table workflow_subwfsetdetail add isCreateForAnyone char(1)
/
alter table Workflow_TriDiffWfSubWf rename column fieldValue to fieldValue_back
/
ALTER table Workflow_TriDiffWfSubWf add fieldValue varchar2(1000)
/
UPDATE Workflow_TriDiffWfSubWf SET fieldValue=fieldValue_back
/
ALTER table Workflow_TriDiffWfSubWf add isreadNodes varchar2(255)
/
ALTER table Workflow_TriDiffWfSubWf add isreadMainwf char(1)
/
alter table Workflow_TriDiffWfSubWf add isreadMainWfNodes varchar2(255)
/
ALTER table Workflow_TriDiffWfSubWf add isreadParallelwf char(1)
/
ALTER table Workflow_TriDiffWfSubWf add isreadParallelwfNodes varchar2(255)
/
ALTER table Workflow_TriDiffWfSubWf add ifSplitField char(1)
/
ALTER table Workflow_TriDiffWfSubWf add isStopCreaterNode char(1)
/
alter table Workflow_TriDiffWfSubWfField add isCreateAttachmentAgain char(1)
/
ALTER table workflow_function_manage add isDeleSubWf char(1)
/
ALTER table workflow_flownode add issubwfAllEnd char(1)
/
ALTER table workflow_flownode add subwfscope varchar2(100)
/
ALTER table workflow_flownode add subwfdiffscope varchar2(100)
/
ALTER table workflow_flownode add issubwfremind char(1)
/
ALTER table workflow_flownode add subwfremindtype varchar2(10)
/
ALTER table workflow_flownode add subwfremindoperator varchar2(1)
/
ALTER table workflow_flownode add subwfremindobject varchar2(1)
/
ALTER table workflow_flownode add subwfremindperson varchar2(500)
/
ALTER table workflow_flownode add subwffreeforword char(1)
/
CREATE TABLE Workflow_RequestSubwfRead (
	requestid integer null,
	mainrequestid integer null,
	isread char(1) null,
	isreadNodes varchar2(255) null,
	isreadMainwf char(1) null,
	isreadMainWfNodes varchar2(255) null,
	isreadParallelwf char(1) null,
	isreadParallelwfNodes varchar2(255) null
)
/
CREATE TABLE Workflow_SubwfRequest (
	subwfid integer null,
	subrequestid integer null,
	mainrequestid integer null,
	isSame char(1) null
)
/
update Workflow_SubwfSet set isreadMainwf=isread,isreadParallelwf=isread
/
update Workflow_SubwfSet set enable='1'
/
update Workflow_SubwfSet set isStopCreaterNode='0'
/
update Workflow_TriDiffWfSubWf set isreadMainwf=isread,isreadParallelwf=isread
/
update Workflow_TriDiffWfDiffField set enable='1'
/
update Workflow_TriDiffWfSubWf set isStopCreaterNode='0'
/
alter table Workflow_TriDiffWfDiffField drop column triggerSource
/
alter table Workflow_TriDiffWfDiffField add triggerSource integer
/

update Workflow_SubwfSet set isreadNodes='all',isreadMainWfNodes='all',isreadParallelwfNodes='all'
/

update Workflow_TriDiffWfSubWf set isreadNodes='all',isreadMainWfNodes='all',isreadParallelwfNodes='all'
/

