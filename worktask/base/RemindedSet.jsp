
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<script language=javascript src="/js/weaver_wev8.js"></script>

<html>
<%
	int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
	int remindtype = 0;
	int beforestart = 0;
	int beforestarttime = 0;
	int beforestarttype = 0;
	int beforestartper = 0;
	int beforeend = 0;
	int beforeendtime = 0;
	int beforeendtype = 0;
	int beforeendper = 0;
	rs.execute("select * from worktask_base where id="+wtid);
	if(rs.next()){
		remindtype = Util.getIntValue(rs.getString("remindtype"), 0);
		beforestart = Util.getIntValue(rs.getString("beforestart"), 0);
		beforestarttime = Util.getIntValue(rs.getString("beforestarttime"), 0);
		beforestarttype = Util.getIntValue(rs.getString("beforestarttype"), 0);
		beforestartper = Util.getIntValue(rs.getString("beforestartper"), 0);
		beforeend = Util.getIntValue(rs.getString("beforeend"), 0);
		beforeendtime = Util.getIntValue(rs.getString("beforeendtime"), 0);
		beforeendtype = Util.getIntValue(rs.getString("beforeendtype"), 0);
		beforeendper = Util.getIntValue(rs.getString("beforeendper"), 0);
	}
	String url_pra = "remindtype="+remindtype+"&beforestart="+beforestart+"&beforestarttime="+beforestarttime+"&beforestarttype="+beforestarttype+"&beforestartper="+beforestartper+"&beforeend="+beforeend+"&beforeendtime="+beforeendtime+"&beforeendtype="+beforeendtype+"&beforeendper="+beforeendper;
	//System.out.println(url_pra);
	String startTimeType = "";
	String endTimeType = "";
	if(beforestarttype == 0){
		startTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
	}else if(beforestarttype == 1){
		startTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
	}else{
		startTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
	}
	if(beforeendtype == 0){
		endTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
	}else if(beforeendtype == 1){
		endTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
	}else{
		endTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
	}
%>

<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>

<body>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveData(this),_self} " ;    
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(21931,user.getLanguage())+",javascript:useSetto(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
			   <td>
				</td>
				<td class="rightSearchSpan" style="text-align:right; ">
					<input type="button"
				value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
				class="e8_btn_top middle" onclick="doSave(this);">
				<input type="button"
				value="<%=SystemEnv.getHtmlLabelName(21931, user.getLanguage())%>"
				class="e8_btn_top middle" onclick="useSetto();">
			<span title="<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<form name="frmmain" id="frmmain" method="post" action="wt_Operation.jsp">
