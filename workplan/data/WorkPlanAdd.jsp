
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="resource" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="customer" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="project" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="workflow" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="doc" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="requestInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
	<STYLE>
		.vis1	{ visibility:"visible" }
		.vis2	{ visibility:"hidden" }
	</STYLE>
</HEAD>

<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	Calendar cal = Calendar.getInstance();

	//String planType = Util.null2String(request.getParameter("plantype"));
	String resourceID = Util.null2String(request.getParameter("resourceid"));
	String beginDate = Util.null2String(request.getParameter("begindate"));
	String beginTime = Util.null2String(request.getParameter("begintime"));
	String crmID = Util.null2String(request.getParameter("crmid"));
	String docID = Util.null2String(request.getParameter("docid"));
	String projectID = Util.null2String(request.getParameter("projectid"));
	String from = Util.null2String(request.getParameter("from"));
	
	String url = "WorkPlanEdit.jsp";
	if(request.getQueryString() != null){
		url += "?"+request.getQueryString();
	}
	if(url != null){
		response.sendRedirect(url) ;
		return;
	}
	
	
	String requestID = "";

	if("".equals(resourceID))
	{
		resourceID = String.valueOf(user.getUID());	//默认为当前登录用户
	}
	if("".equals(beginDate))
	{
		beginDate = Util.add0(cal.get(Calendar.YEAR), 4) + "-" + 
        Util.add0(cal.get(Calendar.MONTH) + 1, 2) + "-" +
        Util.add0(cal.get(Calendar.DAY_OF_MONTH), 2);
	}
	int userid=user.getUID();
	String logintype = user.getLogintype();
	String hrmid = Util.null2String(request.getParameter("hrmid"));
%>

<!--============================= 标题栏 =============================-->
<%
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage()) + ":&nbsp;"
					 + SystemEnv.getHtmlLabelName(2211,user.getLanguage());
	String needfav = "";
	String needhelp = "";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<BODY onbeforeunload="protectLeave()">
