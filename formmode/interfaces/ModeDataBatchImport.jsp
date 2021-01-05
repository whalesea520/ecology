
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.file.*" %>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="FieldInfo" class="weaver.formmode.data.FieldInfo" scope="page"/>
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<HTML>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(26601, user
			.getLanguage());//批量导入
	String needfav = "";
	String needhelp = "";

	int modeid = Util.getIntValue(request.getParameter("modeid"), 0);
	int pageexpandid = Util.getIntValue(request
			.getParameter("pageexpandid"), 0);
	int sourcetype = Util.getIntValue(request
			.getParameter("sourcetype"), 0);
	String flag = Util.null2String(request.getParameter("flag"));
	String msg = Util.null2String((String) session.getAttribute(flag));

	String subCompanyIdsql = "select subCompanyId from modeinfo where id="
			+ modeid;
	RecordSet recordSet = new RecordSet();
	recordSet.executeSql(subCompanyIdsql);
	int subCompanyId = -1;
	if (recordSet.next()) {
		subCompanyId = recordSet.getInt("subCompanyId");
	}
	String userRightStr = "ModeSetting:All";
	Map rightMap = getCheckRightSubCompanyParam(userRightStr, user,
			fmdetachable, subCompanyId, "", request, response, session);
	int operatelevel = Util.getIntValue(Util.null2String(rightMap
			.get("operatelevel")), -1);
	subCompanyId = Util.getIntValue(Util.null2String(rightMap
			.get("subCompanyId")), -1);

	int type = 4;//批量导入权限
	boolean isRight = false;
	boolean isALLRight = false;
	if (type == 4) {//监控权限判断
		ModeRightInfo.setModeId(modeid);
		ModeRightInfo.setType(type);
		ModeRightInfo.setUser(user);
		isRight = ModeRightInfo.checkUserRight(type);
		if (!isRight) {
			isALLRight = HrmUserVarify.checkUserRight(
					"ModeSetting:All", user);
			if (!isALLRight) {
				response.sendRedirect("/notice/noright.jsp");
				return;
			}
		}
	}

	List<Integer> importTypes = ModeRightInfo.checkUserImportType();
	if (importTypes.size() == 0) {
		if (isALLRight) {
			importTypes.add(0);
		}
	}

	String otherTypeSelect = "";
	//根据后台设置的导入类型 这里做一个限制 
	if (importTypes.size() == 0 || importTypes.contains(1)
			|| importTypes.contains(0)) {
		otherTypeSelect += "<option value='1'>"
				+ SystemEnv.getHtmlLabelName(31259, user.getLanguage())
				+ "</option>";
	}
	if (importTypes.size() == 0 || importTypes.contains(2)
			|| importTypes.contains(0)) {
		otherTypeSelect += "<option value='2'>"
				+ SystemEnv.getHtmlLabelName(31260, user.getLanguage())
				+ "</option>";
	}
	if (importTypes.size() == 0 || importTypes.contains(3)
			|| importTypes.contains(0)) {
		otherTypeSelect += "<option value='3'>"
				+ SystemEnv.getHtmlLabelName(17744, user.getLanguage())
				+ "</option>";
	}
%>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style>
select{
	width:160px;
}
.boot-btn {
	display: inline-block;
	padding: 6px 12px;
	margin-bottom: 0;
	font-size: 14px;
	font-weight: normal;
	line-height: 1.42857143;
	text-align: center;
	white-space: nowrap;
	vertical-align: middle;
	-ms-touch-action: manipulation;
	touch-action: manipulation;
	cursor: pointer;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;
	background-image: none;
	border: 1px solid transparent;
	border-radius: 4px;
}

.btn-primary {
	color: #fff;
	background-color: #337ab7;
	border-color: #2e6da4;
}

.btn-primary:hover {
	color: #fff;
	background-color: #286090;
	border-color: #204d74;
}

.disabled {
	color: #999 !important;
	background-color: #e6e6e6 !important;
	border-color: #adadad !important;
}
</style>
	</HEAD>
