
<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*,java.text.*,weaver.matrix.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
char flag=Util.getSeparator();
int userid=user.getUID();
request.setCharacterEncoding("UTF-8");
String matrixid=request.getParameter("matrixid");
String matrixtable=MatrixUtil.MATRIXPREFIX+matrixid;
String deleteitems=request.getParameter("deleteitems");
String sql="";
StringBuffer ids=new StringBuffer("");
String instr="";
for(String item:deleteitems.split(",")){
	ids.append("'").append(item).append("'").append(",");
}
if(ids.length()==0)
	out.println("{\"success\":\"0\"}");
else{
	instr=ids.substring(0,ids.length()-1);
	sql="delete from "+matrixtable+"  where uuid in ( "+instr+" )";
	try{
		RecordSet.execute(sql);
		out.println("{\"success\":\"1\"}");
	}catch(Exception e){
		out.println("{\"success\":\"0\"}");
	}
}
%>