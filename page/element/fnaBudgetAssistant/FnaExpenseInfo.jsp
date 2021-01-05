<%@page import="weaver.conn.RecordSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@page import="org.json.JSONObject"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%><html>
	<head>
	    <link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	    <script type="text/javascript" src="/js/ecology8/jquery_wev8.js"></script>
		<script type="text/javascript" src="/fna/js/e8Common_wev8.js?r=9"></script>
		<script type="text/javascript" src="/page/element/fnaBudgetAssistant/js/highcharts_wev8.js"></script>
		<script type="text/javascript" src="/page/element/fnaBudgetAssistant/js/exporting_wev8.js"></script>
		<script type="text/javascript" src="/page/element/fnaBudgetAssistant/js/no-data-to-display_wev8.js"></script>
		<style type="text/css">
			.tdheader1{
				color: #707070;
				background-color:#D7D7D7;
			}
			.trheader1{
				background-color:#F1F1F1;
			}
			td{
				text-align:center;
			}
			img{
				cursor:pointer;
			}
		</style>
	</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav = "1";
String needhelp = "";

User user = HrmUserVarify.getUser(request , response);
if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

DecimalFormat df = new DecimalFormat("#######################################0.00");
BudgetfeeTypeComInfo bftci = new BudgetfeeTypeComInfo();

String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();

