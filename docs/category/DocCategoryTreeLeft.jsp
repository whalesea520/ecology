
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
String subcompanyId = Util.null2String(request.getParameter("subCompanyId"));
String categoryname = Util.null2String(request.getParameter("categoryname"));
String hasRightSub = Util.null2String(session.getAttribute("hasRightSub"));
boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
int defsub=-1;
if(!hasRightSub.equals("")){
	 if(hasRightSub.indexOf(',')>-1){  
	      defsub=Util.getIntValue(hasRightSub.substring(0,hasRightSub.indexOf(',')),-1);
       }else{
          defsub=Util.getIntValue(hasRightSub,-1);
       }
	
}
MultiAclManager am = new MultiAclManager();
if(isUseDocManageDetach){
am.setHasRightSub(subcompanyId);
}else{
am.setHasRightSub(hasRightSub);
}

MultiCategoryTree tree = am.getPermittedTree(user.getUID(), user.getType(), Util.getIntValue(user.getSeclevel(),0), -1,categoryname,Util.getIntValue(subcompanyId,defsub));
out.println(tree.getTreeCategories().toString());
%>
