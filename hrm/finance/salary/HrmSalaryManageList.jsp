
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String titlename = SystemEnv.getHtmlLabelName(32653,user.getLanguage());
String qname = Util.null2String(request.getParameter("flowTitle"));
String yearmonth = Util.null2String(request.getParameter("yearmonth"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));

boolean hasright = true;
if (!HrmUserVarify.checkUserRight("Compensation:Manager", user)) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>
<body>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function openDialog(id,otherPara){
	window.location.href="HrmSalaryManageView.jsp?subCompanyId="+id+"&yearmonth="+otherPara;
}
</script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		 	<wea:item><%=SystemEnv.getHtmlLabelName(1878,user.getLanguage())%></wea:item>
	    <wea:item>
	     	<brow:browser viewType="0" name="subcompanyid" browserValue='<%=subcompanyid %>' 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
	         hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	         completeUrl="/data.jsp?type=164"
	         browserSpanValue='<%=Util.toScreen(SubCompanyComInfo.getSubcompanyname(subcompanyid),user.getLanguage()) %>'>
	      </brow:browser>
	    </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(19554,user.getLanguage())%></wea:item>
		  <wea:item>
		    <BUTTON class=calendar type=button id=SelectDate onclick=getSdDate(yearmonthspan,yearmonth)></BUTTON>&nbsp;
	      <SPAN id="yearmonthspan" name="yearmonthspan" style="FONT-SIZE: x-small"><%=yearmonth%></SPAN>
	      <input class=inputstyle type="hidden" name="yearmonth" value=<%=yearmonth%>>
		  </wea:item>
    </wea:group>
    <wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</form>
<%
String backfields = " a.id, subcompanyid1, a.paydate, count(distinct c.id) as empNum";
String fromSql  = " from HrmSalarypay a, HrmSalarypaydetail b, HrmResource c ";
String sqlWhere = " where a.id = b.payid and b.hrmid = c.id and c.status in (0,1,2,3) ";
String groupby = " a.id, subcompanyid1, a.paydate " ;
String orderby = " a.paydate " ;
String tableString = "";

if(qname.length()>0){
	sqlWhere += " and exists(select * from hrmsubcompany where c.subcompanyid1 = hrmsubcompany.id and subcompanyname like '%"+qname+"%' ) ";
}

if(subcompanyid.length()>0){
	sqlWhere += " and c.subcompanyid1="+subcompanyid;
}

if(yearmonth.length()>0){
	sqlWhere += " and a.paydate='"+yearmonth+"'";
}

//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
operateString+="     <operate href=\"javascript:openDialog();\" otherpara=\"column:paydate\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
//operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
operateString+="</operates>";	
 
tableString =" <table pageId=\""+PageIdConst.HRM_SalaryManageList+"\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_SalaryManageList,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.job.SpecialityComInfo.getSpecialtityCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlgroupby=\""+groupby+"\" sqlorderby=\""+orderby+"\"  sqlprimarykey=\"subcompanyid1\" sqlsortway=\"Asc\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"25%\" text=\""+ SystemEnv.getHtmlLabelName(1878,user.getLanguage())+"\" column=\"subcompanyid1\" orderkey=\"subcompanyid1\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />"+
    "				<col width=\"25%\" text=\""+ SystemEnv.getHtmlLabelName(33370,user.getLanguage())+"\" column=\"paydate\" orderkey=\"paydate\" />"+
    "				<col width=\"25%\" text=\""+ SystemEnv.getHtmlLabelName(19556,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmSalaryPayStatus\" otherpara=\""+user.getLanguage()+"+"+"column:subcompanyid1+"+user.getUID()+"\" />"+
    "				<col width=\"25%\" text=\""+ SystemEnv.getHtmlLabelName(1859,user.getLanguage())+"\" column=\"empNum\" orderkey=\"empNum\" />"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_SalaryManageList %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
