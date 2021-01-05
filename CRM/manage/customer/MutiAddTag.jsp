
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
String crmids = Util.null2String(request.getParameter("crmids"));
List crmidList = Util.TokenizerString(crmids,",");
String customerid = "";
String customerids = "";
String customernames = "";
for(int i=0;i<crmidList.size();i++){
	customerid = Util.null2String((String)crmidList.get(i));
	if(!customerid.equals("")){
		customerids += "," + customerid;
		customernames += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+customerid+"')>"+ CustomerInfoComInfo.getCustomerInfoname(customerid)+"</a> "; 
	}
}
if(!customerids.equals("")) customerids = customerids.substring(1);
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<style type="text/css">
			TABLE.ViewForm TD.Field{background-color: #F8F8F8;}
			TABLE.ViewForm TD.Line1{background-color: #DDDDDD;}
			TABLE.ViewForm TD.Line{background-color: #DDDDDD;}
			TABLE.ListStyle TR.Header TD{background: #F8F8F8;}
			
			a.submitbtn{width: 90px;height: 26px;line-height: 26px;color: #fff !important;background: #02AFF1;text-align: center;display: block;margin: 0px auto;text-decoration: none !important;}
			a.submitbtn:hover{background: #02A3DF;text-decoration: none !important;color: #fff !important;}
			
			.msg{width: 100%;line-height: 40px;text-align: center;font-weight: bold;}
		</style>
	</HEAD>
	<BODY style="background: transparent;">
		<%if(customerids.equals("")){ %>
			<div class="msg">无可添加标签的客户，请重新选择！</div>
		<%}else{ %>
		<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
			<tr>
				<td height="10" colspan="3" style="padding: "></td>
			</tr>
			<tr>
				<td ></td>
				<td valign="top">
					<TABLE class=Shadow style="height: auto;">
					<tr>
					<td valign="top">
			
						<FORM id=weaver name=weaver action="/CRM/manage/customer/Operation.jsp" method=post target="submitiframe">
							<input type="hidden" name="customerids" value="<%=customerids%>">
							<input type="hidden" name="operation" value="batch_save_tag">
				  			<TABLE class=ViewForm>
						        <COLGROUP>
									<COL width="20%">
						  			<COL width="80%">
						  		</COLGROUP>
						        <TBODY>
							        <TR class=Title>
							            <td>待添加客户：</td>
							            <td><%=customernames %></td>
							       	</TR>
							        <TR class=Spacing style="height: 1px">
							          	<TD class=Line1 colSpan=2></TD></TR>
							        <TR>
							        	<td>标签：</td>
								        <TD class=field>
											<input class="inputstyle" type="text" id="tag" name="tag" value="" maxlength="50" onchange='checkinput("tag","tagimage")'/>
											<span id="tagimage"><IMG src='/images/BacoError_wev8.gif' align=absMiddle /></span>
					 					</TD>
									</TR>
									<TR style="height: 1px">
										<TD class=Line colSpan=2></TD>
									</TR>
								</TBODY>
				  			</TABLE>
						</form>
					</td>
					</tr>
					<tr><td style="height: 20px;"></td></tr>
					<tr>
						<td align="center">
							<a class="submitbtn" href="javascript:doSubmit()">提交</a>
						</td>
					</tr>
					</TABLE>
				</td>
				<td></td>
			</tr>
			<tr>
				<td height="10" colspan="3" style="padding: 0"></td>
			</tr>
		</table>
		<iframe id="submitiframe" name="submitiframe" src="" style="display: none;"></iframe>
		<script language=javascript>
			jQuery(document).ready(function(){
				jQuery("#submitiframe").load(function(){
					parent.completeOperate(2,jQuery("#tag").val());
				});
			});
			function doSubmit() {
				if(jQuery("#tag").val()==""){
					alert("请输入标签内容!");
			        return;
				}
				if(confirm("确定进行添加标签操作？")){
					jQuery("a.submitbtn").hide();
					parent.showeLoad();
					weaver.submit();
				}
			}
		</script>
		<%} %>
	</BODY>
</HTML>
