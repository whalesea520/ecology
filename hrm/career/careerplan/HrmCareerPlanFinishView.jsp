
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-29 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="MailMouldComInfo" class="weaver.docs.mail.MailMouldComInfo" scope="page" />
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("HrmCareerPlanFinish:Finish", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String id = request.getParameter("id");

	String sql = "select * from HrmCareerPlan where id = "+id;
	rs.executeSql(sql);
	rs.next();
	String enddate = Util.null2String(rs.getString("enddate"));
	String fare = Util.null2String(rs.getString("fare"));
	String faretype = Util.null2String(rs.getString("faretype"));
	String advice = Util.null2String(rs.getString("advice"));

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(6132,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6135,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript>
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			function doSave(){
				document.frmMain.submit();
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
			/*RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/career/careerplan/HrmCareerPlanEdit.jsp?isdialog=1&id="+id+",_self} " ;
			RCMenuHeight += RCMenuHeightStep ;*/
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%if(HrmUserVarify.checkUserRight("HrmCareerPlanFinish:Finish", user)){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="CareerPlanOperation.jsp" method=post >
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%>'>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<span><%=enddate%></span>
					</wea:item>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(15728,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<span><%=advice%></span>
					</wea:item>
				</wea:group>
			</wea:layout>
			<input class=inputstyle type="hidden" name=operation value="finish">
			<input class=inputstyle type=hidden name=id value="<%=id%>">
			<input class=inputstyle type=hidden name=_status value="<%=_status%>">
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
	</BODY>
</HTML>
