<%@page import="java.text.DecimalFormat"%>
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
if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

DecimalFormat df = new DecimalFormat("#################################################0.00");

int requestid = Util.getIntValue(request.getParameter("requestid"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
double amountAdvanceBefore = Util.getDoubleValue(request.getParameter("amountAdvanceBefore"), 0.00);
double amountAdvanceAfter = Util.getDoubleValue(request.getParameter("amountAdvanceAfter"), 0.00);
String memo1 = Util.null2String(request.getParameter("memo1")).trim();

String objId = Util.null2String(request.getParameter("objId")).trim();

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=4"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(826, user.getLanguage())
			+ ",javascript:doSave(false),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(83190,user.getLanguage()) %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doSave(false);" 
		    			value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"/><!-- 确定 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
		
<form action="">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(83239,user.getLanguage())%></wea:item><!-- 原借款金额 -->
		<wea:item>
	        <%=df.format(amountAdvanceBefore) %>
	        <input id="amountAdvanceBefore" name="amountAdvanceBefore" value="<%=df.format(amountAdvanceBefore) %>" type="hidden" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83240,user.getLanguage())%></wea:item><!-- 调整后借款金额 -->
		<wea:item>
			<wea:required id="amountAdvanceAfterSpan" required="true">
	        	<input id="amountAdvanceAfter" name="amountAdvanceAfter" value="<%=df.format(amountAdvanceAfter) %>" type="text" 
	        	 	onchange='checkinput("amountAdvanceAfter","amountAdvanceAfterSpan");'/>
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83241,user.getLanguage())%></wea:item><!-- 调整说明 -->
		<wea:item>
			<wea:required id="memo1Span" required="true">
	        	<input id="memo1" name="memo1" value="<%=Util.toScreenForWorkflow(memo1) %>" type="text" 
	        		onchange='checkinput("memo1","memo1Span");'/>
			</wea:required>
		</wea:item>
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
    			value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script language=javascript>
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

jQuery(document).ready(function(){
	resizeDialog(document);
	checkinput("amountAdvanceAfter","amountAdvanceAfterSpan");
	checkinput("memo1","memo1Span");
	controlNumberCheck_jQuery("amountAdvanceAfter", true, 2, true, 18);
});

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
}

//关闭
function doClose(){
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}

//保存
function doSave(_openEditPage){
	var amountAdvanceBefore = null2String(jQuery("#amountAdvanceBefore").val());
	var amountAdvanceAfter = null2String(jQuery("#amountAdvanceAfter").val());
	var memo1 = null2String(jQuery("#memo1").val());
	
	if(amountAdvanceAfter=="" || memo1==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage()) %>");//必填信息不完整
		return;
	}

	var parentWin = parent.getParentWindow(window);
	parentWin.setTzsmValue("<%=objId %>", amountAdvanceBefore, amountAdvanceAfter, memo1);
	onCancel();
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

</script>
</BODY>
</HTML>
