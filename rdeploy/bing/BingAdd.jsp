
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.URLDecoder"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language='javascript' type='text/javascript' src='/social/js/jquery.base64/jquery.base64_wev8.js'></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
</head>

<body>

<%
String issystem = Util.null2String(request.getParameter("issystem"),"");
String groupid = Util.null2String(request.getParameter("groupid"),"");
String userid=user.getUID()+"";
String content = URLDecoder.decode(Util.null2String(request.getParameter("content"),""), "UTF-8");
String from = Util.null2String(request.getParameter("from"),"");
String msgtype = Util.null2String(request.getParameter("msgtype"),"");
String msgid = Util.null2String(request.getParameter("msgid"),"");
String receiver = Util.null2String(request.getParameter("receiverids"),"");
//String receiver [] = temp.split(",");
//String receiver = "";
//for(int i = 0 ;i<tempreceiver.length;i++ ){
//	receiver = tempreceiver[i];
//	System.out.println(tempreceiver[i]);
//}
%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="saveSpan">
				<input class="e8_btn_top middle" onclick="doSubmit()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(126972, user.getLanguage())%>" id="saveSpan"><!-- 解散群 -->
				<input class="e8_btn_top middle" onclick="destoryGroup('')" type="button" value="<%=SystemEnv.getHtmlLabelName(126972, user.getLanguage())%>"/><!-- 解散群 -->
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(83721, user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</wea:item>
	</wea:group>
</wea:layout>


<div class="zDialog_div_content" id="zDialog_div_content" style="height:335px;">

<center>
	<table style="width:90%;margin-top:30px;" align="center">
		<colgroup>
			<col width="20%"/>
			<col width="80%"/>
		</colgroup>
		<tr style="height:45px;">
			<td><%=SystemEnv.getHtmlLabelName(15525, user.getLanguage())%></td><!-- 接收人 -->
			<td>
				<brow:browser viewType='0' name='receiver' browserValue='<%=receiver%>'  
						browserSpanValue='<%=ResourceComInfo.getMulResourcename1(receiver)%>'
						browserUrl='/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp'
						hasInput='true' isSingle='false' hasBrowser = 'true' isMustInput='2'
						completeUrl='/data.jsp' width='80%' />
			</td>
		</tr>
		
		<tr style="height:45px;">
			<td><%=SystemEnv.getHtmlLabelName(18713, user.getLanguage())%></td><!-- 提醒方式 -->
			<td><!-- 应用内    短信 -->
				<input name="remindType" type="radio" checked="checked" value="0"><%=SystemEnv.getHtmlLabelName(127006, user.getLanguage())%> <input name="remindType" type="radio" value="1"><%=SystemEnv.getHtmlLabelName(22825, user.getLanguage())%> 
			</td>
		</tr>
		
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%></td><!-- 内容 -->
			<td>
				<textarea  id="content" name="content" style="width:90%;height:80px;" onblur="checkinput('content','contentspan');"><%=content %></textarea>
				<span id="contentspan"><img align="absmiddle" src="/images/BacoError_wev8.gif"></span>
			</td>
		</tr>
	
	</table>

</center>

</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doSave()"><!-- 确定 -->
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

<script language="javascript">
jQuery(document).ready(function(){
	var dialog = parent.getDialog(window);
	var data = dialog.initData;
	var text = decodeURI($.base64.decode(data?data.content:""));
	if(text!=""&&text!=undefined){
	   $("#content").text(text);
	   $("#content").attr("disabled","disabled");
	   $("#contentspan").remove();
	}
})

function doSave(){
	var openerWin = parent.getParentWindow(window);	
	var USERID = "<%=userid%>";
	var receiver=$("#receiver").val();
	var receiverArray =  receiver.split(",");
	var content=$("#content").val();
	var remindType=$("input[name='remindType']:checked").val();
	var msgid = "<%=msgid%>";
	var scopeid = "<%=groupid%>";
	
	if(receiver==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126981, user.getLanguage())%>");//请填写接收人
		return;
	}
	if(openerWin.ClientSet.multiAccountMsg==1){
		for(var i =receiverArray.length-1;i>=0;i--){
			var parentAccountid = openerWin.AccountUtil.accountBelongTO[receiverArray[i]];
			if(typeof parentAccountid !="undefined"){
				
				if(parentAccountid == USERID){
					receiverArray.splice(i,1);
				}else{
					receiverArray.splice(i,1,parentAccountid);
				}
			}
		}
		receiverArray= openerWin.IMUtil.unique(receiverArray);
		receiver = receiverArray.join(",");
	}	
	if(content==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126982, user.getLanguage())%>");//请填写内容
		return;
	}
	
	if(content.length>1000){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33298, user.getLanguage())%>");//内容长度不得超过1000限制
		return;
	}
	
	$.post("BingOperation.jsp?operation=doSave",
		{
			"receiver":receiver,
			"content":content,
			"remindType":remindType, 
			"msgid":msgid, 
			"noticetype": remindType,
			"scopeid": scopeid
		},
		function(dingid){
		//window.parent.freshDingList();
		var parentWin = parent.getParentWindow(window);
		var _thisDialog = parent.getDialog(window);
		try{
			//改变消息标识
			dingid = $.trim(dingid);
			if('<%=from%>' == 'chat' && dingid != ""){
				var msgtype = '<%=msgtype%>';
				if(msgtype == 1)
					_thisDialog.finalData = {"dingid": dingid};
			}
			parentWin.freshDingList(content);
		}catch(e){
			client.error("刷新DIng列表错误");
			client.error(e);
		}finally{
			_thisDialog.close();
		}
	});
	
}

</script>
</body>
