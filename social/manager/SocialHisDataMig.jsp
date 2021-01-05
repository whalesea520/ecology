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
try{
	recordSet.execute("select count(*) from OFMUCROOM where istransfered is null or istransfered <> '1'");
}catch(Exception e){
	recordSet.execute("select count(*) from OFMUCROOM");
}
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
		    width: 150px;
		    height: 30px;
	  		line-height: 30px;
		    text-align: center;
		    font-size: 16px;
		    background: #03a996;
		    color: #fff;
		    margin: 40px auto;
		    cursor: pointer;
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
			var successRooms  = [], failRooms = [], totalSize = Number("<%=totalCount%>"), 
				ignoredSize = 0, successSize = 0; failSize = 0, idToken = {}, groupDatas, WORKING = 0;
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
				if(WORKING) {
					alert("正在迁移，稍等。。");
					return;
				}
			    jQuery.ajax({
			        type: 'POST',
			        url : '/social/manager/SocialManagerOperation.jsp?method=transferGroups',
			        dataType: "json",
			        cache: false,
			        timeout: 300000,
			        success: function(groupDataTrans){
			            clearVars();
			            //return;
			            //console.log("groupDataTrans:",groupDataTrans);
			            ignoredSize = getIgnoredSize(groupDataTrans);
			            $("#ignoredTip").text(ignoredSize);
			            //alert(totalSize);
			            //return;
			            
			            groupDatas =  groupDataTrans;
			            
			            doCreate();
			            
			        }
			
			    });
			
			}
			
			function doTempCreation(roomUserIds, createrid, roomNaturalName, cb){
                var groupList = roomUserIds;
                for(var i = 0; i < groupList.length; i++) {
                    var itemgroup = groupList[i], userids, useridList;
                    //debugger;
                    for (var k in itemgroup) {
                        userids = itemgroup[k];
                        //拼接创建人自己
                        userids += "," + createrid;
                        useridList = userids.split(",");
                        for (var j = 0; j < useridList.length; ++j) {
                            useridList[j] = useridList[j] + "|" + UDID;
                        }
                        //防止超频
                        setTimeout(function(){
                        	RongIMClient.getInstance().createDiscussion(roomNaturalName, useridList, {
	                            onSuccess: function (targetId) {
	                                console.log("为" + createrid + "创建讨论组:" + roomNaturalName + "成功");
	                                successRooms.push(k);
	                                successSize++;
	                                writeStatusBack(1);
	                                cb(true);
	                            },
	                            onError: function (targetId) {
	                                console.log("为" + createrid + "创建讨论组:" + roomNaturalName + "失败");
	                                failRooms.push(k);
	                                failSize++;
	                                writeStatusBack(0);
	                                cb(false);
	                            }
	
	                        });
                        }, 200);
                    }
                }
			
			}
			
			function doCreateDiscuss(group, needConnect, token, cb) {

			    var createrid = group.createrid;
			    var roomUserIds = group.roomUserIds;
			    var roomNaturalName = group.roomNaturalName;
			    if(needConnect){
			        RongIMClient.getInstance().disconnect();
			        RongIMClient.connect(token, {
			            onSuccess : function(imUserId) {
			            	console.log("测试链接：" +createrid + "成功");
			                doTempCreation(roomUserIds, createrid, roomNaturalName, cb);
			            },
			            onError: function(err){
			                console.log("测试链接：" + createrid + "失败");
			            }
			        });
			    }else{
			        doTempCreation(roomUserIds, createrid, roomNaturalName, cb);
			    }
			}
			
			function doCreate(){
				WORKING = 1;
				if(groupDatas.length <= 0) {
					WORKING = 0;
					return;	
				};
				
				var group = groupDatas.shift();
				var token = group.token;
				
			    if(idToken[createrid]){
                	needConnect = false;
                }else{
                	 needConnect = true;
                	 idToken[group.createrid] = token;
                }       
                
                doCreateDiscuss(group, needConnect, token, function(isSuccess){
                	setTimeout(function(){
   						doCreate();             		
                	}, 1000);
                });
			                
			}
			
			//获取被忽略的群组个数
			function getIgnoredSize(groupDataTrans){
				if(groupDataTrans.length == 0){
					return totalSize;
				}
				var totalGroupCount = totalSize,groupList, sumGroupCount = 0;
				for(var i = 0; i < groupDataTrans.length; ++i){
					groupList = groupDataTrans[i].roomUserIds;
					sumGroupCount += groupList.length;
				}
				if(sumGroupCount > totalGroupCount){
					throw new Error('error compute from getIgnoredSize!');
				}
				return totalGroupCount - sumGroupCount;
			}
			
			$(function(){
				$("#successTip").text(0);
				$("#failTip").text(0);
				$("#ignoredTip").text(0);
			});
		</script>

</head>

<body>

	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="social"/>
	   <jsp:param name="navName" value="<%SystemEnv.getHtmlLabelName(126736, user.getLanguage()) %>"/>
	</jsp:include>
	
	<div style="text-align: center;margin-top:30px;font-size:16px;">共有&nbsp;<span style="color:red;"><%=totalCount %></span>&nbsp;个群需要迁移</div>
	
	<div class="transferBtn" onclick="testTransGroupData();">迁移历史群组数据</div>
	
	<div class="tip">
		成功:<span id="successTip"></span>
		失败:<span id="failTip"></span>
		忽略:<span id="ignoredTip"></span>
	</div>
	
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  

</body>
</html>