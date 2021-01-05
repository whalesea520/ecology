<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="HrmKqSystemComInfo" class="weaver.hrm.schedule.HrmKqSystemComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
    
char separator = Util.getSeparator() ; 

String tosomeone = Util.null2String(request.getParameter("tosomeone")) ; //收件人地址
String timeinterval = Util.null2String(request.getParameter("timeinterval")) ;  //数据采集时间间隔(分钟)
String getdatatype = Util.null2String(request.getParameter("getdatatype")) ; //数据采集方式
String getdatavalue = Util.null2String(request.getParameter("getdatavalue"+getdatatype)) ; //各个方式的值
String avgworkhour = Util.null2String(request.getParameter("avgworkhour")) ; //平均每月工作时间(小时)
String salaryenddate = Util.null2String(request.getParameter("salaryenddate")) ; //薪资计算截至日期(包含当天，号)
String signIpScope = Util.null2String(request.getParameter("signIpScope")) ;//签到签退ip

String para = tosomeone + separator + timeinterval + separator + getdatatype + separator + getdatavalue + separator + avgworkhour + separator + salaryenddate + separator + signIpScope ; 


RecordSet.executeProc("HrmkqSystemSet_Update" , para) ; 
RecordSet.next() ; 
HrmKqSystemComInfo.removeSystemCache() ; //

%>
<script>
    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16746,user.getLanguage())%>");	
    window.location = "HrmkqSystemSetEdit.jsp";
</script>