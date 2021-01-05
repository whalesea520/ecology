<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.general.Util" %>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
// 页面目前不正确.没有涉及到操作者....
// 需统一改正.....
//
int userid = user.getUID();
int usertype = 0;
String logintype = user.getLogintype();	
if(logintype.equals("2"))
	usertype = 1;

String hasnewwf="";
String hasendwf="";
String sql = "select * from SysRemindInfo where userid = "+userid + " and usertype = " + usertype;
RecordSet.executeSql(sql);
if(RecordSet.next()){
	hasnewwf=RecordSet.getString("hasnewwf");
	hasendwf=RecordSet.getString("hasendwf");
	
}
SearchClause.resetClause();
String type = request.getParameter("type");
// 客户联系计划
if(type.equals("1")){
	response.sendRedirect("/CRM/data/CRMContactRemind.jsp");
}


//new newpage 
/*
char flag = Util.getSeparator();
String newscount3="";
RecordSet.executeProc("NewDocFrontpage_SMRecentCount",user.getLogintype()+flag+"-"+user.getType()+flag+userid+flag+user.getSeclevel());
if(RecordSet.next())
newscount3=RecordSet.getString("countnew");
if(type.equals("5")){
    response.sendRedirect("/docs/news/NewsRecDsp.jsp?type=2&newscount="+newscount3);
}
*/

//新的工作流到达:新
else if(type.equals("2.1")){
	String sqlwhere = " t1.requestid in (0," + hasnewwf +") and t2.isremark = '0' and t1.deleted = 0 and t1.currentnodetype<>'3'";//xwj fro td1351 20050516	
	SearchClause.setWhereClause(sqlwhere);
	response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1&perpage=10");	
}
else if(type.equals("2.2")){
	String sqlwhere = " t2.isremark = '0' and t1.deleted = 0 and t1.currentnodetype<>'3' ";	
	SearchClause.setWhereClause(sqlwhere);
	response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1&perpage=10");	
}

//工作流完成(待处理)
else if(type.equals("3.1")){
	String sqlwhere = " t1.requestid in (0," + hasendwf +") ";
	SearchClause.setWhereClause(sqlwhere);
	response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1&perpage=10");	
}
//工作流完成   // sqlwhere is modified by xwj for 2050 on 2005-06-10   WFSearchResult.jsp里有substring()操作, t1.workflowid必须放置最前面
else if(type.equals("3.2")){
	//String sqlwhere = " t1.deleted = 0 and t1.currentnodetype='3' and t1.workflowid <> 1 ";
	  String sqlwhere = " t1.workflowid <> 1 and t1.deleted = 0 and t1.currentnodetype='3' ";
	SearchClause.setWhereClause(sqlwhere);
	response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1&perpage=10");	
}
//系统提醒工作流
else if(type.equals("3.3")){ // sqlwhere is modified by xwj for 2050 on 2005-06-10   WFSearchResult.jsp里有substring()操作, t1.workflowid必须放置最前面
	//String sqlwhere = " t1.deleted = 0 and t1.currentnodetype='3'  and t1.workflowid = 1  ";
	  String sqlwhere = " t1.workflowid = 1  t1.deleted = 0 and t1.currentnodetype='3' ";
	SearchClause.setWhereClause(sqlwhere);
	response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1&perpage=10");	
}
//节点超时
else if(type.equals("4")){
	String sqlwhere = " t1.nodelefttime <=1.0 and t1.nodelefttime >=0.0 ";
	SearchClause.setWhereClause(sqlwhere);
	response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1&perpage=10");	
}


%>

