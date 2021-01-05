<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<%
if(!HrmUserVarify.checkUserRight("CostControlProcedure:set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

boolean enable = true;
String templateFile = FnaWfSet.TEMPLATE_REPAYMENT_FILE;
String templateFileMobile = FnaWfSet.TEMPLATE_REPAYMENT_FILE_MOBILE;
%>

<%@page import="weaver.filter.XssUtil"%><HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(83183,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:doSave(false),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(32159, user.getLanguage())
			+ ",javascript:doSave(true),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(83183,user.getLanguage()) %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doSave(false);" 
		    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doSave(true);" 
		    			value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>"/><!-- 保存并进入详细设置 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
		
<form action="">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(23753,user.getLanguage())%></wea:item><!-- 流程名称 -->
		<wea:item>
		<%
		String _browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp%3Fsqlwhere="+new XssUtil().put("where isbill=1 and formid<0");
		%>
	        <brow:browser viewType="0" name="workflowid" browserValue='<%="" %>' 
	                browserUrl="<%=_browserUrl %>"
	                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
	                completeUrl="/data.jsp?type=workflowBrowser" temptitle='<%= SystemEnv.getHtmlLabelName(23753,user.getLanguage())%>'
	                browserSpanValue='<%="" %>' width="70%" 
	                _callback="workflowid_callback" >
	        </brow:browser>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></wea:item><!-- 是否启用 -->
		<wea:item>
   			<input id="enable" name="enable" value="1" type="checkbox" tzCheckbox="true" <%=(enable)?"checked":"" %> />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("64,18493",user.getLanguage())%></wea:item><!-- 模板文件 -->
		<wea:item>
       		<input class="inputstyle" id="templateFile" name="templateFile" maxlength="2000" style="width: 80%;" value="<%=templateFile%>" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("64,18493",user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(31506,user.getLanguage())%>)</wea:item><!-- 模板文件(手机版) -->
		<wea:item>
       		<input class="inputstyle" id="templateFileMobile" name="templateFileMobile" maxlength="2000" style="width: 80%;" value="<%=templateFileMobile%>" />
		</wea:item>
		<wea:item>
			<font color="red" style="font-weight: bold;">
				<%=SystemEnv.getHtmlLabelNames("82482",user.getLanguage())%>：/fna/template/
			</font>
		</wea:item><!-- 模板地址 -->
	</wea:group>
</wea:layout>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script language=javascript>
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

jQuery(document).ready(function(){
});
resizeDialog(document);

function workflowid_callback(){
	
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
}

//关闭
function doClose(){
	//var parentWin = parent.getParentWindow(window);
	//parentWin.closeDialog();
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}

//保存
function doSave(_openEditPage){
	var workflowid = null2String(jQuery("#workflowid").val());
	var enable = jQuery("#enable").attr("checked")?1:0;
	var templateFile = null2String(jQuery("#templateFile").val());
	var templateFileMobile = null2String(jQuery("#templateFileMobile").val());
	if(workflowid==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage()) %>");//必填信息不完整
		return;
	}
	hideRightMenuIframe();
	try{
		var _data = "operation=add&workflowid="+workflowid+"&enable="+enable+
			"&templateFile="+templateFile+"&templateFileMobile="+templateFileMobile;

		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/budget/wfset/FnaRepaymentWfSetEditOp.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
			    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					if(_json.flag){
						var parentWin = parent.getParentWindow(window);
						var dialog = parent.getDialog(parentWin);
						if(_openEditPage){
							parentWin.openEditPage(_json.id, null, null, 2, parentWin);
						}else{
							parentWin.onBtnSearchClick();
							onCancel();
						}
					}else{
						top.Dialog.alert(_json.msg);
					}
			    	showRightMenuIframe();
			    }catch(e1){
			    	showRightMenuIframe();
			    }
			}
		});	
	}catch(e1){
		showRightMenuIframe();
	}
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

</script>
</BODY>
</HTML>
