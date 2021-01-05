<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("LgcAssetUnitAdd:Add", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String id = Util.null2String(request.getParameter("id"));
	rs.executeProc("LgcAssetUnit_SelectByID",id);
	rs.next();
	String unitmark = rs.getString("unitmark");
	String unitname = rs.getString("unitname");
	String unitdesc = rs.getString("unitdesc");
	boolean canedit = HrmUserVarify.checkUserRight("LgcAssetUnitEdit:Edit", user) ;
	
	boolean canDel = HrmUserVarify.checkUserRight("LgcAssetUnitEdit:Delete", user);
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(1329,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String message = Util.null2String(request.getParameter("message"));
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
			if("<%=message%>"=="failrepeat"){//名称重复，不允许保存
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129179,user.getLanguage())%>");
			}
			function doDel(){
				parentWin._cmd = "closeDialog";
				parentWin.doDel('<%=id%>');
			}
		 	function doSave(){
		    	if(check_form(document.frmMain,'unitname')){
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
			if(canDel){ 
				RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<%if(canDel){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="doDel();">
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="LgcAssetUnitOperation.jsp" method=post >
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required='<%=unitname.length()==0%>'>
							<input class=InputStyle maxLength=50 size=30 name="unitname" value="<%=Util.toScreenToEdit(unitname,user.getLanguage())%>" onchange="checkinput('unitname','namespan')">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="unitdescspan" required="false">
							<textarea class=inputstyle cols=50 rows=4 name="unitdesc" ><%=Util.toScreenToEdit(unitdesc,user.getLanguage())%></textarea>
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>		
			<input type="hidden" name="operation" value="editunit">
			<input type="hidden" name="id" value="<%=id%>">
			<input type="hidden" name="unitmark" value="<%=unitmark%>">
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
