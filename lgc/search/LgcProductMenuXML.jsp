<%@ page language="java" contentType="text/xml; charset=UTF-8" %><?xml version="1.0" encoding="UTF-8"?>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*" %>
<%@page import="java.net.URLDecoder"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

int parentid = Util.getIntValue(request.getParameter("parentid"),0);
String searchName = URLDecoder.decode(Util.null2String(request.getParameter("searchName")),"UTF-8");
%>
<tree>
<%
	StringBuffer treeStr = new StringBuffer();
	String sql = "";
	if(!searchName.equals("")){
		sql = " select id,assetcount, assortmentname ,(select count(*) from LgcAssetAssortment where supassortmentid = t1.id) child_count"+
		" from LgcAssetAssortment t1 where assortmentname like '%"+searchName+"%' order by id asc";
	}else{
		sql = " select id,assetcount, assortmentname ,(select count(*) from LgcAssetAssortment where supassortmentid = t1.id) child_count"+
		" from LgcAssetAssortment t1 where supassortmentid="+parentid+" order by id asc";
	}
	
	RecordSet.executeSql(sql);
 	while(RecordSet.next()){
 		treeStr = new StringBuffer();
 		String mainname = RecordSet.getString("assortmentname");
 		int _count = RecordSet.getInt("assetcount");
 		String mainid = RecordSet.getString("id");
 		
    //第一层
    treeStr.append("<tree ");
    //text
    treeStr.append("text=\"");
    treeStr.append(
    Util.replace(
    Util.replace(
		Util.replace(
		Util.replace(
		Util.replace(
		Util.toScreen(mainname,user.getLanguage())
    		,"<","&lt;",0)
    		,">","&gt;",0)
    		,"&","&amp;",0)
    		,"'","&apos;",0)
    		,"\"","&quot;",0)
    		
    );
    treeStr.append("\" ");
    //action
    treeStr.append("action=\"");
    treeStr.append("javascript:onClickCustomField("+mainid+");");
    treeStr.append("\" ");
    //icon
    //treeStr.append("icon=\"/images/treeimages/book1_close_wev8.gif\" ");
    //openIcon
    //treeStr.append("openIcon=\"/images/treeimages/book1_open_wev8.gif\" ");
    //target
    treeStr.append("target=\"_self\" ");
  	//_id
    treeStr.append("_id=\""+mainid+"\" ");
    //src
    if(RecordSet.getInt("child_count") > 0){
    	treeStr.append("src=\"LgcProductMenuXML.jsp?parentid="+mainid+"\" ");
    }
    //num
    treeStr.append("num=\"" + _count + "\" ");
    treeStr.append(" />");
    
    out.println(treeStr.toString());
 	}
%>
</tree>