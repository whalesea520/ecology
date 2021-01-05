<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user))  {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String reportid = Util.null2String(request.getParameter("reportid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String mutiids = Util.null2String(request.getParameter("mutiids")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String sharelevel = Util.null2String(request.getParameter("sharelevel"));
if("delete".equals(method)){
	rs.execute("DELETE FROM WR_ReportShare WHERE id="+id);
	response.sendRedirect("ReportShare.jsp?method="+method);
	return;
}

String userid = "";
String deptid = "";
String roleid = "";
String rolelevel = "";

if(sharetype.equals("1")){//人力资源
	userid = relatedshareid ;
	seclevel="0";
}else if(sharetype.equals("2")){//部门
	deptid = relatedshareid ;
}else if(sharetype.equals("3")){//角色
	roleid = relatedshareid ;
	rolelevel = Util.null2String(request.getParameter("rolelevel")); 
}

String mutiuserid = "";
String mutideptid = "";
String muticpyid = "";
if(sharelevel.equals("6")){//多部门
	mutideptid = mutiids ;
}else if(sharelevel.equals("8")){//多分部
	muticpyid = mutiids ;
}else if(sharelevel.equals("9")){//多人员
	mutiuserid = mutiids ;
}

rs.execute("INSERT INTO WR_ReportShare "+
			      "  (reportid "+
			      "  ,sharetype "+
			      "  ,seclevel "+
			      "  ,roleid "+
			      "  ,rolelevel "+
			      "  ,sharelevel "+
			      "  ,userid "+
			      "  ,deptid "+
			      "  ,mutiuserid "+
			      "  ,mutideptid "+
			      "  ,muticpyid)"+
			      "  VALUES "+
		          " ('"+reportid+"'"+
		          ",'"+sharetype+"'"+
		          ",'"+seclevel+"'"+
		          ",'"+roleid+"'"+
		          ",'"+rolelevel+"'"+
		          ",'"+sharelevel+"'"+
		          ",'"+userid+"'"+
		          ",'"+deptid+"'"+
		          ",'"+mutiuserid+"'"+
		          ",'"+mutideptid+"'"+
		          ",'"+muticpyid+"')"
		);
response.sendRedirect("ReportShare.jsp?method="+method);

%>