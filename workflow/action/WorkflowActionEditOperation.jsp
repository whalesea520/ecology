
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.workflow.action.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("intergration:formactionsetting", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String fromintegration = Util.null2String(request.getParameter("fromintegration"));



String operate = Util.null2String(request.getParameter("operate"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"),0);
String workflowids = Util.null2String(request.getParameter("workflowids"));
String actionids = Util.null2String(request.getParameter("actionids"));

//(new BaseBean()).writeLog("operate : "+operate+" actionids : "+actionids+" workflowids : "+workflowids);
if("delete".equals(operate))
{
	String isused = Util.null2String(request.getParameter("isused"));
	int actionid = Util.getIntValue(request.getParameter("actionid"), 0);

	int nodeid = Util.getIntValue(request.getParameter("actionnodeid"),0);
	//是否节点后附加操作
	int ispreoperator = Util.getIntValue(request.getParameter("actionispreoperator"), 0);
	//出口id
	int nodelinkid = Util.getIntValue(request.getParameter("actionnodelinkid"), 0);
	String actionname = Util.null2String(request.getParameter("actionname"));
	int actionorder = Util.getIntValue(request.getParameter("actionorder"), 0);
	String interfaceid = Util.null2String(request.getParameter("interfaceid"));//选择注册的接口
	String interfacetype = Util.null2String(request.getParameter("interfacetype"));//选择注册的接口

	//out.println("operate = " + operate + "<br>");
	//out.println("actionid = " + actionid + "<br>");
	WorkflowActionManager workflowActionManager = new WorkflowActionManager();
	workflowActionManager.setActionid(actionid);
	workflowActionManager.setWorkflowid(workflowid);
	workflowActionManager.setNodeid(nodeid);
	workflowActionManager.setActionorder(actionorder);
	workflowActionManager.setNodelinkid(nodelinkid);
	workflowActionManager.setIspreoperator(ispreoperator);
	workflowActionManager.setActionname(actionname);
	workflowActionManager.setInterfaceid(interfaceid);
	workflowActionManager.setInterfacetype(Util.getIntValue(interfacetype));
	workflowActionManager.setIsused(Util.getIntValue(isused,0));
	if(!"".equals(actionids))
	{
		List actionlist = Util.TokenizerString(actionids,",");
		if(null!=actionlist)
		{
			for(int i = 0;i<actionlist.size();i++)
			{
				int tempactionid = Util.getIntValue((String)actionlist.get(i));
				if(tempactionid>0)
				{
					workflowActionManager.doDeleteWsAction(tempactionid);
				}
			}
		}
		if(!"1".equals(fromintegration))
			out.println("<script language=\"javascript\">window.parent.close();dialogArguments.reloadDMLAtion();</script>");
		else
			response.sendRedirect("/workflow/action/WorkflowActionEditSet.jsp?fromintegration="+fromintegration+"&workflowid="+workflowid);
	}
	else if(!"".equals(workflowids))
	{
		List workflowlist = Util.TokenizerString(workflowids,",");
		if(null!=workflowlist)
		{
			for(int i = 0;i<workflowlist.size();i++)
			{
				int tempworkflowid = Util.getIntValue((String)workflowlist.get(i));
				//(new BaseBean()).writeLog("tempworkflowid : "+tempworkflowid);
				if(tempworkflowid>0)
				{
					workflowActionManager.doDeleteByWorkflowid(tempworkflowid);
				}
			}
		}
		
		if(!"1".equals(fromintegration))
			out.println("<script language=\"javascript\">window.parent.close();dialogArguments.reloadDMLAtion();</script>");
		else
			response.sendRedirect("/integration/dmllist.jsp?fromintegration="+fromintegration);
	}
	else if(workflowid>0)
	{
		workflowActionManager.doDeleteByWorkflowid(workflowid);
		if(!"1".equals(fromintegration))
			out.println("<script language=\"javascript\">window.parent.close();dialogArguments.reloadDMLAtion();</script>");
		else
			out.println("<script language=javascript>var parentWin = parent.parent.getParentWindow(parent);parentWin.doRefresh();setTimeout(top.Dialog.close,2);</script>");
	}
	
}else if("save".equals(operate)){
	String[] isuseds = request.getParameterValues("isused");
	String[] tactionids = request.getParameterValues("actionid");
	String[] types = request.getParameterValues("type");
	String[] nodeids = request.getParameterValues("actionnodeid");
	//是否节点后附加操作
	String[] ispreoperators = request.getParameterValues("actionispreoperator");
	//出口id
	String[] nodelinkids = request.getParameterValues("actionnodelinkid");
	String[] actionnames = request.getParameterValues("actionname");
	String[] actionorders = request.getParameterValues("actionorder");
	String[] interfaceids = request.getParameterValues("interfaceid");//选择注册的接口
	String[] interfacetypes = request.getParameterValues("interfacetype");//选择注册的接口
	String tempactionids = "0";
	WorkflowActionManager workflowActionManager = new WorkflowActionManager();
	if(null!=tactionids&&tactionids.length>0)
	{
		
		for(int i = 0;i<tactionids.length;i++)
		{
			int actionid = Util.getIntValue((String)tactionids[i],0);
			int nodeid =  Util.getIntValue((String)nodeids[i],0);
			int ispreoperator = 1;
			if(i<(ispreoperators==null?1:ispreoperators.length)){
				 ispreoperator = Util.getIntValue(ispreoperators==null?"1":(String)ispreoperators[i],0);
			}
			int nodelinkid = Util.getIntValue((String)nodelinkids[i],0);
			String actionname = Util.null2String((String)actionnames[i]);
			int actionorder = Util.getIntValue((String)actionorders[i],0);
			String interfaceid = Util.null2String((String)interfaceids[i]);
			int interfacetype = Util.getIntValue((String)interfacetypes[i],0);
			int isused = Util.getIntValue((String)isuseds[i],0);
			
			
			workflowActionManager.setActionid(actionid);
			workflowActionManager.setWorkflowid(workflowid);
			workflowActionManager.setNodeid(nodeid);
			workflowActionManager.setActionorder(actionorder);
			workflowActionManager.setNodelinkid(nodelinkid);
			workflowActionManager.setIspreoperator(ispreoperator);
			workflowActionManager.setActionname(actionname);
			workflowActionManager.setInterfaceid(interfaceid);
			workflowActionManager.setInterfacetype(interfacetype);
			workflowActionManager.setIsused(isused);
			
			actionid = workflowActionManager.doSaveWsAction();
			if(actionid>0)
			{
				tempactionids += "".equals(tempactionids)?(""+actionid):(","+actionid);
			}
		}
		
	}
	if(!"".equals(tempactionids))
	{
		workflowActionManager.setNodeid(0);
		workflowActionManager.setNodelinkid(0);
		workflowActionManager.setWorkflowid(workflowid);
		workflowActionManager.doDeleteWsActionsNoExists(tempactionids);
	}
	//out.println("actionid 222 = " + actionid + "<br>");
	if("1".equals(fromintegration)){
		out.println("<script language=javascript>var parentWin = parent.parent.getParentWindow(parent);parentWin.doRefresh();setTimeout(top.Dialog.close,2);</script>");
	}else{
	//	response.sendRedirect("/workflow/action/WorkflowActionEditSet.jsp?fromintegration="+fromintegration+"&workflowid="+workflowid);
		response.sendRedirect("/integration/dmllist.jsp");
	}
}

return;
%>