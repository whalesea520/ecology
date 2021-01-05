<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.templetecheck.*"%>
<%@ page import="weaver.hrm.*,weaver.general.*" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="org.json.*" %>


<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	User user = HrmUserVarify.getUser(request,response);
	if(user == null)  return ;
	String parentid=Util.null2String(request.getParameter("parentid"));
	String path = Util.null2String(request.getParameter("path"));//文件路径
	String isedit = Util.null2String(request.getParameter("isedit"));
	String from = Util.null2String(request.getParameter("from"));//判断是否来自于配置文件信息维护 检测配置
	
	//获得xml树形结构的json数据
	JSONArray nodeElement = null;
	if(isedit.equals("true")) {
		XMLUtil xmlUtil = null;
		if("checkconfig".equals(from)) {
			xmlUtil = new XMLUtil(GCONST.getRootPath() + path);//配置文件信息维护检测配置，地址存放的是相对路径，需要添加项目路径
		} else {
			xmlUtil = new XMLUtil(path);
		}
		
		nodeElement = xmlUtil.getElementByParentId(parentid);
	} else {
		//选择节点
		selectXmlNodeUtil xml2ArrayList = null;
		if("checkconfig".equals(from)) {
			xml2ArrayList = new selectXmlNodeUtil(GCONST.getRootPath() + path);//配置文件信息维护检测配置，地址存放的是相对路径，需要添加项目路径
		} else {
			xml2ArrayList = new selectXmlNodeUtil(path);//配置文件信息维护检测配置，地址存放的是相对路径，需要添加项目路径
		}
		
		nodeElement = xml2ArrayList.getElementByParentId(parentid);
	}
	if(nodeElement!=null) {
		out.print(nodeElement.toString().substring(0,nodeElement.toString().length()-1)+"]");
	} else {
		out.print("文件加载失败！");
	}
	
	
%>