
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import = "weaver.formmode.tree.*" %>
<%@ page import = "weaver.conn.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "weaver.general.*" %>
<%@ page import = "net.sf.json.JSONArray" %>
<%@ page import = "net.sf.json.JSONObject" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>

<%
   String id = Util.null2String(request.getParameter("id"));
   String search = Util.null2String(request.getParameter("search"));
   String name = Util.null2String(request.getParameter("root"));
   Map<String,Map<String,String>> map = new TreeMap<String,Map<String,String>>();
   SearchTreeUtil searchTreeUtil = new SearchTreeUtil();
   User user = HrmUserVarify.getUser(request,response) ;
   searchTreeUtil.setUser(user);
   RecordSet rs = new RecordSet();
   RecordSet rs2 = new RecordSet();
   searchTreeUtil.initTreeRelation(id,search,map,null,rs,rs2);
   JSONArray array = new JSONArray();
   for(Map.Entry<String,Map<String,String>> entry : map.entrySet()){
	   JSONObject object = new JSONObject();
	   object.accumulate("id",entry.getKey());
	   object.accumulate("pId",entry.getValue().get("pid"));
	   object.accumulate("name",entry.getValue().get("name"));
	   if(!entry.getValue().get("nodeicon").equals("")){
		   object.accumulate("icon","/weaver/weaver.file.FileDownload?fileid="+entry.getValue().get("nodeicon"));
	   }
	   object.accumulate("open","true");
	   array.add(object);
   }
   //获得根节点的图标
   String rootIcon = "";
   String sql = "select * from mode_customtree where id="+id;
   rs.executeSql(sql);
   if(rs.next()){
	   rootIcon =  Util.null2String(rs.getString("rooticon"));
   }
   JSONObject root = new JSONObject();
   root.accumulate("id","0_0");
   root.accumulate("pId","0");
   root.accumulate("name",name);
   root.accumulate("open","true");
   if(!rootIcon.equals("")){
	   root.accumulate("icon","/weaver/weaver.file.FileDownload?fileid="+rootIcon);
   }
   array.add(root);
   response.getWriter().write(array.toString());
%>


