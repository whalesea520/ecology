
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-08-01 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<%
	String from = Util.null2String(request.getParameter("from"));
	String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));
	String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
	String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
	String fromTodate=Util.fromScreen(request.getParameter("fromTodate"),user.getLanguage());
	String endTodate=Util.fromScreen(request.getParameter("endTodate"),user.getLanguage());

	String isself = Util.null2String(request.getParameter("isself"));
	isself = "1";
	
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+ SystemEnv.getHtmlLabelName(15941,user.getLanguage()) ;
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
			function submitData() {
				if(validateDate()){
					jQuery("#frmmain").submit();
				}
			}
			function exportExcel(){
				document.getElementById("excels").src = "HrmReportExcel.jsp?cmd=HrmRpContract&tnum=16572&fromdate=<%=fromdate%>&enddate=<%=enddate%>&fromTodate=<%=fromTodate%>&endTodate=<%=endTodate%>&subcompanyid1=<%=subcompanyid1%>&from=<%=from%>";
			}
			var dialog = null;
			var dWidth = jQuery(window).width();
			var dHeight = jQuery(window).height();
			

			function closeDialog(){
				if(dialog)
					dialog.close();
				window.location.href="/hrm/report/contract/HrmRpContract.jsp";
			}
			
			function doOpen(url,title,_dWidth,_dHeight){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth ? _dWidth : dWidth;
				dialog.Height = _dHeight ? _dHeight : dHeight;
				if(dialog.Width == null|| dialog.Width.length ==0){
					dialog.Width  =800;
				}
				if(dialog.Height<600){
					dialog.Height =600;
				}
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
			}
			
			function showContractType(){
				show("HrmRpContractType","<%=SystemEnv.getHtmlLabelName(15942,user.getLanguage())%>");
			}
			function showContractTime(){
				show("HrmRpContractTime","<%=SystemEnv.getHtmlLabelName(15943,user.getLanguage())%>");
			}
			function showContractReport(){
				show("HrmContractReport","<%=SystemEnv.getHtmlLabelName(15939,user.getLanguage())%>");
			}
			function showContractDetail(){
				show("HrmRpContractDetail","<%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%>");
			}
			function show(arg0, arg1){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmReport&cmd=hrmContract&method="+arg0+"&showpage=1&subcompanyid1=<%=subcompanyid1%>", arg1);
			}
			function validateDate(){
				//合同开始日期校验
				var createDateSelectValue = jQuery("#createdateselect").val();
				if('6'==createDateSelectValue){
					var fromdate = jQuery("input[name=fromdate]").val();
					var enddate = jQuery("input[name=enddate]").val();
					if(fromdate!=""&&enddate!=""){
						if(fromdate>enddate){
							window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())
										+SystemEnv.getHtmlLabelName(32530,user.getLanguage())
										+SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
							return false;
						}
					}
				}
				//合同结束日期校验
				var endDateSelect = jQuery("#enddateselect").val();
				if('6'==endDateSelect){
					var fromTodate = jQuery("input[name=fromTodate]").val();
					var endTodate = jQuery("input[name=endTodate]").val();
					if(fromTodate!=""&&endTodate!=""){
						if(fromTodate>endTodate){
							window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())
										+SystemEnv.getHtmlLabelName(32530,user.getLanguage())
										+SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
							return false;
						}
					}
				}
				return true;
			}
		</script>
	</head>
	<BODY>
		<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			/*RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:exportExcel(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;*/
			
			RCMenu += "{"+SystemEnv.getHtmlLabelName(15942,user.getLanguage())+",javascript:showContractType(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(15943,user.getLanguage())+",javascript:showContractTime(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(15939,user.getLanguage())+",javascript:showContractReport(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(15729,user.getLanguage())+",javascript:showContractDetail(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
					<!--<input type=button class="e8_btn_top" onclick="exportExcel();" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage())%>"></input>-->
					<input type=button class="e8_btn_top" onclick="showContractType();" value="<%=SystemEnv.getHtmlLabelName(15942,user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="showContractTime();" value="<%=SystemEnv.getHtmlLabelName(15943,user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="showContractReport();" value="<%=SystemEnv.getHtmlLabelName(15939,user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="showContractDetail();" value="<%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%>"></input>
					
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form id=frmmain name=frmmain method=post action="HrmRpContract.jsp" >
			<input type="hidden" name="isself" value="1">
			<input type="hidden" name="from" value ="<%=from%>">
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
						<span class="wuiDateSpan" selectId="enddateselect" selectValue="">
							<input class=wuiDateSel type="hidden" name="fromTodate" value="<%=fromTodate%>">
							<input class=wuiDateSel type="hidden" name="endTodate" value="<%=endTodate%>">
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="subcompanyid1" browserValue='<%=subcompanyid1%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=164" width="60%" browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subcompanyid1)%>'>
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
							String tableString =" <table datasource=\"weaver.hrm.report.manager.HrmRpContractManager.getResult\" sourceparams=\"fromdate:"+fromdate+"+enddate:"+enddate+"+fromTodate:"+fromTodate+"+endTodate:"+endTodate+"+subcompanyid1:"+subcompanyid1+"+from:"+from+"\" pageId=\""+Constants.HRM_Q_030+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Q_030,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
								" <sql backfields=\"*\" sumColumns=\"result\" sqlform=\"temp\" sqlwhere=\"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"/>"+
							"	<head>"+
							"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"title\" orderkey=\"title\" />"+
							"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(15946,user.getLanguage())+"\" column=\"result\" orderkey=\"result\" transmethod=\"weaver.hrm.report.manager.HrmRpContractManager.getResultStr\" otherpara=\"column:resultTitle\" />"+
							"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"\" column=\"result\" orderkey=\"result\" algorithmdesc=\"percent\" molecular=\"result\" denominator=\"total\" />"+
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