<!--============================= 右键菜单开始 =============================-->
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM name="frmmain" action="/workplan/data/WorkPlanOperation.jsp" method="post" target="_parent">
	<INPUT type="hidden" name="method" value="add">
	<INPUT type="hidden" name="from" value="<%=from%>">
  	
  	<TABLE class="ViewForm">
		<COLGROUP>
			<COL width="20%">
			<COL width="80%">
		<TBODY>		
		
		<!--================ 日程类型 ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></TD>
		  	<TD class="Field">
		  	<%
		  		if("".equals(crmID))
		  		{
		  	%>
		  		<SELECT name="workPlanType">
	  			<%
		  			rs.executeSql("SELECT * FROM WorkPlanType" + Constants.WorkPlan_Type_Query_By_Menu);
		  			while(rs.next())
		  			{
		  		%>
		  			<OPTION value="<%= rs.getInt("workPlanTypeID") %>"><%=Util.forHtml(rs.getString("workPlanTypeName")) %></OPTION>
		  		<%
		  			}
		  		%>
		  		</SELECT>
		  	<%
		  		}
		  		else
		  		{
		  	%>
		  		<SELECT name="" disabled>
	  			<%
		  			rs.executeSql("SELECT * FROM WorkPlanType WHERE workPlanTypeId = 3");
		  			while(rs.next())
		  			{
		  		%>
		  			<OPTION value="<%= rs.getInt("workPlanTypeID") %>" selected><%= rs.getString("workPlanTypeName") %></OPTION>
		  		<%
		  			}
		  		%>
		  		</SELECT>
		  		<INPUT type=hidden name="workPlanType" value="<%= rs.getInt("workPlanTypeID") %>">
		  	<%
		  		}
		  	%>
		  	</TD>
		</TR>
		<TR style="height:1px">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		
		<!--================ 标题  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
		  	<TD class="Field">
		  		<INPUT class="InputStyle" maxlength="100" size="30" name="planName" onchange="checkinput('planName','nameImage')">
		  		<SPAN id="nameImage"><IMG src="/images/BacoError_wev8.gif" align="absMiddle"></SPAN>
		  	</TD>
		</TR>
		<TR style="height:1px">
			<TD class="Line" colSpan="2" ></TD>
		</TR>
				
		<!--================ 考核项  ================-->
		<!-- TR>
			<TD><%//=SystemEnv.getHtmlLabelName(18064,user.getLanguage())%></TD>
		  	<TD class="Field">
		  		<SELECT name="hrmPerformanceCheckDetailID">
		  			<OPTION value="-1"></OPTION>
		  		<%
		  			//rs.executeSql("SELECT * FROM HrmPerformanceCheckDetail a WHERE NOT EXISTS(SELECT * FROM HrmPerformanceCheckDetail b WHERE a.ID = b.parentID) ORDER BY dePath");
		  			//while(rs.next())
		  			//{
		  		%>
		  			<OPTION value="<%//= rs.getInt("ID") %>"><%//= rs.getString("targetName") %></OPTION>
		  		<%
		  			//}
		  		%>
		  		</SELECT>
		  	</TD>
		</TR>
		<TR style="height:1px">
			<TD class="Line" colSpan="2"></TD>
		</TR -->
		
		<!--================ 紧急程度  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></TD>
			<TD class="Field">
				<INPUT type="radio" value="1" name="urgentLevel" checked><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>
			    &nbsp;&nbsp;
				<INPUT type="radio" value="2" name="urgentLevel"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
				&nbsp;&nbsp;
				<INPUT type="radio" value="3" name="urgentLevel"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
			</TD>
		</TR>
		<TR style="height:1px">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		
		<!--================ 日程提醒方式  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(19781,user.getLanguage())%></TD>
			<TD class="Field">
				<INPUT type="radio" value="1" name="remindType" onclick=showRemindTime(this) checked><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
				<INPUT type="radio" value="2" name="remindType" onclick=showRemindTime(this)><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
				<INPUT type="radio" value="3" name="remindType" onclick=showRemindTime(this)><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
			</TD>
		</TR>
		<TR style="height:1px">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		
		<!--================ 日程提醒时间  ================-->
		<TR id="remindTime" style="display:none">
			<TD><%=SystemEnv.getHtmlLabelName(19783,user.getLanguage())%></TD>
			<TD class="Field">
				<INPUT type="checkbox" name="remindBeforeStart" value="1">
					<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="remindDateBeforeStart"   onchange="checkint('remindDateBeforeStart')" size=5 value="0">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="remindTimeBeforeStart"   onchange="checkint('remindTimeBeforeStart')" size=5 value="10">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
					&nbsp&nbsp&nbsp
				<INPUT type="checkbox" name="remindBeforeEnd" value="1">
					<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="remindDateBeforeEnd" onchange="checkint('remindDateBeforeEnd')" size=5 value="0">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="remindTimeBeforeEnd" onchange="checkint('remindTimeBeforeEnd')"  size=5 value="10">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			</TD>
		</TR>
		<TR id="remindTimeLine"  style="display:none;height:1px;" >
			<TD class="Line" colSpan="2" style="padding:0;"></TD>
		</TR>
		<TR id="reminddesc" style="display:none;">
			<TD></TD>
			<TD class="Field"><%=SystemEnv.getHtmlLabelName(24155,user.getLanguage())%></TD>
		</TR>
		<TR id="remindTimeLine1" style="display:none;height:1px;" >
			<TD class="Line" colSpan="2"  style="padding:0;"></TD>
		</TR>
		
		<!--================ 接收人  ================-->				
		<TR>
		  	<td><%=SystemEnv.getHtmlLabelName(896,user.getLanguage())%></td>
		  	<TD class="Field">
		  	<%
		  		if (!user.getLogintype().equals("2")) 
		  		{
		  	%>
			      <input class=wuiBrowser type=hidden name="memberIDs" _required="yes" value=<%if("".equals(hrmid))out.print(userid);else out.print(userid+","+hrmid);%>
			      _param="resourceids"  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" _displayText="<%=user.getUsername()%>" 
			      _displayTemplate="<a href=/hrm/resource/HrmResource.jsp?#b{id}' target='_blank'>#b{name}</a>&nbsp;"
			      >
			      </td>
			    </tr>
			<%
				}
		  		else 
		  		{
		  	%>
				<SPAN id="agentIDspan">
					<A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=user.getUID()%>" target='_blank'>
						<%=user.getUsername()%>
					</A>
				</SPAN>
	            <INPUT type="hidden" name="agentID" value="<%=user.getUID()%>">
			<%
				}
			%>
			</TD>
		</TR>
		<TR style="height:1px"><TD class="Line" colSpan="2"></TD></TR>
		
		<!--================ 开始时间  ================-->	
		<TR>          
			<TD>
				<%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%>
			</TD>
			<TD class="Field">
				<INPUT class=wuiDate type="hidden" name="beginDate" value="<%=beginDate%>">  
				<SPAN id="selectBeginDateSpan">
				<%
					if (beginDate.equals("")) 
					{
				%>
					<IMG src="/images/BacoError_wev8.gif" align="absMiddle">
				<%
					} 
					else 
					{
				%>
					<%}%>
				</SPAN> 
				&nbsp;&nbsp;&nbsp;
				<BUTTON type="button" class="Clock" id="selectBeginTime" onclick="onshowPlanTime(beginTime,selectBeginTimeSpan)"></BUTTON>
				<SPAN id="selectBeginTimeSpan">
				
				</SPAN>
				<INPUT type="hidden" name="beginTime">
			</TD>
		</TR>
		<TR style="height:1px">
			<TD class="Line" colSpan="2"></TD>
		</TR>

		<!--================ 结束时间  ================-->
		<TR>
		  	<TD>
		  		<%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%>
		  	</TD>
		  	<TD class="Field">
			  	<INPUT class=wuiDate type="hidden" name="endDate">  
				<SPAN id="endDateSpan"></SPAN> 
			  	&nbsp;&nbsp;&nbsp;
			  	<BUTTON type="button" class="Clock" id="selectEndTime" onclick="onshowPlanTime(endTime,endTimeSpan)"></BUTTON>
			  	<SPAN id="endTimeSpan"></SPAN>
			  	<INPUT type="hidden" name="endTime">
			</TD>
		</TR>
		<TR style="height:1px">
			<TD class="Line" colSpan="2"></TD>
		</TR> 
	
		<!--================ 内容  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></TD>
		  	<TD class="Field">
		  		<TEXTAREA class="InputStyle" name="description" rows="5" style="width:98%" onchange="checkinput('description','descriptionImage')"></TEXTAREA><SPAN id="descriptionImage"><IMG src="/images/BacoError_wev8.gif" align="absMiddle"></SPAN>
	      	</TD>
		</TR>
		<TR style="height:1px"><TD class="Line" colSpan="2"></TD></TR> 
