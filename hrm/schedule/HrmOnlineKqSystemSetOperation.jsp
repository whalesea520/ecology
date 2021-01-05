<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="HrmKqSystemComInfo" class="weaver.hrm.schedule.HrmKqSystemComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
    
int needSign = Util.getIntValue(request.getParameter("needSign"),0) ; //是否启用签到功能
int onlyWorkDay = Util.getIntValue(request.getParameter("onlyworkday"),0);//是在工作日显示
String signTimeScope = Util.null2String(request.getParameter("signTimeScope"));//是在工作日显示
String signIpScope = Util.null2String(request.getParameter("signIpScope")) ; //签到签退ip

String sql = " update HrmKqSystemSet set needSign="+needSign+", onlyworkday="+onlyWorkDay+", " 
					 + " signTimeScope='"+signTimeScope+"', signIpScope='"+signIpScope+"' ";

RecordSet.executeSql(sql);
HrmKqSystemComInfo.removeSystemCache() ; //
%>
<script>
    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16746,user.getLanguage())%>");	
    window.location = "HrmOnlineKqSystemSet.jsp";
</script>