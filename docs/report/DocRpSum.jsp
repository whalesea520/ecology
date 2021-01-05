<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="DocRpManage" class="weaver.docs.report.DocRpManage" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script type="text/javascript">
	function onBtnSearchClick(){
		jQuery("#report").submit();
	}
</script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(79,user.getLanguage());
String needfav ="1";
String needhelp ="";
String optional = Util.null2String(request.getParameter("optional"));
if(optional.equals(""))optional = "crm";
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
String department = Util.null2String(request.getParameter("department")) ;
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
String optionalid = Util.null2String(request.getParameter("optionalid")) ;
String doccreatedateselect = Util.null2String(request.getParameter("doccreatedateselect"));
if(doccreatedateselect.equals(""))doccreatedateselect="0";

if(!doccreatedateselect.equals("") && !doccreatedateselect.equals("0") && !doccreatedateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(doccreatedateselect,"0");
	todate = TimeUtil.getDateByOption(doccreatedateselect,"1");
}

//DocSearchComInfo.resetSearchInfo();
//DocSearchComInfo.addDocstatus("1");
//DocSearchComInfo.addDocstatus("2");
//DocSearchComInfo.addDocstatus("5");
//DocSearchComInfo.setDocdepartmentid(department);
//DocSearchComInfo.setDoccreatedateFrom(fromdate);
//DocSearchComInfo.setDoccreatedateTo(todate);
//DocSearchComInfo.setIsreply(isreply) ;




String whereclause = " where 1=1 ";

if(!optionalid.equals("")){
	whereclause+="and id="+optionalid;
}

String optionalname = "";
String optionalurl = "";
String optionalcompleteurl="";
String labelName = "";
String orderKey = "";
String tableName = "";
String _backfields = "";
String foreignKey = "";
String pageId = "";
String needPage = "true";
if(optional.equals("crm")){
	optionalurl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	optionalcompleteurl="/data.jsp?type=7";
	optionalname = CustomerInfoComInfo.getCustomerInfoname(optionalid);
	labelName = SystemEnv.getHtmlLabelName(30043,user.getLanguage());
	orderKey = "name";
	tableName = "CRM_CustomerInfo";
	_backfields = "t.id,t.name,";
	foreignKey = "crmid";
	pageId = PageIdConst.DOC_CRMLIST;
}else if(optional.equals("hrm")){
	optionalurl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	optionalcompleteurl="/data.jsp";
	optionalname = ResourceComInfo.getResourcename(optionalid);
	labelName = SystemEnv.getHtmlLabelName(30042,user.getLanguage());
	orderKey = "lastname";
	tableName = "hrmresource";
	_backfields = "t.id,t.lastname,";
	foreignKey = "hrmresid";
	pageId = PageIdConst.DOC_HRMLIST;
}else if(optional.equals("project")){
	optionalurl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
	optionalcompleteurl="/data.jsp?type=8";
	optionalname = ProjectInfoComInfo.getProjectInfoname(optionalid);
	labelName = SystemEnv.getHtmlLabelName(30046,user.getLanguage());
	orderKey = "name";
	tableName = "Prj_ProjectInfo";
	_backfields = "t.id,t.name,";
	foreignKey = "projectid";
	pageId = PageIdConst.DOC_PROJIST;
}else if(optional.equals("language")){
	labelName = SystemEnv.getHtmlLabelName(231,user.getLanguage());
	orderKey = "language";
	tableName = "syslanguage";
	foreignKey = "doclangurage";
	_backfields = "t.id,t.language,";
	needPage = "false";
}
//whereclause += "and " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
//DocRpManage.setOptional("creater") ;
//DocRpManage.getRpResult(whereclause,orderbyclause,""+user.getUID()) ;

