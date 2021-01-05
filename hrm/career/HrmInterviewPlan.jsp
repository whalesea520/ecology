<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-04 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String id = Util.null2String(request.getParameter("id"));
	String planid = Util.null2String(request.getParameter("planid"));
	String sql = "select lastname from HrmCareerApply where id ="+id;
	rs.executeSql(sql);
	rs.next();
	String name = Util.null2String(rs.getString("lastname"));

	String step = CareerApplyComInfo.getStep(id);
	String stepname = CareerApplyComInfo.getStepname(id);

	String date = "" ;
	String time = "" ;
	String address = "" ;
	String notice = "" ;
	String interviewer = "" ;

	sql = "select * from HrmInterview where resourceid = "+id+ " and stepid = "+step;
	rs.executeSql(sql);
	if( rs.next() ) {
		date = Util.null2String(rs.getString("date_n"));
		time = Util.null2String(rs.getString("time"));
		address = Util.null2String(rs.getString("address"));
		notice = Util.fromScreen(rs.getString("notice"),user.getLanguage());
		interviewer = Util.null2String(rs.getString("interviewer"));
	}
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(6134,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(6103,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	boolean isInformer = CareerApplyComInfo.isInformer(id,user.getUID()); 
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				//parentWin.planid = "<%=planid%>";
				parentWin.closeDialog();	
			}
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
			if( isInformer ) {
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave();,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%if( isInformer ) {%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="HrmInterviewOperation.jsp" method=post >
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(15732,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<%=name%><input class=inputstyle type=hidden name=resourceid value=<%=id%>>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15731,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<%=stepname%><input class=inputstyle type=hidden name=step value=<%=step%>>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15733,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
					        <% if( isInformer ) { %>
								<BUTTON class=calendar type="button" id=SelectDate onclick="getDate(fromdatespan,date)"></BUTTON>&nbsp;
								<SPAN id=fromdatespan ><%=date%></SPAN>
								<input type="hidden" name="date" value="<%=date%>">
							<%} else {%>
								<%=date%>
							<%}%>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15734,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<% if( isInformer ) { %>
								<BUTTON class=calendar type="button" id=SelectTime onclick="onShowTime(fromtimespan,time)"></BUTTON>&nbsp;
								<SPAN id=fromtimespan ><%=time%></SPAN>
								<input type="hidden" name="time" value="<%=time%>">
							<%} else {%>
								<%=time%>
							<%}%>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15735,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<% if( isInformer ) { %>
								<input class=inputstyle type=text name=address value=<%=address%>>
							<%} else {%>
								<%=address%>
							<%}%>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15736,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<% if( isInformer ) { %>
								<textarea rows=5 cols=40 name="notice"><%=Util.toScreenToEdit(notice,user.getLanguage())%></textarea>
							<%} else {%>
								<%=notice%>
							<%}%>
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>		
			<input class=inputstyle type=hidden name=operation value="plan">
			<input class=inputstyle type=hidden name=planid value="<%=planid%>">
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
