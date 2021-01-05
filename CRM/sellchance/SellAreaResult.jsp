
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(6146,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15114,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(800,user.getLanguage())+"-"+ "<a href='/CRM/sellchance/SellAreaCityRpSum.jsp' >"+SystemEnv.getHtmlLabelName(493,user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
	String provinceId = Util.null2String(request.getParameter("province"));
	String sqlTerm = Util.null2String(request.getParameter("sqlterm"));
	
	String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
	int pagesize = 10;
	String orderby = "t1.id";
	String fromSql = "CRM_customerinfo t1, CRM_Contract t3,"+leftjointable+" t2";
	String backfields = "  t1.id, t1.name, t1.manager, t1.website";
	String sqlWhere = "t3.crmId = t2.relateditemid AND t3.crmId = t1.id AND t3.status >= 2 AND t1.province = " + provinceId+sqlTerm;
	
	String tableString =" <table instanceid=\"info\"  pagesize=\""+pagesize+"\" tabletype=\"none\">"+ 
	"<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  "+
		" sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" sqlisdistinct=\"distinct\"/>"+
	"<head>"+
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(1268,user.getLanguage()) +"\" column=\"name\""+
		" href=\"/CRM/data/ViewCustomer.jsp\" linkkey=\"CustomerID\" linkvaluecolumn=\"id\" target=\"_blank\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(1278,user.getLanguage())+"\" column=\"name\"/>"+
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(227,user.getLanguage()) +"\" column=\"website\"/>"+ 
	"</head>"+   			
	"</table>";
	
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(20323,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<BODY>


</BODY>
</HTML>
