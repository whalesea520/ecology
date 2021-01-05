<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="net.sf.json.*"%>
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<%@page import="weaver.mobile.rong.RongService"%>
<%@page import="weaver.mobile.rong.RongConfig"%>
<%
//分享标题
String boxTitle = Util.null2String(request.getParameter("boxTitle"));
JSONObject pcGroupChatSet = SocialIMService.getGroupChatSet(user);
boolean isGroupChatForbit = "1".equals(pcGroupChatSet.optString("isGroupChatForbit", "0"));
boolean hasGroupChatRight = "1".equals(pcGroupChatSet.optString("hasGroupChatRight", "1"));
//用户ID
String userid = user.getUID()+"";
String username = ""+user.getLastname();
RongConfig rongConfig = RongService.getRongConfig();
String udid = rongConfig.getAppUDIDNew();
if(udid == null || udid.equals("")){
    udid = rongConfig.getAppUDID();
}
%>
<html>
<head>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

</head>

<body scroll="no">
	<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
					<ul class="tab_menu">
						<li class="current">
							<a href="" target="tabcontentframe" _datetype="recent">最近</a>
						</li>
						<%if(!isGroupChatForbit){ %>
						<li>
							<a href="" target="tabcontentframe" _datetype="group">群聊</a>
						</li>
						<%} %>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>
			
		<div class="tab_box">
			<iframe src="" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		<div>
		<!-- 底部按钮组 -->
	    <div id="zDialog_div_bottom" class="zDialog_div_bottom">	
	     	<wea:layout>
	     		<wea:group context="" attributes="{groupDisplay:none}">
	     			<wea:item type="toolbar">
	     				 <input type="button" value="确定" id="zd_btn_confirm" class="zd_btn_cancle" onclick="doSendMsg();">
	                     <input type="button" value="创建新聊天" id="zd_btn_add" class="zd_btn_cancle" onclick="launchNewChat();">
	                     <input type="button" value="取消" id="zd_btn_cancle" class="zd_btn_cancle" onclick="clearOrClose(this);">
	     			</wea:item>
	     		</wea:group>
	     	</wea:layout>
	     </div>
	</div>
</body>

