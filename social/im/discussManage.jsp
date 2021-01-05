
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
String operation = Util.null2String(request.getParameter("operation"),"");
String orgname = Util.null2String(request.getParameter("orgname"),"");
String content = URLDecoder.decode(Util.null2String(request.getParameter("content"),""), "UTF-8");
String isopenfire = Util.null2String(request.getParameter("isopenfire"),"");
String newWin = Util.null2String(request.getParameter("newWin"),"");


%>

<div class="zDialog_div_content" id="zDialog_div_content" style="padding-top:74px" align="center">
<center>
	<table style="width:100%;margin-top:30px;" align="center">
		<tr>
		    <% if(user.getLanguage()==8){%>
			<td style = "padding-left:89px;width:115px;padding-right:10px"><%=SystemEnv.getHtmlLabelName(129927, user.getLanguage())%>：</td><!-- 内容 -->
			<%}else{%>
			<td style = "padding-left:89px;width:60px;padding-right:10px"><%=SystemEnv.getHtmlLabelName(129927, user.getLanguage())%>：</td><!-- 内容 -->
			<%}%>
			<td>
				<input  id="content" name="content" style="" onblur="checkinput('content','contentspan');" value="<%if(!orgname.equals("")){%><%=orgname%><%}%>"></input>
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
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doClose()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

<script language="javascript">
jQuery(document).ready(function(){
	

});

function checkDsNameValid(dsName){
	var isvalid = false;
	if(dsName.match(/^(\w|[\u2E80-\u9FFF])+$/gi)){
		isvalid = true;
	}
	return isvalid;
}

function doClose(){
    var newWin = "<%=newWin%>";   
	if(newWin==='1'){
		var win = window.Electron.currentWindow;	
        win.close();
    }else{
        parent.getDialog(window).close();
    }
    
}

function doSave(){
	var content = $("#content").val();
	//console.log(content);
	var operation= "<%=operation%>";	
	var orgName = "<%=orgname%>";
	var isopenfire = "<%=isopenfire%>";
	var newWin = "<%=newWin%>";
	var doit;
	//console.log(orgName);
	
	if(operation=="add"){
		doit = "addNewDiscussList";
	}else if (operation == "rename"){
		doit = "renameDiscussList";
	}
	
	if(content==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130064, user.getLanguage())%>");//请填写分组名称
		return;
	}
	
	if(!checkDsNameValid(content)){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130065, user.getLanguage())%>");
		return;
	}
	
	if(operation == "rename"){
		if(orgName==content){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130068, user.getLanguage())%>");
			return;
		}
	}
	  var reg = /[\u4e00-\u9fa5]/g;
	  var chinese = content.match(reg);
	  
	  
	  try{
	  	var chlength = chinese.length;
	  }catch(err){
	  	var chlength=0;
	  }
	  var english = content.length - chlength; 
	  
    if((english+chlength*2)  > 20){
    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130069, user.getLanguage())%>");
			return;
    }
	
	if(orgName!=''){
		orgName=encodeURI(orgName);
	}
	
	
	$.post("/social/im/SocialIMOperation.jsp?operation="+doit,
		{
			"discussListName":encodeURI(content),
			"orgName":orgName,
			"isopenfire":isopenfire
		},
		function(data){
		try{
		    var parentWin = parent.getParentWindow(window);
		}catch(err){
		    var parentWin = null;
            
		}
		try{
		  var _thisDialog = parent.getDialog(window);
		  if(newWin==='1'){
		      var _thisDialog = window.Electron.currentWindow;
		  }
		}catch(err){
		  var _thisDialog = window.Electron.currentWindow;
		}
		try{
			//改变消息标识
			var message = $.trim(data);
			if(message=="1")
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130070, user.getLanguage())%>");
			if(message=="2")
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130071, user.getLanguage())%>");
			if(message=="7")
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130072, user.getLanguage())%>");
			if(message=="3"){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130073, user.getLanguage())%>",function(){
					if(newWin==='1'){
					   window.Electron.ipcRenderer.send('plugin-addGroupSub-cb');
					   _thisDialog.close();
					}else{
					   _thisDialog.close();
                        //刷新树
                        parentWin.loadIMDataList("discuss");
					}
				});
			}
			if(message=="4")
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130074, user.getLanguage())%>");
			if(message=="5")
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130075, user.getLanguage())%>");
			if(message=="6"){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130076, user.getLanguage())%>",function(){
					if(newWin==='1'){
                       window.Electron.ipcRenderer.send('plugin-addGroupSub-cb');
                       _thisDialog.close();
                    }else{
                       _thisDialog.close();
                        //刷新树
                        parentWin.loadIMDataList("discuss");
                    }
				});
			}
			
		}catch(e){
			client.error(e);
		}finally{
			//
		}
	});
	
}

</script>
</body>
