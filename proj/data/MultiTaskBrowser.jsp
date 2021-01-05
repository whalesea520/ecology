
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
String impJs="/js/dragBox/rightspluingForBrowserNew_wev8.js";
String srchead="['"+SystemEnv.getHtmlLabelNames("1352",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("17749",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("2097",user.getLanguage())+"']";
String srcfield="['id','subject','prjid','hrmid']";
boolean isSingle="single".equalsIgnoreCase( Util.null2String(request.getParameter("browtype")));
String from= Util.null2String(request.getParameter("from"));
if(isSingle){
	impJs="/js/dragBox/rightspluingForSingleBrowser_wev8.js";
	srchead="['"+SystemEnv.getHtmlLabelNames("1352",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("17749",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("2097",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("22168",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("22170",user.getLanguage())+"']";
	srcfield="['id','subject','prjid','hrmid','begindate','enddate']";
}
%>
<HTML><HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="<%=impJs %>"></script>
<script type="text/javascript" src="/proj/js/multiTaskBrowser_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("1332",user.getLanguage())%>");
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

<%
String subject = Util.null2String(request.getParameter("subject"));
String prjid = Util.null2String(request.getParameter("prjid"));
String begindate = Util.null2String(request.getParameter("begindate"));
String enddate = Util.null2String(request.getParameter("enddate"));
//String worktype = Util.null2String(request.getParameter("worktype"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("resourceids"));
String resourceids = "";
String resourcenames = "";

%>

<BODY  style="overflow:hidden;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("1332",user.getLanguage()) %>'/>
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

<div class="zDialog_div_content">

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<tr>
		<td valign="top" colspan="2">
		</td>
		</tr>

	<FORM id=weaver name=SearchForm style="margin-bottom:0" action="MultiTaskBrowser.jsp" onsubmit="btnOnSearch();return false;" method=post>
		<input type="hidden" name="pagenum" value=''>
		<DIV align=right style="display:none">
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnOnSearch(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
		</DIV>
<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}" >
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item><input name=subject value='<%=subject%>' class="InputStyle"></wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></wea:item>
			<wea:item>    	
			<%
			boolean notaddtask=!"addtask".equalsIgnoreCase(from);
			if(notaddtask){
			%>	
    		<brow:browser viewType="0" name="prjid" browserValue='<%=prjid%>' 
    				 browserSpanValue='<%=ProjectInfoComInfo.getProjectInfoname(prjid)%>' 
    			browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" 
    			hasInput="true" isSingle="true" hasBrowser="true" isMustInput="1" completeUrl="/data.jsp?type=8" />
			<%
			}else{
			%>	
			<span><%=ProjectInfoComInfo.getProjectInfoname(prjid)%></span>
			<input type="hidden" name="prjid" id="prjid" value="<%=prjid %>" />
			<%
			}
			
			
			%>
    		</wea:item>

			<wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></wea:item>
			<wea:item>
   			  <brow:browser viewType="0" name="hrmid" browserValue='<%=hrmid%>' 
   			  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
   			  browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(hrmid),user.getLanguage())%>' 
   			  hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
			  completeUrl="/data.jsp" />
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
			<wea:item>
				<span class="wuiDateSpan" selectId="planendate_sel" selectValue="">
				  <input class=wuiDateSel type="hidden" name="begindate" value="<%=begindate %>">
				  <input class=wuiDateSel  type="hidden" name="enddate" value="<%=enddate %>">
				</span>
				
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
</table>

</BODY></HTML>

<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>

<script type="text/javascript">
jQuery(document).ready(function(){
	showMultiDocDialog("<%=check_per %>",<%=srchead %>,<%=srcfield %>);
});
</SCRIPT>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
