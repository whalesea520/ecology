
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
 <%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(63,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
jQuery(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:searchInfo});
	jQuery("#hoverBtnSpan").hoverBtn();
});

function searchInfo(){
	 jQuery("input[name='searchName']").val(jQuery("#searchName").val());
	 window.weaver.submit();
}

function showDetailInfo(settype , id){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(20323,user.getLanguage()) %>";
	dialog.Width = 800;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = "/CRM/search/SearchOperation.jsp?msg=report&settype="+settype+"&id="+id;
	dialog.show();
}

</script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</head>

<%
	String searchName = Util.null2String(request.getParameter("searchName"));
	String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
	int pagesize = 10;
	String orderby = "resultcount";
	String fromSql = "CRM_CustomerInfo t1, "+leftjointable+" t2 ";
	String backfields = "t1.type ,COUNT(distinct t1.id) AS resultcount";
	String sqlWhere = null;
	String groupby = "t1.type";
	if(user.getLogintype().equals("1")){
		sqlWhere = " t1.id = t2.relateditemid and t1.deleted = 0  ";
	}else{
		sqlWhere = " t1.agent="+user.getUID() + "  and t1.deleted = 0  ";
	}
	
	if(!"".equals(searchName)){
		fromSql += ", CRM_CustomerType t3";
		sqlWhere += " and t3.id = t1.type and t3.fullname like '%"+searchName+"%'";
	}
	
	String tableString =" <table instanceid=\"info\"  pageId=\""+PageIdConst.CRM_RPtype+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_RPtype,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"none\">"+ 
    "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+sqlWhere+"\"  "+
    	"sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.type\" sqlsortway=\"Desc\" sqlgroupby=\""+groupby+"\"  sumColumns=\"resultcount\" />"+
    "<head>"+
    "<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(63,user.getLanguage()) +"\" column=\"type\""+
    	" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getCustomerTypeName\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(1331,user.getLanguage()) +"\" column=\"resultcount\""+
		" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getCustomerInfo\" otherpara=\"customertype+column:type\"/>"+ 
	"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(31143,user.getLanguage()) +"\" column=\"resultcount\" "+
		" algorithmdesc=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"="+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(1331,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(523,user.getLanguage())+"\""+
		" molecular=\"resultcount\" denominator=\"sum:resultcount\"/>"+
	"</head>"+   			
	"</table>";
	
%>

<BODY>


<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(1282,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			
			<input type="text" class="searchInput"  id="searchName" value="<%=searchName %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form action="CustomerTypeRpSum.jsp" method="post" name="weaver">
	<input type="hidden" name="searchName" value="<%=searchName %>">
</form>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_RPtype%>">
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</BODY>

</HTML>