<body>
<%
	String sql = "";
	String modename = "";
	String interfacepath = "";
	String importorder = "";
	String isuse = "";
	String validateid = "";
	int formid = 0;
	boolean tempflag = false;
	String templateTitle = "";
	int isHaveTemplate = 0;
	if (modeid > 0) {
		sql = "select * from modeinfo where Id=" + modeid;
		rs.executeSql(sql);
		if (rs.next()) {
			formid = rs.getInt("formid");
			modename = Util.null2String(rs.getString("modename"));
			
			String templateSql = "select 1 from mode_import_template a where modeid="+modeid+" and formid="+formid+" and (exists(select 1 from workflow_billfield b where b.billid="+formid+" and b.id=a.fieldid) or  a.fieldid in(-1000,-1001,-1002)) ";
			rs.execute(templateSql);
			if(rs.getCounts()>0){
				isHaveTemplate = 1;
			}

			ArrayList editfields = new ArrayList();//可编辑字段

			sql = "select * from workflow_billfield where billid="
					+ formid + " order by viewtype asc,detailtable asc";
			rs.executeSql(sql);
			while (rs.next()) {
				editfields.add("field" + rs.getString("fieldid"));
			}
			ExcelSheet es = null;
			ExcelFile.init();
			ExcelFile.setFilename(modename);
			ExcelStyle ess = ExcelFile.newExcelStyle("Header");
			ess.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor);
			ess.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
			ess.setFontbold(ExcelStyle.WeaverHeaderFontbold);
			ess.setAlign(ExcelStyle.WeaverHeaderAlign);

			ExcelStyle ess2 = ExcelFile.newExcelStyle("MUST");
			ess2.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor);
			ess2.setFontcolor(ExcelStyle.RED_Color);
			ess2.setFontbold(ExcelStyle.WeaverHeaderFontbold);
			ess2.setAlign(ExcelStyle.WeaverHeaderAlign);

			FieldInfo.setUser(user);
			if(isHaveTemplate==1){
				FieldInfo.GetManTableFieldToExcelTemplate(formid, 1, user.getLanguage(),modeid);//根据模块导入模板获得主字段
			}else{
				FieldInfo.GetManTableFieldToExcel(formid, 1, user.getLanguage());//获得主字段
			}
			ArrayList ManTableFieldlabel = FieldInfo.getManTableFieldlabel();
			ArrayList ManTableFieldHtmltypes = FieldInfo
					.getManTableFieldHtmltypes();
			ArrayList ManTableFieldIds = FieldInfo
					.getManTableFieldIds();
			es = new ExcelSheet(); // 初始化一个EXCEL的sheet对象
			ExcelRow er = es.newExcelRow();
			es.addColumnwidth(6000);
			er.addStringValue("ID", "Header");

			String validateids = "";
			sql = "select b.fieldid from mode_excelField a,mode_excelFieldDetail b where a.formid ="
					+ formid
					+ " and a.modeid="
					+ modeid
					+ " and b.mainid=a.id";
			rs.executeSql(sql);
			while (rs.next()) {
				validateids += rs.getString("fieldid") + ",";
			}
			
			
			for (int i = 0; i < ManTableFieldlabel.size(); i++) {
				String htmlyype = Util
						.null2String((String) ManTableFieldHtmltypes
								.get(i));
				if (htmlyype.equals("6") || htmlyype.equals("7"))
					continue;
				String label = Util
						.null2String((String) ManTableFieldlabel.get(i));
				es.addColumnwidth(6000);

				if (validateids.indexOf((String) ManTableFieldIds
						.get(i)) > -1) {
					er.addStringValue(label, "MUST");
				} else {
					er.addStringValue(label, "Header");
				}

				es.addExcelRow(er);//加入一行
			}
			ExcelFile.addSheet(SystemEnv.getHtmlLabelName(21778, user
					.getLanguage()), es); //为EXCEL文件插入一个SHEET

			if(isHaveTemplate==1){
				FieldInfo.GetDetailTableFieldToExcelTemplate(formid, 1, user.getLanguage(),modeid);//根据模块导入模板获得明细字段
			}else{
				FieldInfo.GetDetailTableFieldToExcel(formid, 1, user.getLanguage());//获得明细字段
			}
			ArrayList detailtablefieldlables = FieldInfo
					.getDetailTableFieldNames();
			ArrayList detailtablefieldids = FieldInfo
					.getDetailTableFields();
			for (int i = 0; i < detailtablefieldlables.size(); i++) {
				es = new ExcelSheet(); // 初始化一个EXCEL的sheet对象
				er = es.newExcelRow(); //准备新增EXCEL中的一行
				es.addColumnwidth(6000);
				er.addStringValue("MAINID", "Header");
				ArrayList detailfieldnames = (ArrayList) detailtablefieldlables
						.get(i);
				ArrayList detailfieldids = (ArrayList) detailtablefieldids
						.get(i);
				boolean hasfield = false;
				for (int j = 0; j < detailfieldids.size(); j++) {
					String f = StringHelper.null2String(detailfieldids
							.get(j));
					String[] arr = f.split("_");
					String dhtmltype = "";
					if (arr.length == 4) {
						dhtmltype = arr[3];
						if (dhtmltype.equals("6")) {
							continue;
						}
					}

					//以下为EXCEL添加多个列
					es.addColumnwidth(6000);
					if (validateids
							.indexOf(arr[0].replace("field", "")) > -1) {
						er.addStringValue((String) detailfieldnames
								.get(j), "MUST");
					} else {
						er.addStringValue((String) detailfieldnames
								.get(j), "Header");
					}
					hasfield = true;
				}
				if (hasfield) {
					es.addExcelRow(er); //加入一行
					ExcelFile.addSheet(SystemEnv.getHtmlLabelName(
							17463, user.getLanguage())
							+ (i + 1), es); //为EXCEL文件插入一个SHEET
				}
			}
		}
		
		//获取接口路径等信息
		sql = "select * from mode_DataBatchImport where modeid="
				+ modeid;
		rs.executeSql(sql);
		if (rs.next()) {
			interfacepath = rs.getString("interfacepath");
			importorder = rs.getString("importorder");
			isuse = rs.getString("isuse");
			validateid = Util.null2String(rs.getString("validateid"));
			if (!validateid.equals("")) {
				sql = "select COUNT(a.id) id from mode_excelFieldDetail a,mode_excelField b where a.mainid=b.id and b.modeid="
						+ modeid;
				rs.executeSql(sql);
				if (rs.next()) {
					if (rs.getInt("id") > 0) {
						tempflag = true;
					}
				}
			}

		}
	}
	request.getSession(true).setAttribute("ExcelFile_modeid_"+modeid, ExcelFile);
	request.getSession(true).setAttribute("ExcelFile", ExcelFile);
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	if (sourcetype == 1 && operatelevel > 0) {
		RCMenu += "{"
				+ SystemEnv.getHtmlLabelName(86, user.getLanguage())
				+ ",javascript:onSubmitData(),_self} "; //保存
		RCMenuHeight += RCMenuHeightStep;
	}
	RCMenu += "{"
			+ SystemEnv.getHtmlLabelName(17480, user.getLanguage())
			+ ",javascript:onShowLog(),_self} "; //保存
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id="loading" style="display:none">
	<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
	<!-- 数据导入中，请稍等... -->
	<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(28210, user.getLanguage())%></span>
