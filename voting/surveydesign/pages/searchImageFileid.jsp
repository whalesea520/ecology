
<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*"%>
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
String  docid= Util.null2String(request.getParameter("docid"));
String sql="select imagefileid  from  DocImageFile where docid='"+docid+"'";
RecordSet.execute(sql);
String imagefileid="-1";
if(RecordSet.next())
{
	imagefileid=RecordSet.getString("imagefileid");
}
out.println("{\"imagefileid\":\""+imagefileid+"\"}");
%>