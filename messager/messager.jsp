
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="PluginLicense" class="weaver.license.PluginLicenseForInterface" scope="page" />
<jsp:useBean id="GetPhysicalAddress" class="weaver.system.GetPhysicalAddress" scope="page" />
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />

<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>
<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/messager/resource-cn_wev8.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/messager/resource-en_wev8.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/messager/resource-tw_wev8.js'></script>
<%}%>

 <%
	String loginid=Util.null2String(request.getParameter("loginid"));
 	
 	if("".equals(loginid)){
 		out.println("Must Have Loginid!");
 		return ;
 	}
 	
 	
 	String lastName="";
 	String messagerurl="";
 	String departmentid="";
 	String strSql="select departmentid,lastname,messagerurl from hrmresource where loginid='"+loginid+"'";
 	rs.executeSql(strSql);
 	if(rs.next()) {
 		departmentid=Util.null2String(rs.getString("departmentid")); 	
 		lastName=Util.null2String(rs.getString("lastname")); 		
 		messagerurl=Util.null2String(rs.getString("messagerurl"));
 	} 	
	String target=Util.null2String(request.getParameter("target"));
	if("".equals(messagerurl)) messagerurl="/messager/images/icon-lightred_wev8.jpg";

	
	String styleDir="red";
	rs.executeSql("select msgstyle from hrmresource where loginid='"+loginid+"'");
	if(rs.next()){
		styleDir=Util.null2String(rs.getString("msgstyle"));
	}
 %>
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>Weaver Live Messager --<%=lastName%>--</title>    
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <!--CSS-->
	<LINK href="/messager/ui_wev8.css" type="text/css" rel="STYLESHEET">
	<LINK href="/messager/css/<%=styleDir%>/main_wev8.css" type="text/css" rel="STYLESHEET" id='msgStyle'>
     
    <!-- For Jquery -->
    <script type="text/javascript" src="/messager/jquery_wev8.js"></script>
	<script type="text/javascript" src="/messager/tree/jquery.tree.debug_wev8.js"></script>

	<LINK href="/messager/jquery/autoSearchComplete/autoSearchComplete_wev8.css" type="text/css" rel="STYLESHEET">
	<script type="text/javascript" src="/messager/jquery/autoSearchComplete/jquery.AutoSearchComplete_wev8.js"></script>
	<script type="text/javascript" src="/messager/jquery/jquery.iedrag_wev8.js"></script>
	
	<script type="text/javascript" src="/messager/jquery/jquery.resizable_wev8.js"></script>
	
	 <!-- For XMPP -->
	<script type="text/javascript" src="/messager/jsjac_wev8.js"></script>     
	<!-- 
	<script type="text/javascript" src="/jsjac/src/JSJaCConnection_wev8.js"></script>
	 -->    
    <script type="text/javascript" src="/messager/Debugger_wev8.js"></script>
	<script type="text/javascript" src="/messager/XmppReceive_wev8.js"></script>
	<script type="text/javascript" src="/messager/XmppSend_wev8.js"></script>	
   
   	<!-- For Other -->
   	<%@ include file="/messager/Config.jsp" %>
   	<script type="text/javascript" src="/js/ArrayList_wev8.js"></script>
	<script type="text/javascript" src="/messager/Util_wev8.js"></script>	
	<script type="text/javascript" src="/messager/Login_wev8.js"></script>

	<script type="text/javascript" src="/messager/Multimedia_wev8.js"></script>	
	<script type="text/javascript" src="/messager/Page_wev8.js"></script>
	
	 <!-- For Window -->	
	<script type="text/javascript" src="/messager/window/ControlWindow_wev8.js"></script>
	<script type="text/javascript" src="/messager/window/BaseWindow_wev8.js"></script>
	<script type="text/javascript" src="/messager/window/MessageWindow_wev8.js"></script>
	<script type="text/javascript" src="/messager/window/ChatWindow_wev8.js"></script>
	
	 <!-- For User -->	
	
	<script type="text/javascript" src="/messager/user/ControlUser_wev8.js"></script>
	<script type="text/javascript" src="/messager/user/BaseUser_wev8.js"></script>	
	<script type="text/javascript" src="/messager/user/MessageUser_wev8.js"></script>
	<script type="text/javascript" src="/messager/user/ChatUser_wev8.js"></script>
	
	<script type="text/javascript" src="/jsjac/src/JSJaCConnection_wev8.js"></script>
	<style  type="text/css">
		body,td {
			FONT-SIZE: 12px; MARGIN: 0px; FONT-FAMILY: Verdana; 
		}		
		.content{	
			vertical-align:top;
			/*border:1px solid red;*/			
		}		
		.content .info{	
			/*padding-top:5px;*/
		}
		.content .messagers{
			background:#ffffff;
			margin: 0 1 2 1;
			overflow:auto;
			width:100%;		
		}		
		.chatButtons,.divBlock{
			cursor:hand;border-bottom:1px solid #f0f0f0;height:36;padding:2px;
		}
		
		tab2{
			/*background-image:url("/messager/images/tab2bg_wev8.gif");*/
			
			margin:0 2;
		}
		.tab2unselected{
			/*
			background-image:url("/messager/images/tab2bgtd_wev8.gif");
			background-repeat:no-repeat;
			background-position : bottom  right ;
			*/

		
			cursor:pointer;cursor:hand;
			text-align:center;
			width:80px;
			vertical-align:middle;
		}
		.tab2selected{		
			background-repeat:no-repeat;
			background-position : top  center ;
			
			text-align:center;
			width:76px;
			cursor:pointer;cursor:hand;
			vertical-align:middle;
		}
		.textinput{
			border-top:0px;
			border-left:0px;
			border-right:0px;
			border-bottom:1px solid gray;
		}
		
		#divFaceAll{
			/*border-bottom:1px solid #B2B2B2;
			border-right:1px solid #B2B2B2;*/
			width:180px;
			height:160px;			
			overflow:auto;
		}
		.icon-small{		
			/*border-bottom:0px;
			border-right:0px;*/
			height:32px;
			width:32px;
			background-image:url('/messager/images/faceall_wev8.gif');
			background-repeat:no-repeat;
			padding:5px;
			cursor:hand;
			cursor:pointer;
		}
		#divSearch{
			background:#ffffff;	
			margin:3 1 8 1;
			width:100%;
		}				
	</style>
   </head>
 <body>
