<%@page import="weaver.fna.e9.controller.base.FnaInvoiceLedgerController"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.fna.e9.vo.base.FnaInvoiceLedgerVo"%>
<%@page import="weaver.fna.e9.controller.base.FnaBaseController"%>
<%@page import="weaver.fna.general.RecordSet4Action"%>
<%@page import="weaver.fna.e9.po.base.FnaInvoiceLedger"%>
<%@page import="weaver.fna.e9.dao.base.FnaBaseDao"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ page import="java.text.DecimalFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
boolean canEdit = HrmUserVarify.checkUserRight("FnaInvoiceLedger:settings",user);
if(!canEdit) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

DecimalFormat df2 = new DecimalFormat("####################################################0.00");

int id = Util.getIntValue(request.getParameter("id"),0);

RecordSet4Action rs4a = new RecordSet4Action();
BrowserComInfo browserComInfo = new BrowserComInfo();
ResourceComInfo rci = new ResourceComInfo();
FnaBaseDao fnaBaseDao = new FnaBaseDao();
FnaInvoiceLedgerController fnaInvoiceLedgerController = FnaInvoiceLedgerController.getInstance();
FnaBaseController fnaBaseController = FnaBaseController.getInstance();

FnaInvoiceLedger fnaInvoiceLedger = null;
if(id > 0){
	fnaInvoiceLedger = (FnaInvoiceLedger)fnaBaseDao.queryForObject(rs4a, FnaInvoiceLedger.class.getName(), 
		"select a.* from fnaInvoiceLedger a where a.id = ?", id);
}
if(fnaInvoiceLedger == null){
	fnaInvoiceLedger = new FnaInvoiceLedger();
}
FnaInvoiceLedgerVo vo = new FnaInvoiceLedgerVo();

fnaBaseController.loadVoDataFromPo(fnaInvoiceLedger, vo);
fnaBaseController.setVoObjectDefaultValue(vo);

String requestname = "";
if(vo.getRequestId() > 0){
	rs4a.executeQuery("select a.requestname from workflow_requestbase a where a.requestid = ?", vo.getRequestId());
	if(rs4a.next()){
		requestname = Util.null2String(rs4a.getString("requestname")).trim();
	}else{
		requestname = String.valueOf(vo.getRequestId());
	}
}

List<HashMap<String, Integer>> invoiceTypeList = fnaInvoiceLedgerController.getInvoiceTypeList();
int invoiceTypeList_len = invoiceTypeList.size();

List<HashMap<String, Integer>> authenticityList = fnaInvoiceLedgerController.getAuthenticityList();
int authenticityList_len = authenticityList.size();

