
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<script language=javascript src="/js/weaver_wev8.js"></script>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(468,user.getLanguage())+SystemEnv.getHtmlLabelName(699,user.getLanguage());
String needfav ="";
String needhelp ="";
int billId = Util.getIntValue(request.getParameter("billId"),0) ;
int billNameId = Util.getIntValue(BillComInfo.getBillLabel(String.valueOf(billId)));
String billName = SystemEnv.getHtmlLabelName(billNameId,user.getLanguage());
titlename += " : " + billName ;

int errorcode=Util.getIntValue(Util.null2String(request.getParameter("errorcode")),0);

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int subCompanyId= -1;
int operatelevel=0;
if(detachable==1){
    RecordSet.executeSql("select subcompanyid from workflow_bill where id="+billId);
    if(RecordSet.next()){
        subCompanyId = Util.getIntValue(Util.null2String(RecordSet.getString("subcompanyid")),-1);
    }
    if(subCompanyId==-1) subCompanyId = user.getUserSubCompany1();
    
    operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"FormManage:All",subCompanyId);
}else{
    if(HrmUserVarify.checkUserRight("FormManage:All", user)) operatelevel=2;
}

%>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(17998,user.getLanguage())+",/workflow/workflow/BillManagementFieldAdd0.jsp?src=addfield&srcType=mainfield&billId="+billId+",_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:OnMultiSubmit(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	if(detachable==1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(18581,user.getLanguage())+",/workflow/workflow/BillRightManagent.jsp?billid="+billId+",_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	}
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/workflow/BillManagementList.jsp,_self}" ;
	//RCMenuHeight += RCMenuHeightStep ;
	
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

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
          <%if(errorcode==1){%>
          	<font color="red"><%=SystemEnv.getHtmlLabelName(22410,user.getLanguage())%>！</font>
          <%}else if(errorcode==2){%>
          	<font color="red"><%=SystemEnv.getHtmlLabelName(24311,user.getLanguage())%>！</font>
          <%}%>		
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
                          	tableString =" <table instanceid=\"billManagementDetailTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_BILLMANAGEMENTDETAIL,user.getUID())+"\" >"+
                                                 " <checkboxpopedom    popedompara=\"column:fromUser\" showmethod=\"weaver.workflow.workflow.WorkFlowFieldTransMethod.getCanCheckBox\" />"+
                                                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
                                                 "			<head>"+                                          
                                                 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15456,user.getLanguage())+"\" column=\"fieldlabel\"  otherpara=\""+user.getLanguage()+"+column:id+column:fromUser+"+billId+"+1\" transmethod=\"weaver.workflow.workflow.WorkFlowFieldTransMethod.getLabelnameForBill\" />"+                                     
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
		<form id="frmmain" name="frmmain" method="post" action="BillManagementFieldOperation.jsp">
		<input id="actionType" name="actionType" type="hidden">
		<input id="fieldIds" name="fieldIds" type="hidden">
		<input id="billId" name="billId" type="hidden" value="<%=billId%>">
		<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_BILLMANAGEMENTDETAIL %>"/>
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
</script>
