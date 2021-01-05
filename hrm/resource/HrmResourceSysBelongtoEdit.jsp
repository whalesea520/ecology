<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String ids = request.getParameter("ids");
String isclose = request.getParameter("isclose");
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}

function onBelongto(){
	return "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?sqlwhere=<%=xssUtil.put(" (accounttype=0 or accounttype=null or accounttype is null)")%>";
}

function onBelongToChange(){
	val = jQuery("#accounttype").val();
	if(val=="0"){
		hideEle("belongtodata");
	}
	else {
		showEle("belongtodata");
		if (jQuery("input[name=belongto]").val() == ""){
			jQuery("#belongtospanimg").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		}
		
		jQuery("input[name=belongto]").attr("ismustinput","2");
	} 
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33233,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<div class="zDialog_div_content">
<body>
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
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="HrmResourceSysOperation.jsp" method=post >
			<input name="ids" type="hidden" value="<%=ids %>">
			<input name="method" type="hidden" value="saveBelongtoBatch">
				<wea:layout type="2col">
					<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
						<wea:item><%=SystemEnv.getHtmlLabelName(17745,user.getLanguage())%></wea:item>
						<wea:item>
						  <select class=InputStyle id=accounttype name=accounttype onchange="onBelongToChange(this)">
						    <option value="0"><%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%></option>
						    <option value="1"><%=SystemEnv.getHtmlLabelName(17747,user.getLanguage())%></option>
						  </select>
						</wea:item>
						<wea:item attributes="{'samePair':'belongtodata','display':'none'}"><%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'belongtodata','display':'none'}">
						<%
						String completeUrl = "/data.jsp?type=1&whereClause="+xssUtil.put("(accounttype=0 or accounttype=null or accounttype is null)");
						%>
						<brow:browser viewType="0"  name="belongto" browserValue="" 
													getBrowserUrlFn="onBelongto"
													hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
													completeUrl="<%=completeUrl %>" linkUrl="javascript:openhrm($id$)" width="165px"
													browserSpanValue=""></brow:browser>
						</wea:item>
					</wea:group>
				</wea:layout>		
		</FORM>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="submitData();">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</body>
<script language=javascript>  
function submitData() {
	var accounttype = jQuery("#accounttype").val();
	if(accounttype=="1"){
		if(check_form(frmMain,'belongto')){
	 		frmMain.submit();
	 	}
	}else{
		frmMain.submit();
	}
}
</script>
</HTML>