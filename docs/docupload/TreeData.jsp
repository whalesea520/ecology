
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.docs.multidocupload.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="DocCatagoryMenuUtil" class="weaver.docs.multidocupload.DocCatagoryMenuUtil" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	ArrayList mainids=new ArrayList();
	ArrayList subids=new ArrayList();
	ArrayList secids=new ArrayList();

	AclManager am = new AclManager();
		
	CategoryTree tree = am.getPermittedTree(user.getUID(), user.getType(), Integer.parseInt(user.getSeclevel()), AclManager.OPERATION_CREATEDOC);
	Vector alldirs = tree.allCategories;

	for (int i=0; i < alldirs.size(); i++){
		CommonCategory temp = (CommonCategory)alldirs.get(i);

		if (temp.type == AclManager.CATEGORYTYPE_MAIN) 	{
			mainids.add(Integer.toString(temp.id));
		} 
		else if (temp.type == AclManager.CATEGORYTYPE_SEC) 	{
			secids.add(Integer.toString(temp.id));	
		}
		else if(temp.type == AclManager.CATEGORYTYPE_SUB){
			subids.add(Integer.toString(temp.id));
		}
	}


	String node=request.getParameter("node");

	ArrayList menus = DocCatagoryMenuUtil.getDocCategoryMenuObj(node,mainids,subids,secids);
	
	String printStr="[";
	String tempText=null;
	for(int i=0;i<menus.size();i++){
		DocCatagoryMenuBean dmb = (DocCatagoryMenuBean)menus.get(i);
		if(dmb!=null) {
			if(i==0) {
				printStr+="{";			
			} else {
				printStr+=",{";
			}
			tempText=dmb.getText();
			tempText=Util.null2String(tempText);
			tempText=Util.StringReplace(tempText,"\"","\\\"");
			printStr+="\"cls\":\""+dmb.getCls()+"\",";
			printStr+="\"draggable\":"+dmb.isDraggable()+",";
			printStr+="\"id\":\""+dmb.getId()+"\",";
			printStr+="\"leaf\":"+dmb.isLeaf()+",";
			printStr+="\"text\":\""+tempText+"\"";
			printStr+="}";
		}
	}
	printStr+="]";
	
	out.println(printStr);
	
	
	/*JSONArray jsonObject = JSONArray.fromObject(menus);
	String menuString="";
	try {
		menuString = jsonObject.toString();
	} catch (Exception e) {
		menuString = "Error";
	}
	out.println(menuString);*/
%>



