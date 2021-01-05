<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.social.SocialUtil" %>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<%@ include file="/social/im/SocialIMInit.jsp"%>
<%
String userid=""+user.getUID();

String from  = Util.null2String(request.getParameter("from"));
boolean isfromChat = from.equals("chat");

String targetName  = Util.null2String(request.getParameter("targetName"));
JSONObject sysBroadcastSet = SocialIMService.getSysBroadcastSet(user); 
if("1".equals(sysBroadcastSet.getString("isSysBroadcastForbit"))){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<html>
<head>
	<link rel="stylesheet" href="/social/css/broadcast.view.css" type="text/css" />
	<script>
		var BCHandler = {
			options: {
				PAGESIZE: 4
			},
			hasNext: true,
			pageNo: 2,
			tempPageSize: 0,
			getFiltParams: function(){
				var contentWin = $("#bcadsframe")[0].contentWindow;
				console.log(contentWin.BCS);
				if(contentWin){
					return contentWin.BCS.packParams();
				}else{
					return {};
				}
			},
			loadMsgList: function(_params, callback){
				var params;
				if(_params){
					params = _params;
				}else{
					params = new Object();
					params.content = $.trim($('#searchKeyword').val());
				}
				
				$("#msgList").load("/social/im/SocialBroadCastList.jsp", params, function(){
					if(typeof callback === 'function'){
						callback();
					}
				});
			},
			getBroadcastList: function(pageno, filtParams, isflush, callback){
				var url = "/mobile/plugin/social/SocialMobileOperation.jsp?operation=getBroadcast";
				var pagesize = this.options.PAGESIZE;
				if(BCHandler.tempPageSize != 0){
					pagesize = BCHandler.tempPageSize;
				}
				var params = {pageindex: pageno, pagesize: this.options.PAGESIZE};
				$.extend(params, filtParams);
				$.post(url, params, function(data){
					if(!data){
						return;
					}
					var msgList = $('#msgList');
					var resObjList = data.res;
					var hasnext = data.hasnext;
					BCHandler.hasNext = hasnext;
					if(isflush){
						msgList.empty();
					}
					//消除临时添加的item,并重置tempPagesize
					msgList.find('.msgItem[temp]').removeAttr('temp');
					BCHandler.tempPageSize = 0;
					$.each(resObjList, function(i, resObj){
						var extraObj = new Object();
						extraObj.plaintext = resObj.plaintext;
						$.extend(extraObj, resObj.requestobjs);
						extraObj.broadid = resObj.id;
						extraObj.msg_id = resObj.msgid;
						extraObj.msg_is_broadcast = true;
						extraObj.sendtime = resObj.sendtime;
						extraObj.senderid = resObj.fromUserId;
						PushHandler.updateBroadcastList(extraObj, 'append');
						if(i === resObjList.length - 1 && typeof callback === 'function') {
							callback(data);
						}
					});
				}, 'json');
			},
			openBroadCastSend: function(){
				var dialog = BCHandler.getSocialDialog('<%=SystemEnv.getHtmlLabelName(131684, user.getLanguage()) %>');
				dialog.URL = "/social/im/SocialBroadCastSend.jsp?from="+from;
				dialog.maxiumnable = false;
				dialog.ShowButtonRow = false;
				dialog.Width = 658;
				dialog.Height = 508;
				dialog.openerWin = window;
				dialog.show();
			},
			showEmptyBg: function(flush){
				if(flush){
					$("#msgList").empty();
				}
				var items = $("#msgList .msgItem");
				if(items.length <= 0){
					$("#msgList")
						.append("<div class='bcEmptyBg bg'></div>")
						.append("<div class='bcEmptyBgText bg'><%=SystemEnv.getHtmlLabelName(131683, user.getLanguage()) %></div>");
				}
			},
			getSocialDialog: function(title,width,height,closeHandler){
				var diag =new window.top.Dialog();
			    diag.currentWindow = window; 
			    diag.Modal = true;
			    diag.Drag=true;
				diag.Width =width?width:680;	
				diag.Height =height?height:420;
				diag.ShowButtonRow=false;
				diag.Title = title;
				diag.closeHandle = function(){
					if(typeof closeHandler == 'function'){
						closeHandler(diag);
					}
					//pc端关闭时恢复拖动绑定
					if(typeof from != 'undefined' && from == 'pc'){
						DragUtils.restoreDrags();
					}
				}
				if(typeof from != 'undefined' && from == 'pc'){
					DragUtils.closeDrags();
				}
				return diag;
			},
			showImgLight: function(ele){
				var imgDivObj = $(ele).closest('.imgdiv');
				var allImgObj = imgDivObj.children('img');
				var curIndex = allImgObj.index(ele);
				var imgpool = new Array();
				$.each(allImgObj, function(index, obj){
					imgpool.push($(obj).attr('src'));
					if(index == allImgObj.length - 1) {
						openImgView(curIndex, imgpool);
					}
				});
			},
			checkEnterSearch: function(evt, ele){
				evt = evt || window.event;
				var keynum;
				if(typeof window.event != 'undefined')
		       		keynum=evt.keyCode;
		        else
		            keynum=evt.which;
		        if(keynum==13||keynum==10){
		        	$(ele).closest('.advanceSearch').find('.searchSubmit').click();
		        }else{
		        	var searchMain = $('#searchFitPane');
		        	if(searchMain.attr('loaded')) {
		        		$("#bcadsframe").contents().find('#broadcontent').val($(ele).val());
		        	}
		        }
			},
			search: function(){
				$("#searchFitPane").toggleClass('isopen').hide();
				BCHandler.loadMsgList(false, function(){
					BCHandler.showEmptyBg();
				});
			},
			filter: function(){
				var searchMain = $('#searchFitPane');
				searchMain.css({'height': '135px','background': '#fff'});
				searchMain.toggleClass('isopen');
				searchMain.slideToggle(function(){
					if(searchMain.attr('loaded')) {
						IMUtil.shutLoading();
	 					searchMain.css({'background': 'transparent','height': 'auto'});
					}else{
						var mystyle = ChatUtil.settings.mystyle;
						mystyle.top = '66px';
						IMUtil.showLoading(searchMain,mystyle,ChatUtil.settings.gif,5000,function(){
							IMUtil.shutLoading();
						});
						$('#bcadsframe').attr('src', '/social/im/SocialBroadCastSearch.jsp?content='+$('#searchKeyword').val());
					}
				});
			}
		}
		$(document).ready(function(){
			var msgList = $("#msgList");
			msgList.perfectScrollbar();
			IMUtil.bindLoadMoreHandler(document.getElementById('msgList'), function(target){
				if(!BCHandler.hasNext){
	        		return false;
	        	}
	        	if(msgList.attr('loading')){
	        		return false;
	        	}
	        	//var filtParams = BCHandler.getFiltParams();
	        	var filtParams = {};
	        	var searchMain = $("#searchFitPane");
	        	if(searchMain.length > 0 && searchMain.hasClass('isopen')){
	        		filtParams = BCHandler.getFiltParams();
	        	}
				var pageno = BCHandler.pageNo;
				if(pageno == -1){
					return false;
				}
				IMUtil.showLoading(msgList,ChatUtil.settings.mystyle,ChatUtil.settings.gif,2000,function(){
					IMUtil.shutLoading();
					msgList.removeAttr('loading');
				});
				msgList.attr('loading', 'true');
       			BCHandler.getBroadcastList(pageno,filtParams,false,function(data){
       				msgList.removeAttr("loading");
					IMUtil.shutLoading();
       				msgList.perfectScrollbar("update");
       				BCHandler.pageNo++;
       			});
			});
			BCHandler.loadMsgList(false, function(){
				BCHandler.showEmptyBg();
			});
		});
	</script>
</head>
<body>
	<div class="titlebar">
		<%=targetName %>
		<div class="btnGroup">
			<%if("1".equals(sysBroadcastSet.getString("hasSysBroadcastRight"))){ %>
			<div class="sendBtn btnGroupItem" onclick="BCHandler.openBroadCastSend();"><%=SystemEnv.getHtmlLabelName(131684, user.getLanguage()) %></div><!-- 发广播 -->
			<%} %>
			<div class="advanceSearch btnGroupItem">
				<div class="searchBox">
					<input id="searchKeyword" name="searchKeyword" placeholder="<%=SystemEnv.getHtmlLabelName(131685, user.getLanguage()) %>" max-length="20" size="20" onkeyup="BCHandler.checkEnterSearch(event, this);"><!-- 广播内容 -->
				</div>
				<div class="searchFit searchBtnBox" title="<%=SystemEnv.getHtmlLabelName(131686, user.getLanguage()) %>" onclick="BCHandler.filter();"></div><!-- 筛选 -->
				<div class="searchSubmit searchBtnBox" title="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %>" onclick="BCHandler.search();"></div> <!-- 搜索 -->
			</div>
		</div>
	</div>
	<!-- 筛选 -->
	<div id="searchFitPane">
		<iframe src="" id="bcadsframe" name="bcadsframe" frameborder="0" height="100%" width="100%;"></iframe>
	</div>
	<div id="msgList">
		
	</div>
	<div id="msgItemTemp" style="display:none;">
		<div class="msgItem">
			<div class="msgContent">
				<div class="txtdiv">
					<!-- 文字显示区域 -->
				</div>
				<div class="imgdiv">
					<!-- 图片显示区域 -->
				</div>
				<div class="resdiv">
					<table width="100%" cellpadding="0" cellspacing="0">
						<colgroup><col width="60px"><col width="*"></colgroup>
						<tr class='accList'>
							<td class="titleHead greycolor">
								<img src='/social/images/broadcast_acc_wev8.png'/>
							</td>
							<td class="titleBody">
								<!-- 附件显示区域 -->
							</td>
						</tr>
						<tr class='wfList'>
							<td class="titleHead greycolor">
								<img src='/social/images/broadcast_wf_wev8.png'/>
							</td>
							<td class="titleBody">
								<!-- 流程显示区域 -->
							</td>
						</tr>
						<tr class='docList'>
							<td class="titleHead greycolor">
								<img src='/social/images/broadcast_doc_wev8.png'/>
							</td>
							<td class="titleBody">
								<!-- 文档显示区域 -->
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="msgOpt">
				<span class="sendname"></span>
				<span class="sendtime"></span>
			</div>
		</div>
	</div>
</body>
</html>
