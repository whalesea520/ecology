
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.workflow.action.*"%>
<%@ page import="weaver.workflow.action.WSFormActionManager"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BaseAction" class="weaver.workflow.action.BaseAction" scope="page"/>

<%
if(!HrmUserVarify.checkUserRight("intergration:formactionsetting", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String fromintegration = Util.null2String(request.getParameter("fromintegration"));
String typename = Util.null2String(request.getParameter("typename"));
String operate = Util.null2String(request.getParameter("operate"));
int actionid = Util.getIntValue(request.getParameter("actionid"), 0);
int formid = Util.getIntValue(request.getParameter("formid"),0);
int isbill = Util.getIntValue(request.getParameter("isbill"),0);

String actionname = Util.null2String(request.getParameter("actionname"));
int actionorder = Util.getIntValue(request.getParameter("actionorder"), 0);
String wsurl = Util.null2String(request.getParameter("wsurl"));//web service地址
String wsnamespace = Util.null2String(request.getParameter("wsnamespace"));
String wsoperation = Util.null2String(request.getParameter("wsoperation"));//调用的web service的方法
String xmltext = Util.null2String(request.getParameter("xmltext"));
String retstr = Util.null2String(request.getParameter("retstr"));
int rettype = Util.getIntValue(request.getParameter("rettype"), 0);
String inpara = Util.null2String(request.getParameter("inpara"));
String webservicefrom = Util.null2String(request.getParameter("webservicefrom"));
String custominterface = Util.null2String(request.getParameter("custominterface"));
String isdialog = Util.null2String(request.getParameter("isdialog"));
//out.println("operate = " + operate + "<br>");
//out.println("actionid = " + actionid + "<br>");
WSFormActionManager wsActionManager = new WSFormActionManager();
wsActionManager.setActionid(actionid);
wsActionManager.setFormid(formid);
wsActionManager.setIsbill(isbill);
wsActionManager.setActionname(actionname);
wsActionManager.setWsurl(wsurl);
wsActionManager.setWsoperation(wsoperation);
wsActionManager.setXmltext(xmltext);
wsActionManager.setRetstr(retstr);
wsActionManager.setRettype(rettype);
wsActionManager.setInpara(inpara);
wsActionManager.setWebservicefrom(webservicefrom);
wsActionManager.setCustominterface(custominterface);
wsActionManager.setWsnamespace(wsnamespace);

String methodtypes[] = request.getParameterValues("methodtype");
String paramnames[] = request.getParameterValues("paramname");
String paramtypes[] = request.getParameterValues("paramtype");
String isarrays[] = request.getParameterValues("isarray");
String paramsplits[] = request.getParameterValues("paramsplit");
String paramvalues[] = request.getParameterValues("paramvalue");
if("delete".equals(operate)){
	String errormsg = "";
	boolean isused = BaseAction.checkFromActionUsed(""+actionid,"2");
	if(!isused)
		wsActionManager.doDeleteWsAction();
	else
		errormsg = "1";
	if(!"1".equals(fromintegration))
		out.println("<script language=\"javascript\">window.parent.close();dialogArguments.reloadDMLAtion();</script>");
	else{
		if("1".equals(isdialog)){
			out.println("<script language=javascript>var parentWin = parent.parent.getParentWindow(parent);parentWin.doRefresh();setTimeout(top.Dialog.close,2);</script>");
		}else{
			response.sendRedirect("/integration/formactionlist.jsp");
		}
	}
		
}else if("save".equals(operate)){
	String Chinese_PRC_CS_AS_WS = " ";
	if(RecordSet.getDBType().toLowerCase().indexOf("sqlserver") > -1) {
		Chinese_PRC_CS_AS_WS = " collate Chinese_PRC_CS_AS_WS ";
	}
	String sql = "select 1 from wsformactionset where actionname " + Chinese_PRC_CS_AS_WS + " = '" + actionname + "' ";
	if(actionid > 0) {
		sql += " and id <> " + actionid;
	}
	RecordSet.executeSql(sql);
	if(RecordSet.getCounts() > 0) {
		if("1".equals(isdialog)) {
%>
		<script language=javascript >
			try {
				var parentWin = parent.parent.getParentWindow(parent);
				parentWin.location.href = "/integration/formactionlist.jsp";
				var dialog = parent.parent.getDialog(parent);
				dialog.close();
			} catch(e) {
				
			}
		</script>
<%
		}
		return;
	}
	
	actionid = wsActionManager.doSaveWsAction();
	RecordSet.executeSql("update wsformactionset set formid='"+formid+"',isbill='"+isbill+"',typename ='"+typename+"' where id="+actionid);
	
	RecordSet.executeSql("delete from wsmethodparamvalue where contenttype=5 and contentid="+actionid);
	if(methodtypes!=null){
		for(int i=0;i<methodtypes.length;i++){
			String methodtype=methodtypes[i];
			String paramname=paramnames[i];
			String paramtype=paramtypes[i];
			String isarray=isarrays[i];
			String paramsplit=paramsplits[i];
			String paramvalue=paramvalues[i];
			paramvalue=paramvalue.replace("'","''");//qc:295333 [80][90]流程流转集成-注册Webservice接口，方法参数值带有英文单引号保存导致参数被清除问题
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
	String workflowid = Util.null2String(request.getParameter("workflowid"));
    String nodeid = Util.null2String(request.getParameter("nodeid"));
    String nodelinkid = Util.null2String(request.getParameter("nodelinkid"));
    String ispreoperator = Util.null2String(request.getParameter("ispreoperator"));
    if(!"".equals(workflowid))
    {
        WorkflowActionManager workflowActionManager = new WorkflowActionManager();
        workflowActionManager.setActionid(0);
		workflowActionManager.setWorkflowid(Util.getIntValue(workflowid));
		workflowActionManager.setNodeid(Util.getIntValue(nodeid));
		workflowActionManager.setActionorder(0);
		workflowActionManager.setNodelinkid(Util.getIntValue(nodelinkid));
		workflowActionManager.setIspreoperator(Util.getIntValue(ispreoperator));
		workflowActionManager.setActionname(actionname);
		workflowActionManager.setInterfaceid(actionid+"");
		workflowActionManager.setInterfacetype(2);
		workflowActionManager.setIsused(1);
		workflowActionManager.doSaveWsAction();
		if("1".equals(isdialog))
	    {
	    %>
	    <script language=javascript >
	    try
	    {
			var parentWin = parent.parent.getParentWindow(parent);
  				parentWin.closeDialogAction();
  				parentWin.reloadDMLAtion();
		}
		catch(e)
		{
		}
		</script>
	    <%
	    }
		return;
    }
    else
    {
		//out.println("actionid 222 = " + actionid + "<br>");
		if(!"1".equals(fromintegration)){
			out.println("<script language=\"javascript\">window.parent.close();dialogArguments.reloadDMLAtion();</script>");
		}else{
			//response.sendRedirect("/workflow/action/WsFormActionEditSet.jsp?fromintegration="+fromintegration+"&operate=editws&actionid="+actionid+"&formid="+formid+"&isbill="+isbill+"&typename="+typename);
			if("1".equals(isdialog))
			{
			%>
			<script language=javascript >
			/*QC296128 [80][90]流程流转集成-解决编辑DML和WebService接口页面，保存后跳转页面不正确的问题 start*/
			/*try
			{
				var parentWin = parent.parent.getParentWindow(parent);
				parentWin.location.href="/integration/formactionlist.jsp";
				parentWin.closeDialog();
			}
			catch(e)
			{
			}*/
			try{
				var parentWin = parent.parent.getParentWindow(parent);
				parentWin.doRefresh();
				setTimeout(top.Dialog.close,2);
			}catch(e)
			{}
		    try{
			   var parentWin = parent.parent.getParentWindow(parent);
			   parentWin.closeDialogAction();
			   parentWin.reloadDMLAtion();
			}catch(e)
			{}
		   /*QC296128 [80][90]流程流转集成-解决编辑DML和WebService接口页面，保存后跳转页面不正确的问题 end*/
			</script>
			<%
			}else{
				response.sendRedirect("/workflow/action/WsFormActionEditSet.jsp?fromintegration="+fromintegration+"&operate=editws&actionid="+actionid+"&formid="+formid+"&isbill="+isbill+"&typename="+typename);
			}
			return;
		}	
    }
}

return;
%>