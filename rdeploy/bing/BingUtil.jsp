<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.mobile.ding.MobileDing"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.mobile.ding.DingReply"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<script>

var BingUtils = {
	showStatusDetail: function(dingid,from){
		var detailUrl="/rdeploy/bing/BingConfirmStatus.jsp?dingid="+dingid;
		if(from=="chat"){
			var title="<%=SystemEnv.getHtmlLabelName(127007, user.getLanguage())%>";  //确认详情
		    var url=detailUrl;
			var diag=BingUtils.getPopDialog(title,500,450);
			diag.URL =url+"&from=chat";
			diag.show();
		}else{
			$("#statusDetail").css("display", "block").animate({
				'width': '350px'
			}, 400, function(){
				$(document).bind('click.statusdivhide', function(e){
					closeStatusBox();
				});
			})
		}
		BingUtils.stopEvent();
	},
	doReply: function(obj){
		var content=$(obj).val();
		if($.trim(content) == ''){
			return;
		}
		content=content.replace(/\r\n/g,"<br>").replace(/\n/g, '<br>');
		var dingid=$(obj).attr("_dingid");
		$.post("/rdeploy/bing/BingOperation.jsp?operation=doReply",{"dingid":dingid,"content":content},function(data){
			data=eval("("+$.trim(data)+")");
			var replayitem=$("#breplyitemTemp").clone().attr("id","").show();
			replayitem.find(".targetHead").attr("src",data.imageurl);
			replayitem.find(".breplytime").html(data.username+"&nbsp;"+data.createtime);
			replayitem.find(".breplycontent").html(data.content);
			$("#detail_"+dingid+" .nodata").remove();
			$("#detail_"+dingid+" .breplyList").append(replayitem);
			$(obj).val("").focus();
		});
	},
	
	enterReply: function(obj,event){
		event = event || window.event;
		var keynum;
		if(window.event)
	      		keynum=event.keyCode;
	       else
	           keynum=event.which;
	           
	       if(keynum!=13&&keynum!=10) return;
	           
		if(event.shiftKey&&(keynum==13||keynum==10)){
			
		}else{
			if(keynum==13||keynum==10){
				console.log("event.ctrlKey:"+event.ctrlKey);
				if(event.ctrlKey){
					//event.keyCode=13;
					$("#replycontent").val($("#replycontent").val()+"\n");
					return false;
				}else{
					event.keyCode = 0;//屏蔽回车键
					event.returnvalue = false; 
					BingUtils.stopEvent();
					BingUtils.doReply(obj);
					return false;
				}
			}
		}
		return true;
	},
	 //阻止事件冒泡
	stopEvent: function() {
		if (event.stopPropagation) { 
			// this code is for Mozilla and Opera 
			event.stopPropagation();
		} 
		else if (window.event) { 
			// this code is for IE 
			window.event.cancelBubble = true; 
		}
		return false;
	},
	
	getPopDialog: function(title,width,height){
	    var diag =new window.top.Dialog();
	    diag.currentWindow = window; 
	    diag.Modal = true;
	    diag.Drag=true;
		diag.Width =width?width:680;	
		diag.Height =height?height:420;
		diag.ShowButtonRow=false;
		diag.Title = title;
		return diag;
	}
};

</script>
