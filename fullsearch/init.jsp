<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="ln.LN"%>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.systeminfo.setting.*" %>

<%
// 增加参数判断缓存
int isIncludeToptitle = 0;
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%

//
User user = HrmUserVarify.getUser (request , response) ;

if(user == null)  return ;

//licence信息
String companyNametools="";
LN Licenseinit_1 = new LN();
Licenseinit_1.CkHrmnum();
companyNametools = Licenseinit_1.getCompanyname();

%>



