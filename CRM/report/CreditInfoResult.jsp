<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
</HEAD>
<%
String credit = Util.null2String(request.getParameter("credit"));
String sqlTerm = Util.null2String(request.getParameter("sqlterm"));

String userId = String.valueOf(user.getUID());


String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage()) + SystemEnv.getHtmlLabelName(356,user.getLanguage());
String needfav ="1";
String needhelp ="";

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
int pagesize = 10;
String orderby = "t1.id";
String fromSql = "CRM_customerinfo t1, CRM_CreditInfo t2, "+leftjointable+"t3";
String backfields = "t1.id, t1.name, t1.manager, t1.website";
String sqlWhere = "t1.id = t3.relateditemid and t2.id = "+credit+" AND t1.CreditAmount >= t2.creditamount AND t1.CreditAmount <= t2.highamount "+sqlTerm;
if(!user.getLogintype().equals("1")){
	fromSql = "CRM_customerinfo t1, CRM_CreditInfo t2";
	sqlWhere = "t1.agent ="+userId+" AND t2.id = "+credit+" AND t1.CreditAmount >= t2.creditamount AND t1.CreditAmount <= t2.highamount "+sqlTerm;
}


String tableString =" <table instanceid=\"info\"  pagesize=\""+pagesize+"\" tabletype=\"none\">"+ 
"<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  "+
	"sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" />"+
"<head>"+
"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(1268,user.getLanguage()) +"\" column=\"id\""+
	" href=\"/CRM/data/ViewCustomer.jsp\" linkkey=\"CustomerID\" linkvaluecolumn=\"id\" target=\"_blank\""+
	" transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\"/>"+ 
"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(1278,user.getLanguage()) +"\" column=\"manager\""+
	" transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename' href='/hrm/resource/HrmResource.jsp' linkkey='id'  target='_blank'/>"+ 
"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(227,user.getLanguage()) +"\" column=\"website\" />"+
"</head>"+   			
"</table>";

%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(20323,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="菜单" class="cornerMenu"></span>
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

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

</BODY>
</HTML>