<%if(isgoveproj==0){%>

		<!--================ 相关客户  ================-->
	 	<TR>
			<TD><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></TD>
		  	<TD class="Field">
				<INPUT class=wuiBrowser type="hidden" name="crmIDs" value="<%=crmID%>"
				_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp" 
				_displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?#b{id}' target='_blank'>#b{name}</A>&nbsp;">
				<SPAN id="crmSpan">
				<%
					if(!crmID.equals("")) 
					{
				%>
					<A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=crmID%>" target='_blank'>
					<%=Util.toScreen(customer.getCustomerInfoname(crmID),user.getLanguage())%></A>
				<%
					}
				%>
				</SPAN> 
		  	</TD>
		</TR>		
		<TR style="height:1px">
			<TD class="Line" colSpan="2"></TD>
		</TR> 
		<%}%>
		<!--================ 相关文档  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
		  	<TD class="Field">
		  		<INPUT class=wuiBrowser type="hidden" name="docIDs" value="<%=docID%>"
		  		_url="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp"
		  		_displayTemplate="<A href='/docs/docs/DocDsp.jsp?#b{id}' target='_blank'>#b{name}</A>&nbsp;">
		  		<SPAN id="docSpan">
		  		<%
		  			if(!docID.equals("")) 
		  			{
		  		%>
					<A href="/docs/docs/DocDsp.jsp?id=<%=docID%>" target='_blank'>
						<%=Util.toScreen(doc.getDocname(docID),user.getLanguage())%>
					</A>
				<%
					}
				%>
				</SPAN>
		  	</TD>
		</TR>
		<TR style="height:1px">
			<TD class="Line" colSpan="2"></TD>
		</TR> 
		<%if(isgoveproj==0){%>

		<!--================ 相关项目  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></TD>
		 	<TD class="Field">
				<INPUT class=wuiBrowser type="hidden" name="projectIDs" value="<%=projectID%>"
				_url="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp"
				_displayTemplate="<A href='/proj/data/ViewProject.jsp?ProjID=#b{id}' target='_blank'>#b{name}</A>&nbsp;">
				<SPAN id="projectSpan">
				<%
					if(!projectID.equals("")) 
					{
				%>
					<A href="/proj/data/ViewProject.jsp?ProjID=<%=projectID%>" target='_blank'>
						<%=Util.toScreen(project.getProjectInfoname(projectID),user.getLanguage())%></A><%}%>
				</SPAN>
			</TD>
		</TR>
		<TR style="height:1px">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		<%}%>
		<!--================ 相关流程  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></TD>
		 	<TD class="Field">
				<INPUT class=wuiBrowser type="hidden" name="requestIDs"  value="<%=requestID%>"
				_url="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp"
				_displayTemplate="<A href='/workflow/request/ViewRequest.jsp?#b{id}' target='_blank'>#b{name}</A>&nbsp;">
				<SPAN id="requestSpan">
				<%
					if(!requestID.equals("")) 
					{
				%>
					<A href="/workflow/request/ViewRequest.jsp?requestID=<%=requestID%>" target='_blank'>
						<%=Util.toScreen(requestInfo.getRequestname(requestID),user.getLanguage())%>
					</A>
				<%
					}
				%>
				</SPAN>
			</TD>
		</TR>
		<TR style="height:1px">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		</TBODY>
  	</TABLE>
