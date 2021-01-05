
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-08-01 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<%
	String rightStr = "";
	if(HrmUserVarify.checkUserRight("HrmContractTypeAdd:Add", user)){
		rightStr="HrmContractTypeAdd:Add";
	}
	if(HrmUserVarify.checkUserRight("HrmContractAdd:Add", user)){
		rightStr="HrmContractAdd:Add";
	}
	
	String from = Util.null2String(request.getParameter("from"));
	String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));
	String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
	String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
	String fromTodate=Util.fromScreen(request.getParameter("fromTodate"),user.getLanguage());
	String endTodate=Util.fromScreen(request.getParameter("endTodate"),user.getLanguage());
	String depid=Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());

	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String isself = Util.null2String(request.getParameter("isself"));
	isself = "1";
	
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15942,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
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
		<form id=frmmain name=frmmain method=post action="HrmRpContractType.jsp" >
			<input type="hidden" name="isself" value="1">
			<input type="hidden" name="from" value ="<%=from%>">
			<input type="hidden" name="isdialog" value ="<%=isDialog%>">
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></wea:item>
					<wea:item>
						<span class="wuiDateSpan" selectId="createdateselect" selectValue="">
							<input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
							<input class=wuiDateSel type="hidden" name="enddate" value="<%=enddate%>">
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></wea:item>
					<wea:item>
						<span class="wuiDateSpan" selectId="createdateselect" selectValue="">
							<input class=wuiDateSel type="hidden" name="fromTodate" value="<%=fromTodate%>">
							<input class=wuiDateSel type="hidden" name="endTodate" value="<%=endTodate%>">
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
					<wea:item><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="departmentid" browserValue='<%=depid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?rightStr=&selectedids="
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=4" width="60%" browserSpanValue='<%=DepartmentComInfo.getDepartmentname(depid)%>'>
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
							String tableString =" <table datasource=\"weaver.hrm.report.manager.HrmRpContractTypeManager.getResult\" sourceparams=\"fromdate:"+fromdate+"+enddate:"+enddate+"+fromTodate:"+fromTodate+"+endTodate:"+endTodate+"+subcompanyid1:"+subcompanyid1+"+from:"+from+"+depid:"+depid+"\" pageId=\""+Constants.HRM_Q_030+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Q_030,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
								" <sql backfields=\"*\" sumColumns=\"result\" sqlform=\"temp\" sqlwhere=\"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"/>"+
							"	<head>"+
							"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(6158,user.getLanguage())+"\" column=\"title\" orderkey=\"title\" />"+
							"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(15946,user.getLanguage())+"\" column=\"result\" orderkey=\"result\" transmethod=\"weaver.hrm.report.manager.HrmRpContractManager.getResultStr\" otherpara=\"column:result_url\" />"+
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
