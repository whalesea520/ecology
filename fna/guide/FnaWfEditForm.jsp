<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//new LabelComInfo().removeLabelCache();
if(!HrmUserVarify.checkUserRight("CostControlProcedure:set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String r = FnaCommon.getPrimaryKeyGuid1();
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(83182,user.getLanguage());
String needfav ="1";
String needhelp ="";

int isFromMode = 0;

String creatType = Util.null2String(request.getParameter("creatType")).trim();
int fnaFeeWfInfoId = Util.getIntValue(request.getParameter("fnaFeeWfInfoId"), 0);
int formid = Util.getIntValue(request.getParameter("formid"), 0);
int isFnaFeeDtl = Util.getIntValue(request.getParameter("isFnaFeeDtl"), 0);
int enableRepayment = Util.getIntValue(request.getParameter("enableRepayment"), 0);
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"), 0);

//设置好搜索条件
String sqlInner = "	select a.id, a.fieldname, a.fieldlabel, a.viewtype, \n" +
	"		a.detailtable, a.fieldhtmltype, a.type, a.dsporder  \n" +
	"	from workflow_billfield a \n" +
	"	where a.billid = "+formid+" ";

String backFields ="t.*";
String fromSql = " from ("+sqlInner+") t \r";
String sqlWhere = " where 1=1 ";

String orderBy = "case when (t.detailtable is null or t.detailtable = '') then ' ' else t.detailtable end,t.dsporder";

String sqlprimarykey = "t.id";

//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);

String tableString=""+
      "<table instanceid=\"FnaBorrowWfSetEditForm\" pagesize=\"10\" tabletype=\"none\">"+
      "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
      " sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" />"+
      "<head>"+
			"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"fieldname\" orderkey=\"fieldname\" "+//字段名称
				" transmethod=\"weaver.general.FormFieldTransMethod.getFieldDetail\" otherpara=\"column:id+"+formid+"+"+isFromMode+"\" />"+
    		"<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(15456,user.getLanguage())+"\" column=\"fieldlabel\" orderkey=\"fieldlabel\" "+//字段显示名
				" transmethod=\"weaver.general.FormFieldTransMethod.getFieldname\" otherpara=\""+user.getLanguage()+"\" />"+
			"<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(17997,user.getLanguage())+"\" column=\"viewtype\" orderkey=\"viewtype\" "+//字段位置
				" transmethod=\"weaver.general.FormFieldTransMethod.getViewType\" otherpara=\""+user.getLanguage()+"\" />"+
			"<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(687,user.getLanguage())+"\" column=\"fieldhtmltype\" orderkey=\"fieldhtmltype\" "+//表现形式
				" transmethod=\"weaver.general.FormFieldTransMethod.getHTMLType\" otherpara=\""+user.getLanguage()+"\" />"+
			"<col width=\"23%\" text=\""+SystemEnv.getHtmlLabelName(686,user.getLanguage())+"\" column=\"type\" orderkey=\"type\" "+//字段类型
				" transmethod=\"weaver.general.FormFieldTransMethod.getFieldType\" otherpara=\"column:fieldhtmltype+column:id+"+user.getLanguage()+"\" />"+
			"<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dsporder\" orderkey=\"dsporder\" "+//显示顺序
				" />"+
      "</head>"+
      "</table>";
%>
<%@page import="weaver.fna.general.FnaCommon"%><HTML><HEAD>
<link href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<script language=javascript>
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...
var _getHtmlLabelName30702 = "<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage()) %>";//必填信息不完整
var _creatType = "<%=creatType %>";
</script>
<script language="javascript" src="/fna/guide/css/fna_guide_css_01_wev8.js?r=<%=r %>"></script>
<link href="/fna/guide/css/fna_guide_css_01_wev8.css?r=<%=r %>" type="text/css" rel="STYLESHEET"/>
</head>
<body style="">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(127040, user.getLanguage())
			+ ",javascript:doRefreshGrid(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content" style="overflow: hidden;">
<form action="">
	<div class="fnaTitle1">1、<%= SystemEnv.getHtmlLabelName(127027,user.getLanguage())%></div><!-- 创建表单 -->
	<div class="u_line u444_line u444_line1"></div>
	<div class="u_node u438_node">
		<font class="u_nodeFont">1</font>		
	</div>
	<div class="u_line u437_line u437_line1"></div>
	<div class="u_node u440_node">
		<font class="u_nodeFont">2</font>		
	</div>
	<div class="u_line u437_line u437_line1"></div>
	<div class="u_node u440_node">
		<font class="u_nodeFont">3</font>		
	</div>
	<div class="u_line u437_line u437_line2"></div>
	<div class="fnaContent">
		<img class="fnaImgRefresh" alt="refresh" src="/images/refresh.png" onclick="doRefreshGrid();"/>
	</div>
	<div class="fnaContent">
		<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
	</div>
	<div class="fnaContent fnaContent5">
		<!-- 表单已初始化成功，您可以根据需要 -->
		<%=SystemEnv.getHtmlLabelName(127033,user.getLanguage()) %>
   		<input class="e8_btn_top" type="button" id="btnSave" onclick="openEditForm(<%=formid %>, '<%=SystemEnv.getHtmlLabelName(82022,user.getLanguage()) %>');" 
   	   		style="margin-left: 1px;" 
   			value="<%=SystemEnv.getHtmlLabelName(82022,user.getLanguage()) %>"/><!-- 编辑表单 -->；
		<!-- 或进入下一步。 -->
		<%=SystemEnv.getHtmlLabelName(127034,user.getLanguage()) %>
	</div>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" id="btnNext" 
    			onclick="goToUrl('/fna/guide/FnaWfCreatWf.jsp?creatType=<%=creatType %>&subcompanyid=<%=subcompanyid %>&fnaFeeWfInfoId=<%=fnaFeeWfInfoId %>&formid=<%=formid %>&isFnaFeeDtl=<%=isFnaFeeDtl %>&enableRepayment=<%=enableRepayment %>');" 
    			value="<%=SystemEnv.getHtmlLabelName(1402,user.getLanguage())%>"/><!-- 下一步 -->
    		<input class="zd_btn_cancle" type="button" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
</BODY>
</HTML>
