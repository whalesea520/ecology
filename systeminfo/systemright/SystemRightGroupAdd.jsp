
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-24 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	if(!HrmUserVarify.checkUserRight("SystemRightGroupAdd:Add",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	String groupID = Util.null2String(request.getParameter("groupID"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(492,user.getLanguage());
	String needfav ="1";
	String needhelp ="1";
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
			}else if("<%=isclose%>"=="2"){	
				parentWin.closeDialog();
				parentWin.doEdit("<%=groupID%>");
			}
			function doSave(){
				if(check_form(document.formmain,"mark,description")){
					document.formmain.operationType.value = "save";
					document.formmain.submit();
				}
			}
			function doNext(){
				if(check_form(document.formmain,"mark,description")){
					document.formmain.operationType.value = "next";
					document.formmain.submit();
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
			RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:doNext(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<iframe id="checkHas" style="display:none"></iframe>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage()) %>" class="e8_btn_top" onclick="doNext()"/>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM ID=formmain name=formmain ACTION=SystemRightGroupOperation.jsp METHOD=POST >
			<input type=hidden name=operationType>
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelNames("492,84",user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="true">
							<INPUT class=inputstyle maxLength=100 size=30 name="mark" value="" onchange='checkinput("mark","namespan")'/>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelNames("492,85",user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="descriptionspan" required="true">
							<input class=inputstyle maxlength=100 size=30 name="description" value="" onchange='checkinput("description","descriptionspan")'/>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="notesspan" required="false">
							<textarea class=inputstyle cols=50 rows=4 name="notes" ></textarea>
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>
		</FORM>
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
