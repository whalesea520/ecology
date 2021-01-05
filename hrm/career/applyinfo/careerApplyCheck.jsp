<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
out.clear();
int ishas =0;
String temName = Util.null2String(request.getParameter("lastname"));
String cmd = Util.null2String(request.getParameter("cmd"));

String id = Util.null2String(request.getParameter("id"));

try{
	if(cmd.equals("add")){
		String tempSql = "";
		if(!temName.equals("")){
		    tempSql = "select lastname from HrmCareerApply where lastname='"+temName+"'";
		    rs.executeSql(tempSql);
		    if(rs.next()){
		    	ishas++;
		    }
		}
	}else{
		String tempSql = "";
		if(!temName.equals("")){
		    tempSql = "select lastname from HrmCareerApply where lastname='"+temName+"' and id <>"+id+" ";
		    rs.executeSql(tempSql);
		    if(rs.next()){
		    	ishas++;
		    }
		}
	}
}catch(Exception e){
	e.printStackTrace();
}
//System.out.println(ishas);
out.print(ishas);
%>
