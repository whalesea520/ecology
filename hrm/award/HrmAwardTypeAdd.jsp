<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% if(!HrmUserVarify.checkUserRight("HrmRewardsTypeAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(6099,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/award/HrmAwardType.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
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
<FORM name="frmMain" id="frmMain" action="HrmAwardTypeOperation.jsp" method=post >
<input class=inputstyle type=hidden name=operation value="add">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(6099,user.getLanguage())%>'>
    <wea:item><%=SystemEnv.getHtmlLabelName(15666,user.getLanguage())%></wea:item>
    <wea:item> 
      <INPUT class=InputStyle maxLength=60 style="WIDTH: 90%" name="name" onchange='checkinput("name","namespan")'>
      <SPAN id=namespan><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN> 
    </wea:item> 
    <wea:item><%=SystemEnv.getHtmlLabelName(808,user.getLanguage())%></wea:item>
    <wea:item> 
      <select class=InputStyle name=awardtype value="0">
        <option value="0"><%=SystemEnv.getHtmlLabelName(809,user.getLanguage())%></option>
        <option value="1"><%=SystemEnv.getHtmlLabelName(810,user.getLanguage())%></option>
      </select>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15667,user.getLanguage())%></wea:item>
    <wea:item> 
     <textarea class=InputStyle style="WIDTH: 90%" name="description" rows=6></textarea>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15432,user.getLanguage())%></wea:item>
    <wea:item>
      <textarea class=InputStyle style="WIDTH: 90%" name="transact" rows=6></textarea>
    </wea:item>
	</wea:group>
</wea:layout>
</FORM>
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
 var maxlength= 100;
 if(check_form(frmMain,'name')&&checkTextLength(frmMain.description,maxlength)&&checkTextLength(frmMain.transact,maxlength)){
 frmMain.submit();
 }
}

function checkTextLength(textObj,maxlength){
    var len = trim(jQuery(textObj).html()).length
    if(len >  maxlength){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83448,user.getLanguage())%>"+maxlength);
        return false;
    }
    return true;
  }
 /**
 * trim function ,add by Huang Yu
 */
 function trim(value) {
   var temp = value;
   
   var obj = /^(\s*)([\W\w]*)(\b\s*$)/;
   if (obj.test(temp)) { temp = temp.replace(obj, '$2'); }
   return temp;
}


</script>
</BODY>
</HTML>
