<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%
	User user = HrmUserVarify.checkUser(request , response);
	if(user == null){
		user = new User();
		user.setLanguage(7);
	}
%>
<%
	response.setHeader("Expires", "-1") ; // '将当前页面置为唯一活动的页面,必须关闭这个页面以后,其他的页面才能被激活
%>
<HTML>
 <HEAD>
  <TITLE>Calendar</TITLE>
  <script language="javascript" type="text/javascript" src="datetime_mode/WdatePicker.js"></script>
  <script language="javascript" type="text/javascript">
    var cleanValue;
	var arg0=window.dialogArguments;
    arg0=(typeof(arg0)=="unknown")?'':arg0;
    function getTheDate() {	
		arg0 = document.getElementById("carlendarID").value;
		window.returnValue = arg0;
		window.close();
	}
	function clearWin(){
	    arg0 = document.getElementById("carlendarID").value;
	    if(arg0 != null || arg0 != ""){
		  arg0 = '';
		}
		window.returnValue = arg0;
		cleanValue = 1;
		window.close();
	}
	function cancel(){
		window.close();
	}
	function closeFun(){
		arg0 = document.getElementById("carlendarID").value;
	  	window.returnValue = arg0;
		window.close();
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
  <TABLE border=0 cellpadding=0 cellspacing=0>
    <TR>
	  <TD>
		<div id="carlendarID" style="height:100%;width:100%;border:1px solid black;"></div>
         <script>
		    WdatePicker({eCont:'carlendarID',onpicked:function(dp){$dp.$('carlendarID').value = dp.cal.getDateStr();closeFun();}})
			var d = new Date();
			year = d.getFullYear();
			if(d.getMonth()+1<10){
			  month = "0"+(d.getMonth()+1);
			}else{
			  month = d.getMonth()+1;
			}
			date =  d.getDate();
			if(date < 10){
			  date = "0" + date;
			}
			document.getElementById("carlendarID").value = year +"-"+month+"-"+date;
	     </script>
	  </TD>
    </TR>
    <TR>
	  <TD align=right>
		 <TABLE border=0 cellpadding=2 cellspacing=0>
		   <TR>
			 <TD align="right"><input type="BUTTON" class=style1 value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" ACCESSKEY=1 TITLE="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" onclick="getTheDate()"></TD>
			 <TD align="right"><input type="BUTTON" class=style1 value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" ACCESSKEY=2 TITLE="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick="clearWin()"></TD>
			 <TD align="right"><input type="BUTTON" class=style1 value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" ACCESSKEY=3 TITLE="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" onclick="cancel()"></td>           
		   </TR>
		</TABLE>
	 </TD>
    </TR>
  </TABLE>
</BODY>
</HTML>