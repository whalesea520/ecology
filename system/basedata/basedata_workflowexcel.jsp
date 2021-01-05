
<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8"%>

<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet_tmp" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="weaver.general.*,weaver.hrm.*,java.util.*"%>
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="MainCCI" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCCI" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCCI" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="wfAddinOperateManager" class="weaver.workflow.workflow.WfAddinOperateManager" scope="page" />
<% 
response.setContentType("application/vnd.ms-excel;charset=UTF-8");
response.setHeader("Content-disposition", "attachment;filename=basedata_workflowexcel.xls");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
if(! HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%
boolean isOracle = false;
if(RecordSet.getDBType().equalsIgnoreCase("oracle")){
	isOracle = true;
}
int pagepos=Util.getIntValue(Util.null2String(request.getParameter("pagepos")),1);
String wfname=Util.fromScreen(request.getParameter("wfname"),user.getLanguage());
String wfid=Util.fromScreen(request.getParameter("wfid"),user.getLanguage());
%>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
TABLE {
	FONT-SIZE: 9pt; FONT-FAMILY: Verdana
}
TABLE.Shadow {
	border: #000000 ;
	width:100% ;
	height:100% ;
	BORDER-color:#ffffff;
	BORDER-TOP: 3px outset #ffffff;
	BORDER-RIGHT: 3px outset #000000;
	BORDER-BOTTOM: 3px outset #000000;
	BORDER-LEFT: 3px outset #ffffff;
	BACKGROUND-COLOR:#FFFFFF;
	table-layout:fixed;
}
TABLE.ListStyle {
	width:100% ;
	table-layout:fixed;
	BACKGROUND-COLOR: #FFFFFF ;
	BORDER-Spacing:1pt ; 
}

TABLE.ListStyle TR.Title TH {
	TEXT-ALIGN: left;
}
TABLE.ListStyle TR.Spacing {
	HEIGHT: 1px
}
TABLE.ListStyle TR.Header {
	COLOR: #003366; BACKGROUND-COLOR: #C8C8C8 ; HEIGHT: 30px ;BORDER-Spacing:1pt
}
TABLE.ListStyle TR.Header TD {
	COLOR: #003366;
	TEXT-ALIGN: left;
}
TABLE.ListStyle TR.Header TH {
	COLOR: #003366 ;
	TEXT-ALIGN: left
}

TABLE.ListStyle TR.DataDark {
	BACKGROUND-COLOR: #F7F7F7 ; HEIGHT: 22px ; BORDER-Spacing:1pt
}
TABLE.ListStyle TR.DataDark TD {
	PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
}

TABLE.ListStyle TR.DataLight {
	BACKGROUND-COLOR: #FFFFFF ; HEIGHT: 22px ; BORDER-Spacing:1pt 
}
TABLE.ListStyle TR.DataLight TD {
	PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
}
TABLE.ListStyle TR.Selected {
	BACKGROUND-COLOR: #EAEAEA ; HEIGHT: 22px ; BORDER-Spacing:1pt 
}
TABLE.ListStyle TR.Selected TD {
	PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
}
</style>
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
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">

<br>
<TABLE class=ListStyle cellspacing=1>
  <TR class=Header >
    <TH colspan="4"><%=SystemEnv.getHtmlLabelName(15069,user.getLanguage())%></TH>
  </TR>
</TABLE>

<TABLE class=ListStyle cellspacing=1>
  <TBODY>
<%
boolean islight=true ;
int countsize = 0;
int pagesizes = 0;
int currentpagestart = 0;
int currentpageend = 0;
String sql = "" ;    

String sqlWhere = "";

String wfids4excel = Util.null2String(request.getParameter("wfids4excel"));
if(!"".equals(wfids4excel)){
	wfids4excel = wfids4excel.substring(0, wfids4excel.length()-1);
	sqlWhere = " and id in ("+wfids4excel+") ";
}

if(RecordSet.getDBType().equals("oracle"))
{
	sql = "select * from workflow_base where isvalid='1' "+sqlWhere+" order by workflowtype,id";
}
else
{
	sql = "select *  from workflow_base "+
		  "	                 where isvalid = '1' "+sqlWhere+
		  "	                 order by workflowtype asc, id asc";
}
//out.println(sql);
String tmpsql="" ;
RecordSet.executeSql(sql);
while(RecordSet.next()){
    String workflowname=RecordSet.getString("workflowname");
    String workflowid=RecordSet.getString("id");
    String isbill=RecordSet.getString("isbill");
    String needmark=RecordSet.getString("needmark");
    String formid=RecordSet.getString("formid");
    String messageType=RecordSet.getString("messageType");
    
    //微信提醒(QC:98106)
    String smsAlertsType=RecordSet.getString("smsAlertsType");
    if("1".equals(messageType))messageType=smsAlertsType;
    
    String chatsType=RecordSet.getString("chatsType");
    String chatsAlertType=RecordSet.getString("chatsAlertType");
    boolean isendnode = "1".equals(chatsType)?true:false;
    if("1".equals(chatsType))chatsType=chatsAlertType;
    
    String notRemindifArchived=RecordSet.getString("notRemindifArchived");
  	//微信提醒(QC:98106)
    String multiSubmit=RecordSet.getString("multiSubmit");
    String defaultName=RecordSet.getString("defaultName");
    String docPath=RecordSet.getString("docPath");
    String helpdocid=RecordSet.getString("helpdocid");
%>
  <tr> 
    <TD>
    <TABLE class=ListStyle cellspacing=1>
    <colgroup>
    <col width="5%"><col width="10%">
    <col width="5%"><col width="10%">
    <col width="5%"><col width="5%">
    <col width="5%"><col width="5%">
    <col width="5%"><col width="5%">
    <col width="5%"><col width="5%">
	<col width="5%"><col width="10%">
	<col width="5%"><col width="10%">
    <tr class=Header>
        <td><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></td>
        <td class=field><b><%=workflowname%></b></td>
		<%      
		if(isbill.equals("0"))
		{
	    %>
        <td><%=SystemEnv.getHtmlLabelName(700,user.getLanguage())%></td>
        <td class=field><b><%=FormComInfo.getFormname(""+formid)%></b></td>
		<%      
		}
		else
		{
	        int labelid = Util.getIntValue(BillComInfo.getBillLabel(""+formid));
	    %>
        <td><%=SystemEnv.getHtmlLabelName(15590,user.getLanguage())%></td>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(labelid,user.getLanguage())%></b></td>

		<%      
		}       
		%>
        <td><%=SystemEnv.getHtmlLabelName(18167,user.getLanguage())%></td><!-- 模板选择 -->
		<%      
			int typeid = -1;
			int templateid = -1;
			String iscust = "";
			String mailMessageType = "";
			String isaffirmance = "";
			String isforwardrights = "";
			String isShowChart = "";
			String isModifyLog = "";
			String orderbytype = "";
			String wfdocpath = "";
			String wfdocpathspan = "";
			String wfdocowner = "";
			String wfdocownerspan = "";
			String candelacc = "";
			String docRightByOperator="";
			int docRightByHrmResource = -1;
			String ShowDelButtonByReject = "";
			int subCompanyId2 = -1 ;//add by wjy
			String wfdes="";
			String isSignDoc = "";
			String showDocTab = "";
			String isSignWorkflow = "";
			String showWorkflowTab = "";
			String isannexUpload = "";
			String annexmaincategory = "";
			String annexsubcategory= "";
			String annexseccategory= "";
			String annexdocPath = "";
			String showUploadTab = "";
			if(!workflowid.equals(""))
			{
				WFManager.setWfid(Util.getIntValue(workflowid,-1));
				WFManager.getWfInfo();
				wfname=WFManager.getWfname();
			    templateid=WFManager.getTemplateid();
			    isbill = WFManager.getIsBill();
			    typeid=WFManager.getTypeid();
			    iscust = WFManager.getIsCust();
			    mailMessageType=WFManager.getMailMessageType();
			    isaffirmance=WFManager.getIsaffirmance();
			    isforwardrights=WFManager.getIsforwardRights();
			    isShowChart = WFManager.getIsShowChart();
			    isModifyLog = WFManager.getIsModifyLog();
			    orderbytype = WFManager.getOrderbytype();
			    wfdocpath = WFManager.getWfdocpath();
			    if(wfdocpath!=null && !wfdocpath.equals("")){
			        String _temp1 = wfdocpath.substring(0,wfdocpath.indexOf(','));
			        String _temp2 = wfdocpath.substring(wfdocpath.indexOf(',')+1,wfdocpath.lastIndexOf(','));
			        String _temp3 = wfdocpath.substring(wfdocpath.lastIndexOf(',')+1,wfdocpath.length());
			        if(!_temp1.equals(""))
			        wfdocpathspan="/"+MainCCI.getMainCategoryname(_temp1)+"/"+SubCCI.getSubCategoryname(_temp2)+"/"+SecCCI.getSecCategoryname(_temp3);
			    }
			    wfdocowner = WFManager.getWfdocowner();
			    wfdocownerspan = ResourceComInfo.getLastname(wfdocowner);
			    candelacc = WFManager.getCanDelAcc();//是否允许创建人删除附件
			    docRightByOperator=WFManager.getDocRightByOperator();
			    docRightByHrmResource = WFManager.getDocRightByHrmResource();
			    ShowDelButtonByReject = WFManager.getShowDelButtonByReject();
			    subCompanyId2 = WFManager.getSubCompanyId2() ;//add by wjy
			    wfdes=WFManager.getWfdes();
			    isSignDoc=WFManager.getSignDoc();
			    showDocTab=WFManager.getShowDocTab();
			    isSignWorkflow=WFManager.getSignWorkflow();
			    showWorkflowTab=WFManager.getShowWorkflowTab();
			    isannexUpload=WFManager.getIsAnnexUpload();
			    String tempannexcategory=WFManager.getAnnexDocCategory();
			    if(tempannexcategory!=null && !tempannexcategory.equals("")){
			        annexmaincategory=tempannexcategory.substring(0,tempannexcategory.indexOf(','));
			        annexsubcategory=tempannexcategory.substring(tempannexcategory.indexOf(',')+1,tempannexcategory.lastIndexOf(','));
			        annexseccategory=tempannexcategory.substring(tempannexcategory.lastIndexOf(',')+1,tempannexcategory.length());
			        if(!annexmaincategory.equals(""))
			        annexdocPath="/"+MainCCI.getMainCategoryname(annexmaincategory)+"/"+SubCCI.getSubCategoryname(annexsubcategory)+"/"+SecCCI.getSecCategoryname(annexseccategory);
			    }
			    showUploadTab=WFManager.getShowUploadTab();
			    String templatename = "";
			    if(templateid>0)
			    {
			        WFManager.reset();
			        WFManager.setWfid(templateid);
			    	WFManager.getWfInfo();
			    	templatename=WFManager.getWfname();
			    }

			    tempannexcategory=WFManager.getDocCategory();
			    if(tempannexcategory!=null && !tempannexcategory.equals("")){
			        annexmaincategory=tempannexcategory.substring(0,tempannexcategory.indexOf(','));
			        annexsubcategory=tempannexcategory.substring(tempannexcategory.indexOf(',')+1,tempannexcategory.lastIndexOf(','));
			        annexseccategory=tempannexcategory.substring(tempannexcategory.lastIndexOf(',')+1,tempannexcategory.length());
			        if(!annexmaincategory.equals(""))
			        	docPath="/"+MainCCI.getMainCategoryname(annexmaincategory)+"/"+SubCCI.getSubCategoryname(annexsubcategory)+"/"+SecCCI.getSecCategoryname(annexseccategory);
			    }
		%>
        <td class=field><b><%=templatename%></b></td>
		<%      
			}
		%>
        <td><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td><!-- 工作流类型 -->
        <td class=field><b><%=WorkTypeComInfo.getWorkTypename(""+typeid)%></b></td>
        <td><%=SystemEnv.getHtmlLabelName(15588,user.getLanguage())%></td><!-- 是否门户相关 -->
		<%      
		if(iscust.equals("0"))
		{
		%>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(15589,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
		%>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%></b></td>
		<%      
		}       
		%>
        <td><%=SystemEnv.getHtmlLabelName(31486,user.getLanguage())%></td><!-- 是否默认说明 -->
		<%      
		if(defaultName.equals("1"))
		{
		%>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
		%>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}       
		
		%>
         <td colspan="2">
           <table  width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
              <tr class=Header>
                 <td><%=SystemEnv.getHtmlLabelName(31487,user.getLanguage())%></td>
                 <td class=field>
                   <!-- 是否短信提醒 -->
					<%      
					if(messageType.equals("0"))
					{
					%>
			        <b><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%></b>
					<% }else if(messageType.equals("1")){
			    	%>  
			        <b><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%></b>
					<%}else{ %>
					 <b><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%></b>
					<%}%>
				</td>
              </tr>
              <tr class=Header>
                 <td><%=SystemEnv.getHtmlLabelName(31488,user.getLanguage())%></td>
                 <td class=field>
                   <!-- 是否邮件提醒 -->
					<%      
					if(mailMessageType.equals("1"))
					{
					%>
			        <b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b>
					<%      
					}
					else
					{
			    	%>  
			        <b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b>
					<%      
					}       
					%>
				 </td>
              </tr>
           </table>
        </td>
		<td colspan="2">
		   <table  width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		       <tr class=Header>
                 <td>
                    <%=SystemEnv.getHtmlLabelName(32809,user.getLanguage())%>
                 </td>
                  <td>
                     <!-- 是否微信提醒 -->
						<%      
						if(chatsType.equals("1"))
						{
						%>
				            <b><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%></b>
						<%      
						}
						else
						{
				    	%>  
				          <b><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%></b>
						<%      
						}       
						%>
                  </td>
                 </tr>
                 <%if(isendnode){ %>
                 <tr class=Header>
                   <td >
                      <%=SystemEnv.getHtmlLabelName(32810,user.getLanguage())%>
                   </td>
                   <td class=field>
                       <%if(notRemindifArchived != null && "1".equals(notRemindifArchived) ){ %>
                             <b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b>
                       <%}else{ %>
                             <b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b>
                       <%}%>
                   </td>
                 </tr>
                 <% }%>
		   </table>
		</td>
    </tr>
    <tr class=Header>
         <td><%=SystemEnv.getHtmlLabelName(31489,user.getLanguage())%></td><!-- 是否需要确认 -->
		<%      
		if(isaffirmance.equals("1"))
		{
		%>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
		%>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}       
		%> 
        <td><%=SystemEnv.getHtmlLabelName(31490,user.getLanguage())%></td><!-- 提交流程后是否显示流程图 -->
		<%      
		if(isShowChart.equals("1"))
		{
        %>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
		%>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}       
		%>		  
		 <td><%=SystemEnv.getHtmlLabelName(31491,user.getLanguage())%></td><!-- 是否批量提交 -->
		<%      
		if(multiSubmit.equals("1"))
		{
    	%>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
    	%>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}       
		%>

        <td><%=SystemEnv.getHtmlLabelName(31492,user.getLanguage())%></td><!-- 是否允许转发人设置被转发人权限 -->
		<%      
		if(isforwardrights.equals("1"))
		{
		%>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
		%>
		<td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}
		%>
        <td><%=SystemEnv.getHtmlLabelName(31493,user.getLanguage())%></td><!-- 是否记录表单修改日志 -->
		<%      
		if(isModifyLog.equals("1"))
		{
        %>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
        %>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}       
		%>
        <td><%=SystemEnv.getHtmlLabelName(21603,user.getLanguage())%></td><!-- 流程审批意见显示模式 -->
		<%      
		if(orderbytype.equals("1"))
		{
        %>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(21604,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
        %>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(21605,user.getLanguage())%></b></td>
		<%      
		}       
		%>
        <td><%=SystemEnv.getHtmlLabelName(22220,user.getLanguage())%></td><!-- 流程保存为文档的存放路径 -->
        <td class=field><b><%=wfdocpathspan%></b></td>
        <td class=field><%=SystemEnv.getHtmlLabelName(22221,user.getLanguage())%></td><!-- 流程保存为文档的所有者 -->
        <td class=field><b><%=wfdocownerspan%></b></td>
    </tr>
    <tr class=Header>
        <td><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())%></td><!-- 附件上传目录 -->
        <td class=field><b><%=docPath%></b></td>
        <td><%=SystemEnv.getHtmlLabelName(22944,user.getLanguage())%></td><!-- 是否允许创建人删除附件 -->
		<%
		if(candelacc.equals("1"))
		{
		%>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
		%>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}       
		%>
        <td><%=SystemEnv.getHtmlLabelName(31495,user.getLanguage())%></td><!-- 是否跟随文档关联人赋权 -->
		<%      
		if(docRightByOperator.equals("1"))
		{
		%>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
		%>
		<td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}
		%>
        <td><%=SystemEnv.getHtmlLabelName(19321,user.getLanguage())%></td><!-- 按人力资源条件字段赋权 -->
		<%      
		if(docRightByHrmResource==1)
		{
        %>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
		%>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}       
		%>
        <td><%=SystemEnv.getHtmlLabelName(31496,user.getLanguage())%></td><!-- 退回创建节点是否可删除 -->
		<%      
		if(ShowDelButtonByReject.equals("1"))
		{
        %>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
        %>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}       
		%>
        <td class=field><%=SystemEnv.getHtmlLabelName(15593,user.getLanguage())%></td><!-- 帮助文档 -->
        <td class=field><b><%=Util.toScreen(DocComInfo.getDocname(""+helpdocid),user.getLanguage())%></b></td>
        <td class=field><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></td><!-- 所属机构 -->
        <td class=field><b><%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subCompanyId2))%></b></td>
        <td class=field><%=SystemEnv.getHtmlLabelName(15594,user.getLanguage())%></td><!-- 工作流描述 -->
        <td class=field><b><%=wfdes%></b></td>
    </tr>
    <tr class=Header>
        <td><%=SystemEnv.getHtmlLabelName(23726,user.getLanguage())%></td><!-- 是否允许签字意见关联文档 -->
        <%
		if(isSignDoc.equals("1"))
		{
		%>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
		%>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}       
		%>
        <td><%=SystemEnv.getHtmlLabelName(23728,user.getLanguage())%></td><!-- 是否显示相关文档选项卡 -->
		<%
		if(showDocTab.equals("1"))
		{
		%>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
		%>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}       
		%>
        <td><%=SystemEnv.getHtmlLabelName(23727,user.getLanguage())%></td><!-- 是否允许签字意见关联流程 -->
		<%      
		if(isSignWorkflow.equals("1"))
		{
		%>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
		%>
		<td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}
		%>
        <td><%=SystemEnv.getHtmlLabelName(23729,user.getLanguage())%></td><!-- 是否显示相关流程选项卡 -->
		<%      
		if(showWorkflowTab.equals("1"))
		{
        %>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
		%>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}       
		%>
        <td><%=SystemEnv.getHtmlLabelName(21417,user.getLanguage())%></td><!-- 是否允许签字意见上传附件 -->
		<%      
		if(isannexUpload.equals("1"))
		{
        %>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
        %>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}       
		%>
        <td class=field><%=SystemEnv.getHtmlLabelName(21418,user.getLanguage())%></td><!-- 签字意见附件上传目录 -->
        <td class=field><b><%=annexdocPath%></b></td>
        <td><%=SystemEnv.getHtmlLabelName(23725,user.getLanguage())%></td><!-- 是否显示相关附件选项卡 -->
        <%      
		if(showUploadTab.equals("1"))
		{
        %>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
        %>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}       
		%>
		<%
		  String status= "";
		  String frequencyt= "";
		  String dateType= "";
		  String timeSet= "";
		  String dateSum= "";
		  String alertType= "";
		  RecordSet2.execute("select * from WorkFlowPlanSet where flowid="+workflowid);
		  if(RecordSet2.next())
		  {
			  status=RecordSet2.getString("status");
			  frequencyt=RecordSet2.getString("frequencyt");
			  dateType=RecordSet2.getString("dateType");
			  timeSet=RecordSet2.getString("timeSet");
			  dateSum=RecordSet2.getString("dateSum");
			  alertType=RecordSet2.getString("alertType");
		  }
		  %>
        <td class=field><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18812,user.getLanguage())%></td><!-- 启用流程计划  -->
        <%      
		if(status.equals("0"))
		{
        %>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
        %>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}       
		%>
    </tr>
    <tr class=Header>
        <td><%=SystemEnv.getHtmlLabelName(15592,user.getLanguage())%></td><!-- 是否编号 -->
        <%
		if(needmark.equals("1"))
		{
		%>
        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
		<%      
		}
		else
		{
		%>  
        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
		<%      
		}       
		%>
        <td class=field></td>
        <td class=field></td>
        <td class=field></td>
        <td class=field></td>
        <td class=field></td>
        <td class=field></td>
        <td class=field></td>
        <td class=field></td>
        <td class=field></td>
        <td class=field></td>
        <td class=field></td>
        <td class=field></td>
        <td class=field></td>
        <td class=field></td>
    </tr>
    </table>

	<TABLE class=ListStyle cellspacing=1>
        <colgroup>
        <col width="7%">
        <col width="7%">
        <col width="28%">
        <col width="14%">
        <col width="14%">
        <col width="5%">
        <col width="5%">
        <tr class=header>
            <td colSpan="8"><%=SystemEnv.getHtmlLabelName(15615,user.getLanguage())%></td><!-- 节点信息 -->
        </tr>
        <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%>)</td><!-- 节点名称(节点类型) -->
            <td><%=SystemEnv.getHtmlLabelName(15072,user.getLanguage())%></td><!-- 操作组 -->
            <td><%=SystemEnv.getHtmlLabelName(15073,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>)</td><!-- 操作组定义 --><!-- 批次条件 -->
            <td><%=SystemEnv.getHtmlLabelName(18009,user.getLanguage())%></td><!-- 节点前附加操作 -->
            <td><%=SystemEnv.getHtmlLabelName(18010,user.getLanguage())%></td><!-- 节点后附加操作 -->
            <td><%=SystemEnv.getHtmlLabelName(18359,user.getLanguage())%></td><!-- 强制收回 -->
            <td><%=SystemEnv.getHtmlLabelName(18360,user.getLanguage())%></td><!-- 强制归档 -->
        </tr>
		<tr class=header>
            <td colSpan="7"><%=SystemEnv.getHtmlLabelName(21393,user.getLanguage())%></td><!-- 节点属性-->
        </tr>
        <%
        boolean changeclass = false;
		String sv = "";
		String dv = "";
		String zc = "";
		String mc = "";
		String fw = "";
		String rb = "";
		String ov = "";
		
		RecordSet2.executeSql("select * from workflow_function_manage where workflowid = " + workflowid + " and operatortype = -1");
		if(RecordSet2.next()){
			sv = RecordSet2.getString("typeview");
			dv = RecordSet2.getString("dataview");
			zc = RecordSet2.getString("automatism");
			mc = RecordSet2.getString("manual");
			fw = RecordSet2.getString("transmit");
			rb = RecordSet2.getString("retract");
			ov = RecordSet2.getString("pigeonhole");
		}
		String trclass = changeclass?"DataDark":"DataLight";
        changeclass = changeclass?false:true;
		%>
		<tr class=<%=trclass %>>
            <td  height="23"><%=SystemEnv.getHtmlLabelName(16758,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <%      
			if(rb.equals("1"))
			{
			%>  
	        <td class=field><%=SystemEnv.getHtmlLabelName(18365,user.getLanguage())%></td>
			<%      
			}
			else if(rb.equals("2"))
			{
			%>  
	        <td class=field><%=SystemEnv.getHtmlLabelName(18366,user.getLanguage())%></td>
			<%      
			}
			else
			{
			%>
			<td class=field><%=SystemEnv.getHtmlLabelName(18364,user.getLanguage())%></td>
			<%
			}
			%>
            <%      
			if(ov.equals("1"))
			{
	        %>
	        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
			<%      
			}
			else
			{
	        %>  
	        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
			<%      
			}       
			%>
        </tr>
<%
        ArrayList nodeids=new ArrayList () ;
        ArrayList nodenames=new ArrayList () ;
        ArrayList nodetypes=new ArrayList();
        tmpsql="select w1.nodeid,w2.nodename,w1.nodetype from workflow_flownode w1,workflow_nodebase w2 where (w2.IsFreeNode is null or w2.IsFreeNode!='1') and w1.nodeid=w2.id and w1.workflowid="+ workflowid +" order by w1.nodeid " ;
        rs.executeSql(tmpsql) ;
        while(rs.next()){
            String nodeid=rs.getString("nodeid");
            nodeids.add(nodeid) ;
            nodenames.add(rs.getString("nodename"));
            nodetypes.add(rs.getString("nodetype"));
        }
        
        for(int i=0; i<nodeids.size() ;i++){
            String nodeid = Util.null2String((String) nodeids.get(i));
            String nodename = Util.null2String((String) nodenames.get(i));
            trclass = changeclass?"DataDark":"DataLight";
            changeclass = changeclass?false:true;
            String nodetype = Util.null2String((String) nodetypes.get(i));
            String nodetypeStr = "";
            if("0".equals(nodetype)){
            	nodetype = SystemEnv.getHtmlLabelName(125,user.getLanguage());
            }else if("1".equals(nodetype)){
            	nodetype = SystemEnv.getHtmlLabelName(142,user.getLanguage());
            }else if("2".equals(nodetype)){
            	nodetype = SystemEnv.getHtmlLabelName(615,user.getLanguage());
            }else if("3".equals(nodetype)){
            	nodetype = SystemEnv.getHtmlLabelName(251,user.getLanguage());
            }
%>
		<tr class=<%=trclass %>>
			<td><%=nodename%>&nbsp;(<%=nodetype%>)</td>
<%
            ArrayList groupids=new ArrayList() ;
            ArrayList groupnames=new ArrayList() ;
            String groupname="" ;
            String groupdesc="" ;
            tmpsql="select id,groupname from workflow_nodegroup where nodeid="+nodeid;
            rs.executeSql(tmpsql) ;

            while(rs.next()){
                groupids.add(rs.getString("id")) ;
                groupnames.add(rs.getString("groupname")) ;
            }
		%>
		<td colspan="2">
		<table class="viewform" style="width:100%;height:100%">
		<colgroup>
        <col width="20%">
        <col width="80%">
		<%
            for(int j=0; j<groupids.size(); j++){
            	String bottomStyle = "";
            	if(j<(groupids.size()-1)){
            		bottomStyle = "border-bottom:1px solid #C1DAD7;";
            	}
                groupname=(String)groupnames.get(j);
				out.println("<tr>\n");
				out.println("<td style=\"border-right:1px solid #C1DAD7;"+bottomStyle+"\">"+groupname+"</td>\n");
                String tmpgroupid=(String) groupids.get(j);
                tmpsql="select * from workflow_groupdetail where groupid="+tmpgroupid ;
                rs.executeSql(tmpsql);
                String tmpdesc="" ;
                groupdesc = "";
                while(rs.next()){
                    int type=rs.getInt("type") ;
                    String objid=rs.getString("objid") ;
                    int detailid=rs.getInt("id") ;
                    int level=rs.getInt("level_n");
                    int level2_n=rs.getInt("level2_n");
                    String signorder=rs.getString("signorder");
                    String conditioncn = Util.null2String(rs.getString("conditioncn"));
                    String nodename2 = "";
								    int nodeidindex = nodeids.indexOf(""+objid);
								    if( nodeidindex != -1 ) nodename2 = (String) nodenames.get(nodeidindex);
								    
					String tmpName="";
					String tmpCase2Rolesmark="";
					int bhxj = Util.getIntValue(Util.null2String(rs.getString("bhxj")),0);			    
                    switch(type){
                        //部门 + 安全级别   某一部门安全级别大于等于设定值的人力资源
                        case 1:
                        case 22:
                        	 tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(124,user.getLanguage()) +"-"+DepartmentComInfo.getDepartmentname(objid);
                             if(bhxj == 1)
                             	tmpdesc += "&nbsp;["+SystemEnv.getHtmlLabelName(125943,user.getLanguage())+"]";
                             break;
                        case 2:
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(122,user.getLanguage()) +"-";                            
                            /*原始逻辑 如果流程节点操作者为角色时搜索结果显示角色说明而非角色名称
                            tmpdesc+="<a href='basedata_role.jsp?roleid="+objid+"'>"+RolesComInfo.getRolesname(""+objid)+"</a>-";
                            */
                            RecordSet_tmp.executeSql("select rolesmark from hrmroles where id = "+objid);
                            if(RecordSet_tmp.next()){
                            	tmpCase2Rolesmark=RecordSet_tmp.getString("rolesmark");
                            }else{
                            	tmpCase2Rolesmark=RolesComInfo.getRolesname(""+objid);
                            }
                            tmpdesc+="<a href='basedata_role.jsp?roleid="+objid+"'>"+tmpCase2Rolesmark+"</a>-";
                            
                            if(level==0) tmpdesc+= SystemEnv.getHtmlLabelName(124,user.getLanguage()) ;
                            if(level==1) tmpdesc+= SystemEnv.getHtmlLabelName(141,user.getLanguage()) ;
                            if(level==2) tmpdesc+= SystemEnv.getHtmlLabelName(140,user.getLanguage()) ;
                            break;
                        case 3:
                        	tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(179,user.getLanguage()) +"-"; 
                        	//人力资源缓存 不好使，部分人员根据id获取不到。本次先查询一下，后续缓存类好使了在缓存缓存获取
							RecordSet4.executeSql(" select lastname,id from  hrmresource where   id in(select objid from Workflow_HrmOperator where groupdetailid='"+detailid+"' ) ");	
							while(RecordSet4.next()){
							 String lastname=Util.null2String(RecordSet4.getString("lastname"));
                              tmpdesc+="  "+lastname;
							}
                            break;
                        case 5:
                        case 6:
                        case 7:
                        case 31:
                        case 32:
                        case 38:
                        case 42:
                        case 51:
                        	tmpdesc+=";&nbsp;";
                        	if(type == 5)
                            	tmpdesc+=SystemEnv.getHtmlLabelName(15555,user.getLanguage());
                        	else if(type == 6)
                        		tmpdesc+=SystemEnv.getHtmlLabelName(15559,user.getLanguage());
                        	else if(type == 7)
                        		tmpdesc+=SystemEnv.getHtmlLabelName(15562,user.getLanguage());
                        	else if(type == 31)
                        		tmpdesc+=SystemEnv.getHtmlLabelName(15560,user.getLanguage());
                        	else if(type == 32)
                        		tmpdesc+=SystemEnv.getHtmlLabelName(15561,user.getLanguage());
                        	else if(type == 38)
                        		tmpdesc+=SystemEnv.getHtmlLabelName(15563,user.getLanguage());
                        	else if(type == 42)
                        		tmpdesc+=SystemEnv.getHtmlLabelName(124,user.getLanguage());
                        	else if(type == 51)
                        		tmpdesc+=SystemEnv.getHtmlLabelName(141,user.getLanguage());
							                            if(isbill.equals("0")){
							                            	sql = " select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name,0 viewtype,0 groupid from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid + " and workflow_formdict.id = " + objid;      
							                            	sql += " union all ";
							                            	sql += " SELECT workflow_formdictdetail.id AS id,workflow_fieldlable.fieldlable AS name,1 viewtype,workflow_formfield.groupId + 1 FROM workflow_formdictdetail,workflow_formfield,workflow_fieldlable WHERE workflow_fieldlable.isdefault = 1 AND workflow_fieldlable.formid = workflow_formfield.formid AND workflow_fieldlable.fieldid = workflow_formfield.fieldid AND workflow_formfield.fieldid = workflow_formdictdetail.id AND workflow_formfield.isdetail = '1' AND workflow_formfield.formid = " + formid + " and workflow_formdictdetail.id = " + objid;
							                            }else{
							                            	sql = " select id as id , fieldlabel as name,0 viewtype,0 groupid from workflow_billfield where billid="+ formid+ " and viewtype = 0 and id = " + objid;
							                            	sql += " union all";
							                            	sql += " select a.id, fieldlabel as name,1 viewtype,b.orderid groupid from workflow_billfield a,Workflow_billdetailtable b where a.billid = b.billid and a.detailtable = b.tablename and a.billid="+ formid+ " and viewtype = 1 and a.id = " + objid;
							                            }
														RecordSet2.execute(sql);
														RecordSet2.next();
														
														String viewtype = RecordSet2.getString("viewtype");
												  		String groupid = RecordSet2.getString("groupid");
												  		String name = "";
												  		if(isbill.equals("0")) 
												  			tmpName = RecordSet2.getString("name");
												  		else
												  			tmpName = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
												  		if("1".equals(viewtype))
												  			tmpName += "（" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + groupid + "）";
														tmpdesc+=","+tmpName;
                            break;
                        case 8:
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15564,user.getLanguage());
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 9 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=9 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 9:
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15566,user.getLanguage());
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 9 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=9 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 10:
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15567,user.getLanguage());
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 8 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=8 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 11:
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15569,user.getLanguage());
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 8 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=8 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 12:
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15570,user.getLanguage());
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 8 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=8 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 13:
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15571,user.getLanguage());
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 23 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=23 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 14:
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15573,user.getLanguage());
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 23 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=23 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 15:
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15574,user.getLanguage());
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 7 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=7 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 16:
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15575,user.getLanguage());
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 7 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=7 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 23:
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15555,user.getLanguage());
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 1 or workflow_formdict.type=17) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=1 or type=17) " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 24:
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15555,user.getLanguage());
													  if(isbill.equals("0"))
														  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 7 or workflow_formdict.type = 18 ) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
														  " and workflow_formdict.id = "+objid+" ";
													  else
														  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=7 " +
														  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 25:
                        		tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15581,user.getLanguage());
                            break;
                        case 20:
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(1282,user.getLanguage()) +"-" ;
                            tmpdesc+= CustomerTypeComInfo.getCustomerTypename(""+objid) ;
                            break;
                        case 21:
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15078,user.getLanguage()) +"-" ;
                            tmpdesc+= CustomerStatusComInfo.getCustomerStatusname(""+objid) ;
                            break;
                        case 4 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(1340,user.getLanguage());
                            break;
                        case 17 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15079,user.getLanguage())  ;
                            break;
                        case 18 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15080,user.getLanguage())  ;
                            break;
                        case 19 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15081,user.getLanguage());
                            break;
                        case 30 :
                        	 tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(141,user.getLanguage()) ;
                             tmpdesc+= SubCompanyComInfo.getSubCompanyname(""+objid) ;
                             if(bhxj == 1)
                             	tmpdesc += "&nbsp;["+SystemEnv.getHtmlLabelName(84674,user.getLanguage())+"]";
                             break;
                        case 33 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15565,user.getLanguage()) ;
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 9 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=9 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 34 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15568,user.getLanguage()) ;
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 8 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=8 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 35 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15572,user.getLanguage()) ;
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 23 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=23 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 36 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15576,user.getLanguage()) ;
                            break;
                        case 37 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15577,user.getLanguage()) ;
                            break;
                        case 39 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(15578,user.getLanguage()) ;
                            break;
                        case 40 :
                            tmpdesc+=";&nbsp;"+SystemEnv.getHtmlLabelName(18676,user.getLanguage());// "节点操作者本人"
                            tmpdesc+=","+ nodename2 ;
                            break;
                        case 41 :
                            tmpdesc+=";&nbsp;"+SystemEnv.getHtmlLabelName(18677,user.getLanguage());// "节点操作者经理"
                            tmpdesc+=","+ nodename2 ;
                            break;
                        case 43 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(122,user.getLanguage());
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 65 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";      // 多角色
													  else
													  	sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=65 " +
														  " and id = "+objid+" ";
													  RecordSet2.executeSql(sql);
													  RecordSet2.next();
														if(isbill.equals("0")){
															tmpName=RecordSet2.getString("name");
														}else{
															tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
														}
														tmpdesc+=","+tmpName;
                            break;
                        case 44 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(17204,user.getLanguage());// "客户字段经理的经理"
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 7 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=7 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 45 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(18678,user.getLanguage());// "客户字段分部"
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 7 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=7 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 46 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(18679,user.getLanguage());//"客户字段部门" 
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 7 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=7 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 47 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(18680,user.getLanguage()); //"项目字段经理的经理" 
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 8 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=8 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                        case 48 :
                            tmpdesc+=";&nbsp;"+ SystemEnv.getHtmlLabelName(18681,user.getLanguage()); //"会议室的管理员"
														if(isbill.equals("0"))
															sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 87 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" "+
															  " and workflow_formdict.id = "+objid+" ";
														else
															sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=87 " +
															  " and id = "+objid+" ";
                            RecordSet2.execute(sql);
                            RecordSet2.next();
							if(isbill.equals("0")){
								tmpName=RecordSet2.getString("name");
							}else{
								tmpName=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage());
							}
							tmpdesc+=","+tmpName;
                            break;
                    }
                    //安全级别
                    switch (type){
                    case 1:
                    case 4:
                    case 7:
                    case 9:
                    case 11:
                    case 12:
                    case 14:
                    case 19:
                    case 20:
                    case 21:
                    case 22:
                    case 23:
                    case 25:
                    case 30:
                    case 31:
                    case 32:
                    case 33:
                    case 34:
                    case 35:
                    case 36:
                    case 37:
                    case 38:
                    case 39:
                    case 45:
                    case 46:
                    case 51:
                    
	                    if(level2_n!=-1){
	                        tmpdesc+=","+ SystemEnv.getHtmlLabelName(683,user.getLanguage()) + level +"-" + level2_n;// "安全级别 "
	                    }else{
	                        tmpdesc+=","+ SystemEnv.getHtmlLabelName(683,user.getLanguage()) + level;// "安全级别 "
	                    }
	                    break;

                    case 5:
                    case 42:
                    case 43:
                    	/*//原始取操作组定义会签属性的逻辑
	                    if(level==0){
	                        tmpdesc+=","+SystemEnv.getHtmlLabelName(15585,user.getLanguage());
	                    }else if(level==1){
	                        tmpdesc+=","+SystemEnv.getHtmlLabelName(15557,user.getLanguage());
	                    }else{
	                        tmpdesc+=","+SystemEnv.getHtmlLabelName(15558,user.getLanguage());
	                    }
	                    */
	                  	//参照editoperatorgroup.jsp修改的取操作组定义会签属性的逻辑
                    	if("0".equals(signorder)){
                    		tmpdesc+=","+SystemEnv.getHtmlLabelName(15556,user.getLanguage());
                    	} else if("1".equals(signorder)){
                    		tmpdesc+=","+SystemEnv.getHtmlLabelName(15557,user.getLanguage());
                    	}else if("2".equals(signorder)){
                    		tmpdesc+=","+SystemEnv.getHtmlLabelName(15558,user.getLanguage());
                    	}else if("3".equals(signorder)){
                    		tmpdesc+=","+SystemEnv.getHtmlLabelName(21227,user.getLanguage());
                    	}else if("4".equals(signorder)){
                    		tmpdesc+=","+SystemEnv.getHtmlLabelName(21228,user.getLanguage());
                    	}
	                    break;
                    }
                    if(!"".equals(conditioncn)){
	                    tmpdesc += "["+SystemEnv.getHtmlLabelName(17892,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage())+":"+conditioncn+"]";
                    }
                    if(!"".equals(tmpdesc)){
	                    tmpdesc = tmpdesc + "&nbsp;";
                    }
                }
                
                if(!tmpdesc.equals(""))   tmpdesc=tmpdesc.substring(1) ;
                if(!"".equals(tmpdesc))
                {
                	groupdesc += ""+tmpdesc+"" ;
                }
                out.println("<td style=\"word-break:break-all;word-wrap:break-word;"+bottomStyle+"\">"+groupdesc+"</td>\n");
                out.println("</tr>\n");
                out.println("<tr class=\"Line\" ><td class=\"Line\" colSpan=\"2\"></td></tr>\n");
          }
