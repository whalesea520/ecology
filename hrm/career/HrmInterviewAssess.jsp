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
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(6134,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(6102,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.planid = "<%=planid%>";
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
		<FORM id=weaver name=frmMain action="HrmInterviewOperation.jsp" method=post >
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(15730,user.getLanguage())%></wea:item>
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
					<wea:item><%=SystemEnv.getHtmlLabelName(15697,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
					        <select class=inputstyle name=result>
								<option value=0 ><%=SystemEnv.getHtmlLabelName(15699,user.getLanguage())%></option>
								<option value=1 ><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
								<option value=2 ><%=SystemEnv.getHtmlLabelName(15700,user.getLanguage())%></option>
							</select>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15698,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<textarea class=inputstyle rows=5 cols=40 name="remark" ></textarea>
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>		
			<input class=inputstyle type=hidden name=operation value="assess">
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
