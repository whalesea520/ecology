<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.Util"%>

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
	DecimalFormat df = new DecimalFormat("#################################################0.00");

	User user = HrmUserVarify.getUser (request , response) ;
	 if(user==null){
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }
	String amountBorrowBefore = df.format(Util.getDoubleValue(Util.null2String(request.getParameter("amountBorrowBefore")),0));
	String amountBorrowAfter = Util.null2String(request.getParameter("amountBorrowAfter"));
	String rowId = Util.null2String(request.getParameter("rowId"));
	String memo1 = Util.null2String(request.getParameter("memo1"));
	int wfType = Util.getIntValue(Util.null2String(request.getParameter("wfType")),0);
	
	String title1 = SystemEnv.getHtmlLabelName(83239,user.getLanguage());
	String title2 = SystemEnv.getHtmlLabelName(83240,user.getLanguage());
	String title3 = SystemEnv.getHtmlLabelName(83241,user.getLanguage());
%>
	<script type="text/javascript">
		function onSave(){
			var amountBorrowBefore = jQuery("#amountBorrowBefore").attr("value");
			var memo1 = jQuery("#memo1").attr("value");
			var amountBorrowAfter = jQuery("#amountBorrowAfter").attr("value");
			
			if(checknum(amountBorrowAfter)){
				amountBorrowAfter = (amountBorrowAfter*1.0).toFixed(2);
				parent.setTzsmValue("<%=rowId%>", amountBorrowBefore, amountBorrowAfter, memo1);
				
				parent.closeDialog();
			}else{
				alert("<%=SystemEnv.getHtmlLabelName(19298,user.getLanguage()) %>");
				jQuery("#amountBorrowAfter").attr("value","");
			}
			
			
		}
		function onCancel(){
			parent.closeDialog();
		}
		
		function checknum(amountBorrowAfter) { 
		　　if (isNaN(amountBorrowAfter)) { 
		　　　　return false;
		　　}else{
				return true;
		　　}
		}
	</script>
</head>
<body>
 <TABLE style="margin-top:5px;padding:0;table-layout:fixed;border:1px solid #D8DDE4;" width="100%">
    <COLGROUP> <COL width="25%"> <COL width="75%"></COLGROUP>
    <TBODY> 
      <tr style="padding-bottom:6px;padding-top:6px;background-color:#EFF2F6;border-bottom:1px solid #D8DDE4;"> 
      	<td><%=title1 %></td>
      	<td class=Field> 
       		<span id="oldamount_span" ><%=amountBorrowBefore%></span>
			<input type="hidden" id="amountBorrowBefore" name="amountBorrowBefore" value="<%=amountBorrowBefore%>"><br>
      </td>
    </tr>
     <tr style="padding-bottom:6px;padding-top:6px;background-color:#EFF2F6;border-bottom:1px solid #D8DDE4;"> 
     	<td><%=title2 %></td>
      	<td class=Field> 
       		<input type="text" id="amountBorrowAfter" name="amountBorrowAfter" value="<%=amountBorrowAfter %>" size="12"><br>
     	 </td>
     </tr>
     <tr style="padding-bottom:6px;padding-top:6px;background-color:#EFF2F6;border-bottom:1px solid #D8DDE4;">
     	<td><%=title3 %></td>
     	<td>
     		<input type="text" id="memo1" name="memo1" size="12" value="<%=memo1%>">
     	</td>
     </tr>
    <tr style="padding-bottom:6px;padding-top:6px;background-color:#EFF2F6;border-bottom:1px solid #D8DDE4;">
    	<td colspan="2" > 
    		<center>
	    		<div  style="width:210px;margin-bottom:10px;margin-top:5px;">
		    		<div class="operationBt width50" onclick="onSave();"><%=SystemEnv.getHtmlLabelName(16631,user.getLanguage()) %></div>
		    		<div class="operationBt width50" onclick="onCancel();"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %></div>
	    		</div>
    		</center>
		</td>
    </tr>
				
				
	</TBODY>
</TABLE>
			
	
</body>
</html>