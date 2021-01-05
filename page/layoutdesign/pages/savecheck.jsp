
<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*,java.text.*,weaver.matrix.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.page.maint.layout.PageLayoutUtil"%>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="cs" class="weaver.conn.ConnStatement" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.homepage.cominfo.HomepageBaseLayoutCominfo"%>

<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
char flag=Util.getSeparator();
int userid=user.getUID();
request.setCharacterEncoding("UTF-8");
String layoutid=request.getParameter("layoutid");
String allowarea=request.getParameter("allowarea");
String preallowarea="";
String islostel="0";
String attachpageitems="0";
rs.execute("select allowArea  from pagelayout where id='"+layoutid+"'");
if(rs.next()){
	preallowarea=rs.getString("allowArea");
}
if(!allowarea.equals(preallowarea)){
	islostel="1";
}
rs.execute("select COUNT(*) as nums from (select distinct(hpid)  from hpLayout where layoutbaseid='"+layoutid+"')a");
if(rs.next()){
	attachpageitems=rs.getString("nums");
}
out.println("{\"islostel\":\""+islostel+"\",\"reapages\":\""+attachpageitems+"\"}");

%>