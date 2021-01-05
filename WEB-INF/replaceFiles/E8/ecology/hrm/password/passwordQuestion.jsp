
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.*,weaver.common.*,weaver.hrm.common.*" %>
<%@ include file="/systeminfo/nlinit.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.hrm.passwordprotection.domain.HrmPasswordProtectionQuestion" %>
<jsp:useBean id="questionManager" class="weaver.hrm.passwordprotection.manager.HrmPasswordProtectionQuestionManager" scope="page"/>
<!-- Added by wcd 2014-12-19 [找回密码] -->
<%
	String isDialog = Tools.vString(request.getParameter("isdialog"),"1");
	String loginid = Tools.vString(request.getParameter("loginid"));
	int languageid = Util.getIntValue(request.getParameter("languageid"),7);
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(83510, languageid);
	String needfav ="1";
	String needhelp ="";
	
	boolean showSendSms = MessageUtil.checkSendSMS();
	boolean showSendEmail = MessageUtil.checkSendEmail();
	
	Map map = new HashMap();
	map.put("sql_userId", "and t.user_id in (select id from "+AjaxManager.getData(loginid, "getTResourceName;HrmResource")+" where loginid = '"+loginid+"') ");
	map.put("sqlorderby","t.id asc");
	List list = questionManager.find(map);
	int qSize = list == null ? 0 : list.size();
	HrmPasswordProtectionQuestion question = list == null ? null : (HrmPasswordProtectionQuestion)list.get(weaver.common.StringUtil.random(qSize, 0));
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
			var qid = "<%= question == null ? 0 : question.getId()%>";
			var id;
			var mobile;
			var email;
			
			function initParam(){
				id = 0;
				mobile = "";
				email = "";
			}
			
			function checkLoginId(){
				initParam();
				var type = Number($GetEle("type").value);
				resultmsg = "";
				var result = eval(common.ajax("cmd=forgotPasswordCheckMsg&loginid="+loginid+"&type="+type+"&languageid="+languageid));
				//if(result && result.length>0){
				//	for(var i=0;i<result.length;i++){
				//		id = Number(result[i].id);
				//		mobile = result[i].mobile;
				//		email = result[i].email;
				//	}
				//}
				if(parseInt(result)){
					id = result;
				}else{
					resultmsg = result;
					Dialog.alert(resultmsg);
				}
			}
			
			function otherVerify(){	
				checkLoginId();
				var type = Number($GetEle("type").value);
				var message = "";
				//if(id == 0){
				//	message = "未找到帐号，请重新输入！";
				//} else {
				//	if(type == 0 && mobile == ""){
				//		message = "帐号未设置手机号，请选择其他找回方式！";
				//	} else if(type == 2 && email == ""){
				//		message = "帐号未设置电子邮件，请选择其他找回方式！";
				//	}
				//}
				if(resultmsg.length != 0){
					Dialog.alert(resultmsg);
					return;
				}
				
			//var tempMobile = mobile;
			//if(mobile.length-4 > 0){
			//	tempMobile = mobile.substring(0, mobile.length-4);
			//}
			//tempMobile += "****";
			//
			//var tempEmail = "****";
			//var tempEmailArray = email.split("@");
			//if(tempEmailArray.length == 2){
			//	tempEmail = tempEmailArray[0];
			//	
			//	if(tempEmail.length-4 > 0){
			//		tempEmail = tempEmail.substring(0, tempEmail.length-4);
			//	}
			//	tempEmail += "****";
			//	tempEmail += "@" + tempEmailArray[1];
			//}
				
				switch (type){
					case 0:
						var result = common.ajax("cmd=sendSMS&id="+id+"&loginid="+loginid+"&receiver=");
						if(result!=""){
							message = "<%=SystemEnv.getHtmlLabelName(125972, languageid)%>"+result+"<br/><%=SystemEnv.getHtmlLabelName(125973, languageid)%>";
						} else {
							message = "<%=SystemEnv.getHtmlLabelName(125974, languageid)%>";
						}
						Dialog.alert(message);
						break;
					case 2:
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
			
			function doNext(){
				var answer = $GetEle("answer").value;
				if(!answer){
					Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, languageid)%>");
					return false;
				}
				var type = $GetEle("type").value;
				var result = common.ajax("cmd=verifyQuestion&loginid="+loginid+"&qid="+qid+"&answer="+answer);
				if(!result || result=="false"){
					Dialog.alert("<%=SystemEnv.getHtmlLabelName(125979, languageid)%>"+(type == "1" ? "<%=SystemEnv.getHtmlLabelName(125980, languageid)%>" : ""));
					return false;
				}
//				parentWin.resetPassword(loginid);
				jQuery("input[name='qid']").val(qid);
				jQuery("input[name='loginid']").val(loginid);
				jQuery("input[name='userid']").val(result);
				jQuery("#weaver").submit();
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
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(84110, languageid)%>" class="e8_btn_top" style="margin-right:10px" onclick="doNext()">
				</td>
			</tr>
		</table>
		<form id="weaver" name="frmMain" action="resetPassword.jsp" method="post">
			<input type="hidden" name="qid"/> 
			<input type="hidden" name="loginid"/> 
			<input type="hidden" name="userid"/> 
			<input type="hidden" name="languageid" value="<%=languageid %>"/> 
			
			<wea:layout type="2col" needLogin="false" attributes="{'expandAllGroup':'true'}">
				<wea:group context="<%=SystemEnv.getHtmlLabelName(81605, languageid)%>" attributes="{'groupOperDisplay':'none'}">
					<wea:item><%=SystemEnv.getHtmlLabelName(24419, languageid)%>1</wea:item>
					<wea:item>
						<table style="width:100%">
							<tr>
								<td style="width:55%"><%= question == null ? "" : question.getQuestion()%>&nbsp;</td>
								<td style="width:45%;">
									<input type="button" class="e8_btn_top" style="margin-left:0px" value="<%=SystemEnv.getHtmlLabelName(81620, languageid)%>" onclick="window.location.reload()">
								</td>
							</tr>
						</table>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(24122, languageid)%></wea:item>
					<wea:item>
						<table style="width:100%">
							<tr>
								<td style="width:55%">
									<wea:required id="answerspan" required="true">
										<input type="text" class="InputStyle" name="answer" style="width:80%" onblur='checkinput("answer","answerspan")'>
									</wea:required>
								</td>
								<td style="width:45%;">
									<select name="type" id="type" class="inputstyle" style="width:90%;" onchange="otherVerify();">
										<option value="1"><%=SystemEnv.getHtmlLabelName(81621, languageid)%></option>
										<%if(showSendSms){%><option value="0"><%=SystemEnv.getHtmlLabelName(125977, languageid)%></option><%}%>
										<%if(showSendEmail){%><option value="2"><%=SystemEnv.getHtmlLabelName(125978, languageid)%></option><%}%>
									</select>
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