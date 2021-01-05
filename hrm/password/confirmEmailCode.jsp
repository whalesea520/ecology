<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.*,weaver.common.*,weaver.hrm.common.*" %>
<%@page import="weaver.common.StringUtil"%>
<%@ include file="/systeminfo/nlinit.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.hrm.passwordprotection.domain.HrmPasswordProtectionQuestion" %>
<jsp:useBean id="questionManager" class="weaver.hrm.passwordprotection.manager.HrmPasswordProtectionQuestionManager" scope="page"/>
<!-- [验证手机随机码] -->
<%
	String isDialog = Tools.vString(request.getParameter("isdialog"),"1");
	String loginid = Tools.vString(request.getParameter("loginid"));
	int languageid = Util.getIntValue(request.getParameter("languageid"),7);
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(83510, languageid);
	String needfav ="1";
	String needhelp ="";
	String validatecode = StringUtil.getURLDecode(request.getParameter("validatecode"));
	String result = Tools.vString(request.getParameter("result"));
	
    String validateRand="";
    validateRand=Util.null2String((String)request.getSession(true).getAttribute("validateRand"));
    String emailCode=Util.null2String((String)request.getSession(true).getAttribute("emailCode"));
    if(!validateRand.toLowerCase().equals(validatecode.trim().toLowerCase()) || "".equals(emailCode.trim().toLowerCase())){
		out.println("system error!");
		return;
    }
    
    int emailCodeSec = Constants.SessionSec;//邮箱验证码，一分钟过期
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
			var dialog;
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			var loginid = "<%=loginid%>";
			var languageid = "<%=languageid%>";
			var validatecode = "<%=validatecode%>";
			var result= "<%=result%>";
			var id;
			var mobile;
			var email;
			
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
			
			// 邮箱证码过期 
			var vNumber = Number("<%=emailCodeSec%>");
			jQuery(document).ready(function(){
				message = "<%=SystemEnv.getHtmlLabelName(128902, languageid)%>"+result+"<br/><%=SystemEnv.getHtmlLabelName(125973, languageid)%>";
				showmsg(message);
				pJob();
			})
			
			function pJob(){
				if(document.all("errorMessage")){
					document.all("errorMessage").innerHTML = "<%=SystemEnv.getHtmlLabelName(128903,languageid)+SystemEnv.getHtmlLabelName(81913,languageid)%>"+(vNumber--)+"<%=SystemEnv.getHtmlLabelName(81914,languageid)%>";
					if(vNumber <= 0){
						document.all("errorMessage").innerHTML = "<%=SystemEnv.getHtmlLabelName(132109, languageid)%>";
						jQuery("input[name=sendSmsBtn]").css({"display":"block"});
						clearTimeout("pJob()");
						//common.ajax("cmd=invalidateEmailCode&id="+id+"&loginid="+loginid+"&receiver="+"&validatecode="+validatecode);
						return;
					}
					setTimeout("pJob()",1000);
				}
			}
			
			function initParam(){
				id = 0;
				mobile = "";
				email = "";
			}
			
			var isclick = false;
			function doNext(){
				var emailCode = jQuery.trim(jQuery("input[name='answer']").val());
				if(!emailCode && emailCode == ""){
					showmsg("<%=SystemEnv.getHtmlLabelName(15859, languageid)%>");
					return false;
				}
				var result = common.ajax("cmd=checkEmailCode&id="+id+"&loginid="+loginid+"&validatecode="+validatecode+"&emailCode="+emailCode);
				
				if(result!=""){
					jQuery("input[name='loginid']").val(loginid);
					isclick = true;
					jQuery("#weaver").submit();
				}else{
					showmsg("<%=SystemEnv.getHtmlLabelName(128878, languageid)%>");
					return false;
				}
			}
			function sendSms(){
				var result = common.ajax("cmd=sendEmailCode&id="+id+"&loginid="+loginid+"&receiver="+"&validatecode="+validatecode);
				jQuery("input[name=sendSmsBtn]").css({"display":"none"});
				vNumber = Number("<%=emailCodeSec%>");
				pJob();
			}
			
			function dosubmit(){
				if(isclick){return true;}
				var answer = $GetEle("answer").value;
				if(!answer){
					showmsg("<%=SystemEnv.getHtmlLabelName(15859, languageid)%>");
					return false;
				}
				jQuery("input[name='loginid']").val(loginid);
				return true;
			}
		</script>
	</HEAD>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>su</td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(84110, languageid)%>" class="e8_btn_top" style="margin-right:10px" onclick="doNext()">
				</td>
			</tr>
		</table>
		<form id="weaver" name="frmMain" action="resetPassword.jsp" method="post" onsubmit="return dosubmit();">
			<input type="hidden" name="loginid"/> 
			<input type="hidden" name="userid"/> 
			<input type="hidden" name="type" value="emailCode"/> 
			<input type="hidden" name="languageid" value="<%=languageid %>"/> 
			<input type="hidden" name="validatecode" value="<%=validatecode %>"/> 
			
			<wea:layout type="2col" needLogin="false" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("128877,128904", languageid)%>' attributes="{'groupOperDisplay':'none'}">
					<wea:item><%=SystemEnv.getHtmlLabelName(128904, languageid)%></wea:item>
					<wea:item>
					<table style="width:100%">
							<tr>
								<td style="width:35%">
									<wea:required id="answerspan" required="true">
										<input type="text" class="InputStyle" name="answer" style="width:80%" onblur='checkinput("answer","answerspan")'>
									</wea:required>
								</td>
								<td style="width:35%;">
									<span name="errorMessage" id="errorMessage"></span>
								</td>
								<td style="width:15%;">
		    						<input type="button" value="<%=SystemEnv.getHtmlLabelName(125978, languageid)%>" name="sendSmsBtn" style="display:none;" class="e8_btn_top" onclick="sendSms();">
								</td>
							</tr>
						</table>
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
