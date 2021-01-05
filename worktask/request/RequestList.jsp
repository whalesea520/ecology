
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.*,weaver.file.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>
<%@ page import="weaver.worktask.bean.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<STYLE TYPE="text/css">
/*样式名未定义*/
.btn_RequestSubmitList {BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
} 
</STYLE>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetu" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetd" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="sptmForWorktask" class="weaver.splitepage.transform.SptmForWorktask" scope="page" />
<jsp:useBean id="requestShare" class="weaver.worktask.request.RequestShare" scope="page"/>
<%
String para = "";
String taskids = "";
String tasknames = "";
rs1.execute("select * from worktask_base");
while(rs1.next()){
	String id_tmp = Util.null2String(rs1.getString("id"));
	String name_tmp = Util.null2String(rs1.getString("name"));
	taskids += (id_tmp + "^a^");
	tasknames += (name_tmp + "^b^");
}
if(!"".equals(taskids)){
	taskids = taskids.substring(0, taskids.length()-3);
}
if(!"".equals(tasknames)){
	tasknames = tasknames.substring(0, tasknames.length()-3);
}
para = taskids + "#c#" + tasknames;
String CurrentUser = ""+user.getUID();
String currentMonth = String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).MONTH)+1);
String currentWeek = String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).WEEK_OF_YEAR));
String currentDay = TimeUtil.getCurrentDateString();

int isSelfCreate = Util.getIntValue(request.getParameter("isSelfCreate"), 0);//创建人是自己
int isOtherCreate = Util.getIntValue(request.getParameter("isOtherCreate"), 0);//创建人是他人
int isLiableperson = Util.getIntValue(request.getParameter("isLiableperson"), 0);//作为责任人
int isCoadjutant = Util.getIntValue(request.getParameter("isCoadjutant"), 0);//作为协助人
int isCheckor = Util.getIntValue(request.getParameter("isCheckor"), 0);//作为验证人
int isCreater = Util.getIntValue(request.getParameter("isCreater"), 0);//作为创建人

String operationType = Util.null2String(request.getParameter("operationType"));
String wtid = Util.null2String(request.getParameter("wtid"));
String worktaskStatus = Util.null2String(request.getParameter("worktaskStatus"));

int pagenum=Util.getIntValue(request.getParameter("pagenum"), 1);
int	perpage=10;

