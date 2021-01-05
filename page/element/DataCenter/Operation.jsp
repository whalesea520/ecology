
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/element/operationCommon.jsp"%>
<%@ include file="common.jsp"%>
<jsp:useBean id="rs_update" class="weaver.conn.RecordSet" scope="page" />
<%
	openlink = Util.null2o(request.getParameter("select_open_"+eid));
	todo = Util.null2o(request.getParameter("todo_"+eid));
	todocolor = Util.null2String(request.getParameter("todocolor_"+eid),"#33A3FF");
	asset = Util.null2o(request.getParameter("asset_"+eid));
	assetcolor = Util.null2String(request.getParameter("assetcolor_"+eid),"#FFD200");
	cowork = Util.null2o(request.getParameter("cowork_"+eid));
	coworkcolor = Util.null2String(request.getParameter("coworkcolor_"+eid),"#FD9000");
	proj = Util.null2o(request.getParameter("proj_"+eid));
	projcolor = Util.null2String(request.getParameter("projcolor_"+eid),"#CB61FE");
	customer = Util.null2o(request.getParameter("customer_"+eid));
	customercolor = Util.null2String(request.getParameter("customercolor_"+eid),"#6871E3");
	blog = Util.null2o(request.getParameter("blog_"+eid));
	blogcolor = Util.null2String(request.getParameter("blogcolor_"+eid),"#56DE73");
	mydoc = Util.null2o(request.getParameter("mydoc_"+eid));
	mydoccolor = Util.null2String(request.getParameter("mydoccolor_"+eid),"#FD2677");
	meetting= Util.null2o(request.getParameter("meetting_"+eid));
	meettingcolor= Util.null2String(request.getParameter("meettingcolor_"+eid),"#6871E3");
	
	workplan= Util.null2o(request.getParameter("workplan_"+eid));
	workplancolor= Util.null2String(request.getParameter("workplancolor_"+eid),"#CB61FE");
	
	String sync = Util.null2o(request.getParameter("sync_datacenter_"+eid));
	String userType = Util.null2o(request.getParameter("usertype_datacenter_"+eid));
	
	rs_update.execute("update DataCenterUserSetting set usertype='"+userType+"' where eid='"+eid+"' and userid='"+uid+"'");
	
	if(sync.equals("1")){
		rs_update.execute("update DataCenterUserSetting set openlink='"+openlink+"',todo='"+todo+"',todocolor='"+todocolor+"',asset='"+asset+"',assetcolor='"+assetcolor+"',cowork='"+cowork+"',coworkcolor='"+coworkcolor+"',proj='"+proj+"',projcolor='"+projcolor+"',customer='"+customer+"',customercolor='"+customercolor+"',blog='"+blog+"',blogcolor='"+blogcolor+"',mydoc='"+mydoc+"',mydoccolor='"+mydoccolor+"',meetting='"+meetting+"',meettingcolor='"+meettingcolor+"',workplan='"+workplan+"',workplancolor='"+workplancolor+"' where eid='"+eid+"'");
	}else{
		rs_update.execute("update DataCenterUserSetting set openlink='"+openlink+"',todo='"+todo+"',todocolor='"+todocolor+"',asset='"+asset+"',assetcolor='"+assetcolor+"',cowork='"+cowork+"',coworkcolor='"+coworkcolor+"',proj='"+proj+"',projcolor='"+projcolor+"',customer='"+customer+"',customercolor='"+customercolor+"',blog='"+blog+"',blogcolor='"+blogcolor+"',mydoc='"+mydoc+"',mydoccolor='"+mydoccolor+"',meetting='"+meetting+"',meettingcolor='"+meettingcolor+"',workplan='"+workplan+"',workplancolor='"+workplancolor+"' where eid='"+eid+"' and userid='"+uid+"'");
		//out.println("update DataCenterUserSetting set openlink='"+openlink+"',todo='"+todo+"',todocolor='"+todocolor+"',asset='"+asset+"',assetcolor='"+assetcolor+"',cowork='"+cowork+"',coworkcolor='"+coworkcolor+"',proj='"+proj+"',projcolor='"+projcolor+"',customer='"+customer+"',customercolor='"+customercolor+"',blog='"+blog+"',blogcolor='"+blogcolor+"',mydoc='"+mydoc+"',mydoccolor='"+mydoccolor+"',meetting='"+meetting+"',meettingcolor='"+meettingcolor+"',workplan='"+workplan+"',workplancolor='"+workplancolor+"' where eid='"+eid+"' and userid='"+uid+"'");
	}
%>