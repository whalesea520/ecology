<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.general.BrowserElement"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />

<%
if(!HrmUserVarify.checkUserRight("FinanceWriteOff:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();
DecimalFormat df = new DecimalFormat("###################################################0.00");

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16506,user.getLanguage());//财务销帐
String needfav ="1";
String needhelp ="";

int id = Util.getIntValue(request.getParameter("id"));

String loantype = "";
String organizationid = "";
String organizationtype = "";
String occurdate = "";
String amount = "";
String debitremark = "";
String remark = "";
String requestid = "";
String relatedcrm = "";
String relatedprj = "";
String processorid = "";

String sql = "select * from " +
        "FnaLoanInfo" +
        " where id = "+id;
rs.executeSql(sql);
if(rs.next()){
	loantype = Util.null2String(rs.getString("loantype"));
	organizationid = Util.null2String(rs.getString("organizationid"));
	organizationtype = Util.null2String(rs.getString("organizationtype"));
	occurdate = Util.null2String(rs.getString("occurdate"));
	amount = df.format(Util.getDoubleValue(rs.getString("amount"), 0.00));
	debitremark = Util.null2String(rs.getString("debitremark"));
	remark = Util.null2String(rs.getString("remark"));
	requestid = Util.null2String(rs.getString("requestid"));
	relatedcrm = Util.null2String(rs.getString("relatedcrm"));
	relatedprj = Util.null2String(rs.getString("relatedprj"));
	processorid = Util.null2String(rs.getString("processorid"));
}

String orgTypeName = "";
String orgIdName = "";
if ("1".equals(organizationtype)) {
	rs.executeSql("select subcompanyname from HrmSubCompany where id="+Util.getIntValue(organizationid));
	if(rs.next()){
		orgIdName = Util.null2String(rs.getString("subcompanyname")).trim();
	}
	orgTypeName = SystemEnv.getHtmlLabelName(141,user.getLanguage());
} else if ("2".equals(organizationtype)) {
	rs.executeSql("select departmentname from HrmDepartment where id="+Util.getIntValue(organizationid));
	if(rs.next()){
		orgIdName = Util.null2String(rs.getString("departmentname")).trim();
	}
	orgTypeName = SystemEnv.getHtmlLabelName(124,user.getLanguage());
} else if ("3".equals(organizationtype)) {
	rs.executeSql("select lastname from HrmResource where id="+Util.getIntValue(organizationid));
	if(rs.next()){
		orgIdName = Util.null2String(rs.getString("lastname")).trim();
	}
	orgTypeName = SystemEnv.getHtmlLabelName(6087,user.getLanguage());
} else if ((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)) {
	rs.executeSql("select name from FnaCostCenter where id="+Util.getIntValue(organizationid));
	if(rs.next()){
		orgIdName = Util.null2String(rs.getString("name")).trim();
	}
	orgTypeName = SystemEnv.getHtmlLabelName(515,user.getLanguage());
}
String operationtype = fnaSplitPageTransmethod.getOperationtype(amount, user.getLanguage()+"");
String reqName = "";
String href = "/workflow/request/ViewRequest.jsp?requestid=" + requestid;
if (!requestid.equals("")) {
    reqName = fnaSplitPageTransmethod.getReqName(requestid, user.getLanguage() + "+" + loantype + "+" + processorid + "+" + amount);
}
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage())
			+ ",javascript:doClose(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td>
		<td class="rightSearchSpan" style="text-align: right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33313,user.getLanguage()) %>"/>
</jsp:include>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(17390,user.getLanguage())%>' attributes="{\"groupDisplay\":\"none\"}" ><!-- 财务销帐处理 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(31915,user.getLanguage())%></wea:item><!-- 操作对象 -->
		<wea:item>
			<%=FnaCommon.escapeHtml(orgIdName+"("+orgTypeName+")") %>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(21663,user.getLanguage())%></wea:item><!-- 操作日期 -->
		<wea:item>
            <%=FnaCommon.escapeHtml(occurdate) %>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%></wea:item><!-- 操作类型 -->
		<wea:item>
        	<%=FnaCommon.escapeHtml(operationtype) %>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></wea:item><!-- 金额 -->
		<wea:item>
            <%=df.format(Math.abs(Util.getDoubleValue(amount))) %>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(874,user.getLanguage())%></wea:item><!-- 凭证号 -->
		<wea:item>
			<%=FnaCommon.escapeHtml(debitremark) %>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></wea:item><!-- 相关流程 -->
		<wea:item>
			<%--<%=FnaCommon.escapeHtml(reqName) %>--%>
            <%=reqName.split("——")[0] + "——"%>
            <a target="_blank" href=<%=href%>><%=reqName.split("——")[1]%></a>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item><!-- 备注 -->
		<wea:item>
			<%=FnaCommon.escapeHtml(remark).replaceAll("\r\n", "<br />") %>
		</wea:item>
    </wea:group>
</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="e8_btn_cancel" type="submit" id="btnClose" onclick="doClose();" 
	    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 关闭 -->
	    	</wea:item>
	    </wea:group>
</wea:layout>
</div>


<script language="javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
});
//关闭
function doClose(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}
function onBtnSearchClick(){}
</script>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
</html>
