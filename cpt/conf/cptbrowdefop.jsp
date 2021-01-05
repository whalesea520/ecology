<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
if(!HrmUserVarify.checkUserRight("CptMaint:CptBrowDef", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

int rownum = Util.getIntValue(request.getParameter("rownum"),0);


String sql = "";
for(int i=0;i<rownum;i++){
	String fieldname = Util.null2String(request.getParameter("fieldname_"+i));
	int istitle = Util.getIntValue(request.getParameter("istitle_"+i),0);
	int isconditions = Util.getIntValue(request.getParameter("isconditions_"+i),0);
	String displayorder = Util.getIntValue(request.getParameter("displayorder_"+i),0) + "";					
	sql = "update cpt_browdef set iscondition="+isconditions+",istitle="+istitle+",displayorder="+displayorder+" where fieldid="+fieldname;	
	//System.out.println("sql:"+sql);
	rs.executeSql(sql);
}

response.sendRedirect("/cpt/conf/cptbrowdef.jsp");

%>