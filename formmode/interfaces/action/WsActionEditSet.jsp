
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wsActionManager" class="weaver.formmode.interfaces.action.WSActionManager" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String operate = Util.null2String(request.getParameter("operate"));
	int actionid = Util.getIntValue(request.getParameter("actionid"),0);
	if(actionid <= 0){
		operate = "addws";
	}
	
	String modename = "";
	int isbill = 1;
	String formid = "";
	int modeid = Util.getIntValue(Util.null2String(request.getParameter("modeid")),0);
	int expandid = Util.getIntValue(Util.null2String(request.getParameter("expandid")),0);
	String sql = "select modename,formid from modeinfo where id = " + modeid;
	rs.executeSql(sql);
	while(rs.next()){
		formid = Util.null2String(rs.getString("formid"));
		modename = Util.null2String(rs.getString("modename"));
	}

	String actionname = "";
	int actionorder = 0;
	String wsurl = "";//web service地址
	String wsoperation = "";//调用的web service的方法
	String xmltext = "";
	String retstr = "";
	int rettype = 0;
	String inpara = "";
	if("editws".equals(operate)){
		//如果是编辑，根据actionid去取基本配置信息
		wsActionManager.setActionid(actionid);
		ArrayList wsActionList = wsActionManager.doSelectWsAction(modeid, expandid);
		if(wsActionList.size() > 0){
			ArrayList wsAction = (ArrayList)wsActionList.get(0);
			actionid = Util.getIntValue((String)wsAction.get(0));
			actionname = Util.null2String((String)wsAction.get(1));
			actionorder = Util.getIntValue((String)wsAction.get(2), 0);
			wsurl = Util.null2String((String)wsAction.get(3));
			wsoperation = Util.null2String((String)wsAction.get(4));
			xmltext = Util.null2String((String)wsAction.get(5));
			rettype = Util.getIntValue((String)wsAction.get(6), 0);
			retstr = Util.null2String((String)wsAction.get(7));
			inpara = Util.null2String((String)wsAction.get(8));
		}
	}
	String needcheck = "actionname,actionorder,wsurl,wsoperation,xmltext";
	
	int cx = 0;

