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
int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
int isFnaFeeDtl = Util.getIntValue(request.getParameter("isFnaFeeDtl"), 0);
int enableRepayment = Util.getIntValue(request.getParameter("enableRepayment"), 0);
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"), 0);


String openUrl = "";
String openTitleName = "";
if("borrow".equals(creatType)){//借款流程
	openUrl = "/fna/budget/wfset/FnaBorrowWfSetEditPage.jsp?id="+fnaFeeWfInfoId+"&tabId=2";
	openTitleName = SystemEnv.getHtmlLabelNames("83182",user.getLanguage());
}else if("repayment".equals(creatType)){//还款流程
	openUrl = "/fna/budget/wfset/FnaRepaymentWfSetEditPage.jsp?id="+fnaFeeWfInfoId+"&tabId=2";
	openTitleName = SystemEnv.getHtmlLabelNames("83183",user.getLanguage());
}else if("fnaFeeWf".equals(creatType)){//费用报销流程
	openUrl = "/fna/budget/FnaWfSetEditPage.jsp?id="+fnaFeeWfInfoId+"&tabId=2";
	openTitleName = SystemEnv.getHtmlLabelNames("24787",user.getLanguage());
}else if("change".equals(creatType)){//预算变更流程
	openUrl = "/fna/budget/wfset/budgetChange/FnaChangeWfSetEditPage.jsp?id="+fnaFeeWfInfoId+"&tabId=2";
	openTitleName = SystemEnv.getHtmlLabelNames("124864",user.getLanguage());
}else if("share".equals(creatType)){//费用分摊流程
	openUrl = "/fna/budget/wfset/budgetShare/FnaShareWfSetEditPage.jsp?id="+fnaFeeWfInfoId+"&tabId=2";
	openTitleName = SystemEnv.getHtmlLabelNames("124980",user.getLanguage());
}
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<form action="">
	<div class="fnaTitle1">3、<%= SystemEnv.getHtmlLabelName(555,user.getLanguage())%></div><!-- 完成 -->
	<div class="u_line u444_line u444_line1"></div>
	<div class="u_node u438_node">
		<font class="u_nodeFont">1</font>		
	</div>
	<div class="u_line u444_line u444_line3"></div>
	<div class="u_node u438_node">
		<font class="u_nodeFont">2</font>		
	</div>
	<div class="u_line u444_line u444_line3"></div>
	<div class="u_node u438_node">
		<font class="u_nodeFont">3</font>		
	</div>
	<div class="u_line u444_line u444_line1"></div>
	<div class="fnaContent fnaContent1">
		<img alt="OK" src="/images/ok.png" />
		<%=SystemEnv.getHtmlLabelName(127104,user.getLanguage())%><!-- 流程创建完毕 -->
	</div>
	<div class="fnaContent fnaContent2">
		<%=SystemEnv.getHtmlLabelName(127105,user.getLanguage())%><!-- 1、请确认流程路径是否设置了节点操作者，如未设置请进行配置： -->
   		<input class="e8_btn_top" type="button" id="btnSave" onclick="openEditWf(<%=wfid %>, '<%=SystemEnv.getHtmlLabelName(33488,user.getLanguage()) %>');" 
   	   		style="margin-left: 1px;" 
   			value="<%=SystemEnv.getHtmlLabelName(33488,user.getLanguage()) %>"/><!-- 流转设置 -->
	</div>
	<div class="fnaContent fnaContent2">
		<%=SystemEnv.getHtmlLabelName(127106,user.getLanguage())%><!-- 2、请确认财务流程详细设置： -->
   		<input class="e8_btn_top" type="button" id="btnSave" onclick="openEditFnaFeeWfInfo('<%=openUrl %>', '<%=openTitleName %>');" 
   	   		style="margin-left: 1px;" 
   			value="<%=openTitleName %>"/><!-- XX流程 -->
	</div>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" id="btnPrevious" 
    			onclick="goToUrl('/fna/guide/FnaWfEditWf.jsp?wfid=<%=wfid %>&subcompanyid=<%=subcompanyid %>&creatType=<%=creatType %>&fnaFeeWfInfoId=<%=fnaFeeWfInfoId %>&formid=<%=formid %>&isFnaFeeDtl=<%=isFnaFeeDtl %>&enableRepayment=<%=enableRepayment %>');" 
    			value="<%=SystemEnv.getHtmlLabelName(1876,user.getLanguage())%>"/><!-- 上一步 -->
    		<input class="zd_btn_cancle" type="button" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 关闭 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
</BODY>
</HTML>
