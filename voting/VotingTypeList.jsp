
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<%
boolean canmaint = HrmUserVarify.checkUserRight("Voting:Maint",user);
if (!canmaint) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String name = "";
String approver = "";
String id = Util.null2String(request.getParameter("id"));
if (!id.equals("")) {
	RecordSet.executeSql("select * from voting_type where id ="+id);
	if (RecordSet.next()) {
		name = Util.null2String(RecordSet.getString("typename"));
		approver = Util.null2String(RecordSet.getString("approver"));
	}
}
String typename = Util.null2String(request.getParameter("flowTitle"));
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmmain").submit();
}
jQuery(document).ready(function(){
	<%if(!id.equals("")){%>
		openDialog();
	<%}%>
});
var dialog = null;
function openDialog(){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(1421, user.getLanguage()) + SystemEnv.getHtmlLabelName(24111, user.getLanguage())%>";
    dialog.URL = "/voting/VotingTypeAdd.jsp";
	dialog.Width = 560;
	dialog.Height = 260;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.show();
}


 function doDel(id){
	 var ids=_xtable_CheckedCheckboxId();
	 if(id) ids=id;
	 
	 if(ids.length==0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
	 }else{		 
		 window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>',function(){
	       $.post("/voting/VotingTypeOperation.jsp?method=delete&votingTypeIDs="+ids,{},function(){
				 _table.reLoad();	
			 })
	   });
	 }
	 
 }

function editVoteType(id){
 	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(93, user.getLanguage()) + SystemEnv.getHtmlLabelName(24111, user.getLanguage())%>";
    dialog.URL = "/voting/VotingTypeEdit.jsp?id="+id;
	dialog.Width = 560;
	dialog.Height = 260;
	dialog.Drag = true;
	dialog.show();
	
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(24111, user.getLanguage());
String needfav = "1";
String needhelp = "";
%>
<BODY>
<form action="" name="frmmain" id="frmmain">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<colgroup>
		<col width="30%"/>
		<col width="*"/>
	</colgroup>
	<tbody>
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if (canmaint) { %>
				<% if(id.equals("")){%>
					<input type="button" name="newBtn" onclick="openDialog();" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"/>
				<%}%>
			    <input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle"  value="<%=typename %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
	</tbody>
</table>
</form>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//改造不展示
if (canmaint) {
	RCMenu += "{"+ SystemEnv.getHtmlLabelName(82, user.getLanguage())+ ",javascript:openDialog(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+ SystemEnv.getHtmlLabelName(32136, user.getLanguage())+ ",javascript:doDel(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
						<%
						if (canmaint) {
						%>
						
						<FORM id=weaverD action="VotingTypeOperation.jsp" method=post>
							<input class=inputstyle type="hidden" name="method" value="delete">
							<input class=inputstyle type="hidden" name="votingTypeIDs" id="votingTypeIDs" value="">
							<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Voting_VotingTypeListTable %>"/>
							<%
							}
							%>
									<%
										
										String sqlWhere = "1=1";
										if(!typename.equals("")){
											sqlWhere = " typename like '%"+typename+"%'";
										}
										
										String operatepopedompara = canmaint+"";
										
										String operateString = " <operates>";
											operateString +=" <popedom column=\"id\" transmethod=\"weaver.voting.VotingManager.getVotingTypeListOperation\"  otherpara=\""+operatepopedompara+"\" ></popedom> ";
											
												operateString +="     <operate otherpara=\"column:istemplate+1\" href=\"javascript:editVoteType();\" text=\"" + SystemEnv.getHtmlLabelName(93, user.getLanguage()) + "\"   index=\"0\"/>";
												operateString +="     <operate href=\"javascript:doDel();\" text=\"" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + "\"   index=\"1\"/>";
											
											operateString +=" </operates>";
										
										String tableString=""+
										   "<table instanceid=\"docMouldTable\"  pageId=\""+PageIdConst.Voting_VotingTypeListTable+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Voting_VotingTypeListTable,user.getUID(),PageIdConst.VOTING)+"\" tabletype=\"checkbox\">"+
										   " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getVotingTypeOperate\"  popedompara=\""+canmaint+"+column:id\" />"+
										   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"voting_type\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />";
											 tableString +=  operateString;   
										   tableString +="<head>"+							 
												 "<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(24111,user.getLanguage())+"\"  href=\"javascript:editVoteType('{0}')\" column=\"typename\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_self\" orderkey=\"typename\"/>"+
												 "<col width=\"50%\"  transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" text=\""+SystemEnv.getHtmlLabelName(15057,user.getLanguage())+"\" column=\"approver\"/>"+
										   "</head>"+
										   "</table>";
									%> <wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
						</FORM>
<%
String noDelMeetTypes =  (String)session.getAttribute("noDelMeetTypes");
if (noDelMeetTypes != null && noDelMeetTypes!="") {
%>
<script language="javaScript">
    window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(24111, user.getLanguage())%> <%=noDelMeetTypes%> <%=SystemEnv.getHtmlLabelName(24112, user.getLanguage())%>');
</script>
<%
session.setAttribute("noDelMeetTypes","");
}%>
</BODY>
<script language=javascript>
function submitData() {
  if(check_form(weaverA,"name")){
    weaverA.submit();
  }
}

function MainCallback(){
	dialog.close();
	_table.reLoad();
}
</script>
<script language="vbs">
	sub onShowWorkflow()
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1 and formid=241")
		if NOT isempty(id) then
		   if id(0)<> 0 then
			approvewfspan.innerHtml = id(1)
			weaverA.approver.value=id(0)
		   else
			approvewfspan.innerHtml = ""
			weaverA.approver.value = ""
			end if
		end if
	end sub
</script>
	
