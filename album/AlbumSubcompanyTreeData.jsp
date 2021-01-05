<%@page import="java.util.Map.Entry"%>
<%@page import="weaver.common.util.xtree.TreeNode"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="cptgroup" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="PhotoComInfo" class="weaver.album.PhotoComInfo" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

if(user==null){
	out.print("[]");
}
String sqlwhere="";
String from=Util.null2String(request.getParameter("from"));
int subcompanyid1=Util.getIntValue (request.getParameter("subcompanyid1"),0);


JSONArray arr=new JSONArray();
JSONObject obj=new JSONObject();

Map<String,JSONObject> map=new  LinkedHashMap<String,JSONObject>();

//分部
//cptgroup.setTofirstRow();
String sql1="select * from hrmsubcompany where  canceled=0 or canceled is null    order by supsubcomid,id ";
rs.execute(sql1);
while(rs.next()){
	obj=new JSONObject();
	String id=rs.getString("id");
	JSONObject attr=new JSONObject();
	
	attr.put("groupid", id);
	attr.put("subcompanyid", id);
	
	JSONObject numbers=new JSONObject();
	numbers.put("data2count", "");
	
	obj.put("id",id);
	obj.put("name", rs.getString("subcompanyname"));
	obj.put("pid", rs.getString("supsubcomid"));
	obj.put("attr", attr);
	obj.put("numbers", numbers);
	obj.put("submenus", new JSONArray());
	
	//if( false){
		obj.put("hasChildren", false);
	//}
	
	map.put(id, obj);
}

//直接挂在分部的照片
String sql="select count(id) as cnt,parentid  from  AlbumPhotos where  parentid=subcompanyid and isFolder='0'  group by parentid  ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	String subid=RecordSet.getString("parentid");
	if(map.containsKey(subid)){
		map.get(subid).getJSONObject("numbers").put("data2count", RecordSet.getString("cnt"));
	}
}



//相册文件夹
sql=" select * from  AlbumPhotos where  isFolder='1' order by orderNum desc";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	obj=new JSONObject();
	String id=Util.null2String( RecordSet.getString("id")) ;
	JSONObject attr=new JSONObject();
	
	attr.put("groupid", id);
	attr.put("subcompanyid", Util.null2String( RecordSet.getString("subcompanyid")));
	
	JSONObject numbers=new JSONObject();
	numbers.put("data2count", Util.null2String( RecordSet.getString("photocount")));
	
	obj.put("id",id);
	obj.put("name", Util.null2String( RecordSet.getString("photoname")));
	obj.put("pid", Util.null2String( RecordSet.getString("parentid")));
	obj.put("attr", attr);
	obj.put("numbers", numbers);
	obj.put("submenus", new JSONArray());
	
	obj.put("icon", "/album/img/albumfolder_wev8.png");
	
	//if( false){
		obj.put("hasChildren", false);
	//}
	
	map.put(id, obj);
}



Iterator it=map.entrySet().iterator();
while(it.hasNext()){
	Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
	String k= entry.getKey();
	JSONObject v= entry.getValue();
	
	int pid=Util.getIntValue( v.getString("pid"),0);
	
	JSONObject p=map.get(""+pid);
	if(pid!=0){
		if(p!=null){
			p.put("hasChildren", true);
			((JSONArray)p.get("submenus")).put(v);
		}
	}else{
		arr.put(v);
	}
	
	
	if(p!=null){//资产(资产资料)计数
		JSONObject pObj= ((JSONObject)p.get("numbers"));
		JSONObject sObj= ((JSONObject)v.get("numbers"));
		int cnt= Util.getIntValue((String)sObj.get("data2count"),0)+Util.getIntValue((String)pObj.get("data2count"),0);
		pObj.put("data2count", ""+cnt);
	}
	
}

if("1".equals("abc")){//我的资产剔除没有资产的资产组
	JSONArray arr2=new JSONArray();
	for(int i=0;i<arr.length();i++){
		JSONObject o=(JSONObject) arr.get(i);
		JSONObject o2=o.getJSONObject("numbers");
		if(o2.getInt("data2count")>0){
			arr2.put(o);
		}
	}
	out.println(arr2.toString());
}else{
	out.print(arr.toString());
}
//System.out.println("treedata:\n"+arr.toString());

%>


