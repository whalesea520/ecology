
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>
<%
	String assortmentid = Util.null2String(request.getParameter("assortmentid"));
	String assetname = Util.null2String(request.getParameter("assetname"));
	String sqlWhere = "";
	if(!assortmentid.equals("")){
		sqlWhere += " and t1.assortmentid = "+assortmentid;
	}
	if(!assetname.equals("")){
		sqlWhere += " and t2.assetname like '%"+assetname+"%'";
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(602,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
	//原始页面未采用分页控件，现在改成分页控件 add by Dracula @2014-1-23
	String otherpara = "column:assetid";
	String tableString = "";
	String backfields = " t2.assetid,t2.assetname,t1.assetunitid,t2.currencyid,t2.salesprice,t1.assortmentid,t1.assortmentstr ";
	String fromSql = " LgcAsset t1,LgcAssetCountry t2 ";
	String orderkey = " t2.assetid ";
	sqlWhere = " t1.id=t2.assetid "+sqlWhere;
	tableString = " <table instanceid=\"MaintContacterTitleListTable\"  tabletype=\"none\" pageId=\""+PageIdConst.CRM_ProductReport+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_ProductReport,user.getUID(),PageIdConst.CRM)+"\" >"
	+ "	<sql backfields=\"" + backfields + "\" sqlform=\"" + fromSql + "\" sqlwhere=\"" + Util.toHtmlForSplitPage(sqlWhere) 
	+ "\"  sqlorderby=\"" + orderkey + "\"  sqlprimarykey=\"t2.assetid\" sqlsortway=\"desc\" sqlisdistinct=\"true\" />" ;
	
	tableString += " <head>"; 
	tableString += " <col width=\"20%\"   text=\"" + SystemEnv.getHtmlLabelName(15129,user.getLanguage())
	+ "\" column=\"assetname\" orderkey=\"t2.assetname\"  linkkey=\"t2.assetid\" linkvaluecolumn=\"t2.assetid\" transmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMContacterLinkWithTitle\" otherpara=\""
	+ otherpara + "\" />";
	tableString += " <col width=\"10%\"  text=\"" + SystemEnv.getHtmlLabelName(705,user.getLanguage())
	+ "\" column=\"assetunitid\" orderkey=\"t1.assetunitid\" transmethod =\"weaver.lgc.maintenance.AssetUnitComInfo.getAssetUnitname\" />";
	tableString += " <col width=\"20%\"  text=\"" + SystemEnv.getHtmlLabelName(726,user.getLanguage())
	+ "\" column=\"currencyid\" orderkey=\"t2.currencyid\" transmethod =\"weaver.fna.maintenance.CurrencyComInfo.getCurrencyname1\" otherpara=\"column:salesprice\"/>";
	tableString += " <col width=\"30%\"  text=\"" + SystemEnv.getHtmlLabelName(178,user.getLanguage())
	+ "\" column=\"assortmentid\" orderkey=\"t1.assortmentid\" transmethod =\"weaver.lgc.maintenance.LgcAssortmentComInfo.getAssortmentFullName\"/>";
	
	tableString += " </head></table>";
%>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="text" class="searchInput" value="<%=assetname %>" id="searchName" name="searchName"/>
			<span id="advancedSearch" class="advancedSearch">高级搜索</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<form action="/lgc/search/LgcProductReportList.jsp" method="post" name="weaver">
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >	
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage()) %>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="assortmentid" 
	               	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	               	browserSpanValue='<%=Util.toScreen(LgcAssortmentComInfo.getAssortmentFullName(assortmentid),user.getLanguage()) %>' 
	               	browserValue='<%=assortmentid  %>'
	               	browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowser.jsp?newtype=product"
	               	completeUrl="/data.jsp?type=-99994" width='267px'>
	       		</brow:browser>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="text" class=InputStyle  name=assetname id="assetname" value="<%=assetname%>" style="width: 180px;">
			</wea:item>
		</wea:group>
		
		<wea:group context="" attributes="{'Display':'none'}">
			<wea:item type="toolbar">
				<input type="submit" class="e8_btn_submit" value="搜索" id="searchBtn"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="重置" class="e8_btn_cancel" onclick="resetCondition()"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="取消" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</form>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_ProductReport%>">
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
								

<script type="text/javascript">

$(document).ready(function(){
			
	jQuery("#topTitle").topMenuTitle({searchFn:searchName});
	jQuery("#hoverBtnSpan").hoverBtn();
});
function searchName(){
	var searchName = jQuery("#searchName").val();
	jQuery("#assetname").val(searchName);
	window.weaver.submit();
}
</script>
</BODY>
</HTML>
