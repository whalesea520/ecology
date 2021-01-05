
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ReportShareInfo" class="weaver.formmode.report.ReportShareInfo" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String method = Util.null2String(request.getParameter("method"));
int reportid = Util.getIntValue(request.getParameter("reportid"),0);
if(method.equals("addNew")){//新增权限
	String txtShareDetail[] = request.getParameterValues("txtShareDetail");
	if(txtShareDetail != null){
		for(int i=0;i<txtShareDetail.length;i++){
			String txtSD = txtShareDetail[i];

			ArrayList txtSDList = Util.TokenizerString(txtSD,"_");
			ReportShareInfo.init();
			ReportShareInfo.setReportid(reportid);
			ReportShareInfo.setSharetype(Util.getIntValue((String)txtSDList.get(0),0));
			ReportShareInfo.setRelatedids(Util.null2String((String)txtSDList.get(1)));
			ReportShareInfo.setRolelevel(Util.getIntValue((String)txtSDList.get(2),0));
			ReportShareInfo.setShowlevel(Util.getIntValue((String)txtSDList.get(3),0));
			ReportShareInfo.setRighttype(Util.getIntValue((String)txtSDList.get(4),0));
			ReportShareInfo.insertAddRight();
		}
	}
}else if(method.equals("delete")){//删除权限
	String mainids = Util.null2String(request.getParameter("mainids"));
	if(!mainids.equals("")){
		ReportShareInfo.init();
		ReportShareInfo.setReportid(reportid);
		ReportShareInfo.delShareByIds(mainids);
	}
}
response.sendRedirect("/formmode/setup/reportinfoShareBase.jsp?id="+reportid);
%>