/*会议审批流程中增加'空会议室使用情况'字段－董平*/
INSERT INTO HtmlLabelIndex values(17546,'空会议室使用情况') 
/
INSERT INTO HtmlLabelInfo VALUES(17546,'空会议室使用情况',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17546,'blank meeting room use case',8) 
/

INSERT INTO workflow_browserurl 
	(id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl)
VALUES 	( 118,17546,'','\meeting\maint\blankMeentingRoomBrowser.jsp','','','','')
/

INSERT INTO workflow_billfield 
	( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) 
VALUES 	(85,'viewMeetRoomUseCase',2193,'varchar(100)',3,118,10,0)
/
alter  TABLE Bill_Meeting add  viewMeetRoomUseCase varchar(100)
/