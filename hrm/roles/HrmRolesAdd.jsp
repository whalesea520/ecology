
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-27 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String id = Util.null2String(request.getParameter("id"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String dftsubcomid = "";
	rs.executeProc("SystemSet_Select","");
	if(rs.next()){
		dftsubcomid = Util.null2String(rs.getString("dftsubcomid"));
	}
	String structureid ="";
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	//int hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
	if(Util.null2String(request.getParameter("subCompanyId")).length()==0||
			Util.null2String(request.getParameter("subCompanyId")).equals("0")){
		structureid=dftsubcomid;//String.valueOf(session.getAttribute("role_subCompanyId"));
	}else{
		structureid=Util.null2String(request.getParameter("subCompanyId"));
	}
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(365,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(122,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
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
				parentWin.openDialog("<%=id%>");
			}
			function doCheck(){
				return check_form(document.frmMain,'idname,structureid');
			}
			function doSave(){
				if(doCheck()){
					document.frmMain.operationType.value = "Add";
					document.frmMain.submit();
				}
			}
			function doNext(){
				if(doCheck()){
					document.frmMain.operationType.value="next";
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
			if(HrmUserVarify.checkUserRight("HrmRolesAdd:Add",user)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:doNext(),_self} " ;
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
		<FORM id=weaver name=frmMain action="HrmRolesOperation.jsp" method=post >
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<wea:required id="namespan" required="true">
				  			<input class=inputstyle type=text size=50 name="idname" onchange="checkinput('idname','namespan')">
						</wea:required>
					</wea:item>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<wea:required id="descriptionspan" required="false">
				  			<input class=inputstyle type=text size=60 name="description" onchange="checkinput('description','descriptionspan')">
						</wea:required>
					</wea:item>
					<%if(detachable==1){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<select name="roletype" id="roletype" class=inputstyle>
								<option value="0"><%=SystemEnv.getHtmlLabelName(17866,user.getLanguage())%></option>
								<option value="1"><%=SystemEnv.getHtmlLabelName(17867,user.getLanguage())%></option>
							</select>
							&nbsp;
							<img src="/wechat/images/remind_wev8.png" align="absMiddle" id="crmImg" title="<%=SystemEnv.getHtmlLabelName(23265,user.getLanguage())+"\r\n"+SystemEnv.getHtmlLabelName(23266,user.getLanguage())%>" />
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<span>
							<brow:browser viewType="0" name="structureid" browserValue='<%=structureid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=HrmRolesAdd:Add&isedit=1&selectedids="
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp?type=164" width="60%" browserSpanValue='<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(structureid),user.getLanguage())%>'>
							</brow:browser>
						</span>
					</wea:item>
					<%}%>
					<wea:item><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<span>
							<brow:browser viewType="0" name="docid" browserValue="" 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=9" width="60%" browserSpanValue="">
							</brow:browser>
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>
			<input class="inputstyle" type="hidden" name="operationType">
			<input class="inputstyle" type="hidden" name="id" value="<%=id%>">
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
