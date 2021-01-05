
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

	</head>
	<%
		String error = "";
		int importStart = 0;
		int importEnd = 23;
		int importCount = 200;
		rs.executeSql("select importStart,importEnd,importCount from CRM_BatchOperateSetting");
		if(rs.next()){
			importStart = rs.getInt(1);
			importEnd = rs.getInt(2);
			importCount = rs.getInt(3);
		}
		//工作日需判断时间段
		if(HrmScheduleDiffUtil.getIsWorkday(TimeUtil.getCurrentDateString())){
			int hour = Integer.parseInt(TimeUtil.getFormartString(new Date(),"H"));
			//System.out.println("hour:"+hour);
			if(importStart>importEnd){
				if(!(hour > importStart || hour == importStart || hour < importEnd)){
					error += "为提高性能，系统只允许在 <b>"+importStart+"</b> 点之后或者  <b>"+importEnd+"</b> 点之前进行客户批量导入操作！";
				}
			}else{
				if(!((hour > importStart || hour == importStart) && (hour < importEnd))){
					error += "为提高性能，系统只允许在  <b>"+importStart+"</b> 点到  <b>"+importEnd+"</b> 点之间进行客户批量导入操作！";
				}
			}
		}
	
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(18038, user.getLanguage());
		String needfav = "1";
		String needhelp = "";
		String sql = "";
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(error.equals("")){
				RCMenu += "{" + SystemEnv.getHtmlLabelName(615, user.getLanguage())
					+ ",javascript:onSave(this),_top} ";
				RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
				<tr style="height: 1px;">
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<TABLE class=Shadow>
							<tr>
								<td valign="top">
									<FORM id=cms name=cms action="CustomerImportOperation.jsp" method=post
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
														<TH colSpan="2"><%=SystemEnv.getHtmlLabelName(18038, user.getLanguage())%>
														<span style="color: #804000;font-weight: normal;font-style: normal;">(提示：休息日已取消导入时段限制！)</span>
														</TH>
													</TR>
													<TR class=Spacing style="height: 1px;">
														<TD class=Line1 colSpan="2"></TD>
													</TR>
													<%if(!error.equals("")){ %>
													<tr>
														<td colSpan="2" style="color:red">
															系统提示：<%=error %>
														</td>
													</tr>
													<TR style="height: 1px;">
														<TD class=Line colSpan="2"></TD>
													</TR>
													<%}else{ %>
													<tr>
														<td>
															<%=SystemEnv.getHtmlLabelName(16699, user.getLanguage())%>
														</td>
														<td class=Field>
															<input  type=file size=40 name="filename" id="filename">
														</TD>
													</tr>
													<TR style="height: 1px;">
														<TD class=Line colSpan="2"></TD>
													</TR>
													<tr>
														<td>
															<%=SystemEnv.getHtmlLabelName(1278, user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(25171, user.getLanguage())%>)
														</td>
														<td class=Field>
												            <INPUT class="wuiBrowser" type="hidden" id="managerId" name="managerId" value="<%=user.getUID() %>"
																_displayTemplate="<a href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</a>" 
																_displayText="<%=user.getUsername() %>" _required="yes"  
								          	 					_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" />
														</TD>
													</tr>
													<TR style="height: 1px;">
														<TD class=Line colSpan="2"></TD>
													</TR>
													<TR>
														<TD>默认状态</TD>
														<TD class=Field>
															<INPUT class="wuiBrowser" type="hidden" id="CustomerStatus" name="CustomerStatus" value="1"
																_displayTemplate="<a href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</a>" 
																_displayText="<%=CustomerStatusComInfo.getCustomerStatusname("1") %>" _required="yes"  
								          	 					_url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp" />
								          	 					
								          	 				<font style="color: #800000">(导入模板中增加了客户状态列，如果导入文件中不存在客户状态，则系统会自动读取此处的默认状态并保存)</font>
														</TD>
													</TR>
													<TR style="height: 1px;"><TD class=Line colSpan="2"></TD></TR>
													<TR>
														<TD>默认级别</TD>
														<TD class=Field>
															<select name="rating">
																<option value="1">1</option>
																<option value="2">2</option>
																<option value="3">3</option>
																<option value="4">4</option>
																<option value="5">5</option>
																<option value="6">6</option>
																<option value="7">7</option>
															</select>
															
															<font style="color: #800000">(导入模板中增加了客户级别列，如果导入文件中不存在客户级别，则系统会自动读取此处的默认级别并保存)</font>
														</TD>
													</TR>
													<TR style="height: 1px;"><TD class=Line colSpan="2"></TD></TR>
													
													<tr>
														<td id="msg" align="left" colspan="2">
															<font size="2" color="#FF0000">
															<%
																String msg = Util.null2String(request.getParameter("msg"));
																String msg2 = Util.null2String(request.getParameter("msg2"));
																out.println(msg);
																if (!msg.equals("")) {
															%> 
																<a href="###" onclick="window.open('CustomerImportInfo.jsp','','width=550,height=500,scrollbars=1')">
																	<%=SystemEnv.getHtmlLabelName(1293, user.getLanguage())%>
																</a>
															<%
																}
																out.println(msg2);
															%>
															</font>
														</td>
													</tr>
													<%} %>
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
															  <li><strong>Step One,</strong><a href=CustomerImport.xls>Download excel document mould</a> first.</li>
															  <li><strong>Step Two,</strong>After downloaded,input the content.The content should be inputed has more description.Confirm the format of your excel file has the same to the mould,and hasn't been updated.</li>
															  <li><strong>Step Three,</strong>The customer manager couldn't be selected.The default customer manager is the importer.</li>
															  <li><strong>Step Four,</strong>The status of customer could be selected.If the status hasn't been selected,the customer imported are invalid customer.</li>
															  <li><strong>Step Five,</strong>Click the 'submit' of right menu,turn to import of customer.</li>
															  <li><strong>Step Six,</strong>If upwards steps and excel file are true,the page will give the note of right,else it will give the wrong of the excel file.</li>
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
																<strong>Notice:</strong>
															</p>
															<ul>
															  <li>Suggest importing too much customer once,less than one <%=importCount %> better. </li>
															  <li>Customer Import will estimate whether customer repeat.If the database has the same name customers,some note could been given .</li>
															  <li>If more customers into a successful client (including the success of customers), please fill out the customer must type.</li>
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
																<ul> 
																	<li>第一步，先<a href=CustomerImport.xls>下載Excel文檔模版</a>。 </li> 
																	<li>第二步，下載後，填寫內容，注意，要填寫的內容在下邊的說明中有詳細的說明，請一定要確定你的Excel文檔的格式是模板中的格式，而沒有被修改掉。 </li> 
																	<li>第三步，選擇客戶經理，默認情況下，客戶經理是客戶導入者本人。 </li> 
																	<li>第四步，可以選擇被導入的客戶的狀態，如果不進行選擇，默認情況下導入的客戶是無效客戶。 </li> 
																	<li>第五步，點擊右鍵的提交，進入客戶的導入。 </li> 
																	<li>第六步，如果以上步驟和Excel文件正確的話，則會被正確的導入，也會出現提示。如果有問題，則會提示Excel文件的錯誤之處。 </li> 
											                     </ul> 

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
																<li style="color:#800000">
																	一次性導入的客戶不要太多，系統規定控制在 <b><%=importCount %></b> 以內。
																</li>
																<li>
																	客戶導入會判斷客戶是否重複，如果數據庫中有相同名字的客戶，則無法導入並給出相應提示。
																</li>
																<li>
																	填寫導入內容時注意模板中紅色標題字段項為必填項並注意每個字段的格式是否正確，例如：日期類型，數字類型等。
																</li>
																<li>
																	系統導入方式為逐行判斷導入，所以符合要求的記錄將被導入系統，而導入失敗的記錄會給出相應提示信息。
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
																	<a href=CustomerImport.xls>客户导入模板(20120824更新)</a>。
																</li>
																<li>
																	第二步，下载后，填写内容，注意，要填写的内容在下边的说明中有详细的说明，请一定要确定你的Excel文档的格式是模板中的格式，而没有被修改掉。<br>
																	(<u>建议导入已有excel文件数据时将原excel信息对应复制到模板中，复制时进行“选择性粘贴”，并选择“数值”，之后进行导入</u>)
																</li>
																<li>
																	第三步，选择客户经理，默认情况下，客户经理是客户导入者本人。 
																</li>
																<li>
																	第四步，可以选择被导入的客户的状态，如果不进行选择，默认情况下导入的客户是无效客户。
																</li>
																<li>
																	第五步，点击右键的提交，进行信息的导入。
																</li>
																<li>
																	第六步，如果以上步骤和Excel文件正确的话，则会被正确的导入，也会出现提示。如果有问题，可点击“查看详细信息”进行查看。 
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
																<li style="color:#800000">
																	一次性导入的记录不要太多，系统规定控制在 <b><%=importCount %></b> 以内。
																</li>
																<li>
																	客户导入会判断客户是否重复，如果数据库中有相同名字的客户，则无法导入并给出相应提示。 
																</li>
																<li>
																	填写导入内容时注意模板中的必填项同时注意特殊字段的格式是否正确，例如：日期类型，数字类型等。
																</li>
																<li>
																	系统导入方式为逐行判断导入，所以符合要求的记录将被导入系统，而导入失败的记录会给出相应提示信息。
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
													<TR>
														<TD valign="top" colspan="2">
															<table width="100%">
																<tr>
																	<td valign="top" width="23%">
																		<p><strong><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%></strong></p>
													                    <ul>
																		  <li style="color: #FF0000"><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></li><!-- 客户名称 -->
																		  <li style="color: #FF0000"><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>)</li><!-- 简称(英文) -->
																		  <li style="color: #FF0000"><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>1</li><!-- 地址1 -->
																		  <li style="color: #FF0000"><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></li><!-- 电话 -->
																		  <li style="color: #FF0000"><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></li><!-- 电子邮箱 -->
																		  <li><%=SystemEnv.getHtmlLabelName(17080,user.getLanguage())%></li><!-- 客户编码 -->
																		  <li><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%></li><!-- 邮政编码 -->
																		  <li><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></li><!-- 国家 -->
																		  <li><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></li><!-- 城市 -->
																		  <li><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></li><!-- 传真 -->
																		  <li><%=SystemEnv.getHtmlLabelName(76,user.getLanguage())%></li><!-- 网站 -->
													                    </ul> 
																	</td>
																	<td valign="top" width="25%">
																		<p><strong><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%></strong></p>
													                    <ul>
																		  <li style="color: #FF0000"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></li><!-- 姓名 -->
																		  <li><%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%>
																		  (
																			<%
																			if (rs.getDBType().equals("oracle")){
																				sql="select  fullname from CRM_ContacterTitle where rownum<=3";
																			}else if (rs.getDBType().equals("db2")){
																				sql="select fullname from CRM_ContacterTitle fetch first 3 rows only";
																			}else{
																				sql="select top 3 fullname from CRM_ContacterTitle ";
																			}
																			rs.executeSql(sql);
																			while (rs.next()){
																				out.print(rs.getString(1)+",");
																			}
																			%>
																		  ...)
																		  </li><!-- 称呼 -->
																		  <li><%=SystemEnv.getHtmlLabelName(640,user.getLanguage())%></li><!-- 工作头衔 -->
																		  <li><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></li><!-- 部门 -->
																		  <li><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></li><!-- 电子邮箱 -->
																		  <li><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></li><!-- 办公室电话 -->
																		  <li><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></li><!-- 移动电话 -->
													                    </ul> 
																	</td>
																	<td valign="top" width="30%">
																		<p><strong><%=SystemEnv.getHtmlLabelName(16378,user.getLanguage())%></strong></p><!-- 分类信息 -->
													                    <ul>
																		  <li style="color: #FF0000"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
																		  (
																			<%
																			if (rs.getDBType().equals("oracle")){
																				sql="select  fullname from Crm_CustomerType where rownum<=3";
																			}else if (rs.getDBType().equals("db2")){
																				sql="select fullname from Crm_CustomerType fetch first 3 rows only";
																			}else{
																				sql="select top 3 fullname from Crm_CustomerType ";
																			}
																			rs.executeSql(sql);
																			while (rs.next()){
																				out.print(rs.getString(1)+",");
																			}
																			%>
																		  ...)
																		  </li><!-- 类型 -->
																		  <li><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>
																		  (
																			<%
																			if (rs.getDBType().equals("oracle")){
																				sql="select  fullname from CRM_CustomerDesc where rownum<=3";
																			}else if (rs.getDBType().equals("db2")){
																				sql="select fullname from CRM_CustomerDesc fetch first 3 rows only";
																			}else{
																				sql="select top 3 fullname from CRM_CustomerDesc ";
																			}
																			rs.executeSql(sql);
																			while (rs.next()){
																				out.print(rs.getString(1)+",");
																			}
																			%>
																		  ...)
																		  </li><!-- 描述 -->
																		  <li><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%>
																		  (
																			<%
																			if (rs.getDBType().equals("oracle")){
																				sql="select  fullname from CRM_CustomerSize where rownum<=3";
																			}else if (rs.getDBType().equals("db2")){
																				sql="select fullname from CRM_CustomerSize fetch first 3 rows only";
																			}else{
																				sql="select top 3 fullname from CRM_CustomerSize ";
																			}
																			rs.executeSql(sql);
																			while (rs.next()){
																				out.print(rs.getString(1)+",");
																			}
																			%>
																		  ...)
																		  </li><!-- 规模 -->
																		  <li><%=SystemEnv.getHtmlLabelName(645,user.getLanguage())%>
																		  (
																			<%
																			if (rs.getDBType().equals("oracle")){
																				sql="select  fullname from CRM_ContactWay where rownum<=3";
																			}else if (rs.getDBType().equals("db2")){
																				sql="select fullname from CRM_ContactWay fetch first 3 rows only";
																			}else{
																				sql="select top 3 fullname from CRM_ContactWay ";
																			}
																			rs.executeSql(sql);
																			while (rs.next()){
																				out.print(rs.getString(1)+",");
																			}
																			%>
																		  ...)
																		  </li><!-- 获得途径 -->
																		  <li><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></li><!-- 行业 -->
																		  <li><%=SystemEnv.getHtmlLabelName(25171,user.getLanguage())%></li><!-- 开拓人员 -->
																		  <li><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></li><!-- 级别 -->
													                    </ul> 
																	</td>
																	<td valign="top" width="22%">
																		<p><strong><%=SystemEnv.getHtmlLabelName(15125,user.getLanguage())%></strong></p><!-- 帐务 -->
													                    <ul>
																		  <li><%=SystemEnv.getHtmlLabelName(17084,user.getLanguage())%></li><!-- 开户银行 -->
																		  <li><%=SystemEnv.getHtmlLabelName(571,user.getLanguage())%></li><!-- 账户 -->
																		  <li><%=SystemEnv.getHtmlLabelName(17085,user.getLanguage())%></li><!-- 银行帐号 -->
													                    </ul> 
													                    
													                    <p><strong><%=SystemEnv.getHtmlLabelName(17532,user.getLanguage())%></strong></p><!-- 联系记录 -->
													                    <ul>
																		  <li><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())+SystemEnv.getHtmlLabelName(97,user.getLanguage())%>
																		  (<%=SystemEnv.getHtmlLabelName(15196,user.getLanguage())%>:yyyy-MM-dd)
																		  </li><!-- 联系日期 -->
																		  <li><%=SystemEnv.getHtmlLabelName(1275,user.getLanguage())%>
																		  (<%=SystemEnv.getHtmlLabelName(15196,user.getLanguage())%>:HH:ss)
																		  </li><!-- 联系时间 -->
																		  <li><%=SystemEnv.getHtmlLabelName(24983,user.getLanguage())%></li><!-- 联系内容 -->
													                    </ul> 
																	</td>
																</tr>
															</table>
										  				</TD>
													</TR>
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
