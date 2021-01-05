
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="com.weaver.formmodel.util.StringHelper"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="expandBaseRightInfo" class="weaver.formmode.setup.ExpandBaseRightInfo" scope="page" />
<%@page import="net.sf.json.JSONObject"%>
<%
String MaxShare = Util.null2String(request.getParameter("MaxShare"));
if(MaxShare.equals("")){
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
}
%>
<%
String method = Util.null2String(request.getParameter("method"));
int modeId = Util.getIntValue(request.getParameter("modeid"),0);

int expandid = Util.getIntValue(request.getParameter("expandid"),0);
if(method.equals("addNew")){//新增权限
	String txtShareDetail[] = request.getParameterValues("txtShareDetail");
	if(txtShareDetail != null){
		for(int i=0;i<txtShareDetail.length;i++){
			String txtSD = txtShareDetail[i];
			JSONObject jsonObject = JSONObject.fromObject(txtSD);
			expandBaseRightInfo.init();
			expandBaseRightInfo.setModeid(modeId);
			expandBaseRightInfo.setExpandid(expandid);
			expandBaseRightInfo.setRighttype(Util.getIntValue(Util.null2String(jsonObject.get("rightTypeValue")),0));
			expandBaseRightInfo.setRelatedids(Util.null2String(jsonObject.get("relatedids")));
			expandBaseRightInfo.setRolelevelValue(Util.getIntValue(Util.null2String(jsonObject.get("rolelevelValue")), 0));
			
			String showLevelStr = StringHelper.null2String(jsonObject.get("showlevelValue"));
			int showlevel = 0;
			int showlevel2 = -1;
			if(showLevelStr.indexOf("$")!=-1){
				String[] arr = showLevelStr.split("\\$");
				if(arr.length==2){
					showlevel = Util.getIntValue(arr[0],0);
					showlevel2 = Util.getIntValue(arr[1]);
				}else{
					showlevel = Util.getIntValue(StringHelper.null2String(jsonObject.get("showlevelValue")),0);
				}
			}else{
				showlevel = Util.getIntValue(StringHelper.null2String(jsonObject.get("showlevelValue")),0);
			}
			expandBaseRightInfo.setShowlevel(showlevel);
			expandBaseRightInfo.setShowlevel2(showlevel2);
			
			expandBaseRightInfo.insertAddRight();
		}
	}
	out.println("<script>parent.doReload();</script>");
	return;
}else if(method.equals("delete")){//删除权限
	String mainids = Util.null2String(request.getParameter("mainids"));
	if(!mainids.equals("")){
		expandBaseRightInfo.init();
		expandBaseRightInfo.setModeid(modeId);
	}
	response.sendRedirect("expandBase.jsp?id="+expandid);
}

%>