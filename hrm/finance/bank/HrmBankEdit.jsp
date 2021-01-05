<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
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
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(389,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean CanEdit=HrmUserVarify.checkUserRight("HrmBankEdit:Edit", user);
boolean CanDelete=HrmUserVarify.checkUserRight("HrmBankEdit:Delete", user);
boolean CanAdd=HrmUserVarify.checkUserRight("HrmBankAdd:Add", user);

String id=Util.null2String(request.getParameter("id"));
String message=Util.null2String(request.getParameter("message"));

String bankname=BankComInfo.getBankname(id);
String bankdesc=BankComInfo.getBankdesc(id);
String checkstr=BankComInfo.getCheckstr(id);
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanEdit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/hrm/finance/bank/HrmBankAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(CanDelete){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<% if(message.equals("fail")){ %> <font color=red><%=SystemEnv.getHtmlLabelName(15813,user.getLanguage())%></font><%}%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="doSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name=frmmain method=post action="HrmBankOperation.jsp">
<input type=hidden name="operation">
<input type=hidden name="id" value="<%=id%>">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15812,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item>
		<%if(CanEdit){%>
		<input type="input" name="bankname" onchange="checkinput('bankname','banknamespan')" 
		size="30" maxlength="30" value="<%=Util.toScreenToEdit(bankname,user.getLanguage())%>">
		<span id=banknamespan><%if(bankname.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
		<%} else {%><%=Util.toScreen(bankname,user.getLanguage())%><%}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item> 
		<wea:item>
		<%if(CanEdit){%>
		<input type="input" name="bankdesc" onchange="checkinput('bankdesc','bankdescspan')" 
		size="50" maxlength="100" value="<%=Util.toScreenToEdit(bankdesc,user.getLanguage())%>">
		<span id=bankdescspan><%if(bankdesc.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
		<% } else {%><%=Util.toScreen(bankdesc,user.getLanguage())%><%}%>
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
	function doSave(){
		if(check_form(document.frmmain,'bankname,bankdesc')){
			document.frmmain.operation.value="save";
			document.frmmain.submit();
		}
	}
	function doDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmmain.operation.value="delete";
			document.frmmain.submit();
		}
	}
</script>
</body>
</html>
