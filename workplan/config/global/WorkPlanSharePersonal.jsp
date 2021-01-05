
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.WorkPlan.WorkPlanShare"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="ResourceVirtualComInfo" class="weaver.hrm.companyvirtual.ResourceVirtualComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
</HEAD>
<%

int planType = Util.getIntValue(request.getParameter("planType"), -2);  
int sharelevel = Util.getIntValue(request.getParameter("sharelevel"), 0);
int sharetype = Util.getIntValue(request.getParameter("sharetype"), 0);
String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2211,user.getLanguage())+
"-"+SystemEnv.getHtmlLabelName(2112,user.getLanguage()) ;
int needchange=0;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:add(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:deleteSh(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top middle" onclick="add()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top middle" onclick="deleteSh()"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span ><%=SystemEnv.getHtmlLabelName(20190,user.getLanguage())%></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<FORM id="frmmain" name="frmmain" method="post" action="WorkPlanSharePersonal.jsp">
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<%RecordSet.execute("SELECT * FROM WorkPlanType where (workPlanTypeID=0 or workPlanTypeID>6) and available=1 order by workPlanTypeID");%>
				 <select class=inputstyle  name="planType" id="planType" style="width:80px;">
				      <option value="-2" <%if(planType == -2){ %> selected <%} %> > </option>
					  <option value="-1" <%if(planType == -1){ %> selected <%} %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					 <%while (RecordSet.next()) {%>
					  <option value="<%=RecordSet.getString("workPlanTypeID")%>" <%if(planType == Util.getIntValue(RecordSet.getString("workPlanTypeID"), -3)){ %> selected <%} %>><%=Util.forHtml(RecordSet.getString("workPlanTypename"))%></option>
					 <%}%>
					 
				</SELECT>
			</wea:item>
			<wea:item>
				 <%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<select class=inputstyle  name="sharetype" id="sharetype" style="width:80px;">
					<option value="0" <%if(sharetype == 0) {%>selected<%} %>></option>
					  <option value="1" <%if(sharetype == 1) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
					  <option value="2" <%if(sharetype == 2) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
					  <option value="3" <%if(sharetype == 3) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
					  <option value="4" <%if(sharetype == 4) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
					  <option value="5" <%if(sharetype == 5) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
					  <option value="6" <%if(sharetype == 6) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></option>
				 		<option value="8" <%if(sharetype == 8) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
				 </SELECT>
			</wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" onclick="doSearch();" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtionAVS();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
	    </wea:group>
	</wea:layout>
	</FORM>
</div>
		<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WP_WorkPlanSharePersonal%>"/>
	
	<%	
		String shareSql="";
		if(RecordSet.getDBType().equals("oracle")){
			shareSql="select * from (SELECT id from WorkPlanShareSet where SSHARETYPE=1 and ','||SUSERID||','  like '%,"+user.getUID()+",%' UNION"+
			" SELECT id from WorkPlanShareSet where SSHARETYPE=2 and (','||SSUBCOMPANYID||','  like '%,"+user.getUserSubCompany1()+",%' ";
			String[] compids=ResourceVirtualComInfo.getSubcompanyids(""+user.getUID()).split(",");
			for(int i=0;i<compids.length;i++){
				shareSql+=" or ','||SSUBCOMPANYID||','  like '%,"+compids[i]+",%' "; 
			}
			shareSql+=" ) and SSECLEVEL<="+user.getSeclevel()+" and  sseclevelMax>="+user.getSeclevel()+" UNION "+
			" SELECT id from WorkPlanShareSet where SSHARETYPE=3 and (','||SDEPARTMENTID||','  like '%,"+user.getUserDepartment()+",%' ";
			String[] depeids=ResourceVirtualComInfo.getDepartmentids(""+user.getUID()).split(",");
			for(int i=0;i<depeids.length;i++){
				shareSql+=" or ','||SDEPARTMENTID||','  like '%,"+depeids[i]+",%' "; 
			}
			shareSql+=") and SSECLEVEL<="+user.getSeclevel()+" and  sseclevelMax>="+user.getSeclevel()+" UNION "+
			" SELECT id from WorkPlanShareSet where SSHARETYPE=5 and  SSECLEVEL<="+user.getSeclevel()+" and  sseclevelMax>="+user.getSeclevel()+" UNION "+
			" SELECT  s.id FROM WorkPlanShareSet s, hrmRoleMembers hr WHERE  SSHARETYPE=4 and s.SSECLEVEL<="+user.getSeclevel()+" and  s.sseclevelMax>="+user.getSeclevel()+
			" and hr.roleid = s.SROLEID AND hr.resourceid =1 AND hr.rolelevel >= s.SROLELEVEL ) a1 ";
		}else{
			shareSql="select * from (SELECT id from WorkPlanShareSet where SSHARETYPE=1 and ','+SUSERID+','  like '%,"+user.getUID()+",%' UNION"+
				" SELECT id from WorkPlanShareSet where SSHARETYPE=2 and (','+SSUBCOMPANYID+','  like '%,"+user.getUserSubCompany1()+",%' ";
			String[] compids=ResourceVirtualComInfo.getSubcompanyids(""+user.getUID()).split(",");
			for(int i=0;i<compids.length;i++){
				shareSql+=" or ','+SSUBCOMPANYID+','  like '%,"+compids[i]+",%' "; 
			}
			shareSql+=") and SSECLEVEL<="+user.getSeclevel()+" and  sseclevelMax>="+user.getSeclevel()+" UNION "+
				" SELECT id from WorkPlanShareSet where SSHARETYPE=3 and (','+SDEPARTMENTID+','  like '%,"+user.getUserDepartment()+",%' ";
			String[] depeids=ResourceVirtualComInfo.getDepartmentids(""+user.getUID()).split(",");
			for(int i=0;i<depeids.length;i++){
				shareSql+=" or ','+SDEPARTMENTID+','  like '%,"+depeids[i]+",%' "; 
			}
			shareSql+=") and SSECLEVEL<="+user.getSeclevel()+" and  sseclevelMax>="+user.getSeclevel()+" UNION "+
				" SELECT id from WorkPlanShareSet where SSHARETYPE=5 and  SSECLEVEL<="+user.getSeclevel()+" and  sseclevelMax>="+user.getSeclevel()+" UNION "+
				" SELECT  s.id FROM WorkPlanShareSet s, hrmRoleMembers hr WHERE  SSHARETYPE=4 and s.SSECLEVEL<="+user.getSeclevel()+" and  s.sseclevelMax>="+user.getSeclevel()+
				" and hr.roleid = s.SROLEID AND hr.resourceid ="+user.getUID()+" AND hr.rolelevel >= s.SROLELEVEL ) a1 ";
		}
	
		String backFields = "workPlanType.workPlanTypename,WorkPlanShareSet.*";
		String sqlForm = "WorkPlanShareSet left join workPlanType on WorkPlanShareSet.planid=workPlanType.workPlanTypeID join ("+shareSql+") ss on WorkPlanShareSet.id=ss.id ";
		String sqlWhere = "WHERE 1=1 ";
		if(planType > -2){
			sqlWhere += " and WorkPlanShareSet.planid = '" + planType + "' ";
		}
		if(sharelevel > 0){
			sqlWhere += " and WorkPlanShareSet.SHARELEVEL = '" + sharelevel + "' ";
		}
		if(sharetype > 0){
			sqlWhere += " and WorkPlanShareSet.sharetype = '" + sharetype + "' ";
		}
		String orderby = "settype asc, WorkPlanShareSet.planid";
		
		String tableString=""+
			"<table pagesize=\""+PageIdConst.getPageSize(PageIdConst.WP_WorkPlanSharePersonal,user.getUID())+"\" tabletype=\"checkbox\">"+
		    "<sql backfields=\"" + backFields + "\" sqlform=\"" + Util.toHtmlForSplitPage(sqlForm) + "\" sqlprimarykey=\"WorkPlanShareSet.ID\" sqlorderby=\"" + orderby + "\"  sqlsortway=\"DESC\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
		    " <checkboxpopedom  popedompara=\"column:settype\" showmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanPersonalShareCheck\"  />"+
		    "<head>"+
		    "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(16094,user.getLanguage())+"\" column=\"workPlanTypename\" orderkey=\"workPlanTypename\" otherpara=\"column:planid+"+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanTypeNew\"/>"+							    
		     "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18495,user.getLanguage())+"\" column=\"SHARETYPE\" orderkey=\"SHARETYPE\" otherpara=\""+user.getLanguage()+"+column:companyVirtual\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanShareTypes\"/>"+
		    "<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(19117,user.getLanguage())+"\" column=\"SHARETYPE\" orderkey=\"SHARETYPE\" otherpara=\"column:USERID+column:SUBCOMPANYID+column:DEPARTMENTID+column:ROLEID+column:ROLELEVEL+"+user.getLanguage()+"+column:jobtitleid+column:joblevel+column:joblevelvalue\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanShareTypeDesc\"/>"+
		    "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage()) + "\" column=\"seclevel\" orderkey=\"seclevel\"  otherpara=\"column:seclevelMax+column:SHARETYPE\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getSeclevel\" />";
		    if(WorkPlanShare.SHARE_TYPE!=2){
		    	tableString+="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(3005,user.getLanguage())+"\" column=\"SHARELEVEL\" orderkey=\"SHARELEVEL\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanShareLevelDesc\" />"; 
		    }
		    tableString+="</head>"+
			"<operates>"+
				"<popedom column=\"ID\" otherpara=\"column:settype\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanSharePersonalOperateList\" ></popedom> "+
				"<operate href=\"javascript:delplan();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
			"</operates>"+
		"</table>";
	%>
	
	<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/> 

<script language=javascript>
var dialog1;
if(window.top.Dialog){
	dialog1 = window.top.Dialog;
} else {
	dialog1 = Dialog;
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
		dialog1.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
					doDelete(ids.substr(0,ids.length - 1));	
			});
	} else {
		dialog1.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
	}
}

