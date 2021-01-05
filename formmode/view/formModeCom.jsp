<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
User user = HrmUserVarify.getUser (request , response) ;
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
int billId = Util.getIntValue(request.getParameter("billId"),0);
int replyModeId = 0;
int replyFormId = 0;
/*String sql = "select * from workflow_bill where tablename='uf_Reply'";
rs.executeSql(sql);
if(rs.next()){
	replyFormId = Util.getIntValue(rs.getString("id"),0);
}
if(replyFormId!=0){
	rs.execute("select * from modeinfo where formid="+replyFormId);
	if(rs.next()){
		replyModeId = Util.getIntValue(rs.getString("id"),0);
	}
}*/
String sql = "select * from formEngineSet where isdelete=0";
rs.executeSql(sql);
if(rs.next()){
	replyModeId = Util.getIntValue(rs.getString("modeid"),0);
}
if(replyModeId!=0){
	rs.execute("select * from modeinfo where id="+replyModeId);
	if(rs.next()){
		replyFormId = Util.getIntValue(rs.getString("formid"),0);
	}
}
String replyFrameSrc = "/formmode/view/formModeComView.jsp";
replyFrameSrc+="?modeId="+replyModeId+"&formId="+replyFormId;
replyFrameSrc+="&reqModeId="+modeId+"&reqFormId="+formId+"&reqBillid="+billId;
%>
<html>
  <head>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<style type="text/css">
	 .signblockbarclass {padding: 0px;margin: 0px 0px 10px 0px;background: #fff;height: 44px;overflow-y: hidden;white-space: nowrap;border-bottom:1px solid #d6d6d6;}
	 .signblockbarULclass li{float:left;display:inline;list-style-type:disc;line-height:40px;padding:0 0px;}
	 .signblockbarULclass li a{color:#242424;}
	 .signblockbarULclass .current a{color:#008df6;}
	 .current{border-bottom: 2px solid #089bfe;}	
	 .fmComentClass{margin: 0px 0px 10px 0px; border-bottom: 1px solid #dadada;background: #fff;font-size: 12px;vertical-align: middle;padding: 0px 10px 0px 0px; clear: both;}
	 .fmComentClass .commentAvtorClass{width:65px;float:left;padding:5px 0px 10px 15px;}
	 .commentAvtorClass img{width: 40px;height: 40px;border-radius: 28px;}
	 .fmComment_replayContent{padding-bottom: 5px;padding-top: 5px;word-break:break-all}
	 .fmComentClass .fmComentTime{padding-left:8px;color: #929393}
	 .fmCommentBcolor{color: #929393}
	 .fmLeft{float:left}
	 .fmRight{float:right}
	 .fmClear{clear:both}
	 .fmComentClass .fmOperations{padding-left: 5px;padding-top: 10px;padding-right: 5px;padding-bottom:5px;font-size: 12px;vertical-align: middle;background:#fff;}
	 .fmOperations .fmItem{padding-left:16px;color: #9e9e9e;cursor: pointer;}
	 .fmOperations .fmComment{background-image:url('/cowork/images/icon/com_wev8.png');background-repeat: no-repeat;}
	 .fmOperations .fmQuote{background-image:url('/cowork/images/icon/quote_wev8.png');background-repeat: no-repeat;}
	 .fmOperations .fmDel{background-image:url('/cowork/images/icon/del_wev8.png');background-repeat: no-repeat;}
	 .fmOperations .fmItem{padding-left:16px;color: #9e9e9e;cursor: pointer;}
	 .fmOperations .fmEdit{background-image:url('/cowork/images/icon/edit_wev8.png');background-repeat: no-repeat;}
	 a.fmReplayLink:link{color:#999999;margin-right: 5px;text-decoration: none;font-size:12px}
	 a.fmReplayLink:visited{color:#999999;margin-right: 5px;text-decoration: none;;font-size:12px}
	 a.fmReplayLink:hover{color:#000000;margin-right: 5px;text-decoration: underline;;font-size:12px}
	 .fmReplaydiv{display: none;border: 1px solid #DCDCDC;padding: 5px 10px 5px 10px;margin: 5px 0px 5px 0px;background-color: #ffffff;color:#999999}
	 .fmComment_arrow{background:url('/images/ecology8/angle_wev8.png') no-repeat 50% 50%;width:24px;height:19px;position:absolute;}
	 .fmCommentOperation{margin-top: 3px;height:28px;}
	 .formModeReplyExtTitle{color: #444; padding: 5px 10px 2px 10px; margin-top: 15px; background-color: rgb(245, 245, 245);}
	 .fm_div_pager{clear:both;height:30px;line-height:30px;margin-top:3px;color:#999999;font-weight:bold;float: right;}
	 .fmCommenttr{}
	 .fmtime{color: #929393;}
	 .fmCommentlist{border: 0px solid #dee3e3;padding:6px 8px 6px 8px;background-color:#f9f9f9;margin-top:5px;}
	 .fmCommentlist .fmCommentitem{padding-top:5px;padding-bottom: 5px;}
	 .fmCommentlist .fmCommentline{border-bottom:1px dotted #e4e4e4}
	 .fmCommentlist .fmCommentitem .fmCommentContent{padding-top: 5px;padding-bottom: 5px;}
	 .fmCommentlist .fmCommentitem .fmCommentReply{background-image:url('/cowork/images/icon/com_wev8.png');background-repeat: no-repeat;padding-left:16px;color: #9e9e9e;cursor: pointer;margin-right:5px;}
	 .fmCommentlist .fmCommentitem .fmCommentDelete{background-image:url('/cowork/images/icon/com_del_wev8.png');background-repeat: no-repeat;padding-left:16px;color: #9e9e9e;cursor: pointer;margin-right:5px;}
	 a.fmRelatedLink:link,a.fmRelatedLink:visited,a.fmRelatedLink:hover{color:#929393;margin-right: 8px;font-size:12px}
	.fmTbItmOver{height: 44px;line-height: 44px;cursor: pointer;text-align: center;display: block;}
	.fmReplyDoOver{overflow: hidden;width: 50px;}
	.fmReplyDoOver .fmSearchImgSpan{display:block;width:50px;height:40px;background:url(/images/sign/search_wev8.png) no-repeat scroll center 50%;position:relative;cursor: pointer;}
	.tbItm{overflow: hidden;}
	.fmReplyConditions{display: none;}
	td.btnTd{border-bottom: 0px solid #dadada;}
	.fmOptName{color: #006a92 !important;}
	#signscrollfixed{padding: 0px 5px 0px 5px;}
	dl,dd,dt {
		margin: 0;
		padding: 0;
	}
	.floating_ck {
		position: fixed;
		right: 5px;
		top: 93%;
		display: none;
	}
	.floating_ck dl dd {
		position: relative;
		width: 35px;
		height: 35px;
		background-color: #007FC6;
		border-bottom: solid 0px #555666;
		text-align: center;
		background-repeat: no-repeat;
		background-position: center 20%;
		cursor: pointer;
	}
	.floating_ck dl dd:hover {
		background-color: #646577;
		border-bottom: solid 0px #a40324;
	}
	.floating_ck dl dd:hover .floating_left {
		display: block;
	}
	.moreFoot A {
		BACKGROUND: url(/blog/images/more_bg_wev8.png) repeat-x;
		width: 100%;
	}
	.moreFoot .loading EM.ico_load {
		BACKGROUND-IMAGE: url(../image/loading_wev8.gif);
		BACKGROUND-REPEAT: no-repeat;
	}
	.moreFoot {
		display: none;
		POSITION: relative;
		MARGIN-BOTTOM: -1px;
		HEIGHT: 37px;
		OVERFLOW: hidden;
		FONT-SIZE: 14px !important;
		FONT-WEIGHT: bold;
		background: #fcfcfc;
		padding-left: 5px;
		padding-right: 5px;
	}
	.moreFoot A {
		TEXT-ALIGN: center;
		LINE-HEIGHT: 19px;
		WIDTH: 100%;
		DISPLAY: block;
		BACKGROUND-REPEAT: repeat-x;
		HEIGHT: 37px;
		COLOR: #333 !important;
		PADDING-TOP: 10px
	}
	.moreFoot A:hover {
		/*BACKGROUND-POSITION: 0px -99px;*/
		TEXT-DECORATION: none;
		BACKGROUND: url(/blog/images/more_bg_hover_wev8.png) repeat-x;
		COLOR: #333 !important;
	}
	.moreFoot EM {
		PADDING-LEFT: 10px;
		WIDTH: 9px;
		DISPLAY: inline-block;
		HEIGHT: 16px;
		VERTICAL-ALIGN: text-top;
		OVERFLOW: hidden;
		CURSOR: pointer
	}
	.moreFoot EM.ico_load {
		POSITION: absolute;
		WIDTH: 16px;
		DISPLAY: none;
		MARGIN-LEFT: -50px;
		TOP: 12px;
		LEFT: 50%
	}
	.moreFoot .more_down {
		background: url('/blog/images/more_down_wev8.png') no-repeat 50% 50%;
		margin-left: 3px;
		width: 15px;
	}
	.moreFoot .loading EM.ico_load {
		DISPLAY: inline-block
	}
	.moreFoot {
		border-radius: 0 0 0 5px;
		-moz-border-radius: 0 0 0 5px;
		-webkit-border-radius: 0 0 0 5px
	}
	.moreFoot A {
		border-radius: 0 0 0 5px;
		-moz-border-radius: 0 0 0 5px;
		-webkit-border-radius: 0 0 0 5px
	}
	.moreFoot .more_down {
		background: url('/blog/images/more_down_wev8.png') no-repeat 50% 50%;
		margin-left: 3px;
		width: 15px;
	}
	</style>
	<script language=javascript src="/js/weaver_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/workflowshowpaperchange_wev8.js"></script>
	<script type="text/javascript">
		var fModeReplyCommid;
		var searchStatus=1;
		jQuery(document).ready(function() {
			//loadFmCommentLayout();
			showTopBtn();
		});
		function loadFmCommentLayout(){
			var params = "{modeId:'<%=replyModeId%>',formId:'<%=replyFormId%>',type:1,reqModeId:'<%=modeId%>',reqFormId:'<%=formId%>',reqBillid:'<%=billId%>'}";
			$.post("/formmode/view/formModeComView.jsp",eval('('+params+')'),function(data){
     			$("#fmCommentMainDiv").html(data);
 			});
		}
		function showReplay(comid,sign,commenttopid,commentusersid){
			if(fModeReplyCommid==""){
				fModeReplyCommid=comid;
			}
			if(fModeReplyCommid!=comid){
				 cancelReply(fModeReplyCommid);
				 fModeReplyCommid=comid;
			}
			var replyFrameParams = "";
			if(sign=="quotes"){
			   replyFrameParams = "&temp_Quotesid="+comid;
			   jQuery("#tipcontent_"+comid).html("<%=SystemEnv.getHtmlLabelName(83250, user.getLanguage()) %>");
			}else{
			   if(sign=="comment"){
				    replyFrameParams = "&temp_Commentid="+comid+"&temp_CommentTopid="+comid+"&temp_CommentUsersid=0";
			   }else{
				    replyFrameParams = "&temp_Commentid="+commenttopid+"&temp_CommentTopid="+comid+"&temp_CommentUsersid="+commentusersid;
			   }
			   jQuery("#tipcontent_"+comid).html("<%=SystemEnv.getHtmlLabelName(26965, user.getLanguage()) %>");
			}
			var replyFrameSrc = '<%=replyFrameSrc+"&billid=&type=1"%>';
			replyFrameSrc += "&iframeSign=replyFrame_"+comid+replyFrameParams+"&issubpage=1";
			jQuery("#replyFrame_"+comid).attr("src",replyFrameSrc);
			jQuery("#replaytr_"+comid).show();
		}
		function cancelReply(comid){
			fModeReplyCommid="";
			jQuery("#replaytr_"+comid).hide();
		}
		function delComment(obj,commentid){
			 window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83252, user.getLanguage()) %>",function(){
			 	jQuery.post("/formmode/view/formModeComOperation.jsp?method=delComment",{"rqmodeid":<%=modeId%>,"rqid":<%=billId%>,"commentid":commentid},function(data){
			 	   var commenttr=jQuery(obj).parents(".fmCommenttr:first");
		           var commentitem=jQuery(obj).parents(".fmCommentitem:first");
		           commentitem.prev().removeClass("fmCommentline");
		           commentitem.remove();
		           if(commenttr.find(".fmCommentitem").length==0) 
		        	   commenttr.hide();
		     	});
			 });
		}
		 function deleteComment(obj,comid,sign){
		     window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(128177, user.getLanguage()) %>",function(){
		    	jQuery.post("/formmode/view/formModeComOperation.jsp?method=deleteComment",{"rqmodeid":<%=modeId%>,"rqid":<%=billId%>,"commentid":comid,"sign":sign},function(data){
		    		if(jQuery.trim(data)=="3"){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128178, user.getLanguage()) %>");
						return;
					}else if(jQuery.trim(data)=="1"){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128179, user.getLanguage()) %>");
						return;
					}
		    		if(sign=='comment'){
		    			if(jQuery.trim(data)=="2"){
							window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128180, user.getLanguage()) %>");
							return;
						}
		    			jQuery.post("/formmode/view/formModeComOperation.jsp?method=delRealyComment",{"rqmodeid":<%=modeId%>,"rqid":<%=billId%>,"commentid":comid},function(data){
		          			signtabchanges(0);
		        		});
		    		}else{
		    			jQuery.post("/formmode/view/formModeComOperation.jsp?method=delRealyComment",{"rqmodeid":<%=modeId%>,"rqid":<%=billId%>,"commentid":comid},function(data){
					 	   var commenttr=jQuery(obj).parents(".fmCommenttr:first");
				           var commentitem=jQuery(obj).parents(".fmCommentitem:first");
				           commentitem.prev().removeClass("fmCommentline");
				           commentitem.remove();
				           if(commenttr.find(".fmCommentitem").length==0) 
				        	   commenttr.hide();
		     			});
		    		} 
			 	});
		     });     
		}
		function editComment(comid,quotesid){
			if(fModeReplyCommid==""){
				fModeReplyCommid=comid;
			}
			if(fModeReplyCommid!=comid){
				 cancelReply(fModeReplyCommid);
				 fModeReplyCommid=comid;
			}
			jQuery.post("/formmode/view/formModeComOperation.jsp?method=editComment",{"rqmodeid":<%=modeId%>,"rqid":<%=billId%>,"commentid":comid},function(data){
				if(jQuery.trim(data)=="1"){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128179, user.getLanguage()) %>");
					return;
				}else if(jQuery.trim(data)=="2"){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128180, user.getLanguage()) %>");
					return;
				}else if(jQuery.trim(data)=="3"){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128178, user.getLanguage()) %>");
					return;
				}
				var replyFrameSrc = "<%=replyFrameSrc%>"+"&type=2&billid="+comid;
				replyFrameSrc += "&iframeSign=replyFrame_"+comid+"&temp_Quotesid="+quotesid+"&isEditOpt=1";
				jQuery("#replyFrame_"+comid).attr("src",replyFrameSrc);
				jQuery("#replaytr_"+comid).show();
			});
		}
		function setIframeHeight(iframeSign) {
			setTimeout(function(){
				resetIframeHeight(iframeSign);
			},300);
		}
		function resetIframeHeight(iframeSign){
			var iframe = document.getElementById(iframeSign);
			if (iframe) {
					var iframeWin = iframe.contentWindow || iframe.contentDocument.parentWindow;
					var frameDoc = iframeWin.document;
					//var ifra = frameDoc.body.scrollHeight;
					//iframe.style.height = ifra + "px";
					var $frmmain = jQuery("#frmmain", frameDoc);
					if($frmmain.length > 0){
						iframe.style.height = ($frmmain.height() + 8) + "px";
					}
			}
		}
		function showRemarkDiv(iframeSign){
		   jQuery("#"+iframeSign).contents().find("#remarkShadowDiv").hide();
		   jQuery("#"+iframeSign).contents().find(".remarkDiv").show();
		}
		function showTopBtn(){
			jQuery(window).scroll(function()
			{
				var _top=jQuery(window).scrollTop();
				if(_top>200)
				{
					jQuery(".floating_ck").css("display","block");
				}
				else
				{
					jQuery(".floating_ck").css("display","none");
				}
			});
		}
		//JavaScript脚本实现回到页面顶部示例 acceleration 速度、stime 时间间隔 (毫秒)
		function gotoTop(acceleration,stime) {
		   acceleration = acceleration || 0.1;
		   stime = stime || 10;
		   var x1 = 0;
		   var y1 = 0;
		   var x2 = 0;
		   var y2 = 0;
		   var x3 = 0;
		   var y3 = 0; 
		   if (document.documentElement) {
		       x1 = document.documentElement.scrollLeft || 0;
		       y1 = document.documentElement.scrollTop || 0;
		   }
		   if (document.body) {
		       x2 = document.body.scrollLeft || 0;
		       y2 = document.body.scrollTop || 0;
		   }
		   var x3 = window.scrollX || 0;
		   var y3 = window.scrollY || 0;
		 
		   // 滚动条到页面顶部的水平距离
		   var x = Math.max(x1, Math.max(x2, x3));
		   // 滚动条到页面顶部的垂直距离
		   var y = Math.max(y1, Math.max(y2, y3));
		 
		   // 滚动距离 = 目前距离 / 速度, 因为距离原来越小, 速度是大于 1 的数, 所以滚动距离会越来越小
		   var speeding = 1 + acceleration;
		   window.scrollTo(Math.floor(x / speeding), Math.floor(y / speeding));
		 
		   // 如果距离不为零, 继续调用函数
		   if(x > 0 || y > 0) {
		       var run = "gotoTop(" + acceleration + ", " + stime + ")";
		       window.setTimeout(run, stime);
		   }
		}
	</script>
	
  </head>
  
  <body>
  	<div id="loading" style="display:none;">
		<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
		<span id="loading-msg"><%=SystemEnv.getHtmlLabelName(19945, user.getLanguage())%></span>
	</div>
  	<input type="hidden" id="modeId" name="modeId" value="<%=modeId%>">
	<input type=hidden name=formId id="formId" value="<%=formId%>">
	<input type="hidden" id="billId" name="billId" value="<%=billId%>">
	<input type="hidden" id="fModeReplyCommid" name="fModeReplyCommid" value="">
	<div  style="margin:10px 0px 5px 0px;" >
		<iframe id="replyFrame" name="replyFrame" frameborder="0" style="width: 100%;" scrolling="no" src="<%=replyFrameSrc+"&iframeSign=replyFrame&billid=&type=1"%>" onload="setIframeHeight('replyFrame');">
									
		</iframe>
	</div>
	<div id="signscrollfixed">
		<div id="titlePanel" class="" >
	    	<div class="signblockbarclass" style="width: 100%;">
		        <ul class="signblockbarULclass">
		            <li class="current" id="oTDtype_0"> 
		            	<a href="javascript:signtabchanges(0)"><%=SystemEnv.getHtmlLabelName(675, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(522, user.getLanguage()) %></a> 
		            </li>
		        </ul>
		        <table align="right" style="height:44px;" cellpadding="0px" cellspacing="0px" >
			        <tr width="100%">
			       		<td width="100%">
			    	    	<TABLE style="height:100%;table-layout: fixed; " id="toolBarTbl"  cellpadding="0px" cellspacing="0px"  width="100%" align="right" >
		    	    			<tr align="left">
						           <td class="fmReplyDoOver" searchSignName="showSearch" onclick="toggleSearch(this)">
						        		<span class="fmSearchImgSpan"></span>
						        		<span style="background:#eeeeee;color:#949494;font-size:14px;" class="fmTbItmOver" ><%=SystemEnv.getHtmlLabelName(82529, user.getLanguage()) %></span>   
						           </td>
					        	</tr>
			    			</TABLE>
						</td>
				     </tr>
	    		</table>
		    </div>
		    <div id="fmReplyConditions" class="fmReplyConditions">
		    	 <wea:layout type="4col">
            		<wea:group context="<%=SystemEnv.getHtmlLabelName(32905, user.getLanguage()) %>">
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%> <!-- 内容 -->
						</wea:item>
						<wea:item>
							<input class="inputstyle" type="text" id='fmCommentContent' value="" style="width:80%"/>
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(26225,user.getLanguage())%> <!-- 发表人 -->
						</wea:item>
						<wea:item>
							<brow:browser viewType="0" name="fmCommentReplyor" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp" width="80%" 
									browserSpanValue="">
							</brow:browser>
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(17697,user.getLanguage())%> <!-- 时间 -->
						</wea:item>
						<wea:item>
							 <BUTTON type="button" class=Calendar onclick="getDate(fmCommentReplySdateSpan,fmCommentReplySdate)"></BUTTON> 
				             <SPAN id=fmCommentReplySdateSpan></SPAN> 
				             <input type="hidden" name="fmCommentReplySdate" id="fmCommentReplySdate" >
				             <%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>&nbsp&nbsp
				             <BUTTON  type="button" class=Calendar onclick="getDate(fmCommentReplyEdateSpan,fmCommentReplyEdate)"></BUTTON> 
				             <SPAN id=fmCommentReplyEdateSpan></SPAN> 
				             <input type="hidden" name="fmCommentReplyEdate" id="fmCommentReplyEdate" >
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(27519,user.getLanguage())%> <!-- 楼号 -->
						</wea:item>
						<wea:item>
							 <span style="margin-right: 15px;">
							 	<input class=inputstyle type=text id='fmCommentFloorNum' onchange="checkFloorNum(this)" value="" size="5" style="width:40px;">
							 </span>
						</wea:item>
            		</wea:group>
		            <wea:group context="">
		                <wea:item type="toolbar">
		                    <input class="e8_btn_submit" type="button" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>" onclick="searchComment()";/>
		                    <span class="e8_sep_line">|</span>
		                    <input class="e8_btn_submit" type="button" value="<%=SystemEnv.getHtmlLabelName(27088, user.getLanguage()) %>" onclick="resetSearch()" />
		                    <span class="e8_sep_line">|</span>
		                    <input class="e8_btn_cancel" type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" onclick="cancelSearch();"/>
		                </wea:item>
		            </wea:group>
        		</wea:layout>
		    </div>
		 </div>
		 <div id="signall" style="position:relative;" class="">
		 	<div id='WorkFlowLoddingDiv_<%%>' style="position:absolute;top:20px;display: none; text-align: center; width: 100%; height: 18px; overflow: hidden;"> 
		 		<img src="/images/loading2_wev8.gif" style="vertical-align: middle;"> &nbsp; 
		 		<span style="vertical-align: middle; line-height: 100%;"><%=SystemEnv.getHtmlLabelName(19205, user.getLanguage())%></span> 
		 	</div>
		 	<div id="signid_0" style="">
		        <div style="width: 100%; margin: 0; padding: 0;" id="requestlogappednDiv"></div>
		        <input type="hidden" id="requestLogDataIsEnd<%%>" value="0">
		        <input type="hidden" id="requestLogDataMaxRquestLogId" value="0">
	    	</div>
		 </div>
	 </div>
	 
	 <div id="signall" style="position:relative;">
		<div id='WorkFlowLoddingDiv_<%%>' style="position:absolute;top:20px;display: none; text-align: center; width: 100%; height: 18px; overflow: hidden;"> <img src="/images/loading2_wev8.gif" style="vertical-align: middle;"> &nbsp; 
			<span style="vertical-align: middle; line-height: 100%;"><%=SystemEnv.getHtmlLabelName(19205, user.getLanguage())%></span> 
		</div>
	    <div id="signid_0">
	    
	    </div>
	    <%
		    int pageNo = 1;//当前页码
		    int pageSize = 5;//每页展示条数
		    int totalCount = 0; //获取评论的总信息条数
	    	sql = "select count(1) from uf_Reply where rqmodeid="+modeId+" and rqid="+billId+" and commentid=0";
	    	rs.executeSql(sql);
	    	if(rs.next()){
	    		totalCount = rs.getInt(1);
	    	}
		    int totalPages = (totalCount + pageSize - 1)/pageSize;//总共页数
		    if (totalPages == 0) {
		        totalPages = 1;
		    }
		%>
    	<div id="searchInfo_0">
		    <input type="hidden" id="totalCount" value="<%=totalCount%>"><!--总信息数-->
		    <input type="hidden" id="pageSize" value="<%=pageSize%>"><!--每页条数-->
		    <input type="hidden" id="totalPages" value="<%=totalPages%>"><!--总共页数-->
		    <input type="hidden" id="pagNo" value="<%=pageNo%>"><!--当前页码-->
		</div>
	 </div>
	 <!-- 加载更多 -->
	 <div class="moreFoot" >
	 <A hideFocus href="javascript:flipOver(2);">
     <EM class=ico_load></EM><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%><EM class="more_down"></EM>
     </A>
	 </div>
	 <br>
	 <div class="floating_ck" onClick="gotoTop();return false;">
		<dl>
	    	<dt></dt>
	        <dd class="return">
	        	<span style="color: #fff;"><%=SystemEnv.getHtmlLabelNames("1290,22432", user.getLanguage()) %></span>
	        </dd>
	    </dl>
	 </div>
	 <div style='display:none; padding-top: 1px;' class='pholder' id="pagesplitblock_0">
	    <div id="div_pager_0" class="fm_div_pager"></div>
	 </div>
  </body>
<script type="text/javascript">
var currentTabIndex = 0;
var totalPages = <%=totalPages%>;//总共页数
var totalCount = <%=totalCount %>;//总信息条数
var pageSize = <%=pageSize%>;//每页展示条数
var fmReplyConditionsHeight;
jQuery(document).ready(function() {
	formModeComDataLoadding();
});
function formModeComDataLoadding() {
	flipOver(-1);
}
function flipOver(sign, topage) {
	var currentpageInfoBlockid = "#searchInfo_" + currentTabIndex + " ";
	var pagNo = jQuery(currentpageInfoBlockid + "#pagNo").val();
	var totalPages = jQuery(currentpageInfoBlockid + "#totalPages").val();
	if (sign == -1 || sign == -2) { //初始加载
		pagNo = 1;
		if(pagNo > totalPages)
			return;
		initPaperChange(1);
	} else if (sign == 0) { //首页
		if (pagNo <= 1) {
			return;
		} else {
			pagNo = 1;
		}
		initPaperChange(pagNo);
	} else if (sign == 1) { //上一页
		if (pagNo <= 1) {
			return;
		} else {
			pagNo--;
		}
		initPaperChange(pagNo);
	} else if (sign == 2) { //下一页
		if (pagNo >= totalPages || totalPages <= 1) {
			return;
		} else {
			pagNo++;
		}
		initPaperChange(pagNo);
	} else if (sign == 3) { //尾页
		if (pagNo >= totalPages || totalPages <= 1) {
			return;
		} else {
			pagNo = totalPages;
		}
		initPaperChange(pagNo);
	} else if (sign == 4) {	//跳转
		var page = topage;
		if (page == "" || page.length == 0) {
			return;
		} else if (isNaN(page)) {
			return;
		} else if (page < 0 || page > totalPages) {
			return;
		} else {
			pagNo = page;
		}
		initPaperChange(topage);
	}
	
	showAllComment(sign,pagNo);
	
}
function initPaperChange(topage, totalPages2, totalCount2) {
	var totalPage = totalPages;
	var totalRecords = totalCount;
	var pageNo = <%=pageNo%>;
	if (!!totalPages2) {
		totalPage = totalPages2;
	}
	if (!!totalCount2) {
		totalRecords = totalCount2;
	}
	if (topage) pageNo = topage;

	if (!pageNo) {
		pageNo = 1;
	}
	//生成分页控件
	kkpager.init({
		isGoPage:true,
		pagerid: 'div_pager_' + currentTabIndex,
		pagesize:"" + pageSize,
		pno: pageNo,
		//总页码
		total: totalPage,
		//总数据条数
		totalRecords: totalRecords,
		//链接前部
		hrefFormer: 'pager_test',
		//链接尾部
		hrefLatter: '.html',
		getLink: function(n) {
			return this.hrefFormer + this.hrefLatter + "?pno=" + n;
		}
	});
	kkpager.generPageHtml();
	jQuery(".K13_select").unbind();
	jQuery(".K13_select_checked").find("input[class='_pageSizeInput']").remove();
	jQuery(".K13_select_checked").css("text-align","center").css("line-height","28px").css("cursor","default").append("<span><%=pageSize%></span>");
}
function showAllComment(sign,pagNo){
	var loadingTop = 0;
	var modeId = jQuery("#modeId").val();
	var billId = jQuery("#billId").val();
	var ajax = ajaxinit();
	if(sign!=-1){
		//jQuery("#searchInfo_0").html("");
		loadingTop = jQuery("#loading").css("top");
		jQuery("html,body").animate({scrollTop:jQuery("#signscrollfixed").offset().top-100}, 300);
		jQuery("#loading-msg").html("<%=SystemEnv.getHtmlLabelName(81558, user.getLanguage()) %>");
		jQuery("#loading").css("top",jQuery("#signscrollfixed").offset().top).show();
	}
	var currentsignBlockid = "#signid_" + currentTabIndex;
	var currentpageInfoBlockid = "#searchInfo_" + currentTabIndex + " ";
	var fmCommentContent = jQuery("#fmCommentContent").val();
	var fmCommentReplySdate = jQuery("#fmCommentReplySdate").val();
	var fmCommentReplyEdate = jQuery("#fmCommentReplyEdate").val();
	var fmCommentReplyor = jQuery("#fmCommentReplyor").val();
	var fmCommentFloorNum = jQuery("#fmCommentFloorNum").val();
	var fmParams = "modeId="+modeId+"&billId="+billId+"&pageSize="+pageSize+"&pagNo="+pagNo;
	fmParams+="&fmCommentContent="+fmCommentContent+"&fmCommentReplySdate="+fmCommentReplySdate+"&fmCommentReplyEdate="+fmCommentReplyEdate;
	fmParams+="&fmCommentReplyor="+fmCommentReplyor+"&fmCommentFloorNum="+fmCommentFloorNum;
	ajax.open("POST", "/formmode/view/formModeViewComMore.jsp", true);
	ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	ajax.send(fmParams);
	//获取执行状态
	ajax.onreadystatechange = function() {
		if (ajax.readyState == 4 && ajax.status == 200) {
			try {
				var tableStr = jQuery.trim(ajax.responseText);
				if(sign==2){
					jQuery(currentsignBlockid).append(tableStr);
				}else{
					jQuery(currentsignBlockid).html(tableStr);
				}
				jQuery(currentpageInfoBlockid + "#pagNo").val(pagNo);
				if(sign!=-1){
					jQuery("#loading").css("top",loadingTop).hide();
				}
				if(pagNo>=totalPages){
				    jQuery(".moreFoot").hide();
				}else{
					jQuery(".moreFoot").show();
				}
			} catch(e) {
				alert(e);
			}
		}
	}
}
function signtabchanges(tabindex){
	var ajax = ajaxinit();
	var fmCommentContent = jQuery("#fmCommentContent").val();
	var fmCommentReplySdate = jQuery("#fmCommentReplySdate").val();
	var fmCommentReplyEdate = jQuery("#fmCommentReplyEdate").val();
	var fmCommentReplyor = jQuery("#fmCommentReplyor").val();
	var fmCommentFloorNum = jQuery("#fmCommentFloorNum").val();
	var fmParams = "method=getPagingInfo&pageSize="+<%=pageSize%>+"&modeId="+jQuery("#modeId").val()+"&billId="+jQuery("#billId").val();
	fmParams+="&fmCommentContent="+fmCommentContent+"&fmCommentReplySdate="+fmCommentReplySdate+"&fmCommentReplyEdate="+fmCommentReplyEdate;
	fmParams+="&fmCommentReplyor="+fmCommentReplyor+"&fmCommentFloorNum="+fmCommentFloorNum;
	ajax.open("POST", "/formmode/view/formModeComOperation.jsp", true);
	ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	ajax.send(fmParams);
	ajax.onreadystatechange = function() {
		if (ajax.readyState == 4 && ajax.status == 200) {
			try {
				var pageinfo = jQuery.trim(ajax.responseText);
				pageinfo = pageinfo.split("_");
				totalCount = pageinfo[0];
				totalPages = pageinfo[1];
				jQuery("#totalCount").val(totalCount);
				jQuery("#totalPages").val(totalPages);
				if(tabindex==0){
					flipOver(-2);
				}
			} catch(e) {
				alert(e);
			}
		}
	}
}
jQuery(document).ready(function() {
   jQuery(".fmTbItmOver").hide(); 
   jQuery("#toolBarTbl").css("width",jQuery("#toolBarTbl").find(".fmTbItmOver").length*40+"px");
   jQuery(".fmReplyDoOver").hover(function(event){
	  $this=jQuery(this);	
	  var title = $this.attr("searchSignName"); 	
	  if(title == "showSearch"){
	     if(searchStatus == 0){
	       return;
	     }
	  }
	  var widthMark = $this.find("span:eq(1)").width()+50;
	  $this.find(".fmSearchImgSpan").hide();
	  $this.find(".fmTbItmOver").show();
	  $this.find(".fmTbItmOver").css("width",widthMark+"px");
	  $this.css("width",(widthMark-20)+"px")  		  	
	  $this.stop().animate({width:widthMark+"px"},'400',function(){});  	
   },function(event){
	  $this=jQuery(this);	
	  var title = $this.attr("searchSignName"); 	
	  if(title == "showSearch"){
	     if(searchStatus == 0){
	        return;
	     }
	  }
	  $this.stop().animate({width:'50px'},'400',function(){});	
	  $this.find(".fmTbItmOver").hide();
	  $this.find(".fmTbItmOver").css("width","25px");
	  $this.find(".fmSearchImgSpan").show();  
	}); 
});
function searchComment(){
	searchStatus=1;
	jQuery(document).find('.fmReplyDoOver span:eq(1)').trigger('mouseout');
	jQuery("#fmReplyConditions").hide();
	signtabchanges(0);
}
function cancelSearch(){
	searchStatus=1;
	jQuery(document).find('.fmReplyDoOver span:eq(1)').trigger('mouseout');
	jQuery("#fmReplyConditions").hide();
}
function toggleSearch(){
	if(searchStatus == 1 ){
    	searchStatus = 0;
    	if(typeof(fmReplyConditionsHeight)=="undefined"){
    		fmReplyConditionsHeight = jQuery("#fmReplyConditions").offset().top+100;
    	}
    	jQuery("html,body").animate({scrollTop:fmReplyConditionsHeight}, 300);
    	jQuery("#fmReplyConditions").show();
    }else{
	    searchStatus = 1;
		jQuery("#fmReplyConditions").hide();
    }
}
//清除搜索条件
function resetSearch(){
   jQuery("#fmCommentContent").val("");
   jQuery("#fmCommentReplySdate").val("");
   jQuery("#fmCommentReplySdateSpan").html("");
   jQuery("#fmCommentReplyEdate").val("");
   jQuery("#fmCommentReplyEdateSpan").html("");
   jQuery("#fmCommentReplyor").val("");
   jQuery("#fmCommentReplyorspan").html("");
   jQuery("#fmCommentFloorNum").val("");
}
function checkFloorNum(obj){
	if(obj.value!=""){
		if(!/^\+?[1-9][0-9]*$/.test(obj.value)){
			jQuery(obj).val("");
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82019,user.getLanguage())%>"); //输入值不符合正整数!
		}
	}
}
function opendoc(showid,docImagefileid){
    openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true");
}
function opendoc1(showid){
   openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=0");
}
</script>
</html>
