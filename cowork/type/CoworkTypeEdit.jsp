
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="weaver.cowork.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>
<%

if(! HrmUserVarify.checkUserRight("collaborationarea:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
String logintype = user.getLogintype();
int userid=user.getUID();
String hrmid = Util.null2String(request.getParameter("hrmid"));
String typename="";
String departmentid="";
String managerid="";
String members="";
String isApproval="";
String isAnonymous="";
ConnStatement statement=new ConnStatement();
String sql="select * from cowork_types where id="+id;
boolean isoracle = (statement.getDBType()).equals("oracle");
try {
	statement.setStatementSql(sql);
	statement.executeQuery();
	if(statement.next()){
		typename = Util.toScreen(statement.getString("typename"),user.getLanguage());
		departmentid = Util.toScreen(statement.getString("departmentid"),user.getLanguage());
		isApproval = Util.toScreen(statement.getString("isApproval"),user.getLanguage());
		isAnonymous = Util.toScreen(statement.getString("isAnonymous"),user.getLanguage());
	}
}finally{
	statement.close();
}

boolean canDel = true;
if(id!=0){
	sql="select id from cowork_items where typeid="+id;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		canDel = false;
	}
}


String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17694,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),''} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="collaboration"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("93,83209",user.getLanguage())%>'/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="onSave()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name=frmMain action="TypeOperation.jsp" method=post>
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<wea:layout>
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="nameimage" required="true">
				<INPUT class=inputstyle type=text maxLength=60 size=25 name=name id="name" value="<%=typename%>" 
					onchange='checkinput("name","nameimage")' style="width: 150px;">
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></wea:item>
		<wea:item>
			<select name=departmentid id=dpid>
			<%while(CoMainTypeComInfo.next()){%>
				<option value="<%=CoMainTypeComInfo.getCoMainTypeid()%>" <%if(departmentid.equals(CoMainTypeComInfo.getCoMainTypeid())){%> selected <%}%>><%=CoMainTypeComInfo.getCoMainTypename()%></option>
			<%}%>
			</select>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(31449,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="isApproval" id="isApproval" <%=isApproval.equals("1")?"checked=checked":""%> value="1">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(18576,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="isAnonymous" id="isAnonymous" <%=isAnonymous.equals("1")?"checked=checked":""%> value="1">
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>

<script language=javascript>
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);	
function onSave() {
		var coworkname = $("#name").val();
		var typename = '<%=typename%>';		
		var isAnonymous=$("#isAnonymous").attr("checked")?"1":"0";
		var isApproval=$("#isApproval").attr("checked")?"1":"0";
		$.post("/cowork/type/CoworkTypeCheck.jsp",{coworkname:encodeURIComponent($("#name").val()),departmentid:$("#dpid").val(),id:'<%=id%>'},function(datas){  
				 if(datas.indexOf("unfind") > 0 && check_form(frmMain,'name,departmentid')){
				 		//document.frmMain.operation.value="edit";
						//document.frmMain.submit();
						
						$.post("TypeOperation.jsp?operation=edit",{"name":$("#name").val(),id:<%=id%>,departmentid:$("#dpid").val(),isAnonymous:isAnonymous,isApproval:isApproval},function(){
							parent.getParentWindow(window).callback();	
						})
						
				 } else if (datas.indexOf("exist") > 0){				 	  
				 	  alert("<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> [ "+coworkname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
				 }
		});
}
function onDelete(){
	if(<%=canDel%>==false){
		alert("<%=SystemEnv.getHtmlLabelName(18864,user.getLanguage())%>");
		return;
	}
	if(isdel()) {
		//document.frmMain.operation.value="delete";
		//document.frmMain.submit();
		$.post("TypeOperation.jsp?operation=delete&name="+$("#name").val(),{id:<%=id%>,departmentid:<%=departmentid%>},function(){
			window.parent._table.reLoad();
			parentDialog.close();
		})
	}
}

function changeView(viewFlag,hiddenspan,accepterspan,flag){
	try {
		if(flag==1){
			document.getElementById(viewFlag).style.display='none';
			document.getElementById(hiddenspan).style.display='';
			document.getElementById(accepterspan).style.display='';
		}
		if(flag==0){
			document.getElementById(viewFlag).style.display='';
			document.getElementById(hiddenspan).style.display='none';
			document.getElementById(accepterspan).style.display='none';
		}
	}
	catch(e) {}
}

function back()
{
	window.history.back(-1);
}


$(function(){
	checkinput("name","nameimage");
});

jQuery(document).ready(function(){
	 jQuery("input[type=checkbox]").each(function(){
		  if(jQuery(this).attr("tzCheckbox")=="true"){
		   	jQuery(this).tzCheckbox({labels:['','']});
		  }
	 });
});
 </script>
</BODY></HTML>
