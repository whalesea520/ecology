<%@page import="weaver.fna.fnaVoucher.FnaVoucherObjInit"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.fna.fnaVoucher.FnaVoucherObj"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.BaseBean"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
%>
	<%=SystemEnv.getHtmlLabelName(83328, user.getLanguage()) %>
<%
	response.flushBuffer();
	return;
}else{
	if(!HrmUserVarify.checkUserRight("intergration:financesetting", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	RecordSet rs = new RecordSet();
	String sql = "";
	
	String typename = Util.null2String(request.getParameter("typename")).trim();
	int workflowid = Util.getIntValue(request.getParameter("workflowid"));
	int fnaVoucherXmlId = Util.getIntValue(request.getParameter("fnaVoucherXmlId"));

	List fieldIdListMain = new ArrayList();
	HashMap fieldInfoHmMain = new HashMap();

	int formid = FnaWfSet.getFieldListForFieldTypeMain(fieldIdListMain, fieldInfoHmMain, workflowid);
	int formidABS = Math.abs(formid);
	
	sql = "select DISTINCT detailtable \n" +
			" from workflow_billfield \n" +
			" where detailtable like 'formtable_main_"+formidABS+"_dt%' \n"+
			" order by detailtable asc";
	rs.executeSql(sql);
	while(rs.next()){
		String detailtable = Util.null2String(rs.getString("detailtable")).trim();
		int dtlNumber = Util.getIntValue(detailtable.replaceAll("formtable_main_"+formidABS+"_dt", ""), 0);
		
		FnaWfSet.getFieldListForFieldTypeDetail(fieldIdListMain, fieldInfoHmMain, workflowid, dtlNumber);
	}
	
	int fieldIdListMainLen = fieldIdListMain.size();
	List<FnaVoucherObj> fieldNameList = new ArrayList<FnaVoucherObj>();
	FnaVoucherObjInit fnaVoucherObjInit = new FnaVoucherObjInit();
	
	if("K3".equals(typename)){
		fieldNameList = fnaVoucherObjInit.initK3(2);
	}else if("NC".equals(typename)){
		fieldNameList = fnaVoucherObjInit.initNC(2);
	}else if("EAS".equals(typename)){
	}else if("U8".equals(typename)){
		fieldNameList = fnaVoucherObjInit.initU8(2);
	}else if("NC5".equals(typename)){
		fieldNameList = fnaVoucherObjInit.initNC5(2);
	}

	int fieldNameListLen = fieldNameList.size();
%>
	<table class="LayoutTable" id="" style="table-layout:fixed;display:;width:100%;">
		<colgroup>
			<col width="10%">
			<col width="40%">
			<col width="50%">
		</colgroup>
		<tbody>
<%
	for(int i=0;i<fieldNameListLen;i++){
		FnaVoucherObj fnaVoucherObj = fieldNameList.get(i);
		
		String tr_display = "";
		if(!fnaVoucherObj.isShow()){
			tr_display = "display: none;";
		}
		
		boolean isLockDefType = fnaVoucherObj.isLockDefType();
		
		fnaVoucherObjInit.loadFnaVoucherObjFromDb(fnaVoucherXmlId, fnaVoucherObj);
		
		String fieldValue = fnaVoucherObj.getFieldValue();
		int detailTable = fnaVoucherObj.getDetailTable();
		String fieldDbTbName = fnaVoucherObj.getFieldDbTbName();
		String fieldDbName = fnaVoucherObj.getFieldDbName();
		String fieldValueType1 = fnaVoucherObj.getFieldValueType1();
		String fieldValueType2 = fnaVoucherObj.getFieldValueType2();
		String memo = fnaVoucherObj.getMemo();
		String datasourceid = fnaVoucherObj.getDatasourceid();
		int isNull = fnaVoucherObj.getIsNull();
		int inputIsSelect = fnaVoucherObj.getInputIsSelect();
		String selectValues = fnaVoucherObj.getSelectValues();
		String selectNames = fnaVoucherObj.getSelectNames();

		String display_k3_0_gsdm_sel = fnaVoucherObj.getDisplay_k3_0_gsdm_sel();
		String display_k3_0_gsdm_ipt = fnaVoucherObj.getDisplay_k3_0_gsdm_ipt();
		String display_k3_0_gsdm_span = fnaVoucherObj.getDisplay_k3_0_gsdm_span();

		String fieldValue_sel = ("".equals(display_k3_0_gsdm_sel))?fieldValue:"";
		String fieldValue_ipt = ("".equals(display_k3_0_gsdm_ipt))?fieldValue:"";
		String fieldValue_sql = ("".equals(display_k3_0_gsdm_span))?fieldValue:"";
%>
			<tr style="<%=tr_display %>">
				<td class="fieldName">
					<%=FnaCommon.escapeHtml(fnaVoucherObj.getFieldName()) %>
				</td>
				<td class="field">
					<select id="D2_<%=fieldDbTbName %>_<%=fieldDbName %>" name="D2_<%=fieldDbTbName %>_<%=fieldDbName %>" 
						onchange="workflowfield_onchange(this);" style="width: 120px !important;">
					<%if(!isLockDefType || (isLockDefType && "1".equals(fieldValueType1))){ %>
						<option value="1" <%="1".equals(fieldValueType1)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(126489,user.getLanguage())%></option><!-- 表单 -->
					<%} %>
					<%if(!isLockDefType || (isLockDefType && "3".equals(fieldValueType1))){ %>
						<option value="3" <%="3".equals(fieldValueType1)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(126490,user.getLanguage())%></option><!-- 自定义信息 -->
					<%} %>
					<%if(!isLockDefType || (isLockDefType && "8".equals(fieldValueType1))){ %>
						<option value="8" <%="8".equals(fieldValueType1)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(126491,user.getLanguage())%></option><!-- 流程requestid -->
					<%} %>
					<%if(!isLockDefType || (isLockDefType && "7".equals(fieldValueType1))){ %>
						<option value="7" <%="7".equals(fieldValueType1)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(126492,user.getLanguage())%></option><!-- 自定义SQL -->
					<%} %>
					<%if(!isLockDefType || (isLockDefType && "4".equals(fieldValueType1))){ %>
						<option value="4" <%="4".equals(fieldValueType1)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(126493,user.getLanguage())%></option><!-- 创建人 -->
					<%} %>
					<%if(!isLockDefType || (isLockDefType && "5".equals(fieldValueType1))){ %>
						<option value="5" <%="5".equals(fieldValueType1)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(126494,user.getLanguage())%></option><!-- 创建人部门 -->
					<%} %>
					<%if(!isLockDefType || (isLockDefType && "6".equals(fieldValueType1))){ %>
						<option value="6" <%="6".equals(fieldValueType1)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(126496,user.getLanguage())%></option><!-- 创建人分部 -->
					<%} %>
					</select>
					<%=FnaWfSet.getSelect(fieldIdListMain, fieldInfoHmMain, fieldValue_sel, user, formid, 
							"D2_"+fieldDbTbName+"_"+fieldDbName+"_sel", true, -1, true, display_k3_0_gsdm_sel, "workflowfieldValue_onchange(this);") %>
				<% 
				if(inputIsSelect==1){
					String[] selectValues_array = selectValues.split(",");
					String[] selectNames_array = selectNames.split(",");
					int selectValues_array_len = selectValues_array.length;
				%>
					<span id="D2_<%=fieldDbTbName %>_<%=fieldDbName %>_spanIpt" style="<%=display_k3_0_gsdm_ipt %>">
						<select id="D2_<%=fieldDbTbName %>_<%=fieldDbName %>_ipt" name="D2_<%=fieldDbTbName %>_<%=fieldDbName %>_ipt" 
							onchange="workflowfieldValue_onchange(this);">
							<%
							for(int j=0;j<selectValues_array_len;j++){
								String selectValue = selectValues_array[j];
								String selectName = selectNames_array[j];
								String isselected = "";
								if(selectValue.equals(fieldValue_ipt)){
									isselected = "selected";
								}
							%>
							<option value="<%=FnaCommon.escapeHtml(selectValue) %>" <%=isselected%>><%=FnaCommon.escapeHtml(selectName) %></option>
							<%    
							}
							%>
						</select>
					</span>
				<%
				}else{
				%>
					<input id="D2_<%=fieldDbTbName %>_<%=fieldDbName %>_ipt" name="D2_<%=fieldDbTbName %>_<%=fieldDbName %>_ipt" 
						value="<%=FnaCommon.escapeHtml(fieldValue_ipt) %>" style="width:65%;<%=display_k3_0_gsdm_ipt %>" class="inputstyle" 
						onchange="workflowfieldValue_onchange(this);" />
				<%
				}
				%>
					<span id="D2_<%=fieldDbTbName %>_<%=fieldDbName %>_span" style="<%=display_k3_0_gsdm_span %>">
						<%=SystemEnv.getHtmlLabelName(18076,user.getLanguage()) %>：
						<select id="D2_<%=fieldDbTbName %>_<%=fieldDbName %>_datasourceid" name="D2_<%=fieldDbTbName %>_<%=fieldDbName %>_datasourceid">
							<option></option>
							<%
							List pointArrayList = DataSourceXML.getPointArrayList();
							for(int j=0;j<pointArrayList.size();j++){
								String pointid = (String)pointArrayList.get(j);
								String isselected = "";
								if(datasourceid.equals(pointid)){
									isselected = "selected";
								}
							%>
							<option value="<%=FnaCommon.escapeHtml(pointid) %>" <%=isselected%>><%=FnaCommon.escapeHtml(pointid) %></option>
							<%    
							}
							%>
						</select>
						<textarea id="D2_<%=fieldDbTbName %>_<%=fieldDbName %>_sql" name="D2_<%=fieldDbTbName %>_<%=fieldDbName %>_sql"  
							onblur="workflowfieldValue_onchange(this);" 
							style="width: 430px;height: 120px;"><%=FnaCommon.escapeHtml(fieldValue_sql) %></textarea>
					</span>
				<%
				if(isNull==0){
					String _display = "display: none;";
					if("".equals(fieldValue) && ("1".equals(fieldValueType1)||"3".equals(fieldValueType1)||"7".equals(fieldValueType1))){
						_display = "";
					}
				%>
					<span class="spanBacoError_wev8" style="<%=_display%>"><img src="/images/BacoError_wev8.gif" align="absMiddle"></span>
				<%
				}
				%>
				</td>
				<td class="field" style="vertical-align: top;">
					<%=FnaCommon.escapeHtml(memo) %>
				</td>
			</tr>
			<tr style="height:1px!important;<%=tr_display %>" class="Spacing"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>
<%
	}
%>
		</tbody>
	</table>
<%
	response.flushBuffer();
	return;
	

}
%>