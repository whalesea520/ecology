<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/rdeploy/hrm/js/jquery.zclip.js"></script>
<style>
	.e8_os{
	  height:35px; 
	}
	.e8_innerShowContent{
	  height: 30px;
	  padding: 7px 0 0 7px;
	}
	
	.e8_spanFloat{
	  padding: 5px 0 0 0;
	}
	.e8_browflow{
		
	}
	.hover{
	 background-color: #4a78ee;
	 color: white!important;
	}
</style>
<style type="text/css">
.line{margin-bottom:20px;}
/* 复制提示 */
.copy-tips{position:fixed;z-index:999;bottom:50%;left:50%;margin:0 0 -10px -45px;background-color:rgba(0, 0, 0, 0.2);filter:progid:DXImageTransform.Microsoft.Gradient(startColorstr=#30000000, endColorstr=#30000000);padding:6px;}
.copy-tips-wrap{padding:10px 20px;text-align:center;border:1px solid #F4D9A6;background-color:#FFFDEE;font-size:14px;}
</style>

</head>

<%
String deptid= Util.null2String(request.getParameter("deptid"));
String reUrl = request.getRequestURL().toString();

String invUrl =reUrl.substring(0,reUrl.indexOf("hrm/RdInvitationResource.jsp"))+ "hrm/RdRegistResource.jsp?uid="+user.getUID()+"&lg="+user.getLanguage();
%>

<BODY>
<div style="height: 100px;padding-top: 35px;">
<table width="100%" height="">
  <tr>
    <td align="center" style="padding: 0 20px 10px 50px; color: #727F85;font-size: 15px;">
      <img  src="/rdeploy/assets/img/hrm/invit.png" width="70px;" />
    </td>
  </tr>
  <tr>
   <td align="center" style="padding: 0 20px 10px 50px; color: #536067;font-size: 15px;">
   	<%=SystemEnv.getHtmlLabelName(125242,user.getLanguage())%>
   </td>
 </tr>
   <tr>
     <td align="center">
      <div style="height: 100px;font-size: 14px; padding:15px 0 0 50px;color: #00aaff; "><%=invUrl %> </div>
     </td>
   </tr>
   <tr>
     <td align="center">
       <div style="padding: 10px 20px 10px 50px; ">
		 <div style="width: 525px;height: 28px;color:#b6b6b6; padding: 13px 0 0 20px;font-size: 13px;">
		 <img  src="/rdeploy/assets/img/hrm/th.png" width="16px;" style="position: relative;top: 3px;margin-right: 8px;"/><%=SystemEnv.getHtmlLabelName(125243,user.getLanguage())%></div>
	   </div>
     </td>
   </tr>
</table>
 
</div>
<center>
  <div class="line" style="top: 0px;width: 520px;">
		    <a href="#none" class="copy-input" style="width: 240px;text-align: center;height: 40px;font-size: 16px;padding: 10px 40px 10px 40px;color: #487aee;top: 90px;border: 1px solid #b6b6b6;position: relative;left: 10px; " ><%=SystemEnv.getHtmlLabelName(125244,user.getLanguage())%></a>
		    <input type="hidden" class="input" value="<%=invUrl %>" />
	</div>
</center>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" id="dosubmit" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="doSubmit()">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script language=javascript>
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);	



function doSubmit() {
   window.parent.Dialog.close();
}

function back()
{
	window.history.back(-1);
}

$(document).ready(function(){
/* 定义所有class为copy-input标签，点击后可复制class为input的文本 */
	$(".copy-input").zclip({
		path: "js/ZeroClipboard.swf",
		copy: function(){
		return $(this).parent().find(".input").val();
		},
		afterCopy:function(){/* 复制成功后的操作 */
			var $copysuc = $("<div class='copy-tips'><div class='copy-tips-wrap'><%=SystemEnv.getHtmlLabelName(125245,user.getLanguage())%></div></div>");
			$("body").find(".copy-tips").remove().end().append($copysuc);
			$(".copy-tips").fadeOut(3000);
        }
	});
});


</script>




</BODY></HTML>