%>
	</table>
	</td>
<%          
            //对nodeid找节点前后附加操作
            String preaddStr = "";
			String addStr = "";
			Hashtable reths = wfAddinOperateManager.getAddinOperateStr(Util.getIntValue(nodeid), 0, 1, user, formid, isbill, Util.getIntValue(workflowid));
			preaddStr = Util.null2String((String)reths.get("preaddStr"));
			addStr = Util.null2String((String)reths.get("addStr"));
%>          
            <td style="word-break:break-all;word-wrap:break-word"><%=preaddStr%>&nbsp;</td>
            <td style="word-break:break-all;word-wrap:break-word"><%=addStr%>&nbsp;</td>
            <%
			sv = "";
			dv = "";
			zc = "";
			mc = "";
			fw = "";
			rb = "";
			ov = "";
			
			RecordSet2.executeSql("select * from workflow_function_manage where workflowid = " + workflowid + " and operatortype = " + nodeid);
			
			if(RecordSet2.next()){
				sv = RecordSet2.getString("typeview");
				dv = RecordSet2.getString("dataview");
				zc = RecordSet2.getString("automatism");
				mc = RecordSet2.getString("manual");
				fw = RecordSet2.getString("transmit");
				rb = RecordSet2.getString("retract");
				ov = RecordSet2.getString("pigeonhole");
			}
			%>
            <%      
			if(rb.equals("1"))
			{
			%>  
	        <td class=field><%=SystemEnv.getHtmlLabelName(18365,user.getLanguage())%></td>
			<%      
			}
			else if(rb.equals("2"))
			{
			%>  
	        <td class=field><%=SystemEnv.getHtmlLabelName(18366,user.getLanguage())%></td>
			<%      
			}
			else
			{
			%>
			<td class=field><%=SystemEnv.getHtmlLabelName(18364,user.getLanguage())%></td>
			<%
			}
			%>
            <%      
			if(ov.equals("1"))
			{
	        %>
	        <td class=field><b><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></b></td>
			<%      
			}
			else
			{
	        %>  
	        <td class=field><b><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></b></td>
			<%      
			}       
			%>
		</tr>
		<tr class="<%=trclass%>">
			<%
				String nodeAttrStr = wfAddinOperateManager.getNodeattr(Util.getIntValue(nodeid), user);
			%>
			<td colspan="7" style="word-break:break-all;word-wrap:break-word">&nbsp;<%=nodeAttrStr%></td>
		</tr>
