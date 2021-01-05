<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	</HEAD>
	<body>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(1867,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	String moduleManageDetach = Util.null2String(request.getParameter("moduleManageDetach"));//(模块管理分权-分权管理员专用)
	String typeid = Util.null2String(request.getParameter("typeid"));
%>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/leftMenuCommon.jsp"%>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
				BaseBean baseBean_self = new BaseBean();
				int userightmenu_self = 1;
				try{
					userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
				} catch(Exception e) {}
				if(userightmenu_self == 1){
					RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnsearch_onclick(),_self} " ;
					RCMenuHeight += RCMenuHeightStep ;
					RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:reset_onclick(),_self} " ;
					RCMenuHeight += RCMenuHeightStep ;
					RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
					RCMenuHeight += RCMenuHeightStep ;
					RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
					RCMenuHeight += RCMenuHeightStep ;
					RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
					RCMenuHeight += RCMenuHeightStep ;
				}
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td>
					</td>
					<td class="rightSearchSpan" style="text-align: right;">
						<input type=button class="e8_btn_top" onclick="btnsearch_onclick()" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>"></input>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
		<FORM NAME="SearchForm" id="SearchForm" STYLE="margin-bottom: 0" action="MultiSelect.jsp" method=post target="frame2" onsubmit="onSubmit();">
			<div style="width:0px;height:0px;overflow:hidden;">
				<button type="submit" /></button>
			</div>
			<input type="hidden" name="isinit" value="1" />
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(81651,user.getLanguage())%></wea:item>
					<wea:item>
						<input class="inputstyle" id="workflowname" name="workflowname">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(33234, user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="typeid"
							browserValue='<%=typeid%>'
							browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
							hasInput="true" isSingle="true"
							hasBrowser="true" isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser"
							browserDialogWidth="600px"
							browserSpanValue='<%=WorkTypeComInfo.getWorkTypename(typeid)%>'></brow:browser>
					</wea:item>
				</wea:group>
			</wea:layout>

			<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
			<input class=inputstyle type="hidden" name="workflowids">
			<input class=inputstyle type="hidden" name="tabid">
			<input class=inputstyle type="hidden" name="moduleManageDetach" id="moduleManageDetach">
		</FORM>

		<script language="javascript">
			var dialog = null;
			try {
				dialog = parent.parent.parent.getDialog(parent.parent);
			} catch(ex1) {}

			function reset_onclick() {
				jQuery('#workflowname').val('');
				_writeBackData('typeid','1',{'id':'','name':''});
			}

			function btnclear_onclick() {
				var returnjson = {id:"",name:""};
				if (dialog) {
					try {
				    	dialog.callback(returnjson);
				    } catch(e) {}
					try {
				  		dialog.close(returnjson);
				 	} catch(e) {}
				} else {
					window.parent.parent.returnValue = returnjson;
			    	window.parent.parent.close();
				}
			}

			function btnok_onclick() {
				window.parent.frame2.btnok.click();
			}

			function btncancel_onclick(){
				if(dialog) {
				  	dialog.close();
				} else {
				   window.parent.parent.close();
				}
			}

			function onSubmit() {
				jQuery("input[name=workflowids]").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
			    jQuery("input[name=tabid]").val(1);  
			    jQuery("#moduleManageDetach").val("<%=moduleManageDetach%>");  
			}
			function btnsearch_onclick() {
				onSubmit();      
				$("#SearchForm").submit();
			}
		</script>
	</BODY>
</HTML>
