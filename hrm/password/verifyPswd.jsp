
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- Added by wcd 2014-11-19 [密码验证] -->
<%@ include file="/hrm/header.jsp" %>
<%
	String isDialog = Tools.vString(request.getParameter("isdialog"),"1");
	String checked = Tools.vString(request.getParameter("checked"));
	String isShow = Tools.vString(request.getParameter("isShow"));
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(81605,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/mfcommon_wev8.css" />
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script language="javascript">
			var common = new MFCommon();
			var parentWin = parent.getParentWindow(this);
			var parentDialog = parent.getDialog(this);
			
			function doNext(){
				if(check_form(document.frmMain,"pswd")){
					var pswd = $GetEle("pswd");
					var user = $GetEle("userId");
					common.post({"cmd":"verifyPswd", "id":user.value, "pswd":pswd.value}, function doSuccess(data){
						if(data.result == "false") {
							window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81608,user.getLanguage())%>", function(){
								pswd.value = "";
								pswd.focus();
								$GetEle("pswdspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>";
							});
							return false;
						}
						parentWin.showQuestion("close","<%=checked%>","<%=isShow%>");
					});
				}
			}
		</script>
	</HEAD>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<div>
			<form id="weaver" name="frmMain" action="" method="post">
				<input type="hidden" name="userId" value="<%=String.valueOf(user.getUID())%>">
				<div style="text-align:center;margin:auto;padding-top:35px">
					<%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%>
					<input type="password" class="InputStyle" id="pswd" name="pswd" style="width:60%" autocomplete="off" maxLength=30 onchange='checkinput("pswd","pswdspan")' onkeydown="if(event.keyCode==13){doNext();return false;}">
					<span id="pswdspan"><IMG src="/images/BacoError_wev8.gif" align="absMiddle"></span>
				</div>
			</form>
		</div>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(1402,user.getLanguage())%>" class="e8_btn_cancel" onclick="doNext();">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentWin.close('<%=isShow.equals("true") ? "-1" : "1"%>','<%=checked%>');">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
	</BODY>
</HTML>