<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String tabid = Util.null2String(request.getParameter("tabid"));
String selectedids = Util.null2String(request.getParameter("selectedids"));
String resourceids = Util.null2String(request.getParameter("resourceids"));
if(selectedids.length()==0)selectedids = resourceids;
String companyid = Util.null2String(request.getParameter("companyid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String groupid = Util.null2String(request.getParameter("groupid"));
String isNoAccount = Util.null2String(request.getParameter("isNoAccount"));
String lastname = Util.null2String(request.getParameter("lastname"));
String resourcetype = Util.null2String(request.getParameter("resourcetype"));
String resourcestatus = Util.null2String(request.getParameter("resourcestatus"));
String jobtitle = Util.null2String(request.getParameter("jobtitle"));
String status = Util.null2String(request.getParameter("status"));
String firstname = Util.null2String(request.getParameter("firstname"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());    
String roleid = Util.null2String(request.getParameter("roleid"));
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
//added by wcd 2014-07-08 start
String alllevel = Util.null2String(request.getParameter("alllevel"),"1");
String search = Util.null2String(request.getParameter("search"));
//added by wcd 2014-07-08 end
String fromHrmStatusChange = Util.null2String(request.getParameter("fromHrmStatusChange"));
String rightStr=Util.null2String(request.getParameter("rightStr"));
%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/hrm/MutiResourceBrowserRight_wev8.js"></script>
<script type="text/javascript">
jQuery(document).ready(function(){
	showMultiDocDialog("<%=selectedids%>");
});
	var dialog = null;
	try{
		dialog = parent.parent.parent.getDialog(parent.parent);
	}
	catch(e){}
</script>
</HEAD>
<body scroll="no">
<div class="zDialog_div_content">
	<FORM id="SearchForm" NAME="SearchForm" STYLE="margin-bottom:0" action="" onsubmit="return false;" method=post>
		<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
		<input type="hidden" name="cmd" value='HrmResourceMultiSelect'>
		<input type="hidden" name="pagenum" value=''>
		<input type="hidden" name="tabid" id="tabid" value='<%=tabid%>'>
		<input type="hidden" name="groupid" id="groupid" value='<%=groupid%>'>
		<input type="hidden" name="lastname" id="lastname" value='<%=lastname%>'>
		<input type="hidden" name="resourcetype" id="resourcetype" value='<%=resourcetype%>'>
		<input type="hidden" name="resourcestatus" id="resourcestatus" value='<%=resourcestatus%>'>
		<input type="hidden" name="jobtitle" id="jobtitle" value='<%=jobtitle%>'>
		<input type="hidden" name="subcompanyid" id="subcompanyid" value='<%=subcompanyid%>'>
		<input type="hidden" name="departmentid" id="departmentid" value='<%=departmentid%>'>		
		<input type="hidden" name="status" id="status" value='<%=status%>'>
		<input type="hidden" name="firstname" id="firstname" value='<%=firstname%>'>		
		<input type="hidden" name="seclevelto" id="seclevelto" value='<%=seclevelto%>'>
		<input type="hidden" name="roleid" id="roleid" value='<%=roleid%>'>
		<input type="hidden" name="selectedids" id="selectedids" value='<%=selectedids%>'>
		<input type="hidden" name="alllevel" id="alllevel" value='<%=alllevel%>'>
		<input type="hidden" name="fromHrmStatusChange" id="fromHrmStatusChange" value='<%=fromHrmStatusChange%>'>
		<input type="hidden" name="rightStr" id="rightStr" value='<%=rightStr%>'>
		<table width=100% >
		<!-- added by wcd 2014-07-08 start -->
		<TR>
			<TD align="right" colspan="3">
				<%if(tabid.equals("0")){ %>
				<input type="checkbox" id="alllevel_c"  name="alllevel_c" value="1" <%=alllevel.equals("1")?"checked='checked'":""%>/><%=SystemEnv.getHtmlLabelName(33454,user.getLanguage())%>
				<input class=inputstyle type="hidden" name="search" value="1">
				<%} %>
				<input style="margin-left: 80px;" type="checkbox" value="1" name="isNoAccount" id="isNoAccount" <%=isNoAccount.equals("1")?"checked='checked'":""%>><%=SystemEnv.getHtmlLabelName(31504,user.getLanguage())%>
			</TD>
		</TR>
		<!-- added by wcd 2014-07-08 end -->
		</table>		
		<div id="dialog" style="height: 225px;">
			<div id='colShow'></div>
		</div>
	</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=O  id=btnok value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
</div>

</body>
</html>