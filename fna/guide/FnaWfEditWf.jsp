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
	<div class="fnaTitle1">2、<%= SystemEnv.getHtmlLabelName(127037,user.getLanguage())%></div><!-- 创建流程路径 -->
	<div class="u_line u444_line u444_line1"></div>
	<div class="u_node u438_node">
		<font class="u_nodeFont">1</font>		
	</div>
	<div class="u_line u444_line u444_line3"></div>
	<div class="u_node u438_node">
		<font class="u_nodeFont">2</font>		
	</div>
	<div class="u_line u437_line u437_line1"></div>
	<div class="u_node u440_node">
		<font class="u_nodeFont">3</font>		
	</div>
	<div class="u_line u437_line u437_line2"></div>
	<div class="fnaContent fnaContentGrid2">
		<iframe name="innerFrame" id="innerFrame" src="/workflow/design/wfdesign_readonly.jsp?wfid=<%=wfid %>&type=view&isFullScreen=false&r=<%=r %>" 
			width="740" height="366" frameborder="no" scrolling="no">
			浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</iframe>
	</div>
	<div class="fnaContent fnaContent5">
		<!-- 流程路径已初始化成功，您可以打开 -->
		<%=SystemEnv.getHtmlLabelName(127038,user.getLanguage()) %>
   		<input class="e8_btn_top" type="button" id="btnSave" onclick="openEditWf(<%=wfid %>, '<%=SystemEnv.getHtmlLabelName(33488,user.getLanguage()) %>');" 
   	   		style="margin-left: 1px;" 
   			value="<%=SystemEnv.getHtmlLabelName(33488,user.getLanguage()) %>"/><!-- 流转设置 -->；
		<!-- 设置节点操作者， 或进入下一步，等完成新建后再设置节点操作者。 -->
		<%=SystemEnv.getHtmlLabelName(127039,user.getLanguage()) %>
	</div>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" id="btnNext" 
    			onclick="goToUrl('/fna/guide/FnaWfCreatDone.jsp?wfid=<%=wfid %>&subcompanyid=<%=subcompanyid %>&creatType=<%=creatType %>&fnaFeeWfInfoId=<%=fnaFeeWfInfoId %>&formid=<%=formid %>&isFnaFeeDtl=<%=isFnaFeeDtl %>&enableRepayment=<%=enableRepayment %>');" 
    			value="<%=SystemEnv.getHtmlLabelName(1402,user.getLanguage())%>"/><!-- 下一步 -->
    		<input class="zd_btn_cancle" type="button" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
</BODY>
</HTML>
