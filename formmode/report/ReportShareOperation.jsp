
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
			
			String showLevelStr = (String)txtSDList.get(3);
			int showlevel = 0;
			int showlevel2 = -1;
			if(showLevelStr.indexOf("$")!=-1){
				String[] arr = showLevelStr.split("\\$");
				if(arr.length==2){
					showlevel = Util.getIntValue(arr[0],0);
					showlevel2 = Util.getIntValue(arr[1]);
				}else{
					showlevel = Util.getIntValue((String)txtSDList.get(3),0);
				}
			}else{
				showlevel = Util.getIntValue((String)txtSDList.get(3),0);
			}
			
			ReportShareInfo.setShowlevel(showlevel);
			ReportShareInfo.setShowlevel2(showlevel2);
			ReportShareInfo.setRighttype(Util.getIntValue((String)txtSDList.get(4),0));
			ReportShareInfo.setHrmCompanyVirtualType(Util.getIntValue((String)txtSDList.get(5),0));
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
response.sendRedirect("/formmode/report/ReportShare.jsp?id="+reportid);
%>