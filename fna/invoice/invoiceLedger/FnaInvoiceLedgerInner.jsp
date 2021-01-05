<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.e9.controller.base.FnaInvoiceLedgerController"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
// || HrmUserVarify.checkUserRight("FnaBudgetfeeTypeEdit:Edit",user)
boolean canEdit = HrmUserVarify.checkUserRight("FnaInvoiceLedger:settings",user);
if(!canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

FnaInvoiceLedgerController fnaInvoiceLedgerController = FnaInvoiceLedgerController.getInstance();
BrowserComInfo browserComInfo = new BrowserComInfo();
ResourceComInfo rci = new ResourceComInfo();
RecordSet rs = new RecordSet();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";//全部
String needfav ="1";
String needhelp ="";

String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();
String advQry_invoiceNumber = Util.null2String(request.getParameter("advQry_invoiceNumber")).trim();
int advQry_invoiceType = Util.getIntValue(request.getParameter("advQry_invoiceType"), -1);
int advQry_authenticity = Util.getIntValue(request.getParameter("advQry_authenticity"), -1);
String advQry_seller = Util.null2String(request.getParameter("advQry_seller")).trim();
String advQry_purchaser = Util.null2String(request.getParameter("advQry_purchaser")).trim();
String advQry_billingDate1 = Util.null2String(request.getParameter("advQry_billingDate1")).trim();
String advQry_billingDate2 = Util.null2String(request.getParameter("advQry_billingDate2")).trim();
String advQry_eimbursementDate1 = Util.null2String(request.getParameter("advQry_eimbursementDate1")).trim();
String advQry_eimbursementDate2 = Util.null2String(request.getParameter("advQry_eimbursementDate2")).trim();
String advQry_reimbursePersons = Util.null2String(request.getParameter("advQry_reimbursePersons")).trim();
String advQry_requestIds = Util.null2String(request.getParameter("advQry_requestIds")).trim();

List<HashMap<String, Integer>> invoiceTypeList = fnaInvoiceLedgerController.getInvoiceTypeList();
int invoiceTypeList_len = invoiceTypeList.size();

List<HashMap<String, Integer>> authenticityList = fnaInvoiceLedgerController.getAuthenticityList();
int authenticityList_len = authenticityList.size();

//加载人名
StringBuffer advQry_reimbursePersonsName = new StringBuffer();
if(!"".equals(advQry_reimbursePersons)){
	String[] advQry_reimbursePersons_array = advQry_reimbursePersons.split(",");
	int advQry_reimbursePersons_array_len = advQry_reimbursePersons_array.length;
	for(int i=0;i<advQry_reimbursePersons_array_len;i++){
		if(i>0){
			advQry_reimbursePersonsName.append(",");
		}
		advQry_reimbursePersonsName.append(rci.getLastname(advQry_reimbursePersons_array[i]));
	}
}

//加载流程名
StringBuffer advQry_requestIdsName = new StringBuffer();
if(!"".equals(advQry_reimbursePersons)){
	String[] advQry_requestIds_array = advQry_requestIds.split(",");
	//由于浏览按钮id和name必须顺序保持一致，所以，此处先将流程名称全部查询出来后，以requestid作为key，放入hashmap，供之后遍历所有选择的requestid来依次读取对应名称。
	HashMap<String, String> reqIdsHm = new HashMap<String, String>();
	StringBuffer sql1 = new StringBuffer("select a.requestid, a.requestname from workflow_requestbase a where 1=1");
	sql1.append(" and (1=2 ");
	List<String> _cond_list = FnaCommon.initData1(advQry_requestIds_array);
	int _cond_list_len = _cond_list.size();
	for(int i=0;i<_cond_list_len;i++){
		sql1.append(" or a.requestid in (").append(_cond_list.get(i)).append(") ");
	}
	sql1.append(") ");
	rs.executeQuery(sql1.toString());
	while(rs.next()){
		reqIdsHm.put(rs.getString("requestid"), Util.null2String(rs.getString("requestname")).trim());
	}
	//遍历所有选择的requestid来依次读取对应名称。
	int advQry_requestIds_array_len = advQry_requestIds_array.length;
	for(int i=0;i<advQry_requestIds_array_len;i++){
		if(i>0){
			advQry_requestIdsName.append(",");
		}
		advQry_requestIdsName.append(reqIdsHm.get(advQry_requestIds_array[i]));
	}
}


%>
<html>
<head>
<link href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET" />
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:btnAdd(),_TOP} ";//新建
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(26601,user.getLanguage())+",javascript:btnBatchImp(),_TOP} ";//批量导入
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:btnBatchDelete(),_TOP} ";//批量删除
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="form2" method="post"  action="/fna/invoice/invoiceLedger/FnaInvoiceLedgerInner.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" class="e8_btn_top" onclick="btnAdd()"/><!-- 新建 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(26601,user.getLanguage()) %>" class="e8_btn_top" onclick="btnBatchImp()"/><!-- 批量导入 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="btnBatchDelete()"/><!-- 批量删除 -->
			<input type="text" class="searchInput" id="nameQuery" name="nameQuery" value="<%=FnaCommon.escapeHtml(nameQuery) %>" /><!-- 快速搜索 -->
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span><!-- 高级搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
	
	<wea:layout type="4Col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905, user.getLanguage()) %>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(131487,user.getLanguage())%></wea:item><!-- 发票代码 -->
		    <wea:item>
		    	<input type=text id="advQry_invoiceCode" name="advQry_invoiceCode" class="Inputstyle" value="<%=FnaCommon.escapeHtml(nameQuery) %>" style="width: 150px;" />
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(131488,user.getLanguage())%></wea:item><!-- 发票号码 -->
		    <wea:item>
		    	<input type=text id="advQry_invoiceNumber" name="advQry_invoiceNumber" class="Inputstyle" value="<%=FnaCommon.escapeHtml(advQry_invoiceNumber) %>" style="width: 150px;" />
		    </wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(131489,user.getLanguage())%></wea:item><!-- 发票类型 -->
			<wea:item>
	      			<select id="advQry_invoiceType" name="advQry_invoiceType">
	      				<option value="-1" <%=advQry_invoiceType==-1?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	      			<%
	      			for(int i=0;i<invoiceTypeList_len;i++){
	      				HashMap<String, Integer> hm = invoiceTypeList.get(i);
	      				int value = hm.get("value");
	      				int labelId = hm.get("labelId");
	      				String labelName = "";
	      				if(labelId != 0){
	      					labelName = SystemEnv.getHtmlLabelName(labelId,user.getLanguage());
	      				}
	          		%>
	      				<option value="<%=value %>" <%=advQry_invoiceType==value?"selected=\"selected\"":"" %>><%=FnaCommon.escapeHtmlNull(labelName)%></option>
	          		<%
	      			}
	      			%>
	      			</select>
	       	</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(131497,user.getLanguage())%></wea:item><!-- 发票真伪 -->
			<wea:item>
	      			<select id="advQry_authenticity" name="advQry_authenticity">
	      				<option value="-1" <%=advQry_authenticity==-1?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	      			<%
	      			for(int i=0;i<authenticityList_len;i++){
	      				HashMap<String, Integer> hm = authenticityList.get(i);
	      				int value = hm.get("value");
	      				int labelId = hm.get("labelId");
	      				String labelName = "";
	      				if(labelId != 0){
	      					labelName = SystemEnv.getHtmlLabelName(labelId,user.getLanguage());
	      				}
	          		%>
	      				<option value="<%=value %>" <%=advQry_authenticity==value?"selected=\"selected\"":"" %>><%=FnaCommon.escapeHtmlNull(labelName)%></option>
	          		<%
	      			}
	      			%>
	      			</select>
	       	</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(131490,user.getLanguage())%></wea:item><!-- 销售方 -->
			<wea:item>
       			<input class="inputstyle" id="advQry_seller" name="advQry_seller" style="width: 80%;" maxlength="500"
       				value="<%=FnaCommon.escapeHtmlNull(advQry_seller) %>" />
	       	</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(131491,user.getLanguage())%></wea:item><!-- 购买方 -->
			<wea:item>
       			<input class="inputstyle" id="advQry_purchaser" name="advQry_purchaser" style="width: 80%;" maxlength="500"
       				value="<%=FnaCommon.escapeHtmlNull(advQry_purchaser) %>" />
	       	</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(131486,user.getLanguage())%></wea:item><!-- 开票日期 -->
			<wea:item>
				<input type="hidden" id="advQry_billingDate1" name="advQry_billingDate1" value="<%=FnaCommon.escapeHtmlNull(advQry_billingDate1) %>">
				<button class="calendar" type="button" id="advQry_btn_billingDate1" onclick="_gdt('advQry_billingDate1', 'advQry_span_billingDate1', '', 'yes');"></button>
				<span id="advQry_span_billingDate1"><%=FnaCommon.escapeHtmlNull(advQry_billingDate1) %></span>
				~ 
				<input type="hidden" id="advQry_billingDate2" name="advQry_billingDate2" value="<%=FnaCommon.escapeHtmlNull(advQry_billingDate2) %>">
				<button class="calendar" type="button" id="advQry_btn_billingDate2" onclick="_gdt('advQry_billingDate2', 'advQry_span_billingDate2', '', 'yes');"></button>
				<span id="advQry_span_billingDate2"><%=FnaCommon.escapeHtmlNull(advQry_billingDate2) %></span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(131504,user.getLanguage())%></wea:item><!-- 报销日期 -->
			<wea:item>
				<input type="hidden" id="advQry_reimbursementDate1" name="advQry_eimbursementDate1" value="<%=FnaCommon.escapeHtmlNull(advQry_eimbursementDate1) %>">
				<button class="calendar" type="button" id="advQry_btn_eimbursementDate1" onclick="_gdt('advQry_eimbursementDate1', 'advQry_span_eimbursementDate1', '', 'yes');"></button>
				<span id="advQry_span_eimbursementDate1"><%=FnaCommon.escapeHtmlNull(advQry_eimbursementDate1) %></span>
				~ 
				<input type="hidden" id="advQry_eimbursementDate2" name="advQry_eimbursementDate2" value="<%=FnaCommon.escapeHtmlNull(advQry_eimbursementDate2) %>">
				<button class="calendar" type="button" id="advQry_btn_eimbursementDate2" onclick="_gdt('advQry_eimbursementDate2', 'advQry_span_eimbursementDate2', '', 'yes');"></button>
				<span id="advQry_span_eimbursementDate2"><%=FnaCommon.escapeHtmlNull(advQry_eimbursementDate2) %></span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(131505,user.getLanguage())%></wea:item><!-- 报销人 -->
			<wea:item>
		        <brow:browser viewType="0" name="advQry_reimbursePersons" browserValue='<%=advQry_reimbursePersons %>' 
		                browserUrl='<%=browserComInfo.getBrowserurl("17") +"%3Fselectedids=#id#" %>'
		                completeUrl="/data.jsp?type=17" 
		                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
		                browserSpanValue='<%=FnaCommon.escapeHtml(advQry_reimbursePersonsName.toString()) %>' >
		        </brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(18077,user.getLanguage())%></wea:item><!-- 关联流程 -->
			<wea:item>
		        <brow:browser viewType="0" name="advQry_requestIds" browserValue='<%=advQry_requestIds %>' 
		                browserUrl='<%=browserComInfo.getBrowserurl("152") +"%3Fselectedids=#id#" %>'
		                completeUrl="/data.jsp?type=152" 
		                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
		                browserSpanValue='<%=FnaCommon.escapeHtml(advQry_requestIdsName.toString()) %>' >
		        </brow:browser>
			</wea:item>
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="e8_btn_submit" type="button" id="advSubmit" onclick="onBtnSearchClick('from_advSubmit');" 
	    			value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/><!-- 查询 -->
	    		<input class="e8_btn_submit" type="button" id="advReset" onclick="resetCondtion();"
	    			value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"/><!-- 重置 -->
	    		<input class="e8_btn_cancel" type="button" id="cancel" 
	    			value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/><!-- 取消 -->
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>	
<%
	//设置好搜索条件
	String backFields =" a.*, "+
		fnaInvoiceLedgerController.getCaseWhenSql4InvoiceTypeList("invoiceTypeName", "a.invoiceType", user.getLanguage())+", "+
		fnaInvoiceLedgerController.getCaseWhenSql4Authenticity("authenticityName", "a.authenticity", user.getLanguage());
	String fromSql = " from fnaInvoiceLedger a ";
	String sqlWhere = " where 1=1 ";
	if(!"".equals(nameQuery)){
		sqlWhere += " and a.invoiceCode like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%' ";
	}
	if(!"".equals(advQry_invoiceNumber)){
		sqlWhere += " and a.invoiceNumber like '%"+StringEscapeUtils.escapeSql(advQry_invoiceNumber)+"%' ";
	}
	if(advQry_invoiceType!=-1){
		sqlWhere += " and a.invoiceType = "+advQry_invoiceType+" ";
	}
	if(advQry_authenticity!=-1){
		sqlWhere += " and a.authenticity = "+advQry_authenticity+" ";
	}
	if(!"".equals(advQry_seller)){
		sqlWhere += " and a.seller like '%"+StringEscapeUtils.escapeSql(advQry_seller)+"%' ";
	}
	if(!"".equals(advQry_invoiceNumber)){
		sqlWhere += " and a.purchaser like '%"+StringEscapeUtils.escapeSql(advQry_purchaser)+"%' ";
	}
	if(!"".equals(advQry_billingDate2)){
		sqlWhere += " and a.billingDate <= '"+StringEscapeUtils.escapeSql(advQry_billingDate2)+"' ";
	}
	if(!"".equals(advQry_billingDate1)){
		sqlWhere += " and a.billingDate >= '"+StringEscapeUtils.escapeSql(advQry_billingDate1)+"' ";
	}
	if(!"".equals(advQry_eimbursementDate2)){
		sqlWhere += " and a.eimbursementDate <= '"+StringEscapeUtils.escapeSql(advQry_eimbursementDate2)+"' ";
	}
	if(!"".equals(advQry_eimbursementDate1)){
		sqlWhere += " and a.eimbursementDate >= '"+StringEscapeUtils.escapeSql(advQry_eimbursementDate1)+"' ";
	}
	if(!"".equals(advQry_reimbursePersons)){
		sqlWhere += " and (1=2 ";
		List<String> _cond_list = FnaCommon.initData1(advQry_reimbursePersons.split(","));
		int _cond_list_len = _cond_list.size();
		for(int i=0;i<_cond_list_len;i++){
			sqlWhere += " or a.reimbursePerson in ("+_cond_list.get(i)+") ";
		}
		sqlWhere += ") ";
	}
	if(!"".equals(advQry_requestIds)){
		sqlWhere += " and (1=2 ";
		List<String> _cond_list = FnaCommon.initData1(advQry_requestIds.split(","));
		int _cond_list_len = _cond_list.size();
		for(int i=0;i<_cond_list_len;i++){
			sqlWhere += " or a.requestid in ("+_cond_list.get(i)+") ";
		}
		sqlWhere += ") ";
	}

	String orderBy=" a.billingDate ";
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	
	String tableString=""+
	"<table instanceid=\"FNA_INVOICE_LEDGER_GRIDVIEW_INNER_LIST\" pageId=\""+PageIdConst.FNA_INVOICE_LEDGER_GRIDVIEW_INNER_LIST+"\" "+
		" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_INVOICE_LEDGER_GRIDVIEW_INNER_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"checkbox\">"+
		"<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" "+
		" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
		" sqlprimarykey=\"id\" sqlsortway=\"Asc\" />"+
		"<head>"+
			"<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(131486,user.getLanguage())+"\" column=\"billingDate\" orderkey=\"billingDate\" "+//开票日期
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"btnOpen+column:id\"/>"+
			"<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(131487,user.getLanguage())+"\" column=\"invoiceCode\" "+//发票代码
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"btnOpen+column:id\"/>"+
			"<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(131488,user.getLanguage())+"\" column=\"invoiceNumber\" "+//发票号码
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"btnOpen+column:id\"/>"+
			"<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(131489,user.getLanguage())+"\" column=\"invoiceTypeName\" orderkey=\"invoiceTypeName\" "+//发票类型
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"btnOpen+column:id\"/>"+
			"<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(131490,user.getLanguage())+"\" column=\"seller\" orderkey=\"seller\" "+//销售方
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"btnOpen+column:id\"/>"+
			"<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(131491,user.getLanguage())+"\" column=\"purchaser\" "+//购买方
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"btnOpen+column:id\"/>"+
			"<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(131492,user.getLanguage())+"\" column=\"invoiceServiceYype\" "+//货物或应税服务类型
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"btnOpen+column:id\"/>"+
			"<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(131493,user.getLanguage())+"\" column=\"priceWithoutTax\" "+//金额（不含税价）
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" align=\"right\" />"+
			"<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(131494,user.getLanguage())+"\" column=\"taxRate\" orderkey=\"taxRate\" "+//税率
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountRatioQuartile\" align=\"right\" />"+
			"<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(131495,user.getLanguage())+"\" column=\"tax\" "+//税额（税价）
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" align=\"right\" />"+
			"<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(131496,user.getLanguage())+"\" column=\"taxIncludedPrice\" orderkey=\"taxIncludedPrice\" "+//价税合计（含税价）
				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" align=\"right\" />"+
			"<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(131497,user.getLanguage())+"\" column=\"authenticityName\" orderkey=\"authenticityName\" />"+//发票真伪
		"</head>"+
		"<operates>"+
			"<operate href=\"javascript:btnDelete();\" text=\""+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"\" index=\"0\"/>"+
			"<operate href=\"javascript:btnOpen();\" text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" index=\"1\"/>"+
		" </operates>"+
	"</table>";
