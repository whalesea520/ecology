
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<script language=javascript src="/js/weaver_wev8.js"></script>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20578,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>

</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<br>

<%

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable==1){  
        if(request.getParameter("subCompanyId")==null){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("WorkflowCodeSeq_subCompanyId")),-1);
        }else{
            subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
        }
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        session.setAttribute("WorkflowCodeSeq_subCompanyId",String.valueOf(subCompanyId));
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"StartCode:Maintenance",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("StartCode:Maintenance", user))
            operatelevel=2;
    }
    
	int workflowId=Util.getIntValue(request.getParameter("workflowId"),-1);
	int formId=Util.getIntValue(WorkflowComInfo.getFormId(""+workflowId),-1);
	String isBill=""+Util.getIntValue(WorkflowComInfo.getIsBill(""+workflowId),0);

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



<form name="formWorkflowCodeSeq" method="post" action="/workflow/workflow/WorkflowCodeSeq_right.jsp">

<input type=hidden name=subCompanyId value="<%=subCompanyId%>">

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


<%
    String sqlwhere="";
	if(operatelevel>-1){
		String workflowIdStr="";
		String workflow_baseSqlPart="(1=0)";
		int tempWorkflowId=-1;
		int tempFormId=-1;
		String tempIsBill="0";
		String tempWorkflowSeqAlone="0";
		List workflowIdList=new ArrayList();
		List no_WorkflowIdList=new ArrayList();
		RecordSet.executeSql("select flowId as workflowId,formId,isBill,workflowSeqAlone from workflow_code where struSeqAlone='1' and struSeqSelect in('1','2','3')   and isUse='1'");
		while(RecordSet.next()){
			tempWorkflowId=Util.getIntValue(RecordSet.getString("workflowId"),-1);
			tempFormId=Util.getIntValue(RecordSet.getString("formId"),-1);
			tempIsBill=""+Util.getIntValue(RecordSet.getString("isBill"),0);
			tempWorkflowSeqAlone=Util.null2String(RecordSet.getString("workflowSeqAlone"));
			if(tempWorkflowId>0&&tempWorkflowSeqAlone.equals("1")){
				workflowIdList.add(""+tempWorkflowId);
			}else if(tempFormId>0){
				workflow_baseSqlPart+=" or (formId ="+tempFormId+" and isBill='"+tempIsBill+"') ";
			}
		}
		RecordSet.executeSql("select flowId as workflowId from workflow_code where flowId>0 and workflowSeqAlone='1' and isUse='1'");
		while(RecordSet.next()){
			tempWorkflowId=Util.getIntValue(RecordSet.getString("workflowId"),-1);
			if(tempWorkflowId>0){
				no_WorkflowIdList.add(""+tempWorkflowId);
			}
		}

		RecordSet.executeSql("select * from workflow_base where isvalid=1 and ("+workflow_baseSqlPart+")");
		while(RecordSet.next()){
			tempWorkflowId=Util.getIntValue(RecordSet.getString("id"),-1);
			if(tempWorkflowId>0&&(no_WorkflowIdList.indexOf(""+tempWorkflowId)==-1)){
				workflowIdList.add(""+tempWorkflowId);
			}
		}

		for(int i=0;i<workflowIdList.size();i++){
			workflowIdStr+=","+Util.getIntValue((String)workflowIdList.get(i));
		}

		if(!workflowIdStr.equals("")){
			workflowIdStr=workflowIdStr.substring(1);
		}

		if(!workflowIdStr.equals("")){
			sqlwhere=" where id in("+workflowIdStr+") ";
		}else{
			sqlwhere=" where 1=2 ";
		}

%>

     <table class=viewform cellspacing=1  >
     	<COLGROUP>
        <col width="10%">
        <col width="20%">
        <col width="5">
        <col width="10%">
        <col width="20%">
        <col width="5%">
        <col width="10%">
        <col width="20">

        <tr class=header>
            <td>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
            <td class=field colspan=7>
			    <button class=browser onClick="onShowWorkFlowSerach('workFlowId','workflowspan')"></button>
			    <span id=workflowspan>
			    <%=WorkflowComInfo.getWorkflowname(""+workflowId)%>
			    </span>
			    <input name=workflowId type=hidden value=<%=workflowId%>>
			</td>
        </tr>
     </table>
<%
        if(workflowId>0){
%>
		    <iframe src="/workflow/workflow/WorkflowCodeSeqSet.jsp?subCompanyId=<%=subCompanyId%>&isFromSubCompanyTree=true&workflowId=<%=workflowId%>&formId=<%=formId%>&isBill=<%=isBill%>" ID="iframeWorkflowCodeSeq" name="iframeWorkflowCodeSeq" frameborder="0" style="width:100%;height:100%;border-right:0px solid #879293;border-bottom:0px solid #879293;border-left:0px solid #879293;padding:10px;padding-right:0" scrolling="auto"></iframe>
<%
        }
    }else{
%>
     <table class=viewform cellspacing=1  >
     	<COLGROUP>
     	<COL width="100%">
	        <TR class="Title">
	            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(22814,user.getLanguage())%></TH>
	        </TR>  
	        <TR><TD height="10"></TD></TR>
     </table>
<%
    }
%>

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

</form>
</body>
</html>


<script language="vbs">
Sub onShowWorkFlowSerach(inputname, spanname)
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=<%=xssUtil.put(sqlwhere)%>")
	temp=document.all(inputname).value
	
	If (Not IsEmpty(retValue)) Then
		If retValue(0) <> "0" Then
			document.all(spanname).innerHtml = retValue(1)
			document.all(inputname).value = retValue(0)

            document.formWorkflowCodeSeq.action="/workflow/workflow/WorkflowCodeSeq_right.jsp"
			document.formWorkflowCodeSeq.submit()

		Else 
			document.all(inputname).value = ""
			document.all(spanname).innerHtml = ""
			End If
	End If
End Sub
</script>