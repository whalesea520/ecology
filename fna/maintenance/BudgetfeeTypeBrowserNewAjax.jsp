<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
StringBuffer result = new StringBuffer();

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	
}else{
	int userId = user.getUID();

	String opType = Util.null2String(request.getParameter("opType"));

	if("used".equals(opType)){
		int subjectId = Util.getIntValue(request.getParameter("subjectId"),0);
	
		String sql1 = "delete from FnaBudgetfeeTypeUsed where subjectId = "+subjectId+" and userId = "+userId;
		rs1.executeSql(sql1);

		int idx = 0;
		sql1 = "select * from FnaBudgetfeeTypeUsed where userId = "+userId+" order by orderId desc";
		rs1.executeSql(sql1);
		while(rs1.next()){
			int orderId = rs1.getInt("orderId");
			idx++;
			if(idx >= 20){
				String sql2 = "delete from FnaBudgetfeeTypeUsed where orderId <= "+orderId+" and userId = "+userId;
				rs2.executeSql(sql2);
				break;
			}
		}

		int orderId = 0;
		sql1 = "select max(orderId) maxOrderId from FnaBudgetfeeTypeUsed where userId = "+userId+"";
		rs1.executeSql(sql1);
		while(rs1.next()){
			orderId = rs1.getInt("maxOrderId");
		}
		orderId++;

		sql1 = "insert into FnaBudgetfeeTypeUsed (userId, subjectId, orderId) values ("+userId+", "+subjectId+", "+orderId+")";
		rs1.executeSql(sql1);

		idx = 0;
		sql1 = "select * from FnaBudgetfeeTypeUsed where userId = "+userId+" order by orderId asc";
		rs1.executeSql(sql1);
		while(rs1.next()){
			int _subjectId = rs1.getInt("subjectId");
			
			String sql2 = "update FnaBudgetfeeTypeUsed set orderId = "+idx+" where subjectId = "+_subjectId+" and userId = "+userId;
			rs2.executeSql(sql2);
			
			idx++;
		}
		
		
	}else if("tab".equals(opType)){//显示科目树
		int bwTabId = Util.getIntValue(request.getParameter("bwTabId"),0);
	
		String sql1 = "delete from FnaBudgetfeeTypeBwTab where userId = "+userId;
		rs1.executeSql(sql1);
		
		sql1 = "insert into FnaBudgetfeeTypeBwTab (userId, bwTabId) values ("+userId+", "+bwTabId+")";
		rs1.executeSql(sql1);
		
	}

}
%>