<!-- 
<embed id="SoundNewMessage" src="sound/NewMessage.wav" width="0" height="0" loop="false" autostart="false" style="display:none"></embed>
 -->
<!--基本页面窗口-->
<div class="content" style="width:200;"> 
	

</div> 


	<!------------Window Template --start------------>
 	 <div class="window" id="windowTemplate">	
		<table width="100%" height="100%" cellpadding="0" cellspacing="0" >
			<tr>
				<td class="corner-top-left"></td>
				<td class="line-x"></td>
				<td class="corner-top-right"></td>
			</tr>
			<tr>
				<td class="line-y"></td>
				<td valign="top">
					 <div class="content">
						<!--标题区-->
						<div class="title">
							<div class="logo"></div>
							<div class="name">Message Window</div>
							<div class="operate"></div>
						</div>
						<!--主体区-->
						<div class="body"></div>
					</div>
				</td>
				<td class="line-y"></td>
			</tr>
			<tr>
				<td class="corner-bottom-left"></td>
				<td class="line-x"></td>
				<td class="corner-bottom-right"></td>
			</tr>			
		</table>


	 </div>
	 <!------------Window Template --end------------>	 
	</BODY>
</HTML>

<div style="padding:2px;display:none" id="divIframe">
	<IFRAME src="" height="100%" width="100%" BORDER="0" FRAMEBORDER="no" NORESIZE="NORESIZE" scrolling="no"></IFRAME>
</div>

<div style="padding:2px;display:none" id="divUserIcon">
	<IFRAME  src="/messager/GetUserIcon.jsp?loginid=<%=loginid%>" height="100%" width="100%"	BORDER="0" FRAMEBORDER="no" NORESIZE="NORESIZE" scrolling="no"></IFRAME>
</div>

<div style="padding:2px;display:none" id="divUserStyle">	
	<input type="radio" value="blue" name="msgStyleType" onclick='onMsgStyleClick(this)'><%=SystemEnv.getHtmlLabelName(24518, user.getLanguage())%><br>
	<input type="radio" value="yellow" name="msgStyleType" onclick='onMsgStyleClick(this)'><%=SystemEnv.getHtmlLabelName(24519, user.getLanguage())%><br>
	<input type="radio" value="red" name="msgStyleType" onclick='onMsgStyleClick(this)'><%=SystemEnv.getHtmlLabelName(24520, user.getLanguage())%>
</div>

