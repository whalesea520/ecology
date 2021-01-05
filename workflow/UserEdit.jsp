
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WfUserRef" class="weaver.workflow.workflow.WfUserRef" scope="page" />
<%
	String isclose=Util.null2String(request.getParameter("isclose"));
	String type=Util.null2String(request.getParameter("type"));
	int keyid=Util.getIntValue(Util.null2String(request.getParameter("keyid")),0);
	String name="";
	int usertype=0;
	String subcompanyids="",subcompanynames="";
	String departmentids="",departmentnames="";
	String userids="0",usernames="";
	String navName="";
	if(!"add".equals(type)&&keyid!=0){
		String sql="select name,usertype,userids from workflow_userref where keyid="+keyid;
		rs.executeSql(sql);
		if(rs.next()){
			name=Util.null2String(rs.getString("name"));
			usertype=Util.getIntValue(Util.null2String(rs.getString("usertype")),0);
			if(usertype==2){
				subcompanyids=Util.null2String(rs.getString("userids"));
				subcompanynames=WfUserRef.getSubCompanyNames(subcompanyids);
			}else if(usertype==3){
				departmentids=Util.null2String(rs.getString("userids"));
				departmentnames=WfUserRef.getDepartmentNames(departmentids);
			}else if(usertype==4){
				userids=Util.null2String(rs.getString("userids"));
				usernames=WfUserRef.getUserNames(userids);
			}
		}
		navName = SystemEnv.getHtmlLabelNames("18933",user.getLanguage());
	}else{
		navName = SystemEnv.getHtmlLabelNames("21945",user.getLanguage());
	}
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = ""+SystemEnv.getHtmlLabelName(84571,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  	<script language="javascript" src="../../js/weaver_wev8.js"></script>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<script>
		var dialog = null;
		var parentWin = null;
		try {
			parentWin = parent.getParentWindow(window);
			dialog = parent.getDialog(window);
		} catch (e) {}
		
		<%if("1".equals(isclose)){%>
			closeCurDialog();
		<%}%>
		
		function closeCurDialog(){
			try{
				parentWin.location.reload();
				dialog.close();
			}catch(e){}
		}
		
		jQuery(document).ready(function(){
			controlShow();
		});
		
		function controlShow(){
			var usertype=jQuery("[name='usertype']").val();
			var obj1=jQuery("td[_samepair='subcompany']").closest("tr");
			if(usertype=="2"){
				obj1.css("display","").next().css("display","");
			}else{
				obj1.css("display","none").next().css("display","none");
			}
			var obj2=jQuery("td[_samepair='department']").closest("tr");
			if(usertype=="3"){
				obj2.css("display","").next().css("display","");
			}else{
				obj2.css("display","none").next().css("display","none");
			}
			var obj3=jQuery("td[_samepair='user']").closest("tr");
			if(usertype=="4"){
				obj3.css("display","").next().css("display","");
			}else{
				obj3.css("display","none").next().css("display","none");
			}
		}
	
		function getObjWindowUrl(type) {
			var url="";
			if(type=="2"){
				var tmpids = jQuery("[name='subcompanyids']").val();
				url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+tmpids+"&selectedDepartmentIds="+tmpids;
			}else if(type=="3"){
				var tmpids = jQuery("[name='departmentids']").val();
				url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser1.jsp?selectedids="+tmpids+"&selectedDepartmentIds="+tmpids;
			}else if(type=="4"){
				var tmpids = jQuery("[name='userids']").val();
				url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids;
			}
			return url;
		}
	
  		function submitForm(){
  			if (check_form(userForm,'name')){
	  			document.userForm.action="UserOperation.jsp";
	  			document.userForm.submit();
  			}
  		}
    </script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitForm(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:closeCurDialog(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=navName %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td></td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:submitForm();"/>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<div class="zDialog_div_content">
<form id="userForm" name="userForm" method=post>
	<input type="hidden" name="src" value="save" />
  	<input type="hidden" name="keyid" value="<%=keyid %>" />
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(84572,user.getLanguage())%>'>
			<wea:item>IP</wea:item>
			<wea:item>
				<wea:required id="nameimage" required="true" value='<%=name %>'>
					<input class="Inputstyle" type="text" name="name" value="<%=name %>" onchange='checkinput("name","nameimage")' />
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(33234,user.getLanguage())%></wea:item>
			<wea:item>
				<select style="width:120px" name="usertype" onchange="controlShow();" value="<%=usertype %>">
					<option value="1" <%=usertype==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1340, user.getLanguage())%></option>
					<option value="2" <%=usertype==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></option>
					<option value="3" <%=usertype==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%></option>
					<option value="4" <%=usertype==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(30042, user.getLanguage())%></option>
				</select>
			</wea:item>
			<wea:item attributes="{'samePair':'subcompany'}"><%=SystemEnv.getHtmlLabelName(33256, user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser width="80%" viewType="0" name="subcompanyids" browserValue='<%=subcompanyids %>' 
				    getBrowserUrlFn="getObjWindowUrl" getBrowserUrlFnParams="2"
				    completeUrl="javascript:getAjaxUrl();"
					hasInput="true" isSingle="false" hasBrowser="true"
					isMustInput="1"	browserSpanValue='<%=subcompanynames %>'>
				</brow:browser>
			</wea:item>
			<wea:item attributes="{'samePair':'department'}"><%=SystemEnv.getHtmlLabelName(33255, user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser width="80%" viewType="0" name="departmentids" browserValue='<%=departmentids %>' 
				    getBrowserUrlFn="getObjWindowUrl" getBrowserUrlFnParams="3"
				    completeUrl="javascript:getAjaxUrl();"
					hasInput="true" isSingle="false" hasBrowser="true"
					isMustInput="1"	browserSpanValue='<%=departmentnames %>'>
				</brow:browser>
			</wea:item>
			<wea:item attributes="{'samePair':'user'}"><%=SystemEnv.getHtmlLabelName(33210, user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser width="80%" viewType="0" name="userids" browserValue='<%=userids %>' 
				    getBrowserUrlFn="getObjWindowUrl" getBrowserUrlFnParams="4"
				    completeUrl="javascript:getAjaxUrl();"
					hasInput="true" isSingle="false" hasBrowser="true"
					isMustInput="1"	browserSpanValue='<%=usernames %>'>
				</brow:browser>
			</wea:item>
		</wea:group>
	</wea:layout>
</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeCurDialog();">
	    </wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
</html>
