<%@ page import="weaver.docs.category.security.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCategoryManager" class="weaver.docs.category.SubCategoryManager" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<%
    int categoryid = Util.getIntValue(request.getParameter("categoryid"), -1);
    int categorytype = Util.getIntValue(request.getParameter("categorytype"), -1);
    int nodeid = Util.getIntValue(request.getParameter("node"), -1);
    ArrayList al2=(ArrayList)request.getSession().getAttribute("al2");
    ArrayList al3=(ArrayList)request.getSession().getAttribute("al3");
    
%>
<script>
var parentNode = null;
if(parent.tree!='undefined') {
    parentNode=parent.tree.getNode(<%=nodeid%>);
}
if (parentNode && parentNode.loaded!=true) {
    parentNode.loaded=true;
    var node
    var varScript = "node = tree.getNode(tree.getSelect().id);if( node && node.loaded!=true ){var str=new String(window.location);str=str.substring(0,str.lastIndexOf('/')+1);window.frames[0].location= str +'OpenCategory.jsp?categoryid='+node.categoryid+'&categorytype='+node.categorytype+'&node='+tree.getSelect().id;}";
<%
    if (categorytype == AclManager.CATEGORYTYPE_MAIN) {
        SubCategoryManager.setMainCategoryid(categoryid);
        SubCategoryManager.selectCategoryInfo();
        while (SubCategoryManager.next()) {
            int subid = SubCategoryManager.getCategoryid();
  	        String name = SubCategoryManager.getCategoryname();
  	       	name = 	Util.replace(
  	      			name
  	              	,"\"","&quot;",0);
  	        int fathersubid = SubCategoryManager.getSubCategoryid();
  	        if (fathersubid < 0) { 
  	        for(int a2=0;a2<al2.size();a2++)
  	        if(subid==Integer.parseInt(al2.get(a2).toString())){
%>
    node=parentNode.addChild(parent.Tree_LAST, "<%=name%>",'','','','',<%=subid%>,<%=AclManager.CATEGORYTYPE_SUB%>);
    node.setScript(varScript);
    node.addChild(0,'loading...');
<%}
            }
        }
    } else if (categorytype == AclManager.CATEGORYTYPE_SUB) {
        SubCategoryManager.selectCategoryInfo(categoryid);
        while(SubCategoryManager.next()){
  	        int subid = SubCategoryManager.getCategoryid();
  	        String name = SubCategoryManager.getCategoryname();
  	       	name = 	Util.replace(
  	      			name
  	              	,"\"","&quot;",0);
  	        for(int a2=0;a2<al2.size();a2++)
  	        if(subid==Integer.parseInt(al2.get(a2).toString())){
%>
    node=parentNode.addChild(parent.Tree_LAST, "<%=name%>",'','','','',<%=subid%>,<%=AclManager.CATEGORYTYPE_SUB%>);
    node.setScript(varScript);
    node.addChild(0,'loading...');
<%}
        }
        SecCategoryManager.setSubcategoryid(categoryid);
        SecCategoryManager.selectCategoryInfo();
        while(SecCategoryManager.next()){
            int secid = SecCategoryManager.getId();
            String name = SecCategoryManager.getCategoryname();
           	name = 	Util.replace(
          			name
                  	,"\"","&quot;",0);
  	        for(int a3=0;a3<al3.size();a3++)
  	        if(secid==Integer.parseInt(al3.get(a3).toString())){                  	
%>
    node=parentNode.addChild(parent.Tree_LAST, "<%=name%>",'','',parent.tree.fileImg,parent.tree.fileImg,<%=secid%>,<%=AclManager.CATEGORYTYPE_SEC%>);
    node.setScript('selectCategory(tree.getSelect().id)');
<%}
        }
    }
%>
    parentNode.delChild(0);
}
</script>