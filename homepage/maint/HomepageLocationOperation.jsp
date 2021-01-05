
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%

	String data = Util.null2String(request.getParameter("data"));
	int id,pid,ordernum= 0;
	String sql = "";
	try{
		if(null != data){
			String[] list = data.split(";");
			for(String str : list){
				id=Integer.valueOf(str.split(",")[0]);
				pid=Integer.valueOf(str.split(",")[1]);
				ordernum=Integer.valueOf(str.split(",")[2]);
				sql ="update hpinfo set ordernum1 = '" + ordernum + "' , pid = '"+ pid +"' where id =" + id;
				rs.executeSql(sql);
			}
		}
		//response.sendRedirect("HomepageLocation.jsp");
		//return;
		out.println("{\"success\":\"1\"}");
	}catch(Exception e){
		out.println("{\"success\":\"0\"}");
	}
%>