<%
            
        }
%>
    </table>
<!-- 出口信息 Start -->
	<TABLE class=ListStyle cellspacing=1>
		<colgroup>
		<col width="25%">
		<col width="25%">
		<col width="25%">
		<col width="13%">
		<col width="12%">
		<tr class=header>
			<td colSpan="5"><%=SystemEnv.getHtmlLabelName(15606,user.getLanguage())%></td><!-- 出口信息 -->
		</tr>
		<tr class="header">
			<td><%=SystemEnv.getHtmlLabelName(15611,user.getLanguage())%></td><!-- 出口名称 -->
			<td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td><!-- 节点名称 -->
			<td><%=SystemEnv.getHtmlLabelName(15074,user.getLanguage())%></td><!-- 目标节点 -->
			<td><%=SystemEnv.getHtmlLabelName(15075,user.getLanguage())%></td><!-- 是否退回 -->
			<td><%=SystemEnv.getHtmlLabelName(20576,user.getLanguage())%></td><!-- 生成编号 -->
		</tr>
		<tr class="header">
			<td colspan="2"><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td><!-- 出口条件 -->
			<td colspan="3"><%=SystemEnv.getHtmlLabelName(15610,user.getLanguage())%></td><!-- 附加规则 -->
		</tr>
		<%
			changeclass = false;
			sql = "select * from workflow_nodelink n where workflowid="+workflowid+" and exists(select b1.id from workflow_nodebase b1 where b1.id=n.nodeid and (b1.IsFreeNode is null or b1.IsFreeNode!='1')) and exists(select b2.id from workflow_nodebase b2 where b2.id=n.destnodeid and (b2.IsFreeNode is null or b2.IsFreeNode!='1')) order by id";
			rs.execute(sql);
			while(rs.next()){
				int linkid = Util.getIntValue(rs.getString("id"));
				int nodeid = Util.getIntValue(rs.getString("nodeid"));
				String nodename_t = "";
				if(nodeids.indexOf(""+nodeid) > -1){
					nodename_t = Util.null2String((String)nodenames.get(nodeids.indexOf(""+nodeid)));
				}
				int destnodeid = Util.getIntValue(rs.getString("destnodeid"));
				String destnodename_t = "";
				if(nodeids.indexOf(""+destnodeid) > -1){
					destnodename_t = Util.null2String((String)nodenames.get(nodeids.indexOf(""+destnodeid)));
				}
				String linkname = Util.null2String(rs.getString("linkname"));
				int isreject = Util.getIntValue(rs.getString("isreject"));
				String isrejectStr = "";
				if(isreject == 1){
					isrejectStr = SystemEnv.getHtmlLabelName(163,user.getLanguage());
				}else{
					isrejectStr = SystemEnv.getHtmlLabelName(161,user.getLanguage());
				}
				int isbulidcode = Util.getIntValue(rs.getString("isbulidcode"));
				String isbulidcodeStr = "";
				if(isbulidcode == 1){
					isbulidcodeStr = SystemEnv.getHtmlLabelName(163,user.getLanguage());
				}else{
					isbulidcodeStr = SystemEnv.getHtmlLabelName(161,user.getLanguage());
				}
				trclass = changeclass?"DataDark":"DataLight";
		        changeclass = changeclass?false:true;
		        String conditioncn = "";
				if(isOracle == true){
					conditioncn = wfAddinOperateManager.getLinkConditioncn(linkid);
				}else{
					conditioncn = Util.null2String(rs.getString("conditioncn"));
				}
				Hashtable reths = wfAddinOperateManager.getAddinOperateStr(0, linkid, 0, user, formid, isbill, Util.getIntValue(workflowid));
				String linkaddStr = Util.null2String((String)reths.get("addStr"));
				out.println("<tr class=\""+trclass+"\">\n");
				out.println("<td>"+linkname+"</td>\n");
				out.println("<td>"+nodename_t+"</td>\n");
				out.println("<td>"+destnodename_t+"</td>\n");
				out.println("<td>"+isrejectStr+"</td>\n");
				out.println("<td>"+isbulidcodeStr+"</td>\n");
				out.println("</tr>\n");

				out.println("<tr class=\""+trclass+"\">\n");
				out.println("<td colspan=\"2\" style=\"word-break:break-all;word-wrap:break-word\">&nbsp;"+conditioncn+"</td>\n");
				out.println("<td colspan=\"3\" style=\"word-break:break-all;word-wrap:break-word\">&nbsp;"+linkaddStr+"</td>\n");
				out.println("</tr>\n");
			}
		%>
	</TABLE>

