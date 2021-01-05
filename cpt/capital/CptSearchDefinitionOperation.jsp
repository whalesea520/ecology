<%@page import="weaver.conn.RecordSetTrans"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
if(!HrmUserVarify.checkUserRight("cptdefinition:all", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

int rownum = Util.getIntValue(request.getParameter("rownum"),0);

RecordSetTrans rs=new RecordSetTrans();
rs.setAutoCommit(false);
try{
	
	String sql = "";
	sql = "delete from CptSearchDefinition where mouldid = -1 and fieldname!='isdata' ";
	rs.executeSql(sql);

	for(int i=0;i<rownum;i++){
		String fieldname = Util.null2String(request.getParameter("fieldname_"+i));
		if("".equals(fieldname)) continue;
		
		int isconditionstitle = Util.getIntValue(request.getParameter("isconditionstitle_"+i),0);
		int istitle = Util.getIntValue(request.getParameter("istitle_"+i),0);
		int isconditions = Util.getIntValue(request.getParameter("isconditions_"+i),0);
		int isseniorconditions = Util.getIntValue(request.getParameter("isseniorconditions_"+i),0);
		String displayorder = Util.getIntValue(request.getParameter("displayorder_"+i),0) + "";					

		//if(istitle==0&&!fieldname.equals("isdata")) displayorder="";
		sql = "insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder,mouldid) values ('"+fieldname+"','"+isconditionstitle+"','"+istitle+"','"+isconditions+"','"+isseniorconditions+"','"+displayorder+"','-1')";	
		rs.executeSql(sql);
	}
	rs.commit();
}catch(Exception e){
	rs.rollback();
	e.printStackTrace();
	new BaseBean().writeLog("saving cptsearchdefinition  error:\n"+e.getMessage());
}



response.sendRedirect("/cpt/capital/CptSearchDefinitionTab.jsp");

%>