<div style="padding:2px;display:none" id="divUserState">	
	<input type="radio" value="available" name="msgStyleState" onclick='Page.sendState(this.value)'><%=SystemEnv.getHtmlLabelName(19096, user.getLanguage())%><br>
	<input type="radio" value="Away" name="msgStyleState" onclick='Page.sendState(this.value)'><%=SystemEnv.getHtmlLabelName(24521, user.getLanguage())%><br>
</div>

<div style="padding:2px;display:none;text-align:center" id="divCreateChatConfig">
	<div style="margin:5px"><%=SystemEnv.getHtmlLabelName(2151, user.getLanguage())%>:&nbsp;<input class="textinput" id='txtName'/></div>
	<div style="margin:5px"><%=SystemEnv.getHtmlLabelName(24522, user.getLanguage())%>:&nbsp;<input class="textinput"  id='txtPsw'/></div>	
	<div style="margin:10px"><button class='submit' onclick='Page.createChatSubmit(this)'><%=SystemEnv.getHtmlLabelName(16631, user.getLanguage())%></button>&nbsp;<button class='cancel' onclick='Page.createChatCancel(this)'><%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%></button></div>		
</div>


<div style="padding:2px;display:none;text-align:center" id="divMsgTemp">			
</div>
<!--
<div style="padding:2px;display;width:200px;height;120px" id="divUserInfo">
	<div id="toolbar" style="#92B3E8">
	</div>
	<div  id="info" style="#ffffff"></div>
</div>
-->
<div id="divContainer" style="display:none;">
	<span id="divFaceAll"></span>
	<!-- <span style="width:60;height:60px;border:1px solid gray;"></span> -->
</div>



