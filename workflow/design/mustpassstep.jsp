<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="WFNodePortalMainManager" class="weaver.workflow.workflow.WFNodePortalMainManager" scope="page" />
<%WFNodePortalMainManager.resetParameter();%>
<%

 

	int wfid=0;
	int nodeid = 0;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	nodeid = Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
	
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	
	
	WFNodePortalMainManager.resetParameter();
	WFNodePortalMainManager.setWfid(wfid);
	WFNodePortalMainManager.selectWfNodePortal();
	String jsonString = "{\"options\":[";
	int count= 0;
	while(WFNodePortalMainManager.next()){
		if(WFNodePortalMainManager.getDestnodeid() == nodeid){
			
			jsonString+="{\"name\":\""+WFNodePortalMainManager.getLinkname()+"\", \"type\":\""+WFNodePortalMainManager.getId()+"\",\"node\":\""+nodeid+"\"},";
			count++;
		}
	}
	if(count>0){
		jsonString=jsonString.substring(0,jsonString.length()-1);
	}
	
	jsonString+="]}";
	out.print(jsonString);
	%>