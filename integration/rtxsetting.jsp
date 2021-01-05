
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.resource.HrmSynDAO"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>

<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />

<jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page"/>

<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script type="text/javascript" src="ZeroClipboard.js"></script>

<STYLE>
	.vis1	{ visibility:visible }
	.vis2	{ visibility:hidden }
	.vis3   { display:inline}
	.vis4   { display:none }
	span.itemspan {
		float:left!important;
		line-height:26px!important;
		vertical-align:middle!important;
		padding-right:10px;
	}
</STYLE>
</head>

<%
boolean isLdap=false;
String mode = Prop.getPropValue(GCONST.getConfigFile(), "authentic");
if (mode != null && mode.equals("ldap")) {
    isLdap = true;
}

if(!HrmUserVarify.checkUserRight("intergration:rtxsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String test = Util.null2String(request.getParameter("test"));
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33387,user.getLanguage());//集成
String needfav ="1";
String needhelp ="";

String rtxserverurl = "";
String rtxserverouturl = "";
String rtxserverport = "";
String rtxOrElinkType = "";
String rtxOnload = "";
String rtxDenyHrm = "";
String isusedtx = "";
String rtxVersion = "";
String rtxAlert = "";
String domainName = "";
String rtxConnServer = "";

String userattr = "";
String username = "";
String rtxLoginToOA = "";
String impwd = "";
String isDownload = "";
String sql = "select * from RTXSetting";
rs.executeSql(sql);
if(rs.next())
{
	isusedtx = Util.null2String(rs.getString("IsusedRtx"));
	rtxserverurl = Util.null2String(rs.getString("RTXServerIP"));
	rtxserverouturl = Util.null2String(rs.getString("RTXServerOutIP"));
	rtxserverport = Util.null2String(rs.getString("RTXServerPort"));
	rtxOrElinkType = Util.null2String(rs.getString("RtxOrOCSType"));
	rtxVersion = Util.null2String(rs.getString("RTXVersion"));
	rtxOnload = Util.null2String(rs.getString("RtxOnload"));
	rtxDenyHrm = Util.null2String(rs.getString("RtxDenyHrm"));
	rtxAlert = Util.null2String(rs.getString("RtxAlert"));
	domainName = Util.null2String(rs.getString("domainName"));
	rtxConnServer = Util.null2String(rs.getString("rtxConnServer"));	
	
	userattr = Util.null2String(rs.getString("userattr"));
	//username = Util.null2String(rs.getString("username"));
	rtxLoginToOA = Util.null2String(rs.getString("rtxLoginToOA"));
	impwd = Util.null2String(rs.getString("impwd"));
	isDownload = Util.null2String(rs.getString("isDownload"));
}
if(rtxConnServer.equals("")){
	rtxConnServer = "8000";
}
Map userFiled = HrmSynDAO.getFeildName(4,user.getLanguage());
if("".equals(userattr)){
	userattr = "loginid";
	username = SystemEnv.getHtmlLabelName(412,user.getLanguage());
}else{
	username = (String)userFiled.get(userattr);
}
String oaaddress = "";
//获取oa的设置地址
sql = "select * from SystemSet";
rs.executeSql(sql);
if(rs.next()){
	oaaddress = rs.getString("oaaddress");
}
if(!"".equals(oaaddress) && oaaddress.endsWith("/")){
	oaaddress=oaaddress.substring(0,oaaddress.length()-1);
}

boolean isDoingRtxop = false;

boolean dept_flag = OrganisationCom.isRtxDeptOpFlag();
boolean hrm_flag = OrganisationCom.isRtxHrmOpFlag();
boolean rtxop_flag = OrganisationCom.isRtxOpFlag();

isDoingRtxop = rtxop_flag && (dept_flag || hrm_flag);

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
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="/integration/rtxsettingOperation.jsp">
<input type="hidden" id="method" name="method" value="add">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
	  <wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage()) %></wea:item><!-- 是否启用 -->
	  <wea:item>
			<input class="inputstyle" type=checkbox tzCheckbox='true' id="isusedtx" name="isusedtx" value="1" <%if(isusedtx.equals("1"))out.println("checked"); %>>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage()) %></wea:item><!-- 类型 -->
	  <wea:item>
			<select style='width:120px!important;' id="rtxOrElinkType" name="rtxOrElinkType"  onchange='getType(this.value)'>
				<option value="0" <%if(rtxOrElinkType.equals("") || rtxOrElinkType.equals("0")) out.println("selected"); %>>RTX</option>
				<option value="1" <%if(rtxOrElinkType.equals("1")) out.println("selected"); %>>OCS</option>
				<option value="2" <%if(rtxOrElinkType.equals("2")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%><!-- 其它 --></option>
			</select>
	  </wea:item>
	  
	  <wea:item attributes="{'samePair':'domainName','display':'none'}"><%=SystemEnv.getHtmlLabelName(81647,user.getLanguage()) %></wea:item>
	  <wea:item attributes="{'samePair':'domainName','display':'none'}">
	  	<wea:required id="domainNameImage" required="true" value='<%=domainName %>'>
	  	<input class="inputstyle" style='width:280px!important;' type=text size=50 maxLength="100" id="domainName" name="domainName" value="<%=domainName %>" onchange='checkinput("domainName","domainNameImage")'>
	  	</wea:required>
	  </wea:item>   
	  <wea:item><%=SystemEnv.getHtmlLabelName(32286,user.getLanguage()) %></wea:item><!-- RTX服务器地址 -->
	  <wea:item>
	  	<input class="inputstyle" style='width:280px!important;' type=text size=50 maxLength="100" id="rtxserverurl" name="rtxserverurl" value="<%=rtxserverurl %>" >
	  </wea:item>
	  <!-- rtx属性 start-->
	   <wea:item attributes="{'samePair':'rtxattr'}"><%=SystemEnv.getHtmlLabelName(32151,user.getLanguage()) %></wea:item><!-- RTX外网服务器地址 -->
	  <wea:item attributes="{'samePair':'rtxattr'}">
	  	<input class="inputstyle" style='width:280px!important;' type=text size=50 maxLength="100" id="rtxserverouturl" name="rtxserverouturl" value="<%=rtxserverouturl %>">
	  </wea:item>
	  <wea:item attributes="{'samePair':'rtxattr'}">RTX<%=SystemEnv.getHtmlLabelName(84748,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage()) %></wea:item><!-- RTX中间件端口号 -->
	  <wea:item attributes="{'samePair':'rtxattr'}">
			<input class="inputstyle" style='width:280px!important;' type=text size=50 maxLength="100" id="rtxserverport" name="rtxserverport" value="<%=rtxserverport%>" >
	  </wea:item>
	  <wea:item attributes="{'samePair':'rtxattr'}">RTX<%=SystemEnv.getHtmlLabelName(15038,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage()) %></wea:item><!-- RTX服务器端口号 -->
	  <wea:item attributes="{'samePair':'rtxattr'}">
			<input class="inputstyle" style='width:280px!important;' type=text size=50 maxLength="100" id="rtxConnServer" name="rtxConnServer" value="<%=rtxConnServer%>" >
	  </wea:item>
	  <wea:item attributes="{'samePair':'rtxattr'}"><%=SystemEnv.getHtmlLabelName(567,user.getLanguage()) %></wea:item><!-- rtx版本 -->
	  <wea:item attributes="{'samePair':'rtxattr'}">
			<input class="inputstyle" style='width:280px!important;' type=text size=50 maxLength="100" id="rtxVersion" name="rtxVersion" value="<%=rtxVersion%>" >
	  </wea:item>
	 <!-- rtx属性 end-->
	  <wea:item><%=SystemEnv.getHtmlLabelName(81542,user.getLanguage()) %></wea:item><!-- 是否同步组织架构及账号 -->
	    <wea:item>
			<input class="inputstyle" type=checkbox tzCheckbox='true' id="rtxDenyHrm" name="rtxDenyHrm" value="1" <%if(rtxDenyHrm.equals("1"))out.println("checked"); %>>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(24701,user.getLanguage()) %></wea:item><!-- RTX是否自动登录 -->
	    <wea:item>
			<input class="inputstyle" type=checkbox tzCheckbox='true' id="rtxOnload" name="rtxOnload" value="1" <%if(rtxOnload.equals("1"))out.println("checked"); %>>
	  </wea:item>
	  
	  <wea:item attributes="{'samePair':'impwdspan'}"><%=SystemEnv.getHtmlLabelName(126054,user.getLanguage()) %></wea:item><!-- 密码 -->
	  <wea:item attributes="{'samePair':'impwdspan'}">
	  	<%-- <wea:required id="impwdimage"  value="<%=impwd%>"> --%>
	  	<input class="inputstyle" style='width:280px!important;' type=password maxLength="20" id="impwd" name="impwd" value="<%=impwd %>" onchange='checkinput("impwd","impwdimage")'>
	  	<%-- </wea:required> --%>
	  </wea:item>
	  
	 <wea:item><%=SystemEnv.getHtmlLabelName(81549,user.getLanguage()) %></wea:item><!-- RTX流程到达提醒 -->
	    <wea:item>
			<input class="inputstyle" type=checkbox tzCheckbox='true' id="rtxOnload" name="rtxAlert" value="1" <%if(rtxAlert.equals("1"))out.println("checked"); %>>
	  </wea:item>
	  <wea:item attributes="{'samePair':'otherattr'}"><%=SystemEnv.getHtmlLabelName(28032,user.getLanguage()) %>IM<%=SystemEnv.getHtmlLabelName(83594,user.getLanguage()) %></wea:item><!-- 绑定rtx账号 -->
	    <wea:item attributes="{'samePair':'otherattr'}">
			<brow:browser viewType="0"  browserValue="<%=userattr%>"  browserSpanValue="<%=username%>" 
				browserUrl="/systeminfo/BrowserMain.jsp?mouldID=integration&dmltablename=hrmresource&url=/integration/hrsettingfield.jsp"
				isMustInput='1' name='userattr1' isSingle='true' _callback='onSetTableField'
				completeUrl='/data.jsp' width="280px"></brow:browser>
	  </wea:item>
	  <wea:item attributes="{'samePair':'reversallogin'}">IM<%=SystemEnv.getHtmlLabelName(125918,user.getLanguage()) %></wea:item><!-- RTX反向登陆 -->
	    <wea:item attributes="{'samePair':'reversallogin'}">
			<input class="inputstyle" type=checkbox tzCheckbox='true' id=rtxLoginToOA name="rtxLoginToOA" value="1" <%if(rtxLoginToOA.equals("1"))out.println("checked"); %> onclick="getAccountType();">
	  </wea:item>
	  <wea:item attributes="{'samePair':'extendedattr','display':'none'}">IM<%=SystemEnv.getHtmlLabelName(125918,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></wea:item><!-- RTX反向登陆地址 -->
	    <wea:item attributes="{'samePair':'extendedattr','display':'none'}">
			<span id="inputface"></span>&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" id="copycardid" value="<%=SystemEnv.getHtmlLabelName(77, user.getLanguage()) +SystemEnv.getHtmlLabelName(83578, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:copyRow();"/>&nbsp;&nbsp;
	  </wea:item>
	  <wea:item attributes="{'samePair':'isDownload'}"><%=SystemEnv.getHtmlLabelName(129749,user.getLanguage())%></wea:item><!-- 下载项是否取消 -->
	    <wea:item attributes="{'samePair':'isDownload'}">
			<input class="inputstyle" type=checkbox tzCheckbox='true' id=isDownload name="isDownload" value="1" <%if(isDownload.equals("1"))out.println("checked");%>">
				  	<SPAN class="e8tips" style="CURSOR: hand" id=dremind title="开启此开关，用户登录系统后，未安装IM插件会有下载插件提示信息"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
			
	  </wea:item>
	  
	  <wea:item attributes="{'samePair':'download'}"><%=SystemEnv.getHtmlLabelName(84748, user.getLanguage())+SystemEnv.getHtmlLabelName(258, user.getLanguage())%></wea:item><!-- 中间件 -->
	    <wea:item attributes="{'samePair':'download'}">
			<a href="/resource/weaver_rtxservice.zip" style="font-size: 12px;cursor:hand;color:#007adc;text-decoration:none;">&nbsp;<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></a>
	  </wea:item>
	</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
			  <wea:item attributes="{'colspan':'2'}">
				  	<SPAN class="e8tips" style="CURSOR: hand; color:red" id=remind title="1、<%=SystemEnv.getHtmlLabelName(128494,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(128494,user.getLanguage()) %></SPAN>
			
			  </wea:item>
			</wea:group>
</wea:layout>
<br>
  </FORM>
</BODY>
<script language="javascript">
$(document).ready(function(){
	getType('<%=rtxOrElinkType%>');
	copyRow();
});
function copyRow(){
	var txt =jQuery("#inputface").text();
	var clip = new ZeroClipboard.Client(); // 新建一个对象
	clip.setHandCursor( true );
	clip.setText(txt); // 设置要复制的文本。
	clip.addEventListener( "mouseUp", function(client) {
        var samePairTds = jQuery("td[_samePair*='extendedattr']");
        if(samePairTds.css("display")!="none"){

            alert('<%=SystemEnv.getHtmlLabelName(126081, user.getLanguage())%>');
        }
	});
	clip.glue("copycardid"); // 和上一句位置不可调换
}
function getAccountType(){
	copyRow();
	var checked = $("#rtxLoginToOA").attr("checked");
	if(checked){
		showEle("extendedattr");
	}else{
		hideEle("extendedattr");
	}
	var getType = $("#rtxOrElinkType").val();
	if(getType == 0){
		showEle("download");
	}else{
		hideEle("download");
	}
}
function onSetTableField(event,data,name,paras,tg){
	var obj = null;
		//alert(typeof(tg)+"  event : "+event);
		if(typeof(tg)=='undefined'){
			obj= event.target || event.srcElement;
		}
		else
		{
			obj = tg;
		}
		try
		{
			//alert("obj.parentElement.parentElement.parentElement.parentElement : "+obj.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.outerHTML);
			//obj.parentElement.parentElement.parentElement.parentElement.parentElement.nextSibling.value = data.name;
			jQuery(obj).closest("td").find("input[name='userattr1']").val(data.a1);
			//alert(obj.parentElement.parentElement.parentElement.parentElement.nextSibling.outerHTML+"  "+obj.parentElement.parentElement.parentElement.parentElement.nextSibling.value)
		}
		catch(e)
		{
		}
}
function onSubmit(){
	//QC319856[80][90][建议]IM集成设置-建议 OCS类型，域名 作为必填项 start
	var checkvalue = "";
	var rtxOrElinkType = $("#rtxOrElinkType").val();
	if(rtxOrElinkType == "1"){
		checkvalue = "domainName";
	}
	
	if(check_form(frmMain,checkvalue)){
        frmMain.submit();
    }
	//QC319856[80][90][建议]IM集成设置-建议 OCS类型，域名 作为必填项 end
}

function _fnaOpenDialog(_url, _title, _w, _h){
	diag = new window.top.Dialog();
	diag.currentWindow = window;
	diag.URL = _url;
	diag.Title = _title;
	diag.Width = _w;
	diag.Height = _h;
	
	diag.isIframe=false;
	
	diag.show();
}


 function onSubmitAndSyn(){
	//QC319856[80][90][建议]IM集成设置-建议 OCS类型，域名 作为必填项 start
		var rtxOrElinkType = $("#rtxOrElinkType").val();
		if(rtxOrElinkType == "1"){
			if(!check_form(frmMain,"domainName")){
				return false;
			}			
		}	
	//QC319856[80][90][建议]IM集成设置-建议 OCS类型，域名 作为必填项 end
	 
	 <%if(isDoingRtxop){%>
		 var _w = 700;
			var _h = 570;
			
			var isusedtx = jQuery("#isusedtx").val();
			var rtxserverurl = jQuery("#isusedtx").val();
			var rtxserverouturl = jQuery("#isusedtx").val();
			var rtxserverport = jQuery("#isusedtx").val();
			var rtxOrElinkType = jQuery("#isusedtx").val();
			var rtxVersion = jQuery("#isusedtx").val();
			var rtxOnload = jQuery("#isusedtx").val();
			var rtxDenyHrm = jQuery("#isusedtx").val();
			var rtxAlert = jQuery("#isusedtx").val();
			var domainName = jQuery("#isusedtx").val();
			var rtxConnServer = jQuery("#isusedtx").val();
			var userattr = jQuery("#isusedtx").val();
			var rtxLoginToOA = jQuery("#isusedtx").val();
			var impwd = jQuery("#isusedtx").val();
			var isDownload = jQuery("#isusedtx").val();
			var _data = ""+
					"isusedtx="+isusedtx+"&rtxserverurl="+rtxserverurl+"&rtxserverouturl="+rtxserverouturl+
					"&rtxserverport="+rtxserverport+"&rtxOrElinkType="+rtxOrElinkType+"&rtxVersion="+rtxVersion+
					"&rtxOnload="+rtxOnload+"&rtxDenyHrm="+rtxDenyHrm+"&rtxAlert="+rtxAlert+
					"&domainName="+domainName+"&rtxConnServer="+rtxConnServer+"&userattr="+userattr+
					"&rtxLoginToOA="+rtxLoginToOA+"&impwd="+impwd+"&isDownload="+isDownload;
			
			_fnaOpenDialog("/integration/rtxsettingInitialation.jsp?"+_data,
				"<%=SystemEnv.getHtmlLabelNames("20873,847" ,user.getLanguage()) %>", 
				_w, _h);
	 <%}else{%>
	 top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(81592,user.getLanguage())%>", function (){
		var _w = 700;
		var _h = 570;
		
		var isusedtx = jQuery("#isusedtx").val();
		var rtxserverurl = jQuery("#isusedtx").val();
		var rtxserverouturl = jQuery("#isusedtx").val();
		var rtxserverport = jQuery("#isusedtx").val();
		var rtxOrElinkType = jQuery("#isusedtx").val();
		var rtxVersion = jQuery("#isusedtx").val();
		var rtxOnload = jQuery("#isusedtx").val();
		var rtxDenyHrm = jQuery("#isusedtx").val();
		var rtxAlert = jQuery("#isusedtx").val();
		var domainName = jQuery("#isusedtx").val();
		var rtxConnServer = jQuery("#isusedtx").val();
		var userattr = jQuery("#isusedtx").val();
		var rtxLoginToOA = jQuery("#isusedtx").val();
		var impwd = jQuery("#isusedtx").val();
		var isDownload = jQuery("#isusedtx").val();
		
		var _data = ""+
				"isusedtx="+isusedtx+"&rtxserverurl="+rtxserverurl+"&rtxserverouturl="+rtxserverouturl+
				"&rtxserverport="+rtxserverport+"&rtxOrElinkType="+rtxOrElinkType+"&rtxVersion="+rtxVersion+
				"&rtxOnload="+rtxOnload+"&rtxDenyHrm="+rtxDenyHrm+"&rtxAlert="+rtxAlert+
				"&domainName="+domainName+"&rtxConnServer="+rtxConnServer+"&userattr="+userattr+
				"&rtxLoginToOA="+rtxLoginToOA+"&impwd="+impwd+"&isDownload="+isDownload;
		
		_fnaOpenDialog("/integration/rtxsettingInitialation.jsp?"+_data,
			"<%=SystemEnv.getHtmlLabelNames("20873,847" ,user.getLanguage()) %>", 
			_w, _h);
	 }, function () {}, 320, 90);
	 <%} %>
			
}

function onSubmitAndTest(){
	//QC319856[80][90][建议]IM集成设置-建议 OCS类型，域名 作为必填项 start
	var checkvalue = "";
	var rtxOrElinkType = $("#rtxOrElinkType").val();
	if(rtxOrElinkType == "1"){
		checkvalue = "domainName";
	}
	
	if(check_form(frmMain,checkvalue)){
		document.frmMain.method.value="test";
	    frmMain.submit();
    }
	//QC319856[80][90][建议]IM集成设置-建议 OCS类型，域名 作为必填项 end
}
function getType(obj){
	if(obj == 1 || obj == 2){
		$("#inputface").text("<%=oaaddress%>/login/VerifyEimLogin.jsp?gopage=/wui/main.jsp&logintype=1&loginid=EIM_USERNAME&userpassword=EIM_PASSWORD");
		showEle("domainName");
		hideEle("rtxattr");
		if(obj == 2){
			hideEle("reversallogin");
			hideEle("extendedattr");
		}else{
			showEle("reversallogin");
			showEle("extendedattr");
		}
	}else{
		$("#inputface").text("<%=oaaddress%>/login/RTXClientLoginOA.jsp?gopage=/wui/main.jsp");
		showEle("extendedattr");	
		showEle("reversallogin");
		showEle("rtxattr");
		hideEle("domainName");
	}
	if(obj == 0){
		showEle("download");
		showEle("impwdspan");
		$('#remind').hide(); 
	}else if(obj == 1&&<%=isLdap%>){

		showEle("impwdspan");
		$('#remind').show(); 
	}else{
		hideEle("download");
		hideEle("impwdspan");
		$('#remind').hide(); 
	}
	if(obj == 0 || obj == 1){
		showEle("otherattr");
		getAccountType();
	}else{
		hideEle("domainName");
		hideEle("otherattr");
	}
}
function viewSearchUrl()
{
	prompt("","/integration/integrationTab.jsp?urlType=18");
}
<%if("1".equals(test)){%>
    top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>！");//测试不通过，请检查设置
<%}else if("2".equals(test)){%>
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32297,user.getLanguage())%>！");//测试通过
<%}else if("3".equals(test)){%>
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30109,user.getLanguage())%>！");//同步成功
<%}else if("4".equals(test)){%>
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81556,user.getLanguage())%>！");//同步失败
<%}%>


</script>

</HTML>
