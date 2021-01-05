
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<!-- modified by wcd 2014-06-29 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(431,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String id=Util.null2String(request.getParameter("id"));
	RecordSet.execute("HrmRoleMembers_SelectByID",id);
	RecordSet.next();
	String roleID=RecordSet.getString("roleid");
	String resourceID=RecordSet.getString("resourceid");
	String rolelevel=RecordSet.getString("rolelevel");
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
				if(check_form(document.frmMain,'employeeID')){
					document.frmMain.operationType.value = "Edit";
					document.frmMain.submit();
				}
			}
			
			function doDel(){
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
					document.frmMain.operationType.value = "Delete";
					document.frmMain.cmd.value = "closeDialog";
					document.frmMain.submit();
				});
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
			if(HrmUserVarify.checkUserRight("HrmRoleMembersEdit:Edit",user)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="doDel();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="HrmRolesMembersOperation.jsp" method=post >
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<%=RolesComInfo.getRolesRemark(roleID)%>
					</wea:item>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<SELECT class=inputstyle ID=level Name=level>
								<OPTION VALUE=2 <% if(rolelevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></OPTION>
								<OPTION VALUE=1 <% if(rolelevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION>
								<OPTION VALUE=0 <% if(rolelevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION>						
							</SELECT>
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>
			<input type="hidden" name="employeeID" value=<%=resourceID%>>
			<input type="hidden" name="roleID" value="<%=roleID%>">
			<input type="hidden" name="rolelevel2" value="<%=rolelevel%>">
			<input type="hidden" name="id" value="<%=id%>">
			<input type="hidden" name="operationType">
			<input type="hidden" name="cmd">
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
