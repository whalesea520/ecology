
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.login.TokenJSCX"%>
<%@page import="weaver.hrm.settings.RemindSettings"%>
<%@page import="weaver.hrm.settings.BirthdayReminder"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="weaver.file.Prop"%>
<%
 String tokenKey=Util.null2String(request.getParameter("tokenKey"));
 String tokenKeyCode1=Util.null2String(request.getParameter("tokenKeyCode1"));
 String tokenKeyCode2=Util.null2String(request.getParameter("tokenKeyCode2"));
 String languageid=Util.null2String(request.getParameter("languageid"));
 
 String flag="";
 String message="";
 if(!tokenKey.equals("")&&!tokenKeyCode1.equals("")&&!tokenKeyCode2.equals("")){
	 TokenJSCX tokenJSCX=new TokenJSCX();
	 flag=tokenJSCX.syncTokenKey(tokenKey,tokenKeyCode1,tokenKeyCode2);
 }
 
 if(flag.equals("1"))
	 message=SystemEnv.getHtmlLabelName(129199, Util.getIntValue(languageid,7)); 
 else if(flag.equals("2"))
	 message=SystemEnv.getHtmlLabelName(129200, Util.getIntValue(languageid,7))+"<br>"+SystemEnv.getHtmlLabelName(129201, Util.getIntValue(languageid,7));
%>
<html>
  <head>
    <title><%=SystemEnv.getHtmlLabelName(129202, 7)%></title>
    <script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
		<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_7_wev8.js"></script>
    <link type='text/css' rel='stylesheet'  href='/css/weaver_wev8.css'/>
    <link type='text/css' rel='stylesheet'  href='/wui/theme/ecology7/skins/default/wui_wev8.css'/>
    <script type="text/javascript">
		function showmsg(mess,func) {
				var diag = new window.top.Dialog({
			        Width: 300,
			        Height: 80,
			        normalDialog:false,
			        Modal:true
			    });
				diag.Title = '<%=SystemEnv.getHtmlLabelName(15172, Util.getIntValue(languageid,7))%>';
			    diag.CancelEvent = function () {
			        diag.close();
		        	if (func) func();
			    };
			    diag.InnerHtml = '<table height="100%" border="0" align="center" cellpadding="10" cellspacing="0">\
					<tr><td align="right"><img id="Icon_" src="' + IMAGESPATH + 'icon_alert_wev8.png" style="margin-right:10px;" width="26" height="26" align="absmiddle"></td>\
						<td align="left" id="Message_" style="font-size:9pt">' + mess + '</td></tr>\
				</table>';
				diag.ShowButtonRow=true;
				diag.normalDialog= false;
				diag.show();
		   	 	diag.getDialogDiv().style.zIndex = 99999;
		    	jQuery(diag.getContainer()).css("overflow-y","auto");
			    diag.okButton.style.display = "none";
			    diag.e8SepLine.style.display = "none";
			    diag.cancelButton.value = '<%=SystemEnv.getHtmlLabelName(826, Util.getIntValue(languageid,7))%>';
			    diag.cancelButton.focus();
		}
	    $(document).ready(function () {
	    	var pTop= document.documentElement.offsetHeight/2 + document.documentElement.scrollTop - 154;
	        var pLeft= document.body.offsetWidth/2 - 50;
	        $("#messageArea").css("top", pTop);
	    });
	    function dosave(obj){
	       var tokenKey=jQuery("#tokenKey");
	       var tokenKeyCode1=jQuery("#tokenKeyCode1");
	       var tokenKeyCode2=jQuery("#tokenKeyCode2");
	       
           if(tokenKey.val()==""){
              showmsg("<%=SystemEnv.getHtmlLabelName(129203, Util.getIntValue(languageid,7))%>");
              tokenKey.focus();
              return ;
           }else if(!isdigit(tokenKey.val())||tokenKey.val().length!=10){
              showmsg("<%=SystemEnv.getHtmlLabelName(83745, Util.getIntValue(languageid,7))%>");
              tokenKey.focus();
              return ;
           }	
           
           var tokenType="";
           var startNumber=tokenKey.val().substr(0,1);
           if(startNumber=="1"){      //动联1代
               tokenType="5";
           }else{
               showmsg("<%=SystemEnv.getHtmlLabelName(129133, Util.getIntValue(languageid,7))%>");
               tokenKey.focus();
               return ;
           }
           
           if(tokenKeyCode1.val()==""){
              showmsg("<%=SystemEnv.getHtmlLabelName(127901, Util.getIntValue(languageid,7))%>1！");
              tokenKeyCode1.focus();
              return ;
           }else if(tokenKeyCode1.val().length!=6||!isdigit(tokenKeyCode1.val())){
               showmsg("<%=SystemEnv.getHtmlLabelName(129204, Util.getIntValue(languageid,7))%>1<%=SystemEnv.getHtmlLabelName(129205, Util.getIntValue(languageid,7))%>");   
               tokenKeyCode1.focus();
               return ;
           } 
           
           if(tokenKeyCode2.val()==""){
              showmsg("<%=SystemEnv.getHtmlLabelName(127901, Util.getIntValue(languageid,7))%>2！");
              tokenKeyCode2.focus();
              return ;
           }else if(tokenKeyCode2.val().length!=6||!isdigit(tokenKeyCode2.val())){
              showmsg("<%=SystemEnv.getHtmlLabelName(129204, Util.getIntValue(languageid,7))%>2<%=SystemEnv.getHtmlLabelName(129205, Util.getIntValue(languageid,7))%>");   
              tokenKeyCode2.focus();
              return ;
           }
           
           if(tokenKeyCode1.val()==tokenKeyCode2.val()){
              showmsg("<%=SystemEnv.getHtmlLabelName(129204, Util.getIntValue(languageid,7))%>1<%=SystemEnv.getHtmlLabelName(129206, Util.getIntValue(languageid,7))%>2<%=SystemEnv.getHtmlLabelName(26250, Util.getIntValue(languageid,7))%>");
              return ;
           }
           jQuery("#weaver").submit();
	    }
	    
	    function isdigit(s){
			var r,re;
			re = /\d*/i; //\d表示数字,*表示匹配多个数字
			r = s.match(re);
			return (r==s)?true:false;
		}
    </script>
    <style>
      body{font-size:12px;}
    </style>
  </head>
