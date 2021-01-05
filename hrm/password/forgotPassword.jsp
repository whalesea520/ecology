
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
			
			function showmsg(mess) {
					var diag = new window.top.Dialog({
				        Width: 300,
				        Height: 80,
				        normalDialog:false,
				        Modal:true
				    });
					diag.Title = "<%=SystemEnv.getHtmlLabelName(15172, languageid)%>";
				    diag.CancelEvent = function () {
				        diag.close();
				    };
				    diag.InnerHtml = '<table height="100%" border="0" align="center" cellpadding="10" cellspacing="0">\
						<tr><td align="right"><img id="Icon_" src="' + IMAGESPATH + 'icon_alert_wev8.png" style="margin-right:10px;" width="26" height="26" align="absmiddle"></td>\
							<td align="left" id="Message_" style="font-size:9pt">' + mess + '</td></tr>\
					</table>';
					diag.ShowButtonRow=true;
					diag.normalDialog= false;
					diag.show();
			   	 	diag.getDialogDiv().style.zIndex = 99999;
			    	jQuery(diag.getContainer()).css("overflow-y","auto");
				    diag.okButton.style.display = "none";
				    diag.e8SepLine.style.display = "none";
				    diag.cancelButton.value = "<%=SystemEnv.getHtmlLabelName(826, languageid)%>";
				    diag.cancelButton.focus();
			}

			function initParam(){
				id = 0;
				mobile = "";
				email = "";
				qCount = 0;
				field001 = "";
				field002 = "";
			}
			
			function checkLoginIdNew(){
				checkLoginId();
				changeMsg(1);
			}
			
			function checkLoginId(){
				initParam();
				var loginid = $GetEle("loginid").value;
				if(!loginid){
					showmsg("<%=SystemEnv.getHtmlLabelName(15859, languageid)%>");
					return false;
				}
				var validatecode = $GetEle("validatecode").value;
				if(!validatecode || validatecode == '<%=SystemEnv.getHtmlLabelName(84270, languageid)%>'){
					showmsg("<%=SystemEnv.getHtmlLabelName(15859, languageid)%>");
					return false;
				}
				
				var type = Number($GetEle("type").value);
				resultmsg = "";
				common.ajax("cmd=forgotPasswordCheckMsg&loginid="+loginid+"&randomstr="+randomString(6)+"&type="+type+"&languageid="+languageid+"&validatecode="+validatecode, false, function(result){
					if(parseInt(result)){
						id = result;
					}else{
						resultmsg = result;
						if(resultmsg =="<%=SystemEnv.getHtmlLabelName(127829, languageid)%>"){
							$GetEle("loginid").value = "";
							$GetEle("validatecode").value = "";
						}
						showmsg(resultmsg);
						changeCode();
					}
					//result = jQuery.parseJSON(result);
					//id = Number(result.id);
					//mobile = result.mobile;
					//email = result.email;
					//field001 = result.field001;
					//field002 = result.field002;
					//qCount = Number(result.qCount);
				});
				if(id > 0){
				return true;
				}else{
				return false;
				}
			}
			
			function doNext(){	
				var isCheckLoginId = checkLoginId();
				if(!isCheckLoginId) return;
				var loginid = $GetEle("loginid").value;
				var validatecode = $GetEle("validatecode").value;
				if(validatecode =='<%=SystemEnv.getHtmlLabelName(84270, languageid)%>'){
					showmsg("<%=SystemEnv.getHtmlLabelName(15859, languageid)%>");
					return;
				}
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
				
				/*if(resultmsg.length != 0){
					Dialog.alert(resultmsg);
					resultmsg = "";
					return;
				}
				var isad = 0;
				$.ajaxSetup({async: false});
				$.post("/js/hrm/getdata.jsp",{cmd:"verifyIsADAccount",id:id},function(data){
					if(data.indexOf("1")>-1){
						Dialog.alert("<%=SystemEnv.getHtmlLabelNames("33268,126690", languageid)%>");
						isad = 1;
						//return;
					}
				},"JSON");*/
				
			if(id>0){
			//if(isad==0){
				switch (type){
					case 0:
						//发送短信
						var result = common.ajax("cmd=sendSMSCode&id="+id+"&loginid="+loginid+"&receiver="+"&validatecode="+validatecode);
						if(result!="" && result.indexOf("outoftime") < 0){
							window.location = "/hrm/password/confirmPhoneCode.jsp?languageid=<%=languageid%>&loginid="+loginid+"&validatecode="+validatecode+"&result="+result;
						} else if(result.indexOf("outoftime") == 0) {
							message = "<%=SystemEnv.getHtmlLabelName(130952, languageid)%>";
							showmsg(message);
						} else {
							message = "<%=SystemEnv.getHtmlLabelName(125974, languageid)%>";
							showmsg(message);
						}
						break;
					case 1:
						//密保问题
						var result = common.ajax("cmd=checkValicateCode&id="+id+"&loginid="+loginid+"&validatecode="+validatecode);
						if(result!=""){
							message = "<%=SystemEnv.getHtmlLabelName(125972, languageid)%>"+result+"<br/><%=SystemEnv.getHtmlLabelName(125973, languageid)%>"; 
							window.location = "/hrm/password/passwordQuestion.jsp?languageid=<%=languageid%>&loginid="+loginid+"&validatecode="+validatecode;
							break;
						} else {
							message = "<%=SystemEnv.getHtmlLabelNames("25645,27685", languageid)%>"+"!";
							showmsg(message);
							break;
						}
					case 2:
						//发送邮件
						var result = common.ajax("cmd=sendEmailCode&id="+id+"&loginid="+loginid+"&receiver="+"&validatecode="+validatecode);
						if(result!=""){
							window.location = "/hrm/password/confirmEmailCode.jsp?languageid=<%=languageid%>&loginid="+loginid+"&validatecode="+validatecode+"&result="+result;
						} else {
							message = "<%=SystemEnv.getHtmlLabelName(125974, languageid)%>";
							showmsg(message);
						}
						break;
					}
			}
				//$.ajaxSetup({async: true});
			}
			
			function changeMsg(msg)
			{
			    if(msg==0){
			        if(jQuery("input[name=validatecode]").val()=='<%=SystemEnv.getHtmlLabelName(84270, languageid)%>') 
			            jQuery("input[name=validatecode]").val('');
			    }else if(msg==1){
			        if(jQuery("input[name=validatecode]").val()=='') 
			            jQuery("input[name=validatecode]").val('<%=SystemEnv.getHtmlLabelName(84270, languageid)%>');
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
					<wea:item><%=SystemEnv.getHtmlLabelName(125976, languageid)%></wea:item>
					<wea:item>
						<select name="type" id="type" class="inputstyle" style="width:50%" onchange='checkinput("type","typespan")'>
							<%if(showSendSms){%><option value="0"><%=SystemEnv.getHtmlLabelName(125977, languageid)%></option><%}%>
							<option value="1"><%=SystemEnv.getHtmlLabelName(81605, languageid)%></option>
							<%if(showSendEmail){%><option value="2"><%=SystemEnv.getHtmlLabelName(125978, languageid)%></option><%}%>
						</select>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(20970, languageid)%></wea:item>
					<wea:item>
						<wea:required id="loginidspan" required="true">
							<input type="text" class="InputStyle" name="loginid" style="width:50%" maxLength=30 onchange='checkinput("loginid","loginidspan")' onblur="" onkeydown="if(event.keyCode==13)return false;">
						</wea:required>
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(22910, languageid)%></wea:item>
					<wea:item>
						<wea:required id="validatecodespan" required="true">
							<input type="text" class="InputStyle" name="validatecode" style="width:50%" size="15"  value="<%=SystemEnv.getHtmlLabelName(84270, languageid)%>" onchange='checkinput("validatecode","validatecodespan")' onfocus="changeMsg(0)" onblur="checkLoginIdNew()" onkeydown="if(event.keyCode==13)return false;">
						</wea:required>
						 <a href="javascript:changeCode()" id="imgCodeA" ><img  id="imgCode" border=0 align='absmiddle' style="height: 30px;" src='/weaver/weaver.file.MakeValidateCode?notneedvalidate=1'></a>
						<script>
					   	 var seriesnum_=0;
					  	 function changeCode(){
					  	 	seriesnum_++;
					  		setTimeout('$("#imgCode").attr("src", "/weaver/weaver.file.MakeValidateCode?notneedvalidate=1&seriesnum_="+seriesnum_)',50); 
					  	 }
					  	</script>
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