<script type="text/javascript">
	
	$(document).ready(function(){
	    $('.e8_box').Tabs({
			getLine : 1,
			iframe : "tabcontentframe",
			mouldID:"<%= MouldIDConst.getID("social")%>",
			staticOnLoad:true,
			objName:"<%=boxTitle%>"
		});
		attachUrl();
		$('#objName').css('max-width', '316px');
	});
  
  function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var datetype=$(this).attr("_datetype");
		
		if("recent" == datetype){
			$(this).attr("href","/social/im/SocialHrmBrowserList.jsp?tabid=recent&"+new Date().getTime());
		}
		
		if("group" == datetype){
			$(this).attr("href","/social/im/SocialHrmBrowserList.jsp?tabid=group&"+new Date().getTime());
		}
		
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
}
        var USERID = "<%=userid%>";
        var USERNAME = "<%=username%>";
		var udid = "<%=udid%>";
		
		function doSendMsg(){
			var chatItemSel = $("iframe[name=tabcontentframe]").contents().find(".chatItemWrap .selected");
			if(chatItemSel.length == 0){
				window.top.Dialog.alert("请选择联系人或讨论组");
				return;
			}else{
					for(var i = 0; i < chatItemSel.length; ++i){
						var _thisdomObj = $(chatItemSel[i]);
						var targetId = _thisdomObj.attr("_targetid");
						var targetType = _thisdomObj.attr("_targettype");
						
						var targetName = _thisdomObj.attr("_targetname");
						sendMSG(targetId,targetType,targetName);
					}
					top.getDialog(window).close();
			}
		}
		
		//清除选择
		function clearSelect(){
			if($("#zd_btn_cancle").length > 0 && $("#zd_btn_cancle").val() == "清除"){
				$("#zd_btn_cancle").click();
			}
		}
		//清除or 关闭
		function clearOrClose(obj){
			var txt = $(obj).val();
			if(txt == '清除'){
				var chatItemSel = $("iframe[name=tabcontentframe]").contents().find(".chatItemWrap .selected");
				chatItemSel.removeClass("selected");
				$(obj).val("取消");
				$("#zd_btn_confirm").val("确定");
			}else if(txt == '取消'){
				top.getDialog(window).close();
			}
		}
    	//创建新聊天
    	function launchNewChat(){
    		//判断权限[如果没有发起群聊权限，则打开单人选择框]
	        var browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?";
	        <%if(!isGroupChatForbit && hasGroupChatRight){ %>
	        	browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?";
	        <%}%>
	        var _thisCallback = function(event,data,name,oldid){
	        	var resourceids, resourcenames;
				
	        	if(data.id){
	        		resourceids = data.id.split(",");
	        		resourcenames = data.name.split(",");
	        		//移除创建人id
	        		for(var i = 0; i < resourceids.length; ++i){
	        			if(resourceids[i] == USERID){
							resourceids.splice(i, 1);
							resourcenames.splice(i, 1);
	        			}
	        		}
					
	        		//如果只有一个人，则跳转到单聊,否则创建一个新的讨论组
	        		var targetId = "";
	        		var msgType = 6;
	        		if(resourceids.length == 1){
	        			targetId = resourceids[0];
						sendMSG(targetId,0,data.name);
	        		}else{
	        			var disName = "";
	        			var memList = new Array();
						var disNameList = new Array();
						
	        			for(var i in resourcenames){
	        				i = parseInt(i);
	        				if(isNaN(i)){
	        					continue;
	        				}
							if(resourceids[i])
							{
								memList.push(resourceids[i] + "|" + udid);
								if(disNameList.length < 3)
								{
									disNameList.push(resourcenames[i]);
								}
							}
	        			}
	        			disName = disNameList.join();
	        			if(resourceids.length == 0){
			        		window.top.Dialog.alert("讨论组成员数目必须1人以上(除创建者外)");
			        		return;
			        	}
						var _msbObjArray = packageMSGObj(targetId,0);
						parent.shareFile(2,_msbObjArray,-1,disName,resourceids.join(","),memList);
	        		}
	        	}
	        	top.getDialog(window).close();
	        }
	  		__browserNamespace__.showModalDialogForBrowser(event || window.event, browserUrl +
					'selectedids=','#','resourceid',false,1,'',
			{
				name:'resourceBrowser',
				hasInput:false,
				zDialog:true,
				needHidden:true,
				dialogTitle:'人员',
				arguments:'',
				_callback: _thisCallback
			});
    	}
		
 function getguid()
 {
	 return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
	        var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
	        var uuid=v.toString(16).replace(/-/,"");
	        return uuid;
	    });
 }
 
 
 function sendMSG(targetId,targetType,targetName)
 {
	var _msbObjArray = packageMSGObj(targetId,0,targetName);
	if(_msbObjArray)
	{
		for(var i = 0 ; i < _msbObjArray.length ; i ++)
		{
			var _msgObj = _msbObjArray[i];
			if(top.addNetWorkFileShare && typeof(top.addNetWorkFileShare) == "function"){
				top.addNetWorkFileShare(_msgObj.shareFileId,targetId,targetType,_msgObj.shareFileType,_msgObj.extra);
			}else{
				addNetWorkFileShare(_msgObj.shareFileId,targetId,targetType,_msgObj.shareFileType,_msgObj.extra);
			}
			parent.shareFile(targetType,_msgObj,targetId);
		}
	}
 }
 
 
 
 function packageMSGObj(_targetId,_create,targetName){
	var msgObjArray = new Array();
	var _dataMap = parent._shareDataMap;
	var _folderArray = _dataMap.folderArray;
	var _fileArray = _dataMap.fileArray;
	if(_folderArray)
	{
		for(var i = 0 ; i < _folderArray.length ; i ++)
		{
			var _selectItem = _folderArray[i];
			var guid = window.getguid();
			var name = _selectItem.name;
			var id = _selectItem.id;
			var msgObj = {};
			msgObj['content'] = name;
			msgObj['objectName'] = 'FW:CustomShareMsg';
			msgObj['timestamp'] = guid;
			msgObj['msgType'] = 6;
			msgObj['shareFileId'] = id;
			msgObj['shareFileType'] = 'folder';
			msgObj['targetName'] = targetName;
			if(_create == '0' )
			{
				msgObj['extra'] = "{\"msg_id\":\""+guid+"\",\"sharetitle\":\""+name+"\",\"shareid\":\""+id+"\",\"receiverids\":\""+_targetId+"\",\"sharetype\":\"folder\"}";
			}
			else{
				msgObj['extra'] = "{\"msg_id\":\""+guid+"\",\"sharetitle\":\""+name+"\",\"shareid\":\""+id+"\",\"sharetype\":\"folder\"}";
			}
			msgObjArray.push(msgObj);
		}
	}
	if(_fileArray)
	{
		for(var i = 0 ; i < _fileArray.length ; i ++)
		{
			var _selectItem = _fileArray[i];
			var guid = window.getguid();
			var name = _selectItem.name;
			var id = _selectItem.id;
			var msgObj = {};
			msgObj['content'] = name;
			msgObj['objectName'] = 'FW:CustomShareMsg';
			msgObj['timestamp'] = guid;
			msgObj['msgType'] = 6;
			msgObj['shareFileId'] = id;
			msgObj['shareFileType'] = 'pdoc';
			msgObj['targetName'] = targetName;
			if(_create == '0' )
			{
				msgObj['extra'] = "{\"msg_id\":\""+guid+"\",\"sharetitle\":\""+name+"\",\"shareid\":\""+id+"\",\"receiverids\":\""+_targetId+"\",\"sharetype\":\"pdoc\"}";
			}
			else{
				msgObj['extra'] = "{\"msg_id\":\""+guid+"\",\"sharetitle\":\""+name+"\",\"shareid\":\""+id+"\",\"sharetype\":\"pdoc\"}";
			}
			msgObjArray.push(msgObj);
		}
	}
	return msgObjArray;
 }
 
function addNetWorkFileShare(_fileid,_targetId,_sharetype,_filetype,_extra){
	var extra = eval("(" + _extra + ")");
	jQuery.ajax({
		url : "/docs/networkdisk/addNetWorkFileShare.jsp",
		data : {
			'tosharerid':_targetId,
			'fileid':_fileid,
			'sharetype': parseInt(_sharetype)+1,
			'filetype': _filetype,
			'msgid' : extra.msg_id
		},
		type : "post",
		dataType : "json",
		success : function(data){
			//console.log(data);
		}
	});
}
</script>
</html>