<body style="margin:0px;padding:0px;background-color: rgb(241, 241, 241);">
<form name="weaver" id="weaver" action="syncTokenKey.jsp" method="post">
<div style="width: 100%;position:absolute;" align="center" id="messageArea">
    <div style="width: 582px;height:309px;font-size:12px;background:url(/wui/common/page/images/error_wev8.png) no-repeat;text-align:left;position: relative;" align="center">
	    <div style="height:45px;clear: both;">
	         <div style="padding-left: 15px;padding-top:25px;font-size:16px;"><span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelNames("32896,18240",Util.getIntValue(languageid,7)) %></span>
	         <span style="font-size: 12px;color: red">(<%=SystemEnv.getHtmlLabelName(129208, Util.getIntValue(languageid,7))%>)</span></div>
	    </div>
    <div>
    <div style="float:left; ">
    	<div style=" height:128px; width:123px;background: url(/wui/common/page/images/error_left1_wev8.png); margin-top:20px;margin-left:40px!important; margin-left:20px"></div>
    </div>
	<div style=" height:120px; border-left:solid 1px #e3e3e3; margin:20px; float:left; margin-left:40px;margin-top:20px"></div>
		<div style="height:260px; width:320px; float:left;margin-top:10px; line-height:25px;">
		   <%if(flag.equals("")||flag.equals("1")||flag.equals("2")){%>
		   <table style="margin-top: 15px;width: 100%;font-size:12px;">
		       <tr>
		           <td width="75px"><%=SystemEnv.getHtmlLabelName(32897, Util.getIntValue(languageid,7))%></td>
		           <td><input type="text" name="tokenKey" id="tokenKey" style="width: 150px;" maxlength="10">&nbsp;<%=SystemEnv.getHtmlLabelName(129141, Util.getIntValue(languageid,7))%></td>
		       </tr>
		       <tr>
		           <td><%=SystemEnv.getHtmlLabelName(129204, Util.getIntValue(languageid,7))%>1</td>
		           <td><input type="text" name="tokenKeyCode1" id="tokenKeyCode1" style="width: 150px;" maxlength="6">&nbsp;<%=SystemEnv.getHtmlLabelName(129145, Util.getIntValue(languageid,7))%></td>
		       </tr>
		       <tr>
		           <td><%=SystemEnv.getHtmlLabelName(129204, Util.getIntValue(languageid,7))%>2</td>
		           <td><input type="text" name="tokenKeyCode2" id="tokenKeyCode2" style="width: 150px;" maxlength="6">&nbsp;<%=SystemEnv.getHtmlLabelName(129145, Util.getIntValue(languageid,7))%></td>
		       </tr>
		       <tr>
			       <td colspan="2">
			          <span style="color: red;"><%=message%></span>
			       </td>
			   </tr>
		       <tr>
			       <td colspan="2" align="center" style="padding-top: 5px;">
			         <input type="button" value="<%=SystemEnv.getHtmlLabelName(18240, Util.getIntValue(languageid,7))%>" onclick="dosave(this)">&nbsp;
			         <input type="reset" value="<%=SystemEnv.getHtmlLabelName(2022, Util.getIntValue(languageid,7))%>">
			      </td>
			   </tr>
		   </table>
		   <%}else{%>
		       <div style="margin-top: 45px;font-size: 15px;">
		         <span style="color: red;"><%=SystemEnv.getHtmlLabelNames("129202,15242",Util.getIntValue(languageid,7)) %>！</span><br>
		          <%=SystemEnv.getHtmlLabelName(129149, Util.getIntValue(languageid,7))%>&nbsp;<a href="/login/Login.jsp" style="font-weight: bold;font-size: 14px;"><%=SystemEnv.getHtmlLabelName(674, Util.getIntValue(languageid,7))%></a><%=SystemEnv.getHtmlLabelName(129150, Util.getIntValue(languageid,7))%>
		      </div>
		   <%}%>
	    </div>
	    </div>
    </div>
    
</div>
   <input type=hidden name="languageid" value="<%=languageid%>">
</form>
</body>
</html>    
  
