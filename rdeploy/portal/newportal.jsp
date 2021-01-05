<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    
    /*用户验证*/
    User user = HrmUserVarify.getUser (request , response) ;
    if(user==null) {
        response.sendRedirect("/login/Login.jsp");
        return;
    }
  //门户编辑权限验证
    if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">
		
		<title></title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
	  	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
	  	<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
	  	
	  	<script type="text/javascript">
	  	var dialog = parent.getDialog(window);
		var parentWin = parent.getParentWindow(window);
	  	function cancle() {
			dialog.close();
	  	}
	  	
	  	function submit() {
	  		if ($("#infoname").val() == '') {
	  			window.top.Dialog.alert("请输入门户名称！");
	  			$("#infoname")[0].focus();
	  			return;
	  		}
	  		
	  		$("#btnSearch").attr("onclick", "");
	  		$("#btnClear").attr("onclick", "");
	  		
			$.ajax({
				url: "/rdeploy/portal/newPortalOperate.jsp?infoname=" + $("#infoname").val(),
		        contentType : "charset=UTF-8", 
		        type : "GET", 
		        error:function(ajaxrequest){
		        	dialog.close();
				}, 
		        success:function(content) {
		        	parentWin.location.reload();
		        	dialog.close();
				}
			});
	  	}
	  	
	  	</script>
	</head>

	<body style="margin:0px;padding:0px;overflow: hidden;">
		<div class="zDialog_div_content" style="position:absolute;bottom:48px;top:0px;width: 100%;">
			<table width="100%" height="100%" cellpadding="0px" cellspacing="0px" border="0px">
				<tr>
					<td valign="middle" align="center">
						<span style="font-size:12px;">
							<span style="color:#546266;">名称</span><span style="display:inline-block;width:12px;"></span>
							<input type="text" name="infoname" id="infoname" style="height:35px;width:265px;border:1px solid #d6dae0;">
							
						</span>
					</td>
				</tr>
			</table>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item type="toolbar">
						<input type="button" value="保存" id="btnSearch" class="zd_btn_cancle" onclick="submit();"/>
						<input type="button" value="取消" id="btnClear" class="zd_btn_cancle" onclick="cancle();"/>
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	</body>
</html>
