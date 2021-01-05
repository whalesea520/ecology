<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-09 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("HrmUseDemandAdd:Add", user)){
	  	response.sendRedirect("/notice/noright.jsp");
	  	return;
	}
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6131,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
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
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave();,_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="UseDemandOperation.jsp" method=post >
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0"  name="departmentid" browserValue=''
					 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?isedit=1&rightStr=HrmResourceAdd:Add"
				   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				   completeUrl="/data.jsp?type=4" width="165px"
				   browserSpanValue=''>
				 </brow:browser>
				</wea:item> 
					<wea:item><%=SystemEnv.getHtmlLabelName(20379,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="jobtitle" browserValue="" 
				                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
				                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				                completeUrl="/data.jsp?type=hrmjobtitles" width="60%" browserSpanValue="">
					        </brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(17905,user.getLanguage())+SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="demandnumspan" required="true">
							<input class=inputstyle type=text maxlength="30" style="width:60%" name="demandnum" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("demandnum")' onchange='checkinput("demandnum","demandnumspan")'>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(6153,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="datesspan" required="false">
							<BUTTON class=Calendar type="button" id=selectdate onclick="getDate(datespan,date)"></BUTTON> 
				            <SPAN id=datespan ></SPAN> 
				            <input class=inputstyle type="hidden" id="date" name="date" > 
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
					        <brow:browser viewType="0" name="demandkind" browserValue="" 
				                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp"
				                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				                completeUrl="/data.jsp?type=usekind" width="60%" browserSpanValue="">
					        </brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="leastedulevel" browserValue="" 
				                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp"
				                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				                completeUrl="/data.jsp?type=educationlevel" width="60%" browserSpanValue="">
					        </brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1847,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="otherrequestspan" required="false">
							<textarea class=inputstyle cols=50 rows=4 name="otherrequest" ></textarea>
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>		
			<input type=hidden name="_status" value="<%=_status%>">
			<input class=inputstyle type="hidden" name="operation">
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
		 	function doSave(){
		    	if(check_form(document.frmMain,'jobtitle,demandnum,departmentid')){
				   	document.frmMain.operation.value="save";
				   	document.frmMain.submit();
		  		}
		 	}
		</script> 
	</BODY>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
