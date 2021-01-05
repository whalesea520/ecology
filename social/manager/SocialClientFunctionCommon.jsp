
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.social.service.SocialOpenfireUtil"%>
<%@ page import="weaver.social.manager.SocialManageService"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String showTop = Util.null2String(request.getParameter("showTop"));
String testparas = Util.null2String(request.getParameter("testparas"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());

if (!HrmUserVarify.checkUserRight("message:manager", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

%>


<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />

<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>

<%
	rs.execute("select * from Social_Pc_ClientSettings where fromtype = '0'");
	JSONObject settings = new JSONObject();
	while(rs.next()){
		settings.put(rs.getString("keytitle"), rs.getString("keyvalue"));
	}
	// 检查配置
	if(settings.containsKey("ifForbitWebEm")) {
		String value = SocialManageService.getProperties("ifForbitWebEm", application.getRealPath("/"));
		String dbValue = settings.optString("ifForbitWebEm", "0");
		if(value != null && dbValue.equals("0")) {
			settings.put("ifForbitWebEm", value);
		}
	}
    boolean isOpenFire = false ;//SocialOpenfireUtil.getInstanse().isBaseOnOpenfire();  
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveInfo(),_self} " ;    
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="saveInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="菜单" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="SocialManagerOperation.jsp?method=basesetting&fromtype=0" name="weaver">
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context="功能管理">
		<wea:item><%=SystemEnv.getHtmlLabelNames("17875,126805",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitFilesTransfer" id="ifForbitFilesTransfer" value="<%=settings.optString("ifForbitFilesTransfer", "0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitFilesTransfer").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitFilesTransfer" value="<%=settings.optString("ifForbitFilesTransfer","0")%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("17875,126806" ,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifSendPicOrScreenShots" id="ifSendPicOrScreenShots" value="<%=settings.optString("ifSendPicOrScreenShots","0")%>" class="inputstyle" 
				<%if(settings.optString("ifSendPicOrScreenShots").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifSendPicOrScreenShots" value="<%=settings.optString("ifSendPicOrScreenShots","0")%>">
		</wea:item>
		<!-- 暂时屏蔽 --><!-- 
		OA菜单项
		 -->
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,126808",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitCustomApps" id="ifForbitCustomApps" value="<%=settings.optString("ifForbitCustomApps","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitCustomApps").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitCustomApps" value="<%=settings.optString("ifForbitCustomApps","0")%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,126809",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitGroupChat" id="ifForbitGroupChat" value="<%=settings.optString("ifForbitGroupChat","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitGroupChat").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitGroupChat" value="<%=settings.optString("ifForbitGroupChat","0")%>">
		</wea:item>
		<!-- 暂时屏蔽 --><!-- 
		主次账号切换
		-->
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,126811",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitGroupFileShare" id="ifForbitGroupFileShare" value="<%=settings.optString("ifForbitGroupFileShare","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitGroupFileShare").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitGroupFileShare" value="<%=settings.optString("ifForbitGroupFileShare","0")%>">
		</wea:item>
		<!-- 暂时屏蔽 --><!-- 
		单点登录
		文件夹传输
		-->
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,126813",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitCheckInOut" id="ifForbitCheckInOut" value="<%=settings.optString("ifForbitCheckInOut","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitCheckInOut").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitCheckInOut" value="<%=settings.optString("ifForbitCheckInOut","0")%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,16455",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitGroupOrg" id="ifForbitGroupOrg" value="<%=settings.optString("ifForbitGroupOrg","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitGroupOrg").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitGroupOrg" value="<%=settings.optString("ifForbitGroupOrg","0")%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,31369",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitReadstate" id="ifForbitReadstate" value="<%=settings.optString("ifForbitReadstate","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitReadstate").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitReadstate" value="<%=settings.optString("ifForbitReadstate","0")%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,126359",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitBing" id="ifForbitBing" value="<%=settings.optString("ifForbitBing","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitBing").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitBing" value="<%=settings.optString("ifForbitBing","0")%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,127130",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitShake" id="ifForbitShake" value="<%=settings.optString("ifForbitShake","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitShake").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitShake" value="<%=settings.optString("ifForbitShake","0")%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,127152",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitSysBroadcast" id="ifForbitSysBroadcast" value="<%=settings.optString("ifForbitSysBroadcast","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitSysBroadcast").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitSysBroadcast" value="<%=settings.optString("ifForbitSysBroadcast","0")%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,126807",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifDisableMenuItem" id="ifDisableMenuItem" value="<%=settings.optString("ifDisableMenuItem","0")%>" class="inputstyle" 
				<%if(settings.optString("ifDisableMenuItem").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifDisableMenuItem" value="<%=settings.optString("ifDisableMenuItem","0")%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,126812",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitFolderTransfer" id="ifForbitFolderTransfer" value="<%=settings.optString("ifForbitFolderTransfer","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitFolderTransfer").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitFolderTransfer" value="<%=settings.optString("ifForbitFolderTransfer","0")%>">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,126810",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitAccountSwitch" id="ifForbitAccountSwitch" value="<%=settings.optString("ifForbitAccountSwitch","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitAccountSwitch").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitAccountSwitch" value="<%=settings.optString("ifForbitAccountSwitch","0")%>">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,129979",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitEmWaterMark" id="ifForbitEmWaterMark" value="<%=settings.optString("ifForbitEmWaterMark","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitEmWaterMark").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitEmWaterMark" value="<%=settings.optString("ifForbitEmWaterMark","0")%>">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,130719",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitWfShare" id="ifForbitWfShare" value="<%=settings.optString("ifForbitWfShare","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitWfShare").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitWfShare" value="<%=settings.optString("ifForbitWfShare","0")%>">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,130720",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitDocShare" id="ifForbitDocShare" value="<%=settings.optString("ifForbitDocShare","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitDocShare").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitDocShare" value="<%=settings.optString("ifForbitDocShare","0")%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,132165",user.getLanguage())%></wea:item>
		<wea:item>
            <input type="checkbox" tzCheckbox="true" name="ifForbitCustomer" id="ifForbitCustomer" value="<%=settings.optString("ifForbitCustomer","0")%>" class="inputstyle" 
                <%if(settings.optString("ifForbitCustomer").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
            <input type="hidden" name="ifForbitCustomer" value="<%=settings.optString("ifForbitCustomer","0")%>">
        </wea:item>
			<!--密聊 -->
		<%if(isOpenFire){
		%>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,131962",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitPrivateChat" id="ifForbitPrivateChat" value="<%=settings.optString("ifForbitPrivateChat","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitPrivateChat").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitPrivateChat" value="<%=settings.optString("ifForbitPrivateChat","0")%>">
		</wea:item>
		<%
			}
		%>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18096,132137",user.getLanguage())%></wea:item>
		<wea:item>
            <input type="checkbox" tzCheckbox="true" name="ifForbitOnlineStatus" id="ifForbitOnlineStatus" value="<%=settings.optString("ifForbitOnlineStatus","0")%>" class="inputstyle" 
                <%if(settings.optString("ifForbitOnlineStatus").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
            <input type="hidden" name="ifForbitOnlineStatus" value="<%=settings.optString("ifForbitOnlineStatus","0")%>">
        </wea:item>
        <wea:item><%=SystemEnv.getHtmlLabelNames("18096,382342",user.getLanguage())%></wea:item>
		<wea:item>
            <input type="checkbox" tzCheckbox="true" name="ifForbitWebEm" id="ifForbitWebEm" value="<%=settings.optString("ifForbitWebEm","0")%>" class="inputstyle" 
                <%if(settings.optString("ifForbitWebEm").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
            <input type="hidden" name="ifForbitWebEm" value="<%=settings.optString("ifForbitWebEm","0")%>">
        </wea:item>
	</wea:group>
	
</wea:layout>
</form>
</body>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>  
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
	
	function saveInfo(){
		if(jQuery("img[src='/images/BacoError_wev8.gif']").length !=0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
			return;
		}
		//alert(JSON.stringify(jQuery("form").serializeArray()));
		document.weaver.submit();
		/*
		 jQuery.post("SocialManagerOperation.jsp?method=basesetting",{'fromtype': '0','settings': JSON.stringify(jQuery("form").serialize())},function(isSuccess){
		 	if(jQuery.trim(isSuccess) == 1){
		 		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22619,user.getLanguage())%>");
		 	}
		 	refreshCurPage();
		 });
		*/
	}
	
	function changeValue(obj){
		var $chk = jQuery(obj);
		var _name = $chk.attr("name");
		if($chk.val()=='1'){
			$chk.val('0');
			jQuery("input[name='"+_name+"']").val('0');
		}else{
			jQuery(obj).val('1');
			jQuery("input[name='"+_name+"']").val('1');
		}
		
	}
	
	function refreshCurPage(){
		window.location.href=window.location.href;
	}
	
	/*
	*****主次账号切换*****
	<wea:item><%=SystemEnv.getHtmlLabelNames("18096,126810",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitAccountSwitch" id="ifForbitAccountSwitch" value="<%=settings.optString("ifForbitAccountSwitch","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitAccountSwitch").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitAccountSwitch" value="<%=settings.optString("ifForbitAccountSwitch","0")%>">
		</wea:item>
	*****单点登录*****
	<wea:item><%=SystemEnv.getHtmlLabelNames("18096,126789",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="ifForbitSSO" id="ifForbitSSO" value="<%=settings.optString("ifForbitSSO","0")%>" class="inputstyle" 
				<%if(settings.optString("ifForbitSSO").equals("1"))out.println("checked=checked");%> onchange="changeValue(this);"/>
			<input type="hidden" name="ifForbitSSO" value="<%=settings.optString("ifForbitSSO","0")%>">
		</wea:item>
	*****文件夹传输*****
	*/
	console.log("testparas:", JSON.parse('<%=testparas.equals("")?"{}":testparas%>'));
</script>

