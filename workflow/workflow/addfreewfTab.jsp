<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.general.Util,weaver.file.Prop,weaver.general.GCONST"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="weaver.workflow.workflow.WFMainManager"%>
<!DOCTYPE html>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session" />
<jsp:useBean id="FieldMainManager" class="weaver.workflow.field.FieldMainManager" scope="page" />
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="DetailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %> 
<%
	String wfid = Util.null2String(request.getParameter("wfid"));
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(Util.getIntValue(wfid), 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
	String versionclick = Util.getIntValue(Util.null2String(request.getParameter("versionclick")), 0)+ "";
	ArrayList pointArrayList = DataSourceXML.getPointArrayList();
	//节点模板编辑刷新
	String isnodemode = Util.null2String(request.getParameter("isnodemode"));
	String fromWfEdit = Util.null2String(request.getParameter("fromWfEdit"));
	if (wfid.equals(""))
		wfid = "0";
	//是否为流程模板
	String isTemplate = Util.getIntValue(Util.null2String(request.getParameter("isTemplate")), 0)+ "";
	int typeid = Util.getIntValue(request.getParameter("typeid"), 0);
	//流程版本START by CC
	//流程版本控制类
	WorkflowVersion wfversion = new WorkflowVersion(wfid);
	//是否存在版本
	boolean hasVersion = false;
	//所有版本列表
	List wfversions = null;
	//当前流程最大版本号
	int lastVersionid = 0;
	//当前流程的活动版本
	String activeVersionId = "0";
	//流程模板不存在版本
	if (!"1".equals(isTemplate)) {
		wfversions = wfversion.getAllVersionList();
		
		if (wfversions.size() > 1) {
			hasVersion = true;
		}
				
		lastVersionid = wfversion.getLastVersionID();
		//当前流程的活动流程
		activeVersionId = wfversion.getActiveVersionWFID();
	}
	//流程版本END by CC
	String isbill = "3";
	int formid = 0;
	if (!wfid.equals("0")) {
		WFManager.setWfid(Util.getIntValue(wfid));
		WFManager.getWfInfo();
		isbill = WFManager.getIsBill();
		formid = WFManager.getFormid();
		typeid = WFManager.getTypeid();
	}

	String sql = "";
	String wfMainFieldsOptions = "";//主字段
	String wfDetailFieldsOptions = "";//明细字段
	String wfFieldsOptions = "";//全部字段
	if (formid != 0) {
		if (isbill.equals("0")) {//表单主字段
			sql = "select a.fieldid, b.fieldlable, a.isdetail, a.fieldorder from workflow_formfield a, workflow_fieldlable b "
					+ " where a.isdetail is null and a.formid=b.formid and a.fieldid=b.fieldid and a.formid="
					+ formid
					+ " and b.langurageid = "
					+ user.getLanguage();
			if (RecordSet.getDBType().equals("oracle")) {
				sql += " order by a.isdetail desc,a.fieldorder asc ";
			} else {
				sql += " order by a.isdetail,a.fieldorder ";
			}
		} else if (isbill.equals("1")) {//单据主字段
			sql = "select id,fieldlabel,viewtype,dsporder from workflow_billfield where viewtype=0 and billid="
					+ formid;
			sql += " order by viewtype,dsporder";
		}
		RecordSet.executeSql(sql);
		while (RecordSet.next()) {
			String fieldname = "";
			if (isbill.equals("0"))
				fieldname = RecordSet.getString("fieldlable");
			if (isbill.equals("1"))
				fieldname = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage());
				wfMainFieldsOptions += "<option value=" + RecordSet.getString(1) + ">" + fieldname + "</option>";
		}
		if (isbill.equals("0")) {//表单明细字段
			sql = "select a.fieldid, b.fieldlable, a.isdetail, a.fieldorder from workflow_formfield a, workflow_fieldlable b "
					+ " where a.isdetail=1 and a.formid=b.formid and a.fieldid=b.fieldid and a.formid="
					+ formid
					+ " and b.langurageid = "
					+ user.getLanguage();
			if (RecordSet.getDBType().equals("oracle")) {
				sql += " order by a.groupId,a.isdetail desc,a.fieldorder asc";
			} else {
				sql += " order by a.groupId,a.isdetail,a.fieldorder ";
			}
		} else if (isbill.equals("1")) {//单据明细字段
			sql = "select id,fieldlabel,viewtype,dsporder from workflow_billfield where viewtype=1 and billid="
					+ formid;
			sql += " order by viewtype,dsporder";
		}
		RecordSet.executeSql(sql);
		while (RecordSet.next()) {
			String fieldname = "";
			if (isbill.equals("0"))
				fieldname = RecordSet.getString("fieldlable");
			if (isbill.equals("1"))
				fieldname = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage());
			wfDetailFieldsOptions += "<option value="+ RecordSet.getString(1) + ">" + fieldname+ "</option>";
		}
	}

	wfFieldsOptions = wfMainFieldsOptions + wfDetailFieldsOptions;

	int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
	session.setAttribute("treeleft" + isTemplate, typeid + "");
	Cookie ck = new Cookie("treeleft" + isTemplate + user.getUID(),typeid + "");
	ck.setMaxAge(30 * 24 * 60 * 60);
	response.addCookie(ck);
	//added by cyril on 2008-08-20 for td:9215
	session.setAttribute("treeleft_cnodeid" + isTemplate, wfid + "");
	ck = new Cookie("treeleft_cnodeid" + isTemplate + user.getUID(),wfid + "");
	ck.setMaxAge(30 * 24 * 60 * 60);
	response.addCookie(ck);
	//end by cyril on 2008-08-20 for td:9215
	int isloadleft = Util.getIntValue(request.getParameter("isloadleft"), 0);
	//是否启用计划任务模块
	int isusedworktask = Util.getIntValue(BaseBean.getPropValue("worktask", "isusedworktask"), 0);
	int has_createwpbywf = Util.getIntValue(BaseBean.getPropValue("createwpbywf","hascreatewpbywf"), 0);	
	int isuseNewDesign = Util.getIntValue(BaseBean.getPropValue("workflowNewDesign", "isusingnewDesign"), 0);
	String titlename = "";	
