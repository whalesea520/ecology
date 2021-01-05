<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.resource.HrmSynDAO" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<HTML>
<HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>

<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />

<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css" />
</HEAD>

<%
if(!HrmUserVarify.checkUserRight("CoreMail:ALL", user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String titlename = SystemEnv.getHtmlLabelName(129787,user.getLanguage());// CoreMail集成
String isused = "0";
String systemaddress = "";
String orgid = "";
String providerid = "1";// 邮件系统供应商ID，默认值为1
String domain = "";// 邮件系统域名
String issync = "";
// 绑定账号字段暂不启用
String bindfield = "";
String bindfieldname = "";

String sql = "select * from coremailsetting";
rs.executeSql(sql);
if(rs.next()) {
	isused = Util.null2String(rs.getString("isuse"));
	systemaddress = Util.null2String(rs.getString("systemaddress"));
	orgid = Util.null2String(rs.getString("orgid"));
	providerid = Util.null2String(rs.getString("providerid"));
	domain = Util.null2String(rs.getString("domain"));
	issync = Util.null2String(rs.getString("issync"));
	
	bindfield = Util.null2String(rs.getString("bindfield"));
}

Map userFiled = HrmSynDAO.getFeildName(4,user.getLanguage());
if("".equals(bindfield)) {
	bindfield = "loginid";
	bindfieldname = SystemEnv.getHtmlLabelName(412,user.getLanguage());
} else {
	bindfieldname = (String)userFiled.get(bindfield);
}
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(20873,user.getLanguage())+",javascript:onSubmitAndSyn(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(25496,user.getLanguage())+",javascript:onSubmitAndTest(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmit()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(20873 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmitAndSyn()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(25496 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmitAndTest()"/>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename %></span>
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="/integration/coremail/coremailsettingOperation.jsp">
	<input type="hidden" id="operation" name="operation" value="save">
	
	<div id="loading" style="display:none;">
	<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
	<span id="loadingspan"></span>
	</div>
	
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
			<wea:item><%=SystemEnv.getHtmlLabelName(26472,user.getLanguage()) %></wea:item><!-- 是否启用 -->
			<wea:item>
				<input class="inputstyle" type="checkbox" tzCheckbox="true" id="isused" name="isused" value="1" <% if(isused.equals("1")) out.println("checked"); %>>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(129923,user.getLanguage()) %></wea:item><!-- 邮件系统地址 -->
			<wea:item>
				<wea:required id="systemaddressimage" required="true" value="<%=systemaddress %>">
					<input class="inputstyle" type="text" style="width:280px!important;" size="100" maxLength="100" id="systemaddress" name="systemaddress" value="<%=systemaddress %>" 
						_noMultiLang='true' onchange='checkinput("systemaddress","systemaddressimage")'>
				</wea:required>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(129970,user.getLanguage()) %></wea:item><!-- 邮件系统域名 -->
			<wea:item>
				<wea:required id="domainimage" required="true" value="<%=domain %>">
					<input class="inputstyle" type="text" style="width:280px!important;" size="100" maxLength="100" id="domain" name="domain" value="<%=domain %>" 
						_noMultiLang='true' onchange='checkinput("domain","domainimage")'>
				</wea:required>
				&nbsp;<SPAN class="e8tips" style="CURSOR: hand" id="remind" title="<%=SystemEnv.getHtmlLabelName(129973,user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(129924,user.getLanguage()) %></wea:item><!-- 邮件系统组织架构标识 -->
			<wea:item>
				<wea:required id="orgidimage" required="true" value="<%=orgid %>">
					<input class="inputstyle" type="text" style="width:280px!important;" size="100" maxLength="100" id="orgid" name="orgid" value="<%=orgid %>" 
						_noMultiLang='true' onchange='checkinput("orgid","orgidimage")'>
				</wea:required>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(129925,user.getLanguage()) %></wea:item><!-- 邮件系统供应商ID -->
			<wea:item>
				<wea:required id="provideridimage" required="true" value="<%=providerid %>">
					<input class="inputstyle" type="text" style="width:280px!important;" size="100" maxLength="100" id="providerid" name="providerid" value="<%=providerid %>" 
						_noMultiLang='true' onchange='checkinput("providerid","provideridimage")'>
				</wea:required>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(81542,user.getLanguage()) %></wea:item><!-- 是否同步组织架构及账号 -->
			<wea:item>
				<input class="inputstyle" type="checkbox" tzCheckbox="true" id="issync" name="issync" value="1" <% if(issync.equals("1")) out.println("checked"); %>>
			</wea:item>
			
			<wea:item attributes="{'samePair':'bindfield','display':'none'}"><%=SystemEnv.getHtmlLabelName(129926,user.getLanguage()) %></wea:item>
			<wea:item attributes="{'samePair':'bindfield','display':'none'}">
				<brow:browser width="280px" viewType="0" browserValue="<%=bindfield %>"  browserSpanValue="<%=bindfieldname %>" 
					browserUrl="/systeminfo/BrowserMain.jsp?mouldID=integration&dmltablename=hrmresource&url=/integration/hrsettingfield.jsp" 
					completeurl='/data.jsp' isMustInput='1' isSingle='true' _callback='onSetTableField' id='bindfield' name='bindfield'></brow:browser>
			</wea:item>
		</wea:group>
	</wea:layout>
	<br/>
</FORM>
</BODY>

<script language="javascript">
jQuery(document).ready(function() {
	jQuery(".e8tips").wTooltip({html:true});
});

function onSetTableField(event,data,name,paras,tg) {
	var obj = null;
	if(typeof(tg) == 'undefined') {
		obj = event.target || event.srcElement;
	} else {
		obj = tg;
	}
	try {
		jQuery(obj).closest("td").find("input[name='bindfield']").val(data.a1);
	} catch(e) {
		
	}
}

function checkAddress() {
	var addr = $("#systemaddress").val();
	// IP校验
	var reg1 = /^((25[0-5]|2[0-4]\d|[01]?\d?\d)\.){3}(25[0-5]|2[0-4]\d|[01]?\d?\d)$/;
	// 域名校验
	var reg2 = /^[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})*(\.[a-zA-Z]{2,6})+\.?$/;
	if(reg1.test(addr) || reg2.test(addr)) {
		return true;
	} else {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129972,user.getLanguage()) %>");
		return false;
	}
}

function checkDomain() {
	var domain = $("#domain").val();
	// 域名校验
	var reg = /^[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})*(\.[a-zA-Z]{2,6})+\.?$/;
	if(reg.test(domain)) {
		return true;
	} else {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129971,user.getLanguage()) %>");
		return false;
	}
}

function onSubmit() {
	var checkvalue = "systemaddress,orgid,domain,providerid";
	
	if(check_form(frmMain,checkvalue) && checkAddress() && checkDomain()) {
		frmMain.submit();
	}
}

function onSubmitAndSyn() {
	var checkvalue = "systemaddress,orgid,domain,providerid";
	
	if(check_form(frmMain,checkvalue) && checkAddress() && checkDomain()) {
		var isused = $("#isused").attr("checked") == true ? "1" : "0";
		if(isused == "0") {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130080,user.getLanguage())%>");
			return;
		}
		var systemaddress = jQuery("#systemaddress").val();
		var domain = jQuery("#domain").val();
		var orgid = jQuery("#orgid").val();
		var providerid = jQuery("#providerid").val();
		var issync = $("#issync").attr("checked") == true ? "1" : "0";
		if(issync == "0") {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130081,user.getLanguage())%>");
			return;
		}
		var bindfield = jQuery("#bindfield").val();
		
		jQuery("#loading").show();
		enableAllmenu();
		jQuery("#loadingspan").text("<%=SystemEnv.getHtmlLabelName(130082,user.getLanguage())%>");
		var params = {operation:"syn",isused:isused,systemaddress:systemaddress,domain:domain,orgid:orgid,providerid:providerid,issync:issync,bindfield:bindfield};
		jQuery.ajax({
	        type: "POST",
	        url: "/integration/coremail/coremailsettingOperation.jsp",
	        data: params,
	        success: function(msg) {
				if(jQuery.trim(msg) == "1") {
	        		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125959,user.getLanguage())%>！");// 初始化成功
	        	} else {
	        		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125960,user.getLanguage())%>！");// 初始化失败
	        	}
	        	jQuery("#loading").hide();
	        	displayAllmenu();
	        }
		});
	}
}

