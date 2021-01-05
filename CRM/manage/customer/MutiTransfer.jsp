
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
//判断是否有批量转移权限
if(!HrmUserVarify.checkUserRight("CRM_BatchTransfer:Operate", user)){
	response.sendRedirect("/CRM/data/TransferMutiCustomerInit.jsp");
	return;
}
//判断是否在规定操作时间内
int transferStart = 0;
int transferEnd = 23;
int transferCount = 100;//每次最多可转移客户数量 默认为100
RecordSet.executeSql("select transferStart,transferEnd,transferCount from CRM_BatchOperateSetting");
if(RecordSet.next()){
	transferStart = RecordSet.getInt(1);
	transferEnd = RecordSet.getInt(2);
	transferCount = RecordSet.getInt(3);
}
int hour = Integer.parseInt(TimeUtil.getFormartString(new Date(),"H"));
if(transferStart>transferEnd){
	if(!(hour > transferStart || hour == transferStart || hour < transferEnd)){
		response.sendRedirect("/CRM/data/TransferMutiCustomerInit.jsp");
		return;
	}
}else{
	if(!((hour > transferStart || hour == transferStart) && (hour < transferEnd))){
		response.sendRedirect("/CRM/data/TransferMutiCustomerInit.jsp");
		return;
	}
}


String userid = user.getUID()+"";
String crmids = Util.null2String(request.getParameter("crmids"));
List crmidList = Util.TokenizerString(crmids,",");
String customerid = "";
String customerids = "";
String customernames = "";
int counts = 0;
for(int i=0;i<crmidList.size();i++){
	customerid = Util.null2String((String)crmidList.get(i));
	if(!customerid.equals("") && CustomerInfoComInfo.getCustomerInfomanager(customerid).equals(userid)){
		counts++;
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
			<div class="msg">无可进行转移的客户，请重新选择！</div>
		<%}else if(counts>transferCount){ %>
			<div class="msg">根据系统设置每次最多只能转移 <%=transferCount %> 条记录，请重新选择！</div>
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
			
						<FORM id=weaver name=weaver action="/CRM/data/TransferMutiCustomerOperation.jsp" method=post target="submitiframe">
							<input type="hidden" name="customerids" value="<%=customerids%>">
							<input type="hidden" name="rownum" value="">
				  			<TABLE class=ViewForm>
						        <COLGROUP>
									<COL width="20%">
						  			<COL width="80%">
						  		</COLGROUP>
						        <TBODY>
							        <TR class=Title>
							            <td>可转移客户：</td>
							            <td><%=customernames %></td>
							       	</TR>
							        <TR class=Spacing style="height: 1px">
							          	<TD class=Line1 colSpan=2></TD></TR>
							        <TR>
							        	<td>选择转移人：</td>
								        <TD class=field>
											<INPUT class="wuiBrowser" type="hidden" id="hrmId" name="hrmId" value="" _required="yes"
												_displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
				          	 					_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" />
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
							<a class="submitbtn" href="javascript:doTransfer()">提交</a>
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
					parent.completeOperate(1);
				});
			});
			function doTransfer() {
				if(jQuery("#hrmId").val()==""){
					alert("请选择转移人!");
			        return;
				}
				if(confirm("确定进行转移操作？")){
					jQuery("a.submitbtn").hide();
					parent.showeLoad();
					weaver.submit();
				}
			}
		</script>
		<%} %>
	</BODY>
</HTML>
