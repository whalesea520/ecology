
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import = "weaver.formmode.tree.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "weaver.general.*" %>
<%@ page import = "net.sf.json.JSONArray" %>
<%@ page import = "net.sf.json.JSONObject" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%
	String id = Util.null2String(request.getParameter("id"));
	String init = Util.null2String(request.getParameter("init"));
	String pid = Util.null2String(request.getParameter("pid"));
	String showtype = Util.null2String(request.getParameter("showtype"));
	String isselsub = Util.null2String(request.getParameter("isselsub"));
	String isonlyleaf = Util.null2String(request.getParameter("isonlyleaf"));
	String selectedids = Util.null2String(request.getParameter("selectedids"));
	String treerootnode = Util.null2String(request.getParameter("treerootnode"));
	treerootnode = java.net.URLDecoder.decode(treerootnode,"utf-8");
    CustomTreeData CustomTreeData = new CustomTreeData();
	User user = HrmUserVarify.getUser(request , response) ;
    CustomTreeData.setUser(user);
    
    Map map = new HashMap();
    map.put("id",id);
    map.put("init",init);
    map.put("pid",pid);
    map.put("showtype",showtype);
    map.put("isselsub",isselsub);
    map.put("isonlyleaf",isonlyleaf);
    map.put("selectedids",selectedids);
	map.put("treerootnode",treerootnode);
    try {
	    JSONArray jsonArray = CustomTreeData.getTreeDataByMap(map);
        response.getWriter().write(jsonArray.toString());    
    } catch (Exception e) {   
        new BaseBean().writeLog("/formmode/tree/CustomTreeAjax.jsp");
        new BaseBean().writeLog(e);
    }
%>

