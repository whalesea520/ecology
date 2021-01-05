<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-05-21[流程表单] -->
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelNames("18015,15590",user.getLanguage());
	String sqlwhere = xssUtil.put(strUtil.vString(request.getParameter("sqlwhere")));
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<script type="text/javascript">
			var resourceids = "";
			var resourcenames = "";
			function btnclear_onclick() {
				window.parent.parent.returnValue = {id:"", name:""};
				window.parent.parent.close();
			}
			function btnok_onclick() {
				setResourceStr();
				replaceStr();
				window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
				window.parent.parent.close();
			}
			function btncancel_onclick() {
				window.close();
			}
			function btnsearch_onclick() {
				setResourceStr();
				$("input[name=resourceids]").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
				$("#SearchForm").submit();
			}
			function setResourceStr() {
				var resourceids1 = "";
				var resourcenames1 = "";
				try {
					for(var i=0; i<parent.frame2.resourceArray.length; i++) {
						resourceids1 += ","+parent.frame2.resourceArray[i].split("~")[0];
						resourcenames1 += ","+parent.frame2.resourceArray[i].split("~")[1];
					}
					resourceids = resourceids1;
					resourcenames = resourcenames1;
				}catch(e){}
			}
			function replaceStr() {
				var re = new RegExp("[ ]*[|][^|]*[|]", "g");
				resourcenames = resourcenames.replace(re, "|");
				re = new RegExp("[|][^,]*", "g");
				resourcenames = resourcenames.replace(re, "");
			}
		</script>
	</head>
	<body style="overflow:hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			TopMenu topMenu = new TopMenu(out, user);
			topMenu.addRight(SystemEnv.getHtmlLabelName(197,user.getLanguage()), "document.SearchForm.btnsearch.click()");
			topMenu.addRight(SystemEnv.getHtmlLabelName(199,user.getLanguage()), "document.SearchForm.reset.click()");
			RCMenu += topMenu.getRightMenus();
			RCMenuHeight += RCMenuHeightStep * topMenu.size();
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%topMenu.show();%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form id="SearchForm" name="SearchForm" style="margin-bottom:0" action="/hrm/attendance/workflowBill/multiSelect.jsp" method="post" target="frame2">
			<button accessKey="S" style="display:none" id="btnsearch" class="btnSearch" onclick="btnsearch_onclick()" type="button"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></button>
			<button accessKey="T" style="display:none" id="reset" class="btnReset" type="reset"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></button>
			<button accessKey="O" style="display:none" id="btnok" class="btn" onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></button>
			<button accessKey="T" style="display:none" id="btncancel" class="btnReset" onclick="btncancel_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></button>
			<button accessKey="2" style="display:none" id="btnclear" class="btn" onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></button>
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(18411,user.getLanguage())%></wea:item>
					<wea:item>
						<select name="isBill">
							<option value=""></option>
							<option value="0"><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></option>
							<option value="1"><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></option>
						</select>		
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
					<wea:item><input type="text" id="namelabel" name="namelabel" class="inputStyle" value=""></wea:item>
				</wea:group>
			</wea:layout>
			<input type="hidden" name="resourceids">
			<input type="hidden" name="isinit" value="1"/>
			<input type="hidden" name="sqlwhere" value="<%=sqlwhere%>">
		</form>
	</body>
</html>
