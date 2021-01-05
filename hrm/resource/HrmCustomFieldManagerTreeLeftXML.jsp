<%@ page language="java" contentType="text/xml; charset=UTF-8" %><?xml version="1.0" encoding="UTF-8"?>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

String parentid = Util.null2String(request.getParameter("parentid"));
if(parentid.length()==0) parentid="0";
%>
<tree>
<%
	StringBuffer treeStr = new StringBuffer();
	String sql = " select * from cus_treeform where scope='HrmCustomFieldByInfoType' ";
	if(parentid.length()>0)
	{
		sql += " and parentid= "+parentid;
	}
	sql+=" order by scopeorder asc ";
	RecordSet.executeSql(sql);
 	while(RecordSet.next()){
 		treeStr = new StringBuffer();
 		String mainname = RecordSet.getString("formlabel");
 		String mainid = RecordSet.getString("id");
 		if("-1".equals(mainid)){
 			mainname = SystemEnv.getHtmlLabelName(1361,user.getLanguage());
 		}else if("1".equals(mainid)){
 			mainname = SystemEnv.getHtmlLabelName(15687,user.getLanguage());
 		}else if("3".equals(mainid)){
 			mainname = SystemEnv.getHtmlLabelName(15688,user.getLanguage());
 		}
 		
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
    //src
    treeStr.append("src=\"HrmCustomFieldManagerTreeLeftXML.jsp?parentid="+mainid+"\" ");
    
    treeStr.append(" />");
    
    out.println(treeStr.toString());
 	}
%>
</tree>