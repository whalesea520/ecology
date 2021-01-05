<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";


int id = Util.getIntValue(request.getParameter("id"));
String operateType = Util.null2String(request.getParameter("operateType"));

rs.executeSql("SELECT modifyStatus FROM HrmPerformanceGoal WHERE id="+id+"");
if(rs.next()){
	if(operateType.equals("1")){
		//Åú×¼====================================================================================
		if(rs.getString("modifyStatus").equals("1")){//Ìí¼Ó
			rs2.executeSql("UPDATE HrmPerformanceGoal SET status='3',modifyStatus='' WHERE id="+id+"");
		}else if(rs.getString("modifyStatus").equals("2")){//±à¼­
			rs2.executeSql("UPDATE HrmPerformanceGoal SET modifyStatus='' WHERE id="+id+"");
			rs2.executeSql("DELETE FROM HrmKPIRevisionLog WHERE id="+id+"");
		}else if(rs.getString("modifyStatus").equals("3")){//É¾³ý
			rs2.executeSql("DELETE FROM HrmPerformanceGoal WHERE id="+id+"");
		}
	}else{
		//ÍË»Ø====================================================================================
		if(rs.getString("modifyStatus").equals("1")){//Ìí¼Ó
			rs2.executeSql("DELETE FROM HrmPerformanceGoal WHERE id="+id+"");
		}else if(rs.getString("modifyStatus").equals("2")){//±à¼­
			rs2.executeSql("UPDATE HrmPerformanceGoal SET modifyStatus='' WHERE id="+id+"");
			rs2.executeSql("SELECT * FROM HrmKPIRevisionLog WHERE id="+id+"");
			if(rs2.next()){
				rs3.executeSql("UPDATE HrmPerformanceGoal SET goalName='"+rs2.getString("goalName")+"', goalCode='"+rs2.getString("goalCode")+"', parentId="+rs2.getInt("parentId")+", goalDate='"+rs2.getString("goalDate")+"', type_t="+rs2.getInt("type_t")+", startDate='"+rs2.getString("startDate")+"', endDate='"+rs2.getString("endDate")+"', cycle='"+rs2.getString("cycle")+"', property='"+rs2.getString("property")+"', unit='"+rs2.getString("unit")+"', targetValue="+rs2.getString("targetValue")+", previewValue="+rs2.getString("previewValue")+", memo='"+rs2.getString("memo")+"', percent_n='"+rs2.getString("percent_n")+"' WHERE id="+id+"");
			}
			rs2.executeSql("DELETE FROM HrmKPIRevisionLog WHERE id="+id+"");
		}else if(rs.getString("modifyStatus").equals("3")){//É¾³ý
			rs2.executeSql("UPDATE HrmPerformanceGoal SET modifyStatus='' WHERE id="+id+"");
		}
	}
}

response.sendRedirect("myGoalListIframe.jsp");
%>