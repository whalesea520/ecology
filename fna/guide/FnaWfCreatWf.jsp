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

SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
ManageDetachComInfo manageDetachComInfo = new ManageDetachComInfo();
CheckSubCompanyRight checkSubCompanyRight = new CheckSubCompanyRight();

String r = FnaCommon.getPrimaryKeyGuid1();
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(83182,user.getLanguage());
String needfav ="1";
String needhelp ="";

String creatType = Util.null2String(request.getParameter("creatType")).trim();
int fnaFeeWfInfoId = Util.getIntValue(request.getParameter("fnaFeeWfInfoId"), 0);
int formid = Util.getIntValue(request.getParameter("formid"), 0);
int isFnaFeeDtl = Util.getIntValue(request.getParameter("isFnaFeeDtl"), 0);
int enableRepayment = Util.getIntValue(request.getParameter("enableRepayment"), 0);
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"), 0);

String wfName = "";
rs.executeSql("select a.namelabel from workflow_bill a where a.id = "+formid);
if(rs.next()){
	int _namelabel = rs.getInt("namelabel");
	wfName = SystemEnv.getHtmlLabelName(_namelabel, user.getLanguage());
	if("".equals(wfName)){
		wfName = SystemEnv.getHtmlLabelName(_namelabel, 7);
	}
}

%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.moduledetach.ManageDetachComInfo"%>
<%@page import="weaver.systeminfo.systemright.CheckSubCompanyRight"%>
<%@page import="weaver.workflow.workflow.WfRightManager"%><HTML><HEAD>
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
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(127035, user.getLanguage())
			+ ",javascript:fnaWfCreatWf_doSave("+formid+"),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<form action="">
	<input id="subcompanyid" name="subcompanyid" type="hidden" value="<%=subcompanyid %>" />
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
	<div class="fnaContent fnaContent1"><%=SystemEnv.getHtmlLabelName(127035,user.getLanguage())%></div><!-- 初始化流程路径 -->
	<div class="fnaContent fnaContent2"><%=SystemEnv.getHtmlLabelName(127036,user.getLanguage())%></div><!-- （填写路径基本信息后，点击【初始化流程路径】按钮进行初始化） -->
	<div class="fnaContent fnaContent3">
		<div class="fnaContentSubDiv1">
			<%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%>：
		</div>
		<div class="fnaContentSubDiv2">
			<wea:required id="wfNameSpan" required="true" value="<%=FnaCommon.escapeHtml(wfName) %>">
				<input class="inputstyle" id="wfName" name="wfName" maxlength="80" style="width: 196px;" value="<%=FnaCommon.escapeHtml(wfName) %>" 
	   	   			onchange='checkinput("wfName","wfNameSpan");' />
			</wea:required>
		</div>
	</div>
	<div class="fnaContent fnaContent6">
		<div class="fnaContentSubDiv1">
			<%=SystemEnv.getHtmlLabelName(33806,user.getLanguage())%>：
		</div>
		<div class="fnaContentSubDiv2">
		    <select id="wfTypeid" name="wfTypeid" style="width: 198px;" notBeauty="true">
		    <%
		    rs.executeSql("select id,typename from workflow_type order by dsporder asc,id asc");
		    while(rs.next()){
			%>
				<option value="<%=Util.getIntValue(rs.getString("id"))%>"><%=FnaCommon.escapeHtml(Util.null2String(rs.getString("typename")))%></option>
			<%}%>
		    </select>
		</div>
	</div>
	<div class="fnaContent fnaContent4">
   		<input class="e8_btn_top" type="button" id="btnSave" onclick="fnaWfCreatWf_doSave(<%=fnaFeeWfInfoId %>, <%=formid %>, <%=isFnaFeeDtl %>, <%=enableRepayment %>);" 
   	   		style="width: 140px;height: 40px;background-color: #30b5ff;color: #FFF;" 
   			value="<%=SystemEnv.getHtmlLabelName(127035,user.getLanguage())%>"/><!-- 初始化流程路径 -->
	</div>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" id="btnPrevious" 
    			onclick="goToUrl('/fna/guide/FnaWfEditForm.jsp?creatType=<%=creatType %>&subcompanyid=<%=subcompanyid %>&fnaFeeWfInfoId=<%=fnaFeeWfInfoId %>&formid=<%=formid %>&isFnaFeeDtl=<%=isFnaFeeDtl %>&enableRepayment=<%=enableRepayment %>');" 
    			value="<%=SystemEnv.getHtmlLabelName(1876,user.getLanguage())%>"/><!-- 上一步 -->
    		<input class="zd_btn_cancle" type="button" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
</BODY>
</HTML>