String emptyString = "";
%>
<html><head>
<link href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET" />
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doActionSave(1),_TOP} ";//保存
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32720,user.getLanguage())+",javascript:doActionSave(2),_TOP} ";//保存并新建
RCMenuHeight += RCMenuHeightStep ;
if(id > 0){ 
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:btnDelete(),_TOP} ";//删除
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(131485,user.getLanguage()) %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doActionSave(1);" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doActionSave(2);" value="<%=SystemEnv.getHtmlLabelName(32720,user.getLanguage())%>"/><!-- 保存并新建 -->
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top" onclick="btnDelete()"/><!-- 删除 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
<form class="ViewForm" id="frmmain" action="" method="post">
<input type="hidden" id="id" name="id" value="<%=id %>" />
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(131518,user.getLanguage())%>'><!-- 报销信息 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(131504,user.getLanguage())%></wea:item><!-- 报销日期 -->
		<wea:item>
			<%=FnaCommon.escapeHtmlNull(vo.getReimbursementDate()) %>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(131505,user.getLanguage())%></wea:item><!-- 报销人 -->
		<wea:item>
			<%=FnaCommon.escapeHtmlNull(rci.getLastname(String.valueOf(vo.getReimbursePerson()))) %>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18077,user.getLanguage())%></wea:item><!-- 关联流程 -->
		<wea:item>
		<%if(vo.getRequestId() > 0){ %>
			<a href="/workflow/request/ViewRequest.jsp?requestid=<%=vo.getRequestId() %>" target="_blank"><%=FnaCommon.escapeHtmlNull(requestname) %></a>
		<%} %>
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'><!-- 基本信息 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(131486,user.getLanguage())%></wea:item><!-- 开票日期 -->
		<wea:item>
			<wea:required id="span_billingDateimg" required="true" value="<%=FnaCommon.escapeHtmlNull(vo.getBillingDate()) %>">
				<input type="hidden" id="billingDate" name="billingDate" value="<%=FnaCommon.escapeHtmlNull(vo.getBillingDate()) %>">
				<button class="calendar" type="button" id="btn_billingDate" onclick="_gdt('billingDate', 'span_billingDate', '', 'yes');"></button>
				<span id="span_billingDate"><%=FnaCommon.escapeHtmlNull(vo.getBillingDate()) %></span>
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(131487,user.getLanguage())%></wea:item><!-- 发票代码 -->
		<wea:item>
			<wea:required id="invoiceCodeSpan" required="true" value="<%=FnaCommon.escapeHtmlNull(vo.getInvoiceCode()) %>">
       			<input class="inputstyle" id="invoiceCode" name="invoiceCode" style="width: 150px;" maxlength="10"
       				onchange='checkinput("invoiceCode","invoiceCodeSpan");' value="<%=FnaCommon.escapeHtmlNull(vo.getInvoiceCode()) %>" />
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(131488,user.getLanguage())%></wea:item><!-- 发票号码 -->
		<wea:item>
			<wea:required id="invoiceNumberSpan" required="true" value="<%=FnaCommon.escapeHtmlNull(vo.getInvoiceNumber()) %>">
       			<input class="inputstyle" id="invoiceNumber" name="invoiceNumber" style="width: 150px;" maxlength="8"
       				onchange='checkinput("invoiceNumber","invoiceNumberSpan");' value="<%=FnaCommon.escapeHtmlNull(vo.getInvoiceNumber()) %>" />
			</wea:required>
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(131489,user.getLanguage())%></wea:item><!-- 发票类型 -->
		<wea:item>
      			<select id="invoiceType" name="invoiceType">
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
      				<option value="<%=value %>" <%=vo.getInvoiceType()==value?"selected=\"selected\"":"" %>><%=FnaCommon.escapeHtmlNull(labelName)%></option>
          		<%
      			}
      			%>
      			</select>
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(131490,user.getLanguage())%></wea:item><!-- 销售方 -->
		<wea:item>
			<wea:required id="sellerSpan" required="true" value="<%=FnaCommon.escapeHtmlNull(vo.getSeller()) %>">
       			<input class="inputstyle" id="seller" name="seller" style="width: 80%;" maxlength="500"
       				onchange='checkinput("seller","sellerSpan");' value="<%=FnaCommon.escapeHtmlNull(vo.getSeller()) %>" />
			</wea:required>
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(131491,user.getLanguage())%></wea:item><!-- 购买方 -->
		<wea:item>
			<wea:required id="purchaserSpan" required="true" value="<%=FnaCommon.escapeHtmlNull(vo.getPurchaser()) %>">
       			<input class="inputstyle" id="purchaser" name="purchaser" style="width: 80%;" maxlength="500"
       				onchange='checkinput("purchaser","purchaserSpan");' value="<%=FnaCommon.escapeHtmlNull(vo.getPurchaser()) %>" />
			</wea:required>
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(131492,user.getLanguage())%></wea:item><!-- 货物或应税服务类型 -->
		<wea:item>
			<wea:required id="invoiceServiceYypeSpan" required="true" value="<%=FnaCommon.escapeHtmlNull(vo.getInvoiceServiceYype()) %>" >
       			<input class="inputstyle" id="invoiceServiceYype" name="invoiceServiceYype" style="width: 80%;" maxlength="500"
       				onchange='checkinput("invoiceServiceYype","invoiceServiceYypeSpan");' value="<%=FnaCommon.escapeHtmlNull(vo.getInvoiceServiceYype()) %>" />
			</wea:required>
       	</wea:item>
       	
		<wea:item><%=SystemEnv.getHtmlLabelName(131493,user.getLanguage())%></wea:item><!-- 金额（不含税价） -->
		<wea:item>
			<wea:required id="priceWithoutTaxSpan" required="true" value="<%=vo.getPriceWithoutTax()==null?emptyString:df2.format(vo.getPriceWithoutTax()) %>">
       			<input class="inputstyle" id="priceWithoutTax" name="priceWithoutTax" style="width: 70px;text-align: right;" 
       				onchange='checkinput("priceWithoutTax","priceWithoutTaxSpan");' value="<%=vo.getPriceWithoutTax()==null?"":df2.format(vo.getPriceWithoutTax()) %>" />
			</wea:required>
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(131494,user.getLanguage())%></wea:item><!-- 税率 -->
		<wea:item>
			<wea:required id="taxRateSpan" required="true" value="<%=vo.getTaxRate()==null?emptyString:df2.format(vo.getTaxRate()) %>">
       			<input class="inputstyle" id="taxRate" name="taxRate" style="width: 70px;text-align: right;" 
       				onchange='checkinput("taxRate","taxRateSpan");' value="<%=vo.getTaxRate()==null?"":df2.format(vo.getTaxRate()) %>" />%
			</wea:required>
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(131495,user.getLanguage())%></wea:item><!-- 税额（税价） -->
		<wea:item>
			<wea:required id="taxSpan" required="true" value="<%=vo.getTax()==null?emptyString:df2.format(vo.getTax()) %>">
       			<input class="inputstyle" id="tax" name="tax" style="width: 70px;text-align: right;" 
       				onchange='checkinput("tax","taxSpan");' value="<%=vo.getTax()==null?"":df2.format(vo.getTax()) %>" />
			</wea:required>
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(131496,user.getLanguage())%></wea:item><!-- 价税合计（含税价） -->
		<wea:item>
			<wea:required id="taxIncludedPriceSpan" required="true" value="<%=vo.getTaxIncludedPrice()==null?emptyString:df2.format(vo.getTaxIncludedPrice()) %>">
       			<input class="inputstyle" id="taxIncludedPrice" name="taxIncludedPrice" style="width: 70px;text-align: right;" 
       				onchange='checkinput("taxIncludedPrice","taxIncludedPriceSpan");' value="<%=vo.getTaxIncludedPrice()==null?"":df2.format(vo.getTaxIncludedPrice()) %>" />
			</wea:required>
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(131497,user.getLanguage())%></wea:item><!-- 发票真伪 -->
		<wea:item>
      			<select id="authenticity" name="authenticity">
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
      				<option value="<%=value %>" <%=vo.getAuthenticity()==value?"selected=\"selected\"":"" %>><%=FnaCommon.escapeHtmlNull(labelName)%></option>
          		<%
      			}
      			%>
      			</select>
       	</wea:item>
	</wea:group>
