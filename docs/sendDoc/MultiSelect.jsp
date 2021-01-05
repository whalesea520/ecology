<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
//System.out.println("departmentid"+departmentid);
//System.out.println("tabid"+tabid);

String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String receiveUnitId = Util.null2String(request.getParameter("receiveUnitId"));
int showsubdept=Util.getIntValue(request.getParameter("showsubdept"),0);
String nodeid = Util.null2String(request.getParameter("nodeid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("receiveUnitIds"));
String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));
String requestid = Util.null2String(request.getParameter("requestid"));
%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/docs/multiSelectBrowser_wev8.js"></script>
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.parent.getParentWindow(parent.parent);
		dialog = parent.parent.parent.getDialog(parent.parent);
	}catch(e){
		if(window.console)console.log(e);
	}
	var btnok_onclick = function(){
		jQuery("#btnok").click();
	}

	var btnclear_onclick = function(){
		jQuery("#btnclear").click();
	}
	
	function onClose(){
		 if(dialog){
	    	dialog.close()
	    }else{
		    window.parent.parent.close();
		}
	}
</script>
</HEAD>
<BODY>
<div class="zDialog_div_content" style="height:85% !important">
<%//@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	
<%//@ include file="/systeminfo/RightClickMenu.jsp" %>
<div id="dialog">
	<div id='colShow'></div>
</div>
<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="" onsubmit="return false;" method=post>
	<input type="hidden" name="nodeid" id="nodeid" value='<%=nodeid %>'>
	<input type="hidden" name="subcompanyid" id="subcompanyid" value='<%=subcompanyid %>'>
	<input type="hidden" name="receiveUnitId" id="receiveUnitId" value='<%=receiveUnitId %>'>
	<input type="hidden" name="showsubdept" id="showsubdept" value='<%=showsubdept %>'>
	<input type="hidden" name="sqlwhere" id="sqlwhere" value='<%=xssUtil.put(sqlwhere) %>'>
	<input type="hidden" name="isWorkflowDoc" id="isWorkflowDoc" value='<%=isWorkflowDoc %>'>
	<input type="hidden" name="requestid" id="requestid" value='<%=requestid %>'>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="height:15% !important">
<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=O  id=btnok value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
	        <input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			showMultiDocDialog("<%=check_per%>");
		});
	</script>
</div>

</BODY>
</HTML>
