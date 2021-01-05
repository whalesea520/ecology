<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/hrm/area/areainit.jsp" %>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String cityid = Util.null2String(request.getParameter("cityid"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String cityname = Util.null2String((String)session.getAttribute("cityname"));
String citylongitude = Util.null2String((String)session.getAttribute("citylongitude"));
String citylatitude = Util.null2String((String)session.getAttribute("citylatitude"));
session.removeAttribute("cityname");
session.removeAttribute("citylongitude");
session.removeAttribute("citylatitude");
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
	var parentWin = parent.parent.getParentWindow(parent);
	var dialog = parent.parent.getDialog(parent);
	if("<%=isclose%>"=="1"){
		parentWin.closeDialog();
	}
 	function doSave(){
    	if(check_form(document.frmMain,'cityname,cityid')){
		   	document.frmMain.submit();
  		}
 	}
</script>
</head>
<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(25223,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY >
<%if("1".equals(isDialog)){ %>
	<div class="zDialog_div_content" style="">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%if(msgid!=-1){%>
		<script type="text/javascript">
		window.top.Dialog.alert('<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage()).replace(SystemEnv.getHtmlLabelName(377,user.getLanguage())+SystemEnv.getHtmlLabelName(399,user.getLanguage()),SystemEnv.getHtmlLabelName(195,user.getLanguage()))%>');
		</script>
		<%}%>
<FORM id=weaver name=frmMain action="CityOperationTwo.jsp" method=post >
	<input class=inputstyle type="hidden" name=operation value=add>
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(25223,user.getLanguage())%></wea:item>
			<wea:item><input class=inputstyle type=text size=30 name="cityname" onchange='checkinput("cityname","citynameimage")' value="<%=cityname %>">
			<SPAN id=citynameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(801,user.getLanguage())%></wea:item>
			<wea:item><input class=inputstyle type=text size=30 name="citylongitude" onKeyPress="ItemNum_KeyPress()" onchange='checknumber1(this) ; ' value="<%=citylongitude %>">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(802,user.getLanguage())%></wea:item>
			<wea:item><input class=inputstyle type=text size=30 name="citylatitude" onKeyPress="ItemNum_KeyPress()" onchange='checknumber1(this) ;' value="<%=citylatitude %>">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
			<wea:item>
			   <div areaType="city" areaName="cityid" areaValue="<%=Util.toScreenToEdit(cityid,user.getLanguage())%>" 
			  areaSpanValue="<%=Util.formatMultiLang(CityComInfo.getCityname(Util.null2String(cityid)),user.getLanguage()+"")%>"  areaMustInput="2"  areaCallback="" id="_areaselect_cityid" class="_areaselect" ></div>
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
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.closeByHand();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			areromancedivbyid("_areaselect_cityid");
			checkinput("cityname","citynameimage");
		});
	</script>
<%} %>
<script language=javascript>  
function submitData() {
 if(check_form(frmMain,'cityname,cityid')){
 frmMain.submit();
 }
}
</script>
</BODY>
</HTML>
