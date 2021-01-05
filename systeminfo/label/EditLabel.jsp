<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("System:LabelManage", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String error = Util.null2String(request.getParameter("error"));
int labelId = Util.getIntValue(request.getParameter("id"),-1);
String indexdesc = "";
rs.executeSql("select indexdesc from HtmlLabelIndex where id="+labelId);
if(rs.next()){
	indexdesc = Util.null2String(rs.getString(1));
}
rs.executeSql("select * from syslanguage  where activable=1 order by id asc");
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/characterConv_wev8.js"></script>
<script language=javascript >
function onSave(){
	if(check_form(weaver,"indexdesc")){
		document.getElementById("weaver").submit();
	}
}

function setCName(obj,flag){
	if(flag==1){
		if(obj.value){
			jQuery("#name_7").val(Simplized(obj.value));
		}
	}else{
		if(!jQuery("#name_7").val()){
			jQuery("#name_7").val(obj.value);
			jQuery("#name_7").trigger("change");
		}
	}
}

function setTWName(obj){
	jQuery("#name_9").val(Traditionalized(obj.value));
}

var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=error%>"=="1"){
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31877,user.getLanguage())%>");
}
	if("<%=isclose%>"=="1"){
		try{
			parentWin._table.reLoad();
		}catch(e){}
		dialog.close();	
	}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(81486,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form id="weaver" name="weaver" action="LabelOperation.jsp" method=post>
<wea:layout>
		<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item>
				ID
			</wea:item>
			<wea:item>
				<input type="hidden" name="id" id="id" value="<%=labelId %>"/>
				<%=labelId %>
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<%if(labelId<0){ %>
					<wea:required id="indexdescspan" required="true" value='<%=indexdesc %>'>
						<INPUT class=InputStyle maxLength=255 size=60 name="indexdesc" value="<%=indexdesc %>" temptitle="<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>" 
		          		onChange="checkinput('indexdesc','indexdescspan');setCName(this);">
	           		</wea:required>
	           	<%}else{ %>
	           		<%=indexdesc %>
	           	<%} %>
			</wea:item>
		</wea:group>
		<wea:group context='<%= SystemEnv.getHtmlLabelNames("176,33439",user.getLanguage())%>'>
			<wea:item attributes="{'isTableList':'true'}">
				<wea:layout needImportDefaultJsAndCss="false" type="table" attributes="{'cols':'2','cws':'40%,60%'}">
					<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("176,33439",user.getLanguage())%></wea:item>
						<%while(rs.next()){ %>
							<wea:item><%= rs.getString("language")%></wea:item>
							<wea:item>
								<%if(rs.getInt("id")==7){ %>
									<input class="InputStyle" type="text" id="name_<%=rs.getInt("id") %>" value="<%= SystemEnv.getHtmlLabelName(labelId,rs.getInt("id"),true)%>" name="name_<%=rs.getInt("id") %>" onchange="setTWName(this);"/>
								<%}else if(rs.getInt("id")==9){ %>
									<input class="InputStyle" type="text" id="name_<%=rs.getInt("id") %>" value="<%= SystemEnv.getHtmlLabelName(labelId,rs.getInt("id"),true)%>" name="name_<%=rs.getInt("id") %>" onchange="setCName(this,1);"/>
								<%}else{ %>
									<input class="InputStyle" type="text" id="name_<%=rs.getInt("id") %>" value="<%= SystemEnv.getHtmlLabelName(labelId,rs.getInt("id"),true)%>" name="name_<%=rs.getInt("id") %>"/>
								<%} %>
							</wea:item>
						<%} %>
					</wea:group>
				</wea:layout>
			</wea:item>
			
		</wea:group>
	</wea:layout>
          <input type=hidden value="editLabel" name="operation">
</FORM>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</BODY></HTML>
