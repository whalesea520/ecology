
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%
  String labelid=Util.null2String(request.getAttribute("labelid"));
	if(labelid.isEmpty()){
		labelid = Util.null2String(request.getParameter("labelid"));
	}
	String msg = "";
	if(labelid.equals("999")){
		msg = "该文件格式不支持在线打开，请下载后查看！";
	}else{
	    msg = labelid;
	}
%>
<html>
  <head>
    <title>系统提醒</title>
    <script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
    <link type='text/css' rel='stylesheet'  href='/wui/theme/ecology7/skins/default/wui_wev8.css'/>
  </head>
<body style="margin:0px;padding:0px;">
<div style="width: 100%;position:absolute;margin-top: 10%" align="center" id="messageArea">
    <div style="width: 800px;font-family:微软雅黑;font-size:16px;height:247px;border:1px solid #e2e2e2;text-align:left;" align="center">
    <div style="float:left; ">
    	<div style=" height:80px; width:80px;background: url(/wui/common/page/images/error_left_wev8.png); margin-top:80px;margin-left:40px!important; margin-left:20px"></div>
    </div>
	<div style=" height:205px; border-left:solid 1px #e8e8e8; margin:20px;margin-top:22px; float:left; margin-left:40px;"></div>
	<div style="height:260px; width:610px; float:left; line-height:25px;">
		
			 <p id="msg" style="font-weight:normal;color:#fe9200;margin-top:85px">
	             <%=msg%>
             </p>
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
	
		<p style="color:#8f8f8f;">
			如有疑问请联系系统管理员。</p>
		</div>
    </div>
    
</div>
</body>
</html>    
  
