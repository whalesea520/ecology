<%@page import="java.util.HashMap"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.BaseBean"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="/mobile/plugin/js/jquery/jquery_wev8.js"></script>
<style type="text/css">
	.searchText {
		width:100%;
		height:20px;
		margin-left:auto;
		margin-right:auto;
		border: 1px solid #687D97; 
		background:#fff;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px; 
		border-radius:5px;
		-webkit-box-shadow: inset 0px 5px 3px 0px #BCBFC3;
		-moz-box-shadow: inset 0px 5px 3px 0px #BCBFC3;
		box-shadow: inset 0px 5px 3px 0px #BCBFC3;
	}
	
	.operationBt {
			height:26px;
			margin-left:18px;
			line-height:26px;
			font-size:14px;
			color:#fff;
			text-align:center;
			-moz-border-radius: 5px;
			-webkit-border-radius: 5px; 
			border-radius:5px;
			border:1px solid #0084CB;
			background:#0084CB;
			background: -moz-linear-gradient(0, #30B0F5, #0084CB);
			background:-webkit-gradient(linear, 0 0, 0 100%, from(#30B0F5), to(#0084CB));
			overflow:hidden;
			float:left;
	}
	.width50 {
		width:50px;
	}
	
	.blockHead {
		width:100%;
		height:24px;
		line-height:24px;
		font-size:12px;
		font-weight:bold;
		color:#fff;
		border-top:1px solid #0084CB;
		border-left:1px solid #0084CB;
		border-right:1px solid #0084CB;
		-moz-border-top-left-radius: 5px;
		-moz-border-top-right-radius: 5px;
		-webkit-border-top-left-radius: 5px; 
		-webkit-border-top-right-radius: 5px; 
		border-top-left-radius:5px;
		border-top-left-radius:5px;
		background:#0084CB;
		background: -moz-linear-gradient(0, #31B1F6, #0084CB);
		background:-webkit-gradient(linear, 0 0, 0 100%, from(#31B1F6), to(#0084CB));
	}
	
	.m-l-14 {
		margin-left:14px;
	}
	
	
	.tblBlock {
		width:100%;
		border-left:1px solid #C5CACE;
		border-right:1px solid #C5CACE;
		border-bottom:1px solid #C5CACE;
		background:#fff;
		-moz-border-bottom-left-radius: 5px;
		-moz-border-bottom-right-radius: 5px;
		-webkit-border-bottom-left-radius: 5px; 
		-webkit-border-bottom-right-radius: 5px; 
		border-bottom-left-radius:5px;
		border-bottom-left-radius:5px;
	}
	
	#asyncbox_alert_content {
		height:auto!important;
		min-height:10px!important;
	}
	
	#asyncbox_alert{
		min-width: 220px!important;
		max-width: 280px!important;
	}
	</style>

<title>Insert title here</title>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

RecordSet rs_fna = new RecordSet();
RecordSet rs = new RecordSet();
DecimalFormat df = new DecimalFormat("#################################################0.00");

int requestid = Util.getIntValue(request.getParameter("requestid"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int jklc = Util.getIntValue(request.getParameter("jklc"));
int rowId = Util.getIntValue(request.getParameter("rowId"));
int main_fieldIdSqr_controlBorrowingWf = Util.getIntValue(request.getParameter("main_fieldIdSqr_controlBorrowingWf"));
int main_fieldIdSqr_value = Util.getIntValue(request.getParameter("main_fieldIdSqr_value"));


int jklcFormid = 0;
int jklcFormidAbs = 0;
int jklcWfid = 0;
String requestname = "";

String sql = "select b.formid, a.requestname, a.workflowid \n" +
	" from workflow_requestbase a \n" +
	" join workflow_base b on a.workflowid = b.id \n" +
	" where a.requestid = "+jklc;
rs_fna.executeSql(sql);
if(rs_fna.next()){
	jklcFormid = Util.getIntValue(rs_fna.getString("formid"));
	jklcFormidAbs = Math.abs(jklcFormid);
	requestname = Util.null2String(rs_fna.getString("requestname")).trim();
	jklcWfid = Util.getIntValue(rs_fna.getString("workflowid"));
}

HashMap<String, String> dataMap_jklc = new HashMap<String, String>();
FnaCommon.getFnaWfFieldInfo4Expense(jklcWfid, dataMap_jklc);

String dt1_fieldIdJklx = Util.null2String(dataMap_jklc.get("dt1_fieldIdJklx_fieldId"));
String dt1_fieldNameJklx = Util.null2String(dataMap_jklc.get("dt1_fieldIdJklx_fieldName"));
String dt1_fieldNameJkje = Util.null2String(dataMap_jklc.get("dt1_fieldIdJkje_fieldName"));
String dt1_fieldNameJksm = Util.null2String(dataMap_jklc.get("dt1_fieldIdJksm_fieldName"));

String applicantid = "";//借款流程申请人
sql = "select * from FnaBorrowInfo where requestid = "+jklc;
rs_fna.executeSql(sql);
if(rs_fna.next()){
	applicantid = Util.null2String(rs_fna.getString("applicantid")).trim();
}
%>
<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery("tr").mouseover(function(){
			jQuery(this).css("background-color","#D8DDE4");
		});
		jQuery("tr").mouseout(function(){
			jQuery(this).css("background-color","#EFF2F6");
		});
		jQuery("tr").click(function(){
			var canClick = jQuery(this).attr("canClick");
			if(canClick == '0'){
				return;
			}else if(canClick == '1'){
				var id = jQuery(this).attr("id");
				
				parent.fnaRepayCallBack2(id, <%=rowId%>);
				parent.closeDialog();
				
			}
		});
		
	});
	
	function onCancel(){
		parent.closeDialog();
	}
	
</script>
</head>
<body>
 <TABLE style="margin-top:5px;padding:0;table-layout:fixed;border:1px solid #D8DDE4;" width="100%">
    <COLGROUP> 
	  <%if(!"".equals(dt1_fieldNameJksm)){ %>
    	<COL width="10%"> 
    	<COL width="15%">
    	<COL width="25%">
    	<COL width="25%">
    	<COL width="25%">
      <%}else{ %>
    	<COL width="10%"> 
    	<COL width="20%">
    	<COL width="35%">
    	<COL width="35%">
      <%} %>
    </COLGROUP>
    <thead>
    	<tr>
	      <th><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage()) %></th>
	      <th><%=SystemEnv.getHtmlLabelName(22138,user.getLanguage()) %></th>
	      <th><%=SystemEnv.getHtmlLabelName(1043,user.getLanguage()) %></th>
	      <th><%=SystemEnv.getHtmlLabelName(83288,user.getLanguage()) %></th>
	      <%if(!"".equals(dt1_fieldNameJksm)){ %>
	       <th><%=SystemEnv.getHtmlLabelName(83354,user.getLanguage()) %></th>
	      <%} %>
   	 </tr>
  </thead>
    <TBODY> 
<%
	int currentUid = user.getUID();
	if(main_fieldIdSqr_controlBorrowingWf==1){
		currentUid = main_fieldIdSqr_value;
	}

	FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();
	//设置好搜索条件
	String backFields =" row_number() over(order by dt.id asc) as row_num_dtl, dt.*, ";
	backFields += " (select SUM(fbi.amountBorrow * fbi.borrowDirection) sum_amountBorrow \n" +
			"	from FnaBorrowInfo fbi \n" +
			"	where fbi.requestid <> "+requestid+" and fbi.borrowRequestIdDtlId = dt.id \n" +
			"		and fbi.borrowRequestId = main.requestId \n" +
			"	GROUP BY fbi.borrowRequestId, fbi.borrowRequestIdDtlId) sum_amountBorrow \n";
	
	String fromSql = " from formtable_main_"+jklcFormidAbs+"_dt1 dt " +
			" join formtable_main_"+jklcFormidAbs+" main on main.id=dt.mainid ";
	
	String sqlWhere = " where main.requestId="+jklc+" ";

	String orderBy = " dt.id ";
	
	sql = "select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy;
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	rs.executeSql(sql);
    while(rs.next()){
		String _rownum = rs.getString("row_num_dtl");
		String _jklx = rs.getString(dt1_fieldNameJklx);
		String _jkje = rs.getString(dt1_fieldNameJkje);
		double _sum_amountBorrow = rs.getDouble("sum_amountBorrow");
		String _jksm = rs.getString(dt1_fieldNameJksm);
		String _dtid = rs.getString("id");
		
		String _trid = _rownum+"_"+_dtid;
		
		
		String _jklxName = fnaSplitPageTransmethod.getBorrowTypeName(_jklx, dt1_fieldIdJklx);
		
		boolean canClick = true;
		if("0".equals(_jklx) && Util.getIntValue(applicantid)!=currentUid){
			canClick = false;
		}else if(_sum_amountBorrow <= 0){
			canClick = false;
		}
		out.println("<tr id='"+_trid+"' canClick='"+(canClick?"1":"0")+"' style='padding-bottom:6px;padding-top:6px;background-color:#EFF2F6;border-bottom:1px solid #D8DDE4;'>");
    	out.println("	<td>");
    	out.println(		_rownum);
    	out.println("	</td>");
    	out.println("	<td>");
    	out.println(		_jklxName);
    	out.println("	</td>");
    	out.println("	<td>");
    	out.println(		_jkje);
    	out.println("	</td>");
		out.println("	<td>");
		out.println(		df.format(_sum_amountBorrow));
    	out.println("	</td>");
		if(!"".equals(dt1_fieldNameJksm)){
	    	out.println("	<td>");
	    	out.println(		_jksm);
	    	out.println("	</td>");
		}
    	
    	
    	out.println("</tr>");
    }
%>
	</TBODY>
</TABLE>
			
	
</body>
</html>