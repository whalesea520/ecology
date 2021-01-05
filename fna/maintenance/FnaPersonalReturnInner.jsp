<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
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

FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
boolean fnaBudgetOAOrg = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetOAOrg());
boolean fnaBudgetCostCenter = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetCostCenter());

fnaBudgetCostCenter = false;//成本中心

BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16506,user.getLanguage());//财务销帐
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

String organizationtype = Util.null2String(request.getParameter("organizationtype")).trim();
if("".equals(organizationtype)){
	organizationtype = "3";
}
String organizationid = Util.null2String(request.getParameter("organizationid")).trim();
String subId = "";
String depId = "";
String hrmId = "";
String fccId = "";

String shownameHrm = "";
String shownameDep = "";
String shownameSub = "";
String shownameFcc = "";
if ("1".equals(organizationtype)) {
	rs.executeSql("select subcompanyname from HrmSubCompany where id="+Util.getIntValue(organizationid));
	if(rs.next()){
		shownameSub = Util.null2String(rs.getString("subcompanyname")).trim();
	}
	subId = organizationid;
} else if ("2".equals(organizationtype)) {
	rs.executeSql("select departmentname from HrmDepartment where id="+Util.getIntValue(organizationid));
	if(rs.next()){
		shownameDep = Util.null2String(rs.getString("departmentname")).trim();
	}
	depId = organizationid;
} else if ("3".equals(organizationtype)) {
	rs.executeSql("select lastname from HrmResource where id="+Util.getIntValue(organizationid));
	if(rs.next()){
		shownameHrm = Util.null2String(rs.getString("lastname")).trim();
	}
	hrmId = organizationid;
} else if ((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)) {
	rs.executeSql("select name from FnaCostCenter where id="+Util.getIntValue(organizationid));
	if(rs.next()){
		shownameFcc = Util.null2String(rs.getString("name")).trim();
	}
	fccId = organizationid;
}
String sqrq = Util.null2String(request.getParameter("field2_back")).trim();


%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_TOP}";
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="form2" method="post" action="/fna/maintenance/FnaPersonalReturnInner.jsp">
<input id="operation" name="operation" value="" type="hidden" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" 
				class="e8_btn_top" onclick="doSave();"/><!-- 保存 -->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<%
	DecimalFormat df = new DecimalFormat("#################################################0.00");
// 	int perpage = 1000000;
	
	//设置好搜索条件
	//String sql="select * from fnaloaninfo where organizationtype="+organizationtype+" and organizationid="+organizationid+" order by occurdate";
	String backFields =" a.* ";
	String fromSql = " from fnaloaninfo a ";
	String sqlWhere = " where a.organizationtype="+Util.getIntValue(organizationtype)+" and a.organizationid="+Util.getIntValue(organizationid)+" ";
	String orderBy=" a.occurdate ";

    String loanamount= "" ;
    rs.executeSql("select sum(amount) as amount from fnaloaninfo where organizationtype="+Util.getIntValue(organizationtype)+" and organizationid="+Util.getIntValue(organizationid));
    if(rs.next()){
    	loanamount= df.format(Util.getDoubleValue(rs.getString("amount"), 0.00));
    }
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	
	String tableString=""+
       "<table instanceid=\"FNA_PERSONAL_RETURN_INNER_LIST\" pageId=\""+PageIdConst.FNA_PERSONAL_RETURN_INNER_LIST+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_PERSONAL_RETURN_INNER_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"none\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
       " sqlprimarykey=\"a.id\" sqlsortway=\"desc\" />"+
       "<head>"+
             "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(21663,user.getLanguage())+"\" column=\"occurdate\" orderkey=\"occurdate\" />"+//操作日期
             "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15503,user.getLanguage())+"\" column=\"amount\" "+
                  	" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getOperationtype\" />"+//操作类型
             "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(534,user.getLanguage())+"\" column=\"amount\" orderkey=\"amount\" "+
              		" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountAbs\" align=\"right\" />"+//金额
             "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(874,user.getLanguage())+"\" column=\"debitremark\" orderkey=\"debitremark\" "+//凭证号
      				" transmethod=\"weaver.fna.general.FnaCommon.escapeHtml\" />"+
//             "<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+"\" column=\"requestid\" "+
//             		" otherpara=\""+user.getLanguage()+"+column:loantype+column:processorid\" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getReqName\" />"+//相关流程
            "<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+"\" column=\"requestid\" "+
            " otherpara=\""+user.getLanguage()+"+column:loantype+column:processorid+column:amount\" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getReqName\" />"+//相关流程
       "</head>"+
       "<operates>"+
	   "	<operate href=\"javascript:viewInfo();\" text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\" index=\"0\"/>"+//查看
	   "</operates>"+
       "</table>";
