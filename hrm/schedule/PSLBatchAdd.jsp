<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% 
if(!HrmUserVarify.checkUserRight("PSLBatch:All", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
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
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid") , -1) ; 
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String leavetype = Util.null2String(request.getParameter("leavetype"));
String sql = "select * from HrmPSLBatchProcess where subcompanyid = '" + subcompanyid + "' and leavetype ="+leavetype+" order by workingage desc";
RecordSet.executeSql(sql);
int workingage = 0;
if(RecordSet.next()){
   workingage = (int)RecordSet.getFloat("workingage")+1;
}

String imagefilename = "/images/hdMaintenance_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(131560,user.getLanguage()) + " : "+SystemEnv.getHtmlLabelName(365 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goback(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
if(msgid != -1) {
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid , user.getLanguage())%>
</font>
</DIV>
<%}%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=frmMain action=PSLBatchOperation.jsp method=post >
<input class=inputstyle type=hidden name=operation value="add">
<input class=inputsytle type=hidden name=subcompanyid value="<%=subcompanyid%>">
<input class=inputstyle type=hidden name=leavetype value="<%=leavetype%>">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15878,user.getLanguage())%></wea:item>
	  <wea:item> 
	    <input class=inputstyle size=4 type="text" id=workingage name=workingage value="<%=workingage%>" maxlength="5" onKeyPress="AllNumber_KeyPress()" onBlur='checkallnumber("workingage");checkinput("workingage","workingageimage")'>
	    <SPAN id=workingageimage></SPAN>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelNames("30523,496",user.getLanguage())%></wea:item>
	  <wea:item>
	     <input class=inputstyle size=4 type="text" id="PSLdays" name="PSLdays" maxlength="5" value="" onKeyPress="IsNumber_KeyPress()" onBlur='checkisnumber("PSLdays");checkinput("PSLdays","PSLdaysimage")'> 
	     <SPAN id=PSLdaysimage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>               
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
<Script language=javascript>
function checkvalue() {
	if(!check_form(frmMain,"workingage,PSLdays")) return false ;
	return true ;
}

function submitData() {
	if(checkvalue()) frmMain.submit();
}
function goback(){
    location="PSLBatchView.jsp?subcompanyid=<%=subcompanyid%>";
}
function AllNumber_KeyPress()
{
 if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57))))
  {
     window.event.keyCode=0;
  }
}
function IsNumber_KeyPress()
{
 if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57))||window.event.keyCode==46))
  {
     window.event.keyCode=0;
  }
}
function checkallnumber(objectname)
{
	valuechar = jQuery("#"+objectname).val().split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { 
	  charnumber = parseInt(valuechar[i]) ; 
	  if( isNaN(charnumber)) jQuery("#"+objectname).val("");
	}	 
}
function checkisnumber(objectname)
{
	valuechar = jQuery("#"+objectname).val().split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { 
	  charnumber = parseInt(valuechar[i]) ; 
	  if( isNaN(charnumber)&&valuechar[i]!='.') jQuery("#"+objectname).val("");
	}	 
}
</script>
</BODY>
</HTML>

