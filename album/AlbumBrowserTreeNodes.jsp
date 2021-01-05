<%@page import="java.util.Map.Entry"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*,weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String selids=Util.null2String(request.getParameter("selids"));
String pid=request.getParameter("id");
String flag=request.getParameter("flag");//标志,用来判断用户是否点击右键菜单的显示全部目录
JSONArray jsonArray=new JSONArray();

if(selids.startsWith(",")){
	selids=selids.substring(1);
}
if(selids.endsWith(",")){
	selids=selids.substring(0,selids.length()-1);
}

Map<String,JSONObject> map=new  LinkedHashMap<String,JSONObject>();

if(pid==null&&flag==null){//首次进入加载1级分部
	String sql="select * from hrmsubcompany where  (canceled=0 or canceled is null) and supsubcomid='0'   order by supsubcomid,id ";
	
	
	rs.execute(sql);
	while(rs.next()){
		JSONObject jsonObject=new JSONObject();
		jsonObject.put("id", rs.getString ("id"));
		jsonObject.put("pId", "0");
		jsonObject.put("name", rs.getString("subcompanyname"));
		//jsonObject.put("iconOpen", "/wui/common/jquery/plugin/zTree/css/zTreeStyle/img/diy/1_open_wev8.png");
		//jsonObject.put("iconClose", "/wui/common/jquery/plugin/zTree/css/zTreeStyle/img/diy/1_close_wev8.png");
		jsonObject.put("isParent", true);
		
		map.put(rs.getString ("id"), jsonObject);
		//jsonArray.put(jsonObject);
	}
}else{//加载
	String sql="";
	int parentid=Util.getIntValue(pid,0);
	//分部
	sql="select * from hrmsubcompany where  (canceled=0 or canceled is null) and supsubcomid='"+pid+"' and supsubcomid not in("+selids+")   order by supsubcomid,id ";

	//System.out.println("pid:"+pid);
	
	rs.execute(sql);
	while(rs.next()){
		JSONObject jsonObject=new JSONObject();
		
		String id="";
		String pId="";
		String name="";
		
		id= rs.getString ("id");
		pId=rs.getString ("supsubcomid");
		name=rs.getString("subcompanyname");
		jsonObject.put("id", id);
		jsonObject.put("pId", pId);
		jsonObject.put("name", name);
		jsonObject.put("isParent", true);
		
		map.put(rs.getString ("id"), jsonObject);
	
	}
	
	//相册文件夹
	sql="select * from  AlbumPhotos where  isFolder='1' and parentid='"+pid+"' and parentid not in("+selids+") order by orderNum desc ";
	
	rs.execute(sql);
	while(rs.next()){
		JSONObject jsonObject=new JSONObject();
		
		String id="";
		String pId="";
		String name="";
		
		id= rs.getString ("id");
		pId=rs.getString ("parentid");
		name=rs.getString("photoname");
		jsonObject.put("id", id);
		jsonObject.put("pId", pId);
		jsonObject.put("name", name);
		jsonObject.put("isParent", true);
		jsonObject.put("iconOpen", "/album/img/albumfolder_wev8.png");
		jsonObject.put("iconClose", "/album/img/albumfolder_wev8.png");
		
		map.put(rs.getString ("id"), jsonObject);
	
	}
	
	
}



Iterator it=map.entrySet().iterator();
while(it.hasNext()){
	Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
	String k= entry.getKey();
	JSONObject v= entry.getValue();
	jsonArray.put(v);
	
}

//System.out.println("jsonarr:\n"+jsonArray.toString());

out.println(jsonArray.toString());

%>

    