<SCRIPT LANGUAGE="JavaScript">
<!--
	/*全局变量*/
	
	var Debug;
	var flag="1#1";
	
	var onlprio = Config.DEFAULTPRIORITY;
	var onlstat = 'available';
	var onlmsg = '<%=SystemEnv.getHtmlLabelName(24547, user.getLanguage())%>';

	var intervalCall = null;
	
	var jidCurrent="zdp@"+Config.JABBERSERVER+"/weavermessager";
	var msgCurrent="<%=DepartmentComInfo.getDepartmentname(departmentid)%>";
	var jid=jidCurrent;
	
	var psw="<%=psw%>";
	var nickname="<%=lastName%>";	
	var imgWindow;
	var wCreateChatConfig;
	/*For Init*/	
	function fixInitSize(){
		$(".content .messagers").height($(parent.document.body).find("#divMessager").height()-30-50-20-30-15);		
		
	}
	function forDev(){
		if("<%=loginid%>"!="") {			
			jidCurrent="<%=loginid%>@"+Config.JABBERSERVER+"/weavermessager";
			jid=jidCurrent;
		}
		if("<%=target%>"!="") Config.target="<%=target%>";

	}
	function initDebug(){		
		if (!Debug || typeof(Debug) == 'undefined' || !Debug.start) {
			if (typeof(Debugger) != 'undefined'){
				Debug = new Debugger(Config.DEBUG_LVL,'WeaverMessager_' + Util.cutResource(jid));
			}else {
				Debug = new Object();
				Debug.log = function() {};
				Debug.start = function() {};
			}
		}

		if (Config.USE_DEBUGJID && Config.DEBUGJID == Util.cutResource(jid)){
			Debug.start();
		}

		Debug.log("jid: "+jid+"\npass: "+psw,2);
	}

	function doViewMsgHistory() {
		if(document.getElementById("divIframe").all(0)&&document.getElementById("divIframe").all(0).src!="/messager/MsgSearch.jsp") document.getElementById("divIframe").all(0).src = "/messager/MsgSearch.jsp";
		var msgHistoryWindow=ControlWindow.getBaseWindow("msgHistoryWindow","<%=SystemEnv.getHtmlLabelName(264, user.getLanguage())%>","",600,400,350,100,'divIframe');
		msgHistoryWindow.show();			
	}
	
	function doSettingUserIcon(){
		var imgWindow=ControlWindow.getBaseWindow("imgWindow","<%=SystemEnv.getHtmlLabelName(24523, user.getLanguage())%>","",600,400,350,100,'divUserIcon');					
		imgWindow.show();		
	}

	function doSettingUserStyle(){
		var styleWindow=ControlWindow.getBaseWindow("styleWindow","<%=SystemEnv.getHtmlLabelName(24524, user.getLanguage())%> ","",200,100,300,350,'divUserStyle');					
		styleWindow.show();		
	}
	function  doStyleState(){
		var stateWindow=ControlWindow.getBaseWindow("stateWindow","<%=SystemEnv.getHtmlLabelName(24525, user.getLanguage())%> ","",200,100,280,350,'divUserState');					
		stateWindow.show();		
	}

	function  doShowMsgTemp(){
		var msgTempWindow=ControlWindow.getBaseWindow("msgTempWindow","<%=SystemEnv.getHtmlLabelName(24526, user.getLanguage())%> ","",300,200,280,350,'divMsgTemp');					
		msgTempWindow.show();		
	}
	
	

	function onMsgStyleClick(obj){
		$.get("/messager/MessagerDataForEcology.jsp?method=setMsgStyle&loginid=<%=loginid%>&msgStyle="+obj.value,function(data){			
		})
		$("#msgStyle").attr("href","/messager/css/"+obj.value+"/main_wev8.css");
		
		//alert(obj.value)
	}
	
	function initPage(){
		$("#divSearch").autoSearchComplete({
			text:'<%=SystemEnv.getHtmlLabelName(24527, user.getLanguage())%>',
			url:'/messager/MessagerDataForEcology.jsp?method=search'
		});
		$("#divMyLogo").hover(			
			function () {
				$(this).addClass("divMyLogo_selected");
				//$(this).css("border-color","2px solid #679F86");
			},
			function () {
				$(this).removeClass("divMyLogo_selected");
				//$(this).css("border","2px solid #ffffff");
			}
		);	
		$("#divMyLogo").bind("click",function(){			
			doSettingUserIcon();		   
		});		
		$("#imgClose").hover(			
			function () {
				$(this).attr("src","/messager/images/close_over_wev8.jpg");
			},
			function () {
				$(this).attr("src","/messager/images/close_wev8.jpg");
			}
		);	

		$("#imgHide").hover(			
				function () {
					$(this).attr("src","/messager/images/imgHide_over_wev8.gif");
				},
				function () {
					$(this).attr("src","/messager/images/imgHide_wev8.gif");
				}
		);

		$(".messagers").children("div").append("<div class='divLoading'><img src='/messager/tree/themes/default/throbber_wev8.gif'> Loading...</div>");	
		$(".tab2 #tdRecently").trigger("click");
		//$(".tab2 #tdChat").trigger("click");	


		createIConList();
		$(".icon-small").hover(
			function () {
				$(this).css("border","1px solid blue");
			},
			function () {
				$(this).css("border","0px");
			}
		);
		$(".icon-small").click(function(){
			
		})

		

	} 
	function reloadMyLogo(){		
		$.get("/messager/MessagerDataForEcology.jsp?method=getUserIcon&loginid=<%=loginid%>",function(data){
			$("#divMyLogo img").attr("src",$.trim(data));			
		})
	}

	function createIConList(){
		for(var i=0;i<16;i++){
			var rowStr="<div class='row'>";
			j=1;
			for(var j=1;j<6;j++){
				var posX=-1*(j*54);
				if(j>1) posX=-1*(54+88*(j-1));
				var posY=-1*(i*56+14);

				var colStr='<span class="icon-small" style="background-position-x:'+posX+'px;background-position-y:'+posY+'px"></span>';
				rowStr+=colStr;
			}
			rowStr+="</div>"
			//alert(rowStr)
			$("#divFaceAll").append(rowStr);
		}
	}

	/*For Winodw loaded*/	
	$(document).ready( function() {
		<%
		int licenseState=PluginLicense.getLicenseState("messager");
		int userAccess = PluginUserCheck.checkPluginUserRight("messager",user.getUID()+"");
		if(licenseState!=1){ 
		%>
			$("#divConnectting").find(".showMsg").html(		 		
				"<%=PluginLicense.getErrorMsg(licenseState)%><br><%=SystemEnv.getHtmlLabelName(24528, user.getLanguage())%>。<br><%=SystemEnv.getHtmlLabelName(18639, user.getLanguage())%>:<br>"
				+"<span style='word-break:break-all'><%=Util.getEncrypt(GetPhysicalAddress.getPhysicalAddress())%></span>"
		  );			   
		<%	} else if(userAccess!=1) {%> 
		$("#divConnectting").find(".showMsg").html(				
				"<%=SystemEnv.getHtmlLabelName(24529, user.getLanguage())%>!" 
		  );			
		<%	} else {%>		
			fixInitSize();
			forDev();
			initDebug();
			initPage();	
			Page.connect();
		<%}%>		
	});	

	

	
//-->
</SCRIPT>

<%@ include file="/messager/DocAccessory.jsp" %>