
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(357,user.getLanguage());
String needfav ="1";
String needhelp ="";
String jobgroup = Util.null2String(request.getParameter("jobgroup"));
String jobactivite = Util.null2String(request.getParameter("jobactivite"));
String jobactivityname = Util.null2String(request.getParameter("jobactivityname"));
String jobactivitymark = Util.null2String(request.getParameter("jobactivitymark"));

String qname = Util.null2String(request.getParameter("flowTitle"));

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
						_table.reLoad();
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
	if(dialog == null){
		dialog = new window.top.Dialog();
	}
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
	url+= "&jobgroupid=<%=jobgroup%>";
	dialog.Width = 500;
	dialog.Height = 259;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function openDialogJobGroup(id){
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
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=25 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=25")%>";
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
<script type="text/javascript">
	<%if(jobgroup.length()>0){%>
	parent.setTabObjName("<%=JobGroupsComInfo.getJobGroupsname(jobgroup)%>");
	<%}%>
</script>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmJobActivitiesAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelNames("82,1915",user.getLanguage())+",javascript:openDialog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelNames("32136",user.getLanguage())+",javascript:doDel();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("HrmJobActivities:Log", user)){
  RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<input name="jobgroup" type="hidden" value="<%=jobgroup %>" >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmJobActivitiesAdd:Add", user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialogJobGroup();" value="<%=SystemEnv.getHtmlLabelNames("82,805",user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelNames("82,1915",user.getLanguage())%>"></input>
			<%}if(HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Delete", user)){ %>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<%} %>	
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage()) + SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
			<wea:item><input type="text" id="jobactivitymark" name="jobactivitymark" class="inputStyle" value='<%=jobactivitymark%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage()) + SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
			<wea:item><input type="text" id="jobactivityname" name="jobactivityname" class="inputStyle" value=<%=jobactivityname%>></wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</form>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<%
String backfields = " a.id, a.jobactivitymark, a.jobactivityname, a.jobgroupid, b.jobgroupname "; 
String fromSql  = " from HrmJobActivities a, HrmJobGroups b ";
String sqlWhere = " where a.jobgroupid = b.id ";
String orderby = " a.jobgroupid " ;
String tableString = "";

if(!qname.equals("")){
	sqlWhere += " and jobactivitymark like '%"+qname+"%'";
}		

if (!"".equals(jobgroup)) {
	sqlWhere += " and jobgroupid = "+jobgroup;
	}  	  	

if(jobactivite.length()>0){
	sqlWhere += " and a.id = "+jobactivite;
}

if (!"".equals(jobactivitymark)) {  
	sqlWhere += " and jobactivitymark like '%"+jobactivitymark+"%'"; 	  	
}

if (!"".equals(jobactivityname)) {  
	sqlWhere += " and jobactivityname like '%"+jobactivityname+"%'"; 	  	
}

//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom transmethod=\"weaver.hrm.job.JobActivitiesComInfo.getJobActivityOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Edit", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Delete", user)+":"+HrmUserVarify.checkUserRight("HrmJobActivities:log", user)+":"+HrmUserVarify.checkUserRight("HrmJobActivitiesAdd:Add", user)+"\"></popedom> ";
 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
 	       operateString+="</operates>";	
 String tabletype="checkbox";
 if(HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Delete", user)){
 	tabletype = "checkbox";
 }
 
tableString =" <table pageId=\""+PageIdConst.HRM_JobActivities+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_JobActivities,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.job.JobActivitiesComInfo.getJobActivityCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelNames("1915,399",user.getLanguage())+"\" column=\"jobactivitymark\" orderkey=\"jobactivitymark\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmOpenDialogName\" otherpara=\"column:id\"/>"+
    "				<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelNames("1915,15767",user.getLanguage())+"\" column=\"jobactivityname\" orderkey=\"jobactivitymark\"/>"+
    "				<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(805,user.getLanguage())+"\" column=\"jobgroupname\" orderkey=\"jobgroupname\"/>"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_JobActivities %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 
</BODY></HTML>
