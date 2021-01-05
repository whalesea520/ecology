
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>

<jsp:useBean id="ModeTreeFieldComInfo" class="weaver.formmode.setup.ModeTreeFieldComInfo" scope="page" />
<jsp:useBean id="ModeTreeFieldManager" class="weaver.formmode.setup.ModeTreeFieldManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<%

String operation=Util.null2String(request.getParameter("operation"));

String treeFieldId=Util.null2String(request.getParameter("id"));
String treeFieldName = Util.fromScreen(request.getParameter("treeFieldName"),user.getLanguage());
String superFieldId=Util.null2String(request.getParameter("superFieldId"));
String showOrder=Util.null2String(request.getParameter("showOrder"));

String treeFieldDesc=Util.null2String(request.getParameter("treeFieldDesc"));

String allSuperFieldId="";
String level="0";
String isLast="0";
if(superFieldId.equals("")||superFieldId.equals(DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID)){
	superFieldId=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID;
	allSuperFieldId=superFieldId;
	level="1";
}else{
	allSuperFieldId=ModeTreeFieldComInfo.getAllSuperFieldId(superFieldId)+","+superFieldId;
	level=String.valueOf(Integer.parseInt(ModeTreeFieldComInfo.getLevel(superFieldId))+1);
}

if(treeFieldName!=null){
	treeFieldName=treeFieldName.trim();
}

if(operation.equals("RootEditSave")){
	ModeTreeFieldManager.setTreeFieldName(treeFieldName);
	ModeTreeFieldManager.setTreeFieldId(treeFieldId);
	ModeTreeFieldManager.updateRoot();
	
	ModeTreeFieldComInfo.removeDocTreeDocFieldCache();
    response.sendRedirect("ModeSettings.jsp");
	return;
 }else if(operation.equals("AddSave")){
    //将上级是否末级改为否
	ModeTreeFieldManager.updateDataOfNewSuperiorField(superFieldId);
	ModeTreeFieldManager.setTreeFieldName(treeFieldName);
	ModeTreeFieldManager.setSuperFieldId(superFieldId);
	ModeTreeFieldManager.setAllSuperFieldId(allSuperFieldId);
	ModeTreeFieldManager.setLevel(level);
	ModeTreeFieldManager.setShowOrder(showOrder);
	ModeTreeFieldManager.setTreeFieldDesc(treeFieldDesc);
    
	ModeTreeFieldManager.insertTreeField();
	
	treeFieldId=ModeTreeFieldManager.getTreeFieldId();
    //清除缓存中的内容
    ModeTreeFieldComInfo.removeDocTreeDocFieldCache();
    response.sendRedirect("ModeSettings.jsp?treeFieldId="+treeFieldId);
	return;
 }else if(operation.equals("EditSave")){
	 ModeTreeFieldManager.setTreeFieldId(treeFieldId);
	 ModeTreeFieldManager.setTreeFieldName(treeFieldName);
	 ModeTreeFieldManager.setLevel(level);
	 ModeTreeFieldManager.setShowOrder(showOrder);
	 ModeTreeFieldManager.setTreeFieldDesc(treeFieldDesc);
	 ModeTreeFieldManager.setSuperFieldId(superFieldId);
	 ModeTreeFieldManager.updateTreeField();
	 
	 ModeTreeFieldComInfo.removeDocTreeDocFieldCache();
	 response.sendRedirect("ModeSettings.jsp?treeFieldId="+treeFieldId);
 }else if(operation.equals("DelTree")){
	 ModeTreeFieldManager.setTreeFieldId(treeFieldId);
	 String err = ModeTreeFieldManager.whetherCanDelete();
	 String param = treeFieldId;
	 if(err.equals("")){
	 	ModeTreeFieldManager.deleteTreeField();
	 	ModeTreeFieldComInfo.removeDocTreeDocFieldCache();
	 	param = superFieldId;
	 }
	 response.sendRedirect("ModeSettings.jsp?treeFieldId="+param);
 }
 
%>
