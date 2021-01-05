
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(19828,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
String needfav ="1";
String needhelp ="";

String showTop = Util.null2String(request.getParameter("showTop"));
%>

<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />

<script language="javascript">
 function  MailRuleSubmit(){
     
     if(check_form(fMailRule,'ruleName')){
		fMailRule.submit();
	}
 }
 
 
 
</script>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:MailRuleSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19828,user.getLanguage())%>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="MailRuleSubmit()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="MailRuleOperation.jsp" id="fMailRule" name="fMailRule">
<input type="hidden" name="operation" value="add" />
<input type="hidden" name="ruleConditionRowIndex" id="ruleConditionRowIndex" value="10," />
<input type="hidden" name="ruleActionRowIndex" id="ruleActionRowIndex" value="16," />
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19834,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(19829,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="ruleNameSpan" required="true">
				<input type="text" name="ruleName" class="inputstyle" onchange="checkinput('ruleName','ruleNameSpan')" style="width:30%"/>
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(19835,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="radio" id="matchAll0" name="matchAll" value="0" checked="checked" /><label for="matchAll0" class="ruleDefine" style="font-weight: normal !important"><%=SystemEnv.getHtmlLabelName(19836,user.getLanguage())%></label>
			<input type="radio" id="matchAll1" name="matchAll" value="1" /><label for="matchAll1" class="ruleDefine" style="font-weight: normal !important"><%=SystemEnv.getHtmlLabelName(19837,user.getLanguage())%></label>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(19838,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="radio" id="applyTime0" name="applyTime" value="0" checked="checked" /><label for="applyTime0" class="ruleDefine" style="font-weight: normal !important"><%=SystemEnv.getHtmlLabelName(19839,user.getLanguage())%></label>
			<input type="radio" id="applyTime1" name="applyTime" value="1" /><label for="applyTime1" class="ruleDefine" style="font-weight: normal !important"><%=SystemEnv.getHtmlLabelName(19840,user.getLanguage())%></label>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(19830,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="mailAccountId" style="width:150px;">
				<option value="-1"><%=SystemEnv.getHtmlLabelName(31350,user.getLanguage())%></option>
				<%rs.executeSql("SELECT * FROM MailAccount WHERE userId="+user.getUID()+"");while(rs.next()){%>
					<option value="<%=rs.getInt("id")%>"><%=rs.getString("accountName")%></option>
				<%}%>
			</select>
		</wea:item>
	
	</wea:group>
</wea:layout>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</form>
