<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.templetecheck.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String path = request.getParameter("fpath");
String xpath = request.getParameter("xpath");
String operate = request.getParameter("operate");
String attrs = request.getParameter("attrs");
String attrvals = request.getParameter("attrvals");
String nodename = request.getParameter("nodename");
String nodecontent = request.getParameter("nodecontent");
String res = "";
//System.out.println("xpath:"+xpath);
XMLUtil xmlUtil = new XMLUtil(path);
if(operate.equals("delete")) {
	res = xmlUtil.removeNodeByXpath(xpath);
} else if(operate.equals("edit")){//编辑
	res = xmlUtil.updateXml(nodename,xpath,attrs,attrvals,nodecontent,operate);
} else {//新增
	res = xmlUtil.updateXml(nodename,xpath,attrs,attrvals,nodecontent,operate);
}

out.print(res);

%> 