</wea:layout>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="doClose();" 
	    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
	    	</wea:item>
	    </wea:group>
</wea:layout>
</div>
<Script language=javascript>
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);

jQuery(document).ready(function(){
	resizeDialog(document);
	controlNumberCheck_jQuery("priceWithoutTax",true,2,false,12);
	controlNumberCheck_jQuery("taxRate",true,2,false,4);
	controlNumberCheck_jQuery("tax",true,2,false,12);
	controlNumberCheck_jQuery("taxIncludedPrice",true,2,false,12);
});

//保存
function doActionSave(_saveType){
	try{
		openNewDiv_FnaBudgetViewInner1(_Label33574);
		var _data = "actionName=doActionSave"+getPostDataByForm("frmmain");
		jQuery.ajax({
			url:"/fna/invoice/invoiceLedger/FnaInvoiceLedgerAction.jsp", 
			type:"post", cache:false, processData:false, data:_data, dataType:"json", 
			success: function do4Success(_json){
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				if(_json.flag){
					parentWin._table.reLoad();
					if(_saveType==1){
						doClose();
					}else{
						window.location.href = "/fna/invoice/invoiceLedger/FnaInvoiceLedgerEdit.jsp";
					}
				}else{
					top.Dialog.alert(_json.msg);
				}
			}
		});
	}catch(ex0){
		alert(ex0.message);
		try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
	}
}

//删除
function btnDelete(){
	try{
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
			function(){
				openNewDiv_FnaBudgetViewInner1(_Label33574);
				var _data = "actionName=btnBatchDelete&ids="+jQuery("#id").val();
				jQuery.ajax({
					url:"/fna/invoice/invoiceLedger/FnaInvoiceLedgerAction.jsp", 
					type:"post", cache:false, processData:false, data:_data, dataType:"json", 
					success: function do4Success(_json){
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						if(_json.flag){
							parentWin._table.reLoad();
							doClose();
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

//关闭当前弹出框
function doClose(){
	parentWin.closeDialog();
}

</script>
<script language="javascript" src="/js/datetime_wev8.js"></script>
<script language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>
</HTML>