%>
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33186,user.getLanguage())%>'><!-- 做帐处理单 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(31915,user.getLanguage())%></wea:item><!-- 操作对象 -->
			<wea:item>
				<%
				String hrmSel = "";
				String depSel = "";
				String subSel = "";
				String fccSel = "";
				String hrmDisplay = "none";
				String depDisplay = "none";
				String subDisplay = "none";
				String fccDisplay = "none";
				if(organizationtype.equals("3")){
					hrmSel = "selected";
					hrmDisplay = "block";
				}else if(organizationtype.equals("2")){
					depSel = "selected";
					depDisplay = "block";
				}else if(organizationtype.equals("1")){
					subSel = "selected";
					subDisplay = "block";
				}else if(organizationtype.equals(FnaCostCenter.ORGANIZATION_TYPE+"")){
					fccSel = "selected";
					fccDisplay = "block";
				}
				%>
				<select id='organizationtype' name='organizationtype' onchange='organizationtype_onchange();' style="width: 60px;float: left;">
				<%if(fnaBudgetOAOrg){ %>
					<option value="3" <%=hrmSel%>><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option>
					<option value="2" <%=depSel%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
					<option value="1" <%=subSel%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
				<%} %>
				<%if(fnaBudgetCostCenter){ %>
					<option value="<%=FnaCostCenter.ORGANIZATION_TYPE %>" <%=fccSel%>><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></option>
				<%} %>
				</select>
				<input id="organizationid" name="organizationid" value="<%=organizationid %>" type="hidden" />
				
				<%if("3".equals(organizationtype)){ %>
	            <span id="spanHrmId" style="display: <%=hrmDisplay %>;">
			        <brow:browser viewType="0" name="hrmId" browserValue='<%=hrmId %>' 
			                browserUrl='<%=new BrowserComInfo().getBrowserurl("1") +"%3Fshow_virtual_org=-1" %>'
			                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
			                completeUrl="/data.jsp?type=1"  temptitle='<%= SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>'
			                browserSpanValue='<%=FnaCommon.escapeHtml(shownameHrm) %>' width="40%" 
			                _callback="orgId_callback" >
			        </brow:browser>
			    </span>
				<%}else if("2".equals(organizationtype)){ %>
	            <span id="spanDepId" style="display: <%=depDisplay %>;">
			        <brow:browser viewType="0" name="depId" browserValue='<%=depId %>' 
			                browserUrl='<%=new BrowserComInfo().getBrowserurl("4") +"%3Fshow_virtual_org=-1" %>'
			                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
			                completeUrl="/data.jsp?type=4"  temptitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>'
			                browserSpanValue='<%=FnaCommon.escapeHtml(shownameDep) %>' width="40%" 
			                _callback="orgId_callback" >
			        </brow:browser>
			    </span>
				<%}else if("1".equals(organizationtype)){ %>
	            <span id="spanSubId" style="display: <%=subDisplay %>;">
			        <brow:browser viewType="0" name="subId" browserValue='<%=subId %>' 
			                browserUrl='<%=new BrowserComInfo().getBrowserurl("164") +"%3Fshow_virtual_org=-1" %>'
			                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
			                completeUrl="/data.jsp?type=164"  temptitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>'
			                browserSpanValue='<%=FnaCommon.escapeHtml(shownameSub) %>' width="40%" 
			                _callback="orgId_callback" >
			        </brow:browser>
			    </span>
				<%}else if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){ %>
	            <span id="spanFccId" style="display: <%=fccDisplay %>;">
			        <brow:browser viewType="0" name="fccId" browserValue='<%=fccId %>' 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/costCenter/FccBrowserMulti.jsp%3Fselectids=#id#"
			                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
			                completeUrl="/data.jsp?type=FnaCostCenter"  temptitle='<%= SystemEnv.getHtmlLabelName(515,user.getLanguage())%>'
			                browserSpanValue='<%=FnaCommon.escapeHtml(shownameFcc) %>' width="40%" 
			                _callback="orgId_callback" >
			        </brow:browser>
			    </span>
				<%} %>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(21663,user.getLanguage())%></wea:item><!-- 操作日期 -->
			<wea:item>
				<!-- 
				<button class="calendar" 
					onClick="WdatePicker({el:'occurdateSpan',onpicked:function(dp){occurdateOnpicked(dp);},oncleared:function(dp){occurdateOncleared();}});return false;" 
					style="cursor:pointer;"></button>
	            <span id="occurdateSpan"></span>
	            <span id="occurdateSpan2"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
	            <input id="occurdate" name="occurdate" type="hidden" /> 
				<input class="wuiDate"  type="hidden" id="occurdate" name="occurdate" value="" />
				 -->
				<button class="Calendar" type="button" id=occurdatedate onclick="onShowDate(occurdatespan,occurdate)"></button>
				<span id=occurdatespan><img src="/images/BacoError_wev8.gif" align="absMiddle" /></span>
				<input class=inputstyle type="hidden" name="occurdate" id="occurdate" value="" />
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%></wea:item><!-- 操作类型 -->
			<wea:item>
	        	<select id="operationtype" name="operationtype" style="width: 40px;">
	        		<option value="0"><%=SystemEnv.getHtmlLabelName(24862,user.getLanguage())%></option><!-- 冲销 -->
	        		<option value="1"><%=SystemEnv.getHtmlLabelName(24861,user.getLanguage())%></option><!-- 借款 -->
	        	</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></wea:item><!-- 金额 -->
			<wea:item>
	            <INPUT class=inputstyle type=text name="amount" id="amount" style="width: 100px;" />
	            <span id="amountspan"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(874,user.getLanguage())%></wea:item><!-- 凭证号 -->
			<wea:item>
	            <INPUT class=inputstyle type=text size=30 name="debitremark" id="debitremark" style="width: 100px;" onchange="checkinput('debitremark','debitremarkspan')">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></wea:item><!-- 相关流程 -->
			<wea:item>
		        <brow:browser viewType="0" name="requestid" browserValue="" 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("16") %>'
		                hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?type=1"  temptitle='<%= SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>'
		                browserSpanValue="" width="40%">
		        </brow:browser>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item><!-- 备注 -->
			<wea:item>
            	<TEXTAREA class=inputstyle name="summary" id="summary" style="width:80%" rows=3></TEXTAREA>
			</wea:item>
	    </wea:group>
	</wea:layout>
		<wea:layout type="4col">
	    <%
	    String contextHtml = SystemEnv.getHtmlLabelName(17390,user.getLanguage())+
	    	"("+
	    	SystemEnv.getHtmlLabelName(18801,user.getLanguage())+"："+
	    	"<font color="+(Util.getDoubleValue(loanamount,0)<0?"red":"blue")+">"+df.format(Math.abs(Util.getDoubleValue(loanamount,0)))+"</font>"+
	    	")";
	    %>
		<wea:group context='<%=(contextHtml) %>' attributes="{'itemAreaDisplay':'display'}"><!-- 帐务往来历史明细 -->
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_PERSONAL_RETURN_INNER_LIST %>" />
				<wea:SplitPageTag  tableString='<%=tableString%>' mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</form>


