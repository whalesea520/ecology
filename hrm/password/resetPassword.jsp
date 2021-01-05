
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.*,weaver.hrm.common.*,weaver.hrm.settings.RemindSettings" %>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/systeminfo/nlinit.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<!-- Added by wcd 2014-12-22 [重置密码] -->
<%
	String isDialog = Tools.vString(request.getParameter("isdialog"),"1");
	String loginid = Tools.vString(request.getParameter("loginid"));
	int languageid = Util.getIntValue(request.getParameter("languageid"),7);
	String qid = Tools.vString(request.getParameter("qid"));
	String answer = Tools.vString(request.getParameter("answer"));
	String userid = Tools.vString(request.getParameter("userid"));
	String validatecode = Tools.vString(request.getParameter("validatecode"));
	String codeInp = Tools.vString(request.getParameter("answer"));
	String type = Tools.vString(request.getParameter("type"));
	
	
    String validateRand="",phoneCode="",emailCode="";
    validateRand=Util.null2String((String)request.getSession(true).getAttribute("validateRand"));
    phoneCode=Util.null2String((String)request.getSession(true).getAttribute("phoneCode"));
    emailCode=Util.null2String((String)request.getSession(true).getAttribute("emailCode"));
    
    if(!validateRand.toLowerCase().equals(validatecode.trim().toLowerCase()) || "".equals(validatecode.trim().toLowerCase()) ){
		out.println("system error!");
		return;
    }else{
		try {
		   request.getSession(true).removeAttribute("validateRand");
		}catch (Exception e) {
	  	}	
    }
    if("phoneCode".equals(type)){
	    if(!phoneCode.toLowerCase().equals(codeInp.trim().toLowerCase())){
			out.println("system error!");
			return;
	    }else{
			try {
			   request.getSession(true).removeAttribute("phoneCode");
			}catch (Exception e) {
		  	}	
	    }
    }
    if("emailCode".equals(type)){
	    if(!emailCode.toLowerCase().equals(codeInp.trim().toLowerCase())){
			out.println("system error!");
			return;
	    }else{
			try {
			   request.getSession(true).removeAttribute("emailCode");
			}catch (Exception e) {
		  	}	
	    }
    }
    
    if("".equals(type)){
		RecordSet rs = new RecordSet();
		//rs.executeSql("select 1 from hrm_protection_question where id="+qid+" and user_id="+userid+" and answer='"+answer+"'");
		rs.executeQuery("select 1 from hrm_protection_question where id=? and user_id=? and answer=?",qid,userid,answer);
		if(!rs.next()) response.sendRedirect("/hrm/password/passwordQuestion.jsp?languageid="+languageid+"&loginid="+loginid);
		if("".equals(answer)){
			response.sendRedirect("/hrm/password/passwordQuestion.jsp?languageid="+languageid+"&loginid="+loginid);
		}
    }
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(27002, languageid);
	String needfav ="1";
	String needhelp ="";
	RemindSettings settings = (RemindSettings)application.getAttribute("hrmsettings");
	int passwordComplexity = Tools.parseToInt(settings.getPasswordComplexity(),0);
	int minpasslen = settings.getMinPasslen();
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
			var passwordComplexity = Number("<%=passwordComplexity%>");
			var minpasslen = Number("<%=minpasslen%>");
			var loginid = "<%=loginid%>";
			var answer = "<%=answer%>";
			var qid = "<%=qid%>";
			var userid = "<%=userid%>";
			var type = "<%=type%>";
			
			function showmsg(mess,func) {
					var diag = new window.top.Dialog({
				        Width: 300,
				        Height: 80,
				        normalDialog:false,
				        Modal:true
				    });
					diag.Title = "<%=SystemEnv.getHtmlLabelName(15172, languageid)%>";
				    diag.CancelEvent = function () {
				        diag.close();
			        	if (func) func();
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
			
			function doSave(){
				var newpswd = $GetEle("newpswd").value;
				var cfmpswd = $GetEle("cfmpswd").value;
				if(!newpswd || !cfmpswd){
					showmsg("<%=SystemEnv.getHtmlLabelName(15859, languageid)%>");
					return;
				} else if(newpswd != cfmpswd){
					showmsg("<%=SystemEnv.getHtmlLabelName(125288, languageid)%>");
					return;
				} else if(newpswd.length < minpasslen){
					showmsg("<%=SystemEnv.getHtmlLabelName(125981, languageid)%>"+minpasslen+"！");
					return;
				}
				var checkpass = true;
				if(passwordComplexity == 1){
					var complexity11 = /[a-z]+/;
					var complexity12 = /[A-Z]+/;
					var complexity13 = /\d+/;
					if(complexity11.test(newpswd)&&complexity12.test(newpswd)&&complexity13.test(newpswd)){
						checkpass = true;
					} else {
					showmsg("<%=SystemEnv.getHtmlLabelName(31863, languageid)%>");
						$GetEle("newpswd").value = "";
						$GetEle("cfmpswd").value = "";
						checkpass = false;
					}
				} else if(passwordComplexity == 2){
					var complexity21 = /[a-zA-Z_]+/;
					var complexity22 = /\W+/;
					var complexity23 = /\d+/;
					if(complexity21.test(newpswd)&&complexity22.test(newpswd)&&complexity23.test(newpswd)){
						checkpass = true;
					} else {
						showmsg("<%=SystemEnv.getHtmlLabelName(83716, languageid)%>"); 
						$GetEle("newpswd").value = "";
						$GetEle("cfmpswd").value = "";
						checkpass = false;
					}
				}
				if(!checkpass){
					return;
				}
				if("" == type){
					var verifyQuestion = common.ajax("cmd=verifyQuestion&loginid="+loginid+"&qid="+qid+"&answer="+answer);
					if(!verifyQuestion || verifyQuestion=="false"){
						try{
							showmsg("<%=SystemEnv.getHtmlLabelName(125979, languageid)%>");
						}catch(e){
							alert("<%=SystemEnv.getHtmlLabelName(125982, languageid)%>"); 
							window.location = "/hrm/password/passwordQuestion.jsp?languageid=<%=languageid%>&loginid="+loginid;
						}
						return false;
					}
					var id = 0;
					common.ajax("cmd=forgotPasswordCheck&loginid=<%=loginid%>&randomstr="+randomString(6), false, function(result){
						result = jQuery.parseJSON(result);
						id = Number(result.id);
					});
					if(id == 0){
						showmsg("<%=SystemEnv.getHtmlLabelName(81617, languageid)%>");
						return;
					}
				}
				
				common.post({"cmd":"saveNewPassword","id":id,"loginid":"<%=loginid%>","newpswd":newpswd,"userid":userid,"qid":qid,"type":type});
				showmsg("<%=SystemEnv.getHtmlLabelName(125983, languageid)%>", function(){
					parentDialog.close();
				});
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
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, languageid)%>" class="e8_btn_top" style="margin-right:10px" onclick="doSave()">
				</td>
			</tr>
		</table>
		<form id="weaver" name="frmMain" action="" method="post">
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}" needLogin="false">
				<wea:group context="<%=SystemEnv.getHtmlLabelName(83511, languageid)%>" attributes="{'groupOperDisplay':'none'}"> 
					<wea:item><%=SystemEnv.getHtmlLabelName(27303, languageid)%></wea:item>
					<wea:item>
						<wea:required id="newpswdspan" required="true">
							<input type="password" class="InputStyle" name="newpswd" style="width:60%" autocomplete="off" onblur='checkinput("newpswd","newpswdspan")'>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(125285, languageid)%></wea:item>
					<wea:item>
						<wea:required id="cfmpswdspan" required="true">
							<input type="password" class="InputStyle" name="cfmpswd" style="width:60%" autocomplete="off" onblur='checkinput("cfmpswd","cfmpswdspan")'>
						</wea:required>
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
			
			if("" == type){
				var startverifyQuestion = common.ajax("cmd=verifyQuestion&loginid="+loginid+"&qid="+qid+"&answer="+answer);
				if(!startverifyQuestion || startverifyQuestion=="false"){
					window.location = "/hrm/password/passwordQuestion.jsp?languageid=<%=languageid%>&loginid="+loginid;
					return false;
				}
			}
			
		});
	</script>
<%} %>
	</BODY>
</HTML>