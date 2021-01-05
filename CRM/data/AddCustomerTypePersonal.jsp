
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<HTML>
<head>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
	

	String mainType = "2";//客户状态 【0为type；1为description；2为status；3为size】
	String subType = "1";//客户描述【0为type；1为description；2为status；3为size】
	
	String operation = Util.null2String(request.getParameter("operation"));
	if(!"".equals(operation)){
		mainType = Util.null2String(request.getParameter("mainType"));
		subType = Util.null2String(request.getParameter("subType"));
		
		RecordSet.execute("select * from CRM_CustomerTypePersonal where userId = "+user.getUID());
		if(RecordSet.getCounts() != 0 ){
			rs.execute("update CRM_CustomerTypePersonal set mainType = "+mainType+" , subType = "+subType+" where userId = "+user.getUID());
		}else{
			rs.execute("insert into CRM_CustomerTypePersonal(userId , mainType ,subType) values("+user.getUID()+","+mainType+" , "+subType+")");
		}
		
		return;
	}
	
	
	RecordSet.execute("select mainType , subType from CRM_CustomerTypePersonal where userId = "+user.getUID());
	while(RecordSet.next()){
		mainType = RecordSet.getString("mainType");
		subType = RecordSet.getString("subType");
	}
	
	
	
%> 

<script>

function doSave(){
	if(jQuery("#mainType").val() == jQuery("#subType").val()){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84350,user.getLanguage())%>");
		return;
	}
	jQuery.post("/CRM/data/AddCustomerTypePersonal.jsp?operation=update&"+new Date().getTime(),jQuery("form").serialize(),function(){
		parent.getParentWindow(window).refreshTab(jQuery("#mainType").val(),jQuery("#subType").val());
	});		
}
</script>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(455,user.getLanguage())+SystemEnv.getHtmlLabelName(343,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form>    
<wea:layout>
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item><%=SystemEnv.getHtmlLabelName(863,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="mainType" id="mainType" onchange="showInfo(obj)">
				<option value="0" <%if(mainType.equals("0")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%></option>
				<option value="1" <%if(mainType.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(1283,user.getLanguage())%></option>
				<option value="2" <%if(mainType.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%></option>
				<option value="3" <%if(mainType.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(1285,user.getLanguage())%></option>
			</select>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(1281,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="subType" id="subType" onchange="showInfo(obj)">
				<option value="0" <%if(subType.equals("0")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%></option>
				<option value="1" <%if(subType.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(1283,user.getLanguage())%></option>
				<option value="2" <%if(subType.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%></option>
				<option value="3" <%if(subType.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(1285,user.getLanguage())%></option>
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
</body>
</html>
