
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.formmode.log.LogType"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML>
<HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT type="text/javascript" src="/formmode/js/WdatePicker/WdatePicker_wev8.js"></script>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<style>
td.e8_tblForm_label{
	vertical-align: middle !important;
}
</style>
</HEAD>
<body>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)
			&&!HrmUserVarify.checkUserRight("FORMMODEFORM:ALL", user)
			&&!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String titlename = "";
	
	String objid = Util.null2String(request.getParameter("objid"));
	String logmodule = Util.null2String(request.getParameter("logmodule"));
	String startdate = Util.null2String(request.getParameter("startdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	String operator = Util.null2String(request.getParameter("operator"));
	String logtype = Util.null2String(request.getParameter("logtype"));


%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_top} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(82176,user.getLanguage())+",javascript:doClear(),_top} " ;//清空条件
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="frmSearch" method="post" action="/formmode/setup/log.jsp">
<input type="hidden" name="objid" id="objid" value="<%=objid %>">
<input type="hidden" name="logmodule" id="logmodule" value="<%=logmodule %>">
<table class="e8_tblForm">
<colgroup>
	<col width="8%">
	<col width="18%">
	<col width="8%">
	<col width="18%">
	<col width="8%">
	<col width="26%">
</colgroup>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%><!-- 操作人 --></td>
	<td class="e8_tblForm_field">
		<brow:browser viewType="0" name="operator" browserValue='<%= ""+operator %>' 
			browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="1"
			completeUrl="/data.jsp" linkUrl="javascript:void($id$)"  width="178px"
			browserDialogWidth="700px"
			browserSpanValue='<%=ResourceComInfo.getResourcename(""+operator)%>'
			></brow:browser>
	</td>
	<td class="e8_tblForm_label" ><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%><!-- 操作类型 --></td>
	<td class="e8_tblForm_field">
		<select style="width: 100px;" id="logtype" name="logtype">
			<option></option>
			<%
				LogType[] logTypes = LogType.values();
				for(LogType logType:logTypes){%>
					<option <%if(logtype.equals(logType.name())){%>selected="selected"<%} %> value="<%=logType.name() %>"><%=logType.getDisplayName() %></option>
				<%}
			%>
		</select>
	</td>
	<td class="e8_tblForm_label" ><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%><!-- 操作时间 --></td>
	<td class="e8_tblForm_field">
		<%=SystemEnv.getHtmlLabelName(83838,user.getLanguage())%>
		<button class="calendar" onclick="onSearchWFQTDate(startdate_span,startdate)" type="button"></button>
		<input type="hidden" class="calendar" id="startdate" name="startdate" onclick="WdatePicker()" value="<%=startdate %>"/>
		<span id="startdate_span" name="startdate_span"><%=startdate %></span>
		<%=SystemEnv.getHtmlLabelName(33973,user.getLanguage())%>
		<button class="calendar" onclick="onSearchWFQTDate(enddate_span,enddate)" type="button"></button>
		<input type="hidden" class="calendar" id="enddate" name="enddate" onclick="WdatePicker()" value="<%=enddate %>"/>
		<span id="enddate_span" name="enddate_span"><%=enddate %></span>
	</td>
</tr>
</table>
</form>
<br/>

<%


String SqlWhere = " where a.objid='"+objid+"' and a.logmodule='"+logmodule+"'" ;
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


String perpage = "10";
String backFields = " a.id,a.objid,a.operatorname,a.logtype,a.optdatetime ";
String sqlFrom = " from FormModeLog a ";
String tableString=""+
	"<table  pagesize=\""+perpage+"\" tabletype=\"none\" >"+
		"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
			"<head>"+           //操作人    
				"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(17482,user.getLanguage())+"\" column=\"operatorname\" orderkey=\"operatorname\"  />"+
				//操作类型
				"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(15503,user.getLanguage())+"\" column=\"logtype\" orderkey=\"logtype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.service.LogService.getLogTypeName\"/>"+
				//操作日期
				"<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(21663,user.getLanguage())+"\" column=\"optdatetime\" orderkey=\"optdatetime\" />"+
			"</head>"+
	"</table>";
%>

<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>

<script type="text/javascript">
	$(document).ready(function(){//onload事件
		$(".loading", window.parent.document).hide(); //隐藏加载图片
	})
	
	function doClear(){
		$("#operator").val('');
		$("#operatorspan").html('');
		$("#startdate").val('');
		$("#enddate").val('');
		$("#startdate_span").html('');
		$("#enddate_span").html('');
		$(".sbSelector").html('');
		$("#logtype").val('');
	}

    function doSubmit(){
        enableAllmenu();
        document.frmSearch.submit();
    }
    
    function onShowBrowser(inputName, spanName){
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
    	if (datas){
    	    if(datas.id!=""){
    		    $("#"+inputName).val(datas.id);
    			if ($("#"+inputName).val()==datas.id){
    		    	$("#"+spanName).html(datas.name);
    			}
    	    }else{
    		    $("#"+inputName).val("");
    			$("#"+spanName).html("");
    		}
    	}
    }
    
function onSearchWFQTDate(spanname,inputname){
	var oncleaingFun = function(){
		  $(spanname).innerHTML = '';
		  inputname.value = '';
		}
		WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();
			$dp.$(inputname).value = returnvalue;
		},oncleared:oncleaingFun});
}
</script>

</BODY>
</HTML>
