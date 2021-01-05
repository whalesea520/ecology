<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<% 
	if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsAdd:Add",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String id = Util.null2String(request.getParameter("id"));
	
	rs.executeProc("FnaCurrency_SelectByID",id);
	rs.next();
	String currencyname = Util.toScreen(rs.getString("currencyname"),user.getLanguage());
	String currencydesc = Util.toScreenToEdit(rs.getString("currencydesc"),user.getLanguage());
	String activable = Util.null2String(rs.getString("activable"));
	String isdefault = Util.null2String(rs.getString("isdefault"));
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(406,user.getLanguage())+" : "+ currencyname ;
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.closeDialog();
			}
			function doDel(){
				parentWin._cmd = "closeDialog";
				parentWin.doDel('<%=id%>');
			}
		 	function doSave(){
		 		//默认币种，必须是启用状态判断
		 		if (jQuery('#isdefault').attr('checked')) {   
		 			if(jQuery("#activable").val() == 0){
		 				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81677,user.getLanguage())%>");
		 				return;
		 			}
		 		}
				if(checkactivable()){
					 if(check_form(document.frmMain,"currencyname")){
						document.frmMain.submit();
					 }
				}
		 	}
			function check() {
				if(document.getElementById("isdefault").checked){
					document.getElementById("activable").checked = true;
				}
			}
			function checkactivable() {
				if(document.getElementById("isdefault").checked == true && document.getElementById("activable").checked == false){
					alert("<%=SystemEnv.getHtmlLabelName(27080,user.getLanguage())%>");
					return false
				}
				return true;
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
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="doDel();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="FnaCurrenciesOperation.jsp" method=post >
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required='<%=currencyname.length()==0%>'>
							<input class=InputStyle maxLength=30 size=30 name="currencyname" value="<%=currencyname%>" onchange="checkinput('currencyname','namespan')">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="currencydescspan" required="false">
							<input class=InputStyle maxLength=50 size=50 name="currencydesc" value="<%=currencydesc%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<span>
								<select class=inputstyle id=activable name=activable> 
									<OPTION value="1" <%if(activable.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></OPTION> 
									<OPTION value="0" <%if(activable.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></OPTION>
								</SELECT>
							</span>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(757,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<input id="isdefault" name="isdefault" value="1" type="checkbox" tzCheckbox="true" <%if(isdefault.equals("1")) {%> checked disabled <%}%> onclick="check();" />
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>		
			<input class=inputstyle type="hidden" name="id" value="<%=id%>">
			<input class=inputstyle type=hidden name=isdefaultold value="<%=isdefault%>">
			<input class=inputstyle type=hidden name=operation value="editcurrencies">
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
