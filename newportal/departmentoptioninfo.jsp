
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
String subid = Util.null2String(request.getParameter("subid"));
String optionInfo ="<option value=''></option>";
DepartmentComInfo.setTofirstRow();
while(DepartmentComInfo.next()){
	if(subid.equals(DepartmentComInfo.getSubcompanyid1())&&!"1".equals(DepartmentComInfo.getDeparmentcanceled())){
		
		optionInfo+="<option value='"+DepartmentComInfo.getDepartmentid()+"'>"+DepartmentComInfo.getDepartmentname()+"</option>";
	}
}
out.print(optionInfo);
%>