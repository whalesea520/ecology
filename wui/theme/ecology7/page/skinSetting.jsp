
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util,java.sql.Timestamp"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfigHandler"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfig"%>
<%@ page import="weaver.systeminfo.menuconfig.MenuMaint"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.util.ArrayList,java.lang.reflect.Method" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="weaver.systeminfo.setting.*" %>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
  response.sendRedirect("/wui/theme/ecology7/page/login.jsp");
  return;
}

weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
weaver.conn.RecordSet rs2 = new weaver.conn.RecordSet();

String skin = Util.null2String(request.getParameter("skin"));
String theme = Util.null2String(request.getParameter("theme"));

int userid = user.getUID();

rs.executeSql("select theme, skin from HrmUserSetting where resourceId=" + userid);
if(rs.next()){
	rs2.executeSql("update HrmUserSetting set theme='" + theme + "', skin='" + skin + "' where resourceId=" + userid);
} else {
	rs2.executeSql("insert into HrmUserSetting(theme, skin, resourceId) values ('" + theme + "', '" + skin + "', '" + userid + "')");
}
session.setAttribute("SESSION_CURRENT_THEME", theme);
session.setAttribute("SESSION_CURRENT_SKIN", skin);
session.setAttribute("fromlogin","yes");
response.sendRedirect("/wui/main.jsp");
%>
