
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-08-01 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<%
	String year = Util.null2String(request.getParameter("year"));
	if(year.equals("")){
		Calendar todaycal = Calendar.getInstance ();
		year = Util.add0(todaycal.get(Calendar.YEAR), 4);
	}
	String from = Util.null2String(request.getParameter("from"));
	String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));

	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String showpage = Util.null2String(request.getParameter("showpage"));
	showpage = showpage.length() == 0 ? "1" : showpage;
	String isself = Util.null2String(request.getParameter("isself"));
	isself = "1";
	
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15939,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript>  
			var dialog = parent.parent.getDialog(parent);
			
			function submitData() {
				jQuery("#frmmain").submit();
			}
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form id=frmmain name=frmmain method=post action="HrmContractReport.jsp" >
			<input type="hidden" name="isself" value="1">
			<input type="hidden" name="from" value ="<%=from%>">
			<input type="hidden" name="showpage" value ="<%=showpage%>">
			<input type="hidden" name="isdialog" value ="<%=isDialog%>">
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(15933,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<INPUT class=inputStyle maxLength=4 size=4 name="year" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("year")' value="<%=year%>">
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="subcompanyid1" browserValue='<%=subcompanyid1%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' nameSplitFlag=' '
								completeUrl="/data.jsp?type=164" width="60%" browserSpanValue='<%=SubCompanyComInfo.getMoreSubCompanyname(subcompanyid1)%>'>
							</brow:browser>
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>
			<div id="contentDiv" style="<%=isself.equals("1") ? "" : "display:none"%>">
			<wea:layout type="diycol">
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("15101,356",user.getLanguage())%>' >
					<wea:item attributes="{'isTableList':'true','colspan':'full'}">
						<%
							String tableString = "";
							if(showpage.equals("1") || showpage.equals("2")){
								tableString =" <table datasource=\"weaver.hrm.report.manager.HrmContractReportManager.getResult\" sourceparams=\"year:"+year+"+subcompanyid1:"+subcompanyid1+"+from:"+from+"+showpage:"+showpage+"\" pageId=\""+Constants.HRM_Q_030+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Q_030,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
								" <sql backfields=\"*\" sqlform=\"temp\" sqlwhere=\"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"/>"+
								"	<head>"+
								"		<col width=\"16%\" text=\""+SystemEnv.getHtmlLabelName(showpage.equals("1")?124:716,user.getLanguage())+"\" column=\"title\" orderkey=\"title\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1492,user.getLanguage())+"\" column=\"result1\" orderkey=\"result1\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1493,user.getLanguage())+"\" column=\"result2\" orderkey=\"result2\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1494,user.getLanguage())+"\" column=\"result3\" orderkey=\"result3\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1495,user.getLanguage())+"\" column=\"result4\" orderkey=\"result4\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1496,user.getLanguage())+"\" column=\"result5\" orderkey=\"result5\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1497,user.getLanguage())+"\" column=\"result6\" orderkey=\"result6\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1498,user.getLanguage())+"\" column=\"result7\" orderkey=\"result7\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1499,user.getLanguage())+"\" column=\"result8\" orderkey=\"result8\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1800,user.getLanguage())+"\" column=\"result9\" orderkey=\"result9\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1801,user.getLanguage())+"\" column=\"result10\" orderkey=\"result10\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1802,user.getLanguage())+"\" column=\"result11\" orderkey=\"result11\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1803,user.getLanguage())+"\" column=\"result12\" orderkey=\"result12\" />"+
								"	</head></table>";
							}else if(showpage.equals("3")){
								String sql = "select id,typename from HrmContractType order by id";
								rs.executeSql(sql);
								
								tableString =" <table datasource=\"weaver.hrm.report.manager.HrmContractReportManager.getResult\" sourceparams=\"year:"+year+"+subcompanyid1:"+subcompanyid1+"+from:"+from+"+showpage:"+showpage+"\" pageId=\""+Constants.HRM_Q_030+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Q_030,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
								" <sql backfields=\"*\" sqlform=\"temp\" sqlwhere=\"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"/>"+
								"	<head>"+
								"		<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"title\" orderkey=\"title\" />";
								int rsCount = rs.getCounts();
								while (rs.next()) {
									String id = Util.null2String(rs.getString("id"));
									String typename = Util.null2String(rs.getString("typename"));
									tableString += "<col width=\""+(90/rsCount)+"%\" text=\""+typename+"\" column=\"resultcount"+id+"\" orderkey=\"title\" />";
								}
								tableString +="	</head></table>";
							}
						%>
						<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
					</wea:item>
				</wea:group>
			</wea:layout>
			</div>
		</form>
		<iframe name="excels" id="excels" src="" style="display:none" ></iframe>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.close();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
	</body>
</HTML>
