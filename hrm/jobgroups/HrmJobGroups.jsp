<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function onBtnSearchClickById(id){
	jQuery("#jobgroup").val(id);
	jQuery("#searchfrm").submit();
}

function doDel(id){
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	id=id+"";
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
			jQuery.ajax({
				url:"JobGroupsOperation.jsp?isdialog=1&operation=delete&id="+id,
				type:"post",
				async:true,
				complete:function(xhr,status){
						window.parent.parent.location.href = window.parent.parent.location.href;
				}
	});
});
}

function leftTreeReload(){
	window.parent.parent.initTree();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	if(dialog == null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmJobGroupsAdd";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(805,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmJobGroupsEdit&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(805,user.getLanguage())%>";
	}
	dialog.Width = 500;
	dialog.Height = 203;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onLog(id){
	if(dialog == null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=24 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=24")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(805,user.getLanguage());
String needfav ="1";
String needhelp ="";
String id = Util.null2String(request.getParameter("jobgroup"));

String sqlwhere = "";
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);
rs.executeProc("HrmUserDefine_SelectByID",""+user.getUID());
if(rs.next()){
	perpage =Util.getIntValue(rs.getString(36),-1);
}

if(perpage<=1 )	perpage=10;
String navName = JobGroupsComInfo.getJobGroupsname(id);

boolean canDel = true;
String sql = "select count(id) from HrmJobActivities where jobgroupid = "+id;
rs.executeSql(sql);
rs.next();	
if(rs.getInt(1)>0){
	canDel = false;
}
%>
<script type="text/javascript">
	var decoded = $("<div/>").html("<%= navName %>").text();
	parent.setTabObjName(decoded);
	//parent.setTabObjName("<%= navName %>");
</script>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:onBtnSearchClick(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

if(HrmUserVarify.checkUserRight("HrmJobGroupsAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelNames("82,805",user.getLanguage())+",javaScript:openDialog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javaScript:openDialog("+id+");,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(canDel){ 
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:doDel("+id+");,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmJobGroups:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javaScript:onLog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(1915,user.getLanguage())+",/hrm/jobactivities/HrmJobActivities.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;*/
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="searchfrm" name="searchfrm" method="post" action="HrmJobGroups.jsp">
<input id="jobgroup" name="jobgroup" type="hidden" value="<%=id %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmJobActivitiesAdd:Add", user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelNames("82,805",user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="openDialog('<%=id %>');" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"></input>
				<%if(canDel){ %>
				<input type=button class="e8_btn_top" onclick="doDel('<%=id %>')" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
				<%} %>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<%
rs.executeProc("HrmJobGroups_SelectById",id);
String jobgroupname = "";	
String jobgroupremark = "";
if(rs.next()){	
	jobgroupname = Util.toScreenToEdit(rs.getString("jobgroupname"),user.getLanguage());	
	jobgroupremark = Util.toScreenToEdit(rs.getString("jobgroupremark"),user.getLanguage());
}
%>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>'>
  	<wea:item><%=SystemEnv.getHtmlLabelNames("399",user.getLanguage())%></wea:item>
    <wea:item><%=jobgroupname%></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelNames("15767",user.getLanguage())%></wea:item>
    <wea:item><%=jobgroupremark%></wea:item>
	</wea:group>
</wea:layout>
</BODY></HTML>
