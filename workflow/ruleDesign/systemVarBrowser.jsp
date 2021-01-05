
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.workflow.ruleDesign.RuleBean"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<style>
	.BroswerStyle td
	{
		padding-left:10px;	
	}
</style>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
	<jsp:param name="mouldID" value="workflow"/>
	<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33749,user.getLanguage())%>"/>
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:searchrule(),_top} " ;
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id="container">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			
	       	<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
      <TH width=25%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
      <TH width=30%><%=SystemEnv.getHtmlLabelName(24256,user.getLanguage())%></TH>
      <TH width=45%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
      </tr><TR class=Line style="height: 1px"><TH colspan="4" ></TH></TR>

<TR class=DataLight>
<TD><A HREF=#>manager</A><input type="hidden" value="1" /></TD>
	<TD><%=SystemEnv.getHtmlLabelName(596, user.getLanguage())%></TD>
	<TD><%=SystemEnv.getHtmlLabelNames("20558,596",user.getLanguage()) %></TD>
</TR>

<TR class=DataDark>
	<TD><A HREF=#>currentOperator</A><input type="hidden" value="2" /></TD>
	<TD><%=SystemEnv.getHtmlLabelName(20558, user.getLanguage())%></TD>
	<TD><%=SystemEnv.getHtmlLabelNames("18015,20558",user.getLanguage()) %></TD>
</TR>
<TR class=DataLight>
<TD><A HREF=#>currentDate</A><input type="hidden" value="3" /></TD>
	<TD><%=SystemEnv.getHtmlLabelName(15626, user.getLanguage())%></TD>
	<TD><%=SystemEnv.getHtmlLabelName(129408, user.getLanguage())%></TD>
</TR>

</TABLE>
</div>
<script language=javascript>
	var dialog = parent.parent.getDialog(parent);
	$(document).ready(function(){
  		resizeDialog(document);
	});
</script>
<div id="footer">
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout>
			<wea:group context="" attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" id="zd_btn_submit"  class="zd_btn_submit" onclick="dialog.close()">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage()) %>" id="zd_btn_clean"  class="zd_btn_cancle" onclick="cleanValue()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
</div>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script type="text/javascript">
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
		var returnjson = {id:$(this).find("td:first").find("[type=hidden]").val(),name:$(this).find("td:first").next().text()};
		if(dialog){
			dialog.callback(returnjson);
		}else
		{
			window.parent.returnValue = returnjson;
		  	window.parent.close();
		}	
	})
})

function cleanValue()
{
	var returnjson = {id:"",name:"",condit:""};
	if(dialog){
		dialog.callback(returnjson);
	}else
	{
		window.parent.returnValue = returnjson;
	  	window.parent.close();
	}
}

</script>
</BODY></HTML>

