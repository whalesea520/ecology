<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.interfaces.email.CoreMailAPI" %>
<%@ page import="weaver.interfaces.email.CoreMailTestAPI" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
User user = HrmUserVarify.getUser(request, response);
if(user == null) return;
if(!HrmUserVarify.checkUserRight("CoreMail:ALL", user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return;
}

String operation = Util.null2String(request.getParameter("operation"));

int isused = Util.getIntValue(Util.null2String(request.getParameter("isused")), 0);
String systemaddress = Util.null2String(request.getParameter("systemaddress"));
String domain = Util.null2String(request.getParameter("domain"));
String orgid = Util.null2String(request.getParameter("orgid"));
String providerid = Util.null2String(request.getParameter("providerid"));
int issync = Util.getIntValue(Util.null2String(request.getParameter("issync")), 0);
String bindfield = Util.fromScreen(request.getParameter("bindfield"), user.getLanguage());

rs.executeSql("delete from coremailsetting");
String sql = "";
sql = "insert into coremailsetting(isuse,systemaddress,orgid,providerid,domain,issync,bindfield) values('"+isused+"','"+systemaddress+"','"+orgid+"','"+providerid+"','"+domain+"','"+issync+"','"+bindfield+"')";
rs.execute(sql);

if("syn".equals(operation)) {// 初始化
	String result = "0";
	try {
		CoreMailAPI coremailapi = CoreMailAPI.getInstance();
		if(coremailapi.initOrgAndUser()) {
			result = "1";
		}
		
		//CoreMailTestAPI testapi = CoreMailTestAPI.getInstance();
		//if(testapi.initOrgAndUser()) {
		//	result = "1";
		//}
	} catch(Exception e) {
		
	}
	out.print(result);
} else if("test".equals(operation)) {// 测试
	String result = "0";
	try {
		CoreMailAPI coremailapi = CoreMailAPI.getInstance();
		if(coremailapi.InitClient()) {
			result = "1";
		}
	} catch(Exception e) {
		
	}
	out.print(result);
} else {
	response.sendRedirect("/integration/coremail/coremailsetting.jsp");
}

%>