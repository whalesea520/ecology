
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

    CustomTreeData CustomTreeData = new CustomTreeData();
	User user = HrmUserVarify.getUser(request , response) ;
    CustomTreeData.setUser(user);
    List<TreeNode> tlist = CustomTreeData.getTreeData(init,id,pid);

    try {
        JSONArray jsonArray = JSONArray.fromObject(tlist);
        response.getWriter().write(jsonArray.toString());    
    } catch (Exception e) {   
        new BaseBean().writeLog("/formmode/tree/CustomTreeAjax.jsp");
        new BaseBean().writeLog(e);
    }
%>

