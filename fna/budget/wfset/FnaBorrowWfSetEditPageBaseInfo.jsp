<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("CostControlProcedure:set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(83182,user.getLanguage());
String needfav ="1";
String needhelp ="";

int id = Util.getIntValue(request.getParameter("id"));

int workflowid = 0;
boolean enable = false;
String templateFile = "";
String templateFileMobile = "";

String sql = "select * from fnaFeeWfInfo where id = "+id;
rs.executeSql(sql);
if(rs.next()){
	workflowid = rs.getInt("workflowid");
	enable = 1==rs.getInt("enable");
	templateFile = Util.null2String(rs.getString("templateFile"));
	templateFileMobile = Util.null2String(rs.getString("templateFileMobile"));
}

if("".equals(templateFile)){
	templateFile = FnaWfSet.TEMPLATE_BORROW_FILE;
}
if("".equals(templateFileMobile)){
	templateFileMobile = FnaWfSet.TEMPLATE_BORROW_FILE_MOBILE;
}

String workflowname = "";
if(workflowid > 0){
	sql = "select a.workflowname from workflow_base a where a.id = "+workflowid;
	rs.executeSql(sql);
	if(rs.next()){
		workflowname = Util.null2String(rs.getString("workflowname")).trim();
	}
}
%>

<%@page import="weaver.filter.XssUtil"%><HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:doSave(false),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doSave(false);" 
		    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
<input id="id" name="id" value="<%=id %>" type="hidden" />
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(23753,user.getLanguage())%></wea:item><!-- 流程名称 -->
		<wea:item>
		<%
		String _browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp%3Fsqlwhere="+new XssUtil().put("where isbill=1 and formid<0");
		%>
	        <brow:browser viewType="0" name="workflowid" browserValue='<%=workflowid+"" %>' 
	                browserUrl="<%=_browserUrl %>"
	                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
	                completeUrl="/data.jsp?type=workflowBrowser"  temptitle='<%= SystemEnv.getHtmlLabelName(23753,user.getLanguage())%>'
	                browserSpanValue='<%=FnaCommon.escapeHtml(workflowname) %>' width="80%" 
	                _callback="workflowid_callback" >
	        </brow:browser>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></wea:item><!-- 是否启用 -->
		<wea:item>
   			<input id="enable" name="enable" value="1" type="checkbox" tzCheckbox="true" <%=(enable)?"checked":"" %> />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("64,18493",user.getLanguage())%></wea:item><!-- 模板文件 -->
		<wea:item>
       		<input class="inputstyle" id="templateFile" name="templateFile" maxlength="2000" style="width: 80%;" value="<%=FnaCommon.escapeHtml(templateFile) %>" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("64,18493",user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(31506,user.getLanguage())%>)</wea:item><!-- 模板文件(手机版) -->
		<wea:item>
       		<input class="inputstyle" id="templateFileMobile" name="templateFileMobile" maxlength="2000" style="width: 80%;" value="<%=FnaCommon.escapeHtml(templateFileMobile) %>" />
		</wea:item>
		<wea:item>
			<font color="red" style="font-weight: bold;">
				<%=SystemEnv.getHtmlLabelNames("82482",user.getLanguage())%>：/fna/template/
			</font>
		</wea:item><!-- 模板地址 -->
	</wea:group>
</wea:layout>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" id="btnClose" onclick="onCancel();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script language=javascript>
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

jQuery(document).ready(function(){
	resizeDialog(document);
});

function workflowid_callback(){
	
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
}

//关闭
function doClose(){
	var parentWin = parent.parent.getParentWindow(window);
	parentWin.closeDialog();
}

//保存
function doSave(_openEditPage){
	var id = null2String(jQuery("#id").val());
	var workflowid = null2String(jQuery("#workflowid").val());
	var enable = jQuery("#enable").attr("checked")?1:0;
	var templateFile = null2String(jQuery("#templateFile").val());
	var templateFileMobile = null2String(jQuery("#templateFileMobile").val());
	if(workflowid==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage()) %>");//必填信息不完整
		return;
	}
	try{
		//确定要保存么？
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32130,user.getLanguage()) %>",
			function(){
				hideRightMenuIframe();
				var _data = "operation=editBaseInfo&id="+id+"&workflowid="+workflowid+"&enable="+enable+
					"&templateFile="+templateFile+"&templateFileMobile="+templateFileMobile;
		
				openNewDiv_FnaBudgetViewInner1(_Label33574);
				jQuery.ajax({
					url : "/fna/budget/wfset/FnaBorrowWfSetEditOp.jsp",
					type : "post",
					cache : false,
					processData : false,
					data : _data,
					dataType : "json",
					success: function do4Success(_json){
					    try{
							try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
							if(_json.flag){
								var parentWin = parent.parent.getParentWindow(parent.window);
								parentWin.onBtnSearchClick();
								//onCancel2();
								top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage()) %>");//保存成功
							}else{
								top.Dialog.alert(_json.msg);
							}
		
					    	showRightMenuIframe();
					    }catch(e1){
					    	showRightMenuIframe();
					    }
					}
				});	
			},
			function(){}
		);
	}catch(e1){
		showRightMenuIframe();
	}
}

function onCancel(){
	var dialog = parent.parent.getDialog(parent.window);	
	dialog.closeByHand();
}

function onCancel2(){
	parent.onCancel();	
}

</script>
</BODY>
</HTML>
