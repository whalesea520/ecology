
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.*,weaver.common.*,weaver.hrm.common.*" %>
<%@ include file="/systeminfo/nlinit.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<!-- Added by wcd 2014-12-18 [找回密码] -->
<%
	String isDialog = Tools.vString(request.getParameter("isdialog"),"1");
	int languageid = Util.getIntValue(request.getParameter("languageid"),7);
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(83510, languageid);
	String needfav ="1";
	String needhelp ="";
	
	boolean showSendSms = MessageUtil.checkSendSMS();
	boolean showSendEmail = MessageUtil.checkSendEmail();
%>
<HTML>
	<HEAD>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/mfcommon_wev8.css" />
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_7_wev8.js"></script>
		<script language="javascript">
			var common = new MFCommon();
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			
			var id;
			var mobile;
			var email;
			var qCount;
			var field001;
			var field002;
			var languageid = "<%=languageid%>";
			
			function initParam(){
				id = 0;
				mobile = "";
				email = "";
				qCount = 0;
				field001 = "";
				field002 = "";
			}
			
			function checkLoginId(){
				initParam();
				var loginid = $GetEle("loginid").value;
				if(!loginid){
					Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, languageid)%>");
					return;
				}
				var type = Number($GetEle("type").value);
				resultmsg = "";
				common.ajax("cmd=forgotPasswordCheckMsg&loginid="+loginid+"&randomstr="+randomString(6)+"&type="+type+"&languageid="+languageid, false, function(result){
					if(parseInt(result)){
						id = result;
					}else{
						resultmsg = result;
						if(resultmsg =="<%=SystemEnv.getHtmlLabelName(81617, languageid)%>"){
							$GetEle("loginid").value = "";
						}
						Dialog.alert(resultmsg);
					}
					//result = jQuery.parseJSON(result);
					//id = Number(result.id);
					//mobile = result.mobile;
					//email = result.email;
					//field001 = result.field001;
					//field002 = result.field002;
					//qCount = Number(result.qCount);
				});
			}
			
			function doNext(){	
				checkLoginId();
				var loginid = $GetEle("loginid").value;
				var type = Number($GetEle("type").value);
				var message = "";
				//if(!loginid || id == 0){
				//	message = "未找到帐号，请重新输入！";
				//	$GetEle("loginid").value = "";
				//} else {
				//	if(type == 0 && mobile == ""){
				//		message = "帐号未设置手机号，请选择其他找回方式！";
				//	} else if(type == 1 && qCount == 0){
				//		message = "帐号未设置密保问题，请选择其他找回方式！";
				//	} else if(type == 2 && email == ""){
				//		message = "帐号未设置电子邮件，请选择其他找回方式！";
				//	}
				//}
				if(resultmsg.length != 0){
					Dialog.alert(resultmsg);
					resultmsg = "";
					return;
				}
				switch (type){
					case 0:
						//发送短信
						var result = common.ajax("cmd=sendSMS&id="+id+"&loginid="+loginid+"&receiver=");
						if(result!=""){
							message = "<%=SystemEnv.getHtmlLabelName(125972, languageid)%>"+result+"<br/><%=SystemEnv.getHtmlLabelName(125973, languageid)%>"; 
						} else {
							message = "<%=SystemEnv.getHtmlLabelName(125974, languageid)%>";
						}
						Dialog.alert(message);
						break;
					case 1:
						//密保问题
						window.location = "/hrm/password/passwordQuestion.jsp?languageid=<%=languageid%>&loginid="+loginid;
						break;
					case 2:
						//发送邮件
						var result = common.ajax("cmd=sendEmail&id="+id+"&loginid="+loginid+"&receiver=");
						if(result!=""){
							message = "<%=SystemEnv.getHtmlLabelName(125975, languageid)%>"+result+"<br/><%=SystemEnv.getHtmlLabelName(125973, languageid)%>";
						} else {
							message = "<%=SystemEnv.getHtmlLabelName(125974, languageid)%>";
						}
						Dialog.alert(message);
						break;
				}
			}
		</script>
	</HEAD>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(125248, languageid)%>" class="e8_btn_top" style="margin-right:10px" onclick="doNext()">
				</td>
			</tr>
		</table>
		<form id="weaver" name="frmMain" action="" method="post">
			<wea:layout type="2col" needLogin="false" attributes="{'expandAllGroup':'true'}">
				<wea:group context="<%=SystemEnv.getHtmlLabelName(1361, languageid)%>" attributes="{'groupOperDisplay':'none'}">
					<wea:item><%=SystemEnv.getHtmlLabelName(20970, languageid)%></wea:item>
					<wea:item>
						<wea:required id="loginidspan" required="true">
							<input type="text" class="InputStyle" name="loginid" style="width:50%" maxLength=30 onchange='checkinput("loginid","loginidspan")' onblur="checkLoginId();" onkeydown="if(event.keyCode==13)return false;">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(125976, languageid)%></wea:item>
					<wea:item>
						<select name="type" id="type" class="inputstyle" style="width:50%" onchange='checkinput("type","typespan")'>
							<%if(showSendSms){%><option value="0"><%=SystemEnv.getHtmlLabelName(125977, languageid)%></option><%}%>
							<option value="1"><%=SystemEnv.getHtmlLabelName(81605, languageid)%></option>
							<%if(showSendEmail){%><option value="2"><%=SystemEnv.getHtmlLabelName(125978, languageid)%></option><%}%>
						</select>
					</wea:item>
				</wea:group>
			</wea:layout>
		</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col" needLogin="false">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, languageid)%>" class="e8_btn_cancel" onclick="parentDialog.close();">
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