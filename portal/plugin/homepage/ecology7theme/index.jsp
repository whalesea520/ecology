
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.User"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%

	int subCompanyId = Util.getIntValue(request.getParameter("userSubcompanyId"));
	int templateId = Util.getIntValue(request.getParameter("templateId"));
	int extendtempletid = Util.getIntValue(request.getParameter("extendtempletid"));
	
	String curTheme = "";
	String curskin = "";
	String sqltemplateid1 = "(select max(id) from extandHpTheme where templateId="+templateId+" and subcompanyid = "+subCompanyId+")";
	if(templateId==1){
		sqltemplateid1 = "(select max(id) from extandHpTheme where templateId=1 and subcompanyid = 1)";
	}
	//优先锁定主题
	rs.executeSql("select theme,skin from extandHpThemeItem where extandHpThemeId="+sqltemplateid1+" and islock=1 and isopen=1");
	if (rs.next()) {
		curTheme = rs.getString("theme");
		curskin = rs.getString("skin");
	}
	//没有锁定主题，优先默认主题
	if("".equals(curTheme)&&"".equals(curskin)){
		rs.executeSql("select theme,skin from extandHpThemeItem where extandHpThemeId="+sqltemplateid1+" and isopen=1");
		while (rs.next()) {
			curTheme = rs.getString("theme");
			curskin = rs.getString("skin");
			if("ecology7".equals(curTheme)&&"default".equals(curskin)){
				break;
			}
		}
	}
	//没有启用主题，显示默认主题
	if("".equals(curTheme)&&"".equals(curskin)){
		curTheme = "ecology7";
		curskin = "default";
	}
	
	session.setAttribute("SESSION_CURRENT_THEME", curTheme);
	session.setAttribute("SESSION_CURRENT_SKIN", curskin);
	response.sendRedirect("/wui/main.jsp?"+request.getQueryString());
%>