function onSubmitAndTest() {
	var checkvalue = "systemaddress,orgid,domain,providerid";
	
	if(check_form(frmMain,checkvalue) && checkAddress() && checkDomain()) {
		var isused = $("#isused").attr("checked") == true ? "1" : "0";
		if(isused == "0") {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130080,user.getLanguage())%>");
			return;
		}
		var systemaddress = jQuery("#systemaddress").val();
		var domain = jQuery("#domain").val();
		var orgid = jQuery("#orgid").val();
		var providerid = jQuery("#providerid").val();
		var issync = $("#issync").attr("checked") == true ? "1" : "0";
		var bindfield = jQuery("#bindfield").val();
		
		jQuery("#loading").show();
		jQuery("#loadingspan").text("<%=SystemEnv.getHtmlLabelName(25496,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(25007,user.getLanguage())%>...");
		enableAllmenu();
		var params = {operation:"test",isused:isused,systemaddress:systemaddress,domain:domain,orgid:orgid,providerid:providerid,issync:issync,bindfield:bindfield};
		jQuery.ajax({
	        type: "POST",
	        url: "/integration/coremail/coremailsettingOperation.jsp",
	        data: params,
	        success: function(msg) {
				if(jQuery.trim(msg) == "1") {
	        		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32297,user.getLanguage())%>！");//测试通过
	        	} else {
	        		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130079,user.getLanguage())%>");//测试不通过
	        	}
	        	jQuery("#loading").hide();
	        	displayAllmenu();
	        }
		});
	}
}

</script>
</HTML>
