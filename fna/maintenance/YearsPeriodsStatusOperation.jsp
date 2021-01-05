<%@ page import="weaver.fna.budget.FnaYearsPeriodsHelp"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
BaseBean baseBean = new BaseBean();

User user = HrmUserVarify.getUser (request , response) ;

String operation = Util.null2String(request.getParameter("operation")); 
String id = Util.null2String(request.getParameter("id"));
String status = Util.null2String(request.getParameter("status"));
String startDate = Util.null2String(request.getParameter("startDate")) ;
String endDate = Util.null2String(request.getParameter("endDate")) ;

if(operation.equals("editStatus")){
	if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsAdd:Add" , user)) { 
		response.sendRedirect("/notice/noright.jsp");
    	return;
	}
	//先确定状态，关闭直接开
	//开启状态下关闭的话，查流程，有，弹出来，没有关闭
	if("1".equals(status)){
		StringBuffer updateBuffer = new StringBuffer();
		updateBuffer.append(" update fnayearsperiodslist set status = 0 where id = ").append(id);
		
		rs.executeSql(updateBuffer.toString());
		
		out.println("{\"flag\":false,\"erroInfo\":\"\"}");
	}else{//开启切关闭
		
		StringBuffer buffer = new StringBuffer();
	
		buffer.append(" select * from fnaexpenseinfo fe ");
		buffer.append(" where fe.occurdate >= '").append(StringEscapeUtils.escapeSql(startDate)).append("'");	
		buffer.append(" and fe.occurdate <= '").append(StringEscapeUtils.escapeSql(endDate)).append("'");	
		buffer.append(" and fe.status = 0 ");
		
		rs.executeSql(buffer.toString());
		
		if(rs.next()){
			out.println("{\"flag\":true,\"erroInfo\":\"\"}");
		}else{
			StringBuffer updateBuffer = new StringBuffer();
			updateBuffer.append(" update fnayearsperiodslist set status = 1 where id = ").append(id);
			
			rs.executeSql(updateBuffer.toString());
			out.println("{\"flag\":false,\"erroInfo\":\"\"}");
		}
	}
	
}


%>