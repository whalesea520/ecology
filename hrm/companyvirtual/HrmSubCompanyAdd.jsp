<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String virtualtype = Util.null2String(request.getParameter("virtualtype"));
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
String titlename = SystemEnv.getHtmlLabelName(141,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";

String cmd = Util.null2String(request.getParameter("cmd"));
int subcompanyid= Util.getIntValue(request.getParameter("subcompanyid"),0);
int companyid = 0;
int supsubcomid= 0;
if(cmd.equals("addSiblingSubCompany")){
	//增加同级分部
	supsubcomid = Util.getIntValue(SubCompanyVirtualComInfo.getSupsubcomid(""+subcompanyid),0);
	companyid = Util.getIntValue(SubCompanyVirtualComInfo.getCompanyid(""+subcompanyid),0);
}else if(cmd.equals("addChildSubCompany")){
	//增加下级分部
	supsubcomid = subcompanyid;
	companyid = Util.getIntValue(SubCompanyVirtualComInfo.getCompanyid(""+subcompanyid),0);
}else{
	//增加分部
	companyid = Util.getIntValue(request.getParameter("companyid"),0);
}
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmSubCompanyAdd:Add", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmSubCompanyAdd:Add", user)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="SubCompanyOperation.jsp" method=post>
<input class=inputstyle type="hidden" name=companyid value="<%=companyid%>">
<input class=inputstyle type="hidden" name=operation value=addsubcompany>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    <wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
    <wea:item>
    	<INPUT class=inputstyle id="subcompanyname" name="subcompanyname" type=text maxLength=60 size=50  onblur="checkLength('subcompanyname',60,'','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"    onchange='checkinput("subcompanyname","subcompanynameimage")' value="">
    	<SPAN id=subcompanynameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></SPAN>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle id="subcompanydesc" name="subcompanydesc" type=text maxLength=60 size=50 onblur="checkLength('subcompanydesc',60,'','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"   onchange='checkinput("subcompanydesc","subcompanydescimage")' value="">
    <SPAN id=subcompanydescimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelNames("596,141",user.getLanguage())%></wea:item>
    <wea:item>
    <%
    String url = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/companyvirtual/SubCompanyBrowser.jsp?virtualtype="+virtualtype+"&selectedids=";
    String completeurl = "/data.jsp?type=subcompanyvirtual&virtualtype="+virtualtype;
    %>
		<brow:browser viewType="0" name="supsubcomid" browserValue='<%=supsubcomid+"" %>' 
      browserUrl='<%=url %>'
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
      completeUrl='<%=completeurl %>' width="240px"
      browserSpanValue='<%=SubCompanyVirtualComInfo.getSubCompanyname(""+supsubcomid) %>'></brow:browser>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle type=text size=60 name="showorder" value="0"></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle type=text size=60 name="subcompanycode" value=""></wea:item>       
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
 if(check_form(frmMain,'subcompanyname,subcompanydesc')){
 	 	//校验重复名
 	 	var companyid = jQuery("input[name=companyid]").val();
	 	var subcompanyname = jQuery("#subcompanyname").val();
	 	var subcompanydesc = jQuery("#subcompanydesc").val();
	 	jQuery.ajax({
			url:"/hrm/ajaxData.jsp?cmd=checksubcompanyname&subcompanyname="+subcompanyname+"&subcompanydesc="+subcompanydesc+"&companyid="+companyid,
			type:"post",
			async:true,
			success:function(data,status){
				if(data.trim()=="1"){
					frmMain.submit();
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26603, user.getLanguage())%>");
				}
			},
		});
 }
}
</script>
</BODY>
</HTML>
