<%@page contentType="text/xml; charset=UTF-8"%>
<%@ page import="weaver.general.*,java.util.*,java.io.*,java.math.*"%>
<jsp:useBean id="syscominfo" class="weaver.system.SystemComInfo"
	scope="page" />
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="XmlReportManage" class="weaver.report.XmlReportManage"
	scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  {
	response.sendRedirect("/login/Logout.jsp");
	return ;
}
boolean isRemote = Util.null2String(weaver.file.Prop.getPropValue("xmlreport", "report.remote")).equals("1");
String rptName = Util.null2String(request.getParameter("rptName"));
String xmlContent = XmlReportManage.getXmlContent(rptName);
String rptFlag = Util.null2String(request.getParameter("rptFlag"));
if(rptFlag.equals("")) {
	return;
}
String id = "";
StringBuffer s = new StringBuffer();
s.append("select distinct t1.id from HrmResource t1, XMLREPORT_ShareInfo t2 where ");
s.append("t1.id='"+user.getUID()+"' and (");
s.append("(t2.sharetype = 4 and t2.foralluser = 1 and t2.seclevel <= t1.seclevel) ");
s.append("or (t2.sharetype = 1 and t2.userid = t1.id) ");
s.append("or (t2.sharetype = 2 and t2.departmentid = t1.departmentid and t2.seclevel <= t1.seclevel) ");
s.append("or (t2.sharetype = 3 and t1.id in (SELECT resourceid FROM hrmrolemembers where roleid = t2.roleid) and t2.seclevel <= t1.seclevel) ");
s.append(") and t2.relateditemid='"+rptFlag+"'");
rs.executeSql(s.toString());
//System.out.println(s.toString());
if(rs.next()) {
	id = Util.null2String(rs.getString("id"));
}
if(id.equals("")) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<?xml-stylesheet type="text/xsl" href="XmlReportStyle.jsp?rptName=<%=rptName%>"?>
<%
	response.setContentType("text/xml; charset=UTF-8");
	out.print(xmlContent);
	//System.out.print(xmlContent);
	/*
	//获取文件存放路径
	String rootPath = Util.null2String(syscominfo.getFilesystem());
	if (rootPath.equals("")) {
		rootPath = GCONST.getSysFilePath();
	} else {
		if (!rootPath.substring(rootPath.length() - 1, rootPath.length()).equals("/") || !rootPath.substring(rootPath.length() - 1, rootPath.length()).equals("\\")) {
			rootPath += File.separator;
		}
	}
	rootPath += "xmlreport"+File.separator;
	String dir = "";
	if (rptType.equals("0")) {
		dir = updateDate+File.separator;
	}
	try {
		FileReader fr = null;
		fr = new FileReader(rootPath + dir + rptName);
		BufferedReader br = new BufferedReader(fr);
		while(br.ready()) {
			out.println(br.readLine());
		}
		br.close();
		fr.close();
	} catch (IOException e1) {
		//e1.printStackTrace();
	}
	*/
%>
