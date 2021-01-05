
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*,weaver.conn.*"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.workflow.action.*"%>
<jsp:useBean id="FormActionInfoService" class="weaver.workflow.dmlaction.services.FormActionInfoService" scope="page"/>
<jsp:useBean id="BaseAction" class="weaver.workflow.action.BaseAction" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("intergration:formactionsetting", user))
{
	response.sendRedirect("/notice/noright.jsp");
	
	return;
}
String fromintegration = Util.null2String(request.getParameter("fromintegration"));
String typename = Util.null2String(request.getParameter("typename"));

int actionid = Util.getIntValue(Util.null2String(request.getParameter("actionid")),0);
//操作类型
String operate = Util.null2String(request.getParameter("operate"));
//动作名称
String actionname = Util.null2String(request.getParameter("actionname"));
//表单名称
int formid = Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
//表单名称
int isbill = Util.getIntValue(Util.null2String(request.getParameter("isbill")),0);
//数据源表
String maintablename = Util.null2String(request.getParameter("maintablename"));

//数据源id
String datasourceid = Util.null2String(request.getParameter("datasourceid"));
//操作类型
String dmltype = Util.null2String(request.getParameter("dmltype"));

int actionsqlsetid = Util.getIntValue(Util.null2String(request.getParameter("actionsqlsetid")),0);
//DML主表formid
int dmlformid = Util.getIntValue(Util.null2String(request.getParameter("dmlformid")),0);
//DML主表form名称
String dmlformname = Util.null2String(request.getParameter("dmlformname"));
//DML主表form是否为明细
String dmlisdetail = Util.null2String(request.getParameter("dmlisdetail"));
//DML主表名
String dmltablename = Util.null2String(request.getParameter("dmltablename"));
//DML主表别名
String dmltablebyname = Util.null2String(request.getParameter("dmltablebyname"));

//DML主表字段对应关系
String [] dmlfieldnames = request.getParameterValues("dmlfieldname");
//DML主表条件对应关系
String [] wherefieldnames = request.getParameterValues("wherefieldname");
//自定义主表条件
String dmlmainwhere = Util.null2String(request.getParameter("dmlmainwhere"));
//自定义主表DML语句类型
String dmlmainsqltype = Util.null2String(request.getParameter("dmlmainsqltype"));
//自定义主表DML语句
String dmlmainsql = Util.null2String(request.getParameter("dmlmainsql"));

//数据来源
String dmlsourceinfo = Util.null2String(request.getParameter("dmlsourceinfo"));
int dmlsource = 0;
String dmlsourcetype = "";
int dmlsourceorder = 0;

if(!"".equals(dmlsourceinfo)){
	String [] sourceinfo = dmlsourceinfo.split("_",-1);
	if(sourceinfo.length == 3){
		dmlsourcetype = Util.null2String(sourceinfo[0]);
		dmlsource = Util.getIntValue(Util.null2String(sourceinfo[1]),0);
		dmlsourceorder = Util.getIntValue(Util.null2String(sourceinfo[2]),0);
	}
}

//DML赋值设置,转换规则
String [] transttypevalues = request.getParameterValues("transttypevalue");
//DML赋值设置,转换规则的附加信息,转换规则为1:固定值,7:自定义SQL时,这个参数的值才不为空
String [] extravalues = request.getParameterValues("extravalue");
//DML赋值设置，表单字段id
String [] fieldidvalues = request.getParameterValues("fieldidvalue");


//DML触发条件设置,转换规则
String [] transttypewheres = request.getParameterValues("transttypewhere");
//DML触发条件设置,转换规则的附加信息,转换规则为1:固定值,7:自定义SQL时,这个参数的值才不为空
String [] extrawheres = request.getParameterValues("extrawhere");
//DML条件设置设置，表单字段id
String [] fieldidwheres = request.getParameterValues("fieldidwhere");

String isdialog = Util.null2String(request.getParameter("isdialog"));

Map<String,Object> params = new HashMap<String,Object>();
params.put("actionname",actionname);
params.put("formid",formid);
params.put("isbill",isbill);
params.put("datasourceid",datasourceid);
params.put("dmltype",dmltype);
params.put("actiontable",maintablename);
params.put("dmlformid",dmlformid);
params.put("dmlformname",dmlformname);
params.put("dmlisdetail",dmlisdetail);
params.put("dmltablename",dmltablename);
params.put("dmltablebyname",dmltablebyname);
params.put("dmlfieldnames",dmlfieldnames);
params.put("wherefieldnames",wherefieldnames);
params.put("dmlcuswhere",dmlmainwhere);
params.put("dmlmainsqltype",dmlmainsqltype);
params.put("dmlcussql",dmlmainsql);

