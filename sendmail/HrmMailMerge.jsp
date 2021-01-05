<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-04 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(15691,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	int id= Util.getIntValue(request.getParameter("id"));
	String applyid=Util.null2String(request.getParameter("applyid"));
	String issearch = Util.null2String(request.getParameter("issearch"));
	String rid = Util.null2String(request.getParameter("rid"));
	int pagenum=Util.getIntValue(request.getParameter("pagenum"),0);

	String nothrmids = Util.null2String(request.getParameter("nothrmids"));  //经过选择排除的邮件发送人
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
	String fromPage = Util.null2String(request.getParameter("fromPage"));

	String defmailserver = SystemComInfo.getDefmailserver() ;
	String defmailfrom = SystemComInfo.getDefmailfrom() ;
	String defneedauth = SystemComInfo.getDefneedauth() ;
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				dialog.close();
			}
			function chkMail(){
				var email = jQuery("#from").val();
				if(email == ''){
					return true;
				}
				var pattern =  /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i;
				chkFlag = pattern.test(email);
				if(chkFlag){
					return true;
				} else {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24570, user.getLanguage())%>");
					jQuery("#from").focus();
					return false;
				}
			}
		 	function doSave(){
				if(!chkMail()) return false;
				if(check_form(document.frmMain,'subject')){
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
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1226,user.getLanguage())+",javascript:doSave();,_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(1226,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<span style="padding:5px 0px 10px 30px">
		<% if( defmailserver.equals("") ) {%>
			<font color=red><%=SystemEnv.getHtmlLabelName(18902,user.getLanguage())%></font>
		<%}%>
		<% if( defneedauth.equals("1") && defmailfrom.equals("") ) {%>
			<font color=red><%=SystemEnv.getHtmlLabelName(18904,user.getLanguage())%></font>
		<%}%>
		</span>
		<FORM id=weaver name=frmMain action="/sendmail/HrmSendMail.jsp?issearch=1" method=post >
			<INPUT TYPE=hidden ID=rid NAME=rid class="InputStyle" value="<%=rid%>" >
			<% if( defneedauth.equals("1")) { %>
			<INPUT TYPE=hidden ID=from NAME=from class="InputStyle" value="<%=defmailfrom%>" >
			<%} %>
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="true">
							<INPUT TYPE=TEXT ID=subject NAME=subject class="InputStyle" SIZE=100 MAXLENGTH=255 onchange='checkinput("subject","namespan")'>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(18530,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<BUTTON class=calendar type="button" id=SelectDate onclick="getDate(fromdatespan,fromdate)"></BUTTON>&nbsp;
							<SPAN id=fromdatespan ></SPAN>
							<input type="hidden" name="fromdate" value="">--&nbsp;
							<BUTTON class=calendar type="button" id=SelectTime onclick="onShowTime(fromtimespan,fromtime)"></BUTTON>&nbsp;
							<SPAN id=fromtimespan ></SPAN>
							<input type="hidden" name="fromtime" value="">
						</span>
						
					</wea:item>
					<% if( !defneedauth.equals("1")) { %>
					<wea:item><%=SystemEnv.getHtmlLabelName(1260,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<INPUT TYPE=TEXT ID=from NAME=from class="InputStyle" SIZE=80 MAXLENGTH=255 value=<%=user.getEmail()%>>
						</wea:required>
					</wea:item>
					<%}%>
					<wea:item><%=SystemEnv.getHtmlLabelName(18906,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<INPUT TYPE=HIDDEN ID=mailid NAME="mailid" class="wuiBrowser"
							_url="/systeminfo/BrowserMain.jsp?url=/docs/mail/DocMouldBrowser.jsp"
							displayTemplate="<A target='_blank' href='/docs/mail/DocMouldDsp.jsp?id=#b{id}'>#b{name}</A>"></INPUT>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(18908,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<textarea style="WIDTH: 80%" id=selfComment name=selfComment size=80 rows=15 class="InputStyle"></textarea>
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>
            <input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere)%>" >
            <input class=inputstyle type=hidden name=nothrmids value="<%=nothrmids%>" >
			<INPUT TYPE="hidden" NAME="Action" VALUE="1">
			<INPUT TYPE=Hidden ID=Type NAME=Type VALUE=1></INPUT>
			<input class=inputstyle type=hidden name=fromPage value="<%=fromPage%>" >
			<input type=hidden name=id value="<%=id%>">
			<input type=hidden name=issearch value="<%=issearch%>">
			<input type=hidden name=applyid value="<%=applyid%>">
			<input type=hidden name=pagenum value="<%=pagenum%>">
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
