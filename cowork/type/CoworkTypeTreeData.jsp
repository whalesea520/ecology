
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@ page import="java.util.*" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page"/>
<%
	User user = HrmUserVarify.getUser(request , response) ;
	String sql = "select id ,typename from cowork_maintypes order by sequence asc ,id desc";
	
	rst.execute("select count(*) from cowork_types");
	rst.next();
	int count = Util.getIntValue(rst.getString(1),0);
	String leftMenus="{name:'"+SystemEnv.getHtmlLabelName(25398,user.getLanguage())+"',hasChildren:false,attr:{id:'all'},numbers:{flowAll:"+count+"}}";	
	
	rs.execute(sql);
	while(rs.next()){
		rst.execute("select count(*) from cowork_types where departmentid = "+rs.getString("id"));
		rst.next();
		
		count = Util.getIntValue(rst.getString(1),0);
		
		leftMenus+=",{name:'"+rs.getString("typename")+"',"+
		"hasChildren:false,attr:{id:'"+rs.getString("id")+"'},"+
		"numbers:{flowAll:"+count+"}}";
	}
	leftMenus="["+leftMenus+"]";
	out.print(leftMenus);
	// System.err.println(leftMenus);
%>