<!-- 出口信息 End -->
    <TABLE class=ListStyle cellspacing=1>
        <colgroup>
        <col width="30%">
        <col width="20%">
        <col width="20%">
        <col width="30%">
        <tr class=header>
            <td colSpan=4><%=SystemEnv.getHtmlLabelName(21220,user.getLanguage())%></td><!-- 督办设置 -->
        </tr>
        <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
        </tr>
        <%
		ArrayList ids = new ArrayList();
		ArrayList names = new ArrayList();
		ids.clear();
		names.clear();
		
		if(isbill.equals("0"))
		  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		else
		  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " " ;
		//out.println(sql);
		RecordSet2.executeSql(sql);
		while(RecordSet2.next()){
			ids.add(RecordSet2.getString("id"));
		    if(isbill.equals("0")) names.add(Util.null2String(RecordSet2.getString("name")));
			else names.add(SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet2.getString("name")),user.getLanguage()));
		}


		//the record in db
		int colorcount=0;
		RecordSet2.executeSql("select * from workflow_urgerdetail where workflowid="+workflowid+" order by id");
		
		String oldids="-1";
		while(RecordSet2.next()){
			int detailid = RecordSet2.getInt("id");
			int type = RecordSet2.getInt("utype");
			int objid = RecordSet2.getInt("objid");
			int level = RecordSet2.getInt("level_n");
			int level2 = RecordSet2.getInt("level2_n");
		
		    String conditions=RecordSet2.getString("conditions");
		    String conditioncn=RecordSet2.getString("conditioncn");
			oldids=oldids+","+detailid;
		if(colorcount==0)
		{
			colorcount=1;
		%>
		<TR class=DataLight>
		<%
		}
		else
		{
			colorcount=0;
		%>
		<TR class=DataDark>
		<%
		}
		%>
			<td height="23">
			<%
			if(type==1)
			{%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><%}
			if(type==2)
				{%><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%> <%}
			if(type==3)
				{%><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <%}
			if(type==4)
				{%><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%> <%}
			if(type==5)
				{%><%=SystemEnv.getHtmlLabelName(15555,user.getLanguage())%> <%}
			if(type==6)
				{%><%=SystemEnv.getHtmlLabelName(15559,user.getLanguage())%> <%}
			if(type==7)
				{%><%=SystemEnv.getHtmlLabelName(15562,user.getLanguage())%> <%}
			if(type==8)
				{%><%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%> <%}
			if(type==9)
				{%><%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%> <%}
			if(type==10)
				{%><%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%> <%}
			if(type==11)
				{%><%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%> <%}
			if(type==12)
				{%><%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%> <%}
			if(type==13)
				{%><%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%> <%}
			if(type==14)
				{%><%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%> <%}
			if(type==15)
				{%><%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%> <%}
			if(type==16)
				{%><%=SystemEnv.getHtmlLabelName(15575,user.getLanguage())%> <%}
			if(type==17)
				{%><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%> <%}
			if(type==18)
				{%><%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%> <%}
			if(type==19)
				{%><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%> <%}
			if(type==20)
				{%><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%> <%}
			if(type==21)
				{%><%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%> <%}
			if(type==22)
				{%><%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%> <%}
			if(type==23)
				{%><%=SystemEnv.getHtmlLabelName(2113,user.getLanguage())%> <%}
			if(type==24)
				{%><%=SystemEnv.getHtmlLabelName(15580,user.getLanguage())%> <%}
			if(type==25)
				{%><%=SystemEnv.getHtmlLabelName(15581,user.getLanguage())%> <%}
			if(type==30)
			    {%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%> <%}
			if(type==31)
				{%><%=SystemEnv.getHtmlLabelName(15560,user.getLanguage())%> <%}
			if(type==32)
				{%><%=SystemEnv.getHtmlLabelName(15561,user.getLanguage())%> <%}
			if(type==33)
				{%><%=SystemEnv.getHtmlLabelName(15565,user.getLanguage())%> <%}
			if(type==34)
				{%><%=SystemEnv.getHtmlLabelName(15568,user.getLanguage())%> <%}
			if(type==35)
				{%><%=SystemEnv.getHtmlLabelName(15572,user.getLanguage())%> <%}
			if(type==36)
				{%><%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%> <%}
			if(type==37)
				{%><%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%> <%}
			if(type==38)
				{%><%=SystemEnv.getHtmlLabelName(15563,user.getLanguage())%> <%}
			if(type==39)
				{%><%=SystemEnv.getHtmlLabelName(15578,user.getLanguage())%> <%}
			if(type==40)
				{%><%=SystemEnv.getHtmlLabelName(18676,user.getLanguage())%> <%}
			if(type==41)
				{%><%=SystemEnv.getHtmlLabelName(18677,user.getLanguage())%> <%}
			if(type==42)
				{%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> <%}
			if(type==43)
				{%><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%> <%}
			if(type==44)
				{%><%=SystemEnv.getHtmlLabelName(17204,user.getLanguage())%> <%}
			if(type==45)
				{%><%=SystemEnv.getHtmlLabelName(18678,user.getLanguage())%> <%}
			if(type==46)
				{%><%=SystemEnv.getHtmlLabelName(18679,user.getLanguage())%><%}
			if(type==47)
				{%><%=SystemEnv.getHtmlLabelName(18680,user.getLanguage())%> <%}
			if(type==48)
				{%><%=SystemEnv.getHtmlLabelName(18681,user.getLanguage())%> <%}
			if(type==49)
				{%><%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%> <%}
			if(type==50)
				{%><%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%> <%}
			%>
			</td>
			<td  height="23">
			<%
				switch (type){
					case 1:
					case 22:
					%>
					<%=DepartmentComInfo.getDepartmentname(""+objid)%>
					<%
					break;
					case 2:
					RecordSet1.executeSql("select rolesmark from hrmroles where id = "+objid);
					RecordSet1.next();
					%>
					<%=RecordSet1.getString(1)%>
					<%
					break;
					case 3:
					
					%>
					<%=ResourceComInfo.getResourcename(""+objid)%>
					<%
					break;
					case 5:
					case 49:
					case 6:
					case 7:
					case 8:
					case 9:
					case 10:
					case 11:
					case 12:
					case 13:
					case 14:
					case 15:
					case 16:
					case 23:
					case 24:
					case 31:
					case 32:
					case 33:
					case 34:
					case 35:
					case 38:
					case 42:
					case 43:
					case 44:
					case 45:
					case 46:
					case 47:
					case 48:
						int index=ids.indexOf(""+objid);
						if(index!=-1){
					%>
					<%=names.get(index)%>
					<%	}
					break;
					case 20:
					%>
					<%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(""+objid),user.getLanguage())%>
					<%
					break;
					case 21:
					%>
					<%=Util.toScreen(CustomerStatusComInfo.getCustomerStatusname(""+objid),user.getLanguage())%>
					<%
					break;
					case 30:
					%>
					<%=SubCompanyComInfo.getSubCompanyname(""+objid)%>
					<%
					break;
					case 50:
					int indexs=ids.indexOf(""+objid);
					//System.out.print(indexs);
					if(indexs!=-1){
					%>
					<%=names.get(indexs)%>/
					<%	}%>
					<%=RolesComInfo.getRolesname(""+level)%>
						<%
					break;
				}
			%>
			</td>
			<td height="23">
			<%
				switch (type){
					case 1:
					case 4:
					case 7:
					case 9:
					case 11:
					case 12:
					case 14:
					case 19:
					case 20:
					case 21:
					case 22:
					case 23:
					case 25:
					case 30:
					case 31:
					case 32:
					case 33:
					case 34:
					case 35:
					case 36:
					case 37:
					case 38:
					case 39:
					case 45:
					case 46:
					case 42:
					%>
					<%if(level2!=-1){%>
					<%=level%>-<%=level2%>
					<%}else{%>
					>=<%=level%>
					<%}%>
					<%
					break;
					case 2:
					 if(level==0){%>
					<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
					<%}else if(level==1){%>
					<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
					<%}else if(level==2){%>
					<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
					<%}
					break;
				}%>
			</td>
			<td><%=conditioncn%></td>
		</tr>
		<%} %>
   	</TABLE>
    </TD>
  </TR>
  <tr><td height=10></td></tr>
<%  
    }
%>  
    </tbody>
    </table>
			
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