<input type="hidden" name="src" value="" >
<input type="hidden" name="wtid" value="<%=wtid%>" >
  <wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
			<wea:item><%=SystemEnv.getHtmlLabelName(18713, user.getLanguage())%></wea:item>
			<wea:item>
				<INPUT type="radio" value="0" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 0) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
				<INPUT type="radio" value="1" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 1) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
				<INPUT type="radio" value="2" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 2) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
			</wea:item>
			<wea:item attributes="{'samePair':\"sectr\"}"><%=SystemEnv.getHtmlLabelName(785, user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':\"sectr\"}">
				 <INPUT type="checkbox" name="beforestart" id="beforestart" value="1" <% if(beforestart == 1) { %>checked<% } %>>
				<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
				<INPUT class="InputStyle" type="input" name="beforestarttime" id="beforestarttime" style="width: 40px;" value="<%= beforestarttime%>" onChange="inputChangeCheckBox('beforestarttime','beforestart')">
				<select name="beforestarttype" id="beforestarttype" onChange="onChangeStartTimeType()" style="width:50px">
					<option value="0" <%if(beforestarttype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
					<option value="1" <%if(beforestarttype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
					<option value="2" <%if(beforestarttype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
				</select>
			</wea:item>
			<wea:item attributes="{'samePair':\"sectr\"}"><%=SystemEnv.getHtmlLabelName(18080, user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':\"sectr\"}">
				 <%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="beforestartper" id="beforestartper"  style="width: 40px;"  onChange="inputint('beforestartper')" value="<%=beforestartper%>">
					<span id="beforestarttypespan" name="beforestarttypespan"><%=startTimeType%></span>
			</wea:item>
			<wea:item attributes="{'samePair':\"sectr\"}"><%=SystemEnv.getHtmlLabelName(785, user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':\"sectr\"}">
				 <INPUT type="checkbox" name="beforeend" id="beforeend" value="1" <% if(beforeend == 1) { %>checked<% } %>>
						<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
						<INPUT class="InputStyle" type="input" name="beforeendtime" id="beforeendtime"   style="width: 40px;" value="<%= beforeendtime%>" onChange="inputChangeCheckBox('beforeendtime','beforeend')">
						<select name="beforeendtype" id="beforeendtype" onChange="onChangeEndTimeType()" >
							<option value="0" <%if(beforeendtype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
							<option value="1" <%if(beforeendtype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
							<option value="2" <%if(beforeendtype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
						</select>
			</wea:item>
			<wea:item attributes="{'samePair':\"sectr\"}"><%=SystemEnv.getHtmlLabelName(18080, user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':\"sectr\"}">
						<%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%>
						<INPUT class="InputStyle" type="input" name="beforeendper" id="beforeendper"   style="width: 40px;" onChange="inputint('beforeendper')" value="<%=beforeendper%>">
						<span id="beforeendtypespan" name="beforeendtypespan"><%=endTimeType%></span>
			</wea:item>
		</wea:group>
	</wea:layout>

</form>

<script language=javascript>


function inputChangeCheckBox(inputid,checkboxid){
  var obj = $("#"+inputid);
  if(obj.val() !='' && !isNaN(obj.val()) && obj.val()>0){
     changeCheckboxStatus($("#"+checkboxid),true);
  }else{
     obj.val("0");
  }
}

function inputint(inputid){
 var obj = $("#"+inputid);
  if(isNaN(obj.val()) || obj.val()==""){
     obj.val("0");
  }
}

function saveData(obj){
	if(checkWorkPlanRemind()){
		frmmain.src.value="saveremind";
		frmmain.submit();
		enableAllmenu();
	}
}
function ItemCount_KeyPress_self(event){
	event = jQuery.event.fix(event);
	if(!((event.keyCode>=48) && (event.keyCode<=57))){
		event.keyCode=0;
	}
}

function showRemindTime(obj){
	if("0" == obj.value){
		hideEle("sectr", true);
	}else{
		showEle("sectr");
	}
}

function checkWorkPlanRemind(){
	//alert(document.frmmain.remindtype);
	if(document.frmmain.remindtype[0].checked == false){
		if(document.frmmain.beforestart.checked || document.frmmain.beforeend.checked){
			return true;
		}else{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21978, user.getLanguage())%>");
			return false;
		}
	}else{
		document.frmmain.beforestart.checked = false;
		document.frmmain.beforeend.checked = false;
		document.frmmain.beforestarttime.value = 0;
		document.frmmain.beforeendtime.value = 0;
		document.frmmain.beforestartper.value = 0;
		document.frmmain.beforeendper.value = 0;
		return true;
	}
}
function onChangeStartTimeType(){
	var timeTypeText = jQuery("select[name=beforestarttype] option:selected").html();
	document.getElementById("beforestarttypespan").innerHTML = timeTypeText;
}
function onChangeEndTimeType(){
	var timeTypeText = jQuery("select[name=beforeendtype] option:selected").html();
	document.getElementById("beforeendtypespan").innerHTML = timeTypeText;
}

function MainCallback(){
	dialog.close();
	window.location.reload();
}


function useSetto(){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(21931,user.getLanguage()) %>";
    dialog.URL = "/worktask/base/WorktaskList.jsp?wtid=<%=wtid%>&usesettotype=0";
	dialog.Width = 660;
	dialog.Height = 660;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.show();
}

jQuery(document).ready(function(){
	<% if(remindtype == 0){%>
	   hideEle("sectr", true);
	<%}%>
});
</script>
</body>
</html>
