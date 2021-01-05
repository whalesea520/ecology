<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import=" weaver.hrm.resource.ResourceComInfo" %>
<%@page import="weaver.systeminfo.SystemEnv"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<%

DecimalFormat df = new DecimalFormat("#################################################0.00");
ResourceComInfo resourceComInfo = new ResourceComInfo();
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
int requestid = Util.getIntValue(request.getParameter("requestid"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int detailRecordId = Util.getIntValue(request.getParameter("detailRecordId"));
%>
<HTML><HEAD>
<style type="text/css">
	.searchText {
		width:100%;
		height:20px;
		margin-left:auto;
		margin-right:auto;
		border: 1px solid #687D97; 
		background:#fff;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px; 
		border-radius:5px;
		-webkit-box-shadow: inset 0px 5px 3px 0px #BCBFC3;
		-moz-box-shadow: inset 0px 5px 3px 0px #BCBFC3;
		box-shadow: inset 0px 5px 3px 0px #BCBFC3;
	}
	
	.operationBt {
			height:26px;
			margin-left:18px;
			line-height:26px;
			font-size:14px;
			color:#fff;
			text-align:center;
			-moz-border-radius: 5px;
			-webkit-border-radius: 5px; 
			border-radius:5px;
			border:1px solid #0084CB;
			background:#0084CB;
			background: -moz-linear-gradient(0, #30B0F5, #0084CB);
			background:-webkit-gradient(linear, 0 0, 0 100%, from(#30B0F5), to(#0084CB));
			overflow:hidden;
			float:left;
	}
	.width50 {
		width:50px;
	}
	
	.blockHead {
		width:100%;
		height:24px;
		line-height:24px;
		font-size:12px;
		font-weight:bold;
		color:#fff;
		border-top:1px solid #0084CB;
		border-left:1px solid #0084CB;
		border-right:1px solid #0084CB;
		-moz-border-top-left-radius: 5px;
		-moz-border-top-right-radius: 5px;
		-webkit-border-top-left-radius: 5px; 
		-webkit-border-top-right-radius: 5px; 
		border-top-left-radius:5px;
		border-top-left-radius:5px;
		background:#0084CB;
		background: -moz-linear-gradient(0, #31B1F6, #0084CB);
		background:-webkit-gradient(linear, 0 0, 0 100%, from(#31B1F6), to(#0084CB));
	}
	
	.m-l-14 {
		margin-left:14px;
	}
	
	
	.tblBlock {
		width:100%;
		border-left:1px solid #C5CACE;
		border-right:1px solid #C5CACE;
		border-bottom:1px solid #C5CACE;
		background:#fff;
		-moz-border-bottom-left-radius: 5px;
		-moz-border-bottom-right-radius: 5px;
		-webkit-border-bottom-left-radius: 5px; 
		-webkit-border-bottom-right-radius: 5px; 
		border-bottom-left-radius:5px;
		border-bottom-left-radius:5px;
	}
	
	#asyncbox_alert_content {
		height:auto!important;
		min-height:10px!important;
	}
	
	#asyncbox_alert{
		min-width: 220px!important;
		max-width: 280px!important;
	}
	</style>

</head>
<BODY style="overflow:hidden;">
<Table style="margin-top:5px;padding:0;table-layout:fixed;border:1px solid #D8DDE4;" width="100%">
 <COLGROUP> 
 	<COL width="25%"> 
 	<COL width="25%">
 	<COL width="25%">
 	<COL width="25%">
 	</COLGROUP>
    <TBODY> 
    <tr>
    	<td><%=SystemEnv.getHtmlLabelName(15823,user.getLanguage())%></td>
    	<td><%=SystemEnv.getHtmlLabelName(83278,user.getLanguage())%></td>
    	<td><%=SystemEnv.getHtmlLabelName(18254,user.getLanguage())%></td>
    	<td><%=SystemEnv.getHtmlLabelName(83241,user.getLanguage())%></td>
    </tr>
<%
	String sql = "select createUid, amountAdvanceAfter, createDate, memo1" +
					"	from FnaAdvanceInfoAmountLog a " +
					"	where a.requestid = "+requestid+" and a.dtlid = "+detailRecordId +
					"	order by a.id desc ";
 	rs.executeSql(sql);
 	while(rs.next()){
 		int createUid = rs.getInt("createUid");
 		String createUname = resourceComInfo.getLastname(createUid+"");
 		String amountAdvanceAfter = Util.null2String(rs.getString("amountAdvanceAfter"));
 		String createDate = Util.null2String(rs.getString("createDate"));
 		String memo1 = Util.null2String(rs.getString("memo1"));
 		
 		out.println("<tr  style='padding-bottom:6px;padding-top:6px;background-color:#EFF2F6;border-bottom:1px solid #D8DDE4;'>");
 		out.println("	<td>");
 		out.println(		createUname);
 		out.println("	</td>");
 		out.println("	<td>");
 		out.println(		amountAdvanceAfter);
 		out.println("	</td>");
 		out.println("	<td>");
 		out.println(		createDate);
 		out.println("	</td>");
		out.println("	<td>");
		out.println(		memo1);
 		out.println("	</td>");
 		out.println("</tr>");
 	}
%>
</TBODY>
</Table>

</BODY>
</HTML>