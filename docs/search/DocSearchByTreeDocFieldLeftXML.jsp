<?xml version="1.0" encoding="UTF-8"?>

<%@ page language="java" contentType="text/xml; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>

<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragrma","no-cache111111");
response.setDateHeader("Expires",0);
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />

<tree>
<%


String superiorFieldId=Util.null2String(request.getParameter("superiorFieldId"));
if(superiorFieldId.equals("")){
	superiorFieldId="0";
}



String currentTreeDocFieldId="";
String currentTreeDocFieldName="";
String currentSuperiorFieldId="";
String currentIsLast="";

StringBuffer treeStr = null;


DocTreeDocFieldComInfo.setTofirstRow();
	
while(DocTreeDocFieldComInfo.next()){

 	currentSuperiorFieldId = DocTreeDocFieldComInfo.getSuperiorFieldId();

    if(!currentSuperiorFieldId.equals(superiorFieldId))
			continue;

    treeStr = new StringBuffer();
 	currentTreeDocFieldId = DocTreeDocFieldComInfo.getId();
 	currentTreeDocFieldName = DocTreeDocFieldComInfo.getTreeDocFieldName();
 	currentIsLast = DocTreeDocFieldComInfo.getIsLast();


    treeStr.append("<tree ");
    //text
    treeStr.append("text=\"");
    treeStr.append(currentTreeDocFieldName);
    treeStr.append("\" ");


    //action
    treeStr.append("action=\"");
    treeStr.append("javascript:onClickTreeDocField("+currentTreeDocFieldId+");");
    treeStr.append("\" ");
		
    if(!"1".equals(currentIsLast)){
        //icon
        treeStr.append("icon=\"/images/treemaker/clsfld_wev8.gif\" ");
        //openIcon
        treeStr.append("openIcon=\"/images/treemaker/openfld_wev8.gif\" ");
        //src
        treeStr.append("src=\"DocSearchByTreeDocFieldLeftXML.jsp?superiorFieldId="+currentTreeDocFieldId+"\" ");
    }else{
        //icon
        treeStr.append("icon=\"/images/treemaker/link_wev8.gif\" ");
        //openIcon
        treeStr.append("openIcon=\"/images/treemaker/link_wev8.gif\" ");
	}
    //target
    treeStr.append("target=\"_self\" ");      
    treeStr.append(" />");
    out.print(treeStr.toString());        
}


%>
</tree>
