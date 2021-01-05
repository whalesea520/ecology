<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-27 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<% 
	if(!HrmUserVarify.checkUserRight("HrmCheckItemEdit:Edit",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	String id = Util.null2String(request.getParameter("id"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String checkitemname="";
	String checkitemexplain="";
	rs.executeProc("HrmCheckItem_SByid",id);
	if(rs.next()){
		checkitemname = rs.getString("checkitemname");
		checkitemexplain = Util.toScreenToEdit(rs.getString("checkitemexplain"),user.getLanguage());
	}
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6117,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	boolean canEdit = false;
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.closeDialog();	
			}
		 	function doSave(){
		    	if(check_form(document.frmMain,'checkitemname')){
				   	document.frmMain.operation.value="edit";
				   	document.frmMain.action = "HrmCheckItemOperation.jsp";
				   	document.frmMain.submit();
		  		}
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
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
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
		<FORM id=weaver name=frmMain action="" method=post >
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(15753,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required='<%=checkitemname.length()==0%>'>
							<INPUT class=InputStyle maxLength=30 size=30 name="checkitemname" onchange="checkinput('checkitemname','namespan')" value="<%=checkitemname%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15754,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="checkitemexplainspan" required="false">
							<textarea class=inputstyle cols=50 rows=4 name="checkitemexplain" ><%=checkitemexplain%></textarea>
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>		
			<input class=inputstyle type="hidden" name="operation">
			<input class=inputstyle type="hidden" name=id value="<%=id%>">
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