</FORM>

</BODY>
</HTML>


<SCRIPT language="JavaScript">

function clear(dates,e){
	var target = e.srcElement||e.target;
	$("#"+$(target).attr("id")+"Span").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
}

function doSave(obj) 
{	
	if (check_form(frmmain,"planName,memberIDs,beginDate,description") && checkWorkPlanRemind()) 
	{
		if (!checkOrderValid("beginDate", "endDate")) 
		{
			alert("<%=SystemEnv.getHtmlNoteName(54,user.getLanguage())%>");
			return;
		}

        //td1976 判断是否只为空格和回车
        var dd=$GetEle("description").value;
	    dd=dd.replace(/^[ \t\n\r]+/g, "");
	    dd=dd.replace(/[ \t\n\r]+$/g, "");

	    if (dd=="") 
	    {
            alert('<%=SystemEnv.getHtmlLabelNames("33368,82241",user.getLanguage())%>');
            return;
        }

		var dateStart = $GetEle("beginDate").value;
		var dateEnd = $GetEle("endDate").value;

		if (dateStart == dateEnd && !checkOrderValid("beginTime", "endTime")) 
		{
			alert("<%=SystemEnv.getHtmlNoteName(55,user.getLanguage())%>");
			return;
		}
		obj.disabled = true ;
		document.body.onbeforeunload = null;//by cyril on 2008-06-24 for TD:8828
		document.frmmain.submit();	
	}
}

function goBack() 
{
	document.location.href = "/workplan/data/WorkPlanView.jsp";
}

function onNeedRemind() 
{
	if ($GetEle("needremind").checked) 
	{
        $GetEle("remindspan").className = "vis1";
    }
    else 
    {
        $GetEle("remindspan").className = "vis2";
    }
}

function showRemindTime(obj)
{
	if("1" == obj.value)
	{
		$GetEle("remindTime").style.display = "none";
		$GetEle("remindTimeLine").style.display = "none";
		$GetEle("reminddesc").style.display = "none";
		$GetEle("remindTimeLine1").style.display = "none";
	}
	else
	{
		$GetEle("remindTime").style.display = "";
		$GetEle("remindTimeLine").style.display = "";
		$GetEle("reminddesc").style.display = "";
		$GetEle("remindTimeLine1").style.display = "";
	}
}

function checkWorkPlanRemind()
{
	if(false == document.frmmain.remindType[0].checked)
	{
		if(document.frmmain.remindBeforeStart.checked || document.frmmain.remindBeforeEnd.checked)
		{
			return true;			
		}
		else
		{
			alert("<%=SystemEnv.getHtmlLabelName(20238,user.getLanguage())%>");
			return false;
		}
	}
	else
	{
		document.frmmain.remindBeforeStart.checked = false;
		document.frmmain.remindBeforeEnd.checked = false;
		document.frmmain.remindTimeBeforeStart.value = 10;
		document.frmmain.remindTimeBeforeEnd.value = 10;
		
		return true;		
	}
}
function protectLeave(){
	if(!checkDataChange())//added by cyril on 2008-06-12 for TD:8828
		event.returnValue="<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
}
</SCRIPT>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="JavaScript" src="/js/OrderValidator_wev8.js"></SCRIPT>
<!-- added by cyril on 2008-06-12 for td8828-->
<script language=javascript src="/js/checkData_wev8.js"></script>
<!-- end by cyril on 2008-06-12 for td8828-->