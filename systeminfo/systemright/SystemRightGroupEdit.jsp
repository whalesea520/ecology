
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-24 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	if(!HrmUserVarify.checkUserRight("SystemRightGroupEdit:Edit",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String id = Util.null2String(request.getParameter("id"));
	
	String mark="";
	String description="";
	String notes="";
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = "";
	String needfav ="1";
	String needhelp ="1";
	
	if(!id.equals("-1")) {
		rs.execute("SystemRightGroup_sbygroupid",id);
		rs.next() ;
		mark=rs.getString(1);
		description=rs.getString(2);
		notes=rs.getString(3);
		
		titlename =SystemEnv.getHtmlLabelName(492,user.getLanguage())+" - " + description;
	}else {
		titlename = SystemEnv.getHtmlLabelName(492,user.getLanguage())+" - " +SystemEnv.getHtmlLabelName(332,user.getLanguage());
	}
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
				if(check_form(document.formmain,"mark,description")){
					document.formmain.operationType.value = "edit";
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
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<iframe id="checkHas" style="display:none"></iframe>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM ID=formmain name=formmain ACTION=SystemRightGroupOperation.jsp METHOD=POST >
			<input type=hidden name=operationType>
			<input type=hidden name=groupID value="<%=id%>">
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelNames("492,84",user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required='<%=mark.length()==0%>'>
							<INPUT class=inputstyle maxLength=100 size=30 name="mark" value="<%=mark%>" onchange='checkinput("mark","namespan")'/>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelNames("492,85",user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="descriptionspan" required='<%=description.length()==0%>'>
							<input class=inputstyle maxlength=100 size=30 name="description" value="<%=description%>" onchange='checkinput("description","descriptionspan")'/>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="notesspan" required="false">
							<textarea class=inputstyle cols=50 rows=4 name="notes" ><%=notes%></textarea>
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
