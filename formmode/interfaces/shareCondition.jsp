
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML><HEAD>

</HEAD>
<BODY>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String modeid = StringHelper.null2String(request.getParameter("modeid"));
	String rightid = StringHelper.null2String(request.getParameter("rightid"));
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(82394,user.getLanguage());//条件编辑
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;//保存
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+",javascript:onClean(),_self} " ;//清空
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82691,user.getLanguage())+",javascript:onCheckSQL(),_self} " ;//检测SQL
%>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:onSave();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(15504, user.getLanguage()) %>" class="e8_btn_top" id="cleanBtn" onclick="javascript:onClean();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82691, user.getLanguage()) %>" class="e8_btn_top" id="cleanBtn" onclick="javascript:onCheckSQL();"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table> 
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="{'groupDisplay':'none'}"><!-- 基本信息 -->
		<wea:item attributes="{'isTableList':'true'}">
			<jsp:include page="/formmode/interfaces/shareDesign.jsp">
				<jsp:param name="modeid" value="<%=modeid %>" />
				<jsp:param name="rightid" value="<%=rightid %>" />
 			</jsp:include>
		</wea:item>
	</wea:group>
</wea:layout>
<script language=javascript>
	var dialog = parent.parent.getDialog(parent);
	var parentWin = parent.parent.getParentWindow(parent);
	$(document).ready(function(){
  		resizeDialog(document);
  		settitle();
	});
	function settitle(){
		var navname = "<%=titlename%>";
		parent.setTabObjName(navname);
	}
	function closeDialog(){
		dialog.close();
	}
	
	
	function setConditionElement(){
		closeDialog();
	}
</script>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>
