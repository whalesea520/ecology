
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-07-04 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="CareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="page"/>
<%
	String id = Util.null2String(request.getParameter("id"));
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(6134,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(356,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%
			String backFields = " a.id, b.name, tester, testdate, result, remark ";
			String sqlFrom = "from HrmInterviewResult a, HrmCareerInviteStep b ";
			String sqlWhere = "where a.stepid = b.id  and resourceid = "+id;
			String orderby = "" ;
			
			String operateString= "";
			String tableString=""+
				"<table pageId=\""+Constants.HRM_Z_054+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_054,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
					operateString+
					"<head>"+                             
						"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(15694,user.getLanguage())+"\"  column=\"name\" orderkey=\"15694\"/>"+ 
						"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(15662,user.getLanguage())+"\"  column=\"tester\" orderkey=\"tester\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+ 
						"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(15702,user.getLanguage())+"\" column=\"testdate\" orderkey=\"testdate\"/>"+
						"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15703,user.getLanguage())+"\" column=\"result\" orderkey=\"result\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";0=15690,1=15376,2=15689]}\"/>"+
						"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(15698,user.getLanguage())+"\" column=\"remark\" orderkey=\"remark\"/>"+
					"</head>"+
				"</table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.close();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
	</BODY>
</HTML>
