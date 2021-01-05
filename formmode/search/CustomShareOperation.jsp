
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String method = Util.null2String(request.getParameter("method"));
int formId = Util.getIntValue(Util.null2String(request.getParameter("formId")));
int modeId = Util.getIntValue(Util.null2String(request.getParameter("modeId")));
int pageid = Util.getIntValue(request.getParameter("pageid"),0);

if(method.equals("addNew")){//新增权限
	String txtShareDetail[] = request.getParameterValues("txtShareDetail");
	if(txtShareDetail != null){
		for(int i=0;i<txtShareDetail.length;i++){
			String txtSD = txtShareDetail[i];

			ArrayList txtSDList = Util.TokenizerString(txtSD,"_");
			FormModeRightInfo.init();
			FormModeRightInfo.setPageid(pageid);
			FormModeRightInfo.setSharetype(Util.getIntValue((String)txtSDList.get(0),0));
			FormModeRightInfo.setRelatedids(Util.null2String((String)txtSDList.get(1)));
			FormModeRightInfo.setRolelevel(Util.getIntValue((String)txtSDList.get(2),0));
			
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
			
			FormModeRightInfo.setShowlevel(showlevel);
			FormModeRightInfo.setShowlevel2(showlevel2);
			FormModeRightInfo.setRighttype(Util.getIntValue((String)txtSDList.get(4),0));
			FormModeRightInfo.setLayoutid(Util.getIntValue((String)txtSDList.get(5),0));
			FormModeRightInfo.setLayoutid1(Util.getIntValue((String)txtSDList.get(6),0));
			FormModeRightInfo.setLayoutorder(Util.getIntValue((String)txtSDList.get(7),0));
			FormModeRightInfo.setJoblevel(Util.getIntValue((String)txtSDList.get(9),0));
			FormModeRightInfo.setJobleveltext(Util.null2String((String)txtSDList.get(10)));
			FormModeRightInfo.insertAddRight();
		}
	}
}else if(method.equals("delete")){//删除权限
	String mainids = Util.null2String(request.getParameter("mainids"));
	if(!mainids.equals("")){
		FormModeRightInfo.init();
		FormModeRightInfo.setPageid(pageid);
		FormModeRightInfo.delShareByIds(mainids);
	}
}
response.sendRedirect("/formmode/search/CustomSearchShare.jsp?id="+pageid+"&formId="+formId+"&modeId="+modeId);
%>