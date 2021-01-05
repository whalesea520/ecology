
<%@ page language="java" contentType="text/xml; charset=UTF-8" %><?xml version="1.0" encoding="UTF-8"?>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.docs.category.security.*"%>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="sharemanager" class="weaver.share.ShareManager" scope="page"/>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

String maincategory=Util.null2String(request.getParameter("maincategory"));
if(maincategory.equals("0")) maincategory="";
String subcategory=Util.null2String(request.getParameter("subcategory"));
if(subcategory.equals("0")) subcategory="";
String seccategory=Util.null2String(request.getParameter("seccategory"));
if(seccategory.equals("0")) seccategory="";
String subcompanyId = Util.null2String(String.valueOf(session.getAttribute("maincategory_subcompanyid")));
if(subcompanyId.equals("0")) subcompanyId = "";
%>
<tree>
<%
StringBuffer treeStr = new StringBuffer();

if("".equals(maincategory)&&"".equals(subcategory)){
	
	MainCategoryComInfo.setTofirstRow();
	
 	while(MainCategoryComInfo.next()){
 		treeStr = new StringBuffer();
 		
 		String mainname=MainCategoryComInfo.getMainCategoryname();
 		String mainid = MainCategoryComInfo.getMainCategoryid();
 		if(!subcompanyId.equals("")){
 			if(!subcompanyId.equals(MainCategoryComInfo.getMainCategorysubcompanyid(mainid))){
 				continue;
 			}
 		}
        //主目录
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
        treeStr.append("javascript:onClickCategory("+mainid+","+0+");");
        treeStr.append("\" ");
        //icon
       // treeStr.append("icon=\"/images/treeimages/book1_close_wev8.gif\" ");
        //openIcon
        //treeStr.append("openIcon=\"/images/treeimages/book1_open_wev8.gif\" ");
        //target
        treeStr.append("target=\"_self\" ");
        //_id
        treeStr.append("_id=\""+mainid+"\" ");
        //src
        treeStr.append("src=\"DocCategoryTreeLeftXML.jsp?maincategory="+mainid+"\" ");
        
        treeStr.append(" />");
        
        out.println(treeStr.toString());
 	}

} else if(!"".equals(maincategory)) {
	
	SubCategoryComInfo.setTofirstRow();
	
	while(SubCategoryComInfo.next()){
 		treeStr = new StringBuffer();
 		
 		String tempmainid=SubCategoryComInfo.getMainCategoryid();
 		if(!tempmainid.equals(maincategory))
 			continue;
 		String subname=SubCategoryComInfo.getSubCategoryname();
 		String subid = SubCategoryComInfo.getSubCategoryid();
 		
        //分目录
        treeStr.append("<tree ");
        //text
        treeStr.append("text=\"");
        subname=Util.replace(subname,"&quot;","\"",0);
        subname=Util.replace(subname,"&lt;","<",0);
        subname=Util.replace(subname,"&gt;",">",0);
		subname=Util.replace(subname,"&apos;","'",0);
        treeStr.append(
        		subname
        );
        treeStr.append("\" ");
        //action
        treeStr.append("action=\"");
        treeStr.append("javascript:onClickCategory("+subid+","+1+");");
        treeStr.append("\" ");
        //icon
       // treeStr.append("icon=\"/images/treeimages/hfold_close_wev8.gif\" ");
        //openIcon
      //  treeStr.append("openIcon=\"/images/treeimages/hfold_open_wev8.gif\" ");
        //target
        treeStr.append("target=\"_self\" ");
        
        //_id
        treeStr.append("_id=\""+subid+"\" ");
        
        //src
        treeStr.append("src=\"DocCategoryTreeLeftXML.jsp?subcategory="+subid+"\" ");
        
        treeStr.append(" />");
        
        out.println(treeStr.toString());
 	}
	
} else if(!"".equals(subcategory)){
	
	SecCategoryComInfo.setTofirstRow();
	
	while(SecCategoryComInfo.next()){
 		treeStr = new StringBuffer();
 		
        String cursubid = SecCategoryComInfo.getSubCategoryid();
        if(!cursubid.equals(subcategory))
			continue;
        
 		String secname=SecCategoryComInfo.getSecCategoryname();
        String secid = SecCategoryComInfo.getSecCategoryid();

        //分目录
        treeStr.append("<tree ");
        //text
        treeStr.append("text=\"");
         secname=Util.replace(secname,"&quot;","\"",0);
        secname=Util.replace(secname,"&lt;","<",0);
        secname=Util.replace(secname,"&gt;",">",0);
		secname=Util.replace(secname,"&apos;","'",0);
        treeStr.append(
        		secname
        );
        treeStr.append("\" ");
        //action
        treeStr.append("action=\"");
        treeStr.append("javascript:onClickCategory("+secid+","+2+");");
        treeStr.append("\" ");
        //icon
       // treeStr.append("icon=\"/images/treeimages/fold_wev8.gif\" ");
        //openIcon
       // treeStr.append("openIcon=\"/images/treeimages/open_wev8.gif\" ");
        //target
        treeStr.append("target=\"_self\" ");
        
        //_id
        treeStr.append("_id=\""+secid+"\" ");
        
        //src
        //treeStr.append("src=\"DocSummaryTreeLeftXML.jsp?seccategory="+secid+"\" ");
        
        treeStr.append(" />");
        
        out.println(treeStr.toString());
	}
}
%>
</tree>