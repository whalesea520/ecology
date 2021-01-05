
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="sapActionManager" class="weaver.formmode.interfaces.action.SapActionManager" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

	String operate = Util.null2String(request.getParameter("operate"));
	int actionid = Util.getIntValue(Util.null2String(request.getParameter("actionid")),0);
	if(actionid <= 0){
		operate = "addsap";
	}

	int workflowid = Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
	int nodeid = Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
	//是否节点后附加操作
	int ispreoperator = Util.getIntValue(request.getParameter("ispreoperator"), 0);
	//出口id
	int nodelinkid = Util.getIntValue(request.getParameter("nodelinkid"), 0);

	String actionname = "";
	int actionorder = 0;
	String sapoperation = "";//调用的Sap的方法
	ArrayList inparaList = new ArrayList();
	ArrayList outparaList = new ArrayList();
	if("editsap".equals(operate)){
		//如果是编辑，根据actionid去取基本配置信息
		sapActionManager.setActionid(actionid);
		sapActionManager.getSapActionSetById();
		actionname = sapActionManager.getActionname();
		actionorder = sapActionManager.getActionorder();
		sapoperation = sapActionManager.getSapoperation();
		inparaList = sapActionManager.getInparaList();
		outparaList = sapActionManager.getOutparaList();
	}
	String needcheck = "actionname,actionorder,sapoperation";
	String workFlowName = "";
	int isbill = 0;
	int formid = 0;
	if(workflowid>-1){
		workFlowName = Util.null2String(WorkflowComInfo.getWorkflowname("" + workflowid));
		isbill = Util.getIntValue(WorkflowComInfo.getIsBill("" + workflowid), 0);
		formid = Util.getIntValue(WorkflowComInfo.getFormId("" + workflowid), 0);
	}
	String nodename = "";
	if(nodeid>0){
		RecordSet.executeSql("select nodename from workflow_nodebase b where b.id = "+nodeid);
		if(RecordSet.next()){
			nodename = RecordSet.getString("nodename");
		}
	}
	String linkname = "";
	if(nodelinkid>0){
		RecordSet.executeSql("select linkname from workflow_nodelink n where n.id = "+nodelinkid);
		if(RecordSet.next()){
			linkname = RecordSet.getString("linkname");
		}
	}
	//其实这里只要ArrayList放表单数据库的字段列表，Hashtable放字段对应的XML标签名字，一个放该字段是否要传值过去
	
	int cx = 0;