<script language="javascript">
function onBtnSearchClick(){
	form2.submit();
}

function viewInfo(id){
	var _w = 500;
	var _h = 350;
	_fnaOpenDialog("/fna/maintenance/FnaPersonalReturnView.jsp?id="+id, 
			"<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())+SystemEnv.getHtmlLabelName(33313,user.getLanguage()) %>", 
			_w, _h);
}

function doSave(){
	if(!checkVal()){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage()) %>");
		return;
	}
	jQuery("#operation").val("add");
	form2.action = "/fna/maintenance/FnaPersonalReturnOperation.jsp";
	form2.submit();
}

function organizationtype_onchange(){
	jQuery("#organizationid").val("");
	onBtnSearchClick();
}

controlNumberCheck_jQuery("amount", true, 2, false, 16);

function orgId_callback(event,datas,name,_callbackParams){
	jQuery("#organizationid").val(datas.id);
	onBtnSearchClick();
}

function occurdateOnpicked(dp){
	jQuery("#occurdate").val(dp.cal.getDateStr());
	checkVal();
}

function occurdateOncleared(dp){
	jQuery("#occurdate").val("");
	checkVal();
}

function checkVal(){
	var _flag = true;
	if(jQuery("#organizationid").val()==""){
		_flag = false;
	}
	if(jQuery("#occurdate").val()==""){
		_flag = false;
		jQuery("#occurdateSpan2").show();
	}else{
		jQuery("#occurdateSpan2").hide();
	}
	if(jQuery("#amount").val()==""){
		_flag = false;
		jQuery("#amountspan").show();
	}else{
		jQuery("#amountspan").hide();
	}
	return _flag;
}

jQuery("#amount").bind("propertychange",function(){
	checkVal();
}).bind("change",function(){
	checkVal();
}).bind("blue",function(){
	checkVal();
});
</script>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
</html>
