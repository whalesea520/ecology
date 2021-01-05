<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="infoUse" class="weaver.govern.interfaces.CheckInfoUseAction" scope="page"/>
<%
//上报刊型 待处理 查看界面 获取栏目信息
String ids = Util.null2String(request.getParameter("ids"));		//ID
String kx = Util.null2String(request.getParameter("kx"));		//刊型ID
String lm = Util.null2String(request.getParameter("lm"));		//子栏目ID

JSONObject obj = new JSONObject();

String result = infoUse.execute(ids,kx,lm);

obj.put("result", result);	//放入表


out.clear();
out.print(obj.toString());
%>