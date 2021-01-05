
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(357,user.getLanguage());
String needfav ="1";
String needhelp ="";

String id = Util.null2String(request.getParameter("id"));
String jobgroupid = "";
String jobactivitymark="";
String jobactivityname="";
RecordSet.executeProc("HrmJobActivities_SelectByID",""+id);
if(RecordSet.next()){
	jobactivitymark = Util.toScreenToEdit(RecordSet.getString("jobactivitymark"),user.getLanguage());
	jobactivityname = Util.toScreenToEdit(RecordSet.getString("jobactivityname"),user.getLanguage());
	jobgroupid = Util.toScreenToEdit(RecordSet.getString("jobgroupid"),user.getLanguage());
}
boolean canDel = Boolean.valueOf(JobActivitiesComInfo.getJobActivityCheckbox(id));
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	id = id +"";
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"/hrm/jobactivities/JobActivitiesOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
					window.location.href="/hrm/jobactivities/HrmJobActivities.jsp?jobgroup=<%=jobgroupid%>";
					}
				}
			});
		}
	});
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmJobActivitiesAdd";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(1915,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmJobActivitiesEdit&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(1915,user.getLanguage())%>";
	}
	dialog.Width = 600;
	dialog.Height = 189;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<script type="text/javascript">
	parent.setTabObjName("<%= jobactivitymark %>");
</script>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	if(HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Edit", user)){
		RCMenu += "{"+SystemEnv.getHtmlLabelNames("93,1915",user.getLanguage())+",javaScript:openDialog("+id+");,_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	if(HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Delete", user) && canDel){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:doDel("+id+");,_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<input type="hidden" name="id" value="<%=id %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Edit", user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog('<%=id %>');" value="<%=SystemEnv.getHtmlLabelNames("93,1915",user.getLanguage())%>"></input>
			<%}if(HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Delete", user) && canDel){ %>
				<input type=button class="e8_btn_top" onclick="doDel('<%=id %>');" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
			<%} %>	
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage()) + SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item><%=jobactivitymark%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage()) + SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
		<wea:item><%=jobactivityname%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%></wea:item>
		<wea:item><%=JobGroupsComInfo.getJobGroupsname(jobgroupid)%></wea:item>
	</wea:group>
</wea:layout>
</BODY></HTML>
