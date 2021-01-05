
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<script language=javascript src="/js/weaver_wev8.js"></script>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int isbill=Util.getIntValue(Util.null2String(request.getParameter("isbill")),-1);
int billId = Util.getIntValue(request.getParameter("billId"),0) ;
int operatelevel = UserWFOperateLevel.checkWfFormOperateLevel(detachable,user,"FormManage:All",billId,isbill);
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) || operatelevel < 0){
		response.sendRedirect("/notice/noright.jsp");
    		return;
}

String titlename = SystemEnv.getHtmlLabelName(468,user.getLanguage())+SystemEnv.getHtmlLabelName(699,user.getLanguage());

int billNameId = Integer.parseInt(BillComInfo.getBillLabel(String.valueOf(billId)));
String billName = SystemEnv.getHtmlLabelName(billNameId,user.getLanguage());
titlename += " : " + billName ;

int frompage = Util.getIntValue(request.getParameter("frompage"),0) ;
frompage = 1;
%>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	if(operatelevel>0){
		if(frompage==1){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(17998,user.getLanguage())+",javascript:addNewFieldDialog(1,0),_self}" ;
		    RCMenuHeight += RCMenuHeightStep ;
		}else{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(17998,user.getLanguage())+",/workflow/workflow/BillManagementFieldAdd0.jsp?src=addfield&srcType=mainfield&isbill=0&billId="+billId+",_self}" ;
		    RCMenuHeight += RCMenuHeightStep ;
		}
		
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:OnMultiSubmit(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	if(detachable==1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(18581,user.getLanguage())+",/workflow/workflow/BillRightManagent.jsp?detailno=0&isbill="+isbill+"&billid="+billId+",_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:addformtabretun(),_self}" ;
	//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table> 

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		
				<TABLE width="100%">
                    <tr>
                      <td valign="top">                                                                                    
                          <%      
                          	
                          	int  perpage=50;                                          
                            String backfields = "t1.id,t1.fieldname, t1.fieldlabel, t1.fieldhtmltype, t1.type, t1.dsporder, t1.viewtype, t1.fromUser";
                            String fromSql  = "from workflow_billfield t1 ";
                            String sqlWhere = " where t1.viewtype=0 and t1.billid=" + billId;  
                            String orderby = "dsporder" ;
                            String tableString = "";  
                          	tableString =" <table instanceid=\"billManagementDetailTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_BILLMANAGEMENTDETAIL0,user.getUID())+"\" >"+
                                                 " <checkboxpopedom    popedompara=\"column:fromUser\" showmethod=\"weaver.workflow.workflow.WorkFlowFieldTransMethod.getCanCheckBox\" />"+
                                                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
                                                 "			<head>"+                                          
                                                 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15456,user.getLanguage())+"\" column=\"fieldlabel\"  otherpara=\""+user.getLanguage()+"+column:id+column:fromUser+"+billId+"+0+"+frompage+"\" transmethod=\"weaver.workflow.workflow.WorkFlowFieldTransMethod.getLabelnameForBill\" />"+                                   
												 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"fieldname\" />"+                              
                                                 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(17997,user.getLanguage())+"\" column=\"viewtype\"  transmethod=\"weaver.workflow.workflow.WorkFlowFieldTransMethod.getFieldTableType\" />"+
                                                 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(687,user.getLanguage())+"\" column=\"fieldhtmltype\" orderkey=\"fieldhtmltype\" transmethod=\"weaver.workflow.workflow.WorkFlowFieldTransMethod.getFieldViewType\" />"+
                                               	 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(686,user.getLanguage())+"\" column=\"type\" otherpara=\"column:fieldhtmltype+column:id+"+user.getLanguage()+"\" transmethod=\"weaver.general.FormFieldTransMethod.getFieldType\" />"+
                                               	 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(73,user.getLanguage())+"\" column=\"fromUser\"  orderkey=\"fromUser\"  transmethod=\"weaver.workflow.workflow.WorkFlowFieldTransMethod.getIsAddByUser\" />"+                                               	 
                                  				 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dsporder\"  orderkey=\"dsporder\" />"+  
                                             	 "			</head>"+              
                                                 "</table>";                         
                         %>                          
                         <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
                      </td>
                    </tr>
                  </TABLE>
		<form id="frmmain" name="frmmain" method="post" action="BillManagementFieldOperation0.jsp">
			<input id="actionType" name="actionType" type="hidden">
			<input id="fieldIds" name="fieldIds" type="hidden">
			<input id="billId" name="billId" type="hidden" value="<%=billId%>">
			<input id="isbill" name="isbill" type="hidden" value="<%=isbill%>">
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_BILLMANAGEMENTDETAIL0 %>"/>
		</form>
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
<body>
</html>
<script language="javascript">

function addNewFieldDialog(type,fieldid){
	var title = "";
	var url = "";
	if(type==1){
		title = "<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%>";
		url="/workflow/selectItem/selectItemMain.jsp?topage=BillManagementFieldAdd0&type=1&isbill=1&billId=<%=billId%>";
	}else{
		title = "<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%>";
		url="/workflow/selectItem/selectItemMain.jsp?topage=BillManagementFieldAdd0&type=0&isbill=1&fieldid="+fieldid+"&billId=<%=billId%>";
	}
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 1020;
	diag_vote.Height = 580;
	diag_vote.maxiumnable = true;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}


function OnMultiSubmit(){
	 if(_xtable_CheckedCheckboxId()==""){
     	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
     	return false;
     }
	 top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		document.frmmain.actionType.value='delete';
		document.frmmain.fieldIds.value=_xtable_CheckedCheckboxId();
		document.frmmain.submit();
     }, function () {}, 320, 90,true);	
}

function addformtabretun(){
	//window.parent.parent.location ="/workflow/form/manageformTab.jsp?ajax=1";
	window.parent.location = "/workflow/form/addDefineSysForm.jsp?formid=<%=billId%>";
}
</script>
