
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.Constants" %>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetu" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetd" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<%
	String target = Util.null2String(request.getParameter("target"));
    String workPlanTypeID = Util.null2String(request.getParameter("workPlanType"));
    String timeModul = Util.null2String(request.getParameter("timeModul"));
    String planName = Util.null2String(request.getParameter("planName"));
	String imagefilename = "/images/hdHRM_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(18220,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	if("".equals(target)){
		target="modul";
	}
%>

<%
	String groupId=Util.null2String(request.getParameter("id"));
	String requestid="";
	boolean flag=false;
	String urgentLevel="";
	String type="";
	String planDate="";
	String objId=""+user.getUID();
%>

<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
	<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

	<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:add(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:deleteSh(),_self}";
	RCMenuHeight += RCMenuHeightStep;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" class="e8_btn_top middle" onclick="add()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top middle" onclick="deleteSh()"/>
			<input type="text" class="searchInput" id="t_name" name="t_name" value=""/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span ><%=SystemEnv.getHtmlLabelName(18220,user.getLanguage())%></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
<FORM id="frmmain" name="frmmain" method="post" action="PlanModulListCtnt.jsp">
<input type="hidden" name="target" value="<%=target %>">
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' >
				<wea:item>
			<!--================== 标题 ==================-->
				<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>
				</wea:item>
				<wea:item>      
					<INPUT class="inputstyle"  maxLength=50 size=50 name="planName" id="planName" value="<%=planName%>" onchange='checkinput("name","nameimage")'>
				</wea:item>
			<!--================== 类型 ==================-->
				<%
				if("workplan".equals(target))
				//从日程进入(工作安排)
				{
					rs2.executeSql("SELECT * FROM WorkPlanType" + Constants.WorkPlan_Type_Query_By_Menu);
				%>
				<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
				<wea:item>
					<SELECT name="workPlanType" id="workPlanType">
						<OPTION value="" > </OPTION>
					<%
						while(rs2.next())
						{
							String workPlanTypeIDOption = String.valueOf(rs2.getInt("workPlanTypeID"));
					%>
						<OPTION value=<%= workPlanTypeIDOption %> <% if(workPlanTypeID.equals(workPlanTypeIDOption)) { %> selected <% } %>><%= Util.forHtml(rs2.getString("workPlanTypeName")) %></OPTION>
					<%										  					
						}
					%>
					</SELECT>
						
				</wea:item>
				<%
				}
				%>	
				<!--================== 定期模式 ==================-->  
				<wea:item><%=SystemEnv.getHtmlLabelName(18221, user.getLanguage())%></wea:item>
				<wea:item> 
					<SELECT id="timeModul" name="timeModul"  style="width:150px!important">
						<OPTION value="" > </OPTION>
						<OPTION value="9" <%if (Util.null2String(timeModul).equals("9")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18223,user.getLanguage())%></OPTION><!--不定期建立计划-->
						<OPTION value="3" <%if (Util.null2String(timeModul).equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION><!--天-->
						<OPTION value="0" <%if (Util.null2String(timeModul).equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></OPTION><!--周-->
						<OPTION value="1" <%if (Util.null2String(timeModul).equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></OPTION><!--月-->
						<OPTION value="2" <%if (Util.null2String(timeModul).equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></OPTION><!--年-->
					</SELECT>
				</wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" onclick="doSearchAgain();" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</FORM>		
</div>
<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<TR>
		<TD valign="top" style="padding-left:5px;padding-right:5px;">
						<FORM name="planform" method="post" action="PlanModulOperation.jsp">					
						<INPUT type="hidden" name="operationType" value="process">
						<INPUT type="hidden" name="src">
						<INPUT type="hidden" name="from" value="list">
						<INPUT type="hidden" name="requestId" value=<%=requestid%> >
						<INPUT type="hidden" name="objId" value=<%=objId%>>
						<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WP_PlanModuleList%>"/>
						<%
							String backFields = "hrmPerformancePlanModul.*, hrmPerformancePlanKindDetail.planName";
							String sqlForm = "HrmPerformancePlanModul hrmPerformancePlanModul LEFT JOIN HrmPerformancePlanKindDetail hrmPerformancePlanKindDetail ON hrmPerformancePlanKindDetail.ID = hrmPerformancePlanModul.planProperty";
							String sqlWhere = "WHERE objID = " + objId+" ";
							if("workplan".equals(target)){
								sqlWhere+=" and type_n='0' ";
							}else{
								sqlWhere+=" and type_n<>'0' ";
							}
							
							if(!"".equals(planName)){
								sqlWhere += " and name like '%"+planName+"%' ";
							}
							
							if(!"".equals(timeModul)){
								sqlWhere += " and timeModul = '"+ timeModul + "' ";
							}
							
							if(!"".equals(workPlanTypeID)){
								sqlWhere += " and workPlanTypeId = "+ workPlanTypeID+" " ;
							}
							
							String tableString=""+
								"<table pagesize=\""+PageIdConst.getPageSize(PageIdConst.WP_PlanModuleList,user.getUID())+"\" tabletype=\"checkbox\">"+
								"<sql backfields=\"" + backFields + "\" sqlform=\"" + sqlForm + "\" sqlprimarykey=\"hrmPerformancePlanModul.id\"  sqlsortway=\"DESC\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
								"<head>"+
								"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"workPlanTypeId\" orderkey=\"workPlanTypeId\" otherpara=\"column:type_n+"+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForPlanMode.getPlanTypeDesc\"/>"+
								"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(229,user.getLanguage())+"\" column=\"id\" orderkey=\"name\" otherpara=\""+target+"+column:cycle+column:planDate+column:name+"+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForPlanMode.getPlanModeName\"/>"+	
								"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(2097,user.getLanguage())+"\" column=\"principal\" orderkey=\"principal\"  transmethod=\"weaver.splitepage.transform.SptmForPlanMode.getResourceName\"/>"+
								"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(18221,user.getLanguage())+"\" column=\"timeModul\" orderkey=\"timeModul\" otherpara=\"column:workPlanCreateTime+column:frequency+column:createType+column:frequencyy+"+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForPlanMode.getTimeModul\"/>"+
								"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15030,user.getLanguage())+"\" column=\"availableBeginDate\" orderkey=\"availableBeginDate\" otherpara=\"column:availableEndDate+column:timeModul\" transmethod=\"weaver.splitepage.transform.SptmForPlanMode.getValidDate\"/>"+
								"</head>"+
								"<operates>"+
									"<popedom column=\"id\" otherpara=\"column:timeModul\" transmethod=\"weaver.splitepage.transform.SptmForPlanMode.getWorkPlanPlanModelOpt\"></popedom> "+
									"<operate href=\"javascript:createWp();\" text=\""+SystemEnv.getHtmlLabelName(21149,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
									"<operate href=\"javascript:deldetail();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
								"</operates>"+
							"</table>";
						%>
						<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/> 
						
			 			</FORM>
		</TD>
	</TR>
	<TR>
		<TD height="10" colspan="3"></TD>
	</TR>
</BODY>
</HTML>

<SCRIPT language="javascript">
function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}

function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("input[name='planName']").val(name);
	doSearchAgain();
}
var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	window.location.href="/hrm/performance/targetPlan/PlanModulListCtnt.jsp?target=<%=target%>";
}

function add(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.isIframe=false;
	diag_vote.checkDataChange = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>&nbsp;<%=SystemEnv.getHtmlLabelName(18220,user.getLanguage())%>";
	diag_vote.URL = "/hrm/performance/targetPlan/PlanModelAdd.jsp?target=<%=target%>";
	diag_vote.show();
}

function view(id, target, cycle, planDate){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.checkDataChange = true;
	diag_vote.isIframe=false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(18220,user.getLanguage())%>";
	diag_vote.URL = "/hrm/performance/targetPlan/PlanModelAdd.jsp?target="+target+"&id="+id+"&type_d=3&type="+cycle+"&planDate="+planDate;

	diag_vote.show();
	
}

function deleteSh(id){
	var ids = "";
	if(id==null ||id=="" || id == "NULL" || id == "Null" || id == "null"){
		$("input[name='chkInTableTag']").each(function(){
			if($(this).attr("checked"))
				ids = ids +$(this).attr("checkboxId")+",";
		});
	} else {
		ids = id+",";
	}
	if(ids!="") {
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
					doDelete(ids.substr(0,ids.length - 1));	
			});
	}else{
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
	}
}