%>
<html>
<head>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp"%>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<link href="/js/timeline/lavalamp_wev8.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/js/tabs/css/e8tabs_wev8.css" type="text/css" />
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/js/jquery/plugins/tooltip/simpletooltip_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/js/src/widget/templates/HtmlTabSet_wev8.css" type="text/css" media=screen>
<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/WorkflowSubwfSetUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script language="JavaScript" src="/js/addRowBg_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language=javascript src="/js/jquery/plugins/tooltip/jquery.tooltip_wev8.js"></script>
<script type="text/javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:searchInput});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();			
	jQuery("#hoverBtnSpan").hoverBtn();
});

function onload(){
	var height = $(".tab_box", window.parent.document).css("height");
	if(height.indexOf("px")>0){
			height = height.substring(0,height.indexOf("px"));
	}
	$("body").css("height",height);
	$(".tab_box").css("height",height-40);
}
</script> 
</head>
<body style="overflow:hidden;margin:0px;padding:0px;" onload="onload()">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<% if (isloadleft == 1) {%>
<script>
   try{
    parent.wfleftFrame.location="wfmanage_left2.jsp?isTemplate=<%=isTemplate%>";
   }catch(e){}//update by liaodong for qc52610 in 20130922
</script>
<% } %>
<input type="hidden" id="hasVersionMark" value="<%=hasVersion %>"/>
<TABLE class=Shadow>
<tr>
<td valign="top">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<% if (!wfid.equals(wfversion.getActiveVersionWFID()) && "true".equalsIgnoreCase(WFMainManager.getCheckBox4InActiveVersion(wfid + "+" + "0"))) { %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>" class="e8_btn_top" onclick="delWorkflowVersion(<%=wfid %>)"/>
			<div style="display:none;">
			<form name="deleteWfForm" id="deleteWfForm" action="/workflow/workflow/deleteVersion.jsp">
				<input type="hidden" name="dajax" value="1">
				<input type="hidden" name="dwfid" value="<%=wfid %>">
			</form>
			</div>
			<% } %>	
			<%if(!isTemplate.equals("1") && !wfid.equals("0")){ %>	
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(125059, user.getLanguage())%>" class="e8_btn_top" onclick="saveAsWorkflow(<%=wfid %>)"/>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" />
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>			
<%
if (hasVersion && wfversions.size() > 1) {
%>
<div class="lavaLampHead" style="top:0px!important;<%if(!versionclick.equals("1")){%>display:none;<%}%>">
	<ul class="lavaLamp" id="timeContent">
		<li><img src="/js/timeline/left_wev8.png" style="cursor:pointer;" onclick="onLeft()" id="leftImg"/> </li>
	<%
	Iterator it = wfversions.iterator();
	while (it.hasNext()) {
		Map versionkv = (Map)it.next();
		String tempWfid = (String)versionkv.get("id");
		String tempVersionid = (String)versionkv.get("version");
		
		//System.out.println();
		//activeVersionId
		String currentlistring = "";
		String currentliclass = "";
		String liclickhandle = "";
		if (tempWfid.equals(wfid)) {
			currentliclass = "currentVersion ";
			currentlistring = "current";
		} else {
			liclickhandle = "forwardToVersion('/workflow/workflow/addwf.jsp?versionclick=1&src=editwf&wfid=" + tempWfid + "&isTemplate=" + isTemplate + "')";
		}
		
		if (tempWfid.equals(activeVersionId)) {
			currentliclass += "activeVersion";
		}
		String liTitleString = SystemEnv.getHtmlLabelName(567, user.getLanguage()) + "：V" + tempVersionid;
		liTitleString += " &#10; ";
		liTitleString += SystemEnv.getHtmlLabelName(882, user.getLanguage()) + ": " + (String)versionkv.get("creater");
		liTitleString += " &#10; ";
		liTitleString += SystemEnv.getHtmlLabelName(454, user.getLanguage()) + ": " + (String)versionkv.get("desc");
	%>
  		<li  class="<%=currentlistring %>"><a class="<%=currentliclass %>" href="#" onmouseover="overEditVersion(this,<%=tempWfid %>)" onclick="<%=liclickhandle %>">V<%=tempVersionid %></a></li>
 	 <%}%>
 	 	<li style="text-align: right;position: absolute;right:10px;"><img src="/js/timeline/right_wev8.png" style="cursor:pointer;" onclick="onRight()" id="rightImg"/>  </li>
    </ul>       
</div>
<%
}
%>	
	<!-- 基础设置二级tab页 START -->
	<div class="box tabs" id="basicset" style="height:100%">
	    <ul class="tab_menu"  style='display:none;'>
	        <li id="tab1" class="current" onclick="getMiaoji(this)"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></li>
	        <li id="tab2" onclick="getMiaoji(this)"><%=SystemEnv.getHtmlLabelName(21946, user.getLanguage())%></li>
	        <li id="tab3" onclick="getMiaoji(this)"><%=SystemEnv.getHtmlLabelName(32383, user.getLanguage())%></li>
	        <li id="tab4" onclick="getMiaoji(this)"><%=SystemEnv.getHtmlLabelName(23796, user.getLanguage())%></li>
	        <li id="tab5" onclick="getMiaoji(this)"><%=SystemEnv.getHtmlLabelName(84508, user.getLanguage())%></li>
	        <li id="tab6" onclick="getMiaoji(this)"><%=SystemEnv.getHtmlLabelName(17614, user.getLanguage())%></li>
	    </ul>
    	<% if (wfid.equals("0")) { %>
        <div class="tab_box"><iframe name="basicsetiframe" src="/workflow/workflow/addfreewfbase.jsp?ajax=1&isTemplate=<%=isTemplate%>&typeid=<%=typeid%>"  frameborder="no" border="0" height="100%" width="100%"></iframe></div>
    	<% } else { %>
    	<div class="tab_box"><iframe name="basicsetiframe" src="/workflow/workflow/addfreewfbase.jsp?ajax=1&src=editwf&wfid=<%=wfid%>&isTemplate=<%=isTemplate%>"  frameborder="no" border="0" height="100%" width="100%"></iframe></div>
    	<% } %>
	</div>
	<!-- 基础设置二级tab页 END --> 

	<!-- 表单管理二级tab页 START -->
	<div class="box tabs" id="tableset" style="display:none">
		<%if(isbill.equals("1") && formid>0){ %>
		<ul class="tab_menu">
	        <li class="current" id="tab01b"><%=SystemEnv.getHtmlLabelName(125027, user.getLanguage())%></li>
	    </ul>
    	<div class="tab_box"><iframe src="/workflow/workflow/BillManagementList.jsp"  frameborder="no" border="0" height="100%" width="100%"></iframe></div>	
		<%}else{ %>
		<ul class="tab_menu">
	        <li class="current" id="tab01"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></li>
	        <li id="tab02"><%=SystemEnv.getHtmlLabelName(15449, user.getLanguage())%></li>
	        <li id="tab03"><%=SystemEnv.getHtmlLabelName(15456, user.getLanguage())%></li>
	        <li id="tab04"><%=SystemEnv.getHtmlLabelName(18368, user.getLanguage())%></li>
	        <li id="tab05"><%=SystemEnv.getHtmlLabelName(18369, user.getLanguage())%></li>
	    </ul>
    	<div class="tab_box"><iframe src=""  frameborder="no" border="0" height="100%" width="100%"></iframe></div>		
		<%}%>
	</div>
	<!-- 表单管理二级tab页 END -->
	
	<!-- 流转设置二级tab页 START -->
	<div class="box tabs" id="flowset" style="display:none">
	    <ul class="tab_menu" style='display:none;'>
	        <li class="current" id="tab002"><%=SystemEnv.getHtmlLabelName(15615, user.getLanguage())%></li>
	    </ul>
	    <div class="tab_box"><iframe src="/workflow/workflow/Editfreewfnode.jsp?ajax=1&wfid=<%=wfid %>" id="flowsetiframe" name="flowsetiframe" frameborder="no" border="0" height="100%" width="100%"></iframe></div>        	        
	</div>
	<!-- 流转设置二级tab页 END -->
	<!-- 高级设置二级tab页 START -->
	<div class="box tabs" id="hightset" style="display:none">
	    <ul class="tab_menu"  style='display:none;'>
	        <li  id="tab0001"><%=SystemEnv.getHtmlLabelName(18361, user.getLanguage())%></li>
	        <li id="tab0002"><%=SystemEnv.getHtmlLabelName(18812, user.getLanguage())%></li>
	        <li id="tab0003"><%=SystemEnv.getHtmlLabelName(19502, user.getLanguage())%></li>
	        <li id="tab0004"  class="current"><%=SystemEnv.getHtmlLabelName(21220, user.getLanguage())%></li>
	        <li id="tab0005"><%=SystemEnv.getHtmlLabelName(19331, user.getLanguage())%></li>
	        <li id="tab0006"><%=SystemEnv.getHtmlLabelName(19344, user.getLanguage())%></li>
	        <li id="tab0007"><%=SystemEnv.getHtmlLabelName(21684, user.getLanguage())%></li>
	        <% if (GCONST.getFIELDLINKAGE()) { %>
	        <li id="tab0008"><%=SystemEnv.getHtmlLabelName(21848, user.getLanguage())%></li>
	        <% } %>
	        <li id="tab0009"><%=SystemEnv.getHtmlLabelName(22231, user.getLanguage())%></li>
	        <%if (has_createwpbywf == 1) {%>
	        <li id="tab0010"><%=SystemEnv.getHtmlLabelName(24086, user.getLanguage())%></li>	
	        <% } %>
	        <% if (isusedworktask == 1) { %>
	        <li id="tab0011"><%=SystemEnv.getHtmlLabelName(22118, user.getLanguage())%></li>
	        <% } %>		        	        	        
	    </ul>
	    <div class="tab_box"><iframe src="/workflow/workflow/WFUrger.jsp?ajax=1&wfid=<%=wfid%>"  frameborder="no" border="0" height="100%" width="100%"></iframe></div>        	        
	</div>	
	<!-- 高级设置二级tab页 END -->			
</td>
</tr>
</TABLE>
<div id="ediWfVersin" onmouseout="outEditVersion()" style="position: absolute;width:375px;height:210px;border: 1px;border-style: solid;border-color: #D7E2E6;background-color: #FFFFFF; display:none;">
<iframe src="" frameborder="no" border="0" height="100%" width="100%"></iframe>
</div>
</body>
</html>
<script src="/js/tabs/jquery.tabs_wev8.js"></script>
<SCRIPT language="javascript" src="/js/addwf_wev8.js"></script>
<script type='text/javascript' src='/js/timeline/lavalamp.min_wev8.js'></script>
<script type='text/javascript' src='/js/timeline/easing_wev8.js'></script>
<script type='text/javascript' src='/js/timeline/lavaready_wev8.js'></script>
<script type="text/javascript">
//基本设置
var tab1URL = "/workflow/workflow/addwf0.jsp?ajax=1&src=editwf&wfid=<%=wfid%>&isTemplate=<%=isTemplate%>";

//表单管理
var tab01bURL = "";
var tab01URL = "";
var tab02URL = "";
var tab03URL = "";
var tab04URL = "";
var tab05URL = "";
<%
boolean isnewform = false;
if (isbill.equals("1")) {
	RecordSet.executeSql("select tablename from workflow_bill where id="+ formid);
	if (RecordSet.next()) {
		String tablename = RecordSet.getString("tablename");
		if (tablename.equals("formtable_main_" + formid * (-1)))
			isnewform = true;
	}
}%>

<%if (isbill.equals("1") && !isnewform && !wfid.equals("0") && formid != -1) {%>
        tab01bURL="/workflow/workflow/BillManagementDetail0.jsp?billId=<%=formid%>";
<%} else {%>
        tab01bURL="/workflow/workflow/BillManagementList.jsp";
<%}
if (isbill.equals("0") && !wfid.equals("0")) {%>
    tab01URL = "/workflow/form/addform.jsp?formid=<%=formid%>&src=editform&ajax=1";
    tab02URL = "/workflow/form/addformfield.jsp?formid=<%=formid%>";
    tab03URL = "/workflow/form/addformfieldlabel.jsp?ajax=1&formid=<%=formid%>";
    tab04URL = "/workflow/form/addformrowcal.jsp?ajax=1&formid=<%=formid%>";
    tab05URL = "/workflow/form/addformcolcal.jsp?ajax=1&formid=<%=formid%>";
<%} else if (isnewform) {%>
	tab01URL = "/workflow/form/editform.jsp?ajax=1&formid=<%=formid%>";
	tab02URL = "/workflow/form/editformfield.jsp?formid=<%=formid%>";
	tab03URL = "/workflow/form/addformfieldlabel0.jsp?formid=<%=formid%>&ajax=1";
	tab04URL = "/workflow/form/addformrowcal0.jsp?formid=<%=formid%>&ajax=1";
	tab05URL = "/workflow/form/addformcolcal0.jsp?formid=<%=formid%>&ajax=1";
<%} else {%>
    tab01URL = "/workflow/form/manageform.jsp?ajax=1";
    tab02URL = "/workflow/workflow/wfError.jsp";
    tab03URL = "/workflow/workflow/wfError.jsp";
    tab04URL = "/workflow/workflow/wfError.jsp";
    tab05URL = "/workflow/workflow/wfError.jsp";
<%}%>

//流转设置
var tab001URL = "/workflow/design/WorkflowLayoutEdit.jsp?wfid=<%=wfid %>";
var tab002URL = "/workflow/workflow/Editfreewfnode.jsp?ajax=1&wfid=<%=wfid%>";
var tab003URL = "/workflow/workflow/addwfnodeportal.jsp?ajax=1&wfid=<%=wfid%>";

//高级设置
var tab0001URL = "/workflow/workflow/wfFunctionManage.jsp?ajax=1&wfid=<%=wfid%>";
var tab0002URL = "/workflow/workflow/WorkFlowPlanSet.jsp?ajax=1&wfid=<%=wfid%>";
var tab0003URL = "/workflow/workflow/WFCode.jsp?ajax=1&wfid=<%=wfid%>";
var tab0004URL = "/workflow/workflow/WFUrger.jsp?ajax=1&wfid=<%=wfid%>";
var tab0005URL = "/workflow/workflow/CreateDocumentByWorkFlow.jsp?ajax=1&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>";
var tab0006URL = "/workflow/workflow/WorkflowSubwfSet.jsp?ajax=1&wfid=<%=wfid%>";
var tab0007URL = "";
var tab0007URL = "/workflow/workflow/LinkageViewAttr.jsp?ajax=1&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>";
<%if (!wfid.equals("0")) {%>
tab0007URL = "/workflow/workflow/LinkageViewAttr.jsp?ajax=1&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>";
<%} else {%>
tab0007URL = "/workflow/workflow/wfError.jsp?msg=<%=SystemEnv.getHtmlLabelName(21685, user.getLanguage())%>";
<%} %>
var tab0008URL = "/workflow/workflow/fieldTrigger.jsp?ajax=1&wfid=<%=wfid%>";
var tab0009URL = "/workflow/workflow/CreateDocumentByAction.jsp?ajax=1&wfid=<%=wfid%>";
var tab0010URL = "/workflow/workflow/CreateWorkplanByWorkflow.jsp?ajax=1&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>";
var tab0011URL = "/workflow/workflow/CreateWorktaskByWorkflow.jsp?ajax=1&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>";

function selectedTitle(tab){
	$(".box").css("display","none");
	$("#"+tab).css("display","");	
	$("#"+tab).find("iframe").each(function() {
        var nowtab = $("#"+tab).find(".current").attr("id");
		var purl=$(this).attr("src");
        var url = getURL(nowtab);
        if(url==="" || purl===url) return;
        $(this).attr("src",url);
    });	
}

$(function(){
    $(".tabs").Tabs({
        event:"click",
        callback:lazyloadForPart,
        getLine:1,
        topHeight:40
    });
    
    if("<%=versionclick%>"==1){
    	$(".box").css("padding-top",30);
    }
}); 

//页面延迟加载
function lazyloadForPart(container) {
    container.find("iframe").each(function() {
        var nowtab = container.find(".current").attr("id");
        var url = getURL(nowtab);
        if(url=="") return;
        if(container.attr("id")!="basicset")
        $(this).attr("src",url);
    });
}

function getURL(tab){
	var URL = "";
	if(tab=="tab1"){
		URL = tab1URL;
	}else if(tab == "tab01b"){
		URL = tab01bURL;
	}else if(tab == "tab01"){
		URL = tab01URL;
	}else if( tab == "tab02"){
		URL = tab02URL;
	}else if( tab == "tab03"){
		URL = tab03URL;
	}else if( tab == "tab04"){
		URL = tab04URL;
	}else if( tab == "tab05"){
		URL = tab05URL;
	}else if( tab == "tab001"){
		URL = tab001URL;
	}else if( tab == "tab002"){
		URL = tab002URL;
	}else if( tab == "tab003"){
		URL = tab003URL;
	}else if( tab == "tab0001"){
		URL = tab0001URL;
	}else if( tab == "tab0002"){
		URL = tab0002URL;
	}else if( tab == "tab0003"){
		URL = tab0003URL;
	}else if( tab == "tab0004"){
		URL = tab0004URL;
	}else if( tab == "tab0005"){
		URL = tab0005URL;
	}else if( tab == "tab0006"){
		URL = tab0006URL;
	}else if( tab == "tab0007"){
		URL = tab0007URL;
	}else if( tab == "tab0008"){
		URL = tab0008URL;
	}else if( tab == "tab0009"){
		URL = tab0009URL;
	}else if( tab == "tab0010"){
		URL = tab0010URL;
	}else if( tab == "tab0011"){
		URL = tab0011URL;
	}
	return URL;
}

function mnToggleleft(){
	var f = window.parent.oTd1.style.display;
	if (f != null) {
		if(f==''){
			window.parent.oTd1.style.display='none';
			<%if(detachable==1){%>
			window.parent.parent.oTd1.style.display='none';
			<%}%>
		}else{ 
			window.parent.oTd1.style.display='';
			<%if(detachable==1){%>
			window.parent.parent.oTd1.style.display='';
			<%}%>
		}
	}
}

function getMiaoji(obj){
	var name = $(obj).html();
	basicsetiframe.window.toMiaoji(name);
}

function searchInput(){
	//TODO
}

function savewf(){
	//TODO
}

var diag_saveaswf = null;
/**
 * 存为新版
 */
function saveAsWorkflow(wfid) {
	var flashs = new Array(); 
	var flashobj = jQuery("#wfdesign")[0];
	if (!!jQuery("#wfdesign")[0]) {
		flashobj = jQuery("#wfdesign")[0].contentWindow.document.getElementById("container");
	}
	if (!!flashobj) {
		flashs[0] = flashobj;
	}
    if (!!window.top.Dialog) {
	   diag_saveaswf = new window.top.Dialog();
	} else {
	   diag_saveaswf = new Dialog();
	}
	diag_saveaswf.currentWindow = window;
	diag_saveaswf.flashs = flashs;
	diag_saveaswf.Width = 376;
	diag_saveaswf.Height = 182;
	diag_saveaswf.Modal = true;
	diag_saveaswf.Title = "<%=SystemEnv.getHtmlLabelName(129416, user.getLanguage())%>"; 
	diag_saveaswf.URL = "/workflow/workflow/addVersion.jsp?targetwfid=" + wfid + "&date=" + new Date().getTime();
	diag_saveaswf.show();
}

function editWorkflowVersion(wfid) {
	
	var flashs = new Array(); 
	var flashobj = jQuery("#wfdesign")[0];
	if (!!jQuery("#wfdesign")[0]) {
		flashobj = jQuery("#wfdesign")[0].contentWindow.document.getElementById("container");
	}
	if (!!flashobj) {
		flashs[0] = flashobj;
	}
	
	diag_saveaswf = new window.top.Dialog();
	diag_saveaswf.currentWindow = window;
	diag_saveaswf.flashs = flashs;
	diag_saveaswf.Width = 376;
	diag_saveaswf.Height = 211;
	diag_saveaswf.Modal = true;
	diag_saveaswf.Title = "<%=SystemEnv.getHtmlLabelName(31018, user.getLanguage())%>"; 
	diag_saveaswf.URL = "/workflow/workflow/editVersion.jsp?targetwfid=" + wfid + "&date=" + new Date().getTime();
	diag_saveaswf.show();
}

function cancelsaveAsWorkflow(){ 
	diag_saveaswf.close();
}

function forwardToVersion(url) {
	window.parent.location.href = url;
}

function showVersion(){
    var isdisplay =  $(".lavaLampHead").css("display");
	if(isdisplay=="none"){
		$(".lavaLampHead").show();
		$(".box").css("padding-top",30);
		lavlinit();
	}else{
		$(".lavaLampHead").hide();
		$(".box").css("padding-top",0);
		$("#ediWfVersin").fadeOut(500)
	}
}

function overEditVersion(obj,wfid){
	    var p = $(obj);
	    var parent = p.parent().parent().parent();
		var offset = parent.offset();
		var url = "/workflow/workflow/editVersion.jsp?targetwfid="+wfid+"&token="+new Date().getTime();;
	    $("#ediWfVersin").css("top",offset.top+parent.height()-2)
	    				 .css("left",p.offset().left-15);
	    $("#ediWfVersin iframe").attr("src",url);				 	   	
	    $("#ediWfVersin").fadeIn(1000);  
}

function outEditVersion(){
	var mouseX = event.pageX;
	var mouseY = event.pageY;
	var obj = $("#ediWfVersin");
	var offset = obj.offset();
	if(mouseX<offset.left || mouseX>(offset.left+obj.width()) || mouseY>(offset.top+obj.height()) || mouseY<(offset.top)){
		$("#ediWfVersin").fadeOut(500);
	}
}

function outEditVersion2(){
	$("#ediWfVersin").fadeOut(500);
}

</script>
