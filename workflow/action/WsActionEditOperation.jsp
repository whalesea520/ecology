
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.workflow.action.WSActionManager"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String fromintegration = Util.null2String(request.getParameter("fromintegration"));
String typename = Util.null2String(request.getParameter("typename"));
String operate = Util.null2String(request.getParameter("operate"));
int actionid = Util.getIntValue(request.getParameter("actionid"), 0);
int workflowid = Util.getIntValue(request.getParameter("workflowid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
//是否节点后附加操作
int ispreoperator = Util.getIntValue(request.getParameter("ispreoperator"), 0);
//出口id
int nodelinkid = Util.getIntValue(request.getParameter("nodelinkid"), 0);
String actionname = Util.null2String(request.getParameter("actionname"));
int actionorder = Util.getIntValue(request.getParameter("actionorder"), 0);
String wsurl = Util.null2String(request.getParameter("wsurl"));//web service地址
String wsoperation = Util.null2String(request.getParameter("wsoperation"));//调用的web service的方法
String xmltext = Util.null2String(request.getParameter("xmltext"));
String retstr = Util.null2String(request.getParameter("retstr"));
int rettype = Util.getIntValue(request.getParameter("rettype"), 0);
String inpara = Util.null2String(request.getParameter("inpara"));
String webservicefrom = Util.null2String(request.getParameter("webservicefrom"));
String custominterface = Util.null2String(request.getParameter("custominterface"));
//out.println("operate = " + operate + "<br>");
//out.println("actionid = " + actionid + "<br>");
WSActionManager wsActionManager = new WSActionManager();
wsActionManager.setActionid(actionid);
wsActionManager.setWorkflowid(workflowid);
wsActionManager.setNodeid(nodeid);
wsActionManager.setActionorder(actionorder);
wsActionManager.setNodelinkid(nodelinkid);
wsActionManager.setIspreoperator(ispreoperator);
wsActionManager.setActionname(actionname);
wsActionManager.setWsurl(wsurl);
wsActionManager.setWsoperation(wsoperation);
wsActionManager.setXmltext(xmltext);
wsActionManager.setRetstr(retstr);
wsActionManager.setRettype(rettype);
wsActionManager.setInpara(inpara);
wsActionManager.setWebservicefrom(webservicefrom);
wsActionManager.setCustominterface(custominterface);

String methodtypes[] = request.getParameterValues("methodtype");
String paramnames[] = request.getParameterValues("paramname");
String paramtypes[] = request.getParameterValues("paramtype");
String isarrays[] = request.getParameterValues("isarray");
String paramsplits[] = request.getParameterValues("paramsplit");
String paramvalues[] = request.getParameterValues("paramvalue");
if("delete".equals(operate)){
	wsActionManager.doDeleteWsAction();
	if(!"1".equals(fromintegration))
		out.println("<script language=\"javascript\">window.parent.close();dialogArguments.reloadDMLAtion();</script>");
	else
		response.sendRedirect("/integration/dmllist.jsp?typename="+typename);
}else if("save".equals(operate)){
	actionid = wsActionManager.doSaveWsAction();
	RecordSet.executeSql("update wsactionset set typename ='"+typename+"' where id="+actionid);
	
	RecordSet.executeSql("delete from wsmethodparamvalue where contenttype=5 and contentid="+actionid);
	if(methodtypes!=null){
		for(int i=0;i<methodtypes.length;i++){
			String methodtype=methodtypes[i];
			String paramname=paramnames[i];
			String paramtype=paramtypes[i];
			String isarray=isarrays[i];
			String paramsplit=paramsplits[i];
			String paramvalue=paramvalues[i];
			String methodid = "";
			//System.out.println("methodtype : "+methodtype+" paramname : "+paramname);
			methodid = wsoperation;
			if("".equals(methodid))
				methodid = "0";
			if(!methodid.equals("")&&!methodtype.equals(""))
			{
				String dsql = "insert into wsmethodparamvalue(contenttype,contentid,methodid,paramname,paramtype,isarray,paramsplit,paramvalue) "+
							  "values(5,"+actionid+","+methodid+",'"+paramname+"','"+paramtype+"','"+isarray+"','"+paramsplit+"','"+paramvalue+"')";
				RecordSet.executeSql(dsql);
			}
		}
	}
	//out.println("actionid 222 = " + actionid + "<br>");
	if(!"1".equals(fromintegration))
		out.println("<script language=\"javascript\">window.parent.close();dialogArguments.reloadDMLAtion();</script>");
	else
		response.sendRedirect("/workflow/action/WsActionEditSet.jsp?fromintegration="+fromintegration+"&operate=editws&actionid="+actionid+"&workflowid="+workflowid+"&nodelinkid="+nodelinkid+"&nodeid="+nodeid+"&ispreoperator="+ispreoperator+"&typename="+typename);
}

return;
%>