%>
	<wea:layout type="4col">
<%
	String attributes = "{\"groupDisplay\":\"none\"}";
%>
		<wea:group context='' attributes="<%=attributes %>" ><!-- 科目 -->
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_INVOICE_LEDGER_GRIDVIEW_INNER_LIST %>" />
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</form>


<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
	if(from_advSubmit=="from_advSubmit"){
		jQuery("#nameQuery").val(jQuery("#advQry_invoiceCode").val());
	}else{
		jQuery("#advQry_invoiceCode").val(jQuery("#nameQuery").val());
	}
	form2.submit();
}

//新建
function btnAdd(){
	_fnaOpenDialog("/fna/invoice/invoiceLedger/FnaInvoiceLedgerEdit.jsp?id=", 
			"<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())+SystemEnv.getHtmlLabelName(131485,user.getLanguage()) %>", 
			600, 660);
}

//打开
function btnOpen(id){
	_fnaOpenDialog("/fna/invoice/invoiceLedger/FnaInvoiceLedgerEdit.jsp?id="+id, 
			"<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())+SystemEnv.getHtmlLabelName(131485,user.getLanguage()) %>", 
			600, 660);
}

//删除
function btnDelete(ids){
	try{
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
			function(){
				openNewDiv_FnaBudgetViewInner1(_Label33574);
				var _data = "actionName=btnBatchDelete&ids="+ids;
				jQuery.ajax({
					url:"/fna/invoice/invoiceLedger/FnaInvoiceLedgerAction.jsp", 
					type:"post", cache:false, processData:false, data:_data, dataType:"json", 
					success: function do4Success(_json){
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						if(_json.flag){
							window._table.reLoad();
						}else{
							top.Dialog.alert(_json.msg);
						}
					}
				});
			}, function(){}
		);
	}catch(ex0){
		alert(ex0.message);
		try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
	}
}

