
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

String _guid1 = Util.null2String(request.getParameter("_guid1"));
%>
<html>
	<head>
		<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
	</head>
	<body>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.btnsearch.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="MultiFnaRptSelect.jsp" method=post target="frame2">
			<button class=btnSearch accessKey=S style="display:none" type="button" onclick="btnsearch_onclick()"  id="btnsearch" ><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></button>
			<button class=btnReset accessKey=T style="display:none" id=reset type="reset"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></button>
			<input type="hidden" name="isinit" value="1"/>
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
					<wea:item> 
					  <input class="inputstyle" id="orgName" name="orgName" value="" />
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1321,user.getLanguage())%></wea:item>
					<wea:item> 
					  <input class="inputstyle" id="orgCode" name="orgCode" value="" />
					</wea:item>
				</wea:group>
			</wea:layout>
			<input class=inputstyle type="hidden" id="selectids" name="selectids" />
			<input class=inputstyle type="hidden" id="_guid1" name="_guid1" value="<%=_guid1 %>" />
		</form>
		<script language="javascript">
			function btnsearch_onclick(){
				jQuery("#selectids").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
				jQuery("#SearchForm").submit();
			}

			function replaceStr(){
				var re=new RegExp("[ ]*[|][^|]*[|]","g")
				orgNames=orgNames.replace(re,"|")
				re=new RegExp("[|][^,]*","g")
				orgNames=orgNames.replace(re,"")
			} 
		</script>
	</body>
</html>
