<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
//直接点击超链接页面
String id=Util.null2String(request.getParameter("id"));
rs.execute("select * from FullSearch_Robot where state=0 and id="+id);
if(rs.next()){
	if(!"".equals(rs.getString("url"))){
		response.sendRedirect(rs.getString("url"));
		return;
	}
	out.print(SystemEnv.getHtmlLabelName(83417,user.getLanguage()));
	return;
}else{
	out.print(SystemEnv.getHtmlLabelName(83418,user.getLanguage()));
}
%>
