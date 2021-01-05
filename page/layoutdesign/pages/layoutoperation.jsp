
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*,java.text.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<%
String method = Util.null2String(request.getParameter("method"));
String layoutid=Util.null2String(request.getParameter("layoutid"));
String name=Util.null2String(request.getParameter("name"));
//验证是否 重名
if(method.equals("checkname")) {
	if(!"".equals(layoutid) && !"".equals(name)) {
		baseBean.writeLog("select * from pagelayout where layoutname = '"+name+"' and id !="+layoutid);
		rs.executeSql("select * from pagelayout where layoutname = '"+name+"' and id !="+layoutid);
	}else{
		baseBean.writeLog("select * from pagelayout where layoutname = '"+name+"'");
		rs.executeSql("select * from pagelayout where layoutname = '"+name+"'");
	}
	if(rs.next()) out.println("1");
}
%>