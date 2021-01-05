<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="net.sf.json.*"%>
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<%
//分享标题
String boxTitle = Util.null2String(request.getParameter("boxTitle"));
String coth = Util.null2String(request.getParameter("coth"));
JSONObject pcGroupChatSet = SocialIMService.getGroupChatSet(user);
boolean isGroupChatForbit = "1".equals(pcGroupChatSet.optString("isGroupChatForbit", "0"));
boolean hasGroupChatRight = "1".equals(pcGroupChatSet.optString("hasGroupChatRight", "1"));
//用户ID
String userid = user.getUID()+"";
String username = ""+user.getLastname();

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
		var openerWin = top.getDialog(window).openerWin;
        var USERID = "<%=userid%>";
        var USERNAME = "<%=username%>";
        var coth = "<%=coth%>";
		//发送消息
		function doSendMsg(){
			var chatItemSel = $("iframe[name=tabcontentframe]").contents().find(".chatItemWrap .selected");
			if(chatItemSel.length == 0){
				window.top.Dialog.alert("请选择联系人或群");
				return;
			}else{
				if(openerWin){
					//多对象群发， 引入延时重发机制
					var targetObjQueue = new Array();
					var _thisdomObj;
					var targetIdTemp = {};
					for(var i = 0; i < chatItemSel.length; ++i){
						_thisdomObj = $(chatItemSel[i]);
						var targetId = _thisdomObj.attr("_targetid");
						var targetType = _thisdomObj.attr("_targettype");
						var targetName = _thisdomObj.attr("_targetname");
						if(targetType==0 && openerWin.ClientSet.multiAccountMsg==1){
							//主次账号切换，用主账号
							var parentAccountid = openerWin.AccountUtil.accountBelongTO[targetId];
							if(typeof parentAccountid !="undefined"){
								targetId = parentAccountid;
								targetName =  openerWin.getUserInfo(parentAccountid).userName;
							}	
						}
						if(targetIdTemp[targetId]) continue;
                        targetIdTemp[targetId] = targetId;
						targetObjQueue.push({"targetId":targetId, "targetType":targetType, "targetName": targetName, "counter": 0});
					}
					_sendMutiMsg(targetObjQueue);
				}
			}
		}
		//群发
		function _sendMutiMsg(targetObjQueue){
			if(targetObjQueue.length <= 0){
				top.getDialog(window).close();
			}else{
				var msgObj = openerWin.IM_Ext.cache.msgObj;
				var msgType = msgObj.msgType;
				var _targetObj = targetObjQueue.shift();
				var targetId = _targetObj.targetId;
				var targetType = _targetObj.targetType;
				var targetName = _targetObj.targetName;
				var counter = _targetObj.counter;
				if(!msgObj['coth']) {
					msgObj['coth'] = coth;
				}
				//超过三次，就不发了
				//console.log("counter:",counter);
				if(counter > 3){
					_sendMutiMsg(targetObjQueue);
					return;
				}
				setTimeout(function(){
					openerWin.IM_Ext.sendMsgToUserOrDiscuss(targetId, targetName, targetType, 
						msgObj, msgType, function(result){
							var issuccess = result.issuccess;
							try {
								var shareObj = eval("("+msgObj.extra+")");
								if(!!issuccess){
									if((shareObj.sharetype == "pdoc" || shareObj.sharetype == "folder")&&(typeof(eval(openerWin.shareDiskFileOrFolder)) == "function")){
									//判断是否是群组
									if(shareObj.receiverids.indexOf(",") != -1){
									  if(shareObj.sharetype == "pdoc"){
									  	openerWin.shareDiskFileOrFolder("",targetId,"",shareObj.shareid,shareObj.msg_id);
									  }else{
									 	openerWin.shareDiskFileOrFolder("",targetId,shareObj.shareid,"",shareObj.msg_id);
									  }
									}else{
									if(shareObj.sharetype == "folder"){
									  	openerWin.shareDiskFileOrFolder(targetId,"",shareObj.shareid,"",shareObj.msg_id);
									  }else{
									 	openerWin.shareDiskFileOrFolder(targetId,"","",shareObj.shareid,shareObj.msg_id);
									  }
									}
									
								 }else if(shareObj.sharetype == "crm"&&(typeof(eval(openerWin.shareCrm)) == "function")){
									 openerWin.shareCrm(shareObj.shareid,shareObj.receiverids);
								 }
								}
								
							} catch (e) {
							
							}
							if(!!!issuccess){
								var err = result.err;
								//超时和未知错误的情况下进行重发
								if(err && (err.name == 'TIMEOUT' || err.name == 'UNKNOWN_ERROR')){
									_targetObj.counter += 1;
									targetObjQueue.push(_targetObj);
								}
							}
							_sendMutiMsg(targetObjQueue);
						});
				},counter * 100);
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
	        	console.error("data:", data);
	        	var resourceids;
	        	var isContain = false;//是否包含自己
	        	if(data.id){
	        		resourceids = data.id.split(",");
	        		//移除创建人id,如果创建群的人本身就是一个次账号，次账号不切换成主账号
	        		for(var i = resourceids.length-1; i >=0 ; --i){
						var _targetidTemp = resourceids[i];
	        			if(_targetidTemp == USERID){
	        			    isContain = true;
							resourceids.splice(i, 1);
						}else if(openerWin.ClientSet.multiAccountMsg==1){
							//主次账号切换，用主账号
							var parentAccountid = openerWin.AccountUtil.accountBelongTO[_targetidTemp];
								if(typeof parentAccountid !="undefined"){
									resourceids.splice(i, 1,parentAccountid);
									if(parentAccountid == USERID){
									    isContain = true;
									}
								}	
						}
					}
					resourceids = openerWin.IMUtil.unique(resourceids);
					//群成员中有可能有该账号的次账号，
					resourceids = openerWin.IMUtil.removeArray(resourceids,USERID);
	        		//如果只有一个人，则跳转到单聊,否则创建一个新的讨论组
	        		var targetId = "";
	        		var msgObj = openerWin.IM_Ext.cache.msgObj;
	        		var msgType = msgObj.msgType;
	        		if(!msgObj['coth']) {
						msgObj['coth'] = coth;
					}
					if(resourceids.length ==0 && isContain){
	        		    resourceids.push(USERID);
					}
	        		if(resourceids.length == 1){
	        			targetId = resourceids[0];
	        			openerWin.IM_Ext.sendMsgToUserOrDiscuss(targetId, openerWin.userInfos[targetId].userName, "0", msgObj, msgType,function(result){
							try {
								var issuccess = result.issuccess;
								var shareObj = eval("("+msgObj.extra+")");
									if(!!issuccess){
									if((shareObj.sharetype == "pdoc" || shareObj.sharetype == "folder")&&(typeof(eval(openerWin.shareDiskFileOrFolder)) == "function")){
									//判断是否是群组
									if(shareObj.receiverids.indexOf(",") != -1){
									  if(shareObj.sharetype == "pdoc"){
									  	openerWin.shareDiskFileOrFolder("",targetId,"",shareObj.shareid,shareObj.msg_id);
									  }else{
									 	openerWin.shareDiskFileOrFolder("",targetId,shareObj.shareid,"",shareObj.msg_id);
									  }
									}else{
									if(shareObj.sharetype == "folder"){
									  	openerWin.shareDiskFileOrFolder(targetId,"",shareObj.shareid,"",shareObj.msg_id);
									  }else{
									 	openerWin.shareDiskFileOrFolder(targetId,"","",shareObj.shareid,shareObj.msg_id);
									  }
									}
									
								 }else if(shareObj.sharetype == "crm"&&(typeof(eval(openerWin.shareCrm)) == "function")){
									 openerWin.shareCrm(shareObj.shareid,shareObj.receiverids);
								 }
								}
							} catch (e) {
							
							}
							
						});
	        		}else{
	        			var disName = new Array;
	        			var memList = new Array();
	        			for(var i =0; i< resourceids.length; i++){	        				
	        				if(disName.length < 3){
								var tempUserName  = openerWin.getUserInfo(resourceids[i]).userName;
								if(tempUserName)
									disName.push(tempUserName);
	        				}
	        				memList.push(openerWin.getIMUserId(resourceids[i]));
	        			}
	        			disName = disName.join(",");
	        			if(resourceids.length == 0){
			        		window.top.Dialog.alert("群成员数目必须1人以上(除创建者外)");
			        		return;
			        	}
	        			openerWin.DiscussUtil._addDiscuss(disName,resourceids.join(","),memList,function(discussid, discusstitle){
	        				//发送消息
	        				openerWin.IM_Ext.sendMsgToUserOrDiscuss(discussid,discusstitle, "1", msgObj, msgType,function(result){
								try {
									var issuccess = result.issuccess;
									var shareObj = eval("("+msgObj.extra+")");
								if(!!issuccess){
									if((shareObj.sharetype == "pdoc" || shareObj.sharetype == "folder")&&(typeof(eval(openerWin.shareDiskFileOrFolder)) == "function")){
									//判断是否是群组
									if(shareObj.receiverids.indexOf(",") != -1){
									  if(shareObj.sharetype == "pdoc"){
									  	openerWin.shareDiskFileOrFolder("",discussid,"",shareObj.shareid,shareObj.msg_id);
									  }else{
									 	openerWin.shareDiskFileOrFolder("",discussid,shareObj.shareid,"",shareObj.msg_id);
									  }
									}else{
									if(shareObj.sharetype == "folder"){
									  	openerWin.shareDiskFileOrFolder(targetId,"",shareObj.shareid,"",shareObj.msg_id);
									  }else{
									 	openerWin.shareDiskFileOrFolder(targetId,"","",shareObj.shareid,shareObj.msg_id);
									  }
									}
									
								 }else if(shareObj.sharetype == "crm"&&(typeof(eval(openerWin.shareCrm)) == "function")){
									 openerWin.shareCrm(shareObj.shareid,shareObj.receiverids);
								 }
								}
							} catch (e) {
							
							}
							});
	        			});
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
</script>
</html>

