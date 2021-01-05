
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.setting.*" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.GCONST"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String css = Util.null2String(request.getParameter("css"));
	String cssid = Util.null2String(request.getParameter("cssid"));
	String from = Util.null2String(request.getParameter("from"));
	if("theme".equals(from)){
		
		rs.execute("select * from ecology8theme where id="+cssid);
		if(rs.next()){
			String lastdate = rs.getString("lastdate");
			/*if("2014-10-16".equals(lastdate)){
				session.setAttribute("ColorStyleInfo",css);
				rs.execute("update ColorStyleInfo set style='"+css+"' where userid="+user.getUID());
			}else{*/
				session.setAttribute("ColorStyleInfo","");
				rs.execute("delete from  ColorStyleInfo where userid="+user.getUID());
		//	}
		}
	}else{
		rs.execute("select * from ColorStyleInfo where userid ="+user.getUID());
		if(rs.next()){
			rs.execute("update ColorStyleInfo set style='"+css+"' where userid="+user.getUID());
		}else{
			rs.execute("insert into ColorStyleInfo (userid,style) values("+user.getUID()+",'"+css+"')");
		}
		session.setAttribute("ColorStyleInfo",css);
	}
	
	

	
%>

