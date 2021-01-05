<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
//上报刊型 待处理 查看界面 获取刊型信息
JSONObject obj = new JSONObject();

String formmodeid = Util.null2String(request.getParameter("formmodeid"));										//表单建模ID
String billid = Util.null2String(request.getParameter("billid"));

String htmlStr = "";

//获取此数据已经选中的刊型信息
String ids = "";
RecordSet.executeSql("select * from uf_xxcb_sbInfo where id="+billid);
if(RecordSet.next()){
	ids = RecordSet.getString("cykx");
}

ArrayList<String> list0 = new ArrayList<String>();
String[] tempid = ids.split(",");
for(int i=0;i<tempid.length;i++){
	list0.add(tempid[i]);
}
ArrayList<String> list = new ArrayList<String>();
RecordSet.executeSql("select kx from uf_xxcb_dbInfo where dataid="+billid+" and id in(select dbxx from uf_xxcb_pbInfo_dt1)");
if(RecordSet.next()){
	String kx = RecordSet.getString("kx");
	if(list0.contains(kx)){
		list.add(kx);
	}
}

String kxid = "";
boolean isExist = false;
boolean isUsed = false;
RecordSet.executeSql("select * from uf_xxcb_kxSet where state=0 order by px asc");
while(RecordSet.next()){
	kxid = RecordSet.getString("id");
	isExist = false;
	isUsed = false;
	//判断此刊型是否选中
	if(list0.contains(kxid)){
		isExist = true;
		if(list.contains(kxid)){
			isUsed = true;
		}
	}
	/*String[] tempid = ids.split(",");
	for(int i=0;i<tempid.length;i++){
		if(kxid.equals(tempid[i])){
			isExist = true;
			break;
		}	
	}*/

	if(isExist){
		htmlStr += "<input type='checkbox' class='kxbox' id='kxbox_"+RecordSet.getString("id")+"' value='"+RecordSet.getString("id")+"' checked=checked "+(isUsed?"onClick=\"top.Dialog.alert('该刊型已被引用不能取消！');return false;\"":"")+">"+RecordSet.getString("name")+"&nbsp;&nbsp;&nbsp;";
	}else{
		htmlStr += "<input type='checkbox' class='kxbox' id='kxbox_"+RecordSet.getString("id")+"' value='"+RecordSet.getString("id")+"'>"+RecordSet.getString("name")+"&nbsp;&nbsp;&nbsp;";
	}

	
}

obj.put("htmlStr", htmlStr);	//放入表


out.clear();
out.print(obj.toString());


//String openUrl = "/formmode/view/AddFormMode.jsp?type=0&modeId="+formmodeid+"&formId="+formId+"&billid="+billid;
//response.sendRedirect(openUrl); 
//return;

%>