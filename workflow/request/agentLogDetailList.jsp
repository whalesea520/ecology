
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	</head>
	<%
	    if(!HrmUserVarify.checkUserRight("AgentLog:View", user)){
	        response.sendRedirect("/notice/noright.jsp");
	        return;
	    }
	    
	    String imagefilename = "/images/hdReport_wev8.gif";
	    String titlename =  SystemEnv.getHtmlLabelName(17723,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage());
	    String needfav ="1";
	    String needhelp ="";
	    
	    String workflowname = Util.null2String(request.getParameter("workflowname"));
	    String agentid = Util.null2String(request.getParameter("agentid"));
	    String beagentedid = Util.null2String(request.getParameter("beagentedid"));
	    String fromdate1 = Util.null2String(request.getParameter("fromdate1"));
	    String todate1 = Util.null2String(request.getParameter("todate1"));
	    String date1select = Util.null2String(request.getParameter("date1select"));
	    if("".equals(date1select))
	    	date1select = "0";
		if(!"0".equals(date1select) && !"6".equals(date1select)){
			fromdate1 = TimeUtil.getDateByOption(date1select, "0");
			todate1 = TimeUtil.getDateByOption(date1select, "1");
		}
	    String fromdate2 = Util.null2String(request.getParameter("fromdate2"));
	    String todate2 = Util.null2String(request.getParameter("todate2"));
	    String date2select = Util.null2String(request.getParameter("date2select"));
	    if("".equals(date2select))
	    	date2select = "0";
		if(!"0".equals(date2select) && !"6".equals(date2select)){
			fromdate2 = TimeUtil.getDateByOption(date2select, "0");
			todate2 = TimeUtil.getDateByOption(date2select, "1");
		}
	
	    String sqlwhere = " a.workflowid=b.id ";
	    if(!agentid.equals("")) sqlwhere += " and a.agenterid="+agentid;
	    if(!beagentedid.equals("")) sqlwhere += " and a.beagenterid="+beagentedid;
	    if(!fromdate1.equals("")) sqlwhere += " and a.operatordate>='"+fromdate1+"'";
	    if(!todate1.equals("")) sqlwhere += " and a.operatordate<='"+todate1+"'";
	    if(!fromdate2.equals("")) sqlwhere += " and (a.backDate>='"+fromdate2+"' or a.backDate is null or a.backDate = '')";
	    if(!todate2.equals("")) sqlwhere += " and (a.backDate<='"+todate2+"' or a.backDate is null or a.backDate = '')";
	    if(!workflowname.equals("")) sqlwhere += " and b.workflowname like '%"+workflowname+"%'";
	
	    String backfields = " 1 as ranking__,a.agenterid,a.beagenterid,a.operatordate,a.backDate,a.agenttype,b.workflowname ";
		String fromSQL = " workflow_agent a, workflow_base b";

	    String tableString = ""+
		"<table pageId=\"pageId\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_REQUEST_AGENTLOGDETAILLIST,user.getUID())+"\" tabletype=\"none\">"+
		"<sql backfields=\""+backfields+"\" showCountColumn=\"false\" sqlform=\""+Util.toHtmlForSplitPage(fromSQL)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlorderby=\"beagenterid\" sqlprimarykey=\"agenterid\" sqlsortway=\"asc\" />"+
		"<head>"+							 
				 "<col width=\"5%\" text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"ranking__\" />"+
				 "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(17565,user.getLanguage())+"\" column=\"beagenterid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename1\" />"+
				 "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(17566,user.getLanguage())+"\" column=\"agenterid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename1\" />"+
				 "<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(18104,user.getLanguage())+"\" column=\"workflowname\" />"+
				 "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(24116,user.getLanguage())+"\" column=\"operatordate\" />"+
				 "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(24117,user.getLanguage())+"\" column=\"backDate\" transmethod=\"weaver.workflow.request.AgentLog.getBackDateString\" otherpara=\"column:agenttype+"+SystemEnv.getHtmlLabelName(18661,user.getLanguage())+"\" />"+
		"</head>"+      
		"</table>";
	%>
	<body>

		<!-- start -->
		<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow" />
			<jsp:param name="navName" value="<%=titlename%>" />
		</jsp:include>

		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self}" ;
		    RCMenuHeight += RCMenuHeightStep ;
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/request/agentLogList.jsp,_self}" ;
		    RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button" class="e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" onClick="doSearch();" />
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div id="mainDiv">
			<FORM id=frmmain name=frmmain action=agentLogDetailList.jsp method=post>
				<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_REQUEST_AGENTLOGDETAILLIST %>" />
				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></wea:item>
						<wea:item attributes="{colspan:3}">
							<input style="width:30%;" class="inputstyle" type="text" id="workflowname" name="workflowname" value="<%=workflowname%>">
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></wea:item>
						<wea:item>
							<span id="agentnamespan"><%=ResourceComInfo.getResourcename(agentid)%></span>
							<input name="agentid" type=hidden value="<%=agentid%>">
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%></wea:item>
						<wea:item>
							<span id="beagentednamaspan"><%=ResourceComInfo.getResourcename(beagentedid)%></span>
							<input name="beagentedid" type=hidden value="<%=beagentedid%>">
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(24116,user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="date1select" selectValue='<%="6".equals(date1select)?"":date1select%>'>
								<input class=wuiDateSel type="hidden" name="fromdate1" value="<%=fromdate1%>">
								<input class=wuiDateSel type="hidden" name="todate1" value="<%=todate1%>">
							</span>
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(24117,user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="date2select" selectValue='<%="6".equals(date2select)?"":date2select%>'>
								<input class=wuiDateSel type="hidden" name="fromdate2" value="<%=fromdate2%>">
								<input class=wuiDateSel type="hidden" name="todate2" value="<%=todate2%>">
							</span>
						</wea:item>
					</wea:group>

					<wea:group context='<%=SystemEnv.getHtmlLabelNames("26241,83", user.getLanguage())%>'>
						<wea:item attributes="{'colspan':'full','isTableList':'true'}">

							<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />

						</wea:item>
					</wea:group>
				</wea:layout>

			</FORM>
		</div>

		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
		<!-- end -->

		</form>
	</body>
</html>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript">
    function doSearch(){
        frmmain.submit();
    }

    function searchDetail(beagenterid, agenterid) {
        frmmain.action="";
        frmmain.submit();
    }
</script>		    
