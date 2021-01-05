<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.fna.report.FnaReport"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
boolean canview = HrmUserVarify.checkUserRight("LoanRepaymentAnalysis:qry",user) ;
if(user==null || !canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String jklc = Util.null2s(request.getParameter("jklc"),"-100");
int hrmid = Util.getIntValue(request.getParameter("hrmid"), -100);
int applicantid = hrmid;
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:doExpExcel(),_self}";
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=Util.toScreenForWorkflow(SystemEnv.getHtmlLabelName(23891,user.getLanguage())) %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage()) %>" class="e8_btn_top" onclick="doExpExcel()"/><!-- 导出Excel -->
					<span title="<%=SystemEnv.getHtmlLabelNames("83190,83", user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
		
<form action="">
<% 
	//设置好搜索条件
	String backFields = " temp.* ";
	
	String temp = " from ( select  wb.id, wr.requestid, wr.requestname, wr.creater, wr.creatertype, wr.createdate , SUM(fe.amountBorrow * fe.borrowDirection) sum_amountBorrow \n "+
			      " from FnaBorrowInfo fe "+
	 			  " left join workflow_requestbase wr on fe.borrowRequestId = wr.requestid "+
	 			  " left join workflow_base wb on wb.id = wr.workflowid \n" +
	 			  " where fe.applicantid = "+hrmid+" and fe.borrowRequestId in ("+jklc+") "+
	  		      " group by wb.id, wr.requestid, wr.requestname, wr.creater, wr.creatertype, wr.createdate " +
	  		      " )temp ";//临时视图
	
	String fromSql = temp ;
	
	String sqlWhere = "";

	String orderBy = " temp.createdate ";
	
	String sqlprimarykey = " temp.requestid ";

	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	
	String tableString=""+
       "<table pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_RPT_LoanRepaymentAnalysis,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"none\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" "+
      		" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
       " sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"desc\" />"+
       "<head>"+ 
		//"			<col width=\"10%\"  text=\"" + SystemEnv.getHtmlLabelName(28610, user.getLanguage()) + "\" column=\"requestid\" />"+
		
		"			<col width=\"25%\"  text=\"" + SystemEnv.getHtmlLabelName(26876, user.getLanguage()) + "\" orderkey=\"requestname\" column=\"requestname\" "+
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"openWorkflow+column:requestid+column:id\" />" + 
		
		"			<col width=\"25%\"  text=\"" + SystemEnv.getHtmlLabelName(882, user.getLanguage()) + "\" orderkey=\"creater\"  column=\"creater\" "+
					" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" otherpara=\"column:creatertype\" />" + 
		
		"			<col width=\"25%\"  text=\"" + SystemEnv.getHtmlLabelName(1339, user.getLanguage()) + "\" orderkey=\"createdate\"  column=\"createdate\" />"+
		"			<col width=\"25%\"  text=\"" + SystemEnv.getHtmlLabelName(83288, user.getLanguage()) + "\" orderkey=\"sum_amountBorrow\" column=\"sum_amountBorrow\" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmount\" />";
	tableString += "</head>"+ "</table>";
%>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</form>
<iframe id="dwnfrm" name="dwnfrm" src="" style="display:none"></iframe>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 关闭 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script language=javascript>
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

var applicantid = "<%=applicantid %>";
var currentUid = "<%=user.getUID() %>";

var hrmid = "<%=hrmid %>";
var jklc = "<%=jklc %>";

jQuery(document).ready(function(){
	resizeDialog(document);
});  

/* 打开流程 */
function openWorkflow(requestid,workflowid){
	window.open("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&_workflowid="+workflowid+"&_workflowtype=&isovertime=0&LoanRepaymentAnalysisInnerDetaile=1");
}

//递归判断父元素（上层4级之内）中是否存在className等于ListStyle的元素，如果是则表示是分页控件的下级元素，返回true
function getFirstParentTrObj(_obj, _deep){
	if(_deep > 5){
		return false;
	}
	_deep = _deep+1;
	_obj = jQuery(_obj);
	var className = _obj.attr("className");
	if(className=="ListStyle"){
		return true;
	}else{
		return getFirstParentTrObj(_obj.parent(), _deep);
	}
}

//导出Excel
function doExpExcel(){
	//alert(148);
	document.getElementById("dwnfrm").src = "/fna/report/LoanRepaymentAnalysis/LoanRepaymentAnalysisDetailExcel.jsp?hrmid="+hrmid+"&jklc="+jklc;
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
}

//关闭
function doClose(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}
</script>
</BODY>
</HTML>
