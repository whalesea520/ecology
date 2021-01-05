<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*,weaver.hrm.common.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
 if(!HrmUserVarify.checkUserRight("HrmArrangeShift:Maintance", user)){
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
 }
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "rs" class = "weaver.conn.RecordSet" scope = "page"/>

<HTML><HEAD>
<LINK href = "/css/Weaver_wev8.css" type = text/css rel = STYLESHEET>
<SCRIPT language = "javascript" src = "/js/weaver_wev8.js"></script>
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
String _today = Tools.getCurrentDate();
String id = Util.null2String(request.getParameter("id")) ; 
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16255 , user.getLanguage()) + ":" +                                 SystemEnv.getHtmlLabelName(82 , user.getLanguage()) ; 

String needfav = "1" ;
String needhelp = "" ;  
boolean CanAdd =  HrmUserVarify.checkUserRight("HrmArrangeShift:Maintance" , user) ; 
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
			<%if(CanAdd){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id = weaver name=frmmain method=post action = "HrmArrangeShiftOperation.jsp">
<input class=inputstyle type = "hidden" name = "operation" value = "insertshift">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16255,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
    <wea:item>
        <input class=inputstyle type = "text" name = "shiftname" maxLength = 10 onchange = "checkinput('shiftname','shiftamespan')" size = 43 >
    	<span id="shiftamespan"><IMG src = '/images/BacoError_wev8.gif' align = absMiddle></span>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></wea:item>
    <wea:item>
    <button class = Clock type="button" onclick="onShowTime(shiftbegintimespan,shiftbegintime)"></button>
    <span id="shiftbegintimespan"></span>
    <input class=inputstyle type = hidden name ="shiftbegintime" value = "">
    </wea:item>     
    <wea:item><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></wea:item>
    <wea:item>
    <button class = Clock type="button" onclick = "onShowTime(shiftendtimespan,shiftendtime)"></button>
    <span id = "shiftendtimespan"></span>
    <input class=inputstyle type = hidden name = "shiftendtime" value = "">
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></wea:item>
   	<wea:item>
	    <button class = Clock type="button" onclick = "onHrmShowDate(validedatefromspan,validedatefrom)"></button>
	    <span id = "validedatefromspan"><%=_today%></span>
	    <input type = hidden name = "validedatefrom" value = "<%=_today%>">
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
	if(jQuery("input[name=shiftname]").val()!=""){
		weaver.submit();
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
	}
}
</script>
</body>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
