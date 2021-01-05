
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="CheckSubCompanyRight"	class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	int layoutid=0;
	if(request.getParameter("layoutid")!=null && request.getParameter("method").equalsIgnoreCase("show")){
		layoutid = Util.getIntValue(request.getParameter("layoutid"),0);
	}else{
		return;
	}
	String titlename = SystemEnv.getHtmlLabelName(23018, user.getLanguage());
	String infoname = Util.null2String(request.getParameter("infoname"));
%>
<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script type="text/javascript">
	$(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:onSearch});
	});
	</script>
</head>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(22967,user.getLanguage()) %>"/> 
		</jsp:include>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form id="searchPortalForm" name="searchPortalForm" method="post" action="LayoutRelatedHomepage.jsp">
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="75px">					
			</td>
			<!-- td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="text" class="searchInput" name="infoname" value="<%=infoname %>"/>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td-->
		</tr>
	</table>
	<div class="advancedSearchDiv" id="advancedSearchDiv">
	</div>
</form>
<form name="frmAdd" method="post" action="LayoutRelatedHomepage.jsp">
<input name="method" type="hidden">
<TEXTAREA id="areaResult" NAME="areaResult" ROWS="2" COLS="30" style="display:none"></TEXTAREA>
	<!--列表部分-->
	<%
	//得到pageNum 与 perpage
	int pagenum = Util.getIntValue(request.getParameter("pagenum"),1) ;
	int perpage =100;
	//设置好搜索条件
	String 	sqlWhere=" where layoutid = "+layoutid;
	String tableString = "<table  pagesize=\""+perpage+"\" tabletype=\"none\" valign=\"top\">"+
	   "<sql backfields=\"id,infoname,subcompanyid,hpcreatorid,hplastdate\" sqlform=\" from hpinfo \"  sqlorderby=\"subcompanyid\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />"+
	   "<head >"+
		 "<col width=\"5%\"  text=\"ID\"   column=\"id\" orderkey=\"id\" />"+
		 "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\"  column=\"infoname\" orderkey=\"infoname\" />"+
		 "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" orderkey=\"subcompanyid\"/>"+
		 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"hpcreatorid\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getPortalCreator\" />"+									  
		 "<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(19520,user.getLanguage())+"\" column=\"hplastdate\" />"+
	   "</head></table>";
	%>
	<TABLE width="100%">
		<TR>
			<TD valign="top">
				<wea:SplitPageTag tableString='<%=tableString%>' mode="run" isShowTopInfo="true" isShowBottomInfo="true" />
			</TD>
		</TR>
	</TABLE>
</form>	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<table width="100%">
			    <tr><td style="text-align:center;" colspan="3">
			     <input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
			    </td></tr>
			</table>
</div>
</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
	$(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:onSearch});
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
	});
	
	function onSearch(){
		searchPortalForm.submit();
	}
	function onCancel(){
		var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
		dialog.close();
	}
</SCRIPT>