</div>

<div id="content">

						
						<form name="detailimportform" method="post" action="/formmode/interfaces/ModeDataBatchImportOperation.jsp" enctype="multipart/form-data" target="impIframe">
							<input type=hidden id="modeid" name="modeid" value="<%=modeid%>">
							<input type=hidden name="method" value="import"/>
							<input type=hidden id="formid" name="formid" value="<%=formid%>">
							<input type=hidden name="pageexpandid" value="<%=pageexpandid%>">
							<input type=hidden name="sourcetype" value="<%=sourcetype%>"/>
							<input type=hidden name="isnew" id="isnew" value=""/>
							<input type=hidden name="tempkey" id="tempkey" value=""/>
							<TABLE class="e8_tblForm" id="freewfoTable">
								<TBODY>
									<TR>
									    <td class="e8_tblForm_label" width="20%">1<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(258, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64, user.getLanguage())%></TD>
									    <td class="e8_tblForm_field"><a href="/weaver/weaver.file.ExcelOut?excelfile=ExcelFile_modeid_<%=modeid %>" style="color:blue;"><%=modename%></a>&nbsp;&nbsp;
									    <%
									    	if (sourcetype == 1 && operatelevel > 0) {
									    		if(isHaveTemplate==1){//编辑模板
									    			templateTitle = SystemEnv.getHtmlLabelName(93, user.getLanguage())+SystemEnv.getHtmlLabelName(64, user.getLanguage());
									    		}else{//设置模板
									    			templateTitle = SystemEnv.getHtmlLabelName(68, user.getLanguage())+SystemEnv.getHtmlLabelName(64, user.getLanguage());
									    		}%>
									    			<a  href="javascript:editTemplate();" style="color:#018efb !important;">(<%=templateTitle%>)</button>
									    		<%
									    	}
									    %>
									    </TD>
									</TR>
									<TR>
									    <td class="e8_tblForm_label" width="20%">2<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16630, user.getLanguage())%></TD>
									    <td class="e8_tblForm_field">
									    	<input <%if (operatelevel < 1 && !isRight) {%>disabled="disabled"<%}%> type="file" name="excelfile" id="excelfile" size="35" style="display:none;" onchange="$('#filepath').html(this.value);">
											<input <%if (operatelevel < 1 && !isRight) {%>disabled="disabled"<%}%> type="button" id="filebutton" value="<%=SystemEnv.getHtmlLabelName(132239, user.getLanguage())%>" onclick="excelfile.click()" style="height:22px;width:65px;">
											<span id="filepath"><%=SystemEnv.getHtmlLabelName(132240, user.getLanguage())%></span>
									    </TD>
									</TR>
									<tr>
										<td class="e8_tblForm_label" width="20%">
											<!-- 重复验证字段 -->
											3<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24638, user.getLanguage())%>
										</td>
										<td class="e8_tblForm_field">
											<select <%if (operatelevel < 1 && !isRight) {%>disabled="disabled"<%}%> name="keyField" id="keyField" onchange="javascript:checkKeyField(this);">
												<option value=""></option>
												<%
													if (importTypes.size() == 0 || importTypes.contains(3)
															|| importTypes.contains(0)) {
														String sql1 = "";
														if(isHaveTemplate==1){
															sql1 = " select 1 from  mode_import_template c where  c.fieldid=-1000 and c.modeid="+modeid+" and c.formid="+formid+" ";
														}else{
															sql1 = "select 1 from ModeFormFieldExtend where fieldid=-1000 and needExcel=1 and formid="+formid+" ";
														}
														rs.executeSql(sql1);
														if(rs.getCounts()>0){//显示数据id时，才显示此选项
												%>
												<option value="dataid"><%=SystemEnv.getHtmlLabelName(81287, user
								.getLanguage())%></option>
												<%
														}
													}
													String sqlwhere = "";
													if(isHaveTemplate==1){
														sqlwhere = " and exists (select 1 from  mode_import_template c where c.fieldid=a.id and c.modeid="+modeid+" and c.formid="+formid+" )";
													sql = "select a.fieldname,b.labelname from workflow_billfield a,HtmlLabelInfo b where a.fieldlabel=b.indexid and languageid="
															+ user.getLanguage()
															+ " and (fieldhtmltype<>6 and fieldhtmltype<> 7) and billid="
															+ formid +" " +sqlwhere+ "  and viewtype=0 order by dsporder,id";
													}else{
														sql = "select a.fieldname,b.needExcel,c.labelname from workflow_billfield a, ModeFormFieldExtend b,HtmlLabelInfo c where " 
															+"a.fieldlabel=c.indexid and b.formid=a.billid  and b.formid="+formid+" and b.fieldId=a.id and languageid = 7 and b.needExcel=1 and (fieldhtmltype<>6 and fieldhtmltype<> 7) and viewtype=0 union "
															+"select a.fieldname,1 as needExcel,c.labelname from workflow_billfield a ,HtmlLabelInfo c where a.billid="+formid+" and a.fieldlabel=c.indexid and languageid = 7"
															+"and (fieldhtmltype<>6 and fieldhtmltype<> 7)"+("oracle".equals(rs.getDBType())? "and a.detailTable is null":"and a.detailTable ='' ")+" and not exists (select 1 from ModeFormFieldExtend b where b.formid=a.billid and b.formid="+formid+" and b.fieldId=a.id)";
													}
													
													rs.executeSql(sql);
													System.out.println(sql);
													while (rs.next()) {
														String fieldname = rs.getString("fieldname");
														String labelname = rs.getString("labelname");
												%>
												<option value="<%=fieldname%>"><%=labelname%></option>	
												<%
														}
													%>
									        </select>
										</td>
									</tr>
									<tr>
										<td class="e8_tblForm_label" width="20%">
											<!-- 导入类型 -->
											4<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24863, user.getLanguage())%>
										</td>
										<td class="e8_tblForm_field">
											<select <%if (operatelevel < 1 && !isRight) {%>disabled="disabled"<%}%> id="importtype" name="importtype" onchange="changeImportType(this)">
											    <%
											    	//根据后台设置的导入类型 这里做一个限制 
											    	if (importTypes.size() == 0 || importTypes.contains(1)
											    			|| importTypes.contains(0)) {
											    %>
												<option value="1"><%=SystemEnv.getHtmlLabelName(31259, user
								.getLanguage())%></option><!-- 追加 -->
												<%
													}
													if (importTypes.size() == 0 || importTypes.contains(2)
															|| importTypes.contains(0)) {
												%>
												<option value="2"><%=SystemEnv.getHtmlLabelName(31260, user
								.getLanguage())%></option><!-- 覆盖 -->
												<%
													}
													if (importTypes.size() == 0 || importTypes.contains(3)
															|| importTypes.contains(0)) {
												%>
												<option value="3"><%=SystemEnv.getHtmlLabelName(17744, user
								.getLanguage())%></option><!-- 更新 -->
												<%
													}
												%>
											</select>
											<span id="RemindMessage" style="color:red;font-weight:bold;Letter-spacing:1px;"></span>
										</td>
									</tr>
									
									<tr >
										<td class="e8_tblForm_label" width="20%">
											<!-- Excel数据导入顺序 -->
											5<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(131321, user.getLanguage())%>
										</td>
										<td class="e8_tblForm_field">
											<%
											String importorderDis = "";
											if (sourcetype != 1) {
												importorderDis = "disabled='disabled'";
											}
											%>
											
											<select id="importorder"  name="importorder" <%=importorderDis%> >
												<option value="0"><%=SystemEnv.getHtmlLabelName(131316, user.getLanguage())%></option>
												<option value="1" <%if("1".equals(importorder)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(131317, user.getLanguage())%></option>
											</select>
											
											<span style="margin-left:15px;" title='<%=SystemEnv.getHtmlLabelName(82060,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(131319,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(131320,user.getLanguage())%>' id="remind">
												<img align="absMiddle" src="/images/remind_wev8.png">
											</span>
										</td>
									</tr>
									
									<tr id="isImportedWithIgnoringErrorTR" style="display:none;">
										<td class="e8_tblForm_label">
											6<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(129659, user.getLanguage())%>
										</td>
										<td class="e8_tblForm_field">
											<input type="checkbox" name="isImportedWithIgnoringError" id="isImportedWithIgnoringError" value="0" onclick="checkIsImportedWithIgnoringError(this)" >
										</td>
									</tr>
									
									<%
										int currentIndex = 5;
										int originalIndex = 6;
										if (sourcetype == 1) {
									%>
									<tr class="currentTR" >
										<td class="e8_tblForm_label">										
										<!-- 导入必填 -->
											<%=++currentIndex%>
											<%=SystemEnv
						.getHtmlLabelName(125163, user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("32935,18019,22628", user
						.getLanguage())%>
										</td>
										<td class="e8_tblForm_field">
										 	<button type="button" class="addbtn2" onclick="onShowModeBrowser('importValidationId','importValidationSpan');" title="<%=SystemEnv.getHtmlLabelNames("18596,15364", user
						.getLanguage())%>"></button>
										    <span id="importValidationSpan">
										    <%
										    	if (!validateid.equals("") && tempflag) {
										    %> 	
										       <a id="conditionsetting" href="javascript:onShowModeBrowser('importValidationId','importValidationSpan')"><font color='#018efb'><%=SystemEnv.getHtmlLabelName(15809, user
							.getLanguage())%></font></a>
										    <%
										    	}
										    %>
											</span>
											<input type="hidden" id="importValidationId" name="importValidationId" value="<%=validateid%>">
										</td>
									</tr>
									<tr class="originalTR" style="display:none;">
										<td class="e8_tblForm_label">										
										<!-- 导入必填 -->
											<%=++originalIndex%>
											<%=SystemEnv
						.getHtmlLabelName(125163, user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("32935,18019,22628", user
						.getLanguage())%>
										</td>
										<td class="e8_tblForm_field">
										 	<button type="button" class="addbtn2" onclick="onShowModeBrowser('importValidationId','importValidationSpan');" title="<%=SystemEnv.getHtmlLabelNames("18596,15364", user
						.getLanguage())%>"></button>
										    <span id="importValidationSpan">
										    <%
										    	if (!validateid.equals("") && tempflag) {
										    %> 	
										       <a id="conditionsetting" href="javascript:onShowModeBrowser('importValidationId','importValidationSpan')"><font color='#018efb'><%=SystemEnv.getHtmlLabelName(15809, user
							.getLanguage())%></font></a>
										    <%
										    	}
										    %>
											</span>
											<input type="hidden" id="importValidationId" name="importValidationId" value="<%=validateid%>">
										</td>
									</tr>
							        <%
							        	} else {
							        		if (!validateid.equals("") && tempflag) {
							        %>
									   <tr class="currentTR" >
										<td class="e8_tblForm_label">										
										<!-- 导入必填 -->
											<%=++currentIndex%>
											<%=SystemEnv.getHtmlLabelName(125163, user
							.getLanguage())%><%=SystemEnv.getHtmlLabelNames("32935,18019,22628",
							user.getLanguage())%>
										</td>
										<td class="e8_tblForm_field">										 	
										    <span id="importValidationSpan">
										       <a id="conditionsetting" href="javascript:onShowModeBrowser('importValidationId','importValidationSpan')"><font color='#018efb'><%=SystemEnv.getHtmlLabelName(15809, user
							.getLanguage())%></font></a>
											</span>
											<input type="hidden" id="importValidationId" name="importValidationId" value="<%=validateid%>">
										</td>
									</tr>
							           <tr class="originalTR" style="display:none;">
										<td class="e8_tblForm_label">										
										<!-- 导入必填 -->
											<%=++originalIndex%>
											<%=SystemEnv.getHtmlLabelName(125163, user
							.getLanguage())%><%=SystemEnv.getHtmlLabelNames("32935,18019,22628",
							user.getLanguage())%>
										</td>
										<td class="e8_tblForm_field">										 	
										    <span id="importValidationSpan">
										       <a id="conditionsetting" href="javascript:onShowModeBrowser('importValidationId','importValidationSpan')"><font color='#018efb'><%=SystemEnv.getHtmlLabelName(15809, user
							.getLanguage())%></font></a>
											</span>
											<input type="hidden" id="importValidationId" name="importValidationId" value="<%=validateid%>">
										</td>
									</tr>
							        <%
							        	}
							        	}
							        %>
									<%
										if (sourcetype == 1) {
									%>
									<tr class="currentTR" >
										<td class="e8_tblForm_label" width="20%">
											<!-- 接口路径 -->									
											<%=++currentIndex%><%=SystemEnv
						.getHtmlLabelName(125163, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82804, user
								.getLanguage())%>
										</td>
										<td class="e8_tblForm_field">
											<input type="text" id="interfacePath" name="interfacePath" value="<%=interfacepath%>" <%if (operatelevel < 1 && !isRight) {%>disabled="disabled"<%}%> Style="width:400px;" />
											<INPUT class="inputstyle" style="line-light: 10px;" <%if (operatelevel < 1 && !isRight) {%>disabled="disabled"<%}%> type="checkbox" id="isUse" name="isUse" value="1" <%if ("1".equals(isuse)) {%> checked=checked <%}%>/><span style="color:red;font-weight:bold;Letter-spacing:1px;">(<%=SystemEnv.getHtmlLabelName(18624, user
								.getLanguage())%>)<!-- 是否启用 --></span>
										</td>
									</tr>
									<tr class="originalTR" style="display:none;">
										<td class="e8_tblForm_label" width="20%">
											<!-- 接口路径 -->									
											<%=++originalIndex%><%=SystemEnv
						.getHtmlLabelName(125163, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82804, user
								.getLanguage())%>
										</td>
										<td class="e8_tblForm_field">
											<input type="text" id="interfacePath" name="interfacePath" value="<%=interfacepath%>" <%if (operatelevel < 1 && !isRight) {%>disabled="disabled"<%}%> Style="width:400px;" />
											<INPUT class="inputstyle" style="line-light: 10px;" <%if (operatelevel < 1 && !isRight) {%>disabled="disabled"<%}%> type="checkbox" id="isUse" name="isUse" value="1" <%if ("1".equals(isuse)) {%> checked=checked <%}%>/><span style="color:red;font-weight:bold;Letter-spacing:1px;">(<%=SystemEnv.getHtmlLabelName(18624, user
								.getLanguage())%>)<!-- 是否启用 --></span>
										</td>
									</tr>
									<%
										}
									%>
									
									<tr  class="currentTR">
										<td class="e8_tblForm_label" width="20%">
											<!-- 打印导入日志 -->
											<%
												if(sourcetype == 1) {
													currentIndex = 7;
												} else {
													if (tempflag) {
														currentIndex = 6;
													} else {
														currentIndex = 5;
													}
												}
											%>
											<%=++currentIndex%>
											<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127410, user.getLanguage())%>
										</td>
										<td class="e8_tblForm_field">
											<input type="checkbox" tzCheckbox="true" name="isprintlog" value='1'>
			 							</td>
									</tr>
									
									<tr class="currentTR" >
										<td class="e8_tblForm_label" width="20%">
											<!-- 导入 -->
											<%=++currentIndex%>
											<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18596, user.getLanguage())%>
										</td>
										<td class="e8_tblForm_field">
										<%
											boolean iscanimp = true;
											if(operatelevel < 1 && !isRight){
												iscanimp = false;
											}
										%>
											<button type="button" onclick="onSave(this,1);" <%if (!iscanimp){%>disabled="disabled"<%}%> class="boot-btn btn-primary<%if(!iscanimp){%> disabled<%}%>"><%=SystemEnv.getHtmlLabelName(25649, user.getLanguage())%></button>
										</td>
									</tr>
									<tr  class="originalTR" style="display:none;">
										<td class="e8_tblForm_label" width="20%">
											<!-- 打印导入日志 -->
											<%
												if (sourcetype == 1) {
													originalIndex = 8;
												} else {
													if (tempflag) {
														originalIndex = 7;
													} else {
														originalIndex = 6;
													}
												}
											%>
											<%=++originalIndex%>
											<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127410, user.getLanguage())%>
										</td>
										<td class="e8_tblForm_field">
											<input type="checkbox" tzCheckbox="true" name="isprintlog"  value="1">
			 							</td>
									</tr>
									<tr class="originalTR" style="display:none;">
										<td class="e8_tblForm_label" width="20%">
											<!-- 导入 -->
											<%=++originalIndex%>
											<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18596, user.getLanguage())%>
										</td>
										<td class="e8_tblForm_field">
											<button type="button" onclick="onSave(this,1);" <%if (!iscanimp) {%>disabled="disabled"<%}%> class="boot-btn btn-primary<%if (!iscanimp){%> disabled<%}%>"><%=SystemEnv.getHtmlLabelName(25649, user.getLanguage())%></button>
											<button class="impBtnTrigger" type="button" style="display: none;"></button>
										</td>
									</tr>
									<%
										if (!flag.equals("") && msg.equals("")) {
									%>
										<tr>
											<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(24960, user
								.getLanguage())%></td><!-- 提示信息 -->
											<td class="e8_tblForm_field"><font color="red"><%=SystemEnv.getHtmlLabelName(28450, user
								.getLanguage())%></font></td><!-- 导入成功！ -->
										</tr>
										<TR class="Spacing">
										    <TD class="Line" colspan="2"></TD>
										</TR>
									<%
										} else if (!msg.equals("")) {
									%>
											<tr>
												<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(24960, user
								.getLanguage())%></td><!-- 提示信息 -->
												<td class="e8_tblForm_field"><font color="red"><%=msg.replace("\\n", "<br>")%></font></td>
											</tr>
									<%
										}
									%>
									
									<TR>
									    <TD colspan="2" style="">
									        <br><b><%=SystemEnv.getHtmlLabelName(27577, user.getLanguage())%>：</b><br><!-- 操作步骤 -->

									        1<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27578, user.getLanguage())%><a href="/weaver/weaver.file.ExcelOut?excelfile=ExcelFile_modeid_<%=modeid %>" style="color:blue;"><%=modename%></a><%=SystemEnv.getHtmlLabelName(30765, user.getLanguage())%><br>
									        2<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(30766, user.getLanguage())%><br>
									        3<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(31261, user.getLanguage())%><br>
									        4<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(30767, user.getLanguage())%><br><br>
									        <b><%=SystemEnv.getHtmlLabelName(27581, user.getLanguage())%></b><br>
									        1<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(30768, user.getLanguage())%><br>
									        2<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(30769, user.getLanguage())%><span style="color:red;">(<%=SystemEnv.getHtmlLabelName(131820, user.getLanguage())%>)</span><br>
									        3<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(30770, user.getLanguage())%><br>
									        4<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(30771, user.getLanguage())%><br>
									        5<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27587, user.getLanguage())%><br>
									        6<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82723, user.getLanguage())%><br>
									        7<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(30774, user.getLanguage())%><br>
									        8<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27590, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(126300, user.getLanguage())%><br>
									        9<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(126320, user.getLanguage())%><br>
									        10<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(126429, user.getLanguage())%><br>
									        11<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(126762, user.getLanguage())%><br>
									        12<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(126763, user.getLanguage())%><br>
									        13<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><span style="color:red;font-weight:bold;Letter-spacing:1px;"><%=SystemEnv.getHtmlLabelName(31262, user.getLanguage())%></span><br>
									        14<%=SystemEnv.getHtmlLabelName(82174, user.getLanguage())%><span style="color:red;font-weight:bold;Letter-spacing:1px;"><%=SystemEnv.getHtmlLabelName(126435, user.getLanguage())%></span><br>
									        <%
									        	if (sourcetype == 1) {
									        %>
									        15<%=SystemEnv.getHtmlLabelName(82174, user
								.getLanguage())%><span style="color:red;font-weight:bold;Letter-spacing:1px;"><%=SystemEnv.getHtmlLabelName(82825, user
								.getLanguage())%></span><br>
									        16<%=SystemEnv.getHtmlLabelName(82174, user
								.getLanguage())%><span style="color:red;font-weight:bold;Letter-spacing:1px;"><%=SystemEnv
						.getHtmlLabelName(127102, user.getLanguage())%></span><br>
									        17<%=SystemEnv.getHtmlLabelName(82174, user
								.getLanguage())%><span style="color:red;font-weight:bold;Letter-spacing:1px;"><%=SystemEnv
						.getHtmlLabelName(127710, user.getLanguage())%></span><br>
						                    18<%=SystemEnv.getHtmlLabelName(82174, user
                                .getLanguage())%><span style="color:red;font-weight:bold;Letter-spacing:1px;"><%=SystemEnv
                        .getHtmlLabelName(382477, user.getLanguage())%></span><br>
									        <%
									        	} else {
									        %>
									        15<%=SystemEnv.getHtmlLabelName(82174, user
								.getLanguage())%><span style="color:red;font-weight:bold;Letter-spacing:1px;"><%=SystemEnv
						.getHtmlLabelName(127102, user.getLanguage())%></span><br>
									        16<%=SystemEnv.getHtmlLabelName(82174, user
								.getLanguage())%><span style="color:red;font-weight:bold;Letter-spacing:1px;"><%=SystemEnv
						.getHtmlLabelName(127710, user.getLanguage())%></span><br>
						                    17<%=SystemEnv.getHtmlLabelName(82174, user
                                .getLanguage())%><span style="color:red;font-weight:bold;Letter-spacing:1px;"><%=SystemEnv
                        .getHtmlLabelName(382477, user.getLanguage())%></span><br>
									        <%
									        	}
									        %>
									    </TD>
									</TR>
								</TBODY>
							</TABLE>
						</form>
						<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0" width="0"></iframe>
						<iframe id="impIframe" name="impIframe" border=0 frameborder=no noresize=NORESIZE height="0" width="0"></iframe>
