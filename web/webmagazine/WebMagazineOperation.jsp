
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WebMagazine:Main", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
Calendar now = Calendar.getInstance();
String currenttime = Util.add0(now.getTime().getHours(), 2) +":"+
                     Util.add0(now.getTime().getMinutes(), 2) +":"+
                     Util.add0(now.getTime().getSeconds(), 2) ;

String isDialog = Util.null2String(request.getParameter("isdialog"));
String to = Util.null2String(request.getParameter("to"));


String method = Util.null2String(request.getParameter("method"));
int subcompanyId = Util.getIntValue(request.getParameter("subcompanyid"),0);
String sql = "";
if(method.equals("TypeAdd")){
	String name = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("name"))),"'","''");
	String remark = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("remark"))),"'","''");
	int typeID = 0;
	if(subcompanyId!=0){
		sql = "insert into WebMagazineType(name,remark,subcompanyid) values('" + name + "','" + remark + "','"+subcompanyId+"')";
	}else{
		sql = "insert into WebMagazineType(name,remark) values('" + name + "','" + remark + "')";
	}
	
	RecordSet.executeSql(sql);
	sql = "select max(id) as id from WebMagazineType";
	RecordSet.executeSql(sql);
	if (RecordSet.next()) typeID = Util.getIntValue(RecordSet.getString("id"),0);
	log.insSysLogInfo(user, typeID, name, sql, "273", "1", 0, request.getRemoteAddr());
	if(isDialog.equals("1")){
		response.sendRedirect("WebMagazineTypeAdd.jsp?isclose=1&typeID=" + typeID);
	}else{
		response.sendRedirect("WebMagazineList.jsp?typeID=" + typeID);
	}
	return;
}else
if(method.equals("TypeDel")){
	int typeID = Util.getIntValue(request.getParameter("typeID"),0);
	sql = "delete WebMagazineType where id = " + typeID;
	String name = "";
	RecordSet.executeSql("select name from WebMagazineType where id = " + typeID);
	if(RecordSet.next()){
		name = RecordSet.getString(1);
	}
	log.insSysLogInfo(user, typeID, name, sql, "273", "3", 0, request.getRemoteAddr());
	RecordSet.executeSql(sql);
	response.sendRedirect("WebMagazineTypeList.jsp");
	return;
}else
if(method.equals("TypeUpdate")){
	int typeID = Util.getIntValue(request.getParameter("typeID"),0);
	String name = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("name"))),"'","''");
	String remark = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("remark"))),"'","''");
	if(subcompanyId!=0){
		sql = "update WebMagazineType set name = '" + name + "',remark = '" + remark + "',subcompanyid='"+subcompanyId+"' where id = " + typeID;
	}else{
		sql = "update WebMagazineType set name = '" + name + "',remark = '" + remark + "' where id = " + typeID;
	}
	log.insSysLogInfo(user, typeID, name, sql, "273", "2", 0, request.getRemoteAddr());
	RecordSet.executeSql(sql);
	if(isDialog.equals("1")){
		response.sendRedirect("WebMagazineTypeEdit.jsp?isclose=1&typeID=" + typeID);
	}else{
		response.sendRedirect("WebMagazineList.jsp?typeID=" + typeID);
	}
	return;
}else
if(method.equals("MagazineAdd")){
	String releaseYear = Util.null2String(request.getParameter("releaseYear"));
	String name = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("name"))),"'","''");
	String HeadDoc = Util.null2String(request.getParameter("HeadDoc"));
	int typeID =  Util.getIntValue(request.getParameter("typeID"),0);
	int totaldetail =  Util.getIntValue(request.getParameter("totaldetail"),0);
	int id = 0 ;
	sql = "insert into WebMagazine(typeID,releaseYear,name,docID,createDate) values(" + typeID + ",'" + releaseYear + "','" + name + "','"+HeadDoc+"','"+currentdate+"')";
	String logsql = sql;
	RecordSet.executeSql(sql);
	sql = "select max(id) as id from WebMagazine";
	RecordSet.executeSql(sql);
	if (RecordSet.next()) id = Util.getIntValue(RecordSet.getString("id"),0);
	String group = "";
	String groupIsView = "";
	String groupDocs = ""; 
	for (int i=0;i<totaldetail;i++)
	{
		group = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("node_"+i+"_group"))),"'","''");
		groupIsView = ""+Util.getIntValue(request.getParameter("node_"+i+"_isview"),0);
		groupDocs = request.getParameter("node_"+i+"_docs");
		
		if(!group.equals("")){
			sql = "insert into WebMagazineDetail(mainID,name,isView,docID) values(" + id + ",'" + group + "','"+groupIsView+"','"+groupDocs+"')";
			logsql = logsql + ";"+sql;
			RecordSet.executeSql(sql);
		}
	}
	log.insSysLogInfo(user, id, releaseYear+name, logsql, "273", "1", 0, request.getRemoteAddr());
	if(isDialog.equals("1")){
		response.sendRedirect("WebMagazineAdd.jsp?typeID="+typeID+"&to="+to+"&isclose=1&id=" + id);
	}else{
		response.sendRedirect("WebMagazineEdit.jsp?id=" + id);
	}
	return;
}else
if(method.equals("MagazineDel")){
	int typeID =  Util.getIntValue(request.getParameter("typeID"),0);
	String id = Util.null2String(request.getParameter("id"));
	RecordSet1.executeSql("select id,releaseYear,name from WebMagazine where id in("+id+")");
	sql = "delete WebMagazine where id in( " + id+")";
	String logsql = sql;
	RecordSet.executeSql(sql);
	sql = "delete WebMagazineDetail where mainID in( " + id+")";
	logsql = logsql + ";"+sql;
	RecordSet.executeSql(sql);
	while(RecordSet1.next()){
		log.insSysLogInfo(user, RecordSet1.getInt(1), RecordSet1.getString(2)+RecordSet1.getString(3), logsql, "273", "3", 0, request.getRemoteAddr());
	}
	response.sendRedirect("WebMagazineList.jsp?typeID=" + typeID);
	return;
}else
if(method.equals("MagazineUpdate")){
	String optype = Util.null2String(request.getParameter("optype"));
	String releaseYear = Util.null2String(request.getParameter("releaseYear"));
	String name = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("name"))),"'","''");
	String HeadDoc = Util.null2String(request.getParameter("HeadDoc"));
	int typeID =  Util.getIntValue(request.getParameter("typeID"),0);
	int totaldetail =  Util.getIntValue(request.getParameter("tableMax"),0);
	int id = Util.getIntValue(request.getParameter("id"),0);
	sql = "update WebMagazine set  releaseYear='" + releaseYear + "',name='" + name + "',docID='"+HeadDoc+"' where id = " + id ;
	String logsql = sql;
	RecordSet.executeSql(sql);
	String group = "";
	String groupIsView = "";
	String groupDocs = ""; 
	sql = "delete WebMagazineDetail where mainID = " + id;
	logsql = logsql + ";"+sql;
	RecordSet.executeSql(sql);
	for (int i=0;i<=totaldetail;i++)
	{
		group = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("node_"+i+"_group"))),"'","''");
		groupIsView = ""+Util.getIntValue(request.getParameter("node_"+i+"_isview"),0);
		groupDocs = Util.null2String(request.getParameter("node_"+i+"_docs"));
		if(!group.equals("")){		
			sql = "insert into WebMagazineDetail(mainID,name,isView,docID) values(" + id + ",'" + group + "','"+groupIsView+"','"+groupDocs+"')";
			logsql = logsql + ";"+sql;
			RecordSet.executeSql(sql);
		}
	}
	log.insSysLogInfo(user, id, releaseYear+name, logsql, "273", "2", 0, request.getRemoteAddr());
	//response.sendRedirect("WebMagazineView.jsp?id=" + id);
	if(isDialog.equals("1")){
		response.sendRedirect("WebMagazineEdit.jsp?optype="+optype+"&typeID="+typeID+"&to="+to+"&isclose=1&id=" + id);
	}else{ 
		response.sendRedirect("WebMagazineEdit.jsp?optype="+optype+"&id=" + id);
	}
	return;
}  else if("typedel".equals(method)){
	String typeid = Util.null2String(request.getParameter("typeid"));
	RecordSet1.executeSql("select id,name from WebMagazineType where id in("+typeid+")");
	// del WebMagazineType	
	sql = "delete WebMagazineType where id in("+typeid+")";
	String logsql = sql;
	RecordSet.executeSql(sql);

	// del WebMagazineDetail
	RecordSet.executeSql("select id from WebMagazine where typeID in("+typeid+")");
	while(RecordSet.next()){
		int tempid=RecordSet.getInt("id");
		sql = "delete WebMagazineDetail where mainID="+tempid;
		logsql = logsql + ";"+sql;
		RecordSet1.executeSql(sql);
	}
	// del WebMagazine
	sql = "delete WebMagazine where typeID in ("+typeid+")";
	logsql = logsql + ";"+sql;
	RecordSet.executeSql(sql);
	while(RecordSet1.next()){
		log.insSysLogInfo(user, RecordSet1.getInt(1), RecordSet1.getString(2), logsql, "273", "3", 0, request.getRemoteAddr());
	}
	response.sendRedirect("WebMagazineTypeList.jsp"); 
	return;

} else if ("del".equals(method)){
	String id = Util.null2String(request.getParameter("id"));
	String typeID = Util.null2String(request.getParameter("typeID"));
	RecordSet1.executeSql("select id,releaseYear,name from WebMagazine where id ="+id);
	// del WebMagazineDetail
	sql = "delete WebMagazineDetail where mainID="+id;
	String logsql = sql;
	RecordSet.executeSql(sql);
	// del WebMagazine
	sql = "delete WebMagazine where id="+id;
	logsql = logsql + ";"+sql;
	RecordSet.executeSql(sql);
	while(RecordSet1.next()){
		log.insSysLogInfo(user, RecordSet1.getInt(1), RecordSet1.getString(2)+RecordSet1.getString(3), logsql, "273", "3", 0, request.getRemoteAddr());
	}
	response.sendRedirect("WebMagazineList.jsp?typeID="+typeID); 
	return;

}

%>
