<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	out.clear();
	String method = Util.null2String(request.getParameter("method"));
	if("checklayoutname".equals(method)){
		String modeid = Util.null2String(request.getParameter("modeid"));
		String formid = Util.null2String(request.getParameter("formid"));
		String layoutid = Util.null2String(request.getParameter("layoutid"));
		String layouttype = Util.null2String(request.getParameter("layouttype"));
		String layoutname = Util.null2String(request.getParameter("layoutname"));
		String sql = "select 1 from modehtmllayout where modeid="+modeid+" and formid="+formid
					+" and type="+layouttype+" and layoutname = '"+layoutname+"' and id<>"+layoutid;
		rs.executeSql(sql);
		int layoutCount = rs.getCounts();
		if(layoutCount==0){
			out.print("{\"result\":1}");
		}else{
			out.print("{\"result\":0}");
		}
	}
%>