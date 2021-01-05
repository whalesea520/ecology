<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<% 
	if(!HrmUserVarify.checkUserRight("FnaCurrencyExchangeAdd:Add",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
	String id = Util.null2String(request.getParameter("id"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	RecordSet.executeProc("FnaCurrency_SelectByDefault","");
	RecordSet.next() ;
	String defaultcurrencyid = RecordSet.getString("id") ;
	String defaultcurrencyname = RecordSet.getString("currencyname") ;
	String currencyname = Util.toScreen(CurrencyComInfo.getCurrencyname(id),user.getLanguage()) ;
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(406,user.getLanguage())+" : "+ currencyname ;
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			<%if(msgid!=-1){%>
				window.top.Dialog.alert('<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>');
			<%}%>
		
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.id = "<%=id%>";
				parentWin.closeDialog();	
			}			
			function doSave() {
				if(check_form(document.frmMain,"fnayear,periodsid,avgexchangerate,endexchangerage")){
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
		<FORM id=frmMain name=frmMain action="FnaCurrenciesOperation.jsp" method=post >
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<select style="width:90px" name="fnayear">
							<%
							RecordSet.executeProc("FnaYearsPeriods_Select","");
							while(RecordSet.next()) {
								String fnayear = RecordSet.getString("fnayear") ;
							%>
								<option value="<%=fnayear%>"><%=fnayear%></option>
							<%}%>
							</select>
						</span>
						<span style="padding-left:10px">
							<img src="/wechat/images/remind_wev8.png" align="absMiddle" id="crmImg" title="<%=SystemEnv.getHtmlLabelName(33479,user.getLanguage())%>" />
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<select style="width:90px" id=periodsid name=periodsid>
								<!--<option>&nbsp;</option>-->
								<%for(int i=1;i<=12;i++){%>
								<option value="<%=i%>"><%=i%></option>
								<%}%>
							</select> 
						</span>
					</wea:item>
				  	<wea:item><%=SystemEnv.getHtmlLabelNames("526,588",user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="avgexchangeratespan" required="true">
							1 <%=defaultcurrencyname%> = <input style="width:30%" id=avgexchangerate name=avgexchangerate maxlength="8" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("avgexchangerate");checkinput("avgexchangerate","avgexchangeratespan")' size="10"> <%=currencyname%>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelNames("1460,588",user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="endexchangeragespan" required="true">
							1 <%=defaultcurrencyname%> = <input style="width:30%" id=endexchangerage name=endexchangerage maxlength="8" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("endexchangerage");checkinput("endexchangerage","endexchangeragespan")' size="10"> <%=currencyname%>
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>
			<input class=inputstyle type=hidden name=operation value="addcurrencyexchange">
			<input class=inputstyle type=hidden name=thecurrencyid value="<%=id%>">
			<input class=inputstyle type=hidden name=defcurrencyid value="<%=defaultcurrencyid%>">
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
