
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<%
String suptype = Util.null2String(request.getParameter("suptype"));
String subId = Util.null2String(request.getParameter("subId"));
String cmd = Util.null2String(request.getParameter("cmd")); 
ArrayList departMentList = new ArrayList();
String returnStr = "";
if("com".equals(suptype)){
    departMentList = SubCompanyComInfo.getSubDepartmentStrByEditRight(subId,departMentList);
    for(int i=0;i<departMentList.size();i++){
        returnStr = returnStr + departMentList.get(i) + ",";
    }
}else if("dep".equals(suptype)){
    departMentList = SubCompanyComInfo.getsubDepartmentStr(subId,departMentList);
    for(int i=0;i<departMentList.size();i++){
        returnStr = returnStr + departMentList.get(i) + ",";
    }
}else if("subcom".equals(suptype)){
    departMentList = SubCompanyComInfo.getsubCompanyStr(subId,departMentList);
    for(int i=0;i<departMentList.size();i++){
        returnStr = returnStr + departMentList.get(i) + ",";
    }
}else if("getnuloadnode".equals(cmd)){
	String nuloadnode = Util.null2String(request.getParameter("nuloadnode"));
	String[] nodeids = Util.TokenizerString2(nuloadnode,",");
	if(nodeids!=null){
		for(String nodeid : nodeids){
			subId = Util.TokenizerString2(nodeid,"_")[1];
			if(nodeid.startsWith("com")){
		    departMentList = SubCompanyComInfo.getSubDepartmentStrByEditRight(subId,departMentList);
			}else if(nodeid.startsWith("subcom")){
		    departMentList = SubCompanyComInfo.getsubCompanyStr(subId,departMentList);
			}else if(nodeid.startsWith("dep")){
		    departMentList = SubCompanyComInfo.getsubDepartmentStr(subId,departMentList);
			}
		}
    for(int i=0;i<departMentList.size();i++){
      returnStr = returnStr + departMentList.get(i) + ",";
  	}
	}
}
%>
<%=returnStr%>