
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.zip.*"%>
<%@ page import="java.io.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="PluginLicense" class="weaver.license.PluginLicenseForInterface" scope="page" />
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<%
String plugintype = Util.null2String(request.getParameter("plugintype"));
if("messager".equals(plugintype)&&HrmUserVarify.checkUserRight("Messages:All", user)){
	plugintype = "messager";
} else if ("mobile".equals(plugintype)&&HrmUserVarify.checkUserRight("Mobile:Setting", user)) {
	plugintype = "mobile";
} else {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

String usr_id[] = request.getParameterValues("usr_id"); 
String usr_sharetype[] = request.getParameterValues("usr_sharetype"); 
String usr_seclevel[] = request.getParameterValues("usr_seclevel");
String usr_sharevalue[] = request.getParameterValues("usr_sharevalue");

int userTotal = Util.getIntValue(Util.null2String(request.getParameter("userTotal")));

try {

String upids = "";
for(int i=0;usr_id!=null&&i<usr_id.length;i++){
	if(Util.getIntValue(usr_id[i],0)==0){
		rs.executeSql(" insert into PluginLicenseUser(plugintype,sharetype,sharevalue,seclevel) values('" + plugintype + "','"+usr_sharetype[i]+"','"+usr_sharevalue[i]+"','"+usr_seclevel[i]+"')");
		String sqltemp = "select max(id) mid from PluginLicenseUser where ";
		if(rs.getDBType().equalsIgnoreCase("oracle")){
			if(!"".equals(plugintype)){
				sqltemp += " plugintype = '" + plugintype + "'";
			}else{
				sqltemp += " plugintype is null ";
			}
		}else{
			sqltemp += "plugintype = '" + plugintype + "'";
		}
		rs.executeSql(sqltemp);
		if(rs.next()) upids += "," + rs.getString("mid");
	}
}
for(int i=0;usr_id!=null&&i<usr_id.length;i++){
	if(Util.getIntValue(usr_id[i],0)>0){
		upids += "," + usr_id[i];
		rs.executeSql(" update PluginLicenseUser set sharetype = '" + usr_sharetype[i] + "',sharevalue = '" + usr_sharevalue[i] + "',seclevel = '" + usr_seclevel[i] + "' where id = " + usr_id[i]);
	}
}

if(userTotal==0) upids="0";

if(upids!=null&&!"".equals(upids)){
	upids = upids.trim().startsWith(",")?upids.trim().substring(1):upids.trim();
	upids = upids.trim().endsWith(",")?upids.trim().substring(0,upids.trim().length()-1):upids.trim();
	if(!"".equals(upids))
	rs.executeSql("delete from PluginLicenseUser where plugintype = '" + plugintype + "' and id not in ("+upids+")");
}

PluginUserCheck.clearPluginUserCache(plugintype);

PluginLicense.resetLicenseState(plugintype);

} catch(Exception e){
	rs.writeLog(e);
}

int licenseState=PluginLicense.getLicenseState(plugintype);
if(licenseState==5){
%>
<script type="text/javascript">
alert('<%=PluginLicense.getErrorMsg(licenseState)%>');
location.href = 'PluginLicenseUser.jsp?plugintype=<%=plugintype%>';
</script>
<%} else {%>
<script type="text/javascript">
alert('<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>');
location.href = 'PluginLicenseUser.jsp?plugintype=<%=plugintype%>';
</script>
<%}%>