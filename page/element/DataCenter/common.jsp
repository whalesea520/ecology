<%@page import="java.util.ArrayList"%>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
String uid = user.getUID()+"";

String openlink ="1",todo = "on",todocolor = "#33A3FF",asset="on",assetcolor="#FFD200",cowork="on",coworkcolor="#FD9000",proj="on",projcolor="#CB61FE",
customer="on",customercolor="#6871E3",blog="on",blogcolor="#56DE73",mydoc="on",mydoccolor="#FD2677",meetting="on",meettingcolor="#6871E3",workplan="on",workplancolor="#CB61FE";
List list = new ArrayList();

String strSettingSql = "select id from DataCenterUserSetting where eid = '"+eid+"' and userid="+uid;
rs.execute(strSettingSql);
if(!rs.next()){
	String insertStr = "";
	
	insertStr = "insert into DataCenterUserSetting (userid,eid,openlink,todo,todocolor,asset,assetcolor,cowork,coworkcolor,proj,projcolor,customer,customercolor,blog,blogcolor,mydoc,mydoccolor,meetting,meettingcolor,workplan,workplancolor) values ('"+uid+"','"+eid+"','"+openlink+"','"+todo+"','"+todocolor+"','"+asset+"','"+assetcolor+"','"+cowork+"','"+coworkcolor+"','"+proj+"','"+projcolor+"','"+customer+"','"+customercolor+"','"+blog+"','"+blogcolor+"','"+mydoc+"','"+mydoccolor+"','"+meetting+"','"+meettingcolor+"','"+workplan+"','"+workplancolor+"')";
	rs2.execute("select userid from DataCenterUserSetting where eid = '"+eid+"' and usertype=3");
	if(rs2.next()){
		String t_userid = rs2.getString("userid");
		insertStr = "insert into DataCenterUserSetting (userid,eid,openlink,todo,todocolor,asset,assetcolor,cowork,coworkcolor,proj,projcolor,customer,customercolor,blog,blogcolor,mydoc,mydoccolor,meetting,meettingcolor,workplan,workplancolor) select "+uid+",eid,openlink,todo,todocolor,asset,assetcolor,cowork,coworkcolor,proj,projcolor,customer,customercolor,blog,blogcolor,mydoc,mydoccolor,meetting,meettingcolor,workplan,workplancolor from DataCenterUserSetting where eid ="+eid+" and userid = "+t_userid;
	}
	rs.execute(insertStr);
}

String selectSql = "select openlink,todo,todocolor,asset,assetcolor,cowork,coworkcolor,proj,projcolor,customer,customercolor,blog,blogcolor,mydoc,mydoccolor,meetting,meettingcolor,workplan,workplancolor from DataCenterUserSetting where eid = '"+eid+"' and userid="+uid;
rs2.execute(selectSql);
if(rs2.next()){
	openlink=Util.null2String(rs2.getString("openlink"));
	todo = Util.null2String(rs2.getString("todo"));
	todocolor = Util.null2String(rs2.getString("todocolor"));
	asset = Util.null2String(rs2.getString("asset"));
	assetcolor = Util.null2String(rs2.getString("assetcolor"));
	cowork = Util.null2String(rs2.getString("cowork"));
	coworkcolor = Util.null2String(rs2.getString("coworkcolor"));
	proj = Util.null2String(rs2.getString("proj"));
	projcolor = Util.null2String(rs2.getString("projcolor"));
	customer = Util.null2String(rs2.getString("customer"));
	customercolor = Util.null2String(rs2.getString("customercolor"));
	blog = Util.null2String(rs2.getString("blog"));
	blogcolor = Util.null2String(rs2.getString("blogcolor"));
	mydoc = Util.null2String(rs2.getString("mydoc"));
	mydoccolor = Util.null2String(rs2.getString("mydoccolor"));
	meetting =  Util.null2String(rs2.getString("meetting"));
	meettingcolor =  Util.null2String(rs2.getString("meettingcolor"));
	workplan =  Util.null2String(rs2.getString("workplan"));
	workplancolor =  Util.null2String(rs2.getString("workplancolor"));
	list.add("todo,"+todo+","+todocolor+",1207");
	list.add("asset,"+asset+","+assetcolor+",30044");
	list.add("cowork,"+cowork+","+coworkcolor+",17855");
	list.add("proj,"+proj+","+projcolor+",1211");
	list.add("customer,"+customer+","+customercolor+",6059");
	list.add("blog,"+blog+","+blogcolor+",26468");
	list.add("mydoc,"+mydoc+","+mydoccolor+",1212");
	list.add("meetting,"+meetting+","+meettingcolor+",2102");
	list.add("workplan,"+workplan+","+workplancolor+",18480");
}
%>