params.put("dmlsourceinfo",dmlsourceinfo);

params.put("transttypevalues",transttypevalues);
params.put("extravalues",extravalues);
params.put("fieldidvalues",fieldidvalues);

params.put("transttypewheres",transttypewheres);
params.put("extrawheres",extrawheres);
params.put("fieldidwheres",fieldidwheres);

if("add".equals(operate))
{
	
	//QC267860 start [80][90]流程流转集成-DML弹出窗口按Backspace会重复插入一条数据
	
	String Chinese_PRC_CS_AS_WS = " ";
	if(RecordSet.getDBType().toLowerCase().indexOf("sqlserver") > -1) {
		Chinese_PRC_CS_AS_WS = " collate Chinese_PRC_CS_AS_WS ";
	}
	String sql = "select 1 from formactionset where dmlactionname " + Chinese_PRC_CS_AS_WS + " = '" + actionname + "' ";
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
	//QC267860 END [80][90]流程流转集成-DML弹出窗口按Backspace会重复插入一条数据

	actionid = FormActionInfoService.saveFormActionSet(params);

	if(actionid > 0){
		RecordSet.executeSql("update formactionset set typename ='"+typename+"' where id="+actionid);
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
		workflowActionManager.setInterfaceid(""+actionid);
		workflowActionManager.setInterfacetype(1);
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
		/*
		if(!"1".equals(fromintegration))
			out.println("<script language=javascript>window.parent.close();dialogArguments.reloadDMLAtion();</script>");
		else
			response.sendRedirect("/workflow/dmlaction/FormActionSettingView.jsp?fromintegration="+fromintegration+"&actionid="+actionid+"&typename="+typename);
		*/
		if("1".equals(isdialog))
	    {
			//System.out.println("isdialog : "+isdialog);
	    %>
	    <script language=javascript >
	    try
	    {
			var parentWin = parent.parent.getParentWindow(parent);
			parentWin.location.href="/integration/formactionlist.jsp";
			parentWin.closeDialog();
		}
		catch(e)
		{
		}
		</script>
	    <%
	    }
		return;
    }
	//response.sendRedirect("DMLActionSettingView.jsp?actionid="+actionid);
}
else if("edit".equals(operate))
{
	//QC267860 start [80][90]流程流转集成-DML弹出窗口按Backspace会重复插入一条数据
	String Chinese_PRC_CS_AS_WS = " ";
	if(RecordSet.getDBType().toLowerCase().indexOf("sqlserver") > -1) {
		Chinese_PRC_CS_AS_WS = " collate Chinese_PRC_CS_AS_WS ";
	}
	String sql = "select 1 from formactionset where dmlactionname " + Chinese_PRC_CS_AS_WS + " = '" + actionname + "' ";
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
	//QC267860 END [80][90]流程流转集成-DML弹出窗口按Backspace会重复插入一条数据
	params.put("actionsqlsetid",actionsqlsetid);
	FormActionInfoService.editFormActionSet(actionid,params);
	RecordSet.executeSql("update formactionset set typename ='"+typename+"' where id="+actionid);
	if(!"1".equals(fromintegration)){
		//out.println("<script language=javascript>window.parent.close();dialogArguments.reloadDMLAtion();</script>");
		if("1".equals(isdialog))
	    {
%>
	    <script language=javascript >
	    try
	    {
			var parentWin = parent.parent.getParentWindow(parent);
			parentWin.location.href="/integration/formactionlist.jsp";
			parentWin.closeDialog();
		}
		catch(e)
		{
		}
		</script>
	    <%
	    }
		return;
	}else{
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
			response.sendRedirect("/workflow/dmlaction/FormActionSettingView.jsp?fromintegration="+fromintegration+"&actionid="+actionid+"&typename="+typename);
		}
		return;
	}
}
else if("delete".equals(operate))
{
	String errormsg = "";
	boolean isused = BaseAction.checkFromActionUsed(""+actionid,"1");
	if(!isused)
		FormActionInfoService.deleteFormActionSet(actionid,actionsqlsetid);
	else
		errormsg = "1";
	if(!"1".equals(fromintegration))
		out.println("<script language=javascript>window.parent.close();dialogArguments.reloadDMLAtion();</script>");
	else{
		if("1".equals(isdialog))	    {
			out.println("<script language=javascript>var parentWin = parent.parent.getParentWindow(parent);parentWin.doRefresh();setTimeout(top.Dialog.close,2);</script>");
		}else{
			response.sendRedirect("/integration/formactionlist.jsp");
		}
	}
}
return;
%>