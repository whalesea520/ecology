
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*,weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String wfid=Util.null2String(request.getParameter("wfid"));//流程里传来的流程id
String hidearchive=Util.null2String(request.getParameter("hidearchive"));//隐藏封存科目
String from_wf_browser=Util.null2String(request.getParameter("from_wf_browser"));//来自wf浏览按钮
String pid=request.getParameter("id");
String flag=request.getParameter("flag");//标志,用来判断用户是否点击右键菜单的显示全部目录
JSONArray jsonArray=new JSONArray();

//System.out.println("wfid:"+wfid);

if(pid==null&&flag==null){//首次进入加载1级
	String sql="select * from CptCapitalAssortment where supassortmentid=0  order by id ";
	
	rs.execute(sql);
	while(rs.next()){
		JSONObject jsonObject=new JSONObject();
		jsonObject.put("id", rs.getInt("id"));
		jsonObject.put("pId", 0);
		jsonObject.put("name", rs.getString("assortmentname"));
		jsonObject.put("iconOpen", "/wui/common/jquery/plugin/zTree/css/zTreeStyle/img/diy/1_open_wev8.png");
		jsonObject.put("iconClose", "/wui/common/jquery/plugin/zTree/css/zTreeStyle/img/diy/1_close_wev8.png");
		if(rs.getInt("subassortmentcount")>0){
			jsonObject.put("isParent", true);
		}else{
			jsonObject.put("isParent", false);
		}
		jsonArray.put(jsonObject);
	}
	
}else{//加载
	rs.execute("select * from CptCapitalAssortment where supassortmentid="+pid);
	while(rs.next()){
		JSONObject jsonObject=new JSONObject();
		jsonObject.put("id", rs.getInt("id"));
		jsonObject.put("pId", rs.getInt("supassortmentid"));
		jsonObject.put("name", rs.getString("assortmentname"));
		if(rs.getInt("subassortmentcount")>0){
			jsonObject.put("isParent", true);
		}else{
			jsonObject.put("isParent", false);
		}
		jsonArray.put(jsonObject);
	}
}


out.println(jsonArray.toString());

%>

    
