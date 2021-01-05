<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.rdeploy.portal.PortalUtil"%>

<%
		/*用户验证*/
		User user = HrmUserVarify.getUser (request , response) ;
		if(user==null) {
		    response.sendRedirect("/login/Login.jsp");
		    return;
		}
		//门户编辑权限验证
		if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		    response.sendRedirect("/notice/noright.jsp");
		    return;
		}
		String infoid = Util.null2String(request.getParameter("infoid"));
		int isuse = Util.getIntValue(Util.null2String(request.getParameter("isuse")), 0);
		RecordSet rs = new RecordSet();
		rs.executeSql("update hpinfo set isuse='" + isuse + "' where id=" + infoid);
		//System.out.println("update hpinfo set isuse='" + isuse + "' where id=" + infoid);
		boolean isdel = PortalUtil.isdelhp(infoid);
		//System.out.println(isdel ? "1" : "0");
		response.getWriter().write(isdel ? "1" : "0");
%>  
