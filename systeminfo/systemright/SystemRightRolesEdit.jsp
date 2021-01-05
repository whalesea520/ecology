
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<!-- modified by wcd 2014-07-01 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("SystemRightRolesAdd:Add",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	String id = Util.null2String(request.getParameter("id")) ;
	String groupID = Util.null2String(request.getParameter("groupID")) ;

	rs.executeSql("select a.id,a.rightid,a.roleid,a.rolelevel,b.rolesmark from SystemRightRoles a left join HrmRoles b on a.roleid = b.id where a.id = "+id);
	rs.next();
	String rightid = rs.getString("rightid");
	String roleid = rs.getString("roleid");
	String rolelevel = rs.getString("rolelevel");
	String rolesmark = rs.getString("rolesmark");
	boolean canedit = HrmUserVarify.checkUserRight("SystemRightRolesEdit:Edit",user) ;
	
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(385,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(122,user.getLanguage());
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
				parentWin.id = "<%=rightid%>";
				parentWin.groupID = "<%=groupID%>";
				parentWin.closeDialog();	
			}
			function doSave() {
				if(check_form($GetEle("frmMain"),'roleid')){
					$GetEle("frmMain").submit();
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
			if(canedit) {
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<% if(canedit) {%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=frmMain name=frmMain action="SystemRightGroupOperation.jsp" method=post >
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
					<wea:item><span><%=rolesmark%></span></wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<% if(canedit) {%>
								<SELECT ID=rolelevel NAME=rolelevel>
									<OPTION VALUE="2" <% if(rolelevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></OPTION>
									<OPTION VALUE="1" <% if(rolelevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION>
									<OPTION VALUE="0" <% if(rolelevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION>
								</SELECT>
							<%} else {%>
								<% if(rolelevel.equals("2")) {%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><%}%>
								<% if(rolelevel.equals("1")) {%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><%}%>
								<% if(rolelevel.equals("0")) {%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><%}%>
							<%}%>
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>
			<input type=hidden name="id" value="<%=id%>">
			<input type=hidden name="operationType" value="editrightroles">
			<input type=hidden name="groupID" value="<%=groupID%>">
			<input type=hidden name="rightid" value="<%=rightid%>">
			<input type=hidden name="roleid" value="<%=roleid%>">
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
