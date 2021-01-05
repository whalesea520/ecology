
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="SubCompanyComInfo"	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
boolean canedit = false;

int detachable = Util.getIntValue(String.valueOf(session.getAttribute("meetingdetachable")), 0);
int subcompanyid = -1;
//分权模式下参数传过来的选中的分部
int subid = user.getUserSubCompany1();
ArrayList subcompanylist = SubCompanyComInfo.getRightSubCompany(
		user.getUID(), "meetingmanager:all");
int operatelevel = CheckSubCompanyRight
		.ChkComRightByUserRightCompanyId(user.getUID(),
				"meetingmanager:all", subid);
if (detachable == 1) {
	if (subid != 0 && operatelevel < 1) {
		canedit = false;
	} else {
		canedit = true;
	}
	subcompanyid = subid;
} else {
	if (HrmUserVarify.checkUserRight("meetingmanager:all", user)) {
		canedit = true;
	}
}
if (!canedit) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
	String id=Util.null2String(request.getParameter("id"));
	if(!"".equals(id)){
	int dscsDoc	= Util.getIntValue(request.getParameter("dscsDoc"), 0);
	int dscsWf	= Util.getIntValue(request.getParameter("dscsWf"), 0);
	int dscsCrm	= Util.getIntValue(request.getParameter("dscsCrm"), 0);
	int dscsPrj	= Util.getIntValue(request.getParameter("dscsPrj"), 0);
	int dscsTsk	= Util.getIntValue(request.getParameter("dscsTsk"), 0);
	int dscsAttch	= Util.getIntValue(request.getParameter("dscsAttch"), 0);
	String dscsAttchCtgry	= Util.null2String(request.getParameter("dscsAttchCtgry"));
	int tpcDoc	= Util.getIntValue(request.getParameter("tpcDoc"), 0);
	int tpcWf	= Util.getIntValue(request.getParameter("tpcWf"), 0);
	int tpcCrm	= Util.getIntValue(request.getParameter("tpcCrm"), 0);
	int tpcPrj	= Util.getIntValue(request.getParameter("tpcPrj"), 0);
	int tpcTsk	= Util.getIntValue(request.getParameter("tpcTsk"), 0);
	int tpcAttch	= Util.getIntValue(request.getParameter("tpcAttch"), 0);
	String tpcAttchCtgry	= Util.null2String(request.getParameter("tpcAttchCtgry"));
	String mtngAttchCtgry	= Util.null2String(request.getParameter("mtngAttchCtgry"));
	int callerPrm	= Util.getIntValue(request.getParameter("callerPrm"), 1);
	int contacterPrm	= Util.getIntValue(request.getParameter("contacterPrm"), 1);
	int createrPrm	= Util.getIntValue(request.getParameter("createrPrm"), 1);
	int roomConflictChk	= Util.getIntValue(request.getParameter("roomConflictChk"), 0);
	int roomConflict	= Util.getIntValue(request.getParameter("roomConflict"), 1);
	int memberConflictChk	= Util.getIntValue(request.getParameter("memberConflictChk"), 0);
	int memberConflict	= Util.getIntValue(request.getParameter("memberConflict"), 1);
	int timeRangeStart = Util.getIntValue(request.getParameter("timeRangeStart"), 0);
	int timeRangeEnd = Util.getIntValue(request.getParameter("timeRangeEnd"), 24);
	int tpcprjflg = Util.getIntValue(request.getParameter("tpcprjflg"), 0);
	int tpccrmflg = Util.getIntValue(request.getParameter("tpccrmflg"), 0);
	int recArrive = Util.getIntValue(request.getParameter("recArrive"), 0);
	int recBook = Util.getIntValue(request.getParameter("recBook"), 0);
	int recReturn = Util.getIntValue(request.getParameter("recReturn"), 0);
	int recRemark = Util.getIntValue(request.getParameter("recRemark"), 0);
	int days = Util.getIntValue(request.getParameter("days"), 2);
	int dspUnit = Util.getIntValue(request.getParameter("dspUnit"), 1);	
	int createMeetingRemindChk = Util.getIntValue(request.getParameter("createMeetingRemindChk"), 0);
	int cancelMeetingRemindChk = Util.getIntValue(request.getParameter("cancelMeetingRemindChk"), 0);
	int reMeetingRemindChk = Util.getIntValue(request.getParameter("reMeetingRemindChk"), 0);
	int zqhyzdkd = Util.getIntValue(request.getParameter("zqhyzdkd"), 0);
	int canChange= Util.getIntValue(request.getParameter("canChange"), 0);	
	String sql = "update MeetingSet set dscsDoc =" + dscsDoc 
		+ ", dscsWf = " + dscsWf
		+ ", dscsCrm = " + dscsCrm
		+ ", dscsPrj = " + dscsPrj
		+ ", dscsTsk = " + dscsTsk
		+ ", dscsAttch = " + dscsAttch
		+ ", dscsAttchCtgry = '" + dscsAttchCtgry + "' "
		+ ", tpcDoc = " + tpcDoc
		+ ", tpcWf = " + tpcWf
		+ ", tpcCrm = " + tpcCrm
		+ ", tpcPrj = " + tpcPrj
		+ ", tpcTsk = " + tpcTsk
		+ ", tpcAttch = " + tpcAttch
		+ ", tpcAttchCtgry = '" + tpcAttchCtgry + "' "
		+ ", mtngAttchCtgry = '" + mtngAttchCtgry + "' "
		+ ", callerPrm = " + callerPrm
		+ ", contacterPrm = " + contacterPrm
		+ ", createrPrm = " + createrPrm
		+ ", roomConflictChk = " + roomConflictChk
		+ ", roomConflict = " + roomConflict
		+ ", memberConflictChk = " + memberConflictChk
		+ ", memberConflict = " + memberConflict
		+ ", timeRangeStart = " + timeRangeStart
		+ ", timeRangeEnd = " + timeRangeEnd
		+ ", tpcprjflg = " + tpcprjflg
		+ ", tpccrmflg = " + tpccrmflg
		+ ", days = " + days
		+ ", recArrive = " + recArrive
		+ ", recBook = " + recBook
		+ ", recReturn = " + recReturn
		+ ", recRemark = " + recRemark
		+ ", dspUnit = " + dspUnit
		+ ", createMeetingRemindChk = " + createMeetingRemindChk
		+ ", cancelMeetingRemindChk = " + cancelMeetingRemindChk
		+ ", reMeetingRemindChk = " + reMeetingRemindChk
		+ ", zqhyzdkd = " + zqhyzdkd
		+ ", canchange = " + canChange
		+" where id="+id;
	RecordSet.execute(sql);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.insSysLogInfo(user,0,"会议应用设置","会议应用设置","315","2",0,Util.getIpAddr(request));
	
	}
	response.sendRedirect("/meeting/Maint/MeetingSet.jsp");
%>
