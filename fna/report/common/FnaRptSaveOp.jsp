<%@page import="java.util.UUID"%>
<%@page import="weaver.fna.report.FnaReport"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.json.JSONObject"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

String rptTypeName = Util.null2String(request.getParameter("rptTypeName")).trim();
boolean canview = FnaReport.checkUserRight(rptTypeName, user) ;
if(!canview) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}

String operation = Util.null2String(request.getParameter("operation"));

String sql = "";

//历史查询结果
if(operation.equals("saveNew")){
	String _guid1 = Util.null2String(request.getParameter("_guid1"));
	String tbName = Util.null2String(request.getParameter("tbName"));
	String description = Util.null2String(request.getParameter("description"));

	HashMap<String, String> retHm = FnaReport.getFnaReportShareLevel(_guid1, user.getUID());
	
	boolean isEdit = "true".equals(retHm.get("isEdit"));//编辑
	boolean isFull = "true".equals(retHm.get("isFull"));//完全控制
	if(!isEdit && !isFull) {
		response.sendRedirect("/notice/noright.jsp") ; 
		return ; 
	}
	
	sql = "update fnaTmpTbLog set tbName = '"+StringEscapeUtils.escapeSql(tbName)+"', description = '"+StringEscapeUtils.escapeSql(description)+"', isTemp = 0 "+
		" where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"'";
	rs.executeSql(sql);	

	out.println("{\"flag\":true}");//成功
	out.flush();
	return;
	
}else if(operation.equals("delete") || operation.equals("batchDel")){

	String id = Util.null2String(request.getParameter("id"));
	String batchDelIds = Util.null2String(request.getParameter("batchDelIds"));
	if(operation.equals("delete")){
		batchDelIds = id;
	}
	String[] batchDelIdsArray = batchDelIds.split(",");
	
	for(int i=0;i<batchDelIdsArray.length;i++){
		int _id = Util.getIntValue(batchDelIdsArray[i], 0);
		FnaReport.deleteFnaReport(_id, user.getUID());
	}

	out.println("{\"flag\":true}");//成功
	out.flush();
	return;
	
}
//历史查询结果共享
else if(operation.equals("FnaRptShareSave")){
	int fnaTmpTbLogId = Util.getIntValue(request.getParameter("fnaTmpTbLogId"));
	String groupGuid1 = Util.null2String(request.getParameter("groupGuid1"));
	int shareType = Util.getIntValue(request.getParameter("shareType"));
	String shareId = Util.null2String(request.getParameter("shareId"));
	String secLevel1 = Util.null2String(request.getParameter("secLevel1"));
	String secLevel2 = Util.null2String(request.getParameter("secLevel2"));
	int shareLevel = Util.getIntValue(request.getParameter("shareLevel"));

	HashMap<String, String> retHm = FnaReport.getFnaReportShareLevel(fnaTmpTbLogId, user.getUID());

	boolean isEdit = "true".equals(retHm.get("isEdit"));//编辑
	boolean isFull = "true".equals(retHm.get("isFull"));//完全控制
	if(!isEdit && !isFull) {
		response.sendRedirect("/notice/noright.jsp") ; 
		return ; 
	}
	
	if(!isFull && shareLevel >= 2){
		response.sendRedirect("/notice/noright.jsp") ; 
		return ; 
	}
	
	if(shareType==0){
		shareId = "";
	}else if(shareType==1){
		secLevel1 = "-1";
		secLevel2 = "-1";
	}
	
	String[] shareIdArray = shareId.split(",");
	
	if(Util.getIntValue(secLevel1) < 0){
		secLevel1 = "-1";
	}
	
	if(Util.getIntValue(secLevel2) < 0){
		secLevel2 = "-1";
	}
	
	if("".equals(groupGuid1)){
		groupGuid1 = UUID.randomUUID().toString();
	}

	sql = "delete from fnaTmpTbLogShare where fnaTmpTbLogId = "+fnaTmpTbLogId+" and groupGuid1 = '"+StringEscapeUtils.escapeSql(groupGuid1)+"'";
	rs.executeSql(sql);
	
	for(int i=0;i<shareIdArray.length;i++){
		String _shareId = Util.null2String(shareIdArray[i]).trim();
		if("".equals(_shareId)){
			_shareId = "NULL";
		}
		
		sql = "insert into fnaTmpTbLogShare (fnaTmpTbLogId, groupGuid1, shareType, shareId, secLevel1, secLevel2, shareLevel) "+
			" values ("+
			" "+fnaTmpTbLogId+", '"+StringEscapeUtils.escapeSql(groupGuid1)+"', "+shareType+", "+_shareId+", "+secLevel1+", "+secLevel2+", "+shareLevel+" "+
			")";
		rs.executeSql(sql);
	}
		

	out.println("{\"flag\":true}");//成功
	out.flush();
	return;
	
}else if(operation.equals("delFnaRptShare") || operation.equals("batchDelFnaRptShare")){

	String groupGuid1 = Util.null2String(request.getParameter("groupGuid1"));
	String batchDelIds = Util.null2String(request.getParameter("batchDelIds"));
	if(operation.equals("delFnaRptShare")){
		batchDelIds = groupGuid1;
	}
	String[] batchDelIdsArray = batchDelIds.split(",");
	
	for(int i=0;i<batchDelIdsArray.length;i++){
		String _groupGuid1 = Util.null2String(batchDelIdsArray[i]).trim();
		FnaReport.deleteFnaReportShare(_groupGuid1, user.getUID());
	}

	out.println("{\"flag\":true}");//成功
	out.flush();
	return;
	
}
%>
