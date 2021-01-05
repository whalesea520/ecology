
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@page import="weaver.formmode.service.AppInfoService"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="formComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="billComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="FormInfoService" class="weaver.formmode.service.FormInfoService" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />
		<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></SCRIPT>
		<script language="JavaScript" src="/js/addRowBg_wev8.js"></script>
	</HEAD>
<%
	String userRightStr = "ModeSetting:All";
	if(!HrmUserVarify.checkUserRight(userRightStr, user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String modeid = Util.null2String(request.getParameter("modeid"));
	String formid = Util.null2String(request.getParameter("formid"));
	String subCompanyIdsql = "select subCompanyId from modeinfo where id="+ modeid;
	RecordSet recordSet = new RecordSet();
	recordSet.executeSql(subCompanyIdsql);
	int subCompanyId = -1;
	if (recordSet.next()) {
		subCompanyId = recordSet.getInt("subCompanyId");
	}
	
	Map rightMap = getCheckRightSubCompanyParam(userRightStr, user,
			fmdetachable, subCompanyId, "", request, response, session);
	int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")), -1);
	subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")), -1);
	String titlename = "";
	FormInfoService.setUser(user);
	JSONObject resultObj = FormInfoService.getAllFieldByImport(Util.getIntValue(modeid),Util.getIntValue(formid));
%>

	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		if(operatelevel>0){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;//保存
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(32757,user.getLanguage())+",javascript:clear(),_self} " ;//恢复默认
			RCMenuHeight += RCMenuHeightStep;
		}
		%>
		
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<table id="topTitle" cellpadding="0" cellspacing="0" style="display:none;">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%
			if(operatelevel>0){
			
			%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()">
			<%
			}
			%>
				<span title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
		<FORM id="frmMain" name="frmMain" action="/formmode/interfaces/ModeImportTemplateOperation.jsp" method=post>
			<input type="hidden" name="modeid" id="modeid" value="<%=modeid %>">
			<input type="hidden" name="formid" id="formid" value="<%=formid %>">
			<input type="hidden" name="operation" id="operation" value="saveorupdate">

		<TABLE class="e8_tblForm" style="margin-bottom:40px;">
		<TBODY>
			<tr>
				<td colspan=2>
					<table class="e8_tblForm" id="oTable" style="margin-top: 5px;">
						<COLGROUP>
							<COL width="5%">
							<COL width="25%">
							<COL width="15%">
							<COL width="20%">
						</COLGROUP>
						<tr class="header" >
						   <th><input type="checkbox" name="selectall" id="selectall" onclick="SelAll(this)"></th>
						   <th><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></th><!-- 名称 -->
						   <th><%=SystemEnv.getHtmlLabelName(21900,user.getLanguage())%></th><!-- 提示信息 -->
						   <th><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></th><!-- 显示顺序 -->
						</tr>
						<%
							String maintable1 =  resultObj.getString("maintable");
							JSONArray tables =  resultObj.getJSONArray("tables");
							for(int i=0;i<tables.size();i++){
								String table = tables.getString(i);
								String tablename = table.replace(maintable1, "");
								String tablename1 = "";
								if("".equals(tablename)){
									tablename = SystemEnv.getHtmlLabelName(21778,user.getLanguage())+"("+maintable1+")";
									tablename1 = SystemEnv.getHtmlLabelName(21778,user.getLanguage());
								}else{
									tablename = table.replace(maintable1+"_dt", "");
									tablename1 = SystemEnv.getHtmlLabelName(17463,user.getLanguage())+tablename;
									tablename = SystemEnv.getHtmlLabelName(17463,user.getLanguage())+tablename+"("+table+")";
								}
								JSONArray data = resultObj.getJSONArray(table);
								if(data.size()>0){
									%>
									<tr class="tableTr"><td colspan="4"><span class="groupbg"> </span><%=tablename%></td></tr>
									<%
								}
								for (int j = 0; j < data.size(); j++) {
									JSONObject jsonObject = data.getJSONObject(j);
									String fieldid = jsonObject.getString("fieldid");
									String fieldname = jsonObject.getString("fieldname");
									String fieldlabelname = jsonObject.getString("fieldlabelname");
									String ischeck = jsonObject.getString("ischeck");
									String dsporder = jsonObject.getString("dsporder");
									String css = "";
									if("-1000".equals(fieldid)||"-1001".equals(fieldid)||"-1002".equals(fieldid)){
										css = "display:none;";
									}
									%>
									<tr class="rowTr">
									<td><input <%if("1".equals(ischeck)){%>checked="checked"<%}%> type="checkbox" onclick="checkDsporder('<%=fieldid%>')" id="check_node" name="check_node" fieldid="<%=fieldid%>" class="check_node_<%=fieldid%>" value="<%=fieldid%>" ></td>
									<td ><%=fieldlabelname+" ["+fieldname+"]"%></td>
									<td ><%=tablename1%></td>
									<td>
									<span style="<%=css%>">
									<INPUT class=inputstyle type="text" style="width:120px" maxLength=18 size=20 name="dsporder_<%=fieldid%>" id="dsporder_<%=fieldid%>" onKeyPress="ItemDecimal_KeyPress('dsporder_<%=fieldid%>',8,2)" 
										onchange="checkDsporder('<%=fieldid%>');" value="<%=dsporder%>">
									<SPAN id="dsporder_<%=fieldid%>image"><%if("1".equals(ischeck)&&"".equals(dsporder)){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
									</span>
									</tr>
									<%
								}
							}
						%>
						
					</table>
				</td>
			</tr>
		</TBODY>
		</TABLE> 
		</FORM>
		
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col" needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
    		<input type="button" class=zd_btn_submit  id=btncancel onclick="btncancel_onclick();" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"><!-- 取消 -->
</wea:item>
</wea:group>
</wea:layout>
</div>
<style>
#oTable tr.tableTr td{
	padding:8px 6px;
}

.groupbg {
    background-image: url("/wui/theme/ecology8/templates/default/images/groupHead_wev8.png");
    background-repeat: no-repeat;
    background-position: 0 50%;
    display: inline-block;
    width: 16px;
    height: 17px;
    float: left;
    margin-right: 6px;
}

tr.rowTr{
	
}
</style>
<script>

var dialog;
var parentWin;
try{
		parentWin = window.parent.parent.parent.getParentWindow(parent);
		dialog = window.parent.parent.parent.getDialog(parent);
		if(!dialog){
			parentWin = parent.parentWin;
			dialog = parent.dialog;
		}
}catch(e){
		
}
	
function submitData(){
	if(checkOrder()){
		enableAllmenu();
        frmMain.submit();
	}
}

function clear(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("826,32757,19653",user.getLanguage())+"?"%>",function(){
		jQuery("#operation").val("clear");
		enableAllmenu();
    	frmMain.submit();
	});
	
}

