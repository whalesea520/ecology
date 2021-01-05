<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.report.FnaReport"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<head>
	</head>
<%

String id = Util.null2String(request.getParameter("id")).trim();

String guid1 = "";
String rptTypeName = "";
String qryConds = "";
rs.executeSql("select guid1, rptTypeName, qryConds from fnaTmpTbLog where id = "+id);
if(rs.next()){
	guid1 = Util.null2String(rs.getString("guid1")).trim();
	rptTypeName = Util.null2String(rs.getString("rptTypeName")).trim();
	qryConds = Util.null2String(rs.getString("qryConds")).trim();
}

boolean canview = FnaReport.checkUserRight(rptTypeName, user) ;
if(!canview) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}

StringBuffer iptStr = new StringBuffer();

if(!"".equals(qryConds)){
	String[] qryCondsArray = qryConds.split("&");
	for (int i = 0; i < qryCondsArray.length; i++) {
		String[] param = qryCondsArray[i].split("=");
		String paramName = "";
		String paramVal = "";
		if(param.length >= 1){
			paramName = param[0];
		}
		if(param.length >= 2){
			paramVal = param[1];
		}
		iptStr.append("<input id=\""+paramName+"\" name=\""+paramName+"\" value=\""+FnaCommon.escapeHtml(FnaCommon.decodeURL(paramVal))+"\" type=\"hidden\" /><br />");
	}
}

String action = FnaReport.getActionUrlByRptTypeName(rptTypeName);
%>
<BODY>
<%=SystemEnv.getHtmlLabelName(127955,user.getLanguage()) %>
<form id="form2" name="form2" method="post"  action="<%=action %>">
	<input id="_guid1" name="_guid1" value="<%=guid1 %>" type="hidden" /><br />
	<input id="qryFunctionType" name="qryFunctionType" value="1" type="hidden" /><br />
	<%=iptStr.toString() %>
</form>
<script type="text/javascript">
jQuery(document).ready(function(){
	try{
		parent.jQuery("#tabTop2").removeClass("current");
	}catch(e1){}
	try{
		parent.jQuery("#tabTop1").addClass("current");
	}catch(e1){}
	form2.submit();
});
</script>
</BODY>
</HTML>