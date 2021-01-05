<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/hrm/area/areainit.jsp" %>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("HrmResourceSys:Mgr", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String isclose = "0" ;
	String isDialog = "1";
	
	String ids = Util.null2String(request.getParameter("ids")) ;
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelNames("20839,83511",user.getLanguage());
	
	RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
    String openPasswordLock = settings.getOpenPasswordLock();
 	String passwordComplexity = settings.getPasswordComplexity();
 	int minpasslen = settings.getMinPasslen() ;
	
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.getParentWindow(this);
			var dialog = parent.getDialog(this);
			if("<%=isclose%>"=="1"){
				parentWin.closeDialog();1
			}
			
		 	function doSave(event){
		 		if(check_form(document.frmMain,'password')){
					var ids = '<%=ids%>';
					var pwd = $('#password').val() ;
					
					if(pwd.length < <%=minpasslen %>){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20172,user.getLanguage())+minpasslen%>");
						return  ;
					}
					
					if(CheckPasswordComplexity(pwd)){
						$.ajax({
							"url":"/hrm/resource/HrmResourceSysOperation.jsp",
							"type":"post",
							"data":{ids:ids,pwd:pwd,method:"batchPasswordChange"},
							"dataType":"json",
							"success":function(data){
								if(data.code == '1'){
									window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125983,user.getLanguage())%>");
									parentWin.closeDialog();
									return ;
								}else{
									window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126200,user.getLanguage())%>");
									return ;
								}
							},
							"error" :function(){
								window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("468,127353",user.getLanguage())%>");
								return ;
							}
						});
					}
		 		}
		 	}


		 	function CheckPasswordComplexity(pwd)
		 	{
		 		var cs = pwd ;
		 		var checkpass = true;
		 		<%
		 		if("1".equals(passwordComplexity)){		
		 		%>
		 		var complexity11 = /[a-z]+/;
		 		var complexity12 = /[A-Z]+/;
		 		var complexity13 = /\d+/;
		 		if( cs!="" )
		 		{
		 			if(complexity11.test(cs)&&complexity12.test(cs)&&complexity13.test(cs))
		 			{
		 				checkpass = true;
		 			}
		 			else
		 			{
		 				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31863,user.getLanguage())%>");
		 				checkpass = false;
		 			}
		 		}
		 		<%
		 		}
		 		else if("2".equals(passwordComplexity))
		 		{
		 		%>
		 		var complexity21 = /[a-zA-Z_]+/;
		 		var complexity22 = /\W+/;
		 		var complexity23 = /\d+/;
		 		if(cs!="" )
		 		{
		 			if(complexity21.test(cs)&&complexity22.test(cs)&&complexity23.test(cs))
		 			{
		 				checkpass = true;
		 			}
		 			else
		 			{
		 				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83716,user.getLanguage())%>");
		 				checkpass = false;
		 			}
		 		}
		 		<%
		 		}
		 		%>
		 		return checkpass;
		 	}
		 	
		
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain method=post >
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="true">
							<input class=InputStyle type="password" maxLength=30 id="password" size=30 name="password" onchange="checkinput('password','namespan')" value="">
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>		
		</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.closeByHand();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);

			$('#password').val('');
		});
	</script>
<%} %>
	</BODY>
</HTML>
