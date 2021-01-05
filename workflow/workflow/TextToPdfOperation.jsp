<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<%      
        String method=Util.null2String(request.getParameter("method"));
		String id=Util.null2String(request.getParameter("id"));
        String operationtype=Util.null2String(request.getParameter("operationtype"));
		String filetopdffile=Util.null2String(request.getParameter("filetopdffile"));
		String filetopdf=Util.null2String(request.getParameter("filetopdf"));
		String filemaxsize=Util.null2String(request.getParameter("filemaxsize"));
		String checktype=Util.null2String(request.getParameter("checktype"));
		int workflowId=Util.getIntValue(Util.null2String(request.getParameter("workflowId")),-1);
		int topdfnodeid=Util.getIntValue(Util.null2String(request.getParameter("topdfnodeid")),0);
        int pdfsavesecid=Util.getIntValue(Util.null2String(request.getParameter("pdfsavesecid")),0);
        String catalogtype2=Util.null2String(request.getParameter("catalogtype2"));
        int selectcatalog2=Util.getIntValue(Util.null2String(request.getParameter("selectcatalog2")),0);
		int pdfdocstatus=Util.getIntValue(Util.null2String(request.getParameter("pdfdocstatus")),0);
 		int pdffieldid=Util.getIntValue(Util.null2String(request.getParameter("pdffieldid")),0);
        int decryptpdfsavesecid=Util.getIntValue(Util.null2String(request.getParameter("decryptpdfsavesecid")),0);
        String decryptcatalogtype2=Util.null2String(request.getParameter("decryptcatalogtype2"));
        int decryptselectcatalog2=Util.getIntValue(Util.null2String(request.getParameter("decryptselectcatalog2")),0);
		int decryptpdfdocstatus=Util.getIntValue(Util.null2String(request.getParameter("decryptpdfdocstatus")),0);
 		int decryptpdffieldid=Util.getIntValue(Util.null2String(request.getParameter("decryptpdffieldid")),0);
		RecordSet.executeSql("select workflowId from workflow_texttopdfconfig where workflowId="+workflowId);
		if(method.equals("edit")){
			
			
			RecordSet.executeSql("update  workflow_texttopdfconfig set  workflowid='"+workflowId+"' ,topdfnodeid="+topdfnodeid+",pdfsavesecid="+pdfsavesecid+",catalogtype2='"+catalogtype2+"',selectcatalog2="+selectcatalog2+",pdfdocstatus="+pdfdocstatus+",pdffieldid="+pdffieldid+",decryptpdfsavesecid="+decryptpdfsavesecid+",decryptcatalogtype2='"+decryptcatalogtype2+"',decryptselectcatalog2="+decryptselectcatalog2+",decryptpdfdocstatus="+decryptpdfdocstatus+",decryptpdffieldid="+decryptpdffieldid+" ,operationtype='"+operationtype+"',filetopdffile='"+filetopdffile+"',filetopdf='"+filetopdf+"',filemaxsize='"+filemaxsize+"',checktype='"+checktype+"' where id="+id);
		}else if(method.equals("add")){
			RecordSet.executeSql("delete  from workflow_texttopdfconfig where topdfnodeid="+topdfnodeid+" and workflowId="+workflowId);
			RecordSet.executeSql("insert into workflow_texttopdfconfig(workflowId,topdfnodeid,pdfsavesecid,catalogtype2,selectcatalog2,pdfdocstatus,pdffieldid,decryptpdfsavesecid,decryptcatalogtype2,decryptselectcatalog2,decryptpdfdocstatus,decryptpdffieldid,operationtype,filetopdffile,filetopdf,filemaxsize,checktype)values("+workflowId+","+topdfnodeid+","+pdfsavesecid+",'"+catalogtype2+"',"+selectcatalog2+","+pdfdocstatus+","+pdffieldid+","+decryptpdfsavesecid+",'"+decryptcatalogtype2+"',"+decryptselectcatalog2+","+decryptpdfdocstatus+","+decryptpdffieldid+",'"+operationtype+"','"+filetopdffile+"','"+filetopdf+"','"+filemaxsize+"','"+checktype+"' )");
			
		}else if(method.equals("delete")){
		
		RecordSet.executeSql("delete  from workflow_texttopdfconfig where id in("+id+")");
		}
      
	
%>

