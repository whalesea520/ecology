<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
//上报刊型 待处理 查看界面 获取栏目信息
String kxid = Util.null2String(request.getParameter("kxid"));		//刊型ID

JSONObject obj = new JSONObject();

String htmlStr = "<select id='lmSelect' onchange='lmChange(this.options[this.options.selectedIndex].value);'><option value=''></option>";

RecordSet.executeSql("select * from uf_xxcb_kxSet_dt1 where mainid="+kxid+" order by id asc");
while(RecordSet.next()){

	htmlStr += "<option value='"+RecordSet.getString("id")+"'>"+RecordSet.getString("name")+"</option>";
	
}

htmlStr += "</select>";

obj.put("htmlStr", htmlStr);	//放入表


out.clear();
out.print(obj.toString());


//String openUrl = "/formmode/view/AddFormMode.jsp?type=0&modeId="+formmodeid+"&formId="+formId+"&billid="+billid;
//response.sendRedirect(openUrl); 
//return;

%>