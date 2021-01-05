<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.common.Tools"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
	if(!HrmUserVarify.checkUserRight("CRM:AssignManager",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String customids = Util.null2String(request.getParameter("customids"));//需要设置的resourceid
	String[] tmpcustomids = Tools.split(customids,",");
	String customnames = "";
	for(int i=0;tmpcustomids!=null&&i<tmpcustomids.length;i++){
		if(Util.null2String(tmpcustomids[i]).length()==0)continue;
		if(customnames.length()>0)customnames+=",";
		customnames+=CustomerInfoComInfo.getCustomerInfoname(tmpcustomids[i]);
	}
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
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="outresourceOperation.jsp" method=post >
   <input type=hidden name=operation>
   <input type=hidden id=customids name=customids value="<%=customids%>">
	<wea:layout type="2col">
		<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
      <wea:item><%=SystemEnv.getHtmlLabelName(24974,user.getLanguage())%></wea:item>
      <wea:item><%=customnames%></wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></wea:item>
      <wea:item>
				<brow:browser viewType="0"  name="custommanager" browserValue='' 
				    browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
				    hasInput="true" isSingle="false" hasBrowser="true" isMustInput='2' linkUrl="javascript:openhrm($id$)"
				    completeUrl="/data.jsp" width="165px"
				    browserSpanValue=''></brow:browser>
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

<script language=javascript>
function onSave(){
	if(check_form(document.frmMain,'custommanager')){
		document.frmMain.operation.value="outresourceAssignSet";
		document.frmMain.submit();
	}
}

</script>
</BODY></HTML>