String backfields = " o.id, o.optstatus, o.userid, r.creater, r.createdate, r.createtime, r.planstartdate, r.planstarttime, r.planenddate, r.planendtime, r.taskid, r.taskcontent,r.taskname, r.checkor, r.needcheck, o.viewtype, o.createrviewtype, o.checkorviewtype ";
String fromSql  = " from worktask_operator o, worktask_requestbase r ";
String sqlWhere = " where o.requestid=r.requestid and r.deleted=0 and o.type=1 and r.istemplate=0 and r.status in (6,7,8,9,10,11) ";
if(isSelfCreate==0 && isOtherCreate==1){//创建人不是自己
	sqlWhere += " and r.creater<>"+user.getUID()+" ";
}else if(isSelfCreate==1 && isOtherCreate==0){//创建人是自己
	sqlWhere += " and r.creater="+user.getUID()+" ";
}
if(!"".equals(worktaskStatus.trim())){//处理责任人状态与任务状态不同的修正
	String optStatus = "";
	if((","+worktaskStatus+",").indexOf(",5,") !=-1){
		optStatus += "0,-1,7,8,";
	}else{
		if((","+worktaskStatus+",").indexOf(",6,") !=-1){
			optStatus += "0,";
		}
		if((","+worktaskStatus+",").indexOf(",7,") !=-1){
			optStatus += "-1,7,";
		}
		if((","+worktaskStatus+",").indexOf(",8,") !=-1){
			optStatus += "8,";
		}
	}
	if((","+worktaskStatus+",").indexOf(",9,") !=-1){
		optStatus += "1,";
	}
	if(!"".equals(optStatus)){
		optStatus = optStatus.substring(0, optStatus.length()-1);
		sqlWhere += " and o.optstatus in ("+optStatus+") ";
	}
}
if(!"".equals(wtid)){
	if(wtid.endsWith(",")){
		wtid = wtid.substring(0, wtid.length()-1);
	}
	sqlWhere += " and r.taskid in ("+wtid+") ";
}
if(isLiableperson==1 || isCheckor==1 || isCreater==1 || isCoadjutant==1){
	sqlWhere += " and ( ";
	if(isLiableperson == 1){
		sqlWhere += " o.userid = "+user.getUID()+" or  exists(select 1  from worktask_requestbase a inner join worktask_list b on a.requestid = b.requestid inner join worktask_list_liableperson c    on b.id=c.wtlistid  where  c.userid='"+user.getUID()+"'  and a.requestid=o.requestid) or ";
	}
	if(isCheckor == 1){
		sqlWhere += " r.checkor = "+user.getUID()+" or";
	}
	if(isCreater == 1){
		sqlWhere += " r.creater = "+user.getUID()+" or";
	}
	if(isCoadjutant == 1){
		if(rs1.getDBType().equalsIgnoreCase("oracle")){
			sqlWhere += " concat(concat(',',r.coadjutant),',') like '%,"+user.getUID()+",%' or";
		}else{
			sqlWhere += " ','+CONVERT(varchar,r.coadjutant)+',' like '%,"+user.getUID()+",%' or";
		}
	}
	sqlWhere = sqlWhere.substring(0, sqlWhere.length()-2);
	sqlWhere += " ) ";
}
if(isCheckor != 1){
	sqlWhere += requestShare.getCreateShareStrForView(user.getUID());
}
String orderby = " o.id ";
String tableString = "";
tableString =" <table instanceid=\"WorktaskRequestTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                         "		<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"o.id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
                         "		<head>"+
                         "			<col width=\"11%\"   text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"taskid\" otherpara=\""+para+"\" orderkey=\"taskid\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getWorktaskName\"/>"+
                       	 "			<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"optstatus\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getStatusName\" />"+
                       	 "          <col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(229,user.getLanguage())+"\" column=\"taskname\" otherpara=\"column:id+column:viewtype+column:createrviewtype+column:checkorviewtype+column:userid+column:creater+column:needcheck+column:checkor+column:optstatus+"+user.getUID()+"\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getWorktaskLinkIcon\" />"+
                       	 "			<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(22134,user.getLanguage())+"\" column=\"taskcontent\" />"+
                       	 "			<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(16936,user.getLanguage())+"\" column=\"userid\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getUserLink\" />"+
                       	 "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(22169,user.getLanguage())+"\" column=\"planstartdate\" otherpara=\"column:planstarttime\" orderkey=\"planstartdate, planstarttime\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getDateTime\" />"+
          				 "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(22171,user.getLanguage())+"\" column=\"planenddate\" otherpara=\"column:planendtime\" orderkey=\"planenddate, planendtime\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getDateTime\" />"+
                         "		</head>"+
                         "</table>";

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style>
#tabPane tr td{padding-top:2px}
#monthHtmlTbl td,#seasonHtmlTbl td{cursor:hand;text-align:left;padding:0 2px 0 2px;color:#333}
.cycleTD{font-family:MS Shell Dlg,Arial;background-image:url(/images/tab2_wev8.png);cursor:hand;font-weight:bold;text-align:center;color:#666;border-bottom:1px solid #879293;}
.cycleTDCurrent{font-family:MS Shell Dlg,Arial;padding-top:2px;background-image:url(/images/tab.active2_wev8.png);cursor:hand;font-weight:bold;text-align:center;color:#666}
.seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
#subTab{border-bottom:1px solid #879293;padding:0}
</style>
</HEAD>
<%
String needfav ="1";
String needhelp ="";
String titlename = SystemEnv.getHtmlLabelName(16539, user.getLanguage()) + SystemEnv.getHtmlLabelName(320, user.getLanguage());
String imagefilename = "/images/hdHRM_wev8.gif";
%>

<BODY id="worktaskBody">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15518, user.getLanguage())+",javaScript:onSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<table width=100% height=95% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
<form name="taskform" method="post" action="RequestList.jsp">
		<input type="hidden" name="wtid" id="wtid" value="<%=wtid%>">
		<input type="hidden" name="worktaskStatus" id="worktaskStatus" value="<%=worktaskStatus%>">
		<input type="hidden" name="isSelfCreate" id="isSelfCreate" value="<%=isSelfCreate%>">
		<input type="hidden" name="isOtherCreate" id="isOtherCreate" value="<%=isOtherCreate%>">
		<input type="hidden" name="isLiableperson" id="isLiableperson" value="<%=isLiableperson%>">
		<input type="hidden" name="isCoadjutant" id="isCoadjutant" value="<%=isCoadjutant%>">
		<input type="hidden" name="isCheckor" id="isCheckor" value="<%=isCheckor%>">
		<input type="hidden" name="isCreater" id="isCreater" value="<%=isCreater%>">
		<input type="hidden" name="operationType">
		<input type="hidden" name="planId">
		<input type="hidden" name="importType" value="0" >
		<input type="hidden" name="ishidden" value="1" >
		<input type="hidden" id="functionPage" name="functionPage" value="RequestExecuteList.jsp" >
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		<TABLE width="100%">
		    <tr>
		        <td valign="top">  
		            <wea:SplitPageTag tableString='<%=tableString%>'  mode="run" />
		        </td>
		    </tr>
		</TABLE>

		</td>
		</tr>
		</TABLE>
	</form>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</BODY>

<script>

function onSearch(){
	//document.taskform.operationType.value="search";
	//document.taskform.submit();
	location.href="/worktask/request/WorktaskMain.jsp?rigthPage=RequestExecuteFrame";
	enableAllmenu;
}


</script>
</HTML>


<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
