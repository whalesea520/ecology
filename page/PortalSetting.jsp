
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="java.io.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/workflow/request/CommonUtils.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+ $label(86,user.getLanguage()) +",javascript:pager.doSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
	
	RecordSet.executeProc("SystemSet_Select","");
	RecordSet.next();
	String rsstype = Util.null2String(RecordSet.getString("rsstype"));
	String refreshTime = Util.null2String(RecordSet.getString("refreshMins"));
	String needRefresh = Util.null2String(RecordSet.getString("needRefresh"));
	String showlasthp = Util.null2String(RecordSet.getString("showlasthp"));
	
%>
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/proj/js/common_wev8.js"></script>

		<script>
			jQuery(document).ready(function(){
				pager.init();
			});
			
			var pager = {
				defaultOvertimeValue : '',
				init : function(){

					pager.bind();
				},
				
				bind : function(){
					
				},
				
				doSave : function(){
					$('#weaver').submit();
				}
			};
		function changeDiv(obj,target){
			if(jQuery(obj).attr("checked")){
				showEle(target);
			}else{
				hideEle(target);
			}
			
		}	
		</script>
	</head>
	<body>
		<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=$label(33672,user.getLanguage())%>"/>
		</jsp:include>

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">				
					<input id="btnSave" type="button" value="<%=$label(86,user.getLanguage()) %>" class="e8_btn_top" onclick="pager.doSave()" />
					<span title="<%=$label(83721,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>

		<form id="weaver" name="frmmain" action="PortalSettingOperation.jsp" method="post" >
			<wea:layout type="twoCol" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=$label(33393,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
					<% 
				String attr = "{'samePair':'beforeDiv2','display':'"+(needRefresh.equals("1")?"":"none")+"'}";
				%>
				<wea:item><%=SystemEnv.getHtmlLabelName(33394,user.getLanguage())%></wea:item>
				<wea:item>
					 <input type="checkbox"  tzCheckbox="true" name=needRefresh  value="1" <% if(needRefresh.equals("1")) {%>checked<%}%>
						onclick="changeDiv(this,'beforeDiv2')" >
				</wea:item>
				<wea:item attributes='<%=attr %>'><%=SystemEnv.getHtmlLabelName(33395,user.getLanguage())%></wea:item>
				<wea:item attributes='<%=attr %>'>
				
						<INPUT class=InputStyle style="width: 40px;" maxLength=2 size=10 name="refreshTime" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("refreshTime")' value = "<%=refreshTime%>">
					
					&nbsp;<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
				</wea:item>
				<wea:item ><%=SystemEnv.getHtmlLabelName(21822,user.getLanguage())%></wea:item>
					<wea:item >
						 <select name="rsstype" >
						  	<option value="1" <%if(rsstype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(108,user.getLanguage())%></option>
						  	<option value="2" <%if(rsstype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())%></option>
						  </select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(83200,user.getLanguage())%></wea:item>
				<wea:item>
					 <input type="checkbox"  tzCheckbox="true" name=showlasthp  value="1" <% if(showlasthp.equals("1")) {%>checked<%}%>
						>
				</wea:item>
			</wea:group>
				
		</wea:layout>
		</form>
	</body>
</html>
