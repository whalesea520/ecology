
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo"
	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight"
	class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
	String requestid = Util.null2String(request.getParameter("requestid"));
	String wfid = Util.null2String(request.getParameter("wfid"));
	String currentnodeid = "";
	RecordSet.executeSql("select currentnodeid from workflow_requestbase where requestid = "+  requestid);
	if(RecordSet.next()) {
		currentnodeid = RecordSet.getString("currentnodeid");
	}
	
	int subcompanyid = -1;
	int nowuserid = user.getUID();
	boolean isshowdelete = false;
	String isremark = "";
	RecordSet.executeSql("select isremark from WORKFLOW_CURRENTOPERATOR where requestid = "+  requestid + " and workflowid = " + wfid + " and userid = " + nowuserid);
	if(RecordSet.next()) {
		isremark = RecordSet.getString("isremark");
		if("0".equals(isremark)){
			isshowdelete = true;
		}
	}

	String isview = "";
	RecordSet.executeSql("SELECT isview FROM workflow_monitor_bound WHERE WORKFLOWID = " + wfid + " AND MONITORHRMID = " + nowuserid);
	if(RecordSet.next()) {
		isview = RecordSet.getString("isview");
		if("1".equals(isview)){
			isshowdelete = true;
		}
	}
	
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<LINK href="/js/ecology8/meeting/meetingbase_wev8.css" type=text/css rel=STYLESHEET>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css"
			type="text/css" />
		<link rel="stylesheet"
			href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css"
			type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(780, user
				.getLanguage());
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY style="overflow: hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(isshowdelete){
			RCMenu += "{" + SystemEnv.getHtmlLabelName(611, user.getLanguage())
					+ ",javascript:add(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(32136, user.getLanguage())+",javascript:delRoomPrm(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<!-- <table cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align: right; width: 100% !important">
					<input type=button style="Float:right;" name="deleteInputCol" class=delbtn accessKey=E onClick="delRoomPrm()" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
					<input type=button style="Float:right;" name="addInputCol" class=addbtn accessKey=A onClick="add()" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>" class="e8_btn_top middle" onclick="add()" />
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>" class="e8_btn_top middle" onclick="delRoomPrm()" />
				</td>
			</tr>
		</table> -->
		<wea:layout type="fourCol">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(2112, user.getLanguage())%>'>
		<wea:item type="groupHead">
		<%
			if(isshowdelete){
		%>
			<input type=button name="addCol" class=addbtn accessKey=A onClick="add()" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input> 
			<input type=button name="deleteCol" class=delbtn accessKey=E onClick="delRoomPrm()" title="E-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
		<%} %>	
			<%--
			<button type="button"  name="addCol" class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="addNewCol();" ><%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%></button>
			<input type=button name="addCol" class=addbtn accessKey=A onClick="addNewCol()" title="<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%>"></input> --%>
		</wea:item> 
		<wea:item attributes="{'isTableList':'true'}">
		<div class="zDialog_div_content" id="shareDiv" name="shareDiv">
			<%
					String orderby = " id ";
					String tableString = "";
					int perpage = 10;
					String sqlwhere = " wfid = " + wfid + " and requestid = " + requestid;
					String otherParaobj = "column:departmentid+column:subcompanyid+column:userid+column:roleid+column:rolelevel+"+user.getLanguage();
					String otherParalvl = "column:deptlevel+column:deptlevelMax+column:sublevel+column:sublevelMax+column:seclevel+column:seclevelMax+column:roleseclevel+column:roleseclevelMax";
					//System.out.println("[" + sqlwhere + "]");
					String backfields = " id,wfid,requestid,permissiontype,departmentid,deptlevel,subcompanyid,sublevel,seclevel,userid,seclevelMax,deptlevelMax,sublevelMax,roleid,rolelevel,roleseclevel,roleseclevelMax,iscanread,operator,currentnodeid ";
					String fromSql = " Workflow_SharedScope ";
					tableString = " <table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""
							+ perpage
							+ "\" >"
							+ " <checkboxpopedom  id=\"checkbox\" popedompara=\"1\" showmethod=\"weaver.workflow.request.WFShareTransMethod.getCheckbox\"  />"
							+ "       <sql backfields=\""
							+ backfields
							+ "\" sqlform=\""
							+ fromSql
							+ "\"  sqlwhere=\""
							+ Util.toHtmlForSplitPage(sqlwhere)
							+ "\"  sqlorderby=\""
							+ orderby
							+ "\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"
							+ "       <head>"
							+ "           <col width=\"20%\"  text=\""
							+ SystemEnv.getHtmlLabelName(21956, user.getLanguage())
							+ "\" column=\"permissiontype\" orderkey=\"permissiontype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.request.WFShareTransMethod.getWFPermissiontype\" />"
							+ "           <col width=\"20%\"  text=\""
							+ SystemEnv.getHtmlLabelName(106, user.getLanguage())
							+ "\" column=\"permissiontype\" orderkey=\"permissiontype\" otherpara=\""
							+ otherParaobj
							+ "\" transmethod=\"weaver.workflow.request.WFShareTransMethod.getWFPermissionObj\" />"
							+ "           <col width=\"20%\"  text=\""
							+ SystemEnv.getHtmlLabelName(683, user.getLanguage())
							+ "\" column=\"permissiontype\" orderkey=\"permissiontype\" otherpara=\""
							+ otherParalvl
							+ "\" transmethod=\"weaver.workflow.request.WFShareTransMethod.getWFPermissionlevel\" />"
							
							+ "<col width=\"20%\"  text=\""
							+ SystemEnv.getHtmlLabelName(1380, user.getLanguage())+ SystemEnv.getHtmlLabelName(504, user.getLanguage())
							+ "\" column=\"iscanread\" orderkey=\"iscanread\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.request.WFShareTransMethod.getWFIsCanread\" />"
							+ "<col width=\"20%\"  text=\""
							+ SystemEnv.getHtmlLabelName(82615, user.getLanguage())
							+ "\" column=\"operator\" orderkey=\"operator\" transmethod=\"weaver.workflow.request.WFShareTransMethod.getWFOperator\" />"
							
							+ "       </head>";
			                if(isshowdelete){
			                	tableString += "		<operates>"+
			                	"		<popedom column=\"id\" transmethod=\"weaver.workflow.request.WFShareTransMethod.checkWFPrmOperate\"></popedom> "+
			                	"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
								"		</operates>";
			                }
			                tableString += " </table>";

					//System.out.println(tableString);
			%>
			<input type="hidden" value="<%=wfid%>" name="wfid" id="wfid">
			<input type="hidden" value="<%=requestid%>" name="requestid" id="requestid">
				<TABLE width="100%" cellspacing=0>
					<tr>
						<td valign="top">
							<wea:SplitPageTag tableString='<%=tableString%>' mode="run" />
						</td>
					</tr>
				</TABLE>
		</div>
		</wea:item>
		</wea:group>
		</wea:layout>
		
	</body>
</html>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript">
var diag_vote;
var dlg;
if(window.top.Dialog){
	dlg = window.top.Dialog;
} else {
    dlg = Dialog;
}

function delRoom(id){
	var ids = id+",";
	dlg.confirm("<%=SystemEnv.getHtmlLabelName(33601, user.getLanguage())%>", function (){
		doDeleteRoom(ids);	
	}, function () {}, 320, 90,false);
}

function add(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 500;
	diag_vote.Height = 400;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())+SystemEnv.getHtmlLabelName(119, user.getLanguage())%>";
	diag_vote.URL = "/workflow/request/WorkflowPrmsnAddTab.jsp?wfid=<%=wfid %>&requestid=<%=requestid %>&currentnodeid=<%=currentnodeid%>";
	diag_vote.show();
}

function onDel(id){
	delRoomPrm(id);
}

function delRoomPrm(id){
	var ids = "";
	if(id==null ||id=="" || id == "NULL" || id == "Null" || id == "null"){
		$("input[name='chkInTableTag']").each(function(){
			if($(this).attr("checked"))			
				ids = ids +$(this).attr("checkboxId")+",";
		});
	} else {
		ids = id+",";
	}
	if(ids=="") {
		dlg.alert("<%SystemEnv.getHtmlLabelName(84534, user.getLanguage())%>!") ;
	} else {
		dlg.confirm("<%SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>", function (){
		doDeleteRoomPrm(ids);
		}, function () {}, 300, 90, true, null, null, null, null, null);
	}
}

function doDeleteRoomPrm(ids){
	$.post("/workflow/request/WorkflowPrmOperation.jsp",{method:"prmDelete",ids:ids,wfid:"<%=wfid%>",requestid:"<%=requestid%>"},function(datas){
		location='/workflow/request/WorkflowSharedScope.jsp?wfid=<%=wfid%>&requestid=<%=requestid%>';
	});
}
jQuery(document).ready(function(){
	resizeDialog();
});
</script>
