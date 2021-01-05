
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-07-16 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="AllSubordinate" class="weaver.hrm.resource.AllSubordinate" scope="page"/>
<jsp:useBean id="SptmForLeave" class="weaver.hrm.resource.SptmForLeave" scope="page"/>
<%
	String hrmid="";
	ArrayList hrmids = new ArrayList();
	hrmids.add(""+user.getUID());
	AllSubordinate.getAll(""+user.getUID());
	while(AllSubordinate.next()){
		hrmids.add(AllSubordinate.getSubordinateID());
	}

	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+SystemEnv.getHtmlLabelName(670,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String isself = Util.null2String(request.getParameter("isself"));
	isself = "1";

	String departmentid=Util.null2String(request.getParameter("departmentid"));
	String resourceid=Util.null2String(request.getParameter("resourceid"));
	String fromdate =Util.null2String(request.getParameter("fromdate"));
	String todate =Util.null2String(request.getParameter("todate"));

	String attendancetype = Util.null2String(request.getParameter("attendancetype"));
	String attendancetypename = Util.null2String(request.getParameter("attendancetypename"));
	String leavesqlwhere = "";
	String leavetype = "";
	String otherleavetype = "";
	if(!attendancetype.equals("")){
		if(Util.TokenizerString2(attendancetype,"_")[0].equals("otherleavetype")){
			otherleavetype = Util.TokenizerString2(attendancetype,"_")[1];
			leavesqlwhere = " and leavetype = 4 and otherleavetype = " + otherleavetype;
		}else{
			leavetype = Util.TokenizerString2(attendancetype,"_")[1];
			leavesqlwhere = " and leavetype = " + leavetype;
		}
	}

	Calendar today = Calendar.getInstance();
	if(fromdate.equals("")) {
		fromdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
						 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-01" ;
	}

	if(todate.equals("")) {
		todate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
						 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
						 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
	}

	String querystr = "";
	if(!departmentid.equals("")) querystr += " and a.departmentid = "+departmentid;
	if(HrmUserVarify.checkUserRight("HrmResource:Absense",user)) {
		if(!resourceid.equals("")) querystr += " and a.resourceid = "+resourceid ;
	} else {
		if(!resourceid.equals("")) 
			querystr += " and a.resourceid = "+resourceid ;
		else {
			for(int i=0 ; i<hrmids.size() ; i++){
				if(i==0)
					hrmid=(String)hrmids.get(i);
				else
					hrmid+=","+(String)hrmids.get(i);
			}
			querystr += " and a.resourceid in ("+hrmid+")" ;
		}
	}
	querystr += " and ((a.fromdate <= '"+todate+"' and a.fromdate >= '"+fromdate+"') or "+
				" (a.todate <= '"+todate+"' and a.todate >= '"+fromdate+"') or (a.todate >= '"+todate+"' and a.fromdate <= '"+fromdate+"')) " ;
	querystr += leavesqlwhere;
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script language=javascript>  
			function submitData() {
				if(check_form(document.frmmain,"resourceid")){
					jQuery("#frmmain").submit();
				}
			}
			function doProcFrom(event,data,name){
				$GetEle("attendancetypename").value = data.name;
			}
			function exportExcel(){
				if(check_form(document.frmmain,"resourceid")){
					document.getElementById("excels").src = "HrmRpAbsenseExcel.jsp?fromdate="+document.frmmain.fromdate.value+"&todate="+document.frmmain.todate.value+"&resourceid="+$GetEle("resourceid").value+"&attendancetype="+$GetEle("attendancetype").value;
				}
			}
		</script>
	</head>
	<BODY>
		<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:exportExcel(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="exportExcel();" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage())%>"></input>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form id=frmmain name=frmmain method=post action="HrmRpAbsense.jsp" >
			<input type="hidden" name="isself" value="1">
			<input type="hidden" name="attendancetype" value="<%=attendancetype%>">
			<input type="hidden" name="attendancetypename" value="<%=attendancetypename%>">
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="resourceid" browserValue='<%=resourceid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp" width="60%" browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%>'>
							</brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1881,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="attendancetype" browserValue='<%=attendancetype%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/schedule/AnnualTypeBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="" width="60%" browserSpanValue='<%=attendancetypename%>' _callback="doProcFrom">
							</brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
					<wea:item>
						<span class="wuiDateSpan" selectId="createdateselect" selectValue="">
							<input class=wuiDateSel type="hidden" name="fromdate" id="fromdate" value="<%=fromdate%>">
							<input class=wuiDateSel type="hidden" name="todate" id="todate" value="<%=todate%>">
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>
			<div id="contentDiv" style="<%=isself.equals("1") ? "" : "display:none"%>">
			<wea:layout type="diycol">
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("15101,356",user.getLanguage())%>' >
					<wea:item attributes="{'isTableList':'true','colspan':'full'}">
						<%
							String backfields = "c.lastname,a.resourceid,a.leavetype,a.otherleavetype,a.fromdate,a.fromtime,a.todate,a.totime,a.leavedays,a.leavereason,a.requestid,b.requestname ";
							String fromSql  = " from bill_bohaileave a left join workflow_requestbase b on a.requestid = b.requestid left join HrmResource c on a.resourceId = c.id ";
							String sqlWhere = " where b.currentnodetype = 3 "+querystr;
							String orderby = "a.fromdate ,a.fromtime";
							String tableString =" <table pageId=\""+Constants.HRM_Q_002+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Q_002,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
								" <sql backfields=\""+backfields+"\" sumColumns=\"leavedays\" decimalFormat=\"%.0f\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.resourceid\" sqlsortway=\"asc\" sqlisdistinct=\"true\"/>"+
								"	<head>"+
								"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(85,user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\" href=\"/workflow/request/ViewRequest.jsp\" target=\"_blank\"/>"+
								"<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(827,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" linkkey=\"id\" linkvaluecolumn=\"resourceid\" href=\"/hrm/resource/HrmResource.jsp\" target=\"_blank\"/>"+
								"<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(828,user.getLanguage())+"\" column=\"leavedays\" orderkey=\"leavedays\" />"+
								"<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(1881,user.getLanguage())+"\" column=\"leavetype\" orderkey=\"leavetype\" transmethod=\"weaver.hrm.resource.SptmForLeave.getLeaveType\" otherpara=\"column:otherleavetype\" />"+
								"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"fromdate\" orderkey=\"fromdate\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:append[+ +column:fromtime+]}\" />"+
								"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"todate\" orderkey=\"todate\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:append[+ +column:totime+]}\" />"+
								"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(791,user.getLanguage())+"\" column=\"leavereason\" orderkey=\"leavereason\" />"+
								"</head></table>";
						%>
						<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
					</wea:item>
				</wea:group>
			</wea:layout>
			</div>
		</form>
		<iframe name="excels" id="excels" src="" style="display:none" ></iframe>
	</body>
</HTML>
