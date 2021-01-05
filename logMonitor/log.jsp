<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<!--
	qc:271653日志监测
-->
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<title><%=SystemEnv.getHtmlLabelName(130472,user.getLanguage())%></title>
<style> 
.div-1{
	position: absolute;
	width:100%; 
	height:83%; 
	float:left; 
 	overflow-y:scroll; 
}
/* Border styles */
#table-1 thead, #table-1 tr {
border-top-width: 1px;
border-top-style: solid;
border-top-color: rgb(230, 189, 189);
}
#table-1 {
position:absolute;
width:100%;
height:83%; 
}

/* Padding and font style */
#table-1 td, #table-1 th {
padding: 5px 10px;
font-size: 12px;
font-family: Verdana;
color: black;
}

/* Alternating background colors */
#table-1 tr:nth-child(even) {
background: rgb(248,248,248)
}
#table-1 tr:nth-child(odd) {
background: #FFF
}
.select {
    position: relative;
}
</style>
<%
String titlename = SystemEnv.getHtmlLabelName(130472,user.getLanguage());
String theLoginid = user.getLoginid().toLowerCase();
if(!HrmUserVarify.checkUserRight("tail:log",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>
<script>
	$(document).ready(function(){
			$("#ingspan").hide();
			$("#txtDate").val(getTodayStrWithSplit());
	});
	var timeout = false; //启动关闭监测  
	function time()  
	{  
	  if(timeout) return;  
	  
	  $.ajax({
	        	 type:'get',
	        	 url:"logoperation.jsp?module="+$("#module").val()+"&lines="+$("#lines").val()+"&seldate="+getTextDate()+"&t="+new   Date(),
	        	 success: function(data) {
		            var trstr = '<tr>'+
			        	'<td colspan="4" valign="top">'+
			        		data
			        	'</td>'+
			        	'</tr>';
					$("#tbodyid").html(trstr);
	         	 }
	         	}
	         );
	  setTimeout(time,parseInt($("#pers").val())); 
	}  
	function startTail()
	{
		timeout = false;
		time();
		$("#ingspan").show();
	}
	function stop()
	{
		timeout = true;
		$("#ingspan").hide();
	}
	function dl()
	{
		if("<%=theLoginid%>"=="sysadmin")
		$.ajax({
	        	 type:'get',
	        	 url:"logExist.jsp?module="+$("#module").val()+"&lines="+$("#lines").val()+"&seldate="+getTextDate()+"&t="+new   Date(),
	        	 success: function(data) {
		            if("exist" == data){
						window.location.href = "dl.jsp?module="+$("#module").val()+"&seldate="+getTextDate()+"&t="+new   Date();
		            }else{
		            	var trstr = '<tr>'+
			        	'<td colspan="4" valign="top">'+
			        		data
			        	'</td>'+
			        	'</tr>';
						$("#tbodyid").html(trstr);
		            }
	         	 }
	         	}
	         );
	     else{
	     	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(2012,user.getLanguage()) %>！");
	     }
	}
	function getTextDate(){
		var txtDate = $("#txtDate").val();
		txtDate = txtDate.split("-").join('');
		if(getTodayStr() == txtDate){
		  	txtDate = "";
		  }
		return txtDate; 
	}
	function getTodayStr(){
		var now = new Date();
		var str = now.getFullYear()+""+((now.getMonth()+1)<10?"0":"")+(now.getMonth()+1)+""+(now.getDate()<10?"0":"")+now.getDate();
		return str;
	}
	function getTodayStrWithSplit(){
		var now = new Date();
		var str = now.getFullYear()+"-"+((now.getMonth()+1)<10?"0":"")+(now.getMonth()+1)+"-"+(now.getDate()<10?"0":"")+now.getDate();
		return str;
	}
</script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(530,user.getLanguage())+",javascript:startTail(),_self} " ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(20387,user.getLanguage())+",javascript:stop(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div  id="advancedSearchDiv">
   <wea:layout type="4col" attributes="{'expandAllGroup':'true'}">

	<wea:group context='<%=SystemEnv.getHtmlLabelName(130472,user.getLanguage()) %>' >
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("33234,131754 ",user.getLanguage()) %></wea:item>
	    	<wea:item>
	    		<select id="module">
					<option value="ecology">OA<%=SystemEnv.getHtmlLabelName(83,user.getLanguage()) %></option>
					<option value="integration/integration.log"><%=SystemEnv.getHtmlLabelName(31695,user.getLanguage()) %></option>
				</select>
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("31131,131754 ",user.getLanguage()) %></wea:item>
	    	<wea:item>
	    		 <input name="txtDate" id="txtDate" type="hidden" class="wuiDate" value="" ></input>
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("23201,131754 ",user.getLanguage()) %></wea:item>
	    	<wea:item>
	    		<select id="lines">
					<option value="25" selected="selected">25</option>
					<option value="100">100</option>
					<option value="1000">1000</option>
				</select>
				<SPAN class="e8tips" style="CURSOR: hand" title="<%=SystemEnv.getHtmlLabelName(130405,user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("104,131754 ",user.getLanguage()) %></wea:item>
	    	<wea:item>
	    	&nbsp;&nbsp;
		    	<input value="<%=SystemEnv.getHtmlLabelName(530,user.getLanguage()) %>" onclick="startTail();"  class="e8_btn_top" type="button"/>
				<input value="<%=SystemEnv.getHtmlLabelName(20387,user.getLanguage()) %>" onclick="stop();"  class="e8_btn_top" type="button"/>

				<span id="ingspan" style="color:red"><%=SystemEnv.getHtmlLabelName(130401,user.getLanguage()) %>...</span>
				
	    	
	    	</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(354,user.getLanguage()) %><%=SystemEnv.getHtmlLabelNames("18813,131754 ",user.getLanguage()) %></wea:item>
	    	<wea:item>
	    		<select id="pers">
	    			<option value="1000" >1<%=SystemEnv.getHtmlLabelName(27954,user.getLanguage()) %></option>
	    			<option value="2000" >2<%=SystemEnv.getHtmlLabelName(27954,user.getLanguage()) %></option>
					<option value="3000" selected="selected">3<%=SystemEnv.getHtmlLabelName(27954,user.getLanguage()) %></option>
			        <option value="10000">10<%=SystemEnv.getHtmlLabelName(27954,user.getLanguage()) %></option>
			        <option value="30000">30<%=SystemEnv.getHtmlLabelName(27954,user.getLanguage()) %></option>
			        <option value="60000">60<%=SystemEnv.getHtmlLabelName(27954,user.getLanguage()) %></option>
				</select>
				<SPAN class="e8tips" style="CURSOR: hand" title="<%=SystemEnv.getHtmlLabelName(130406,user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
	    	</wea:item>
	    	<wea:item></wea:item>
	    	<wea:item>
	    	<a href="#" onclick="dl()" style="color: blue;" title="<%=SystemEnv.getHtmlLabelName(258,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(34223,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(83,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage()) %></a>
	    	<SPAN class="e8tips" style="CURSOR: hand" title="<%=SystemEnv.getHtmlLabelName(130408,user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
	    	</wea:item>
	    </wea:group>

	    </wea:layout>
</div>


<div id="div-1" class="div-1">
<table id="table-1">
<tbody id="tbodyid" >

</tbody>
</table>
</div>

</body>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
</html>
