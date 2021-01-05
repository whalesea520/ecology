
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.teechart.*" %>
<!-- modified by wcd 2014-07-31 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<%
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage()) +":" + SystemEnv.getHtmlLabelName(671,user.getLanguage()) ;
	String needfav ="1";
	String needhelp ="";
	
	String isself = Util.null2String(request.getParameter("isself"));
	isself = "1";

	String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
	String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
	String status=Util.fromScreen(request.getParameter("status"),user.getLanguage());
	String location=Util.fromScreen(request.getParameter("location"),user.getLanguage());
	
	if(status.equals("")){
		status = "8";
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script language=javascript>  
			function submitData() {
				jQuery("#frmmain").submit();
			}
			function exportExcel(){
				document.getElementById("excels").src = "HrmReportExcel.jsp?cmd=HrmJobCallRp&tnum=16554&fromdate=<%=fromdate%>&enddate=<%=enddate%>&location=<%=location%>&status=<%=status%>";
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
		<form id=frmmain name=frmmain method=post action="HrmJobCallRp.jsp" >
			<input type="hidden" name="isself" value="1">
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="location" browserValue='<%=location%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=location" width="60%" browserSpanValue='<%=Util.toScreen(LocationComInfo.getLocationname(location),user.getLanguage())%>'>
							</brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1908,user.getLanguage())%></wea:item>
					<wea:item>
						<span class="wuiDateSpan" selectId="createdateselect" selectValue="">
							<input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
							<input class=wuiDateSel type="hidden" name="enddate" value="<%=enddate%>">
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<SELECT class=inputStyle id=status name=status value="<%=status%>"  >              
							   <OPTION value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>                   
							   <OPTION value="0" <% if(status.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></OPTION>
							   <OPTION value="1" <% if(status.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></OPTION>
							   <OPTION value="2" <% if(status.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
							   <OPTION value="3" <% if(status.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></OPTION>
							   <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
							   <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
							   <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
							   <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
							   <OPTION value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></OPTION>                   
						 </SELECT>
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>
			<div id="contentDiv" style="<%=isself.equals("1") ? "" : "display:none"%>">
			<wea:layout type="diycol">
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("15101,356",user.getLanguage())%>' >
					<wea:item attributes="{'isTableList':'true','colspan':'full'}">
						<%
							String tableString =" <table needPage=\"false\" datasource=\"weaver.hrm.report.manager.HrmJobCallRpManager.getResult\" sourceparams=\"fromdate:"+fromdate+"+enddate:"+enddate+"+location:"+location+"+status:"+status+"\" pageId=\""+Constants.HRM_Q_0210+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Q_0210,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
								" <sql backfields=\"*\" sumColumns=\"result\" showCountColumn=\"true\" showPageCount=\"false\" sqlform=\"temp\" sqlwhere=\"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"/>"+
							"	<head>"+
							"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(806,user.getLanguage())+"\" column=\"title\" orderkey=\"title\" />"+
							"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(1859,user.getLanguage())+"\" column=\"result\" orderkey=\"result\" />"+
							"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"\" column=\"percent\" orderkey=\"percent\" molecular=\"result\" denominator=\"total\" />"+
							"	</head></table>";
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
