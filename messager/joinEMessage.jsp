<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<!--<div id="divMessagerState"/>-->
<%@ page import="weaver.systeminfo.*,org.dom4j.io.SAXReader,org.dom4j.*,java.util.*" %>

<script type="text/javascript" src="/messager/flex/swfobject.js"></script>
<%
	String unread = "false";
	String strSql= "select COUNT(*) from ofOffline where username='"+user.getLoginid()+"'";
	rs.executeSql(strSql);
	if(rs.next()){
		if(rs.getInt(1)>0){
			unread = "true";
		}
	}
%>

<SCRIPT type="text/javascript">	
   	
	
	//flex调用
	function install(){
		jQuery("#tdMessageState").attr("title","下载E-Message");
	}

	//flex调用
	function hasmessage(){
		jQuery("#tdMessageState").attr("title","E-Message有未读消息");
	}
	
	//flex调用
	function showinstall(){
		if (jQuery("#mainFrame")[0]) {
			jQuery("#mainFrame").attr("src","/messager/installm3/emessageproduce.jsp");
		} else {
			jQuery("#leftFrame")[0].contentWindow.document.getElementById("mainFrame").src = "/messager/installm3/emessageproduce.jsp";
		}
	}
	
	function unsurport(){
		jQuery("#tdMessageState").empty();
		jQuery("#tdMessageState").click(function(){
			showinstall();
		}).append("<img src='/messager/images/e-message_wev8.png' id='imgMsgStateBar' align='absmiddle'  width='16px' title='安装E-Message'/>");
		
	}

	jQuery(function() {
		jQuery("#tdMessageState").empty();
		jQuery("#tdMessageState").click(function(){
			showinstall();
		}).append("<img src='/messager/images/e-message_wev8.png' id='imgMsgStateBar' align='absmiddle'  width='16px' title='E-Message'/>");
		jQuery("#tdMessageState").append("<div id='flashContent'></div>");
		if("<%=unread%>"=="true"){
			jQuery("#tdMessageState").attr("title","E-Message有未读消息");
		}//else{
		//	jQuery("#tdMessageState").attr("title","打开E-Message");
		//}
		
		// For version detection, set to min. required Flash Player version, or 0 (or 0.0.0), for no version detection. 
//		var swfVersionStr = "10.2.0";
		// To use express install, set to playerProductInstall.swf, otherwise the empty string. 
//		var xiSwfUrlStr = "/messager/flex/playerProductInstall.swf";
//		var flashvars = {'unread':'<%=unread%>'};
//		var params = {};
//		params.quality = "high";
		//params.bgcolor = "#ffffff";
//		params.wmode = "transparent";
//		params.allowscriptaccess = "sameDomain";
		//params.allowfullscreen = "true";
//		var attributes = {};
//		attributes.id = "Main";
//		attributes.align = "middle";
//		swfobject.embedSWF(
//			"/messager/install/messagestatus.swf", "flashContent", 
//			"16px", "16px", 
//			swfVersionStr, xiSwfUrlStr, 
//			flashvars, params, attributes);
		// JavaScript enabled so display the flashContent div in case it is not replaced with a swf object.
//		swfobject.createCSS("#flashContent", "display:block;text-align:left;");
		
	});
</SCRIPT>

<%
	//if(user.getLoginid)
%>

