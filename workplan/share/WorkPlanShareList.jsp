
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.WorkPlan.WorkPlanShare"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="workPlanHandler" class="weaver.WorkPlan.WorkPlanHandler" scope="page"/>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
		<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

		<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
	</HEAD>
<%
	int msgID = Util.getIntValue(request.getParameter("msgid"), 0);
	int from = Util.getIntValue(request.getParameter("from"), -1);
	String planID = Util.null2String(request.getParameter("planID"));
	
	if (planID.equals(""))
	{
		return;
	}
	String userID = String.valueOf(user.getUID());
	boolean canEdit = false;
	rs.execute("select resourceid,createrid from workplan where id="+planID);
	
	if(rs.next()){
		String createrID=rs.getString("createrid");
		String resourceid=rs.getString("resourceid");
		if (createrID.equals(userID))
		{
		    canEdit = true;
		}
		if(!canEdit&&WorkPlanShare.SHARE_TYPE==2){
			if((","+resourceid+",").indexOf(","+userID+",")>-1){
				canEdit = true;
			}
		}
	}
	 
%>

<%	
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(20190,user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
	if (canEdit) 
	{	
		RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:add(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteSh(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<%if (canEdit) 
			{%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top middle" onclick="add()"/>
			<%}%>
			<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(1290, user.getLanguage())%>"
					id="zd_btn_save" class="e8_btn_top middle" onclick="goBack(this)">
			<%if (canEdit) 
			{%>		
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top middle" onclick="deleteSh()"/>
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span ><%=SystemEnv.getHtmlLabelName(20190,user.getLanguage())%></span>
	</span>
</div>
<div class="zDialog_div_content">
	
	<%
		
		String sqlForm = "WorkPlanShare";
		String sqlWhere = "WHERE isdefault is null and workPlanID = " + planID;
		if(WorkPlanShare.SHARE_TYPE==2){
			sqlWhere+=" and fromuser ="+user.getUID();
		}
		String sqlSortWay = "DESC";
		
		String tableString=""+
			"<table pagesize=\"10\" tabletype=\"checkbox\">"+
		    "<sql backfields=\"*\" sqlform=\"" + sqlForm + "\" sqlprimarykey=\"id\" sqlsortway=\"" + sqlSortWay + "\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
		    " <checkboxpopedom  popedompara=\"column:type\" showmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanShareCheck\"  />"+
		    "<head>"+
		    "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(19910,user.getLanguage())+"\" column=\"shareType\" otherpara=\""+user.getLanguage()+"+column:companyVirtual\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanShareTypeNew\"/>"+
		    "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(19117,user.getLanguage())+"\" column=\"shareType\" orderkey=\"shareType\" otherpara=\"column:userID+column:subCompanyId+column:deptId+column:roleId+column:roleLevel+"+user.getLanguage()+"+column:jobtitleid+column:joblevel+column:joblevelvalue\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanShareTypeDescSig\"/>"+
		    "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage()) + "\" column=\"securityLevel\" orderkey=\"securityLevel\" otherpara=\"column:securityLevelMax+column:SHARETYPE\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getSeclevel\" />"+
		    "<col width=\"13%\"  text=\""+SystemEnv.getHtmlLabelName(3005,user.getLanguage())+"\" column=\"shareLevel\" orderkey=\"shareLevel\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanShareLevelDesc\" />"+ 
		    "</head>"+
			"<operates>"+
				"<popedom column=\"id\" otherpara=\""+canEdit+"column:type\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanSharePersonalOperateList\" ></popedom> "+
				"<operate href=\"javascript:del();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
			"</operates>"+
		"</table>";
	%>
	
	<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/> 


</div>
<%if(from != 2){%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
				<wea:group context="">
					<wea:item type="toolbar">
			
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%}%>
<SCRIPT language="JavaScript">
var dialog1;
if(window.top.Dialog){
	dialog1 = window.top.Dialog;
} else {
	dialog1 = Dialog;
}
function btn_cancle(){
	parent.btn_cancle();
}
jQuery(document).ready(function(){
	resizeDialog(document);
});


function goBack() {
	parent.goBack();
}

function deleteSh(id){
	var ids = "";
	if(id==null ||id=="" || id == "NULL" || id == "Null" || id == "null"){
		$("input[name='chkInTableTag']").each(function(){
			if($(this).attr("checked"))
				ids = ids +$(this).attr("checkboxId")+",";
		});
	} else {
		ids = id+",";
	}
	if(ids!="") {
		dialog1.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
					doDelete(ids.substr(0,ids.length - 1));	
			});
	} else {
		dialog1.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
	}
}

function del(id)
{
	deleteSh(id);
}

function doDelete(ids){
	$.post("WorkPlanShareHandler.jsp?method=delete",{delid:ids,planID:<%=planID%>,f_weaver_belongto_userid:<%=user.getUID()%>},function(datas){
		window.location.href="/workplan/share/WorkPlanShareList.jsp?planID=<%=planID%>&f_weaver_belongto_userid=<%=user.getUID()%>";
	});
}

</SCRIPT>
<script language="javascript">
var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	window.location.href="/workplan/share/WorkPlanShareList.jsp?planID=<%=planID%>&f_weaver_belongto_userid=<%=user.getUID()%>";
}

function add(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 700;
	diag_vote.Height = 300;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(20190,user.getLanguage())%>";
	diag_vote.URL = "/workplan/share/WorkPlanShareSigAdd.jsp?planID=<%=planID%>&f_weaver_belongto_userid=<%=user.getUID()%>";
	diag_vote.show();
}

</script>
</BODY>
</HTML>
