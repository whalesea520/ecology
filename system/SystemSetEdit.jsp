
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.rtx.RTXConfig" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rtxConfig" class="weaver.rtx.RTXConfig" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="EmailEncoder" class="weaver.email.EmailEncoder" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
RecordSet.executeProc("SystemSet_Select","");
RecordSet.next();
String pop3server = RecordSet.getString("pop3server");
String emailserver = RecordSet.getString("emailserver");
String debugmode = Util.null2String(RecordSet.getString("debugmode"));
String logleaveday = Util.null2String(RecordSet.getString("logleaveday"));
String defmailuser = Util.null2String(RecordSet.getString("defmailuser"));
String defmailpassword = Util.null2String(RecordSet.getString("defmailpassword"));

String picPath = RecordSet.getString("picturePath");
String filesystem = RecordSet.getString("filesystem");
String filesystembackup = RecordSet.getString("filesystembackup");
String filesystembackuptime = Util.null2String(RecordSet.getString("filesystembackuptime"));
String needzip = Util.null2String(RecordSet.getString("needzip"));
String needzipencrypt = Util.null2String(RecordSet.getString("needzipencrypt"));
String defmailserver = Util.null2String(RecordSet.getString("defmailserver"));
String defneedauth = Util.null2String(RecordSet.getString("defneedauth"));
String defmailfrom = Util.null2String(RecordSet.getString("defmailfrom"));
String smsserver = Util.null2String(RecordSet.getString("smsserver"));
String detachable= Util.null2String(RecordSet.getString("detachable"));
int dftsubcomid=Util.getIntValue(RecordSet.getString("dftsubcomid"),0);
int emailfilesize=Util.getIntValue(RecordSet.getString("emailfilesize"),0);
//add by  haofeng for MAILSSL_SUPPENT
String needSSL = Util.null2String(RecordSet.getString("needSSL"));
String smtpServerPort = Util.null2String(RecordSet.getString("smtpServerPort"));

//add by yinshun.xu for licenseRemind
String licenseRemind = Util.null2String(RecordSet.getString("licenseRemind"));
String remindUsers = Util.null2String(RecordSet.getString("remindUsers"));
String remindDays= Util.null2String(RecordSet.getString("remindDays"));
String defUseNewHomepage= Util.null2String(RecordSet.getString("defUseNewHomepage"));

String refreshTime = Util.null2String(RecordSet.getString("refreshMins"));
String needRefresh = Util.null2String(RecordSet.getString("needRefresh"));

String rtxServer = rtxConfig.getPorp(RTXConfig.RTX_SERVER_IP);
rtxServer = rtxServer == null?"":rtxServer;
String rtxServerOut = rtxConfig.getPorp(RTXConfig.RTX_SERVER_OUT_IP);
rtxServerOut = rtxServerOut == null?"":rtxServerOut;
String serverType = rtxConfig.getPorp(RTXConfig.CUR_SMS_SERVER);
serverType = serverType == null?"":serverType;
String isDownLineNotify = rtxConfig.getPorp(RTXConfig.IS_DOWN_LINE_NOTIFY);
isDownLineNotify = isDownLineNotify == null?"":isDownLineNotify;
String receiveProtocolType = RecordSet.getString("receiveProtocolType");

String mailAutoCloseLeft= Util.null2String(RecordSet.getString("mailAutoCloseLeft"));
String rtxAlert= Util.null2String(RecordSet.getString("rtxAlert"));
String emlsavedays = Util.null2String(RecordSet.getString("emlsavedays"));
String emlpath = Util.null2String(RecordSet.getString("emlpath"));
String scan = Util.null2String(RecordSet.getString("scan"));

String rsstype = Util.null2String(RecordSet.getString("rsstype"));
String isUseOldWfMode = Util.null2String(RecordSet.getString("isUseOldWfMode"));

String messageprefix = Util.null2String(RecordSet.getString("messageprefix"));//短信提醒前缀

String oaaddress = Util.null2String(RecordSet.getString("oaaddress"));
String encryption = Util.null2String(RecordSet.getString("encryption"));
if(encryption.equals("1")) defmailpassword = EmailEncoder.DecoderPassword(defmailpassword);
String isaesencrypt = Util.null2o(RecordSet.getString("isaesencrypt"));

