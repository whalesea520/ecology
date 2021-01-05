
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	response.setHeader("Expires", "-1") ; // '将当前页面置为唯一活动的页面,必须关闭这个页面以后,其他的页面才能被激活	
%>
<HTML>
<HEAD>
	<TITLE>Clock</TITLE>
<script>
var cleanValue;
var arg0=window.dialogArguments;
arg0=(typeof(arg0)=="unknown")?'':arg0;
var isBtnClosed=0;

function getTheTime() {	
	isBtnClosed=1;
    arg0 = document.all("timevalue").value;
	window.returnValue = arg0
	window.close();
}
function clearWin(){
	isBtnClosed=2;
	arg0 = document.all("timevalue").value;
	if(arg0 != null || arg0 != ""){
	  arg0 = '';
	}
	cleanValue = 1;
	window.returnValue = arg0;
	window.close();
}
function cancel(){
	window.close();
}
function closeFun(){
	arg0 = document.all("timevalue").value;
	window.returnValue = arg0;
	window.close();
}
var heightTemp;
var browser=navigator.appName  
var b_version=navigator.appVersion  
var version=b_version.split(";");  
var trim_Version=version[1].replace(/[ ]/g,"");  
if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE7.0"){  
     heightTemp = 26;
}  
else if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE6.0"){  
     heightTemp = 21;
} 

</script>	
 <style type="text/css">
<!--
.style1 {
    border:#ccc 1px solid;
	padding:2px;
}
-->
</style>
</HEAD>

<BODY scroll="no">

<TABLE width=100% height=100% border=0 cellpadding=0 cellspacing=0>
<TR>
<TD valign="top">
<div style="position:absolute;left:0;top:3;text-align:center; border:1px solid #bbb;padding:2px background-color:lightgrey;font-size:9pt;" onselectstart="return false">
<h1 Author="wayx" style="background-color:lightgrey;font-size:12px;font-weight:normal;height:22px;line-height:20px;margin:0px;">
<div id=hourid>Hour:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<select id=hour name=hour>
<script>
var d = new Date();
 for (var i=0; i<24;  i++){
	i<10?j=0+i.toString():j=i;
		if (d.getHours().toString()==i)
	{
		document.writeln("<OPTION VALUE= " + j + " selected>" + j + "</option>");
		}else{
			document.writeln("<OPTION VALUE= " + j + ">" + i + "</option>");
	}
 }
</script>
</select>
</div>
</h1>
<span id="nowhour"></span>
<input type=hidden id="timevalue" name="timevalue" value="">
</div>
<script>
 
function getTime(temp,id){
 var sTime;
 var mTime = id.value;
 if(mTime<10){
	 mTime = "0" + mTime;
 }
 sTime = document.all.hour.value + ":" +mTime;
 document.all("timevalue").value = sTime;
 document.all(temp.id).style.background = '#BEEBEE';
 closeFun();
}
function clineTime(){
  var temptime;
  document.all("timevalue").value = '';
}
var timestr;
var m = new Date();
timestr = "<div style=\'border:lightgrey 1px solid;\' id=TimeLayer>";
timestr+="<table style=\'background-color:lightgrey;border:1 solid black;\' border=1 cellspacing=0><tr>";
for (var i=1; i<61; i++){
 var j;
 i<10?j=0+i.toString():j=i;
 var t =  i-1;
 if (i%6 == 0){
   if(m.getMinutes().toString()==t){
     timestr+="<td width=40  align=center height="+heightTemp+" bgcolor=\'#BEEBEE\' style=\'font-size:9pt;FONT-FAMILY: Verdana;cursor:pointer;\' id="+t+" onClick=getTime(this,minute"+t+")>" + t + "<input type=hidden id=minute"+t+" value="+t+"></td></tr><tr>";
   }else{
	     timestr+="<td width=40  align=center height="+heightTemp+" onmouseover=" + " style.backgroundColor=\'#BEEBEE\' " + " onmouseout=" + " style.backgroundColor=\'lightgrey\' " +"style=\'font-size:9pt;FONT-FAMILY: Verdana;cursor:pointer;\' id="+t+" onClick=getTime(this,minute"+t+")>" + t + "<input type=hidden id=minute"+t+" value="+t+"></td></tr><tr>";
   }
  }else{
    if(m.getMinutes().toString()==t){
	      timestr+="<td width=40  align=center height="+heightTemp+" bgcolor=\'#BEEBEE\' style=\'font-size:9pt;FONT-FAMILY: Verdana;cursor:pointer;\' id="+t+" onClick=getTime(this,minute"+t+")>" + t + "<input type=hidden id=minute"+t+" value="+t+"></td>";
	}else{
      timestr+="<td width=40  align=center height="+heightTemp+" onmouseover=" + " style.backgroundColor=\'#BEEBEE\' " + " onmouseout=" + " style.backgroundColor=\'lightgrey\' " +"style=\'font-size:9pt;FONT-FAMILY: Verdana;cursor:pointer;\' id="+t+" onClick=getTime(this,minute"+t+")>" + t + "<input type=hidden id=minute"+t+" value="+t+"></td>";
	}
  }
}
timestr+="</tr><tr></table></div>";
document.getElementById("nowhour").innerHTML = timestr;
hourstr = d.getHours();
if(hourstr < 10)
hourstr = "0"+hourstr;

minutesstr = d.getMinutes();
if(minutesstr < 10)
minutesstr = "0"+minutesstr;
document.getElementById("timevalue").value = hourstr +":"+minutesstr;
</script>
</TD>
</TR>
<TR>
	<TD align=right height=30px>
		<TABLE border=0 cellpadding=2 cellspacing=0>
		<TR>
			<TD align="right"><input type="BUTTON" class=style1 value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" ACCESSKEY=1 TITLE="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" onclick="getTheTime()"></TD>
			<TD align="right"><input type="BUTTON" class=style1 value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" ACCESSKEY=2 TITLE="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick="clearWin()"></TD>
			<TD align="right"><input type="BUTTON" class=style1 value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" ACCESSKEY=3 TITLE="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" onclick="cancel()"></td>                     
		</TR>
		</TABLE>
	</TD>
</TR>
</TABLE>
</BODY>
</HTML>