%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<STYLE TYPE="text/css">
		.btn_actionList
		{
			BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
		} 
		</STYLE>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(23662, user.getLanguage())+"(Sap)"; //配置接口动作(数据库DML)
		String needfav = "1";
		String needhelp = "";
	%>
	<body>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:submitData(),_self} ";//保存
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + ",javascript:deleteData(),_self} ";//删除
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form name="frmmain" method="post" action="/workflow/action/SapActionEditOperation.jsp">
			<input type="hidden" id="operate" name="operate" value="<%=operate%>">
			<input type="hidden" id="actionid" name="actionid" value="<%=actionid%>">
			<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="10">
					<col width="">
					<col width="10">
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<TABLE class=Shadow>
							<tr>
								<td valign="top">
									<table class=viewform cellspacing=1>
										<colgroup>
											<col width="15%">
											<col width="85%">
										<tbody>
											<tr class=spacing>
												<td class=Sep1 colSpan=2></td>
											</tr>
											<tr>
												<td class=line colspan=2>
												<td>
											</tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></td>
												<td class=field><!-- action名称 -->
													<input type="text" size="35" class="InputStyle" maxlength="20" temptitle="<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%>" id="actionname" name="actionname" value="<%=actionname%>" onChange="checkinput('actionname','actionnamespan')">
													<span id="actionnamespan">
														<%
															if (actionname.equals("")){
														%>
														<img src="/images/BacoError_wev8.gif" align=absmiddle>
														<%
															}
														%>
													</span>
												</td>
											</tr>
											<tr>
												<td class=line colspan=2></td>
											</tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(18104, user.getLanguage())%></td>
												<td class=field><!-- 流程名称，显示 -->
													<span id="workflowspan">
														<%=workFlowName%>
													</span>
													<input type="hidden" id="workflowid" name="workflowid" value="<%=workflowid%>">
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(26419, user.getLanguage())%></td><!-- 执行顺序 -->
												<td class=field>
													<input type="text" size="35" class="InputStyle" id="actionorder" temptitle="<%=SystemEnv.getHtmlLabelName(26419, user.getLanguage())%>" name="actionorder" maxlength="10" value="<%=actionorder%>" onChange="checkinput('actionorder','actionorderspan')"  onKeyPress="ItemCount_KeyPress()" onBlur="checknumber1(this);">
													<span id="actionorderspan">
														
													</span>
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<%if(nodeid > 0){%>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(15070, user.getLanguage())%></td>
												<td class=field><!-- 节点名称，显示 -->
													<%=nodename %>
													<input type=hidden id="nodeid" name="nodeid" value="<%=nodeid %>">
													<input type=hidden id="ispreoperator" name="ispreoperator" value="<%=ispreoperator %>">
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<%}else if(nodelinkid > 0){%>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(15611, user.getLanguage())%></td>
												<td class=field><!-- 出口名称，显示 -->
													<%=linkname %>
													<input type="hidden" id="nodelinkid" name="nodelinkid" value="<%=nodelinkid %>">
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<%}%>
											<tr>
												<td>Sap<%=SystemEnv.getHtmlLabelName(604, user.getLanguage())%></td>
												<td class=field><!-- Sap方法 -->
													<input type="text" class="InputStyle" size="35" temptitle="Sap<%=SystemEnv.getHtmlLabelName(604, user.getLanguage())%>" id="sapoperation" name="sapoperation" value="<%=sapoperation%>" onChange="checkinput('sapoperation','sapoperationspan')">
													<span id="sapoperationspan">
														<%
															if (sapoperation.equals("")){
														%>
														<img src="/images/BacoError_wev8.gif" align=absmiddle>
														<%
															}
														%>
													</span>
													<br>
													 <%=SystemEnv.getHtmlLabelName(27927, user.getLanguage())%><!-- 调用的SAP服务的Bapi名称 -->
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
											<td colspan="2">
												<table class="liststyle" style="LEFT: 0px; WIDTH: 100%;WORD-WRAP: break-word;" cellspacing="0" cellpadding="0">
													<colgroup>
														<col width="30%">
														<col width="70%">
													<tr class="Header">
													<td><%=SystemEnv.getHtmlLabelName(27902, user.getLanguage())%></td><!-- 传入参数设置 -->
													<td align="right">
														<BUTTON Class="BtnFlow" type="button" onclick="addRow(0)"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
														<BUTTON Class="BtnFlow" type="button" onclick="deleteRow(0)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
													</td>
													</tr>
													<tr>
													<td colspan=2>
														<table class="ListStyle" id="oTable0" >
															<COLGROUP>
															<TBODY>
																<tr class="header">
																<td width="3%"></td>
																<td width="12%" nowrap><%=SystemEnv.getHtmlLabelName(561,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td><!-- 参数类型 -->
																<td width="18%" nowrap><%=SystemEnv.getHtmlLabelName(23481,user.getLanguage())%></td><!-- 参数名称 -->
																<td width="67%" nowrap><%=SystemEnv.getHtmlLabelName(17632,user.getLanguage())%></td><!-- 参数设置 -->
																</tr>
														<%
															int indexnum0 = 0;
															String submitdtlid0 = "";
															for(int i=0; i<inparaList.size(); i++){
																ArrayList sapdetail = (ArrayList)inparaList.get(i);
																int paratype_t = Util.getIntValue((String)sapdetail.get(0));
																String paraname_t = Util.null2String((String)sapdetail.get(1));
																String paratext_t = Util.null2String((String)sapdetail.get(2));
														%>
															<tr>
																<td style="word-wrap:break-word;word-break:break-all;background:#E7E7E7">
																	<input type="checkbox" class="InputStyle" name="check_node0" value="<%=indexnum0%>">
																</td>
																<td style="word-wrap:break-word;word-break:break-all;background:#E7E7E7">
																	<select id="paratype0_<%=indexnum0%>" name="paratype0_<%=indexnum0%>">
																		<option value="0" <%if(paratype_t==0){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(27903,user.getLanguage())%></option><!-- 字符串 -->
																		<option value="1" <%if(paratype_t==1){out.print("selected");}%>>Sap<%=SystemEnv.getHtmlLabelName(27904,user.getLanguage())%></option><!-- 表 -->
																		<option value="2" <%if(paratype_t==2){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(27905,user.getLanguage())%></option><!-- 结构体 -->
																	</select>
																</td>
																<td style="word-wrap:break-word;word-break:break-all;background:#E7E7E7">
																	<input type="text" class="InputStyle" id="paraname0_<%=indexnum0%>" name="paraname0_<%=indexnum0%>" temptitle="<%=SystemEnv.getHtmlLabelName(23481,user.getLanguage())%>" style="width:90%" onchange="checkinput('paraname0_<%=indexnum0%>','paraname0_<%=indexnum0%>span')" value="<%=paraname_t%>">
																	<span id="paraname0_<%=indexnum0%>span">
																	<%if("".equals(paraname_t)){%>
																		<img src="/images/BacoError_wev8.gif" align="absmiddle">
																	<%}%>
																	</span>
																</td>
																<td style="word-wrap:break-word;word-break:break-all;background:#E7E7E7">
																	<textarea class="InputStyle" id="paratext0_<%=indexnum0%>" name="paratext0_<%=indexnum0%>" temptitle="<%=SystemEnv.getHtmlLabelName(17632,user.getLanguage())%>" rows="4" onchange="checkinput('paratext0_<%=indexnum0%>','paratext0_<%=indexnum0%>span')" style="width:90%" onfocus="dosetfocus('paratext0_<%=indexnum0%>')"><%=paratext_t%></textarea>
																	<span id="paratext0_<%=indexnum0%>span">
																	<%if("".equals(paratext_t)){%>
																		<img src="/images/BacoError_wev8.gif" align="absmiddle">
																	<%}%>
																	</span>
																</td>
															</tr>
														<%
																needcheck = needcheck + ",paraname0_"+indexnum0+",paratext0_"+indexnum0;
																submitdtlid0 = submitdtlid0 + "," + indexnum0;
																indexnum0++;
															}
															if(!"".equals(submitdtlid0)){
																submitdtlid0 = submitdtlid0.substring(1);
															}
														%>
														</table>
													<input type="hidden" id="submitdtlid0" name="submitdtlid0" value="<%=submitdtlid0%>">
													<input type="hidden" id="nodesnum0" name="nodesnum0" value="<%=indexnum0%>">
													<input type="hidden" id="indexnum0" name="indexnum0" value="<%=indexnum0%>">
													</td>
													</tr>
												</table>
											</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
												<td colspan="2">
													<%=SystemEnv.getHtmlLabelName(27928,user.getLanguage())%>：<!-- 参数设置方法 -->
													<br>
													<%=SystemEnv.getHtmlLabelName(27903,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(27929,user.getLanguage())%><!-- 字符串: 参数名称即是该参数在SAP执行对象中的名称，直接在参数设置中填写该参数所需填入的流程表单字段的标签即可。-->
													<br>
													Sap<%=SystemEnv.getHtmlLabelName(27904,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(27930,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27931,user.getLanguage())%>：$name1$:$field001$,$name2$:$field002$<!-- 表:  参数名称即是该表在SAP执行对象中的表名称，参数设置中应设置表的列明与流程表单字段的对应关系，多个参数用半角逗号隔开。一般用于传递明细字段的值。形如 -->
													<br>
													<%=SystemEnv.getHtmlLabelName(27905,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(27932,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27931,user.getLanguage())%>：$name1$:$field001$,$name2$:$field002$<!-- 结构体 :参数名称即是该结构体在SAP执行对象中的名称，参数设置中应设置结构体中具体参数的标签名与流程表单字段的对应关系，多个参数用半角逗号隔开。一般不用于传递明细字段的值。形如-->
													<br>
													<font color="#ff0000"><b><%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%></b>：<%=SystemEnv.getHtmlLabelName(27933,user.getLanguage())%></font><!--  这里Sap表和结构体只支持一层，即只能包含简单结构（字符串之类），不能进一步包含Sap表或结构体。  -->
													<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#ff0000"><%=SystemEnv.getHtmlLabelName(27926,user.getLanguage())%></font><!-- 若要引用流程表单字段，请点击以下字段标签列表，会自动在鼠标光标位置插入字段标签。标签禁止随意修改！ -->
													<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#ff0000"><%=SystemEnv.getHtmlLabelName(27934,user.getLanguage())%></font><!-- 参数设置中的Sap参数名必须用"$"符引用。 -->
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
											<td colspan="2">
												<table class="liststyle" style="LEFT: 0px; WIDTH: 100%;WORD-WRAP: break-word;" cellspacing="0" cellpadding="0">
													<colgroup>
														<col width="30%">
														<col width="70%">
													<tr class="Header">
													<td><%=SystemEnv.getHtmlLabelName(27906,user.getLanguage())%></td><!-- 返回参数设置 -->
													<td align="right">
														<BUTTON Class="BtnFlow" type="button" onclick="addRow(1)"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON><!-- 添加 -->
														<BUTTON Class="BtnFlow" type="button" onclick="deleteRow(1)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON><!-- 删除 -->
													</td>
													</tr>
													<tr>
													<td colspan=2>
														<table class="ListStyle" id="oTable1" >
															<COLGROUP>
															<TBODY>
																<tr class="header">
																<td width="3%"></td>
																<td width="12%" nowrap><%=SystemEnv.getHtmlLabelName(561,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td><!-- 参数类型 -->
																<td width="18%" nowrap><%=SystemEnv.getHtmlLabelName(23481,user.getLanguage())%></td><!-- 参数名称 -->
																<td width="67%" nowrap><%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())%>SQL</td><!-- 执行 -->
																</tr>
														<%
															int indexnum1 = 0;
															String submitdtlid1 = "";
															for(int i=0; i<outparaList.size(); i++){
																ArrayList sapdetail = (ArrayList)outparaList.get(i);
																int paratype_t = Util.getIntValue((String)sapdetail.get(0));
																String paraname_t = Util.null2String((String)sapdetail.get(1));
																String paratext_t = Util.null2String((String)sapdetail.get(2));
														%>
															<tr>
																<td style="word-wrap:break-word;word-break:break-all;background:#E7E7E7">
																	<input type="checkbox" class="InputStyle" name="check_node1" value="<%=indexnum1%>">
																</td>
																<td style="word-wrap:break-word;word-break:break-all;background:#E7E7E7">
																	<select id="paratype1_<%=indexnum1%>" name="paratype1_<%=indexnum1%>">
																		<option value="0" <%if(paratype_t==0){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(27903,user.getLanguage())%></option>
																		<option value="1" <%if(paratype_t==1){out.print("selected");}%>>Sap<%=SystemEnv.getHtmlLabelName(27904,user.getLanguage())%></option>
																		<option value="2" <%if(paratype_t==2){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(27905,user.getLanguage())%></option>
																	</select>
																</td>
																<td style="word-wrap:break-word;word-break:break-all;background:#E7E7E7">
																	<input type="text" class="InputStyle" id="paraname1_<%=indexnum1%>" name="paraname1_<%=indexnum1%>" temptitle="<%=SystemEnv.getHtmlLabelName(23481,user.getLanguage())%>" style="width:90%" onchange="checkinput('paraname1_<%=indexnum1%>','paraname1_<%=indexnum1%>span')" value="<%=paraname_t%>">
																	<span id="paraname1_<%=indexnum1%>span">
																	<%if("".equals(paraname_t)){%>
																		<img src="/images/BacoError_wev8.gif" align="absmiddle">
																	<%}%>
																	</span>
																</td>
																<td style="word-wrap:break-word;word-break:break-all;background:#E7E7E7">
																	<textarea class="InputStyle" id="paratext1_<%=indexnum1%>" name="paratext1_<%=indexnum1%>" temptitle="<%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())%>SQL" rows="4" onchange="checkinput('paratext1_<%=indexnum1%>','paratext1_<%=indexnum1%>span')" style="width:90%" onfocus="dosetfocus('paratext1_<%=indexnum1%>')"><%=paratext_t%></textarea>
																	<span id="paratext1_<%=indexnum1%>span">
																	<%if("".equals(paratext_t)){%>
																		<img src="/images/BacoError_wev8.gif" align="absmiddle">
																	<%}%>
																	</span>
																</td>
															</tr>
														<%
																needcheck = needcheck + ",paraname1_"+indexnum1+",paratext1_"+indexnum1;
																submitdtlid1 = submitdtlid1 + "," + indexnum1;
																indexnum1++;
															}
															if(!"".equals(submitdtlid1)){
																submitdtlid1 = submitdtlid1.substring(1);
															}
														%>
														</table>
													<input type="hidden" id="submitdtlid1" name="submitdtlid1" value="<%=submitdtlid1%>">
													<input type="hidden" id="nodesnum1" name="nodesnum1" value="<%=indexnum1%>">
													<input type="hidden" id="indexnum1" name="indexnum1" value="<%=indexnum1%>">
													</td>
													</tr>
												</table>
											</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
												<td colspan="2">
													<%=SystemEnv.getHtmlLabelName(27928,user.getLanguage())%>：<!-- 参数设置方法 -->
													<br>
													<%=SystemEnv.getHtmlLabelName(27935,user.getLanguage())%><!-- 参数类型、参数名称含义同传入参数。 -->
													SQL<%=SystemEnv.getHtmlLabelName(27924,user.getLanguage())%>：<!-- 格式如下 -->
													<br>
													update formtable_main_100 set field001='$name1$', field002=$name2$ where requestid=$requestid$
													<br>
													<font color="#ff0000"><b><%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%></b>：<%=SystemEnv.getHtmlLabelName(27933,user.getLanguage())%></font><!-- 注意:这里Sap表和结构体只支持一层，即只能包含简单结构（字符串之类），不能进一步包含Sap表或结构体。 -->
													<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#ff0000"><%=SystemEnv.getHtmlLabelName(27925,user.getLanguage())%></font><!-- 这里不能引用表单字段 -->
													<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#ff0000"><%=SystemEnv.getHtmlLabelName(27937,user.getLanguage())%></font><!-- SQL中的Sap参数名必须用"$"符引用。(TODO) -->
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
												<td colspan=2>
													<table width="100%" class="liststyle">
														<colgroup>
															<col width="20%">
															<col width="20%">
															<col width="20%">
															<col width="20%">
															<col width="20%">
														<tbody>
															<tr class="Header"><td colspan="5"><%=SystemEnv.getHtmlLabelName(26421, user.getLanguage())%></td></tr>
															<tr class="Line"><th colspan="5"></th></tr>
															<tr>
																<td><a href="#" onclick="insertIntoTextarea('$requestname$')"><%=SystemEnv.getHtmlLabelName(26876, user.getLanguage())%></a></td><!-- 流程标题 -->
																<td><a href="#" onclick="insertIntoTextarea('$requestid$')"><%=SystemEnv.getHtmlLabelName(18376, user.getLanguage())%></a></td><!-- 流程请求ID -->
																<td><a href="#" onclick="insertIntoTextarea('$creater$')"><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></a></td><!-- 创建人 -->
																<td><a href="#" onclick="insertIntoTextarea('$createdate$')"><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></a></td><!-- 创建日期 -->
																<td><a href="#" onclick="insertIntoTextarea('$createtime$')"><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></a></td><!-- 创建时间 -->
															</tr>
															<tr>
																<td class="line" colspan="5"></td>
															</tr>
															<tr>
																<td><a href="#" onclick="insertIntoTextarea('$workflowname$')"><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></a></td><!--  流程类型  -->
																<td><a href="#" onclick="insertIntoTextarea('$currentuse$')"><%=SystemEnv.getHtmlLabelName(20558,user.getLanguage())%></a></td><!-- 当前操作者 -->
																<td><a href="#" onclick="insertIntoTextarea('$currentnode$')"><%=SystemEnv.getHtmlLabelName(18564,user.getLanguage())%></a></td><!-- 当前节点 -->
																<td><!--<a href="#" onclick="insertIntoTextarea('$retstr$')"><%=SystemEnv.getHtmlLabelName(27907,user.getLanguage())%></a>--></td><!-- 返回值 -->
																<td><!--<a href="#" onclick="insertIntoTextarea('\t')"><%=SystemEnv.getHtmlLabelName(27908,user.getLanguage())%></a>--></td><!-- 增加缩进 -->
															</tr>
															<tr>
																<td class="line" colspan="5"></td>
															</tr>
														<%
														String sql = "";
														if(isbill == 0){
															sql = "select fd.id, fd.fieldname, fl.fieldlable as fieldlabel from workflow_formdict fd left join workflow_formfield ff on ff.fieldid=fd.id left join workflow_fieldlable fl on fl.fieldid=fd.id and fl.langurageid="+user.getLanguage()+" and fl.formid="+formid+" where ff.formid="+formid+" order by fd.id";
														}else{
															sql = "select bf.id, bf.fieldname, hl.labelname as fieldlabel from workflow_billfield bf left join htmllabelinfo hl on hl.indexid=bf.fieldlabel and hl.languageid="+user.getLanguage()+" where (viewtype=0 or viewtype is null) and billid="+formid+" order by bf.dsporder";
														}
														rs.execute(sql);
														cx = 0;
														while(rs.next()){
															int fieldid_t = Util.getIntValue(rs.getString("id"), 0);
															String fieldlabel_t = Util.null2String(rs.getString("fieldlabel"));
															//从那个Hashtable里面去取xml的标签名
															String xmlmark_t = "";
															if(cx%5 == 0){
														%>
															<tr>
														<%}%>
															<td><a href="#" onclick="insertIntoTextarea('$field<%=fieldid_t%>$')"><%=fieldlabel_t%></a></td>
														<%
															cx++;
															if(cx%5 == 0){
														%>
															</tr>
															<tr>
																<td class="line" colspan="5"></td>
															</tr>
														<%
															}
														}
														while(cx%5 != 0){
														%>
															<td></td>
														<%
															cx++;
															if(cx%5 == 0){
														%>
															</tr>
															<tr>
																<td class="line" colspan="5"></td>
															</tr>
														<%
															}
														}
														%>
														</tbody>
													</table>

												</td>
											</tr>
											<%
											//明细表循环
											if(isbill == 0){
												sql = "select distinct groupid from workflow_formfield where formid="+formid+" and isdetail='1' order by groupid";
											}else{
												sql = "select tablename as groupid, title from Workflow_billdetailtable where billid="+formid+" order by orderid";
											}
											RecordSet.execute(sql);
											int groupCount = 0;
											while(RecordSet.next()){//明细表循环开始
												groupCount++;
												String groupid_tmp = "";
												if(isbill == 0){
													groupid_tmp = ""+Util.getIntValue(RecordSet.getString("groupid"), 0);
												}else{
													groupid_tmp = Util.null2String(RecordSet.getString("groupid"));
												}
											%>
											<tr>
												<td colspan=2>
													<table width="100%" class="liststyle">
														<colgroup>
															<col width="20%">
															<col width="20%">
															<col width="20%">
															<col width="20%">
															<col width="20%">
														<tbody>
															<tr class="Header">
																<td colspan="5"><%=SystemEnv.getHtmlLabelName(19325, user.getLanguage())%><%=groupCount%><%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%></td><!-- 明细表  字段-->
															</tr>
															<tr class="Line"><th colspan="5"></th></tr>
														<%
														if(isbill == 0){
															sql = "select fd.id, fd.fieldname, fl.fieldlable as fieldlabel from workflow_formdictdetail fd left join workflow_formfield ff on ff.fieldid=fd.id and ff.isdetail='1' and ff.groupid="+groupid_tmp+" left join workflow_fieldlable fl on fl.fieldid=fd.id and fl.langurageid="+user.getLanguage()+" and fl.formid="+formid+" where ff.formid="+formid+" order by fd.id";
														}else{
															sql = "select bf.id, bf.fieldname, hl.labelname as fieldlabel from workflow_billfield bf left join htmllabelinfo hl on hl.indexid=bf.fieldlabel and hl.languageid="+user.getLanguage()+" where bf.detailtable='"+groupid_tmp+"' and bf.viewtype=1 and bf.billid="+formid+" order by bf.dsporder";
														}
														rs.execute(sql);
														cx = 0;
														while(rs.next()){
															int fieldid_t = Util.getIntValue(rs.getString("id"), 0);
															String fieldlabel_t = Util.null2String(rs.getString("fieldlabel"));
															//从那个Hashtable里面去取xml的标签名
															String xmlmark_t = "";
															if(cx%5 == 0){
														%>
															<tr>
														<%}%>
																<td><a href="#" onclick="insertIntoTextarea('$field<%=fieldid_t%>$')"><%=fieldlabel_t%></a></td>
														<%
															cx++;
															if(cx%5 == 0){
														%>
															</tr>
															<tr>
																<td class="line" colspan="5"></td>
															</tr>
														<%
															}
														}
														while(cx%5 != 0){
														%>
															<td></td>
														<%
															cx++;
															if(cx%5 == 0){
														%>
															</tr>
															<tr>
																<td class="line" colspan="5"></td>
															</tr>
														<%
															}
														}%>
														</tbody>
													</table>

												</td>
											</tr>

											<%}//明细表循环结束%>
										</tbody>
									</table>
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
		</form>
	</body>
</html>
<script language="javascript">
var needcheck = "<%=needcheck%>";
var textfocus = null;
function dosetfocus(ename){
	textfocus = document.getElementById(ename);
}
function submitData(){
	enableAllmenu();
	document.getElementById("operate").value = "save";
	if(check_form(frmmain,needcheck)){
		document.frmmain.submit();
	}
	displayAllmenu();
}
function deleteData(){
	if(isdel()){
		document.frmmain.operate.value = "delete";
		document.frmmain.submit();
		enableAllmenu();
	}
}
function insertIntoTextarea(textvalue){
	var obj = textfocus;
	if(obj){
		obj.focus();
		if(document.selection){
			document.selection.createRange().text = textvalue;
		}else{
			obj.value = obj.value.substr(0, obj.selectionStart) + textvalue + obj.value.substr(obj.selectionEnd);
		}
		checkinput(obj.name,obj.name+"span");
	}
}
function addRow(obj){
	var oTable = document.getElementById("oTable"+obj);
	var initDetailfields = "";
	var curindex=parseInt(document.getElementById("nodesnum"+obj).value);
	var rowindex=parseInt(document.getElementById("indexnum"+obj).value);
	if(document.getElementById("submitdtlid"+obj).value==''){
		document.getElementById("submitdtlid"+obj).value=rowindex;
	}else{
		document.getElementById("submitdtlid"+obj).value+=","+rowindex;
	}
	oRow = oTable.insertRow(curindex+1);
	oCell = oRow.insertCell();
	oCell.style.background= "#E7E7E7";
	oCell.style.wordWrap = "break-word";
	oCell.style.wordBreak = "break-all";

	//checkbox
	var oDiv = document.createElement("div");
	var sHtml = "<input type='checkbox' class='InputStyle' name='check_node"+obj+"' value='"+rowindex+"'>";
	oDiv.innerHTML = sHtml;
	oCell.appendChild(oDiv);

	//参数类型
	oDiv = document.createElement("div");
	sHtml = "<select id='paratype"+obj+"_"+rowindex+"' name='paratype"+obj+"_"+rowindex+"'><option value='0'><%=SystemEnv.getHtmlLabelName(27903,user.getLanguage())%></option><option value='1'>Sap<%=SystemEnv.getHtmlLabelName(27904,user.getLanguage())%></option><option value='2'><%=SystemEnv.getHtmlLabelName(27905,user.getLanguage())%></option></select>";
	oCell = oRow.insertCell();
	oCell.style.background= "#E7E7E7";
	oCell.style.wordWrap= "break-word";
	oCell.style.wordBreak= "break-all";
	oDiv.innerHTML = sHtml;
	oCell.appendChild(oDiv);

	//参数名
	oDiv = document.createElement("div");
	sHtml = "<input type='text' class='InputStyle' id='paraname"+obj+"_"+rowindex+"' name='paraname"+obj+"_"+rowindex+"' temptitle='<%=SystemEnv.getHtmlLabelName(23481,user.getLanguage())%>' style='width:90%' onchange='checkinput(\"paraname"+obj+"_"+rowindex+"\",\"paraname"+obj+"_"+rowindex+"span\")' value=''><span id='paraname"+obj+"_"+rowindex+"span'><img src=\"/images/BacoError_wev8.gif\" align=absmiddle></sapn>";
	oCell = oRow.insertCell();
	oCell.style.background= "#E7E7E7";
	oCell.style.wordWrap= "break-word";
	oCell.style.wordBreak= "break-all";
	oDiv.innerHTML = sHtml;
	oCell.appendChild(oDiv);

	//参数设置
	var pttitle = "";
	if(obj == 0){
		pttitle = "temptitle='<%=SystemEnv.getHtmlLabelName(17632,user.getLanguage())%>'";
	}else if(obj == 1){
		pttitle = "temptitle='<%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())%>SQL'";
	}
	oDiv = document.createElement("div");
	sHtml = "<textarea class='InputStyle' id='paratext"+obj+"_"+rowindex+"' name='paratext"+obj+"_"+rowindex+"' "+pttitle+" rows='4' onchange='checkinput(\"paratext"+obj+"_"+rowindex+"\",\"paratext"+obj+"_"+rowindex+"span\")' style='width:90%' onfocus=\"dosetfocus('paratext"+obj+"_"+rowindex+"')\"></textarea><span id='paratext"+obj+"_"+rowindex+"span'><img src=\"/images/BacoError_wev8.gif\" align=absmiddle></sapn>";
	oCell = oRow.insertCell();
	oCell.style.background= "#E7E7E7";
	oCell.style.wordWrap= "break-word";
	oCell.style.wordBreak= "break-all";
	oDiv.innerHTML = sHtml;
	oCell.appendChild(oDiv);

	var newneedcheck = needcheck + ",paraname"+obj+"_"+rowindex+",paratext"+obj+"_"+rowindex+"";
	needcheck = newneedcheck;

	rowindex = rowindex*1 +1;
	curindex = curindex*1 +1;

	//alert("rowindex|curindex"+rowindex+"|"+curindex);
	document.getElementById("nodesnum"+obj).value = curindex ;
	document.getElementById("indexnum"+obj).value = rowindex;

}
function deleteRow(obj){
	var flag = false;
	var ids = document.getElementsByName("check_node"+obj);
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked == true) {
			flag = true;
			break;
		}
	}
	if(flag) {
		if(isdel()){
			var oTable=document.getElementById("oTable"+obj);
			curindex = parseInt(document.getElementById("nodesnum"+obj).value);
			len = document.forms[0].elements.length;
			var i=0;
			var rowsum1 = 0;
			for(i=len-1; i>=0; i--) {
				if (document.forms[0].elements[i].name=="check_node"+obj){
					rowsum1 += 1;
				}
			}
			for(i=len-1; i>=0; i--) {
				if (document.forms[0].elements[i].name == "check_node"+obj){
					if(document.forms[0].elements[i].checked == true) {
						//从提交序号串中删除被删除的行
						var delid = document.forms[0].elements[i].value;
						var submitdtlidArray = document.getElementById("submitdtlid"+obj).value.split(',');
						document.getElementById("submitdtlid"+obj).value = "";
						var k;
						for(k=0; k<submitdtlidArray.length; k++){
							if(submitdtlidArray[k]!=delid){
								if(document.getElementById("submitdtlid"+obj).value==""){
									document.getElementById("submitdtlid"+obj).value = submitdtlidArray[k];
								}else{
									document.getElementById("submitdtlid"+obj).value += ","+submitdtlidArray[k];
								}
							}
						}
						//删除行
						oTable.deleteRow(rowsum1);
						curindex--;
					}
					rowsum1 -= 1;
				}
			}
			var rows = oTable.rows.length;
			document.getElementById("nodesnum"+obj).value = curindex;
		}
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");//请选择需要删除的数据
		return;
	}
}
</script>
