
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<%
//QC296829 	 [80]集成登录-集成登录账号设置页面优化 -----START
String sysids=Util.null2String(request.getParameter("sysid"));
String sql="select * from outter_sys where 1=1";
if(!"".equals(sysids)){
	sql+=" and sysid='"+sysids+"'";
}
String deleteaccountsql="delete  outter_account where userid="+user.getUID();
if(!"".equals(sysids)){
	deleteaccountsql+=" and sysid='"+sysids+"'";
}
String deleteparamssql="delete  outter_params where userid="+user.getUID();
if(!"".equals(sysids)){
	deleteparamssql+=" and sysid='"+sysids+"'";
}
String operate = Util.fromScreen(request.getParameter("operate"),user.getLanguage());
RecordSet.executeSql(deleteaccountsql);
RecordSet.executeSql(deleteparamssql);
//RecordSet.executeSql("select * from outter_sys");
RecordSet.executeSql(sql);
//QC296829 	 [80]集成登录-集成登录账号设置页面优化 -----END
while(RecordSet.next()){
String sysid= RecordSet.getString("sysid");
String account = Util.fromScreen(request.getParameter("account_999_"+sysid),user.getLanguage());
String password = Util.fromScreen(request.getParameter("password_999_"+sysid),user.getLanguage());
//密码加密存储
if(!password.equals("")){
password= SecurityHelper.encryptSimple(password);
 }

String logintype = Util.fromScreen(request.getParameter("logintype_999_"+sysid),user.getLanguage());
String date = TimeUtil.getCurrentDateString();
String time = TimeUtil.getOnlyCurrentTimeString();
RecordSet1.executeSql("insert into outter_account(sysid,userid,account,password,logintype,createdate,createtime,modifydate,modifytime) values('"+sysid+"',"+user.getUID()+",'"+account+"','"+password+"','"+logintype+"','"+date+"','"+time+"','"+date+"','"+time+"')") ;
RecordSet1.executeSql("select * from outter_sysparam where paramtype=1 and  sysid='"+sysid+"'");
while(RecordSet1.next()){                  
	String paramname=RecordSet1.getString("paramname");
	String paramvalue=Util.fromScreen(request.getParameter(paramname+"_"+sysid),user.getLanguage());
    RecordSet1.executeSql("insert into outter_params(sysid,userid,paramname,paramvalue) values('"+sysid+"',"+user.getUID()+",'"+paramname+"','"+paramvalue+"')") ;
}
}

if(operate.equals("insert")) {
%>
<script>
    alert("<%=SystemEnv.getHtmlLabelName(16746,user.getLanguage())%>");
        window.location = "/interface/AccountSettingFrame.jsp?sysid=<%=sysids%>";  //QC296829 	 [80]集成登录-集成登录账号设置页面优化
</script>
<%}else{
    response.sendRedirect("login.jsp");
}%>