</div>
<script language=javascript>
	$(document).ready(function(){//onload事件
		$(".loading", window.parent.document).hide(); //隐藏加载图片
		if($("#modeid").val()=='0'){
			if(confirm("<%=SystemEnv.getHtmlLabelName(30776, user.getLanguage())%>")){//请先保存基本信息！
				window.parent.document.getElementById('modeBasicTab').click();
			}else{
				$('.href').hide();
			}
		}
		
		if(jQuery("#importtype").val()=='2') {
			jQuery("#RemindMessage").html('<%=SystemEnv.getHtmlLabelName(31263, user.getLanguage())%>');
			Dialog.alert('<%=SystemEnv.getHtmlLabelName(31263, user.getLanguage())%>',false,550,80);//导入方式选择“覆盖”会把该模块中所有的数据全部删除，然后再导入模版中的数据，请慎用！
		}
	});
	
	function onSubmitData() {
		document.detailimportform.method.value="save";
		document.detailimportform.submit();
	}
	
	function setBtnDisabled(obj,flag){
		if(flag){//禁用
			$(obj).attr("disabled","disabled");
    		$(obj).addClass("disabled");
		}else{//启用
			$(obj).attr("disabled","");
    		$(obj).removeClass("disabled");
		}
	}

    function onSave(obj,isnew) {
    	setBtnDisabled(obj,true);
    	if(isnew&&isnew==1){
    		jQuery("#isnew").val(isnew);
    	}
        var fileName=$G("excelfile").value;
		if(fileName!=""&&fileName.length>4){
		    var keyField_select = $G("keyField").value;
		    var importtype_select = $G("importtype").value;
		    if("dataid" == keyField_select && 3 != importtype_select){
		      alert('<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())
					+ SystemEnv.getHtmlLabelName(24863, user.getLanguage())
					+ ":"
					+ SystemEnv.getHtmlLabelName(17744, user.getLanguage())%>');//
			  setBtnDisabled(obj,false);
		      return;
		    }
		    
		    if("" == keyField_select && 3 == importtype_select){
		      alert('<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())
					+ SystemEnv.getHtmlLabelName(24638, user.getLanguage())%>');//
			  setBtnDisabled(obj,false);
		      return;
		    }
			if(fileName.substring(fileName.length-4).toLowerCase()!=".xls"){
				alert('<%=SystemEnv.getHtmlLabelName(31460, user.getLanguage())%>');//必须上传.xls格式的文件
				setBtnDisabled(obj,false);
				return;
			}
			
			var tempkey = new Date().getTime();
			jQuery.ajax({
				url : "/formmode/view/checkExcel.jsp?optype=imp&tempkey="+tempkey,
				type : "post",
				dataType : "json",
				success: function do4Success(data){
					if(data){
						var msg = data.msg;
						if(msg==""){
							jQuery("#tempkey").val(tempkey);
							$G("detailimportform").submit();//上传文件
							showImpDialog(obj,0,tempkey);
						}else{
							Dialog.alert(msg);
							setBtnDisabled(obj,false);
						}
					}
				}
			});
		}else{
            alert('<%=SystemEnv.getHtmlLabelName(20890, user.getLanguage())%>');//必须上传Excel格式的文件
            setBtnDisabled(obj,false);
        }
    }
var dialog;
function showImpDialog(obj,isimport,tempkey){
	$("#rightMenu").css("visibility","hidden");
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Width = 600 ;
	dialog.Height = 370;
	dialog.normalDialog = false;
	var url = "/formmode/interfaces/ModeDataBatchImportStep.jsp?modeid=<%=modeid%>&dialogid="+dialog.ID+"&isimport="+isimport;
	if(tempkey){
		url += "&tempkey="+tempkey;
	}
	dialog.callbackfun = function (paramobj, id1) {
		setBtnDisabled(obj,false);
		$("#excelfile").val("");
		$("#filepath").html("<%=SystemEnv.getHtmlLabelName(132240, user.getLanguage())%>");
		$("#excelfile").replaceWith("<input <%if (operatelevel < 1 && !isRight) {%>disabled='disabled'<%}%> type='file' name='excelfile' id='excelfile' size='35' style='display:none;' onchange=\"$('#filepath').html(this.value);\">");
	};
	dialog.URL = url;
	dialog.Title = "批量导入";//提示信息
	dialog.Drag = false;
	dialog.show();
	showOrHideCloseBtn(false);
}

function showOrHideCloseBtn(isshow){
	var id = dialog.ID;
	var dialogDraghandle = top.$("#_Draghandle_"+id);
	var closeBtn = dialogDraghandle.find("td div:last");
	if(isshow){
		closeBtn.show();
	}else{
		closeBtn.hide();
	}
}

    function onClose() {
        window.parent.close();
    }
    
    function checkIsImportedWithIgnoringError(obj){
		if($(obj).attr("checked")){
			$(obj).val(1);
		}else{
			$(obj).val(0);
		}
	}

    function changeImportType(obj){
		if(obj.value=="1"){
			jQuery("#RemindMessage").html("");
		}else if(obj.value=="2"){
			jQuery("#RemindMessage").html('<%=SystemEnv.getHtmlLabelName(31263, user.getLanguage())%>');
			Dialog.alert('<%=SystemEnv.getHtmlLabelName(31263, user.getLanguage())%>',false,550,80);//导入方式选择“覆盖”会把该模块中所有的数据全部删除，然后再导入模版中的数据，请慎用！
		}else if(obj.value == "3") {
		    var htmls = '&nbsp;&nbsp;<input type="checkbox" name="updateadddata" id="updateadddata" value="1" >（<%=SystemEnv.getHtmlLabelName(129660, user.getLanguage())%>）';
			jQuery("#RemindMessage").html(htmls);
			jQuery("body").jNice();
		}
	}
	
	function checkKeyField(obj){
		jQuery("[name='isprintlog']").attr("checked",false);
		if(obj.value) {
			jQuery("#isImportedWithIgnoringErrorTR").show();
			jQuery(".currentTR").hide();
			jQuery(".originalTR").show();
		}else{
			jQuery("#isImportedWithIgnoringErrorTR").hide();
			jQuery(".currentTR").show();
			jQuery(".originalTR").hide();
		}
	    jQuery("#importtype").selectbox("detach");
	    jQuery("#importtype").empty();
	    if(obj.value=="dataid"){
			jQuery("#importtype").append("<option value='3'><%=SystemEnv.getHtmlLabelName(17744, user.getLanguage())%></option>");
			var htmls = '&nbsp;&nbsp;<input type="checkbox" name="updateadddata" id="updateadddata" value="1" >（<%=SystemEnv.getHtmlLabelName(129660, user.getLanguage())%>）';
			jQuery("#RemindMessage").html(htmls);
			jQuery("body").jNice();
	    }else{
	        jQuery("#importtype").append("<%=otherTypeSelect%>");
	        jQuery("#RemindMessage").html("");
	    }
	    jQuery("#importtype").selectbox("attach");
	}
	
	function onShowModeBrowser(ids,spans){
    var modeid = $("#modeid").val();
    var formid = $("#formid").val();
    var importValidationId = $("#importValidationId").val();
	urls = "/formmode/setup/ModeImportCondition.jsp?modeid="+modeid+"&formid="+formid+"&id="+importValidationId+"&sourcetype=<%=sourcetype%>";
	urls = "/systeminfo/BrowserMain.jsp?url="+escape(urls);
	dlg = new window.top.Dialog();
	dlg.currentWindow = window;
	dlg.Model = true;
	dlg.Width = 750;//定义长度
	dlg.Height = 450;
	dlg.URL = urls;
	dlg.Title = "<%=SystemEnv.getHtmlLabelNames("32935,18019,22628", user
					.getLanguage())%>";//导入必填字段
	dlg.callbackfun = function(callbackfunParam, data){
	   var id = data.id;
	   var flag = data.flag;
	   if(flag){
	      var html = "<a id='conditionsetting' href='javascript:onShowModeBrowser(\""+ids+"\",\""+spans+"\")'><font color='#018efb'><%=SystemEnv.getHtmlLabelName(15809, user.getLanguage())%></font></a>";
	      $("#"+spans).html(html);
	      $("#"+ids).val(id);
	   }else{
	      $("#conditionsetting").hide();
       }
	}
	dlg.show();
}

function editTemplate(){
	$("#rightMenu").css("visibility","hidden");
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Width = 600 ;
	dialog.Height = 600;
	dialog.normalDialog = false;
	var url = "/formmode/interfaces/ModeImportTemplate.jsp?modeid=<%=modeid%>&formid=<%=formid%>&isHaveTemplate=<%=isHaveTemplate%>";
	dialog.callback = function (paramobj, id1) {
		window.location.href = window.location.href;
	};
	dialog.URL = url;
	dialog.Title = "<%=templateTitle%>";
	dialog.show();
}
	
function onShowLog(){
	var url = "/formmode/interfaces/ModeDataBatchImportLog.jsp?modeid=<%=modeid%>&pageexpandid=<%=pageexpandid%>";
	window.location.href = url;
}
	
    
    <%if (importTypes.contains(3) && importTypes.size() == 1) {%>
         //更新 + 追加条件
         var htmls = '&nbsp;&nbsp;<input type="checkbox" name="updateadddata" id="updateadddata" value="1" >（<%=SystemEnv
						.getHtmlLabelName(129660, user.getLanguage())%>）';
	     jQuery("#RemindMessage").html(htmls);
	     jQuery("body").jNice();
    <%}%>
</script>
</body>
</html>
