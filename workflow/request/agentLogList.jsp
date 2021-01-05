
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

	    String sqlwhere = " 1=1 ";
	    if(!agentid.equals("")) sqlwhere += " AND agenterid="+agentid;
	    if(!beagentedid.equals("")) sqlwhere += " AND beagenterid="+beagentedid;
	    if(!fromdate1.equals("")) sqlwhere += " AND operatordate>='"+fromdate1+"'";
	    if(!todate1.equals("")) sqlwhere += " AND operatordate<='"+todate1+"'";
	    if(!fromdate2.equals("")) sqlwhere += " AND backDate>='"+fromdate2+"'";
	    if(!todate2.equals("")) sqlwhere += " AND backDate<='"+todate2+"'";

	    String backfields = " 1 as ranking__,beagenterid,agenterid,count ";
		String fromSQL = " (SELECT COUNT(*) AS count,beagenterid,agenterid FROM workflow_agent WHERE " + sqlwhere + " GROUP BY beagenterid,agenterid) t";

	    String tableString = ""+
		"<table pageId=\"pageId\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_REQUEST_AGENTLOGLIST,user.getUID())+"\" tabletype=\"none\">"+
		"<sql backfields=\""+backfields+"\" showCountColumn=\"false\" sqlform=\""+Util.toHtmlForSplitPage(fromSQL)+"\" sqlorderby=\"beagenterid\" sqlprimarykey=\"agenterid\" sqlsortway=\"asc\" />"+
		"<head>"+							 
				 "<col width=\"5%\" text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"ranking__\" />"+
				 "<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(17565,user.getLanguage())+"\" column=\"beagenterid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename1\" />"+
				 "<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(17566,user.getLanguage())+"\" column=\"agenterid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename1\" />"+
				 "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(16851,user.getLanguage())+"\" column=\"count\" />"+
				 "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(320,user.getLanguage())+"\" column=\"beagenterid\" transmethod=\"weaver.workflow.request.AgentLog.getDetailListLink\" otherpara=\"column:agenterid+"+SystemEnv.getHtmlLabelName(320, user.getLanguage())+"\" />"+
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
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/request/wfAgentStatistic.jsp,_self}" ;
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
			<FORM id=frmmain name=frmmain action=agentLogList.jsp method=post>
				<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_REQUEST_AGENTLOGLIST %>" />
				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="agentid"
								browserValue='<%=agentid%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="/data.jsp"
								browserDialogWidth="600px"
								browserSpanValue='<%=ResourceComInfo.getLastname(agentid)%>'></brow:browser>
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="beagentedid"
								browserValue='<%=beagentedid%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="/data.jsp"
								browserDialogWidth="600px"
								browserSpanValue='<%=ResourceComInfo.getLastname(beagentedid)%>'></brow:browser>
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

							<wea:SplitPageTag isShowTopInfo="false"
								tableString="<%=tableString%>" mode="run" />

						</wea:item>
					</wea:group>
				</wea:layout>

			</FORM>
		</div>

		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
		<!-- end -->

	</body>
</html>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript">
    function doSearch(){
        frmmain.submit();
    }

    function searchDetail(beagenterid,agenterid){
    	//2012-08-20 ypc 修改 一下注释的 两行 这种写法不兼容 Google和火狐 
        //document.getElementById("beagentedid").value=beagenterid;
        //document.getElementById("agentid").value=agenterid;
    	document.all("beagentedid").value=beagenterid;
    	document.all("agentid").value=agenterid;
        document.frmmain.action="agentLogDetailList.jsp";
        document.frmmain.submit();
    }
</script>		    