function delplan(id)
{
	deleteSh(id);
}

function doDelete(ids){
	$.post("PlanShareOperation.jsp?types=1&method=delete",{id:ids},function(datas){
		window.location.href="/workplan/config/global/WorkPlanSharePersonal.jsp";
	});
}

</script>

<script language="javascript">
var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	window.location.href="/workplan/config/global/WorkPlanSharePersonal.jsp";
}

function add(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 700;
	diag_vote.Height = 300;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = true;
	diag_vote.isIframe=false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20190,user.getLanguage())%>";
	diag_vote.URL = "/workplan/config/global/WorkPlanSharePersonalAdd.jsp";
	diag_vote.show();
}
function doSearch() {
	document.frmmain.submit();
}
function resetCondtionAVS(){
	var advancedSearchDiv = "#advancedSearchDiv";
	//清空文本框
	jQuery(advancedSearchDiv).find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery(advancedSearchDiv).find(".Browser").siblings("span").html("");
	jQuery(advancedSearchDiv).find(".Browser").siblings("input[type='hidden']").val("");
	jQuery(advancedSearchDiv).find(".e8_os").find("input[type='hidden']").val("");
	jQuery(advancedSearchDiv).find(".e8_outScroll .e8_innerShow span").html("");
	//清空下拉框
	jQuery(advancedSearchDiv).find("select").val("0");
	jQuery(advancedSearchDiv).find("select").trigger("change");
	
	jQuery(advancedSearchDiv).find("#planType").val("-2");
	jQuery(advancedSearchDiv).find("#planType").trigger("change");
	//清空日期
	jQuery(advancedSearchDiv).find(".calendar").siblings("span").html("");
	jQuery(advancedSearchDiv).find(".calendar").siblings("input[type='hidden']").val("");
	
	jQuery(advancedSearchDiv).find("select").selectbox('detach');
	jQuery(advancedSearchDiv).find("select").selectbox('attach');
}

function preDo(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}

function onBtnSearchClick(){
	doSearch();
}
</script>
</BODY>
</HTML>
