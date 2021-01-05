<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.mobile.rong.WeaverRongUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%

if (!HrmUserVarify.checkUserRight("message:manager", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String titlename =SystemEnv.getHtmlLabelName(18014,user.getLanguage()); //微博基本设置

WeaverRongUtil rongUtil=WeaverRongUtil.getInstanse();
Map<String,String> rongConfig=rongUtil.getRongConfig("1", "" ,"");
String APPKEY =rongConfig.get("APPKEY");//应用key
String UDID =rongConfig.get("UDID");//用户区分标识
RecordSet recordSet = new RecordSet();
recordSet.execute("select count(*) from ( " + 
        " SELECT DISTINCT targetid as targetid FROM social_IMConversation WHERE isopenfire = 0 and targettype = 1  AND targetid NOT IN (SELECT DISTINCT groupId FROM Social_AllGroupInfos)" +
        " union " +
        " select DISTINCT group_id as targetid from mobile_ronggroup where isopenfire = 0 and group_id NOT IN (SELECT DISTINCT groupId FROM Social_AllGroupInfos)) a");
recordSet.next();
int totalCount = recordSet.getInt(1);
%>

<!DOCTYPE HTML>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
    <SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
	<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()+"'></script>

 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<style>
		
		.transferBtn {
		    width: 134px;
		    height: 38px;
	  		line-height: 30px;
		    text-align: center;
		    font-size: 18px;
		    background: #288fe6;
		    color: #fff;
		    margin: 40px auto;
		    cursor: pointer;
		    border-radius:20px;
		}
		.transferBtn:hover {
			background: #3de;
		}
		.tip {
		    width: 300px;
    		margin: 0 auto;
    		text-align: center;
    		font-size: 16px;
		}
		.tip span{
		    color: red;
		    width: 30px;
		    display: inline-block;
		}
		.progressBar{
		 width:400px;
		 height:20px;
		 border:1px solid #98AFB7;
		 border-radius:5px;
		 margin-top:10px;
		 margin:0px auto;
		 }
		 #bar{
		 width:0px;
		 height:20px;
		 border-radius:5px;
		 background:#8ac7de;
		 }
	</style>
	<script type="text/javascript" src="/social/im/js/RongIMClient.js"></script>
	<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
	<script>
			var UDID = "<%=UDID%>";
			var M_APPKEY = "<%=APPKEY%>";
			var M_CORE = RongIMClient;
			(function(w) {
			    IMClient = function(listeners) {
			        if (!listeners.onConnectionStatusChanged) {
			            listeners.onConnectionStatusChanged = function (status) {
			                switch (status) {
			                    //链接成功
			                    case RongIMClient.ConnectionStatus.CONNECTED:
			                        console && console.log('链接成功');
			
			                        break;
			                    //正在链接
			                    case RongIMClient.ConnectionStatus.CONNECTING:
			                        console && console.log('正在链接');
			                        break;
			                    //重新链接
			                    case RongIMClient.ConnectionStatus.RECONNECT:
			                        console && console.log('重新链接');
			                        break;
			                    //其他设备登陆
			                    case RongIMClient.ConnectionStatus.OTHER_DEVICE_LOGIN:
			                        console && console.log('其他设备登陆');
			
			                        checkLoginStatus();
			                        break;
			                    //连接关闭
			                    case RongIMClient.ConnectionStatus.CLOSURE:
			                        console && console.log('链接断开');
			                        break;
			                    //未知错误
			                    case RongIMClient.ConnectionStatus.UNKNOWN_ERROR:
			                        console && console.log('未知错误');
			                        break;
			                    //登出
			                    case RongIMClient.ConnectionStatus.LOGOUT:
			                        console && console.log('登出');
			                        break;
			                    //用户已被封禁
			                    case RongIMClient.ConnectionStatus.BLOCK:
			                        console && console.log('用户已被封禁');
			                        break;
			                }
			            };
			        }
			        var receiveMessageListener = {
			            onReceived : function(data) {
			                listeners.onMessageReceived(data);
			            }
			        };
			        var connectionStatusListener = {
			            onChanged : listeners.onConnectionStatusChanged
			        };
			        M_CORE.init(M_APPKEY);
			        M_CORE.setConnectionStatusListener(connectionStatusListener);
			        M_CORE.getInstance().setOnReceiveMessageListener(receiveMessageListener);
			
			        var connectionListener = {
			            onSuccess : function(imUserId) {
			
			            },
			            onError : listeners.onConnectionError
			        };
			    };
			
			    IMClient.prototype = new Object();
			
			    IMClient.prototype.reconnect=function(){
			        RongIMClient.getInstance().reconnect({
			            onSuccess:function(){
			                console.log('重新连接成功');
			            },
			            onError: function(e){
			                console.log('重新连接失败');
			                console.log(e);
			            }
			        });
			    };
			
			    IMClient.prototype.disconnect=function(){
			        console && console.log('断开链接');
			        RongIMClient.getInstance().disconnect();
			    };
			
			})(window);
			
			var client;
			
			window.onload = function () {
			    var listeners = {
			        //接收消息的回调
			        onMessageReceived:function (data) {
			
			        },
			        onConnectionSuccess: function (x) {
			            console && console.log("connected，userid＝" + x);
			
			        },
			        onConnectionError: function (x) {
			            console && console.log(x)
			            console.info('链接失败');
			        }
			    };
			
			    client = new IMClient(listeners);
			}
			
			var successRooms  = [], failRooms = [], totalSize = Number("<%=totalCount%>"), ignoredSize = 0, successSize = 0; failSize = 0, idToken = {};
			//回写处理状态
			function writeStatusBack(issuccess) {
				if(issuccess){
					$("#successTip").text(successSize);
				}else{
					$("#failTip").text(failSize);
				}
			    //如果成功、失败、忽略的个数和达到数目就回写
			    if(ignoredSize + successSize + failSize >= totalSize){
			    	if(successRooms.length == 0){
			    		return;
			    	}
			    	var successRoomNames = successRooms.join(",");
			    	jQuery.post('/social/manager/SocialManagerOperation.jsp?method=writeTransStatus',{successRoomNames: successRoomNames}, function(ok){
						ok = $.trim(ok);
						console.log("write back ok??", ok);
					});
			    }
			}
			
			function clearVars(){
			    successRooms = [];
			    failRooms = [];
			    ignoredSize = 0;
			    successSize = 0;
			    failSize = 0;
			    idToken = {};
			}
			
			//测试群组数据迁移
			function testTransGroupData(){
				$("#tranferDataBtn").hide();
				$("#cancleDataBtn").show();
				$('#prodiv').show();
			    $('.tip').show();
			    jQuery.ajax({
			        type: 'POST',
			        url : '/social/manager/SocialManagerOperation.jsp?method=transferGroupsData',
			        dataType: "json",
			        cache: false,
			        timeout: 300000,
			        success: function(Data){
			            clearVars();//初始化
			            var successSize =  0;
			            var failSize =  0;
			            if(Data.Flag==2){
			            	successSize = Data.successSize;
			            	failSize = Data.failSize		            	
			            }
			            $("#successTip").text(successSize);
						$("#failTip").text(failSize);
						progressBar(successSize);
						if(Data.Flag==1){
							$("#tranferMessage").html(Data.Message);
						}else
						{
							$("#tranferMessage").html(Data.Message+"<br>1."+Data.Message1+"<br>2."+
									Data.Message2+"<br>3."+Data.Message3+"<br>4."+Data.Message4);
						$("#cancleDataBtn").hide();
						}
										
			        }
			    
			
			    });
			}
			function progressBar(s){
				 var e = <%=totalCount %>;
				  $("#bar").css("width","0px");
				   nowWidth = parseInt($("#bar").width());
				   if(e>=0) nowWidth = (400*s)/e;
				   if(nowWidth<=400){
				    barWidth = nowWidth+"px";
				    $("#bar").css("width",barWidth);
				   }
				   if(nowWidth==0){$("#bar").css("width",400)};
				 }
			$(function(){
				$("#successTip").text(0);
				$("#failTip").text(0);
			});
		</script>

</head>

<body>

	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="social"/>
	   <jsp:param name="navName" value="<%SystemEnv.getHtmlLabelName(126736, user.getLanguage()) %>"/>
	</jsp:include>
	<div id="startPro">
	<div id="tranferMessage" style="text-align: center;margin-top:30px;font-size:16px;">共有&nbsp;<span style="color:red;"><%=totalCount %></span>&nbsp;个群组会话需要迁移</div>
	<div id="process">
	<div class="center" style="height: 150px;background: url(../images/jpg.png) center center no-repeat;"></div>
	<div id="prodiv" style="display: none;">
	<div class="progressBar"><div id="bar"></div></div>
	<div class="tip" style="display: none;">
		成功:<span id="successTip"></span>
		失败:<span id="failTip"></span>
	</div>
	</div>
	<div id="tranferDataBtn" class="transferBtn" onclick="testTransGroupData();">迁移</div>
	<div id="cancleDataBtn" class="transferBtn" style="display: none;" onclick="window.location.reload()">取消</div>
	</div>
	
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  

</body>
</html>