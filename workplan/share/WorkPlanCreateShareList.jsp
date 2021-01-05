
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.WorkPlan.WorkPlanShare"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
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
			<span ><%=SystemEnv.getHtmlLabelName(19792,user.getLanguage())%></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<FORM id="frmmain" name="frmmain" method="post" action="WorkPlanCreateShareList.jsp">
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
				 <%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<select class=inputstyle  name="sharelevel" id="sharelevel" style="width:80px;">
					<option value="0" <%if(sharelevel == 0) {%>selected<%} %> > </option>
				  	<option value="1" <%if(sharelevel == 1) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
				  	<option value="2" <%if(sharelevel == 2) {%>selected<%} %>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
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
					  <option value="9" <%if(sharetype == 9) {%>selected<%} %>><%=SystemEnv.getHtmlLabelNames("2211,15525",user.getLanguage())%></option>
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
	<%	
		String backFields = "workPlanType.workPlanTypename, WorkPlanCreateShareSet.*";
		String sqlForm = "WorkPlanCreateShareSet left join workPlanType on WorkPlanCreateShareSet.planid=workPlanType.workPlanTypeID";
		String sqlWhere = "WHERE SUSERID= "+user.getUID();	
		if(planType > -2){
			sqlWhere += " and WorkPlanCreateShareSet.planid = '" + planType + "' ";
		}
		if(sharelevel > 0){
			sqlWhere += " and WorkPlanCreateShareSet.SHARELEVEL = '" + sharelevel + "' ";
		}
		if(sharetype > 0){
			sqlWhere += " and WorkPlanCreateShareSet.sharetype = '" + sharetype + "' ";
		}	
														
		String orderby = "WorkPlanCreateShareSet.planid";
		
		String tableString=""+
		"<table pagesize=\""+PageIdConst.getPageSize(PageIdConst.WP_WorkPlanCreateShareSet,user.getUID())+"\" tabletype=\"checkbox\">"+
	    "<sql backfields=\"" + backFields + "\" sqlform=\"" + sqlForm + "\" sqlprimarykey=\"WorkPlanCreateShareSet.ID\" sqlorderby=\"" + orderby + "\"  sqlsortway=\"DESC\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
	    "<head>"+
	    "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16094,user.getLanguage())+"\" column=\"workPlanTypename\" orderkey=\"workPlanTypename\" otherpara=\"column:planid+"+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanTypeNew\"/>"+
	    "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18495,user.getLanguage())+"\" column=\"SHARETYPE\" orderkey=\"SHARETYPE\" otherpara=\""+user.getLanguage()+"+column:companyVirtual\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanShareTypes\"/>"+	
	   "<col width=\"14%\"  text=\""+SystemEnv.getHtmlLabelName(19117,user.getLanguage())+"\" column=\"SHARETYPE\"  otherpara=\"column:USERID+column:SUBCOMPANYID+column:DEPARTMENTID+column:ROLEID+column:ROLELEVEL+"+user.getLanguage()+"+column:jobtitleid+column:joblevel+column:joblevelvalue\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanShareTypeDesc\"/>"+
	    "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage()) + "\" column=\"seclevel\" orderkey=\"seclevel\" otherpara=\"column:seclevelMax+column:SHARETYPE\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getSeclevel\" />";
	   tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(3005,user.getLanguage())+"\" column=\"SHARELEVEL\" orderkey=\"SHARELEVEL\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanShareLevelDesc\" />"; 
		    tableString+="</head>"+
			"<operates>"+
				"<popedom column=\"ID\"  ></popedom> "+
				"<operate href=\"javascript:delplan();\" isalwaysshow=\"true\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
			"</operates>"+
		"</table>";
	%>
	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WP_WorkPlanCreateShareSet%>"/>
	<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/> 

</td>
		</tr>
		</TABLE>
	</td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

<script language=javascript>
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
	}else {
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
	}
}

function delplan(id)
{
	deleteSh(id);
}

function doDelete(ids){
	$.post("WorkPlanCreateShareHandler.jsp?method=delete",{id:ids},function(datas){
		_table.reLoad();
	});
}


</script>

<script language="javascript">
var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	_table.reLoad();
	diag_vote.close();
}

function add(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 730;
	diag_vote.Height = 300;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(20190,user.getLanguage())%>";
	diag_vote.URL = "/workplan/share/WorkPlanCreateShareAdd.jsp";
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
