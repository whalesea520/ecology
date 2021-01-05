<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.social.po.SocialClientProp" %>
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<%
//分享标题
String sharejson = Util.null2String(request.getParameter("sharejson"));
String pcClientSettings = SocialClientProp.serialize();
JSONObject pcGroupChatSet = SocialIMService.getGroupChatSet(user);
boolean isGroupChatForbit = "1".equals(pcGroupChatSet.optString("isGroupChatForbit", "0"));
boolean hasGroupChatRight = "1".equals(pcGroupChatSet.optString("hasGroupChatRight", "1"));
//是否开启云盘
String isOpenDisk =weaver.file.Prop.getPropValue("network2Emessage", "openDisk");
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
    var sharejson = JSON.parse('<%=sharejson%>');
	var extraObj = JSON.stringify(<%=sharejson%>);
	// var extraObj = '[{"shareid":"124","sharetitle":"xjx","sharetype":"","objectname":"fw:personcardmsg"},{"shareid":"13731","sharetitle":"123","sharetype":"doc","objectname":"FW:CustomShareMsg"}]';
	$(document).ready(function(){
	    $('.e8_box').Tabs({
			getLine : 1,
			iframe : "tabcontentframe",
			mouldID:"<%= MouldIDConst.getID("social")%>",
			staticOnLoad:true,
			objName:"[分享]"
		});
		attachUrl();
		$('#objName').css('max-width', '316px');
        if(socialForShare.checkIfForbit(sharejson[0].sharetype)){
            window.top.Dialog.alert("e-message 已经禁止此类分享!");
            top.getDialog(window).close();
        }
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
		//发送消息
		function doSendMsg(){
			var chatItemSel = $("iframe[name=tabcontentframe]").contents().find(".chatItemWrap .selected");
			if(chatItemSel.length == 0){
				window.top.Dialog.alert("请选择联系人或群");
				return;
			}else{
				//发送单挑或者多人聊天
				var resourceids = new Array();
				var openType  = 1;
				for(var i = 0; i < chatItemSel.length; ++i){
						_thisdomObj = $(chatItemSel[i]);
						resourceids.push(_thisdomObj.attr("_targetid"));
						if(_thisdomObj.attr("_targettype") == 0){
							openType  = 0;
						};						
					}
				socialForShare.sendMsgToPCorWeb(resourceids.toString(),openType,"",extraObj,function(){
					top.getDialog(window).close();
				})
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
	        	var resourceids, resourcenames,openType;
				var groupName = "";
	        	if(data.id){
	        		resourceids = data.id.split(",");
	        		resourcenames = data.name.split(",");
	        		//移除创建人id
	        		for(var i = 0; i < resourceids.length; ++i){
	        			if(resourceids[i] == USERID){
	        				resourceids.splice(i, 1);
	        			}
	        		}
	        		//如果只有一个人，则跳转到单聊,否则创建一个新的讨论组
	        		if(resourceids.length == 1){
						openType = 0;	        			
	        		}else{
						for(var i in resourcenames){
	        				if(i < 3){
	        					groupName += ","+resourcenames[i];
	        				}else{
								break;
							}
	        				
	        			}
	        			groupName = groupName.substring(1); 
						openType = 2;      			
	        		}					
	        	}
				
	        socialForShare.sendMsgToPCorWeb(data.id,openType,groupName,extraObj,function(){
					top.getDialog(window).close();
				});
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
var socialForShare ={
    pcClientSettings :JSON.parse('<%=pcClientSettings%>'),
    shareType:{
        "folder":"<%=isOpenDisk%>",//云盘目录
		"pdoc":"<%=isOpenDisk%>",//云盘文件
		"workflow":"ifForbitWfShare",//流程
		"doc":"ifForbitDocShare",//新闻文档
		"crm":"ifForbitCustomer",//crm
		 },
	checkIfForbit:function (shareType) {
        if("0"== this.shareType[shareType] || "1" == this.pcClientSettings[this.shareType[shareType]]){
            return true;
        }
        return false;
   	 },
		/**
		* 调用e-message发起会话
		* @param conventioners
		* @param openType
		* @param groupName
		* @param extra
		*/
		sendMsgToPCorWeb:function(conventioners,openType,groupName,extra,successCallBack,errorCallBack){
					jQuery.ajax({
						url :"/social/im/SocialIMOperation.jsp?operation=openPCconversation",
						data : {
							'conventioners':conventioners,
							'openType':openType,
							'groupName':groupName,
							'extra':extra
						},
						type : "post",
						dataType : "json",
						contentType: "application/x-www-form-urlencoded; charset=utf-8", 
						success : function(data){
							if(data !=null){
								if(data.pcStatus ==0&&data.webStatus==0){
									//pc和web都不在
								window.top.Dialog.alert("检查到您的web端和客户端的e-message不在线，<br>  请打开任意一端进行会话！");
								}else if(data.webStatus ==1){
									//web在线
									if(window.top.$('#socialIMFrm').length>0){
										
									}else{
										if(!!window.ActiveXObject || "ActiveXObject" in window){
											window.top.Dialog.alert("您发起的e-message聊天已经建立，<br>  请到主页进行消息发送！");	
										}
									}
								}else{
									//pc在线不作判断
								}
								typeof successCallBack ==='function' && successCallBack(data);
							}else{
								window.top.Dialog.alert('对话创建失败！');
								typeof errorCallBack ==='function' && errorCallBack();
							}
						},
						error:function(XMLHttpRequest, textStatus, errorThrown){
							window.top.Dialog.alert('请求发送失败，请您检查当前网络！');
							typeof errorCallBack ==='function' && errorCallBack();
						}			
					});
				}
	}

</script>
</html>

