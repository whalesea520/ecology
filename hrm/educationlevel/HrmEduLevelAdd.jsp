<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
if(!HrmUserVarify.checkUserRight("HrmEducationLevelAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(818,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="EduLevelOperation.jsp" method=post >
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(818,user.getLanguage()) + SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="namespan" required="true">
					<input class=inputstyle type=text maxlength="30" name="name" onchange="checkinput('name','namespan')">
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(818,user.getLanguage()) + SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="descriptionspan" required="true">
					<input class=inputstyle type=text maxlength="30" name="description" onchange="checkinput('description','descriptionspan')">
				</wea:required>
			</wea:item>
		</wea:group>
	</wea:layout>
	<input class=inputstyle type="hidden" name=operation value=add>
 </form>
   <%if("1".equals(isDialog)){ %>
   </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
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
<script language=javascript>  
function submitData() {
	if(check_form(frmMain,'name,description')){
		var ajax=ajaxinit();
		ajax.open("POST", "/hrm/educationlevel/EduLevelCheck.jsp", true);
		ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		ajax.send("saveType=add&name="+jQuery("input[name='name']").val());
		ajax.onreadystatechange = function() {
		if (ajax.readyState == 4 && ajax.status == 200) {
			try{
				if(ajax.responseText==1){
					frmMain.submit();
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("818,195,24943",user.getLanguage())%>");
					return false;
				}
			}catch(e){
				return false;
			}
		}
		}
	}
}
</script>
</BODY>
</HTML>
