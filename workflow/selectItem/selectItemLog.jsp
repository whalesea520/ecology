<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SelectItemManager" class="weaver.workflow.selectItem.SelectItemManager" scope="page" />
<%
if (!HrmUserVarify.checkUserRight("WORKFLOWPUBLICCHOICE:VIEW", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
	int objid = Util.getIntValue(request.getParameter("id"),0);
	String logmodule = Util.null2String(request.getParameter("logmodule"));
	String startdate = Util.null2String(request.getParameter("startdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	String operator = Util.null2String(request.getParameter("operator"));
	String logtype = Util.null2String(request.getParameter("logtype"));
	String selectname = Util.null2String(request.getParameter("selectname"));
    
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />

</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(83,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body style="">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClick(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<form name="frmSearch" method="post" id="frmSearch" action="selectItemLog.jsp">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">				
				<input type="hidden" name="id" id="id" value="<%=objid %>" />
				<input type="text" class="searchInput" name="flowTitle" value="<%=selectname %>" />
				<input type="hidden" name="selectname" id="selectname" class=Inputstyle value='<%=selectname %>'>
				&nbsp;&nbsp;&nbsp;
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>		
	<!-- bpf start 2013-10-29 -->
	<div class="advancedSearchDiv" id="advancedSearchDiv">
		<wea:layout type="fourCol">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
		        <wea:item><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%><!-- 操作人 --></wea:item>
			    <wea:item>
			    <brow:browser viewType="0" name="operator" browserValue='<%= ""+operator %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="1"
					completeUrl="/data.jsp" linkUrl="javascript:void($id$)"  width="178px"
					browserDialogWidth="700px"
					browserSpanValue='<%=ResourceComInfo.getResourcename(""+operator)%>'
					></brow:browser>
			    </wea:item>
		    
		    	<wea:item><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%><!-- 操作时间 --></wea:item>
			    <wea:item>
			   
				<button type="button" class="calendar" id="SelectDate" onclick="getDate(startdatespan,startdate)"></button>&nbsp;
			 	<span id="startdatespan"><%=startdate %></span>
			  	-&nbsp;&nbsp;<button type="button" class="calendar" id="SelectDate2" onclick="getDate(enddatespan,enddate)"></button>&nbsp;
			  	<span id="enddatespan"><%=enddate %></span>
			  	</span>
			  	<input type="hidden" name="startdate" value="<%=startdate %>">
			  	<input type="hidden" name="enddate" value="<%=enddate %>">
				
			    </wea:item>
			    
			    <wea:item><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%><!-- 操作类型 --></wea:item>
			    <wea:item>
			    <select style="width: 100px;" id="logtype" name="logtype">
					<option value=""></option>
					<option <%if(logtype.equals("ADD")){%>selected="selected"<%} %> value="ADD"><%=SelectItemManager.getLogType("ADD",""+user.getLanguage()) %></option>
					<option <%if(logtype.equals("EDIT")){%>selected="selected"<%} %> value="EDIT"><%=SelectItemManager.getLogType("EDIT",""+user.getLanguage()) %></option>
					<option <%if(logtype.equals("DELETE")){%>selected="selected"<%} %> value="DELETE"><%=SelectItemManager.getLogType("DELETE",""+user.getLanguage()) %></option>
				</select>
			    </wea:item>
		    </wea:group>
		    <wea:group context="">
		    	<wea:item type="toolbar">
		    		<input class="e8_btn_submit" type="submit" name="submit2" value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/>
		    		<input class="e8_btn_cancel" type="button"  name="reset"  onclick="resetCondtion()" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"/>
		    		<input class="e8_btn_cancel" type="button" id="cancel" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/>
		    	</wea:item>
		    </wea:group>
		</wea:layout>
	</div>
</form>		
<%
int pageSize = 10;

String SqlWhere = " where a.logmodule='SELECTITEM'" ;

if(objid>0){
   SqlWhere += " and a.objid='"+objid+"' ";
}

if(!startdate.isEmpty()){
	SqlWhere += " and optdatetime >= '"+startdate+" 00:00'";
}
if(!enddate.isEmpty()){
	SqlWhere += " and optdatetime <= '"+enddate+" 23:59'";
}
if(!operator.isEmpty()){
	SqlWhere += " and operator = '"+operator+"'";
}
if(!logtype.isEmpty()){
	SqlWhere += " and logtype = '"+logtype+"'";
}

if(!selectname.isEmpty()){
	SqlWhere += " and selectname like '%"+selectname+"%'";
}

String backFields = " a.id,a.objid,a.operatorname,a.logtype,a.optdatetime,a.selectname,a.ipaddress,'"+SystemEnv.getHtmlLabelName(124930,user.getLanguage())+"' as proj ";
String sqlFrom = " from selectItemLog a ";

//out.println("select "+backFields+" "+sqlFrom+" "+SqlWhere);

String tableString=""+
	"<table  pagesize=\""+pageSize+"\" tabletype=\"none\" >"+
		"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
			"<head>"+           //操作人    
				"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17482,user.getLanguage())+"\" column=\"operatorname\" orderkey=\"operatorname\"  />"+
				"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(21663,user.getLanguage())+"\" column=\"optdatetime\" orderkey=\"optdatetime\" />"+
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15503,user.getLanguage())+"\" column=\"logtype\" orderkey=\"logtype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.selectItem.SelectItemManager.getLogType\"/>"+
				"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(101,user.getLanguage())+"\" column=\"proj\"  />"+
				"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage())+"\" column=\"selectname\" orderkey=\"selectname\"  />"+
				"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(124985,user.getLanguage())+"\" column=\"ipaddress\"  />"+
			"</head>"+
	"</table>";
%>

<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />	
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
</wea:layout>
</div>

</BODY>

<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}

	function btn_cancle(){
		dialog.closeByHand();
	}
</script>

<script type="text/javascript">
var diag_vote;
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();		
});

function onBtnSearchClick(){
	var flowTitle=$("input[name='flowTitle']",parent.document).val();
	$("input[name='selectname']").val(flowTitle);
	$("#frmSearch").submit();
}

function onReset() {
	resetCondtion();
	try{
		jQuery("#logtype").val("");
	}catch(e){
	}
}


</script>

		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
