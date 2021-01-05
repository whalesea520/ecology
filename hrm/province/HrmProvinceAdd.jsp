<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<%
	if(!HrmUserVarify.checkUserRight("HrmProvinceAdd:Add", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(800,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String countryid = Util.null2String(request.getParameter("countryid"));
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				dialog.closeByHand();
				parentWin.location.reload();
			}
		 	function doSave(){
		    	if(check_form(document.frmMain,'provincename,countryid')){
				   	document.frmMain.submit();
		  		}
		 	}
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
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
		<FORM id=weaver name=frmMain action="ProvinceOperation.jsp" method=post >
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelNames("800,399",user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="true">
							<input class=InputStyle maxLength=30 size=30 name="provincename" onchange="checkinput('provincename','namespan')"><!--<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(27086,user.getLanguage())%></font>-->
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelNames("800,15767",user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="descspan" required="false">
							<input class=InputStyle maxLength=50 size=50 name="provincedesc"><!--<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(27087,user.getLanguage())%></font>-->
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelNames("33476,377",user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="countryid" browserValue='<%=countryid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp?type=1111" width="60%" browserSpanValue='<%=CountryComInfo.getCountrydesc(countryid)%>'>
							</brow:browser>
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>		
			<input class=inputstyle type="hidden" name="operation" value="add">
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
		});
	</script>
<%} %>
	</BODY>
</HTML>
