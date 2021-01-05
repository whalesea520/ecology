<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
String sql = "select distinct manager from CRM_CustomerInfo where  (department is null or department ='' or department = 0) and (manager <> '1' and manager <> 0 and manager is not null )";
RecordSet.executeSql(sql);
while(RecordSet.next()){
 	int manager=RecordSet.getInt("manager");
 	String hrmsql = "select departmentid,subcompanyid1 from hrmresource where id ="+manager;
 	rs.executeSql(hrmsql);
 	if(rs.next()){
 	    int department = rs.getInt("departmentid");
 	    int subcompanyid1 = rs.getInt("subcompanyid1");
		String upsql = "update CRM_CustomerInfo set department = "+department+",subcompanyid1 = "+subcompanyid1+" where manager = "+manager;
		rs1.executeSql(upsql);
	}
}
%>

<HTML>
<HEAD>
<SCRIPT language="javascript">
function reUpdate(){
  alert("<%=SystemEnv.getHtmlLabelName(31439,user.getLanguage())%>");
}
</script>
</HEAD>
<BODY onload="reUpdate()">
</BODY>
</HTML>