<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%
String impJs="/js/dragBox/rightspluingForBrowserNew_wev8.js";
String srchead="['"+SystemEnv.getHtmlLabelNames("195",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("16314",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("714",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("19799",user.getLanguage())+"']";
String srcfield="['id','name','capitalspec','mark','blongsubcompany']";
boolean isSingle="single".equalsIgnoreCase( Util.null2String(request.getParameter("browtype")));
if(isSingle){
	impJs="/js/dragBox/rightspluingForSingleBrowser_wev8.js";
	srchead="['"+SystemEnv.getHtmlLabelNames("195",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("16314",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("714",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("19799",user.getLanguage())+"']";
	srcfield="['id','name','capitalspec','mark','blongsubcompany']";
}
%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="<%=impJs %>"></script>
<script type="text/javascript" src="/cpt/js/multicptbrowser_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("1509",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<%
String name = Util.null2String(request.getParameter("name"));
String from = Util.null2String(request.getParameter("from"));
String capitalspec = Util.null2String(request.getParameter("capitalspec"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String mark = Util.null2String(request.getParameter("mark"));
String capitalgroupid = Util.null2String(request.getParameter("capitalgroupid"));
String blongsubcompany = Util.null2String(request.getParameter("blongsubcompany"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("resourceids"));


String resourceids = "";
String resourcenames = "";


%>

<script type="text/javascript">
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
		    window.parent.close();
		}
	}
</script>

</HEAD>

<BODY style="overflow:hidden;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="assest"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("1509",user.getLanguage()) %>'/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" onclick="btnOnSearch()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnOnSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!isSingle){
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
</DIV>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<div class="zDialog_div_content">
<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MultiCapitalBrowser.jsp" onsubmit="btnOnSearch();return false;" method=post>
<input type="hidden" name="pagenum" value=''>
<input type="hidden" name="from" value='<%=from %>' />



<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">

<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}" >
	
			
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="text" class="InputStyle" name="name" id="name" value="<%=name %>" />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
			<wea:item>
		        <input type="text" class="InputStyle" name="mark" id="mark" value="<%=mark %>" />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></wea:item>
			<wea:item>
		         <input type="text" class="InputStyle" name="capitalspec" id="capitalspec" value="<%=capitalspec %>" />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="capitalgroupid" 
					browserValue='<%=capitalgroupid %>' browserSpanValue='<%=CapitalAssortmentComInfo.getAssortmentName(capitalgroupid ) %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=25" />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(1507,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="resourceid" 
					browserValue='<%=resourceid %>' browserSpanValue='<%=ResourceComInfo.getLastname(resourceid ) %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=1" />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="blongsubcompany" 
					browserValue='<%=blongsubcompany %>' browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(blongsubcompany ) %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=164" />
			</wea:item>
	</wea:group>
</wea:layout>
	
	
</div>
<div id="dialog">
	<div id='colShow'></div>
</div>


<div style="width:0px;height:0px;overflow:hidden;">
<button type=submit></BUTTON>
</div>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
		<%
		if(!isSingle){
			%>
			<input type="button" class=zd_btn_submit  accessKey=O  id=btnok value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<%
		}
		%>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
	        <input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>


<script type="text/javascript">

jQuery(document).ready(function(){
	showMultiDocDialog("<%=check_per %>",<%=srchead %>,<%=srcfield %>);
});


</SCRIPT>
</BODY>
</HTML>