function deldetail(id)
{
	deleteSh(id);
}

function doSubmit()
{
	document.planform.src.value="submit";
	document.planform.submit();
	enablemenu();	
}

function doDelete(ids){
	//enablemenu();
	$.post("PlanModulOperation.jsp?operationType=del",{id:ids},function(datas){
		window.location.href="/hrm/performance/targetPlan/PlanModulListCtnt.jsp?target=<%=target%>";
	});
}

function doSearchAgain() 
{
	document.frmmain.submit();
}

function createWp(id){
	$.post("PlanModulOperation.jsp?operationType=createwp",{planModulId:id},function(datas){
		if(datas != ""){
			//Dialog.alert("<%=SystemEnv.getHtmlLabelName(21149,user.getLanguage())+(user.getLanguage() == 8?" ":"")+SystemEnv.getHtmlLabelName(25008,user.getLanguage())%>!");
			viewWp(datas);
		} else {
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(21149,user.getLanguage())+(user.getLanguage() == 8?" ":"")+SystemEnv.getHtmlLabelName(25009,user.getLanguage())%>.");
		}
	});
}

function viewWp(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.checkDataChange = false;
	diag_vote.isIframe=false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>";

	diag_vote.URL = "/workplan/data/WorkPlanDetail.jsp?from=1&workid=" + id ;
	diag_vote.show();
	
}


function resetCondtion(){
	jQuery("#planName").val("");
	
	jQuery("#workPlanType").val("");
	jQuery("#workPlanType").trigger("change");
	
	jQuery("#timeModul").val("");
	jQuery("#timeModul").trigger("change");
	
	jQuery("#advancedSearchDiv").find("select").selectbox('detach');
	jQuery("#advancedSearchDiv").find("select").selectbox('attach');
}

function confirms(id,cycle,planDate)
{
	document.planform.planId.value=id;
	document.planform.type.value=cycle;
	document.planform.planDate.value=planDate;
	document.planform.operationType.value="confirm";
	document.planform.submit();
	enablemenu();
}
</SCRIPT>

    
