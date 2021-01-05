<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.appdetach.AppDetachComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld"  prefix="wea"%>
<%
String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=Util.fromScreen(request.getParameter("f_weaver_belongto_usertype"),user.getLanguage());
String tabid = Util.null2String(request.getParameter("tabid"));
String selectedids = Util.null2String(request.getParameter("selectedids"));
String resourceids = Util.null2String(request.getParameter("resourceids"));
if(selectedids.length()==0)selectedids = resourceids;
String nodeid = Util.null2String(request.getParameter("nodeid"));
String isdec = Util.null2String(request.getParameter("isdec"));
String companyid = Util.null2String(request.getParameter("companyid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
int showsubdept=Util.getIntValue(request.getParameter("showsubdept"),0);
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String deptname = Util.null2String(request.getParameter("deptname"));
String deptcode = Util.null2String(request.getParameter("deptcode"));
String showId  = new AppDetachComInfo().getScopeIds(user, "department");
String virtualtype = Util.null2String(request.getParameter("virtualtype"));
%>

<HTML><HEAD>
	<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
	<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/hrm/MutiDepartmentBrowser_wev8.js"></script>
<script type="text/javascript">
	try{
		parent.parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("124",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
	var dialog = null;
	try{
		dialog = parent.parent.parent.getDialog(parent.parent);
	}
	catch(e){}
	
	jQuery(document).ready(function(){
		showMultiDocDialog("<%=selectedids%>");
	});

</script>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
</HEAD>
<BODY>
<div class="zDialog_div_content">
<FORM id="SearchForm" NAME="SearchForm" STYLE="margin-bottom:0" action="" onsubmit="return false;" method=post>
	<input type="hidden" name="cmd" value='HrmResourceMultiSelect'>
	<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
	<input type="hidden" name="pagenum" value=''>
	<input type="hidden" name="tabid" id="tabid" value='<%=tabid%>'>
	<input type="hidden" name="subcompanyid" id="subcompanyid" value='<%=subcompanyid%>'>
	<input type="hidden" name="departmentid" id="departmentid" value='<%=departmentid%>'>		
	<input type="hidden" name="selectedids" id="selectedids" value='<%=selectedids%>'>
	<input type="hidden" name="nodeid" id="nodeid" value='<%=nodeid%>'>
	<input type="hidden" name="companyid" id="companyid" value='<%=companyid%>'>
	<input type="hidden" name="deptname" id="deptname" value='<%=deptname%>'>
	<input type="hidden" name="deptcode" id="deptcode" value='<%=deptcode%>'>
	<input type="hidden" name="fieldid" value="<%=f_weaver_belongto_userid %>"/>
	<input type="hidden" name="detachable" value="<%=f_weaver_belongto_usertype %>"/>
	<input type="hidden" name="showId" id="showId" value='<%=showId%>'>
	<input type="hidden" name="virtualtype" id="virtualtype" value='<%=virtualtype%>'>
	<%if(tabid.equals("0")){ %>
	<table cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td>
			</td>
			<td style="text-align:right;">
				<input type="checkbox" id="showsubdept" name="showsubdept" value="1" <%=showsubdept==1?"checked='checked'":""%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17587,user.getLanguage())%>
			</td>
		</tr>
	</table>
	<%} %>
	<div id="dialog" style="height: 225px;">
		<div id='colShow'></div>
	</div>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=O  id=btnok  value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>">
			<input type="button" class=zd_btn_cancle accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>">
      <input type="button" class=zd_btn_submit accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<!--########//Shadow Table End########-->
</BODY>
</HTML>
