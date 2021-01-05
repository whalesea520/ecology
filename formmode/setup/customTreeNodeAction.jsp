
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
FileUpload fu = new FileUpload(request);

String operation = Util.null2String(fu.getParameter("operation"));
String sql = "";

String nodename = InterfaceTransmethod.toHtmlForMode(fu.getParameter("nodename"));
String nodedesc = InterfaceTransmethod.toHtmlForMode(fu.getParameter("nodedesc"));
String nodeicon = Util.null2String(fu.uploadFiles("nodeicon"));
String oldnodeicon = Util.null2String(fu.getParameter("oldnodeicon"));
int id = Util.getIntValue(Util.null2String(fu.getParameter("id")),0);
int mainid = Util.getIntValue(Util.null2String(fu.getParameter("mainid")),0);
int sourcefrom = Util.getIntValue(Util.null2String(fu.getParameter("sourcefrom")),0);
int sourceid = Util.getIntValue(Util.null2String(fu.getParameter("sourceid")),0);
int hreftype = Util.getIntValue(Util.null2String(fu.getParameter("hreftype")),0);
int hrefid = Util.getIntValue(Util.null2String(fu.getParameter("hrefid")),0);
int supnode = Util.getIntValue(Util.null2String(fu.getParameter("supnode")),0);
String tablename = Util.null2String(fu.getParameter("tablename"));
String tablekey = Util.null2String(fu.getParameter("tablekey"));
String tablesup = Util.null2String(fu.getParameter("tablesup"));
String showfield = Util.null2String(fu.getParameter("showfield"));
String hreftarget = InterfaceTransmethod.toHtmlForMode(fu.getParameter("hreftarget"));
String hrefrelatefield = Util.null2String(fu.getParameter("hrefrelatefield"));
String supnodefield = Util.null2String(fu.getParameter("supnodefield"));
String nodefield = Util.null2String(fu.getParameter("nodefield"));
String iconField = Util.null2String(fu.getParameter("iconField"));
String dataorder = InterfaceTransmethod.toHtmlForMode(fu.getParameter("dataorder"));
String datacondition = InterfaceTransmethod.toHtmlForMode(fu.getParameter("datacondition"));
String hrefField = Util.null2String(fu.getParameter("hrefField"));
String rootids = Util.null2String(fu.getParameter("rootids"));
int isshowrootnode = Util.getIntValue(Util.null2String(fu.getParameter("isshowrootnode")),0);
int iscontainssub = Util.getIntValue(Util.null2String(fu.getParameter("iscontainssub")),0);
double showorder = Util.getDoubleValue(fu.getParameter("showorder"),1);

if(nodeicon.equals("")){
	nodeicon = oldnodeicon;
}
if (operation.equals("add")) {
	sql = "insert into mode_customtreedetail(mainid,nodename,nodedesc,sourcefrom,sourceid,tablename,tablekey,tablesup,showfield,hreftype,hrefid,hreftarget,hrefrelatefield,nodeicon,supnode,supnodefield,nodefield,showorder,iconField,dataorder,datacondition,hrefField,rootids,isshowrootnode,iscontainssub)";
	sql += " values ("+mainid+",'"+nodename+"','"+nodedesc+"','"+sourcefrom+"','"+sourceid+"','"+tablename+"','"+tablekey+"','"+tablesup+"','"+showfield+"','"+hreftype+"','"+hrefid+"','"+hreftarget+"','"+hrefrelatefield+"','"+nodeicon+"','"+supnode+"','"+supnodefield+"','"+nodefield+"','"+showorder+"','"+iconField+"','"+dataorder+"','"+datacondition+"','"+hrefField+"','"+rootids+"',"+isshowrootnode+","+iscontainssub+")";
	rs.executeSql(sql);
	
	sql = "select max(id) id from mode_customtreedetail where mainid = " + mainid + " and nodename = '"+nodename+"'";
	rs.executeSql(sql);
	while(rs.next()){
		id = rs.getInt("id");
	}

	response.sendRedirect("/formmode/setup/customTreeNodeBase.jsp?id="+id);
}else if (operation.equals("edit")) {
	sql = "update mode_customtreedetail set ";
	sql += " mainid = " + mainid + ",";
	sql += " nodename = '" + nodename + "',";
	sql += " nodedesc = '" + nodedesc + "',";
	sql += " sourcefrom = '" + sourcefrom + "',";
	sql += " sourceid = '" + sourceid + "',";
	sql += " tablename = '" + tablename + "',";
	sql += " tablekey = '" + tablekey + "',";
	sql += " tablesup = '" + tablesup + "',";
	sql += " showfield = '" + showfield + "',";
	sql += " hreftype = '" + hreftype + "',";
	sql += " hrefid = '" + hrefid + "',";
	sql += " hreftarget = '" + hreftarget + "',";
	sql += " isshowrootnode = " + isshowrootnode + ",";
	sql += " iscontainssub = " + iscontainssub + ",";
	sql += " hrefrelatefield = '" + hrefrelatefield + "',";
	
	sql += " rootids = '" + rootids + "',";
	sql += " hrefField = '" + hrefField + "',";
	sql += " dataorder = '" + dataorder + "',";
	sql += " datacondition = '" + datacondition + "',";
	sql += " iconField = '" + iconField + "',";
	sql += " nodeicon = '" + nodeicon + "',";
	sql += " supnode = '" + supnode + "',";
	sql += " supnodefield = '" + supnodefield + "',";
	sql += " nodefield = '" + nodefield + "',";
	sql += " showorder = '" + showorder + "'";
	sql += " where id = '" + id + "'";
	rs.executeSql(sql);
	
	response.sendRedirect("/formmode/setup/customTreeNodeBase.jsp?id="+id);
}else if (operation.equals("del")) {
	sql = "delete from mode_customtreedetail where id = " + id;
	rs.executeSql(sql);
	response.sendRedirect("/formmode/setup/customTreeBase.jsp?id="+mainid);
}
%>