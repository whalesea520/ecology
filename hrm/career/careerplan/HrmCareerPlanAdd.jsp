<%@ page import="weaver.general.Util,java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-11 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="MailMouldComInfo" class="weaver.docs.mail.MailMouldComInfo" scope="page" />
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("HrmCareerPlanAdd:Add", user)){
	 	response.sendRedirect("/notice/noright.jsp");
	 	return;
	}
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6132,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
		
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String id = Util.null2String(request.getParameter("id"));
	String _status = Util.null2String(request.getParameter("_status"));
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin._status = "<%=_status%>";
				parentWin.closeDialog();	
			}else if("<%=isclose%>"=="2"){	
				parentWin._status = "<%=_status%>";
				parentWin.closeDialog();
				parentWin.openDialog("<%=id%>");
			}
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(HrmUserVarify.checkUserRight("HrmCareerPlanAdd:Add", user)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave()">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage()) %>" class="e8_btn_top" onclick="doNext()"/>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="CareerPlanOperation.jsp" method=post >
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%>'>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<wea:required id="namespan" required="true">
				  			<input class=inputstyle type=text size=30 name="topic" onchange="checkinput('topic','namespan')">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<span>
							<brow:browser viewType="0" name="principalid" browserValue="" 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp" width="60%" browserSpanValue="">
							</brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15669,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<span>
							<brow:browser viewType="0" name="informmanid" browserValue="" 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp" width="60%" browserSpanValue="">
							</brow:browser>
						</span>
					</wea:item>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(22168,user.getLanguage())%></wea:item>
				  	<wea:item>
						<wea:required id="selectdatespan" required="false">
							<BUTTON class=Calendar type="button" id=selectdate onclick="getDate(datespan,startdate)"></BUTTON> 
				            <SPAN id=datespan ></SPAN> 
				            <input class=inputstyle type="hidden" id="startdate" name="startdate" > 
						</wea:required>
					</wea:item>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<wea:required id="memospan" required="false">
				  			<textarea class=inputstyle cols=50 rows=4 name="memo" ></textarea>
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>
			<input class="inputstyle" type="hidden" name="operation">
			<input class="inputstyle" type="hidden" name="id" value="<%=id%>">
			<input type=hidden name="_status" value="<%=_status%>">
		</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.closeByHand();">
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
		<script language=javascript>
			function doCheck(){
				return check_form(document.frmMain,'topic');
			}
			function doSave(){
				if(doCheck()){
					document.frmMain.operation.value = "save";
					document.frmMain.submit();
				}
			}
			function doNext(){
				if(doCheck()){
					document.frmMain.operation.value="next";
					document.frmMain.submit();
				}
			}
		</script>
	</BODY>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
