
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = "渠道" + SystemEnv.getHtmlLabelName(18038, user.getLanguage());
		String needfav = "1";
		String needhelp = "";
		String type = Util.null2String(request.getParameter("type"));
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(615, user.getLanguage())
					+ ",javascript:onSave(this),_top} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
				<tr style="height: 10px;">
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<TABLE class=Shadow>
							<tr>
								<td valign="top">
									<FORM id=cms name=cms action="CustomerChannelImportOperation.jsp" method=post
										enctype="multipart/form-data">
										<INPUT class=InputStyle type=hidden name=userId value="<%=user.getUID()%>">
										<INPUT class=InputStyle type=hidden name=userLanguage value="<%=user.getLanguage()%>">
										<TABLE class="viewForm">
											<COLGROUP>
												<COL width="20%">
												<COL width="80%">
											</COLGROUP>
												<TBODY>
													<TR class=Title>
														<TH colSpan="2"><%="渠道" + SystemEnv.getHtmlLabelName(18038, user.getLanguage())%></TH>
													</TR>
													<TR class=Spacing style="height: 1px;">
														<TD class=Line1 colSpan="2"></TD>
													</TR>
													<tr>
														<td class=Field>
															<%=SystemEnv.getHtmlLabelName(16699, user.getLanguage())%>
														</td>
														<td>
															<input type=file size=40 name="filename" id="filename">
														</TD>
													</tr>
													<TR style="height: 1px;">
														<TD class=Line colSpan="2"></TD>
													</TR>
													<tr>
														<td class=Field>
															<%=SystemEnv.getHtmlLabelName(1278, user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(25171, user.getLanguage())%>)
														</td>
														<td>
												            <INPUT class="wuiBrowser" type="hidden" id="managerId" name="managerId" value="<%=user.getUID() %>"
																	_displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
					          	 									_displayText="<%=user.getUsername() %>"
					          	 									_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" />	
														</TD>
													</tr>
													<TR style="height: 1px;">
														<TD class=Line colSpan="2"></TD>
													</TR>
													<tr>
														<td id="msg" align="left" colspan="2">
															<font size="2" color="#FF0000">
															<%
																String msg = Util.null2String(request.getParameter("msg"));
																out.println(msg);
																if (!msg.equals("")) {
															%> 
																<a href="###" onclick="window.open('CustomerChannelImportInfo.jsp','','width=550,height=500,scrollbars=1')">
																	<%=SystemEnv.getHtmlLabelName(1293, user.getLanguage())%>
																</a>
															<%
																}
															%>
															</font>
														</td>
													</tr>

													<TR style="height: 15px;">
														<TD height="15" colspan="2"></TD>
													</TR>
												</TBODY>
										</table>
										<TABLE class="viewForm">
											<COLGROUP>
												<COL width="50%">
												<COL width="50%">
											</COLGROUP>
												<TBODY>
													<TR class=Title>
														<TH colSpan="2"><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%></TH>
													</TR>
													<TR class=Spacing style="height: 1px;">
														<TD class=Line1 colSpan="2"></TD>
													</TR>
													<%
														if (user.getLanguage() == 8) {
													%>
													<TR>
														<TD colspan="2">
															<p>
																<strong>Import Step:</strong>
															</p>

															<ul>
																<li>
																	First，down import template：
																	<a href=CustomerChannelImport.xls>CustomerInfoImportTemplate</a>.
																</li>
															</ul>

														</TD>
													</TR>
													<TR style="height: 1px;">
														<TD class=Line colSpan="2"></TD>
													</TR>

													<TR style="height: 1px;">
														<TD height="15" colspan="2"></TD>
													</TR>
													<TR>
														<TD colspan="2">
															<p>
																<strong>Notice:</strong>
															</p>

															<ul>

															</ul>

														</TD>
													</TR>
													<TR style="height: 1px;">
														<TD class=Line colSpan="2"></TD>
													</TR>

													<TR style="height: 15px;">
														<TD height="15" colspan="2"></TD>
													</TR>
													<%
														} else if (user.getLanguage() == 9) {
													%>
													<TR>
														<TD colspan="2">
															<p>
																<strong>導入步驟：</strong>
															</p>

															<ul>
																<li>
																	第一步，先下載Excel文檔模板：
																	<a href=CustomerChannelImport.xls>渠道客戶導入模板</a>。
																</li>
																<li>
																	第二步，下載後，填寫內容，請確定你的Excel文檔的格式是模板中的格式，而沒有被修改掉。
																</li>
																<li>
																	第三步，選擇填寫好的導入文件。
																</li>
																<li>
																	第四步，選擇客戶經理，不選則默認為當前用戶。
																</li>
																<li>
																	第五步，點擊右鍵的提交，進行信息的導入。
																</li>
																<li>
																	第六步，如果以上步驟和Excel文件正確的話，則會被正確的導入，也會出現提示。如果有問題，則會提示Excel文件的錯誤之處。
																</li>

															</ul>

														</TD>
													</TR>
													<TR style="height: 1px;">
														<TD class=Line colSpan="2"></TD>
													</TR>

													<TR style="height: 15px;">
														<TD height="15" colspan="2"></TD>
													</TR>
													<TR>
														<TD colspan="2">
															<p>
																<strong>注意事項：</strong>
															</p>

															<ul>
																<li>
																	填寫導入內容時注意模板中紅色標題字段項為必填項並注意每個字段的格式是否正確，例如：日期類型，數字類型等。
																</li>
																<li>
																	系統導入方式為逐行判斷導入，所以符合要求的記錄將被導入系統，而導入失敗的記錄會給出相應提示信息。
																</li>
																<li>
																	建議一次性導入的客戶不要太多，控制在100以內。
																</li>
															</ul>

														</TD>
													</TR>
													<TR style="height: 1px;">
														<TD class=Line colSpan="2"></TD>
													</TR>

													<TR style="height: 15px;">
														<TD height="15" colspan="2"></TD>
													</TR>
													<%
														} else {
													%>

													<TR>
														<TD colspan="2">
															<p>
																<strong>导入步骤：</strong>
															</p>

															<ul>
																<li>
																	第一步，先下载Excel文档模板：
																	<a href=CustomerChannelImport.xls>渠道客户导入模板</a>。
																</li>
																<li>
																	第二步，下载后，填写内容，请确定你的Excel文档的格式是模板中的格式，而没有被修改掉。
																</li>
																<li>
																	第三步，选择填写好的导入文件。
																</li>
																<li>
																	第四步，选择客户经理，不选择则默认为当前用户。
																</li>
																<li>
																	第五步，点击右键的提交，进行信息的导入。
																</li>
																<li>
																	第六步，如果以上步骤和Excel文件正确的话，则会被正确的导入，也会出现提示。如果有问题，则会提示Excel文件的错误之处。
																</li>
															</ul>

														</TD>
													</TR>
													<TR style="height: 1px;">
														<TD class=Line colSpan="2"></TD>
													</TR>

													<TR style="height: 15px;">
														<TD height="15" colspan="2"></TD>
													</TR>
													<TR>
														<TD colspan="2">
															<p>
																<strong>注意事项：</strong>
															</p>

															<ul>
																<li>
																	填写导入内容时注意模板中红色标题字段项为必填项同时注意每个字段的格式是否正确，例如：日期类型，数字类型等。
																</li>
																<li>
																	系统导入方式为逐行判断导入，所以符合要求的记录将被导入系统，而导入失败的记录会给出相应提示信息。
																</li>
																<li>
																	建议一次性导入的记录不要太多，控制在100以内。
																</li>
															</ul>

														</TD>
													</TR>
													<TR style="height: 1px;">
														<TD class=Line colSpan="2"></TD>
													</TR>

													<TR style="height: 15px;">
														<TD height="15" colspan="2"></TD>
													</TR>
													<%
														}
													%>
													<TR style="height: 1px;">
														<TD class=Line colSpan="2"></TD>
													</TR>
													<TR style="height: 15px;">
														<TD height="15" colspan="2"></TD>
													</TR>
												</TBODY>
										</table>
										<div id='_xTable' style='background: #FFFFFF; padding: 3px; width: 100%' valign='top'>
										</div>
									</FORM>
								</td>
							</tr>
							
						</TABLE>
					</td>
					<td></td>
				</tr>
				<tr style="height: 10px;">
					<td height="10" colspan="2"></td>
				</tr>
		</table>
		<div id="loadDiv" style="display: none; background-color: white">
			<img src="/image_secondary/cm/loading2_wev8.gif" />
		</div>
	</body>


<script language="javascript">
function onSave(obj){
	if (cms.filename.value==""){
		alert("<%=SystemEnv.getHtmlLabelName(18618, user.getLanguage())%>");
	}else{
		var showTableDiv  = $G('_xTable');
		var message_table_Div = document.createElement("div");
		message_table_Div.id="message_table_Div";
		message_table_Div.className="xTable_message";
		showTableDiv.appendChild(message_table_Div);
		var message_table_Div  = document.getElementById("message_table_Div");
		message_table_Div.style.display="inline";
		message_table_Div.innerHTML="<img src='/image_secondary/cm/loading_wev8.gif' />";
		var pTop= document.body.offsetHeight/2-60;
		var pLeft= document.body.offsetWidth/2-100;
		message_table_Div.style.position="absolute";
		message_table_Div.style.posTop=pTop;
		message_table_Div.style.posLeft=pLeft;
	
		cms.submit();
		obj.disabled = true;
	}
}
</script>
