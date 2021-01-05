<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@page import="com.alibaba.fastjson.JSON"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
rs.getDBType();
String actionType=request.getParameter("actionType");
String actionName=request.getParameter("actionName");
String actionId=request.getParameter("actionId");
String flag="true";
String sql ="";
String Chinese_PRC_CS_AS_WS=" ";


if(rs.getDBType().toLowerCase().indexOf("sqlserver")>-1){
	  Chinese_PRC_CS_AS_WS=" collate Chinese_PRC_CS_AS_WS ";
}
if(actionType.equals("dml"))
	sql="select count(1)   from  formactionset where dmlactionname "+Chinese_PRC_CS_AS_WS+"='"+actionName+"'";
else if(actionType.equals("action"))
	sql="select  count(1)    from  actionsetting where actionshowname "+Chinese_PRC_CS_AS_WS+"='"+actionName+"'";

else if(actionType.equals("ws"))
	sql="select  count(1)    from  wsformactionset where actionname "+Chinese_PRC_CS_AS_WS+"='"+actionName+"'";

if(actionId!=null&&!"".equals(actionId)){
	sql+=" and id <>"+actionId;
}
rs.execute(sql);
rs.next();
if(rs.getInt(1)>0){
	flag="false";
}
Map<String,String> returndata= new HashMap<String,String>();
returndata.put("flag",flag);
 out.print(JSON.toJSONString(returndata));
%>

