<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%
	String userid = user.getUID()+"";
	if(cmutil.getGoalMaint(userid)[0]<2){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<HTML>
	<HEAD>
		<title>目标导入</title>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<%
		String imagefilename = "/images/hdMaintenance.gif";
		String titlename = "目标导入";
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp"%>

		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(615, user.getLanguage())
					+ ",javascript:onSave(this),_top} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>

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
									<FORM id="cms" name="cms" action="GoalImportOperation.jsp" method="post" enctype="multipart/form-data">
										<INPUT class=InputStyle type=hidden name=userId value="<%=user.getUID()%>">
										<INPUT class=InputStyle type=hidden name=userLanguage value="<%=user.getLanguage()%>">
										<TABLE class="ViewForm">
											<COLGROUP>
												<COL width="20%">
												<COL width="80%">
											</COLGROUP>
												<TBODY>
													<TR class=Title>
														<TH colSpan="2">目标导入</TH>
													</TR>
													<TR class=Spacing style="height: 1px;">
														<TD class=Line1 colSpan="2"></TD>
													</TR>
													<tr>
														<td>
															<%=SystemEnv.getHtmlLabelName(16699, user.getLanguage())%>
														</td>
														<td class=Field>
															<input  type=file size=40 name="filename" id="filename" />
														</TD>
													</tr>
													<TR style="height: 1px;">
														<TD class=Line colSpan="2"></TD>
													</TR>
													
													
													<tr>
														<td id="msg" align="left" colspan="2">
															<font size="2" color="#FF0000">
															<%
																String errormsg = Util.null2String((String) request.getSession().getAttribute("GOAL_IMPORT_INFO"));
																//String msg = Util.null2String(request.getParameter("msg"));
																//String msg2 = Util.null2String(request.getParameter("msg2"));
																out.println(errormsg);
																request.getSession().setAttribute("GOAL_IMPORT_INFO","");
															%> 
															</font>
														</td>
													</tr>
													
													<TR style="height: 15px;">
														<TD height="15" colspan="2"></TD>
													</TR>
												</TBODY>
										</table>
										<TABLE class="ViewForm">
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

													<TR>
														<TD colspan="2">
															<p>
																<strong>导入步骤：</strong>
															</p>

															<ul>
																<li>
																	第一步，先下载Excel文档模板：
																	<a href=GoalImport.xls>目标导入模板</a>。
																</li>
																<li>
																	第二步，下载后，填写内容，注意，要填写的内容在下边的说明中有详细的说明，请一定要确定你的Excel文档的格式是模板中的格式，而没有被修改掉。<br>
																	(<u>建议导入已有excel文件数据时将原excel信息对应复制到模板中，复制时进行“选择性粘贴”，并选择“数值”，之后进行导入</u>)
																</li>
																<li>
																	第三步，点击右键的提交，进行信息的导入。
																</li>
																<li>
																	第四步，如果以上步骤和Excel文件正确的话，则会被正确的导入，也会出现提示。如果有问题，可点击“查看详细信息”进行查看。 
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
																	一次性导入的记录不要太多，建议控制在 <b>1000</b> 以内。
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
													<TR>
														<TD valign="top" colspan="2">
															<table width="100%">
																<tr>
																	<td valign="top" width="23%">
																		<p><strong>字段说明</strong></p>
													                    <ul>
																		  <li style="color: #FF0000">标识：每条数据的唯一标识项，可用p1,p2,p3,p4...表示，需确保此标识没有重复</li>
																		  <li style="color: #FF0000">上级标识：用于表示上级目标的标识，如果此目标的上级目标已经在系统中存在，则可直接填写上级目标在系统中的id值，如果上级目标在导入文件中，则填写上级目标的标识值</li>
																		  <li style="color: #FF0000">目标名称：填写目标的名称</li>
																		  <li style="color: #FF0000">目标类型：可填写内容包括“财务效益类”、“客户运营类”、“内部经营类”、“学习成长类”、“备忘类”</li>
																		  <li style="color: #FF0000">目标周期：用数字来表示目标的周期类型，对应关系为 月度-1  季度-2 年度-3 三年-4 五年-5</li>
																		  <li>责任人：此处填写责任人在系统中的id值，人员名称与id的对应关系可在导入模板的sheet2中进行查找</li>
																		  <li>目标值：填写对应的目标值</li>
																		  <li>目标值单位：填写对应的目标值单位</li>
																		  <li>完成值：填写对应的完成值</li>
																		  <li>完成值单位：填写对应的完成值单位</li>
																		  <li>年份：目标结束日期对应的年份，如不填写则默认为当前年份</li>
																		  <li>月份：目标结束日期对应的月份，如不填写则默认为当前月份</li>
																		  <li>季度：目标结束日期对应的季度，如不填写则默认为当前季度</li>
																		  <li>名称附加：此列主要是针对目标名称相似时使导入数据录入更加方便，例如目标名称为XXX有效合同金额，则可在目标名称中填入XXX，在此列中填入“有效合同金额”，最终导入系统中的实际目标名称为“目标名称”+“名称附加信息”</li>
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
			<img src="/image_secondary/cm/loading2.gif" />
		</div>
	</body>


<script language="javascript">
function onSave(obj){
	if (jQuery("#filename").val()==""){
		alert("<%=SystemEnv.getHtmlLabelName(18618, user.getLanguage())%>");
	}else{
		var showTableDiv  = $G('_xTable');
		var message_table_Div = document.createElement("div");
		message_table_Div.id="message_table_Div";
		message_table_Div.className="xTable_message";
		showTableDiv.appendChild(message_table_Div);
		var message_table_Div  = document.getElementById("message_table_Div");
		message_table_Div.style.display="inline";
		message_table_Div.innerHTML="<img src='/image_secondary/cm/loading.gif' />";
		var pTop= document.body.offsetHeight/2-60;
		var pLeft= document.body.offsetWidth/2-100;
		message_table_Div.style.position="absolute";
		message_table_Div.style.posTop=pTop;
		message_table_Div.style.posLeft=pLeft;
	
		jQuery("#cms").submit();
		obj.disabled = true;
	}
}
</script>
