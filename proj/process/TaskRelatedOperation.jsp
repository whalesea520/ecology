
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />

<%
String method = Util.null2String(request.getParameter("method"));
int taskID = Util.getIntValue(Util.null2String(request.getParameter("taskID")), -1);
int projID = Util.getIntValue(Util.null2String(request.getParameter("ProjID")), -1);
String sql = "";
ArrayList arrList = new ArrayList();

/* Required Workflow */
if(method.equals("addRequiredWF")){
	sql = "SELECT workflowId FROM Prj_Task_needwf WHERE taskId="+taskID;
	RecordSet.executeSql(sql);
	arrList.clear();
	while(RecordSet.next()){
		arrList.add(new Integer(RecordSet.getInt("workflowId")));
	}
	String wfIDs = Util.null2String(request.getParameter("wfIDs"));
	String[] wfIDList = Util.TokenizerString2(wfIDs,",");
	for(int i=0;i<wfIDList.length;i++){
		int wfID = Util.getIntValue(wfIDList[i], -1);
		if(wfID!=-1 && !arrList.contains(new Integer(wfID))){
			sql = "INSERT INTO Prj_Task_needwf (taskId,workflowId,isNecessary,isTempletTask) VALUES ("+taskID+","+wfID+",'0','0')";
			RecordSet.executeSql(sql);
		}
	}
}
if(method.equals("delRequiredWF")){
	int requiredWFID = Util.getIntValue(Util.null2String(request.getParameter("requiredWFID")), -1);
	sql = "DELETE FROM Prj_Task_needwf WHERE taskId="+taskID+" AND workflowId="+requiredWFID;
	RecordSet.executeSql(sql);
}
if(method.equals("modifyRequiredWFN")){
	int wfID = Util.getIntValue(Util.null2String(request.getParameter("wfID")), -1); 
	String isNecessary = Util.null2String(request.getParameter("isNecessary"));
	sql = "UPDATE Prj_Task_needwf SET isNecessary='"+isNecessary+"' WHERE taskId="+taskID+" AND workflowId="+wfID;
	RecordSet.executeSql(sql);
}


/* Required Document */
if(method.equals("addRequiredDoc")){
	sql = "SELECT docSecCategory FROM Prj_Task_needdoc WHERE taskId="+taskID;
	RecordSet.executeSql(sql);
	arrList.clear();
	while(RecordSet.next()){
		arrList.add(new Integer(RecordSet.getInt("docSecCategory")));
	}
	int secID = Util.getIntValue(Util.null2String(request.getParameter("secID")), -1);
	int subID = -1;
	int mainID = -1;
	if(!arrList.contains(new Integer(secID))){
		subID = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(String.valueOf(secID)));
		mainID = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(String.valueOf(subID)));
		sql = "INSERT INTO Prj_Task_needdoc (taskId,docMainCategory,docSubCategory,docSecCategory,isNecessary,isTempletTask) VALUES ("+taskID+","+mainID+","+subID+","+secID+",'0','0')";
		out.println(sql);
		RecordSet.executeSql(sql);
	}
}
if(method.equals("delRequiredDoc")){
	int secID = Util.getIntValue(Util.null2String(request.getParameter("secID")), -1);
	sql = "DELETE FROM Prj_Task_needdoc WHERE taskId="+taskID+" AND docSecCategory="+secID;
	RecordSet.executeSql(sql);
}
if(method.equals("modifyRequiredDocN")){
	int secID = Util.getIntValue(Util.null2String(request.getParameter("secID")), -1); 
	String isNecessary = Util.null2String(request.getParameter("isNecessary"));
	sql = "UPDATE Prj_Task_needdoc SET isNecessary='"+isNecessary+"' WHERE taskId="+taskID+" AND docSecCategory="+secID;
	RecordSet.executeSql(sql);
}


/* Referenced Document */
if(method.equals("addReferencedDoc")){
	sql = "SELECT docId FROM Prj_Task_referdoc WHERE taskId="+taskID;
	RecordSet.executeSql(sql);
	arrList.clear();
	while(RecordSet.next()){
		arrList.add(new Integer(RecordSet.getInt("docId")));
	}
	String docIDs = Util.null2String(request.getParameter("docIDs"));
	String[] docIDList = Util.TokenizerString2(docIDs,",");
	for(int i=0;i<docIDList.length;i++){
		int docID = Util.getIntValue(docIDList[i], -1);
		if(docID!=-1 && !arrList.contains(new Integer(docID))){
			sql = "INSERT INTO Prj_Task_referdoc (taskId,docId,isTempletTask) VALUES ("+taskID+","+docID+",'0')";
			RecordSet.executeSql(sql);
		}
	}
}
if(method.equals("delReferencedDoc")){
	int docID = Util.getIntValue(Util.null2String(request.getParameter("docID")), -1);
	sql = "DELETE FROM Prj_Task_referdoc WHERE taskId="+taskID+" AND docId="+docID;
	RecordSet.executeSql(sql);
}


response.sendRedirect("ViewTask.jsp?taskrecordid="+taskID);
%>