<%@page import="weaver.hrm.User"%><%@ page language="java" contentType="text/html; charset=UTF-8"%><%@ page import="weaver.general.*"%>
<%@ page import="java.util.*" %><%@ page import="java.net.*" %><%@page import="weaver.hrm.HrmUserVarify"%><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" /><%
User user = HrmUserVarify.getUser (request , response) ;
boolean canEdit = HrmUserVarify.checkUserRight("FnaLedgerAdd:Add",user) || HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit",user);
if(!canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String checkid = Util.null2String(request.getParameter("checkid")).trim();
String jsonStr = "{\"result1\":1}";
if(!"".equals(checkid)){
	String[] checkidArray = Util.splitString(checkid, ",");
	if(checkidArray!=null && checkidArray.length>0){
		for(int i=0;i<checkidArray.length;i++){
			int id = Util.getIntValue(checkidArray[i]);
			if(id > 0){
				String sql = "select count(*) cnt from fnabudgetfeetype where supsubject="+id;
				rs.executeSql(sql);
				if(rs.next() && rs.getInt("cnt")>0){
					jsonStr = "{\"result1\":2}";
					break;
				}
			}
		}
	}
}
%>
<%=jsonStr %>