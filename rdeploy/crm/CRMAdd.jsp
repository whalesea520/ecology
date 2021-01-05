
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<%@page import="weaver.crm.util.CrmFieldComInfo"%>

<%@ taglib uri="/browserTag" prefix="brow"%>
<%

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(26760,user.getLanguage()); //微博基本设置
String needfav ="1";
String needhelp ="";

int userid=0;
userid=user.getUID();

String operation=Util.null2String(request.getParameter("operation"));

%>
<!DOCTYPE HTML>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
    <SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
	<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()+"'></script>
	
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
	<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
	
 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</head>
<body>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="客户信息"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form  method="post" id="mainform">
<input type="hidden" name="method" value="add">
<wea:layout>

	<wea:group context="<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%>">
	
		<wea:item>客户名称</wea:item> <!-- 允许申请关注 -->
		<wea:item>
			<wea:required id="namespan" required="true">
				<input class="inputstyle" type="text" name="name" id="name" 
					onkeydown="if(window.event.keyCode==13) return false;" onChange="checkinput('name','namespan')" 
					style="width:45%" onblur="checkLength('name',100,'<%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')">
			</wea:required> 
		</wea:item>
		
		<wea:item>客户经理</wea:item>
		<wea:item>
			<brow:browser viewType="0" name="manager" browserValue='<%=""+userid%>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
							completeUrl="/data.jsp" width="50%" 
							browserSpanValue='<%=ResourceComInfo.getResourcename(""+userid)%>'>
			</brow:browser>
		</wea:item>
		
		<wea:item>状态</wea:item>
		<wea:item>
			<brow:browser viewType="0" name="status" browserValue='2' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
							completeUrl="/data.jsp?type=customerStatus" width="50%" 
							browserSpanValue='基础客户'>
			</brow:browser>
		</wea:item>
		
		<wea:item>网站</wea:item>
		<wea:item>
			<input type="text" name="website" id="website"/>
		</wea:item>
		<wea:item>电子邮件</wea:item>
		<wea:item>
			<input type="text" name="email" id="email" onblur='checkEmailFormate(this)'/>
		</wea:item>
		
	</wea:group>
</wea:layout>
</form>

<wea:layout>
<%
	String customerid="444";
	boolean canedit=true;
	%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%>'>
		<%if(false){ %>
		<wea:item type="groupHead">
			<input type="button" id="btn_contacter" class="addbtn" onclick="addContacter()" _status="1"/>
			<input type="button" id="btn_contacter" class="delbtn" onclick="addContacter()" _status="1"/>
		</wea:item>
		<%}%>
		<wea:item attributes="{'colspan':'full'}">
			<!-- 人员关系开始 -->
			<jsp:include page="ContacterRel.jsp">
				<jsp:param value="0" name="customerid"/>
				<jsp:param value="<%=canedit %>" name="canedit"/>
				<jsp:param value="0" name="contact"/>
			</jsp:include>
			<!-- 人员关系结束 -->
		</wea:item>
	</wea:group>
</wea:layout>
  
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
 <script type="text/javascript">
  function doSave(){
     var errorLength=$("#mainform").find("img[src='/images/BacoError_wev8.gif']").length;
     if($("#addContacter").is(":hidden")){
     	errorLength=errorLength-3;
     }
     if(errorLength>0){
     	alert("必填信息不全");
     	return;
     }
     
     if($("#PhoneOffice").val()== $("#PhoneOffice").attr("_def")) $("#PhoneOffice").val("");
     if($("#mobilephone").val()== $("#mobilephone").attr("_def")) $("#mobilephone").val("");
	 if($("#CEmail").val()== $("#CEmail").attr("_def")) $("#CEmail").val("");
     
     var params=$("#mainform").serialize();
     $.post("CRMOperation.jsp?"+params,function(data){
     	
     	var CustomerID=$.trim(data);
     	var manager=$("#manager").val();
     	var params=$("#quickaddform").serialize();
     	$.post("CRMOperation.jsp?CustomerID="+CustomerID+"&manager="+manager+"&"+params,function(data){
     		var parentWin = parent.getParentWindow(window);
			parentWin.reloadData();
			parent.getDialog(window).close();
     	});
     	
     });
     //jQuery("#mainform").submit();
  }
  
  function checkEmailFormate(obj){
  	var emailStr=$(obj).val();
  	if(!checkEmail(emailStr)){
  		$(obj).val("");
  	}
  }
  
jQuery(document).ready(function(){
	 jQuery("input[type=checkbox]").each(function(){
		  if(jQuery(this).attr("tzCheckbox")=="true"){
		   		jQuery(this).tzCheckbox({labels:['','']});
		  }
	 });
});

 </script>
</html>