//批量删除
function btnBatchDelete(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("18214,264",user.getLanguage()) %>");
		return;
	}
	btnDelete(ids);
}

//批量导入
function btnBatchImp(){
	var _w = 580;
	var _h = 420;
	_fnaOpenDialog("/fna/invoice/invoiceLedger/FnaInvoiceLedgerBatchImp.jsp", 
			"<%=SystemEnv.getHtmlLabelName(131529,user.getLanguage()) %>", 
			_w, _h);
}






//页面初始化事件
jQuery(document).ready(function(){
});























/**
 *   导出全部数据
 */
function exportAll() {
    downExcel();
};
/**
 * 导出列表中所勾选的数据
 */
function exportSelect() {
    var ids = _xtable_CheckedCheckboxId();
    if(!ids || ids =='' ) {
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127108,user.getLanguage())%>");
    }else {
        downExcel(ids);
    }
};
function downExcel(ids){
    try{
        var elemIF = document.createElement("iframe");
        elemIF.style.display = "none";
        var url = "/fna/maintenance/FnaBudgetfeeTypeDownload.jsp";
        if(ids) {
            url += "?type=select&ids="+ids;
        }else {
            url += "?type=all";
        }
        elemIF.src = url;
        document.body.appendChild(elemIF);
    }catch(e){
    }
}
</script>
<script language="javascript" src="/js/datetime_wev8.js"></script>
<script language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
</html>
