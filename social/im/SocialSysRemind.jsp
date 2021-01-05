<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	return;
}
String userid=""+user.getUID();

String from  = Util.null2String(request.getParameter("from"));
boolean isfromChat = from.equals("chat");

String targetName  = Util.null2String(request.getParameter("targetName"));
%>
<html>
<head>
	<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
    <link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
	<style>
		*{
			font-family: "Microsoft YaHei"!important;
		}
		.clear{clear:both;}
		body{
			padding: 0;
			margin: 0;
			font-size:12px;
			background: #f5f5f5;
			color:#374660;
			overflow: hidden;
		}
		.titlebar{
			height: 40px;
		    line-height: 40px;
		    font-size: 16px;
		    text-align: center;
		    position: relative;
		}
		.titlebar .btnGroup{
			height: 100%;
		    min-width: 80px;
		    position: absolute;
		    right: 0;
		    top: 0;
		}
		.titlebar .btnGroup .setBtn{
			display: inline-block;
		    width: 50%;
		    height: 100%;
		    float: left;
		    background: url('/social/images/im_setting_wev8.png') no-repeat center center;
		    cursor: pointer;
		}
		.titlebar .btnGroup .closeBtn{
			display: inline-block;
		    width: 50%;
		    height: 100%;
		    color: #99A0A6;
    		font-size: 22px;
    		cursor: pointer;
		}
		
		#msgList{
			position: absolute;
		    bottom: 0px;
		    top: 40px;
		    right: 0;
		    left: 0;
		    height: auto;
		}
		
		#msgList .msgItem{
			border: 1px solid #ebebeb;
		    width: 80%;
		    margin: 0 auto;
		    background: #fff;
		    min-height: 130px;	
		    color: #737373;
		    padding: 0 12px;
		    cursor:pointer;
		}
		
		.msgItem .msgTitle{height: 45px; font-size: 16px;color:#374660;line-height: 45px;}
		.msgItem .msgContent{}
		.msgItem .msgContent .subject{}
		.msgItem .msgContent .msgDetails{padding: 16px 0;}
		.msgItem .msgOpt{height: 45px;line-height: 45px;overflow:hidden;}
		
		.msgItem .splitHorLine{
			border-top: 1px solid #ebebeb;
		    width: auto;
		}
		
		#msgList .sendtime{
			margin: 0 auto;
		    width: 50%;
		    text-align: center;
		    height: 40px;
		    line-height: 40px;
		}
	</style>
	<script>
		$(document).ready(function(){
			$("#msgList").perfectScrollbar();
		});
		
		var RemindHandler = {
			_getDataset: function(obj){
				var msgItemObj = $(obj).closest(".msgItem");
				if(msgItemObj.length == 0 && $(obj).hasClass("msgItem")){
					msgItemObj = $(obj);
				}
				if(msgItemObj.length > 0){
					if(msgItemObj[0].dataset){
						return msgItemObj[0].dataset;
					}else{
						return {};
					}
				}
			},
			goDetail: function(obj){
				var dataset = RemindHandler._getDataset(obj);
				window.open(dataset.url + dataset.requestid);
			},
			//打开系统提醒设置
			doOpenSet: function(){
				var title = '系统提醒设置',width = 500, height = 600;
				var url = '/social/im/SocialSysRemindSetting.jsp';
				var dialog = RemindHandler.getSocialDialog(title,width,height);
				dialog.URL =url;
				dialog.ShowButtonRow = false;
				dialog.show();
				//dialog.callbackfun = opt.callbackfun;
				document.body.click();
			},
			getSocialDialog(title,width,height,closeHandler){
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
			}
		}
	</script>
</head>
<body>
	<div class="titlebar">
		<%=targetName %>
		<div class="btnGroup">
			<div class="setBtn" onclick="RemindHandler.doOpenSet();"></div>
			<%if(!isfromChat){ %>
			<div class="closeBtn" onclick="alert('close parent window')">×</div>
			<%} %>
		</div>
	</div>
	<div id="msgList">
		<%
			String sql = "select t3.remindname title,t3.surl handleurl,t1.remindtype remindtype, t1.requesttitle subject, t1.requestid requestid, t1.requestdetails requestdetails,t1.sendtime sendtime "+
			"from social_sysremind t1 left join social_sysremindreceiver t2 on t1.id = t2.remindid left join social_sysremindtype t3 on t1.remindtype = t3.remindtype where t2.receiverid = '"+userid+"' order by sendtime desc";
			RecordSet.execute(sql);
			while(RecordSet.next()){
		%>
			<div class="sendtime"><%=RecordSet.getString("sendtime") %></div>
			<div class="msgItem" data-remindtype="<%=RecordSet.getString("remindtype") %>" data-url="<%=RecordSet.getString("handleurl") %>" data-requestid="<%=RecordSet.getString("requestid") %>"
				 onclick="RemindHandler.goDetail(this);">
				<div class="msgTitle"><%=RecordSet.getString("title") %></div>
				<div class="msgContent">
					<div class="subject"><%=RecordSet.getString("subject") %></div>
					<div class="msgDetails">
						<%=RecordSet.getString("requestdetails") %>
					</div>
				</div>
				
				<div class="splitHorLine"></div>
				<div class="msgOpt">
					<span>查看详情</span>
					<span style="float:right;">></span>
				</div>
			</div>
		<%
			}
		%>
	</div>
	<div id="msgItemTemp" style="display:none;">
		<div class="sendtime"></div>
		<div class="msgItem" data-remindtype="" data-url="" data-requestid=""
			 onclick="RemindHandler.goDetail(this);">
			<div class="msgTitle"></div>
			<div class="msgContent">
				<div class="subject"></div>
				<div class="msgDetails">
				</div>
			</div>
			
			<div class="splitHorLine"></div>
			<div class="msgOpt">
				<span>查看详情</span>
				<span style="float:right;">></span>
			</div>
		</div>
	</div>
</body>
</html>
