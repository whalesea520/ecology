<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% if(!HrmUserVarify.checkUserRight("AnnualPeriod:All" , user)) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
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
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
int msgid = Util.getIntValue(request.getParameter("msgid") , -1) ; 
Calendar today = Calendar.getInstance() ; 
String currentyear = Util.add0(today.get(Calendar.YEAR) , 4) ; 
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" + 
				 Util.add0(today.get(Calendar.MONTH) + 1 , 2) + "-" + 
				 Util.add0(today.get(Calendar.DAY_OF_MONTH) , 2) ; 
RecordSet.executeSql("select * from hrmannualperiod where subcompanyid = " +subcompanyid+ " order by annualyear desc") ; 
if(RecordSet.next()) { 
	 currentyear = (Util.getIntValue(RecordSet.getString("annualyear"))+1)+"";
}

String imagefilename = "/images/hdMaintenance_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(445 , user.getLanguage()) + " : "+SystemEnv.getHtmlLabelName(365 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this);,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
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
<FORM id=frmMain action=AnnualPeriodOperation.jsp method=post >
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
<input class=inputstyle type=hidden name=operation value="add">
<input class=inputstyle type=hidden name=subcompanyid value="<%=subcompanyid%>">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></wea:item>
    <wea:item> 
      <input class=inputstyle id=annualyear name=annualyear value="<%=currentyear%>" maxlength="4" size=5 
			onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("annualyear");checkinput("annualyear","annualyearimage")'>
      <SPAN id=annualyearimage></SPAN>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(19548,user.getLanguage())%></wea:item>
    <wea:item><BUTTON class=Calendar type="button" id=selectstartdate onclick="onShowDate(startdatespan,startdate)"></BUTTON> 
            <SPAN id=startdatespan ><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN> 
            <input class=inputstyle type="hidden" name="startdate" value="">
    </wea:item> 
    <wea:item><%=SystemEnv.getHtmlLabelName(19547,user.getLanguage())%></wea:item>
    <wea:item><BUTTON class=Calendar type="button" id=selectenddate onclick="onShowDate(enddatespan,enddate)"></BUTTON> 
       <SPAN id=enddatespan ><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN> 
       <input class=inputstyle type="hidden" name="enddate" value="">
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
	if(!check_form(frmMain,"annualyear,startdate,enddate")) return false ;
	if(frmMain.annualyear.value.length != 4 ) {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(25,user.getLanguage())%>");
		return false;
	}
	if(new Date(frmMain.startdate.value)- new Date(frmMain.enddate.value)>0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("19547,27891,19548",user.getLanguage())%>");
		return false;
	}
	return true ;
}

function submitData(obj) {
	if(checkvalue()) {frmMain.submit();obj.disabled = true;}
}
function goback(){
    location="AnnualPeriodView.jsp?subcompanyid=<%=subcompanyid%>";
}
</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()></script>
</HTML>