Map<String, String> dataMap = (Map<String, String>)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_dataMap_"+_guid1);
int requestId = Util.getIntValue((String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_requestId_"+_guid1));
int workflowid = Util.getIntValue((String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_workflowid_"+_guid1));
String fnaWfType = (String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_fnaWfType_"+_guid1);

String currentDate = (String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_currentDate_"+_guid1);
String currentYYYY = (String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_currentYYYY_"+_guid1);
String currentMM = (String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_currentMM_"+_guid1);
String currentDD = (String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_currentDD_"+_guid1);
String currentLastYYYY = (String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_currentLastYYYY_"+_guid1);
String currentLastMM = (String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_currentLastMM_"+_guid1);

//out.println("fnaWfType="+fnaWfType+"<br />");
if(!"fnaFeeWf".equals(fnaWfType)){
	return;
}

RecordSet rs1 = new RecordSet();

int creater = 0;
String sql = "select a.creater from workflow_requestbase a where a.requestid = "+requestId+" "+
	" and exists (select 1 from workflow_currentoperator wc where wc.requestid = a.requestid and wc.userid="+user.getUID()+" and wc.usertype=0)";
rs1.executeSql(sql);
if(rs1.next()){
	creater = rs1.getInt("creater");
}else{
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

int formid = Util.getIntValue(dataMap.get("formid"), 0);
int formidABS = Math.abs(formid);
String fieldIdSubject_fieldName = Util.null2String(dataMap.get("fieldIdSubject_fieldName")).trim();//报销流程的报销明细的科目数据库字段
String fieldIdSubject_isDtl = Util.null2String(dataMap.get("fieldIdSubject_fieldId_isDtl"));

List<String> feetypeList = new ArrayList<String>();
StringBuffer feetypeIds = new StringBuffer();
sql = "select distinct b."+fieldIdSubject_fieldName+" subject, c.codeName, c.name  "+
	" from formtable_main_"+formidABS+" a "+
	" join formtable_main_"+formidABS+"_dt1 b on a.id = b.mainid "+
	" join FnaBudgetfeeType c on b."+fieldIdSubject_fieldName+" = c.id \n" +
	" where a.requestid = "+requestId+" \n"+
	" order by c.codeName, c.name, b."+fieldIdSubject_fieldName+" ";
if(!"1".equals(fieldIdSubject_isDtl)){
	sql = "select distinct a."+fieldIdSubject_fieldName+" subject, c.codeName, c.name  "+
		" from formtable_main_"+formidABS+" a "+
		" join FnaBudgetfeeType c on a."+fieldIdSubject_fieldName+" = c.id \n" +
		" where a.requestid = "+requestId+" \n"+
		" order by c.codeName, c.name, a."+fieldIdSubject_fieldName+" ";
}
//out.println(sql+"<br />");
rs1.executeSql(sql);
while(rs1.next()){
	int subject = rs1.getInt("subject");
	String isEditFeeTypeId_subject = bftci.getIsEditFeeTypeId(subject+"");
	if(subject > 0 && !feetypeList.contains(isEditFeeTypeId_subject+"")){
		if(feetypeList.size() > 0){
			feetypeIds.append(",");
		}
		feetypeIds.append(isEditFeeTypeId_subject+"");
		feetypeList.add(isEditFeeTypeId_subject+"");
	}
}
List<String> subjectIds_list = FnaCommon.initData1(feetypeIds.toString().split(","));
int subjectIds_list_len = subjectIds_list.size();

request.getSession().setAttribute("fnaBudgetAssistant_View.jsp_feetypeIds_"+_guid1, feetypeIds.toString());
request.getSession().setAttribute("fnaBudgetAssistant_View.jsp_feetypeList_"+_guid1, feetypeList);
request.getSession().setAttribute("fnaBudgetAssistant_View.jsp_creater_"+_guid1, creater+"");

int feetypeListLen = feetypeList.size();
int tableDivHeightRowNumber = feetypeListLen;
if(feetypeListLen >= 2){
	tableDivHeightRowNumber = 2;
}else if(feetypeListLen == 1){
	tableDivHeightRowNumber = 1;
}
double tableDivHeight = 81;
%>
<body>
<div id="tableDiv" style="height:<%=tableDivHeight * tableDivHeightRowNumber%>px;overflow-x:hidden;overflow-y:auto">
		<table style="height:auto;width:100%;" cellspacing="0">
			<colgroup>
				<col width="25%">
				<col width="25%">
				<col width="25%">
				<col width="25%">
			</colgroup>
			<tbody>
				<%
					HashMap<String, String> actualExpenseMM = new HashMap<String, String>();//预算本月已发生费用
					HashMap<String, String> actualExpenseLastMM = new HashMap<String, String>();//预算上月已发生费用
					HashMap<String, String> actualExpenseYYYY = new HashMap<String, String>();//预算本年已发生费用

					HashMap<String, String> approvalExpenseMM = new HashMap<String, String>();//预算本月审批中费用
					HashMap<String, String> approvalExpenseLastMM = new HashMap<String, String>();//预算上月审批中费用
					HashMap<String, String> approvalExpenseYYYY = new HashMap<String, String>();//预算本年审批中费用
					
					//表格部分
					if(feetypeListLen > 0){
						StringBuffer sql_rs1 = new StringBuffer();
						sql_rs1.append("select b.isEditFeeTypeId subject, a.status, SUM(a.amount) sumAmt  \n");
						sql_rs1.append(" from workflow_requestbase wr \n");
						sql_rs1.append(" join FnaExpenseInfo a on wr.requestid = a.requestid \n");
						sql_rs1.append(" join FnaBudgetfeeType b on a.subject = b.id \n");
						sql_rs1.append(" where wr.currentnodetype <> 0 \n");
						sql_rs1.append(" and (1=2 \n");
				    	for(int j=0;j<subjectIds_list_len;j++){
				    		String sqlCond_subjectIds = Util.null2String(subjectIds_list.get(j));
							sql_rs1.append(" or b.isEditFeeTypeId in ("+sqlCond_subjectIds+") \n");
				    	}
						sql_rs1.append(" ) \n");
						sql_rs1.append(" and wr.creater = "+creater+" \n");
						
						String sql1 = sql_rs1.toString() + " and (a.occurdate >= '"+StringEscapeUtils.escapeSql(currentYYYY+"-"+currentMM+"-01")+"' and a.occurdate <= '"+StringEscapeUtils.escapeSql(currentYYYY+"-"+currentMM+"-31")+"') "+
							" group by b.isEditFeeTypeId , a.status ";
						String sql2 = sql_rs1.toString() + " and (a.occurdate >= '"+StringEscapeUtils.escapeSql(currentLastYYYY+"-"+currentLastMM+"-01")+"' and a.occurdate <= '"+StringEscapeUtils.escapeSql(currentLastYYYY+"-"+currentLastMM+"-31")+"') "+
							" group by b.isEditFeeTypeId , a.status ";
						String sql3 = sql_rs1.toString() + " and (a.occurdate >= '"+StringEscapeUtils.escapeSql(currentYYYY+"-01-01")+"' and a.occurdate <= '"+StringEscapeUtils.escapeSql(currentYYYY+"-12-31")+"') "+
							" group by b.isEditFeeTypeId , a.status ";

						//out.println(sql1+"<br />");
						//out.println(sql2+"<br />");
						//out.println(sql3+"<br />");
						
						rs1.executeSql(sql1);
						while(rs1.next()){
							int status = rs1.getInt("status");
							if(status==0){
								approvalExpenseMM.put(Util.null2String(rs1.getString("subject")), df.format(Util.getDoubleValue(rs1.getString("sumAmt"), 0.00)));
							}else if(status==1){
								actualExpenseMM.put(Util.null2String(rs1.getString("subject")), df.format(Util.getDoubleValue(rs1.getString("sumAmt"), 0.00)));
							}
						}
						rs1.executeSql(sql2);
						while(rs1.next()){
							int status = rs1.getInt("status");
							if(status==0){
								approvalExpenseLastMM.put(Util.null2String(rs1.getString("subject")), df.format(Util.getDoubleValue(rs1.getString("sumAmt"), 0.00)));
							}else if(status==1){
								actualExpenseLastMM.put(Util.null2String(rs1.getString("subject")), df.format(Util.getDoubleValue(rs1.getString("sumAmt"), 0.00)));
							}
						}
						rs1.executeSql(sql3);
						while(rs1.next()){
							int status = rs1.getInt("status");
							if(status==0){
								approvalExpenseYYYY.put(Util.null2String(rs1.getString("subject")), df.format(Util.getDoubleValue(rs1.getString("sumAmt"), 0.00)));
							}else if(status==1){
								actualExpenseYYYY.put(Util.null2String(rs1.getString("subject")), df.format(Util.getDoubleValue(rs1.getString("sumAmt"), 0.00)));
							}
						}
					}

					double actualExpenseMM_valSum = 0.00;
					double actualExpenseLastMM_valSum = 0.00;
					double actualExpenseYYYY_valSum = 0.00;

					double approvalExpenseMM_valSum = 0.00;
					double approvalExpenseLastMM_valSum = 0.00;
					double approvalExpenseYYYY_valSum = 0.00;
					
					for(int i = 0; i < feetypeList.size(); i++){
						String subjectId = feetypeList.get(i);
						String feeTypeName = bftci.getBudgetfeeTypename(subjectId);

						double actualExpenseMM_val = Util.getDoubleValue(actualExpenseMM.get(subjectId+""), 0.00);
						actualExpenseMM_valSum += actualExpenseMM_val; actualExpenseMM_valSum = Util.getDoubleValue(df.format(actualExpenseMM_valSum), 0.00);
						double actualExpenseLastMM_val = Util.getDoubleValue(actualExpenseLastMM.get(subjectId+""), 0.00);
						actualExpenseLastMM_valSum += actualExpenseLastMM_val; actualExpenseLastMM_valSum = Util.getDoubleValue(df.format(actualExpenseLastMM_valSum), 0.00);
						double actualExpenseYYYY_val = Util.getDoubleValue(actualExpenseYYYY.get(subjectId+""), 0.00);
						actualExpenseYYYY_valSum += actualExpenseYYYY_val; actualExpenseYYYY_valSum = Util.getDoubleValue(df.format(actualExpenseYYYY_valSum), 0.00);
						
						double approvalExpenseMM_val = Util.getDoubleValue(approvalExpenseMM.get(subjectId+""), 0.00);
						approvalExpenseMM_valSum += approvalExpenseMM_val; approvalExpenseMM_valSum = Util.getDoubleValue(df.format(approvalExpenseMM_valSum), 0.00);
						double approvalExpenseLastMM_val = Util.getDoubleValue(approvalExpenseLastMM.get(subjectId+""), 0.00);
						approvalExpenseLastMM_valSum += approvalExpenseLastMM_val; approvalExpenseLastMM_valSum = Util.getDoubleValue(df.format(approvalExpenseLastMM_valSum), 0.00);
						double approvalExpenseYYYY_val = Util.getDoubleValue(approvalExpenseYYYY.get(subjectId+""), 0.00);
						approvalExpenseYYYY_valSum += approvalExpenseYYYY_val; approvalExpenseYYYY_valSum = Util.getDoubleValue(df.format(approvalExpenseYYYY_valSum), 0.00);
						
						out.println("<tr style='background-color:#ADC7EF;color:white;padding:0;height:27px'>");
						out.println("	<td>");
						out.println(		FnaCommon.escapeHtml(feeTypeName));
						out.println("	</td>");
						out.println("	<td>");
						out.println(		SystemEnv.getHtmlLabelName(126758,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")");//本月
						out.println("	</td>");
						out.println("	<td>");
						out.println(		SystemEnv.getHtmlLabelName(126759,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")");//上月
						out.println("	</td>");
						out.println("	<td>");
						out.println(		SystemEnv.getHtmlLabelName(126760,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")");//本年
						out.println("	</td>");
						out.println("</tr>");
						out.println("<tr style='height:18px'>");
						out.println("	<td>");
						out.println(		SystemEnv.getHtmlLabelName(18503,user.getLanguage()));//已发生费用
						out.println("	</td>");
						out.println("	<td>");
						out.println(		"<font color='#ABABAB'>"+df.format(actualExpenseMM_val)+"</font>");
						out.println("	</td>");
						out.println("	<td>");
						out.println(		"<font color='#ABABAB'>"+df.format(actualExpenseLastMM_val)+"</font>");
						out.println("	</td>");
						out.println("	<td>");
						out.println(		"<font color='#ABABAB'>"+df.format(actualExpenseYYYY_val)+"</font>");
						out.println("	</td>");
						out.println("</tr>");
						out.println("<tr style='height:18px' class='trheader1'>");
						out.println("	<td>");
						out.println(		SystemEnv.getHtmlLabelName(18769,user.getLanguage()));//审批中费用
						out.println("	</td>");
						out.println("	<td>");
						out.println(		"<font color='#41A6CC'>"+df.format(approvalExpenseMM_val)+"</font>");
						out.println("	</td>");
						out.println("	<td>");
						out.println(		"<font color='#41A6CC'>"+df.format(approvalExpenseLastMM_val)+"</font>");
						out.println("	</td>");
						out.println("	<td>");
						out.println(		"<font color='#41A6CC'>"+df.format(approvalExpenseYYYY_val)+"</font>");
						out.println("	</td>");
						out.println("</tr>");
						out.println("<tr style='height:18px'>");
						out.println("	<td>");
						out.println(		SystemEnv.getHtmlLabelName(358,user.getLanguage()));//合计
						out.println("	</td>");
						out.println("	<td>");
						out.println(		"<font color='#ABABAB'>"+df.format(actualExpenseMM_val + approvalExpenseMM_val)+"</font>");
						out.println("	</td>");
						out.println("	<td>");
						out.println(		"<font color='#ABABAB'>"+df.format(actualExpenseLastMM_val + approvalExpenseLastMM_val)+"</font>");
						out.println("	</td>");
						out.println("	<td>");
						out.println(		"<font color='#ABABAB'>"+df.format(actualExpenseYYYY_val + approvalExpenseYYYY_val)+"</font>");
						out.println("	</td>");
						out.println("</tr>");
					}
						
				%>
			</tbody>
		</table>
</div>
<div id="tableSumDiv" style="height:<%=tableDivHeight%>px;">
	<table style="height:auto;width:100%; cellspacing=0">
				<colgroup>
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col width="25%">
				</colgroup>
				<tbody>
		<%
			//合计表格代码块
			{
				out.println("<tr style='background-color:#8EB4E3;color:white;padding:0;height:27px'>");
				out.println("	<td>");
				out.println(		SystemEnv.getHtmlLabelName(126829,user.getLanguage()));//费用汇总
				out.println("	</td>");
				out.println("	<td>");
				out.println(		SystemEnv.getHtmlLabelName(126758,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")");//本月
				out.println("	</td>");
				out.println("	<td>");
				out.println(		SystemEnv.getHtmlLabelName(126759,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")");//上月
				out.println("	</td>");
				out.println("	<td>");
				out.println(		SystemEnv.getHtmlLabelName(126760,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")");//本年
				out.println("	</td>");
				out.println("	<td rowspan='5' style='background-color:#F1F1F1'></td>");
				out.println("</tr>");
				out.println("<tr style='height:18px'>");
				out.println("	<td>");
				out.println(		SystemEnv.getHtmlLabelName(18503,user.getLanguage()));//已发生费用
				out.println("	</td>");
				out.println("	<td>");
				out.println(		"<font color='#ABABAB'>"+df.format(actualExpenseMM_valSum)+"</font>");
				out.println("	</td>");
				out.println("	<td>");
				out.println(		"<font color='#ABABAB'>"+df.format(actualExpenseLastMM_valSum)+"</font>");
				out.println("	</td>");
				out.println("	<td>");
				out.println(		"<font color='#ABABAB'>"+df.format(actualExpenseYYYY_valSum)+"</font>");
				out.println("	</td>");
				out.println("</tr>");
				out.println("<tr style='height:18px' class='trheader1'>");
				out.println("	<td>");
				out.println(		SystemEnv.getHtmlLabelName(18769,user.getLanguage()));//审批中费用
				out.println("	</td>");
				out.println("	<td>");
				out.println(		"<font color='#41A6CC'>"+df.format(approvalExpenseMM_valSum)+"</font>");
				out.println("	</td>");
				out.println("	<td>");
				out.println(		"<font color='#41A6CC'>"+df.format(approvalExpenseLastMM_valSum)+"</font>");
				out.println("	</td>");
				out.println("	<td>");
				out.println(		"<font color='#41A6CC'>"+df.format(approvalExpenseYYYY_valSum)+"</font>");
				out.println("	</td>");
				out.println("</tr>");
				out.println("<tr style='height:18px'>");
				out.println("	<td>");
				out.println(		SystemEnv.getHtmlLabelName(358,user.getLanguage()));//合计
				out.println("	</td>");
				out.println("	<td>");
				out.println(		"<font color='#ABABAB'>"+df.format(actualExpenseMM_valSum + approvalExpenseMM_valSum)+"</font>");
				out.println("	</td>");
				out.println("	<td>");
				out.println(		"<font color='#ABABAB'>"+df.format(actualExpenseLastMM_valSum + approvalExpenseLastMM_valSum)+"</font>");
				out.println("	</td>");
				out.println("	<td>");
				out.println(		"<font color='#ABABAB'>"+df.format(actualExpenseYYYY_valSum + approvalExpenseYYYY_valSum)+"</font>");
				out.println("	</td>");
				out.println("</tr>");
			}
		%>
		</tbody>
	</table>
</div>
<div style="width:810px;height:309px;overflow:hidden;margin-top:22px;">
	<div style="width:810px;margin-top:5px;padding-top:2px;padding-bottom:25px">
		&nbsp;&nbsp;&nbsp;
		<span style="color:#41A6CC;padding-bottom:5px; border-bottom:2px solid #41A6CC"><%=SystemEnv.getHtmlLabelName(126761,user.getLanguage())%></span><!-- 图表分析 -->
	</div>
	<div style="width:50px;float:left;padding-top:68px;padding-bottom:95px;padding-left:5px;padding-right:5px">
		<img  id="signalToLeft" onclick="getChart('toLeft')" class="e8_box_mutiarrow e8_box_disabled" src="/page/element/fnaBudgetAssistant/image/5_wev8.png">
	</div>
	<div style="width:690px;height:250px;magin-top:10px;float:left;overflow:hidden;">
		<div style="width:690px;height:250px;position:relative;" id="chartdiv"></div>
	</div>
	<div style="width:50px;float:left;padding-top:68px;padding-bottom:95px;padding-left:5px;padding-right:5px">
		<img  id="signalToRigtht" onclick="getChart('toRight')"  class="e8_box_mutiarrow e8_first_arrow e8_box_disabled" src="/page/element/fnaBudgetAssistant/image/4_wev8.png">
	</div>
</div>
<input id="currentMonth" name="currentMonth" type="hidden" />
<script type="text/javascript">
jQuery(document).ready(function(){
	getChart();
	var src = "/page/element/fnaBudgetAssistant/image/";
	var srcToLeftNormal = src+"5_wev8.png";
	var srcToRightNormal = src+"4_wev8.png";
	var srcToLeftHover = src+"5-h_wev8.png";
	var srcToRightHover = src+"4-h_wev8.png";
	jQuery("#signalToLeft").hover(
		function(event){
			jQuery(this).attr("src",srcToLeftHover);
		},function(event){
			jQuery(this).attr("src",srcToLeftNormal);
		}
	);
	jQuery("#signalToRigtht").hover(
		function(event){
			jQuery(this).attr("src",srcToRightHover);
		},function(event){
			jQuery(this).attr("src",srcToRightNormal);
		}
	);
});
	
function getChart(direction){
	var categories = "";
	var sum_applyAmt_str = "";
	var sum_actualAmt_str = "";
	var currentMonth = "";
	
	if(direction!=null && direction!=''){
		if(direction == 'toRight'){
			currentMonth = jQuery("#currentMonth").val()*1.0 + 2;
		}else if(direction == 'toLeft'){
			currentMonth = jQuery("#currentMonth").val()*1.0 - 2;
		}
		if(currentMonth <= 3){
			currentMonth = 3;
		}else if(currentMonth >= 10){
			currentMonth = 10;
		}
	}else{
		currentMonth = <%=Util.getIntValue(currentMM) %>;
	}
	jQuery("#currentMonth").val(currentMonth);
	
	jQuery.ajax({
		url : "/page/element/fnaBudgetAssistant/getChartAjax.jsp?_guid1=<%=_guid1%>&month="+currentMonth,
		type : "post",
		processData : false,
		dataType : "json",
		success: function do4Success(msg){ 
			categories = msg.categories;
			sum_applyAmt_str = msg.sum_applyAmt_str;
			sum_actualAmt_str = msg.sum_actualAmt_str;
			
			companyClick(categories, sum_applyAmt_str, sum_actualAmt_str);
		}
	});
}
	
function companyClick(categories1, sum_applyAmt_str, sum_actualAmt_str){
	var _categories1 = eval(categories1);
	var _series = eval("[{"+
		"name: '<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>',"+//审批中
		"data: "+sum_applyAmt_str+
	"}, {"+
		"name: '<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>',"+//已发生
		"data: "+sum_actualAmt_str+","+
	"}]");
	jQuery('#chartdiv').html("");
	jQuery('#chartdiv').highcharts({
		chart: {type: 'column'},
		title: {text: ''},
		xAxis: {categories: _categories1},
		yAxis: {title: {text: '<%=SystemEnv.getHtmlLabelName(534,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")"%>'}},
		tooltip: {useHTML: true},
		plotOptions: {
			column: {borderWidth:0}
		},
		exporting: {enabled: false},
		series: _series
	});
}
</script>
</body>
</html>