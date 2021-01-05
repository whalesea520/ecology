
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
User user = HrmUserVarify.getUser(request,response);
boolean canedit = HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user) ;
if(!canedit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
JSONObject json = new JSONObject();
if(operation.equals("delete")){
	String ids = Util.null2String(request.getParameter("ids"));
    boolean result = rs.executeSql("delete from multilang_permission_list where id in ("+ids+")");
    if(result){
    	json.put("result",1);
    }else{
    	json.put("result",0);
    }
    
}else if(operation.equals("add")){
   String resourceids = Util.null2String(request.getParameter("resourceids"));
   int wbList = Util.getIntValue(request.getParameter("wbList"),0);
   String[] idArr = resourceids.split(",");
   boolean result = rs.executeSql("delete from multilang_permission_list where userid in ("+resourceids+")");
   if(result){
	   for(int i=0;i<idArr.length;i++){
		   rs.executeSql("insert into multilang_permission_list(userid,wbList) values("+idArr[i]+","+wbList+")");
	   }
	   json.put("result",1);
   }else{
	   json.put("result",0);
   }
}else if(operation.equals("save")){
	int wbList = Util.getIntValue(request.getParameter("wbList"),-1);
	boolean result = rs.executeSql("update SystemSet set wbList="+wbList);
	if(result){
    	json.put("result",1);
    }else{
    	json.put("result",0);
    }
}
out.print(json.toString());

%>