function checkOrder(){
	var chks = jQuery("[name=check_node]:checked");
	for (var i=0;i<chks.length;i++){
        var fieldid = jQuery(chks[i]).attr("fieldid");
        if(fieldid<0){
        	continue;
        }
        if(isNaN(jQuery("#dsporder_"+fieldid).val())){
			jQuery("#dsporder_"+fieldid).val("");
		}
        if(jQuery("#dsporder_"+fieldid).val()==""){
        	Dialog.alert("<%=SystemEnv.getHtmlLabelName(129512,user.getLanguage())%>");
        	return false;
        }
    } 
    return true;
}

function checkDsporder(fieldid){
	if(isNaN(jQuery("#dsporder_"+fieldid).val())){
		jQuery("#dsporder_"+fieldid).val("");
	}
	var chk = jQuery(".check_node_"+fieldid)[0].checked; 
	if(chk){
		checkinput('dsporder_'+fieldid,'dsporder_'+fieldid+'image');
	}else{
		jQuery('#dsporder_'+fieldid+'image').html("");
	}
}

function SelAll(obj){
	var chks = document.getElementsByName("check_node"); 
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        changeCheckboxStatus(chk, obj.checked);
        var fieldid = jQuery(chk).attr("fieldid");
        checkDsporder(fieldid);
    } 
}

function btncancel_onclick(){
    if(dialog){
		dialog.close();
	}
}

</script>
</BODY>
</HTML>
