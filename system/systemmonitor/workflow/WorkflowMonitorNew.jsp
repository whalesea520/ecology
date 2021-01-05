
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util,weaver.file.Prop,weaver.general.GCONST" %>
<html>
<head>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
<!--begin-->
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray_wev8.css" />
<link rel="stylesheet" type="text/css" href="/css/weaver-ext_wev8.css" />	
<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base_wev8.js"></script>
<script type="text/javascript" src="/js/extjs/ext-all_wev8.js"></script>  
<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/js/weaver-lang-cn-gbk_wev8.js'></script>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_CN_gbk_wev8.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/weaver-lang-en-gbk_wev8.js'></script>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-en_wev8.js'></script>
<%}%>
<!--end-->
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16758,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean isViewPort=true;
int userid=user.getUID();
String logintype = user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
	usertype = 1;
String seclevel = user.getSeclevel();

String selectedworkflow="";
String isuserdefault="";
String wfcustom = Util.null2String(request.getParameter("wfcustom"));
if(!"".equals(wfcustom)){
	wfcustom = " and id in ("+wfcustom+") ";
}
RecordSet.executeSql("select * from workflow_custom where 0=0 "+wfcustom);
Hashtable wfids_hs = new Hashtable();
while(RecordSet.next()){
	String formid_tmp = RecordSet.getString("formID");
	String isbill_tmp = RecordSet.getString("isBill");
	String wfids_tmp = Util.null2String(RecordSet.getString("wfids"));
	if(!"".equals(wfids_tmp) && !"null".equalsIgnoreCase(wfids_tmp.trim())){
		wfids_hs.put("wfids_"+formid_tmp+"_"+isbill_tmp, ","+wfids_tmp+",");
	}
}
//对不同的模块来说,可以定义自己相关的工作流
String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
String selecttab = Util.null2String(request.getParameter("selecttab"));
//......
String topage = Util.null2String(request.getParameter("topage"));
ArrayList NewWorkflowTypes = new ArrayList();
ArrayList NewWorkflows = new ArrayList();
ArrayList NewWorkflowNames = new ArrayList();
StringBuffer items_sb = new StringBuffer();
String sql = "select  * from workflow_base  where isvalid='1' and formid in (select formid from workflow_custom where isbill=workflow_base.isbill "+wfcustom+") and id in (select workflowid as id from workflow_monitor_bound b where b.monitorhrmid = " + user.getUID()+") and exists (select 1 from workflow_currentoperator where workflow_currentoperator.workflowid=workflow_base.id and userid="+userid+" )  order by  workflowtype,id ";
RecordSet.executeSql(sql);

String divStr="";
String wfids="";

while(RecordSet.next()){
	String id = RecordSet.getString("id");
	String formid_tmp = RecordSet.getString("formid");
	String isbill_tmp = RecordSet.getString("isbill");
	String wfids_tmp = Util.null2String((String)wfids_hs.get("wfids_"+formid_tmp+"_"+isbill_tmp));
	if(!"".equals(wfids_tmp) && !"null".equalsIgnoreCase(wfids_tmp.trim())){
		if(wfids_tmp.indexOf(","+id+",") == -1){
			continue;
		}
	}
	wfids += id + ",";
	String wfname = RecordSet.getString("workflowname");
	NewWorkflowTypes.add(RecordSet.getString("workflowtype"));
    NewWorkflows.add(id);
	NewWorkflowNames.add(wfname);
	items_sb.append("{ id:'").append(id).append("', contentEl:'div").append(id).append("', ");
	items_sb.append("title :'").append(wfname).append("' },");

	divStr+="<div id=\"div"+id+"\"><iframe id=\"ifrm_"+id+"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0\" scrolling=\"auto\"></iframe></div>\n";
}
if("".equals(divStr)){
	response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitor.jsp");
}
if(items_sb.length() > 0){
	items_sb.delete(items_sb.length()-1, items_sb.length());
}
if(!"".equals(wfids)){
	wfids = wfids.substring(0, wfids.length()-1);
}

if(NewWorkflows.size() == 0){
	NewWorkflows.add("0");
}
int colspanCount = NewWorkflows.size() + 1;
int wfCount = NewWorkflows.size();
%>
</head>
<BODY>
<%@ include file="/systeminfo/TopTitleExt.jsp"%>
<%=divStr%>

<SCRIPT LANGUAGE="JavaScript">
<!--  
		var isfirst = 1;
		var items=[
		<%=items_sb.toString()%>
		];

		Ext.onReady(function() {
			Ext.QuickTips.init();
			Ext.BLANK_IMAGE_URL = '/js/extjs/resources/images/default/s_wev8.gif';

			var viewport = new Ext.Viewport({
					layout : 'border',
					items : [	
						panelTitle,		
						new Ext.TabPanel({
						    listeners :{
								beforetabchange :function ( tabPanle,  newTab, currentTab ){
									var newTabId=newTab.id;
									if(newTabId!=null){
										var iframe=document.getElementById("ifrm_"+newTabId);
										try{
											iframe.src="/system/systemmonitor/workflow/WorkflowMonitor2New.jsp?workflowid="+newTabId+"&isfirst="+isfirst+"&firstWFids=<%=wfids%>";
											if(isfirst == 1){
												isfirst = 0;
											}
										}catch(e){}
									}
								}
							},
							//title : 'ttt',
							region : 'center',
							activeTab : 0,
							frame : true,
							tabPosition : 'top',
							//minTabWidth : 150,
							//resizeTabs : true,
							enableTabScroll:true,
							items :items
						})
					]
			});
		});

//-->
</SCRIPT>

</body>
</html>
<BODY>


