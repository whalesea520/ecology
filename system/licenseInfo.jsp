
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.system.*"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="ln.LN" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="verifylogin" class="weaver.login.LicenseCheckLogin" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("18014",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->licenseInfo.jsp");
	}
	var dialog = null;
	try{
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
<script type="text/javascript">
function openInLicense(){
window.location.href="/system/InLicense.jsp";
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18014,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean canEdit = HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user) ;

LN license = new LN();
license.CkHrmnum();
String companyName = license.getCompanyname();
String licenseCode = license.getLicensecode();
String hrmNum = license.getHrmnum();
String scType = Util.null2String(license.getScType());
String scCount = scType.equals("1") ? "0" : Util.null2String(license.getScCount());
scCount = scCount.equals("0") ? SystemEnv.getHtmlLabelName(82497,user.getLanguage()) : scCount;
String concurrentFlag = Util.null2String(license.getConcurrentFlag());//用户并发数标识
int onlineusercount = verifylogin.checkUserLoginCount();

int licensenum = license.CkUsedHrmnum(); //已使用的license数量
int unusedlice = license.CkUnusedHrmnum() ;//未license已使用数量
if(hrmNum.equals("999999"))hrmNum=SystemEnv.getHtmlLabelName(18637,user.getLanguage());
String expireDate = license.getExpiredate();
if(expireDate.equals("9999-99-99"))expireDate=SystemEnv.getHtmlLabelName(18638,user.getLanguage());
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canEdit){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18640,user.getLanguage())+",javascript:openInLicense();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id=weaver name=frmmain method=post style="MARGIN-TOP: 0px">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(canEdit){ %>
				<input type=button class="e8_btn_top" onclick="openInLicense();" value="<%=SystemEnv.getHtmlLabelName(18640,user.getLanguage())%>"></input>
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(16898,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(companyName,user.getLanguage())%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18639,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(licenseCode,user.getLanguage())%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15029,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(hrmNum,user.getLanguage())%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(82496,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(scCount,user.getLanguage())%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(expireDate,user.getLanguage())%></wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21519,user.getLanguage())%>'>
	<%if("1".equals(concurrentFlag)){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(23657,user.getLanguage())%></wea:item>
		<wea:item><%=onlineusercount%></wea:item>
	<%} else { %>
		<wea:item><%=SystemEnv.getHtmlLabelName(21522,user.getLanguage())%></wea:item>
		<wea:item><%=licensenum%></wea:item>
	<%if(license.getHrmnum().equals("999999")){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(21523,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(hrmNum,user.getLanguage())%></wea:item>
	<%}else{%>
		<wea:item><%=SystemEnv.getHtmlLabelName(21523,user.getLanguage())%></wea:item>
		<wea:item><%=unusedlice%></wea:item>
	<%}}%>
	</wea:group>
</wea:layout>
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
</form>
</BODY>
</HTML>
