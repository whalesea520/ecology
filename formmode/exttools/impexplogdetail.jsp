<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.formmode.exttools.impexp.common.StringUtils"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
	String logid = StringUtils.null2String(request.getParameter("logid"));
	String loglevel = StringUtils.null2String(request.getParameter("loglevel"));
%>
<html>
  <head>
  	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<SCRIPT type="text/javascript" src="/formmode/js/WdatePicker/WdatePicker_wev8.js"></script>
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
	<style>
	td.e8_tblForm_label{
		vertical-align: middle !important;
	}
	</style>
  </head>
  
  <body>
  	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_top} " ;//搜索
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82176,user.getLanguage())+",javascript:doClear(),_top} " ;//清空条件
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
    <form name="frmSearch" method="post" action="/formmode/exttools/impexplogdetail.jsp">
    <input type="hidden" name="logid" value="<%=logid %>">
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
		<td class="e8_tblForm_label" ><%=SystemEnv.getHtmlLabelName(31702,user.getLanguage())%><!-- 日志类型 --></td>
		<td class="e8_tblForm_field">
			<select style="width: 100px;" id="loglevel" name="loglevel">
				<option></option>
				<option <%if("0".equals(loglevel)){%>selected="selected"<%} %> value="0">提示</option>
				<!-- <option <%if("1".equals(loglevel)){%>selected="selected"<%} %> value="1">警告</option> -->
				<option <%if("2".equals(loglevel)){%>selected="selected"<%} %> value="2">错误</option>
			</select>
		</td>
	</tr>
	</table>
	</form>
	<%
	String perpage = "20";
	String backFields = "a.id,a.tablename,a.logtype,a.message";
	String sqlFrom = " from mode_impexp_logdetail a ";
	String SqlWhere = " where logid='"+logid+"' ";
	if(!"".equals(loglevel)){
		SqlWhere += " and logtype='"+loglevel+"' ";
	}
	SqlWhere += " and logtype<>1";
	String tableString = ""+
		"<table  pagesize=\""+perpage+"\" tabletype=\"none\" >"+
			"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
				"<head>"+           
					//相关表名    
					"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelNames("522,21900",user.getLanguage())+"\" column=\"tablename\" orderkey=\"tablename\"  />"+
					//日志信息
					"<col width=\"60%\"  text=\""+SystemEnv.getHtmlLabelName(32940,user.getLanguage())+"\" column=\"message\" />"+
					//日志级别
					"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelNames("83,139",user.getLanguage())+"\" column=\"logtype\" orderkey=\"logtype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.exttools.impexp.log.LogTransferService.getLogLevel\"/>"+
				"</head>"+
		"</table>";
	%>
	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
  </body>
</html>
<script>
function doClear(){
	$(".sbSelector").html('');
	$("#loglevel").val('');
}

function doSubmit(){
    enableAllmenu();
    document.frmSearch.submit();
}
</script>