boolean canedit = HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user) ;

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(774,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
boolean enableMultiLang = Util.isEnableMultiLang(); 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top" onclick="onSubmit();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="SystemSetOperation.jsp">

	<wea:layout>
		<wea:group context='<%= SystemEnv.getHtmlLabelName(33174,user.getLanguage())%>'>
			  <wea:item><%=SystemEnv.getHtmlLabelName(21870,user.getLanguage())%></wea:item>
			  <wea:item>
                   <input type="text" class=inputstyle style="width :50%" name=oaaddress  value="<%=oaaddress%>" <% if(!canedit) { %>disabled<%}%>>
                 </wea:item>
			  <% if(canedit) { 
			  	String attr = "{'samePair':'beforeDiv','display':'"+(licenseRemind.equals("1")?"":"none")+"'}";
			  %>
			  	<wea:item><%=SystemEnv.getHtmlLabelName(33386,user.getLanguage())%></wea:item>
			  	<wea:item><input type="checkbox" tzCheckbox="true" name=licenseRemind  value="1" <% if(licenseRemind.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%> onclick="changeDiv(this,'beforeDiv')"></wea:item>
			  	<wea:item attributes='<%=attr %>'><%=SystemEnv.getHtmlLabelName(18013,user.getLanguage())%></wea:item>
			  	<wea:item attributes='<%=attr %>'>
			  		<%
					ArrayList remindUsersArray=Util.TokenizerString(remindUsers,",");
					String remindUsersStr = "";
					for(int m=0; m < remindUsersArray.size(); m++){
						String remindUser=(String) remindUsersArray.get(m);
						if(remindUsersStr.equals("")){
							remindUsersStr = "<a target='_blank' href='/hrm/resource/HrmResource.jsp?id="+remindUser+"'>"+Util.toScreen(ResourceComInfo.getResourcename(remindUser),user.getLanguage())+"</a>";
						}else{
							remindUsersStr = remindUsersStr + ",<a target='_blank' href='/hrm/resource/HrmResource.jsp?id="+remindUser+"'>"+Util.toScreen(ResourceComInfo.getResourcename(remindUser),user.getLanguage())+"</a>";
						}
					}
					%>
			  		<span>
			        <brow:browser viewType="0" name="remindUsers" browserValue='<%= ""+remindUsers %>' 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
			                _callback="onShowResource" linkUrl="/hrm/resource/HrmResource.jsp?id="
			                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
			                completeUrl="/data.jsp"  temptitle='<%= SystemEnv.getHtmlLabelName(18013,user.getLanguage())%>'
			                browserSpanValue='<%=remindUsersStr%>'>
			        </brow:browser>
			    </span>
			  	</wea:item>
			  	<wea:item attributes='<%=attr %>'><%=SystemEnv.getHtmlLabelName(32089,user.getLanguage())%></wea:item>
			  	<wea:item attributes='<%=attr %>'><INPUT class=InputStyle maxLength=2 size=10 name="remindDays" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("remindDays")' value = '<%=remindDays%>'></wea:item>
			  <%} %>
		</wea:group>	 
		<wea:group context='<%= SystemEnv.getHtmlLabelName(33387,user.getLanguage())%>' attributes="{'samePair':'RTXSetting','groupDisplay':'none','itemAreaDisplay':'none'}">	
			<wea:item>
				RTX<%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<% if(canedit) { %>
				<input type="text" name=rtxServer  value="<%=Util.toScreenToEdit(rtxServer,user.getLanguage())%>" maxlength="50" style="width :50%" class="InputStyle">
				<% } else {%>
				<%=Util.toScreen(rtxServer,user.getLanguage())%>
				<%}%>
			</wea:item>
			<wea:item>RTX<%=SystemEnv.getHtmlLabelName(32151,user.getLanguage())%></wea:item>
			<wea:item>
				<% if(canedit) { %>
				<input type="text" name=rtxServerOut  value="<%=Util.toScreenToEdit(rtxServerOut,user.getLanguage())%>" maxlength="50" style="width :50%" class="InputStyle">
				<% } else {%>
				<%=Util.toScreen(rtxServerOut,user.getLanguage())%>
				<%}%>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(33388,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="checkbox" tzCheckbox="true" name=rtxAlert  value="1" <% if("1".equals(rtxAlert)) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
			</wea:item>
		</wea:group>
		<wea:group context='<%= SystemEnv.getHtmlLabelName(33389,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(20231,user.getLanguage())%></wea:item>
			<wea:item>
				<% if(canedit) { %>
				<input accesskey=Z name=picPath  value="<%=Util.toScreenToEdit(picPath,user.getLanguage())%>" maxlength="200" style="width :50%" class="InputStyle">
				<span class="e8tips" title="<%=SystemEnv.getHtmlLabelNames("33390",user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
				<% } else {%>
				<%=Util.toScreen(picPath,user.getLanguage())%>
				<%}%>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15046,user.getLanguage())%></wea:item>
			<wea:item>
				<% if(canedit) { %>
					<input accesskey=Z name=filesystem  value="<%=Util.toScreenToEdit(filesystem,user.getLanguage())%>" maxlength="200" style="width :50%" class="InputStyle">
					<span class="e8tips" title="<%=SystemEnv.getHtmlLabelNames("33390",user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
					<% } else {%>
					<%=Util.toScreen(filesystem,user.getLanguage())%>
					<%}%>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15047,user.getLanguage())%></wea:item>
			<wea:item>
				<% if(canedit) { %>
					<input accesskey=Z name=filesystembackup  value="<%=Util.toScreenToEdit(filesystembackup,user.getLanguage())%>" maxlength="200" style="width :50%" class="InputStyle">
					<span class="e8tips" title="<%=SystemEnv.getHtmlLabelNames("33390",user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
					<% } else {%>
					<%=Util.toScreen(filesystembackup,user.getLanguage())%>
					<%}%>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15048,user.getLanguage())%></wea:item>
			<wea:item>
				<% if(canedit) { %>
				<input accesskey=Z name=filesystembackuptime  value="<%=filesystembackuptime%>" maxlength="50" style="width :50%" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle"></span>
					<% } else {%>
					<%=filesystembackuptime%>
					<%}%>&nbsp;
				<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
				<% if(canedit) { %>
					<span class="e8tips" title="<%=SystemEnv.getHtmlLabelNames("25482",user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
				<%} %>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(33391,user.getLanguage())%></wea:item>
			<wea:item><input type="checkbox" tzCheckbox="true" name=needzip  value="1" <% if(needzip.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(33392,user.getLanguage())%></wea:item>
			<wea:item><input type="checkbox" tzCheckbox="true" name=isaesencrypt  value="1" <% if(isaesencrypt.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>></wea:item>
		</wea:group>
		<%if(enableMultiLang){ %>
			<wea:group context='<%=SystemEnv.getHtmlLabelNames("34032,33508",user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelNames("18599,33508",user.getLanguage())%></wea:item>
				<wea:item><img src="/wui/theme/ecology8/page/images/back-end_wev8.png" onclick="setMulitLangPermission()" style="cursor:pointer;vertical-align:middle" /></wea:item>
			</wea:group>
		<%} %>
	</wea:layout>
			
  </FORM>
</BODY>

<script type="text/javascript">

function onShowResource(e,datas,name,params) {
	if (datas != null) {
		if (wuiUtil.getJsonValueByIndex(datas, 0).length > 500) { // '500为表结构提醒对象字段的长度
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129310, user.getLanguage())%>");
			jQuery("#"+name+"span").html("");
			jQuery("#"+name).val("");
		}
	}
}
</script>

<script language="javascript">

function setMulitLangPermission(){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=80&isdialog=1";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("34032,18599,33508",user.getLanguage())%>";
	dialog.Height = 650;
	dialog.Width = 600;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onSubmit()
{
	

    if($GetEle("filesystem")!=null&&$GetEle("filesystembackup")!=null){
		if(trim($GetEle("filesystem").value)!=''&&trim($GetEle("filesystem").value)==trim($GetEle("filesystembackup").value)){
			top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22603,user.getLanguage())%>');
			return;
		}
	}
	
	frmMain.submit();
}
function changeDiv(obj,target){
	if(jQuery(obj).attr("checked")){
		showEle(target);
	}else{
		hideEle(target);
	}
	
}

jQuery(document).ready(function(){
	jQuery(".e8tips").wTooltip({html:true});
});
</script>
</HTML>
