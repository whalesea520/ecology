
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%
	int labelid=Util.getIntValue(((String)request.getAttribute("labelid")==null?request.getParameter("labelid"):(String)request.getAttribute("labelid")),0);
%>
<html>
  <head>
    <title>系统提醒</title>
    <script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
    <link type='text/css' rel='stylesheet'  href='/wui/theme/ecology7/skins/default/wui_wev8.css'/>
	
	<script type="text/javascript">
	 function finalDo(){
		var loading = top.document.getElementById('loading');
		if(loading){
			try{
					top.document.getElementById('loading').style.display="none";
					//top.finalDo("view");
			}catch(e){
				alert(e);
			}
		}else{
			window.setTimeout(function(){finalDo()},200);
		}
	}
		jQuery(top.document).ready(function(){
			finalDo();
		});
	</script>
  </head>
<body style="margin:0px;padding:0px;">
<div style="width: 100%;position:absolute;margin-top: 10%" align="center" id="messageArea">
	<div style="width: 800px;font-family:微软雅黑;font-size:16px;height:247px;border:1px solid #e2e2e2;text-align:left;" align="center">
		<div style="float:left; ">
			<div style=" height:80px; width:80px;background: url(/wui/common/page/images/error_left_wev8.png); margin-top:80px;margin-left:40px!important; margin-left:20px"></div>
		</div>
		<div style=" height:205px; border-left:solid 1px #e8e8e8; margin:20px;margin-top:22px; float:left; margin-left:40px;"></div>
		<div style="height:260px; width:610px; float:left; line-height:25px;">
			<%if(labelid == 999){%>
				<p style="color:#fe9200;margin-top:60px">
					文件过大，暂不支持在线预览！
				</p>
				<p style="color:#8f8f8f;">
					我们正在努力的寻求解决方案，
					使其能支持更大文件的在线预览，给您造成的不便敬请谅解。
				</p>
			<%}%>
			<p style="color:#8f8f8f;">
				如有疑问请联系系统管理员。
			</p>
		</div>
	</div>
</div>
</body>
</html>    
  
