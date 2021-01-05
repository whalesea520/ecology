<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.general.Util,weaver.file.Prop,weaver.general.GCONST"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="weaver.workflow.workflow.WFMainManager"%>
<%@ page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="java.util.Collections" %>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<!DOCTYPE html>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session" />
<jsp:useBean id="FieldMainManager" class="weaver.workflow.field.FieldMainManager" scope="page" />
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="DetailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %> 
<%
	String wfid = Util.null2String(request.getParameter("wfid"));
	String iscreat = Util.null2String(request.getParameter("iscreat"));
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
	List<Map<String,String>> wfversions = null;
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
	
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);

    int subCompanyId=-1;
    int operatelevel=0;

	//流程版本END by CC
	String isbill = "3";
	int formid = 0;
	String isFree = "0";
	if (!wfid.equals("0")) {
		WFManager.setWfid(Util.getIntValue(wfid));
		WFManager.getWfInfo();
		isbill = WFManager.getIsBill();
		formid = WFManager.getFormid();
		typeid = WFManager.getTypeid();
		isFree = WFManager.getIsFree();
	}

	
    
	   //如果开启分权，管理员
    if(detachable==1){  
        if (wfid.equals("0")) {
            subCompanyId = Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId2")),-1);
        }else{
        	subCompanyId=WFManager.getSubCompanyId2();
        }
    }
    session.setAttribute(wfid+"subcompanyid",subCompanyId);
    session.setAttribute("managefield_subCompanyId",subCompanyId);
    operatelevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyId,user,haspermission,"WorkflowManage:All");
    
    
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
<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
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
			<td id="title_tab1" class="rightSearchSpan">
			<% if (!wfid.equals(wfversion.getActiveVersionWFID()) && "true".equalsIgnoreCase(WFMainManager.getCheckBox4InActiveVersion(wfid + "+" + "0")) && operatelevel > 1) { %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top" onclick="delWorkflowVersion(<%=wfid %>)"/>
			<div style="display:none;">
			<form name="deleteWfForm" id="deleteWfForm" action="/workflow/workflow/deleteVersion.jsp">
				<input type="hidden" name="dajax" value="1">
				<input type="hidden" name="dwfid" value="<%=wfid %>">
			</form>
			</div>
			<script type="text/javascript">
				function delWorkflowVersion(vwfid) {
					window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(125127,user.getLanguage()) %>", function (){
									jQuery("#deleteWfForm")[0].submit();
								}, function () {return;}, 520, 90,false);							
				}
			</script>
			<% } %>
			
			<%
			if(!isTemplate.equals("1") && !wfid.equals("0") && operatelevel > 0){ %>	
			<input id="newVersionButton" type="button" value="<%=SystemEnv.getHtmlLabelName(125059,user.getLanguage()) %>" class="e8_btn_top" onclick="saveAsWorkflow(<%=wfid %>)"/>
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</tr>
	</table>			
<%
if (hasVersion && wfversions.size() > 1) {
%>
<div class="lavaLampHead" style="top:0px!important;display:none;">
	<ul class="lavaLamp" id="timeContent">
		<li><img src="/js/timeline/left_wev8.png" style="cursor:pointer;" onclick="onLeft()" id="leftImg"/> </li>
	<%
	 for(Map<String,String> versionkv:wfversions){ 
			String tempWfid = (String)versionkv.get("id");
			String tempVersionid = (String)versionkv.get("version");
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
			String liTitleString = SystemEnv.getHtmlLabelName(567, user.getLanguage())+"：V" + tempVersionid;
			liTitleString += " &#10; ";
			liTitleString += SystemEnv.getHtmlLabelName(882, user.getLanguage())+": " + (String)versionkv.get("creater");
			liTitleString += " &#10; ";
			liTitleString += SystemEnv.getHtmlLabelName(454, user.getLanguage())+": " + (String)versionkv.get("desc");
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
	    <ul class="tab_menu">
	        <li id="tab1" class="current" onclick="getMiaoji(this)"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></li>
	        <%
	        if(wfid.equals("0") || isFree.equals("1")){
		    %>
		    <li id="tabFree" onclick="getMiaoji(this)"><%=SystemEnv.getHtmlLabelName(32825, user.getLanguage())%></li>
		    <%    
		    }
	        %>
	        <li id="tab2" onclick="getMiaoji(this)"><%=SystemEnv.getHtmlLabelName(21946, user.getLanguage())%></li>
	        <li id="tab3" onclick="getMiaoji(this)"><%=SystemEnv.getHtmlLabelName(32383, user.getLanguage())%></li>
	        <li id="tab4" onclick="getMiaoji(this)"><%=SystemEnv.getHtmlLabelName(23796, user.getLanguage())%></li>
	        <li id="tab5" onclick="getMiaoji(this)" style="display: none;"><%=SystemEnv.getHtmlLabelName(84508, user.getLanguage())%></li>
	        <li id="tab6" onclick="getMiaoji(this)"><%=SystemEnv.getHtmlLabelName(17614, user.getLanguage())%></li>
	    </ul>
	    <%
	    String fromString=Util.null2String(request.getParameter("from"));
	    if("prjwf".equalsIgnoreCase(fromString)){
	    %>	
    	<% if (wfid.equals("0") && iscreat.equals("1")) { %>
        <div class="tab_box"><iframe onload="bindInnerRightMenu(event, this)" name="basicsetiframe" src="/workflow/workflow/addwf0.jsp?ajax=1&isTemplate=<%=isTemplate%>&typeid=<%=typeid%>&iscreat=1&<%=request.getQueryString() %>"  frameborder="no" border="0" height="100%" width="100%"></iframe></div>
    	<% }else if (wfid.equals("0") && !iscreat.equals("1")) { %>
        <div class="tab_box"><iframe onload="bindInnerRightMenu(event, this)" name="basicsetiframe" src="/workflow/workflow/addwf0.jsp?ajax=1&isTemplate=<%=isTemplate%>&typeid=<%=typeid%>&<%=request.getQueryString() %>"  frameborder="no" border="0" height="100%" width="100%"></iframe></div>
    	<% }else { %>
    	<div class="tab_box"><iframe onload="bindInnerRightMenu(event, this)" name="basicsetiframe" src="/workflow/workflow/addwf0.jsp?ajax=1&src=editwf&wfid=<%=wfid%>&isTemplate=<%=isTemplate%>&<%=request.getQueryString() %>"  frameborder="no" border="0" height="100%" width="100%"></iframe></div>
    	<% } %>
	    <%
	    }else{
	    %>	
    	<% if (wfid.equals("0") && iscreat.equals("1")) { %>
        <div class="tab_box"><iframe onload="bindInnerRightMenu(event, this)" name="basicsetiframe" src="/workflow/workflow/addwf0.jsp?ajax=1&isTemplate=<%=isTemplate%>&typeid=<%=typeid%>&iscreat=1"  frameborder="no" border="0" height="100%" width="100%"></iframe></div>
    	<% }else if (wfid.equals("0") && !iscreat.equals("1")) { %>
        <div class="tab_box"><iframe onload="bindInnerRightMenu(event, this)" name="basicsetiframe" src="/workflow/workflow/addwf0.jsp?ajax=1&isTemplate=<%=isTemplate%>&typeid=<%=typeid%>"  frameborder="no" border="0" height="100%" width="100%"></iframe></div>
    	<% }else { %>
    	<div class="tab_box"><iframe onload="bindInnerRightMenu(event, this)" name="basicsetiframe" src="/workflow/workflow/addwf0.jsp?ajax=1&src=editwf&wfid=<%=wfid%>&isTemplate=<%=isTemplate%>"  frameborder="no" border="0" height="100%" width="100%"></iframe></div>
    	<% } %>
	    <%
	    }
	    %>
	</div>
	<!-- 基础设置二级tab页 END --> 

	<!-- 表单管理二级tab页 START -->
	<div class="box tabs" id="tableset" style="display:none">
		<%if(isbill.equals("1") && formid>0){ %>
		<ul class="tab_menu">
	        <li id="tab01b"><%=SystemEnv.getHtmlLabelName(125027, user.getLanguage())%></li>
	    </ul>
    	<div class="tab_box"><iframe onload="bindInnerRightMenu(event, this)" src=""  frameborder="no" border="0" height="100%" width="100%"></iframe></div>	
		<%}else{ %>
		<ul class="tab_menu">
	        <li id="tab01"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></li>
	        <li id="tab02"><%=SystemEnv.getHtmlLabelName(15449, user.getLanguage())%></li>
	        <li id="tab03"><%=SystemEnv.getHtmlLabelName(15456, user.getLanguage())%></li>
	        <li id="tab04"><%=SystemEnv.getHtmlLabelName(18368, user.getLanguage())%></li>
	        <li id="tab05"><%=SystemEnv.getHtmlLabelName(18369, user.getLanguage())%></li>
	    </ul>
    	<div class="tab_box"><iframe onload="bindInnerRightMenu(event, this)" src=""  frameborder="no" border="0" height="100%" width="100%"></iframe></div>		
		<%}%>
	</div>
	<!-- 表单管理二级tab页 END -->
	
	<!-- 流转设置二级tab页 START -->
	<div class="box tabs" id="flowset" style="display:none">
	    <ul class="tab_menu">
	        <li id="tab001"><%=SystemEnv.getHtmlLabelName(16459,user.getLanguage()) %></li>
	        <li id="tab002"><%=SystemEnv.getHtmlLabelName(15615, user.getLanguage())%></li>
	        <li id="tab003"><%=SystemEnv.getHtmlLabelName(15606, user.getLanguage())%></li>
	        <li style="float:right;margin-right:10px;display:none;" id="openDelNodeListDialog"><%=SystemEnv.getHtmlLabelNames("126185,15599",user.getLanguage()) %></li>
	    </ul>
	    <div class="tab_box"><iframe onload="bindInnerRightMenu(event, this)" src="" id="flowsetiframe" name="flowsetiframe" frameborder="no" border="0" height="100%" width="100%"></iframe></div>        	        
	</div>
	<!-- 流转设置二级tab页 END -->
	<!-- 高级设置二级tab页 START -->
	<div class="box tabs" id="hightset" style="display:none">
	    <ul class="tab_menu">
	        <li id="tab0001"><%=SystemEnv.getHtmlLabelName(18361, user.getLanguage())%></li>
	        <li id="tab0002"><%=SystemEnv.getHtmlLabelName(18812, user.getLanguage())%></li>
	        <li id="tab0003"><%=SystemEnv.getHtmlLabelName(19502, user.getLanguage())%></li>
	        <li id="tab0004"><%=SystemEnv.getHtmlLabelName(21220, user.getLanguage())%></li>
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
	        <li id="tab0013"><%=SystemEnv.getHtmlLabelName(32752, user.getLanguage())%></li>
	        <li id="tab0012" onclick="replaceTitle()"><%=SystemEnv.getHtmlLabelName(20412, user.getLanguage())%></li>		        	        	        
	    </ul>
	    <div class="tab_box"><iframe onload="bindInnerRightMenu(event, this)" src="/workflow/workflow/wfFunctionManage.jsp"  frameborder="no" border="0" height="100%" width="100%"></iframe></div>        	        
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
<script language="javascript" src="/js/addwf_wev8.js"></script>
<script type='text/javascript' src='/js/timeline/lavalamp.min_wev8.js'></script>
<script type='text/javascript' src='/js/timeline/easing_wev8.js'></script>
<script type='text/javascript' src='/js/timeline/lavaready_wev8.js'></script>
<script type="text/javascript">
//基本设置
var tab1URL = "";
<% if(iscreat.equals("1")){%>
	tab1URL = "/workflow/workflow/addwf0.jsp?ajax=1&src=editwf&wfid=<%=wfid%>&isTemplate=<%=isTemplate%>&iscreat=1";
<% }else{%>
	tab1URL = "/workflow/workflow/addwf0.jsp?ajax=1&src=editwf&wfid=<%=wfid%>&isTemplate=<%=isTemplate%>";
<% }%>
<%
String from=Util.null2String(request.getParameter("from"));
%>
<% if("prjwf".equalsIgnoreCase(from)&& iscreat.equals("1")){%>
tab1URL = "/workflow/workflow/addwf0.jsp?ajax=1&src=editwf&wfid=<%=wfid%>&isTemplate=<%=isTemplate%>&iscreat=1&<%=request.getQueryString() %>";
<% }else if("prjwf".equalsIgnoreCase(from)){%>
tab1URL = "/workflow/workflow/addwf0.jsp?ajax=1&src=editwf&wfid=<%=wfid%>&isTemplate=<%=isTemplate%>&<%=request.getQueryString() %>";
<% }%>
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
		if (tablename.equals("formtable_main_" + formid * (-1)) || tablename.startsWith("uf_"))
			isnewform = true;
	}
}%>

<%if (isbill.equals("1") && !isnewform && !wfid.equals("0") && formid != -1) {%>
        tab01bURL="/workflow/workflow/BillManagementDetail0.jsp?billId=<%=formid%>&isbill=<%=isbill%>";
<%} else {%>
        tab01bURL="/workflow/workflow/BillManagementList.jsp?isbill=<%=isbill%>";
<%}
if (isbill.equals("0") && !wfid.equals("0")) {%>
    tab01URL = "/workflow/form/addform.jsp?formid=<%=formid%>&src=editform&ajax=1&isbill=<%=isbill%>";
    tab02URL = "/workflow/form/addformfield.jsp?formid=<%=formid%>&isbill=<%=isbill%>";
    tab03URL = "/workflow/form/addformfieldlabel.jsp?ajax=1&formid=<%=formid%>&isbill=<%=isbill%>";
    tab04URL = "/workflow/form/addformrowcal.jsp?ajax=1&formid=<%=formid%>&isbill=<%=isbill%>";
    tab05URL = "/workflow/form/addformcolcal.jsp?ajax=1&formid=<%=formid%>&isbill=<%=isbill%>";
<%} else if (isnewform) {%>
	tab01URL = "/workflow/form/editform.jsp?ajax=1&formid=<%=formid%>&isbill=<%=isbill%>";
	tab02URL = "/workflow/form/editformfield.jsp?formid=<%=formid%>&isbill=<%=isbill%>";
	tab03URL = "/workflow/form/addformfieldlabel0.jsp?formid=<%=formid%>&ajax=1&isbill=<%=isbill%>";
	tab04URL = "/workflow/form/addformrowcal_new.jsp?formid=<%=formid%>&ajax=1&isbill=<%=isbill%>";
	tab05URL = "/workflow/form/addformcolcal_new.jsp?formid=<%=formid%>&ajax=1&isbill=<%=isbill%>";
<%} else {%>
    tab01URL = "/workflow/form/manageform.jsp?ajax=1&isbill=<%=isbill%>";
    tab02URL = "/workflow/workflow/wfError.jsp";
    tab03URL = "/workflow/workflow/wfError.jsp";
    tab04URL = "/workflow/workflow/wfError.jsp";
    tab05URL = "/workflow/workflow/wfError.jsp";
<%}%>

//流转设置
var tab001URL = "/workflow/design/WorkflowLayoutEdit.jsp?wfid=<%=wfid %>";
var tab002URL = "/workflow/workflow/Editwfnode.jsp?ajax=1&wfid=<%=wfid%>";
var tab003URL = "/workflow/workflow/addwfnodeportal.jsp?ajax=1&wfid=<%=wfid%>";

//高级设置
var tab0001URL = "/workflow/workflow/wfFunctionManage.jsp?ajax=1&wfid=<%=wfid%>";
var tab0002URL = "/workflow/workflow/WorkFlowPlanSet.jsp?ajax=1&wfid=<%=wfid%>";
var tab0003URL = "/workflow/workflow/WFCode.jsp?ajax=1&wfid=<%=wfid%>";
var tab0004URL = "/workflow/workflow/WFUrger.jsp?ajax=1&wfid=<%=wfid%>";
var tab0005URL = "/workflow/workflow/CreateDocumentByWorkFlowForWf.jsp?isdialog=0&ajax=1&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>";
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
var tab0012URL = "/workflow/workflow/ListFormByWorkflow.jsp?ajax=1&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>&subcompanyid=<%=subCompanyId%>";
var tab0013URL = "/workflow/workflow/Browsedatadefinition.jsp?ajax=1&wfid=<%=wfid%>";

function selectedTitle(tab){
	$(".box").css("display","none");
	$("#"+tab).css("display","");	
	$(".current").removeClass("current");
	$(".magic-line").css("left","8px").css("width","32px");
	if("tableset" === tab){
		$("#tab01").addClass("current");
		$("#tab01b").addClass("current");
	}else if("flowset" === tab)
	{
		$("#tab001").addClass("current");
	}else if("hightset" === tab)
	{
		$("#tab0001").addClass("current");
    }
	$("#"+tab).find("iframe").each(function() {
        var nowtab = $("#"+tab).find(".current").attr("id");
        var url = getURL(nowtab);
        if(url=="") return;
        showOrHideNodeListBtn(nowtab);
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
}); 


jQuery('#openDelNodeListDialog').click(function(event){
	opennodedellist();
	event.stopImmediatePropagation();
});

function opennodedellist(){
	var title = "<%=SystemEnv.getHtmlLabelName(33564,user.getLanguage())%>";
	var url = "/workflow/selectItem/selectItemMain.jsp?topage=deleteNodeList&wfid=<%=wfid%>";
	var diagtemp = new window.top.Dialog();
	diagtemp.currentWindow = window;	
	diagtemp.URL = url;
	diagtemp.Width = 1020;
	diagtemp.Height = 580;
	diagtemp.Title = title
	diagtemp.Drag = true;
	diagtemp.show();	
}

//页面延迟加载
function lazyloadForPart(container) {
    container.find("iframe").each(function() {
        var nowtab = container.find(".current").attr("id");
        var url = getURL(nowtab);
        if(url=="") return;
        if(container.attr("id")!="basicset"){
			showOrHideNodeListBtn(nowtab);
	        $(this).attr("src",url);
        }
    });
}

function showOrHideNodeListBtn(nowtab){
   	  if("tab002" === nowtab){
      	jQuery('#openDelNodeListDialog').css('display','block');
      }else{
      	jQuery('#openDelNodeListDialog').css('display','none');
      }
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
	}else if( tab == "tab0012"){
		URL = tab0012URL;
	}else if( tab == "tab0013"){
		URL = tab0013URL;
	}
	showVersion('false');
	return URL;
}
function doSupSearch(){
   
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

function showVersion(flag){
    var isdisplay =  $(".lavaLampHead").css("display");
	if((isdisplay=="none" && 'false' != flag) || 'true' == flag){
		$(".lavaLampHead").show();
		$(".box").css("padding-top",30);
		lavlinit();
	}else{
		$(".lavaLampHead").hide();
		$(".box").css("padding-top",0);
		//$("#ediWfVersin").fadeOut(500)
		$("#ediWfVersin").hide()
	}
}

function overEditVersion(obj,wfid){
	    var p = $(obj);
	    var parent = p.parent().parent().parent();
		var offset = parent.offset();
		var url = "/workflow/workflow/editVersion.jsp?targetwfid="+wfid+"&token="+new Date().getTime() + "&thisworkflowid=" + <%= wfid%>;
	    $("#ediWfVersin").css("top",offset.top+parent.height()-2)
	    				 .css("left",p.offset().left-15);
	    $("#ediWfVersin iframe").attr("src",url);				 	   	
	    //$("#ediWfVersin").fadeIn(1000);  
	    $("#ediWfVersin").show();  
}

function outEditVersion(){
	var mouseX = event.pageX;
	var mouseY = event.pageY;
	var obj = $("#ediWfVersin");
	var offset = obj.offset();
	if(mouseX<offset.left || mouseX>(offset.left+obj.width()) || mouseY>(offset.top+obj.height()) || mouseY<(offset.top)){
		//$("#ediWfVersin").fadeOut(500);
		$("#ediWfVersin").hide();
	}
}

function outEditVersion2(){
	//$("#ediWfVersin").fadeOut(500);
	$("#ediWfVersin").hide();
}

function bindInnerRightMenu(e, target) {
	var rightmenuiframe; 
	try {
		rightmenuiframe = target.contentWindow.document.getElementById("rightMenuIframe").contentWindow;
	} catch (e) {}
	if (!!!rightmenuiframe) {
		setTimeout(function () {
			bindInnerRightMenu(e, target);
		}, 100);
		return ;
	}
	var e8_head=$("div.e8_boxhead",window.parent.document);
	if(e8_head.length==0){
		var e8_head=$("div#rightBox",window.parent.document);
	}
	jQuery(".cornerMenu",window.parent.document).unbind("click");
	jQuery(".cornerMenu",window.parent.document).click(function(e){
		bindCornerMenuEvent(e8_head, target.contentWindow, e);
		return false;
	});
}
</script>
