<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DocRpManage" class="weaver.docs.report.DocRpManage" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
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
String department = Util.null2String(request.getParameter("department")) ;
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
String needreply = Util.null2String(request.getParameter("needreply")) ;
String orderby = Util.null2String(request.getParameter("orderby")) ;
String isreply = "" ;
if(!needreply.equals("1")) isreply = "0" ;


DocSearchComInfo.resetSearchInfo();
DocSearchComInfo.addDocstatus("1");
DocSearchComInfo.addDocstatus("2");
DocSearchComInfo.addDocstatus("5");
DocSearchComInfo.setDocdepartmentid(department);
DocSearchComInfo.setDoccreatedateFrom(fromdate);
DocSearchComInfo.setDoccreatedateTo(todate);
DocSearchComInfo.setIsreply(isreply) ;




String whereclause = " where  (ishistory is null or ishistory = 0) and usertype>0 and t1.maincategory in (select id from DocMainCategory) and " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
String orderbyclause ="" ;


if(orderby.equals("1") || orderby.equals("")) orderbyclause +="order by ownerid ";
if(orderby.equals("2")) orderbyclause +="order by docdepartmentid ";
if(orderby.equals("3")) orderbyclause +="order by resultcount desc ";

DocRpManage.setOptional("creater") ;
DocRpManage.getRpResult(whereclause,orderbyclause,""+user.getUID()) ;

%>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<FORM id=report name=report action=DocRpCreater.jsp method=post>
	
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
	      <wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
	    <wea:item>
		<INPUT    class=wuiBrowser   id=department type=hidden name=department 
		  _displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentmark(department),user.getLanguage())%> - <%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%>"
		 _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=<%=department%>"   value="<%=department%>" >
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
	    <wea:item><input class=wuiDate  type="hidden" name="fromdate" value='<%=fromdate%>'>
	      -&nbsp;&nbsp; <input class=wuiDate  type="hidden" name="todate" value="<%=todate%>">
	    </wea:item>
	      <wea:item><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>:&nbsp;<%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></wea:item>
	    <wea:item>
	      <input id=needreply type=checkbox name=needreply value="1" <%if(needreply.equals("1")) {%>checked<%}%>>
	
	    </wea:item>
	      <wea:item><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></wea:item>
	    <wea:item>
	      <SELECT class=InputStyle  id=orderby style="WIDTH: 150px" name=orderby>
	        <OPTION value=1 <%if(orderby.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())%>
	        <OPTION value=2 <%if(orderby.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
	        <OPTION value=3 <%if(orderby.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(355,user.getLanguage())%>
	      </SELECT>
	    </wea:item>
	  </wea:group>
	  </wea:layout>
	</FORM>
</div>
<% 
	String tabletype="none";
	String backfields="t.id,t.lastname,t.departmentid,"+
	"(select COUNT(id) from DocDetail d where t.id = d.doccreaterid) as doccount,"+
	"(select COUNT(id) from DocDetail d where t.id = d.doccreaterid and (d.isreply=0 or d.isreply is null)) as notreplydoccount,"+
	"(select COUNT(id) from DocDetail d where t.id = d.doccreaterid and (d.isreply=1)) as replydoccount";
	String sqlform = "hrmresource t";
	String tableString=""+
	   "<table pageId=\""+PageIdConst.DOC_MAINCATEGORYLIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_MAINCATEGORYLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\""+backfields+"\" sumColumns=\"doccount,notreplydoccount,replydoccount\"  sqlform=\""+sqlform+"\" sqlorderby=\"doccount\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
	    "<head>"+							 
			 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"1\" column=\"id\"  orderkey=\"lastname\"/>"+
			 "<col width=\"20%\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.general.KnowledgeTransMethod.getDepartmentName\" otherpara=\""+user.getLanguage()+"\" text=\""+SystemEnv.getHtmlLabelName(27511,user.getLanguage())+"\"/>"+
			 "<col width=\"10%\" column=\"doccount\" orderkey=\"doccount\" text=\""+SystemEnv.getHtmlLabelName(31626,user.getLanguage())+"\"/>"+
			 "<col width=\"20%\" column=\"doccount\" algorithmdesc=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"="+SystemEnv.getHtmlLabelName(31626,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(523,user.getLanguage())+"\" molecular=\"doccount\" denominator=\"sum:doccount\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"\"/>"+
			 "<col width=\"10%\" column=\"notreplydoccount\" orderkey=\"notreplydoccount\" text=\""+SystemEnv.getHtmlLabelName(18467,user.getLanguage())+"\"/>"+
			 "<col width=\"10%\" column=\"replydoccount\" orderkey=\"replydoccount\" text=\""+SystemEnv.getHtmlLabelName(18468,user.getLanguage())+"\"/>"+
			 "<col width=\"20%\" column=\"notreplydoccount\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" algorithmdesc=\""+SystemEnv.getHtmlLabelNames("18467,30041,31143",user.getLanguage())+"="+SystemEnv.getHtmlLabelName(18467,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(31626,user.getLanguage())+"\" molecular=\"notreplydoccount\" denominator=\"doccount\" text=\""+SystemEnv.getHtmlLabelNames("18467,30041,31143",user.getLanguage())+"\"/>"+
	   "</head>"+
	   "</table>";
%>
	<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.DOC_MAINCATEGORYLIST %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
	</BODY>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	</HTML>
