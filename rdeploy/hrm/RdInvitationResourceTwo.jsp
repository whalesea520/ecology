<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
<link href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/rdeploy/hrm/js/jquery.zclip.js"></script>
<script type="text/javascript" src="/rdeploy/hrm/js/jquery.zclip.min.js"></script>
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
.copy-tips{position:fixed;z-index:999;bottom:50%;left:50%;margin:0 0 -50px -45px;background-color:rgba(0, 0, 0, 0.2);filter:progid:DXImageTransform.Microsoft.Gradient(startColorstr=#30000000, endColorstr=#30000000);padding:6px;}
.copy-tips-wrap{padding:10px 20px;text-align:center;border:1px solid #F4D9A6;background-color:#FFFDEE;font-size:14px;}
</style>

</head>

<%
String deptid= Util.null2String(request.getParameter("deptid"));
String reUrl = request.getRequestURL().toString();

String invUrl =reUrl.substring(0,reUrl.indexOf("hrm/RdInvitationResourceTwo.jsp"))+ "hrm/RdRegistResource.jsp?uid="+user.getUID()+"&lg="+user.getLanguage();
%>

<BODY>
<div class="e8_boxhead" style="visibility: visible;border-bottom: 1px solid #DADADA;">
					<div id="div_e8_xtree" class="div_e8_xtree"></div>
			        <div id="e8_tablogo" class="e8_tablogo" style="background-image: url(&quot;/js/tabs/images/nav/mnav2_wev8.png&quot;); margin-left: 6px;"></div>
					<div class="e8_ultab">
					<div id="e8_navtab" class="e8_navtab">
						<span id="objName" style="max-width: 1630px;"><%=SystemEnv.getHtmlLabelName(125246 ,user.getLanguage())%></span>
					</div>
				<div>
				
		    <ul class="tab_menu" style="width: 1288px;">
		     			
					
						
					<li class="defaultTab firstLi" imageidx="1" style="padding-left: 5px;" idx="0">
						<a onclick="javascript:void('0')" target="tabcontentframe" href="#" id="li_a_0" style="max-width: 1218px;">2015-07-28 16:09:36</a>
					<span class="e8_rightBorder" style="display: none;">|</span></li>
		        
		    <li class="magic-line" style="display: none;"></li></ul>
				    <div class="e8_outbox" style="visibility: visible; top: 20px;"><div class="e8_rightBox" id="rightBox" style="width: 354px; visibility: visible; position: absolute;"><div class="_box" id="tabcontentframe_box">
			<span class="cornerMenu middle" title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>"></span>
		</div></div></div>
			
	    		</div>
				</div>
			</div>
<div style="width: 100%;height: 502;padding-top: 135px;">
<div style="height: 100px;">
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
		 <div style="width: 525px;height: 28px;color:#b6b6b6; padding: 13px 0 0 20px;font-size: 13px;"><img  src="/rdeploy/assets/img/hrm/th.png" width="16px;" style="position: relative;top: 3px;margin-right: 8px;"/><%=SystemEnv.getHtmlLabelName(125243,user.getLanguage())%></div>
	   </div>
     </td>
   </tr>
</table>
 
</div>
<center>
  <div class="line" style="top: 0px;width: 520px;">
		    <a href="#none" class="copy-input" style="width: 240px;text-align: center;height: 40px;font-size: 16px;padding: 10px 40px 10px 40px;color: #487aee;top: 90px;border: 1px solid #b6b6b6;position: relative;left: 10px;"><%=SystemEnv.getHtmlLabelName(125244,user.getLanguage())%></a>
		    <input type="hidden" class="input" value="<%=invUrl %>" />
	</div>
</center>
<script language=javascript>

function back()
{
	window.history.back(-1);
}

$(function(){
/* 定义所有class为copy-input标签，点击后可复制class为input的文本 */
	$(".copy-input").zclip({
		path: "/rdeploy/hrm/js/ZeroClipboard.swf",
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

