<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<jsp:useBean id="SelectItemManager" class="weaver.workflow.selectItem.SelectItemManager" scope="page" />
<%

User user = HrmUserVarify.getUser (request , response) ;
int id = Util.getIntValue(request.getParameter("id"));
String src = Util.null2String(request.getParameter("src"));

if(src.equals("pubchoiceback")){
	String sql="SELECT id,name FROM mode_selectitempagedetail WHERE mainid="+id+" and pid=0 AND statelev=1 and (cancel IS NULL OR cancel='0' OR cancel='') ORDER BY disorder";
	//System.out.println(sql);
	rs.executeSql(sql);
	JSONArray jsonArray=new JSONArray();
	JSONObject jsonObject=new JSONObject();
	while(rs.next()){
	    int _id = Util.getIntValue(rs.getString("id"),0);
	    String _name = Util.null2String(rs.getString("name"));
	    jsonObject=new JSONObject();
		jsonObject.put("id", _id);
		jsonObject.put("name", _name);
		jsonArray.put(jsonObject);
	}
	out.println(jsonArray.toString());
	
	//System.out.println(jsonArray.toString());
}else if(src.equals("notcancel")){//解封
	int detailid = Util.getIntValue(request.getParameter("detailid"));
	ArrayList<String> arrayList = new ArrayList<String>();
	arrayList = SelectItemManager.getAllSubSelectItemId(arrayList, ""+detailid, -1);
	String allSubIds = "";//所有子项id
	for(int j=0;j<arrayList.size();j++){
		allSubIds += ","+arrayList.get(j);
	}
	String allids = detailid + allSubIds;
	String sql = "update mode_selectitempagedetail set cancel=0 where id in ("+allids+")";
	rs.executeSql(sql);
	JSONObject jsonObject = new JSONObject();
	jsonObject.put("detailid",detailid);
	
	SelectItemManager.syncPubSelectOp(id,user.getLanguage());
	
	response.getWriter().write(jsonObject.toString());
	return;
}else if(src.equals("selectItemback")){
	JSONArray jsonArray=new JSONArray();
	JSONObject jsonObject=new JSONObject();
	Map<String,String> selectItemOptionMap = SelectItemManager.getSelectItemOption(id+"");
	for(Map.Entry<String, String> entry: selectItemOptionMap.entrySet()){
		jsonObject=new JSONObject();
		jsonObject.put("id", entry.getKey());
		jsonObject.put("name", entry.getValue());
		jsonArray.put(jsonObject);
	}
	out.println(jsonArray.toString());
}else if(src.equals("hasPubChoice")){
	int formid = Util.getIntValue(request.getParameter("formid"));
	int isdetail = Util.getIntValue(request.getParameter("isdetail"));
    String detailtable = Util.null2String(request.getParameter("detailtable"));
    boolean flag = SelectItemManager.hasPubChoice(formid,isdetail,detailtable);
	if(flag){
		out.println("true");	
	}else{
		out.println("false");
	}
}

%>
