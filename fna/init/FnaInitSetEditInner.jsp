<%@page import="java.text.DecimalFormat"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.general.BrowserElement"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />

<%@ page import="weaver.systeminfo.label.LabelComInfo"%>

<%
if(user.getUID()!=1){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";//通用设置
String needfav ="1";
String needhelp ="";

%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.fna.encrypt.Des"%><html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<script type="text/javascript" src="/fna/encrypt/des/des_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(128608, user.getLanguage())+",javascript:doSave(),_self}";
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post" action="/fna/init/FnaInitSetOperation.jsp">
<input id="operation" name="operation" value="FnaInitData" type="hidden" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(128608,user.getLanguage()) %>" 
				class="e8_btn_top" onclick="doSave();"/><!-- 清除数据 -->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

	<wea:layout type="2col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(128621,user.getLanguage()) %>' attributes="{'itemAreaDisplay':'display'}"><!-- 验证信息 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(128620,user.getLanguage()) %></wea:item><!-- 当前用户密码 -->
			<wea:item>
				<wea:required id="pwdSpan" required="true">
    				<input id="pwd" value="" type="password" style="width: 100px;" onchange='checkinput("pwd","pwdSpan");' />
    			</wea:required>
    			<input id="dStr" name="dStr" value="" type="hidden" />
			</wea:item>
	    </wea:group>
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(128609,user.getLanguage()) %>' attributes="{'itemAreaDisplay':'display'}"><!-- 清除财务相关数据 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(128610,user.getLanguage()) %></wea:item><!-- 清除科目 -->
			<wea:item>
    			<input id="subject" name="subject" value="1" type="checkbox" tzCheckbox="true" onclick="subject_fcc_onClick();" />
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(128611,user.getLanguage()) %></wea:item><!-- 清除成本中心 -->
			<wea:item>
    			<input id="fcc" name="fcc" value="1" type="checkbox" tzCheckbox="true" onclick="subject_fcc_onClick();" />
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(128612,user.getLanguage()) %></wea:item><!-- 清除预算总额 -->
			<wea:item>
    			<input id="fnaBudget" name="fnaBudget" value="1" type="checkbox" tzCheckbox="true" onclick="fnaBudget_onClick();" />
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(128613,user.getLanguage()) %></wea:item><!-- 清除预算费用（审批中、已发生） -->
			<wea:item>
    			<input id="fnaExpense" name="fnaExpense" value="1" type="checkbox" tzCheckbox="true" onclick="fnaExpense_onClick();" />
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(128614,user.getLanguage()) %></wea:item><!-- 清除借还款数据 -->
			<wea:item>
    			<input id="fnaLoan" name="fnaLoan" value="1" type="checkbox" tzCheckbox="true" />
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(128615,user.getLanguage()) %></wea:item><!-- 清除预付款数据 -->
			<wea:item>
    			<input id="fnaAdvance" name="fnaAdvance" value="1" type="checkbox" tzCheckbox="true" />
			</wea:item>
			
	    </wea:group>	    
	</wea:layout>
</form>


<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

function onBtnSearchClick(){}

function fnaBudget_onClick(){
	var _checked = jQuery("#fnaBudget").attr("checked")?true:false;
	if(_checked){
	}else{
		var _checked_subject = jQuery("#subject").attr("checked")?true:false;
		var _checked_fcc = jQuery("#fcc").attr("checked")?true:false;

		jQuery("#fnaBudget").attr("checked", (_checked_subject || _checked_fcc));
		fna_____changeCheckboxStatus4tzCheckBox($G("fnaBudget"), (_checked_subject || _checked_fcc));
	}
}

function fnaExpense_onClick(){
	var _checked = jQuery("#fnaExpense").attr("checked")?true:false;
	if(_checked){
	}else{
		var _checked_subject = jQuery("#subject").attr("checked")?true:false;
		var _checked_fcc = jQuery("#fcc").attr("checked")?true:false;

		jQuery("#fnaExpense").attr("checked", (_checked_subject || _checked_fcc));
		fna_____changeCheckboxStatus4tzCheckBox($G("fnaExpense"), (_checked_subject || _checked_fcc));
	}
}

function subject_fcc_onClick(){
	var _checked_subject = jQuery("#subject").attr("checked")?true:false;
	var _checked_fcc = jQuery("#fcc").attr("checked")?true:false;
	
	jQuery("#fnaBudget").attr("checked",  (_checked_subject || _checked_fcc));
	fna_____changeCheckboxStatus4tzCheckBox($G("fnaBudget"), (_checked_subject || _checked_fcc));
	jQuery("#fnaExpense").attr("checked",  (_checked_subject || _checked_fcc));
	fna_____changeCheckboxStatus4tzCheckBox($G("fnaExpense"), (_checked_subject || _checked_fcc));
}


//切换美化checkbox是否选中
function fna_____changeCheckboxStatus4tzCheckBox(obj, checked) {
	//jQuery(obj).attr("checked", checked);
	if (checked) {
		jQuery(obj).next("span.tzCheckBox").addClass("checked");
		jQuery(obj).next("span.jNiceCheckbox").addClass("jNiceChecked");
	} else {
		jQuery(obj).next("span.tzCheckBox").removeClass("checked");
		jQuery(obj).next("span.jNiceCheckbox").removeClass("jNiceChecked");
	}
}

function doSave(){
	jQuery("#dStr").val("");
	var pwd = jQuery("#pwd").val();
	if(pwd==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("128620,18019",user.getLanguage()) %>!");
		return;
	}
	
	var _checked_subject = jQuery("#subject").attr("checked")?true:false;
	var _checked_fcc = jQuery("#fcc").attr("checked")?true:false;
	var _checked_fnaBudget = jQuery("#fnaBudget").attr("checked")?true:false;
	var _checked_fnaExpense = jQuery("#fnaExpense").attr("checked")?true:false;
	var _checked_fnaLoan = jQuery("#fnaLoan").attr("checked")?true:false;
	var _checked_fnaAdvance = jQuery("#fnaAdvance").attr("checked")?true:false;
	if(_checked_subject || _checked_fcc || _checked_fnaBudget || _checked_fnaExpense || _checked_fnaLoan || _checked_fnaAdvance){
		//您确定要清除财务相关数据么？
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(128616,user.getLanguage()) %>",
			function(){
				//一旦确定，清除的财务数据将无法恢复，您确定要清除财务相关数据么？
				top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(128617,user.getLanguage()) %>",
					function(){
						var _key1 = "<%=Des.KEY1 %>";
						var _key2 = "<%=Des.KEY2 %>";
						var _key3 = "<%=Des.KEY3 %>";
						var dStr = strEnc(pwd,_key1,_key2,_key3);
						jQuery("#dStr").val(dStr);
						form2.submit();
					},function(){}
				);
			},function(){}
		);
	}else{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128618,user.getLanguage()) %>");//请选择要清除的财务数据
	}
}
</script>
</body>
</html>