%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(!optional.equals("language")){ %>
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%if(!optional.equals("language")){ %>
	<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
		<FORM id=report name=report action=DocRpSum.jsp method=post>
		<input type="hidden" name="optional" id="optional" value="<%=optional %>"/>
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		      <wea:item><%=labelName%></wea:item>
		    <wea:item>
		    <brow:browser viewType="0" name="optionalid" browserValue='<%= ""+optionalid %>' 
					browserUrl='<%=optionalurl %>'
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl='<%=optionalcompleteurl %>' 
					browserSpanValue='<%=optionalname%>'>
			</brow:browser>
		    </wea:item>
		    <wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
		    <wea:item>
			<span class="wuiDateSpan" selectId="doccreatedateselect">
				<input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
				<input class=wuiDateSel  type="hidden" name="todate" value="<%=todate%>">
			</span>
		    </wea:item>
		  </wea:group>
		  <wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
		  </wea:layout>
		</FORM>
	</div>
<%} %>
<% 
	String doccount = "select COUNT(id) from DocDetail d where t.id = d."+foreignKey+" and (ishistory is null or ishistory = 0) and docstatus in ('1','2','5')";
	String notreply = "select COUNT(id) from DocDetail d where t.id = d."+foreignKey+" and (ishistory is null or ishistory = 0) and docstatus in ('1','2','5') and (d.isreply=0 or d.isreply is null)";
	String onlyreply = "select COUNT(id) from DocDetail d where t.id = d."+foreignKey+" and (ishistory is null or ishistory = 0) and docstatus in ('1','2','5') and (d.isreply=1)";
	if(!fromdate.equals("")){
		doccount+=" and d.doccreatedate >= '"+fromdate+"'";
		notreply+=" and d.doccreatedate >= '"+fromdate+"'";
		onlyreply+=" and d.doccreatedate >= '"+fromdate+"'";
	}
	if(!todate.equals("")){
		doccount+=" and d.doccreatedate <= '"+todate+"'";
		notreply+=" and d.doccreatedate <='"+todate+"'";
		onlyreply+=" and d.doccreatedate <='"+todate+"'";
	}
	String tabletype="none";
	String backfields=_backfields+
	"("+doccount+") as doccount,"+
	"("+notreply+") as notreplydoccount,"+
	"("+onlyreply+") as replydoccount";
	String sqlform = tableName + " t";
	String tableString=""+
	   "<table needPage=\""+needPage+"\" pageId=\""+pageId+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sumColumns=\"doccount,notreplydoccount,replydoccount\"  sqlform=\""+sqlform+"\" sqlwhere=\""+Util.toHtmlForSplitPage(whereclause)+"\" sqlorderby=\"doccount\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
	   "<head>"+							 
			 "<col width=\"30%\" text=\""+labelName+"\"  column=\""+orderKey+"\"  orderkey=\""+orderKey+"\"/>"+
			 "<col width=\"10%\" column=\"doccount\" orderkey=\"doccount\" text=\""+SystemEnv.getHtmlLabelName(31626,user.getLanguage())+"\"/>"+
			 "<col width=\"20%\" column=\"doccount\" algorithmdesc=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"="+SystemEnv.getHtmlLabelName(31626,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(523,user.getLanguage())+"\" molecular=\"doccount\" denominator=\"sum:doccount\" text=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"\"/>"+
			 "<col width=\"10%\" column=\"notreplydoccount\" orderkey=\"notreplydoccount\" text=\""+SystemEnv.getHtmlLabelName(18467,user.getLanguage())+"\"/>"+
			 "<col width=\"10%\" column=\"replydoccount\" orderkey=\"replydoccount\" text=\""+SystemEnv.getHtmlLabelName(18468,user.getLanguage())+"\"/>"+
			 "<col width=\"20%\" column=\"notreplydoccount\" algorithmdesc=\""+SystemEnv.getHtmlLabelNames("18467,30041,31143",user.getLanguage())+"="+SystemEnv.getHtmlLabelName(18467,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(31626,user.getLanguage())+"\" molecular=\"notreplydoccount\" denominator=\"doccount\" text=\""+SystemEnv.getHtmlLabelNames("18467,30041,31143",user.getLanguage())+"\"/>"+
	   "</head>"+
	   "</table>";
%>
	<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= pageId %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
	</BODY>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	</HTML>
