<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">

<html>
<head>

<link href="style/Contacts.css" rel="stylesheet" type="text/css" />
<link href="style/Public.css" rel="stylesheet" type="text/css" />
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology7/skins/default/wui.css" type=text/css rel=STYLESHEET>
<link type='text/css' rel='stylesheet'  href='/wui/skins/default/wui.css'/>
<script type="text/javascript" src="/js/jquery/jquery.js"></script>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<style>
li{
	font-size: 12px;
}
a{
	text-decoration: none!important;
	color: #444444!important;
}
em{
	width: 60px!important;
}
a:ACTIVE {
	text-decoration: none!important;
	color: #444444!important;
}
</style>

<%
	String defSubId = ResourceComInfo.getSubCompanyID(""+user.getUID());
	
%>
</head>
<body>
<!--浮动通讯录 start-->
<table width="100%" align="center" >
<colgroup>
	<col width="">
	<col width="890px">
	<col width="">
</colgroup>
<tr>
	<td>&nbsp;</td>
	<td>
	<div class="Contacts">
<div class="ContactsBox  png Relative">

<div  class="ContactsTop png">
<div class="FL ContactsBg">
<!--通讯录左边 start-->
<div class="ContactsLeft">
<table cellpadding="0" cellspacing="0" width="356px">
<tr>
<td>
<input type="text" id="subCompany" name="subCompany" style="float:left;" class="browser" style="width:60px;" readonly="true"/>

</td>
<td  style="padding-right:5px;"><button type="button" class="Browser" onclick="onShowSubcompanyid();"></button></td>
<td>
<select id='departmentSel' class='BgSelect0 BoxW90 FL'>

</select>
</td>
<td>
<i class="Relative BoxW90 DisBox FL PL10" >
	<table>
			<tr>
				<td><input name="keyword" id="keyword" type="text"   value="" style="width:60px;" /></td>
				<td><img  id="search"  onclick="doSearch()" src="images/Search.png" class="png Bgfff" style="padding:2px;cursor:hand;" /></td>
			</tr>
		</table>
</i>
</td>
</tr>
</table>

<div id="ContactsSearch" class="ContactsSearch MT10">
<jsp:include page="contactssearch.jsp" flush="true" >
			<jsp:param name="subid" value=""/>
</jsp:include>
</div>
</div>
<!--通讯录左边 end-->
<!--通讯录右边 start-->
<div class="ContactsRight Relative" id="simpleHrmInfoDiv">
<img src="/messager/images/dummyContact.png" class="ContactsAvatar Absolute" style="right:0" />
<ul class="ContactsList">
<li id="ContactsListTit" class="cBlue2 FB FS16"> </li>
<li><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%>：</li>
<li><%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%>： </li>
<li><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%>：</li>
<li><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%>：</li>
<li><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%>：</li>
<li><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%>：</li>
<li><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%>： </li>
<li><%=SystemEnv.getHtmlLabelName(382,user.getLanguage())%>： </li>
<li><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%>：</li>
<li><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>：</li>
<li><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%>：</li>
<li><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%>：</li>
</ul>
</div>
<!--通讯录左边 end-->

</div>
</div>
</div>
<div class="clear"></div>
<div class="ContactsFoot png"></div>
</div>
	</td>
	<td>&nbsp;</td>
</tr>
</table>


</body>
</html>
<!--浮动通讯录 end-->
<script type="text/javascript">
<!--
var returnValue ="";


$(document).ready(function(){
	//$("ContactsSearch").load(/)
	changeSubcompany();
	loadHrmInfo("","");
})

// 获取人力资源信息
function loadHrmInfo(id,flag){
	$(".ContactsBox2Hover").removeClass("ContactsBox2Hover");
	$(".Lihover").removeClass("Lihover");
	$("#ContactsBox_"+flag).addClass("ContactsBox2Hover");
	$("#li_"+id).addClass("Lihover");
	$("#simpleHrmInfoDiv").html();
	$("#simpleHrmInfoDiv").load("simplehrminfo.jsp?id="+id,function(data){
		$(".ContactsList li:even").addClass("alt");
		
		});
}

// 根据分部改变所属部门信息
function changeSubcompany(){
	var id = $("#subcompanySel option:selected").val();
	var obj = document.getElementById("departmentSel");
	$(obj).load("departmentoptioninfo.jsp?subid="+id);
}

// 搜索
function doSearch(){

	var subid = $("#subcompanySel option:selected").val();
	var departid = $("#departmentSel option:selected").val()
	var keyword = $("#keyword").val();
	//keyword = encodeURIComponent(keyword);
	$("#ContactsSearch").html("");
	$("#ContactsSearch").load("contactssearch.jsp?subid="+returnValue+"&departid="+departid+"&keyword="+escape(keyword));
	
}

function setSubCompony(name,id){
	var obj2=document.getElementById("subCompany");
	obj2.value=name;
	var obj = document.getElementById("departmentSel");
	$(obj).load("departmentoptioninfo.jsp?subid="+id);
}
function onShowSubcompanyid(){
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp")
	if (data){
	    if (data.id!=0){
			returnValue=data.id
			setSubCompony(data.name,data.id)
	    }else{
			returnValue = ""

			setSubCompony(data.name,data.id)
	    }
	}
}
//-->
jQuery(document).keydown(function(event){
		if(event.keyCode == 13) {
			doSearch();
	        var evt =  event;    
			if(evt.preventDefault) {    
				// Firefox    
				 evt.preventDefault();    
				 evt.stopPropagation();    
			 } else {    
				// IE    
				 evt.cancelBubble=true;    
				 evt.returnValue = false;    
			 }
		}
	})
</script>
<script language="javascript" for="document" event="onkeydown">
	
    /*if (event.keyCode == 13)
    {
        doSearch();
        var evt =  event;    
		if(evt.preventDefault) {    
			// Firefox    
			 evt.preventDefault();    
			 evt.stopPropagation();    
		 } else {    
			// IE    
			 evt.cancelBubble=true;    
			 evt.returnValue = false;    
		 } 
    }*/
   
</script>
