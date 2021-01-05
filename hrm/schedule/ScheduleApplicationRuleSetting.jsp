
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));

	String cmd = Util.null2String(request.getParameter("cmd"));
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = Util.null2String(request.getParameter("titlename"));
	
	String msg = Util.null2String(request.getParameter("msg"));
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
try{
	parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("15880,579,68",user.getLanguage())%>");
}catch(e){
	if(window.console)console.log(e+"-->ScheduleApplicationRuleSetting.jsp");
}
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.reflashAdminTable();
	dialog.close();	
}

function doSave() {
	var checkstr="seclevel,seclevelend,reportname";
	if(check_form(document.weaver,checkstr)){
	   var _seclevel = jQuery("#seclevel").val();
	   var _seclevelend = jQuery("#seclevelend").val();
	   if(parseInt(_seclevel) > parseInt(_seclevelend)){
	   		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(382783,user.getLanguage())%>");
	   		return false;
	   }else{
			document.weaver.submit();
	   }
	}
}


</script>
</head>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="doSave();">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<BODY>
	<%if("1".equals(isDialog)){ %>
	<div class="zDialog_div_content">
	<%} %>
          <%
          if(msg.equals("1")){
          %>
	   <DIV>
         <font color=red size=2>
         <%=SystemEnv.getHtmlLabelName(382783,user.getLanguage())%>
         </font>
      </div>
          <%
          }
          %>
	<FORM style="MARGIN-TOP: 0px" name=weaver method=post action="ScheduleApplicationSettingOperation.jsp">
		<input type="hidden" name="action" value="addRule">
		<wea:layout type="2col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
				<wea:item>
	        <SELECT class=inputstyle name=sharetype onchange="onChangeSharetype()" >
		        <option value="1" selected><%=SystemEnv.getHtmlLabelName(20081,user.getLanguage())%></option>
		        <option value="2"><%=SystemEnv.getHtmlLabelName(20082,user.getLanguage())%></option>
		    	</SELECT>
			  </wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></wea:item>
				<wea:item>
					<span id=showseclevel name=showseclevel>
					<INPUT type=text class="InputStyle" id=seclevel name=seclevel size=6 value="" onchange='checkinput("seclevel","seclevelimage")' onBlur='checknumber1(this);' onKeyPress='ItemNum_KeyPress(this)' style="width: 30px;">
					<SPAN id=seclevelimage><img src="/images/BacoError_wev8.gif" align=absmiddle></SPAN>
					-
					<INPUT type=text class="InputStyle" id=seclevelend name=seclevelend size=6 value="" onchange='checkinput("seclevelend","seclevelendimage")' onBlur='checknumber1(this);' onKeyPress='ItemNum_KeyPress(this)' style="width: 30px;" >
					</span>
					<SPAN id=seclevelendimage><img src="/images/BacoError_wev8.gif" align=absmiddle></SPAN>
				</wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelNames("15101,261,195",user.getLanguage())%></wea:item>
				<wea:item>
					<INPUT type=text class="InputStyle" name=reportname id=reportname onchange='checkinput("reportname","reportnameimage")' />
					<SPAN id=reportnameimage><img src="/images/BacoError_wev8.gif" align=absmiddle></SPAN>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
				<wea:item>
				<br/>
				<%=SystemEnv.getHtmlLabelName(382796,user.getLanguage())%><br/>
				<%=SystemEnv.getHtmlLabelName(382797,user.getLanguage())%><br/>
				</wea:item>
			</wea:group>
		</wea:layout>
		<%if("1".equals(isDialog)){ 
		%>
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
	</FORM>
</BODY>
</HTML>
