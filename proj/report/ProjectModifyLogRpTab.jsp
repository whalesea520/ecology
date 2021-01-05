<%@page import="weaver.cpt.util.DateUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String isfromProjTab = Util.null2String(request.getParameter("isfromProjTab"));
String querystr=request.getQueryString();
//String url="/proj/report/ProjectModifyLogRp.jsp?isfromProjTab=1";
if(!"1".equals(isfromProjTab)){
	//response.sendRedirect("/proj/data/ProjectBlankTab.jsp"+"?url="+url);
	//return;
}

if(!HrmUserVarify.checkUserRight("LogView:View", user))  {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}

String src=Util.null2String(request.getParameter("src"));
if("".equals(src)){
	src="today";
}
%>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script type="text/javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#report").submit();
}
$(function(){
	try{
		//parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(16575,user.getLanguage()) %>");
	}catch(e){}
});
</script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(79,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.report.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
String submiter = Util.null2String(request.getParameter("submiter"));

String prjname = Util.null2String(request.getParameter("prjname"));
String manager = Util.null2String(request.getParameter("manager"));
String nameQuery = Util.null2String(request.getParameter("flowTitle"));

if("".equals(fromdate)&&"".equals(todate)){
	if("today".equalsIgnoreCase(src)){
		fromdate=todate= TimeUtil.getCurrentDateString();
	}else if("thisyear".equalsIgnoreCase(src)){
		fromdate=TimeUtil.getFirstDayOfTheYear();
		todate=TimeUtil.getCurrentDateString().substring(0,4)+"-12-31";
	}else if("thismonth".equalsIgnoreCase(src)){
		fromdate=TimeUtil.getFirstDayOfMonth();
		todate=TimeUtil.getLastDayOfMonth().substring(0,10) ;
	}else if("thisweekday".equalsIgnoreCase(src)){
		fromdate= DateUtil.getFirstDayOfWeek ();
		todate=DateUtil.getLastDayOfWeek() ;
	}else if("thisquater".equalsIgnoreCase(src)){
		fromdate=DateUtil.getCurrentQuarterStartTime();
		todate=DateUtil.getCurrentQuarterEndTime();
	}
}
%>
<FORM id="report" name="report" action="" method=post>
<input type="hidden" name="src" value="<%=src %>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<input type="text" class="searchInput" name="flowTitle" value="<%=nameQuery %>" />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	
	
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("104,101",user.getLanguage())%></wea:item>
	     <wea:item>
	     	<input type="text" class="InputStyle" name="prjname" value="<%=prjname %>" />
	     </wea:item>
	     <wea:item><%=SystemEnv.getHtmlLabelName(16573,user.getLanguage())%></wea:item>
	    <wea:item>
		    <brow:browser viewType="0" name="manager" browserValue='<%= ""+manager %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids="
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" 
					browserSpanValue='<%=ResourceComInfo .getResourcename  (manager) %>'>
			</brow:browser>
	    </wea:item>
	     <wea:item><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></wea:item>
	    <wea:item>
		    <brow:browser viewType="0" name="submiter" browserValue='<%= ""+submiter %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids="
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" 
					browserSpanValue='<%=ResourceComInfo .getResourcename  (submiter) %>'>
			</brow:browser>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<span class="wuiDateSpan" selectId="selectDate_sel" selectValue="">
			    <input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
			    <input class=wuiDateSel  type="hidden" name="todate" value="<%=todate%>">
			</span>
	    </wea:item>
	      
	  </wea:group>
	  <wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
			<input type="reset" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" />
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
</div>

</FORM>

<% 

String sqlwhere= " where t3.projectid=t1.id  and ( "+CommonShareManager.getPrjShareWhereByUser(user) +" ) ";
if(!"".equals(submiter)){
	sqlwhere+=" and t3.submiter='"+submiter+"' ";
}
if(!fromdate.equals("")){
	sqlwhere+=" and t3.submitdate>='"+fromdate+"' ";
}
if(!todate.equals("")){
	sqlwhere+=" and t3.submitdate<='"+todate+"' ";
}
if(!"".equals(prjname)){
	sqlwhere+=" and t1.name like '%"+prjname+"%' ";
}else if(!"".equals(nameQuery)){
	sqlwhere+=" and t1.name like '%"+nameQuery+"%' ";
}
if(!"".equals(manager)){
	sqlwhere+=" and t1.manager='"+manager+"' ";
}

String tabletype="none";
String backfields=" t3.*,t1.manager ";
String sqlform = " Prj_Log  t3, prj_projectinfo t1 ";
String orderby=" t3.submitdate ,t3.submittime ";
//String groupby=" t1.manager ";
String primarykey=" t3.projectid ";
//String sumColumns="resultcount";

//out.println("select "+backfields+" from "+sqlform+" "+sqlwhere+" order by "+orderby);

String tableString=""+
   "<table pageId=\""+PageIdConst.DOC_CREATERLIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_CREATERLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
   "<sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\"  sqlform=\""+Util.toHtmlForSplitPage(sqlform)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlorderby=\""+orderby+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
   "<head>"+							 
		 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName( 99 ,user.getLanguage())+"\" column=\"submiter\" orderkey=\"submiter\" transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename' href='/hrm/resource/HrmResource.jsp' linkkey='id' target='_fullwindow' />"+
		 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"logtype\" orderkey=\"logtype\" otherpara='"+(""+user.getLanguage())+"' transmethod='weaver.proj.util.ProjectTransUtil.getPrjLogTypeName2' />"+
		 "<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(97,user.getLanguage())+"\" column=\"submitdate\"  orderkey=\"submitdate\"  />"+
		 "<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(277,user.getLanguage())+"\" column=\"submittime\"  orderkey=\"submittime\"  />"+
		 "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(1353,user.getLanguage())+"\" column=\"projectid\" orderkey=\"projectid\" transmethod='weaver.proj.Maint.ProjectInfoComInfo.getProjectInfoname' href='/proj/data/ViewProject.jsp' linkkey='ProjID' target='_fullwindow' />"+
		 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName( 16573 ,user.getLanguage())+"\" column=\"manager\" orderkey=\"manager\" transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename' href='/hrm/resource/HrmResource.jsp' linkkey='id' target='_fullwindow' />"+
		 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(33586,user.getLanguage())+"\" column=\"clientip\"  orderkey=\"clientip\" />"+
   "</head>"+
   "</table>";
%>
<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.DOC_CREATERLIST %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />

	
</BODY>
	
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
