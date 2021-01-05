<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="PrjViewer" class="weaver.proj.PrjViewer" scope="page"/>
<jsp:useBean id="PrjShareUtil" class="weaver.proj.util.PrjShareUtil" scope="page"/>

<%

User user=HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}

char flag = 2;
String ProcPara = "";

String method = Util.null2String(request.getParameter("method"));

String ProjID=Util.null2String(request.getParameter("ProjID"));
String taskrecordid=Util.null2String(request.getParameter("taskrecordid"));
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String CustomerID=Util.null2String(request.getParameter("CustomerID"));
int powerlevel=Util.getIntValue(Util.null2String(request.getParameter("powerlevel")),0);
String reasondesc=Util.null2String(request.getParameter("reasondesc"));


if(method.equals("add"))
{


	ProcPara = ProjID + flag + taskrecordid + flag + CustomerID + flag + powerlevel + flag + reasondesc;
	RecordSet.executeProc("Prj_Customer_Insert",ProcPara);

	PrjViewer.setPrjShareByPrj(""+ProjID);
	PrjShareUtil.addCrmShare(CustomerID, ProjID, taskrecordid, user.getUID());

	if(type.equals("1"))
		response.sendRedirect("/proj/plan/ViewTask.jsp?log=n&taskrecordid="+taskrecordid);
	else if(type.equals("2"))
		response.sendRedirect("/proj/process/ViewTask.jsp?log=n&taskrecordid="+taskrecordid);
}

if(method.equals("del"))
{
	String[] idarr=id.split(",");
	for(int i=0;i<idarr.length;i++){
		ProcPara = idarr[i];
		RecordSet.executeProc("Prj_Customer_DeleteByID",ProcPara);

		PrjViewer.setPrjShareByPrj(""+ProjID);
	}
	
	

	if(type.equals("1"))
		response.sendRedirect("/proj/plan/ViewTask.jsp?log=n&taskrecordid="+taskrecordid);
	else if(type.equals("2"))
		response.sendRedirect("/proj/process/ViewTask.jsp?log=n&taskrecordid="+taskrecordid);
}


if(method.equals("edit"))
{
	ProcPara = id + flag + CustomerID + flag + powerlevel + flag + reasondesc;
	RecordSet.executeProc("Prj_Customer_Update",ProcPara);

	PrjViewer.setPrjShareByPrj(""+ProjID);
	PrjShareUtil.addCrmShare(CustomerID, ProjID, taskrecordid, user.getUID());

	if(type.equals("1"))
		response.sendRedirect("/proj/plan/ViewTask.jsp?log=n&taskrecordid="+taskrecordid);
	else if(type.equals("2"))
		response.sendRedirect("/proj/process/ViewTask.jsp?log=n&taskrecordid="+taskrecordid);
}
%>
