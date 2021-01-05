
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
	String customerId = Util.null2String(request.getParameter("customerId"));
	int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),customerId);
	if(sharelevel<=0){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<HTML>
	<HEAD>
		<title>添加联系记录</title>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</head>
	<%
	%>
	<BODY style="overflow: hidden;">
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<TABLE class=Shadow>
							<tr>
								<td valign="top">
									<FORM id=weaver name=frmMain action="UpdateStatusOperation.jsp" method=post>
										<input type="hidden" name="method" value="addquick">
										<input type="hidden" name="ParentID" value="0">
										<input type="hidden" name="isSub" value="0">
										<input type="hidden" name="CustomerID" value="<%=customerId%>">
										<input type="hidden" name="Subject" value="客户联系">
										<input type="hidden" name="isfinished" value="1">
										<input type="hidden" name="isPassive" value="3">
										<input type="hidden" name="isprocessed" value="1">
										<input type="hidden" name="ContactDate" value="<%=TimeUtil.getCurrentDateString()%>">
										<INPUT type="hidden" name="ContactTime" value="<%=TimeUtil.getOnlyCurrentTimeString()%>">
										<INPUT type=hidden name=ResourceID value="<%=user.getUID()%>">
										<TABLE class=Viewform>
											<COLGROUP>
												<COL width="20%">
												<COL width="80%">
											</COLGROUP>
											<TBODY>
												<TR class=Title>
													<TH colSpan=2>联系记录</TH>
												</TR>
												<TR class=Spacing style="height: 1px;">
													<TD class=Line1 colSpan=2></TD>
												</TR>
												<TR>
													<TD colspan="2">
														<TEXTAREA class=InputStyle wrap="hard" NAME="ContactInfo" id="ContactInfo" ROWS=8 STYLE="width:98%" onchange='checkinput("ContactInfo","ContactInfoImage")'></TEXTAREA>
														<SPAN id="ContactInfoImage"><IMG src="/images/BacoError_wev8.gif" align=absMiddle/></SPAN>
													</TD>
												</TR>
												<TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>
												<tr> 
											      <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></td>
											      <td class=Field>
												      <input type=hidden class="wuiBrowser" 
												      _url="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp" _param="resourceids"
												      _displayTemplate="<a href='/proj/process/ViewTask.jsp?taskrecordid=#b{id}'>#b{name}</a>&nbsp"
												      name="relatedprj" value="0">
											      </td>
											    </tr>
											    <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>
											    <tr>
											      <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
											      <td class=Field>
											      	<input type=hidden  class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp"
											       	_param="resourceids" _displayText="<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customerId),user.getLanguage())%>"
											       	_displayTemplate="<a href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</a>&nbsp"
											       	name="relatedcus" value="<%=customerId%>">
											      </td>
											    </tr>
											    <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>
											    <tr>
											      <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
											      <td class=Field>
												      <input type=hidden  class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp" _param="resourceids"
												      _displayTemplate="<a href='/workflow/request/ViewRequest.jsp?requestid=#b{id}'>#b{name}</a>&nbsp"
												      name="relatedwf" value="0">
											      </td>
											    </tr>
											    <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>
											    <tr>
											      <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
											      <td class=Field>
												      <input type=hidden class="wuiBrowser" _url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" _param="documentids"
												      _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>&nbsp"
												       name="relateddoc" value="0">
											      </td>
											    </tr>
											    <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>
											    <tr>
											    	<td colspan="2" align="center" valign="middle" style="height: 40px;">
											    		<div id="btnarea" style="height: 25px;width: 97px;">
											    			<div id="btn_add" onclick="doSaveCrmContract()" style="cursor: pointer;width:46px;line-height:25px;background:url('/image_secondary/common/btn-1_wev8.png') no-repeat;color:#808080;text-align:center;margin-right:5px;float:left;">保存</div>
											    			<div id="btn_cancel" onclick="doCancel()" style="cursor: pointer;width:46px;line-height:25px;background:url('/image_secondary/common/btn-1_wev8.png') no-repeat;color:#808080;text-align:center;float:left;">取消</div>
											    		</div>
											    		<img id="loading" src='/images/loadingext_wev8.gif' align=absMiddle style="display: none";>
											    	</td>
											    </tr>
											    <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>
											</TBODY>
										</TABLE>
									</form>
								</td>
							</tr>
						</TABLE>
					</td>
					<td></td>
				</tr>
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
		</table>
		<script language=javascript>  
			function doSaveCrmContract(){
				if(check_form(weaver,'ContactInfo')){ 
					jQuery("#btnarea").hide();
					jQuery("#loading").show();
					var paras = getFormElements('weaver');
					var ContactInfo=jQuery("#ContactInfo").val();
					jQuery.ajax({
						type: "post",
					    url: "/CRM/data/ContactLogOperation.jsp?log=n&"+paras,
					    data:{'ContactInfo':encodeURI(ContactInfo)},
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(){ 
					    	opener.onSearch();
							window.close();
						}
				    });
				}
			}
			function getFormElements(name){
				var form = document.getElementById(name);
				var para ='';
					
				for(i=0;i<form.elements.length;i++)
				{

					if(form.elements[i].name!= ''&&form.elements[i].name!="ContactInfo"){
					    
						if(form.elements[i].value.indexOf('\n')>0){
							para+='&'+form.elements[i].name+'='+URLencode(form.elements[i].value);
						}else{
							para+='&'+form.elements[i].name+'='+URLencode(form.elements[i].value);
						}
					}
				}
				
				return para;

			}
			function URLencode(sStr) 
			{
			    return escape(sStr).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F');
			}
			function doCancel(){
				if(jQuery("#ContactInfo").val()!=""){
					if(confirm("确定取消添加联系记录?")){
						window.close();
					}
				}else{
					window.close();
				}
			}
		</script>
	</BODY>
</HTML>
