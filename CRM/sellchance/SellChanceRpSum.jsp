<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript">

function showDetailInfo(id){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(2227,user.getLanguage()) %>";
	dialog.Width = 800;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = "/CRM/sellchance/SellChanceReport.jsp?msg=report&endtatusid="+id;
	dialog.show();
}

</script>

</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(63,user.getLanguage());
String needfav ="1";
String needhelp ="";


%>
<%
	String searchName = Util.null2String(request.getParameter("searchName"));
	String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
	int pagesize = 10;
	String orderby = "resultcount";
	String fromSql = "CRM_SellChance t1,"+leftjointable+" t2,CRM_CustomerInfo t3 ";
	String backfields = "t1.endtatusid ,COUNT(distinct t1.id) AS resultcount";
	String sqlWhere = "t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.relateditemid";
	String groupby = "t1.endtatusid";
	
	String tableString =" <table instanceid=\"info\"  pageId=\""+PageIdConst.CRM_RPSellChanceDown+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_RPSellChanceDown,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"none\">"+ 
    "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+sqlWhere+"\"  "+
    	"sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.endtatusid\" sqlsortway=\"Desc\" sqlgroupby=\""+groupby+"\"  sumColumns=\"resultcount\" />"+
    "<head>"+
    "<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(15112,user.getLanguage()) +"\" column=\"endtatusid\""+
    	" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getSellChanceActiveName\"/>"+ 
   	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(15258,user.getLanguage())+SystemEnv.getHtmlLabelName(1331,user.getLanguage()) +"\" column=\"resultcount\""+
		" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getSellChanceInfo\" otherpara=\"column:endtatusid\"/>"+ 
	"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(31143,user.getLanguage()) +"\" column=\"resultcount\" "+
		" algorithmdesc=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"="+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(1331,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(523,user.getLanguage())+"\""+
		" molecular=\"resultcount\" denominator=\"sum:resultcount\"/>"+
	"</head>"+   			
	"</table>";
	
	// System.err.println("select "+backfields+" from "+ fromSql+" where "+sqlWhere+" group by "+groupby);
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(15112,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			
		</wea:item>
	</wea:group>
</wea:layout>
<form action="CustomerDescRpSum.jsp" method="post" name="weaver">
	<input type="hidden" name="searchName" value="<%=searchName %>">
</form>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_RPSellChanceDown%>">
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</BODY>

</HTML>