%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(23662, user.getLanguage())+"(WebService)"; //配置接口动作(数据库DML)23662
		String needfav = "1";
		String needhelp = "";
	%>
	<body>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:submitData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + ",javascript:deleteData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form name="frmmain" method="post" action="/formmode/interfaces/action/WsActionEditOperation.jsp">
			<input type="hidden" id="operate" name="operate" value="<%=operate%>">
			<input type="hidden" id="actionid" name="actionid" value="<%=actionid%>">
			<input type="hidden" id="modeid" name="modeid" value="<%=modeid %>">
			<input type="hidden" id="expandid" name="expandid" value="<%=expandid%>">
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
												<td><%=SystemEnv.getHtmlLabelName(28485, user.getLanguage())%></td>
												<td class=field><!-- 流程名称，显示 -->
													<span id="workflowspan">
														<%=modename%>
													</span>
													<input type="hidden" id="modeid" name="modeid" value="<%=modeid%>">
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

											<tr>
												<td>WebService<%=SystemEnv.getHtmlLabelName(110, user.getLanguage())%></td>
												<td class=field><!-- WebService地址 -->
													<input type="text" class="InputStyle" size="80" temptitle="WebService<%=SystemEnv.getHtmlLabelName(110, user.getLanguage())%>" id="wsurl" name="wsurl" value="<%=wsurl%>" onChange="checkinput('wsurl','wsurlspan')">
													<span id="wsurlspan">
														<%
															if (wsurl.equals("")){
														%>
														<img src="/images/BacoError_wev8.gif" align=absmiddle>
														<%
															}
														%>
													</span><br><%=SystemEnv.getHtmlLabelName(27919, user.getLanguage())%>
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
												<td>WebService<%=SystemEnv.getHtmlLabelName(604, user.getLanguage())%></td>
												<td class=field><!-- WebService方法名 -->
													<input type="text" class="InputStyle" size="35" temptitle="WebService<%=SystemEnv.getHtmlLabelName(604, user.getLanguage())%>" id="wsoperation" name="wsoperation" value="<%=wsoperation%>" onChange="checkinput('wsoperation','wsoperationspan')">
													<span id="wsoperationspan">
														<%
															if (wsoperation.equals("")){
														%>
														<img src="/images/BacoError_wev8.gif" align=absmiddle>
														<%
															}
														%>
													</span><br><%=SystemEnv.getHtmlLabelName(27920, user.getLanguage())%>
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(27909, user.getLanguage())%></td>
												<td class=field><!-- 传入参数名称 -->
													<input type="text" size="35" class="InputStyle" maxlength="20" temptitle="<%=SystemEnv.getHtmlLabelName(27909, user.getLanguage())%>" id="inpara" name="inpara" value="<%=inpara%>" >
													<br><%=SystemEnv.getHtmlLabelName(27921, user.getLanguage())%>
												</td>
											</tr>
											<tr>
												<td class=line colspan=2></td>
											</tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(27907,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
												<td class=field><!-- 返回值类型 -->
													<select id="rettype" name="rettype" onchange="dochangetitle(this)">
														<option value='0' <%if(rettype==0){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(27903,user.getLanguage())%></option>
														<option value='1' <%if(rettype==1){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())%>SQL</option>
													</select><br>
													<div id="rtdiv0" style="display:<%if(rettype!=0){out.print("none");}%>"><%=SystemEnv.getHtmlLabelName(27922, user.getLanguage())%></div>
													<div id="rtdiv1" style="display:<%if(rettype!=1){out.print("none");}%>"><%=SystemEnv.getHtmlLabelName(27923, user.getLanguage())%></div>
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(27907,user.getLanguage())%></td>
												<td class=field><!-- 返回值 -->
													<textarea class="InputStyle" temptitle="<%=SystemEnv.getHtmlLabelName(27907,user.getLanguage())%>" id="retstr" name="retstr" rows="4" style="width:90%" onfocus="dosetfocus('retstr')"><%=retstr%></textarea>
													<br>
													<div id="rtdiv2" style="display:<%if(rettype!=1){out.print("none");}%>">SQL<%=SystemEnv.getHtmlLabelName(27924,user.getLanguage())%>：
													<br>
													update formtable_main_100 set field001='$retstr$' where requestid=$requestid$
													<br>
													<font color="#ff0000"><b><%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%></b>：<%=SystemEnv.getHtmlLabelName(27925,user.getLanguage())%></font>
													</div>
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
												<td>XML<%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></td>
												<td class=field><!-- XML模板 -->
													<textarea class="InputStyle" temptitle="XML<%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%>" id="xmltext" name="xmltext" rows="14" style="width:90%" onfocus="dosetfocus('xmltext')" onChange="checkinput('xmltext','xmltextspan')"><%=xmltext%></textarea>
													<span id="xmltextspan">
														<%
															if (xmltext.equals("")){
														%>
														<img src="/images/BacoError_wev8.gif" align=absmiddle>
														<%
															}
														%>
													</span>
													<br>
													<a href="/workflow/action/wsxmlmode.xml" target="_blank">XML<%=SystemEnv.getHtmlLabelName(19971,user.getLanguage())%></a>
													<br>
													<font color="#ff0000"><b><%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%></b>：<%=SystemEnv.getHtmlLabelName(27926,user.getLanguage())%></font>
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
																<td><a href="#" onclick="insertIntoTextarea('$id$')"><%=SystemEnv.getHtmlLabelName(563, user.getLanguage())%>ID</a></td>
																<td><a href="#" onclick="insertIntoTextarea('$modedatacreater$')"><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></a></td>
																<td><a href="#" onclick="insertIntoTextarea('$modedatacreatedate$')"><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></a></td>
																<td><a href="#" onclick="insertIntoTextarea('$modedatacreatetime$')"><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></a></td>
																<td></td>
															</tr>
															<tr>
																<td class="line" colspan="5"></td>
															</tr>
														<%
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
																<td colspan="2"><%=SystemEnv.getHtmlLabelName(19325, user.getLanguage())%><%=groupCount%><%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%></td>
																<td colspan="3" align="left"><a href="#" onclick="insertIntoTextarea('$grouphead<%=groupCount%>$')"><%=SystemEnv.getHtmlLabelName(19572,user.getLanguage())%></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onclick="insertIntoTextarea('$grouptail<%=groupCount%>$')"><%=SystemEnv.getHtmlLabelName(19573,user.getLanguage())%></a></td>
															</tr>
															<tr class="Line"><th colspan="5"></th></tr>
														<%
														if(isbill == 0){
															sql = "select fd.id, fd.fieldname, fl.fieldlable as fieldlabel from workflow_formdictdetail fd left join workflow_formfield ff on ff.fieldid=fd.id and ff.isdetail='1' and ff.groupid="+groupid_tmp+" left join workflow_fieldlabl fl on fl.fieldid=fd.id and fl.langurageid="+user.getLanguage()+" and fl.formid="+formid+" where ff.formid="+formid+" order by fd.id";
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
var textfocus = document.getElementById("xmltext");
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
		document.getElementById("operate").value = "delete";
        document.frmmain.submit();
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
		checkinput("xmltext","xmltextspan");
	}
}
function dochangetitle(obj){
	var rettype_t = obj.value;
	document.getElementById("rtdiv0").style.display = "none";
	document.getElementById("rtdiv1").style.display = "none";
	document.getElementById("rtdiv2").style.display = "none";
	document.getElementById("rtdiv"+rettype_t).style.display = "";
	if(rettype_t == "1"){
		document.getElementById("rtdiv2").style.display = "";
	}
}
</script>
