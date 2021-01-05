
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="ln.LN"%>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="weaver.workflow.workflow.TestWorkflowCheck" %>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.systeminfo.setting.*" %>
<%@ page import="weaver.general.Util,weaver.interfaces.datasource.*"%>
<%@ page import="weaver.servicefiles.ResetXMLFileCache"%>
<%@page import="weaver.interfaces.schedule.BaseCronJob"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="org.quartz.CronExpression"%>
<%@page import="weaver.general.InitServiceXMLtoDB"%>
<%@ page import="weaver.formmode.excel.ModeCacheManager"%>


<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserXML" class="weaver.servicefiles.BrowserXML" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

if(user == null)  return ;
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String operation = Util.null2String(request.getParameter("operation"));
String customid = Util.null2String(request.getParameter("customid"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String istest = "";
BrowserXML.initData();
if(operation.equals("browser")){
    String method = Util.null2String(request.getParameter("method"));
    if(method.equals("add")){
        String browserid = Util.null2String(request.getParameter("browserid"));
        String oldbrowserid = Util.null2String(request.getParameter("browserid_old"));
        
        String name = Util.null2String(request.getParameter("name"));
        String typename = Util.null2String(request.getParameter("typename"));
        if(browserid.equals("") || "".equals(name)){
            response.sendRedirect("browsersetinfo.jsp?customid="+customid);
            return;
        }
        String ds = "datasource."+Util.null2String(request.getParameter("ds"));
        if("".equals(Util.null2String(request.getParameter("ds"))))
        {
        	ds = "";
        }
        String search = Util.null2String(request.getParameter("search"));
        String searchById = Util.null2String(request.getParameter("searchById"));
        String searchByName = Util.null2String(request.getParameter("searchByName"));
        String nameHeader = Util.null2String(request.getParameter("nameHeader"));
        String descriptionHeader = Util.null2String(request.getParameter("descriptionHeader"));
        String outPageURL = Util.null2String(request.getParameter("outPageURL"));
        String from = Util.null2String(request.getParameter("from"));
        String href = Util.null2String(request.getParameter("href"));
        String showtree = Util.null2String(request.getParameter("showtree"));
        String nodename = Util.null2String(request.getParameter("nodename"));
        String parentid = Util.null2String(request.getParameter("parentid"));
        String ismutil = Util.null2String(request.getParameter("ismutil"));
        
        Hashtable dataHST = new Hashtable();
        dataHST.put("ds",ds);
        dataHST.put("search",search);
        dataHST.put("searchById",searchById);
        dataHST.put("searchByName",searchByName);
        dataHST.put("nameHeader",nameHeader);
        dataHST.put("descriptionHeader",descriptionHeader);
        dataHST.put("outPageURL",outPageURL);
        dataHST.put("from",from);
        dataHST.put("href",href);
        dataHST.put("showtree",showtree);
        dataHST.put("nodename",nodename);
        dataHST.put("parentid",parentid);
        dataHST.put("ismutil",ismutil);
        dataHST.put("name",name);
        dataHST.put("customid",customid);
        
        BrowserXML.writeToBrowserXMLAdd(browserid,dataHST);
        BrowserXML.init();
        InitServiceXMLtoDB initServiceXMLtoDB = new InitServiceXMLtoDB();
		initServiceXMLtoDB.initCacheBrowserByName(browserid);
		ModeCacheManager.getInstance().reloadBrowser(browserid);
       	response.sendRedirect("/formmode/setup/browserList.jsp?objid="+customid);
    	return;
    }else if(method.equals("deletesingle")){
    	String typename = Util.null2String(request.getParameter("typename"));
    	String browserid = Util.null2String(request.getParameter("browserid"));
    	String SQL = "delete from datashowset where showname='"+browserid+"'";
		rs1.executeSql(SQL);
    	BrowserXML.writeToBrowserXMLDel(browserid);
    	BrowserXML.init();
    	InitServiceXMLtoDB initServiceXMLtoDB = new InitServiceXMLtoDB();
		initServiceXMLtoDB.initCacheBrowserByName(browserid);
		ModeCacheManager.getInstance().reloadBrowser(browserid);
		response.sendRedirect("/formmode/setup/browserList.jsp?objid="+customid);
    	return;
    }
}
%>