<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.login.TokenJSCX"%>
<%@page import="weaver.hrm.settings.RemindSettings"%>
<%@page import="weaver.hrm.settings.BirthdayReminder"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="weaver.file.Prop"%>
<%@page import="weaver.conn.RecordSet"%>
<%
 RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
 if(settings==null){
	  BirthdayReminder birth_reminder = new BirthdayReminder();
	  settings=birth_reminder.getRemindSettings();
	  if(settings==null){
	     out.println("Cann't create connetion to database,please check your database.");
	     return;
	  }
	 application.setAttribute("hrmsettings",settings);
 }
 
 String needusb=settings.getNeedusb();    //是否启用usb验证
 String needusbHt=Util.null2String(settings.getNeedusbHt());
 String needusbDt=Util.null2String(settings.getNeedusbDt());
 needusb = (needusbHt.equals("1") || needusbDt.equals("1")) ? "1" : "0";
 String usbType = settings.getUsbType();  //启用usb验证类型
 
 String userid=Util.null2String(request.getParameter("userid"));   //被绑定人用户id
 String loginid=Util.null2String(request.getParameter("loginid")); 
 String userpassword=Util.null2String(request.getParameter("userpassword"));
 String tokenKey1=Util.null2String(request.getParameter("tokenKey1"));
 String tokenKey2=Util.null2String(request.getParameter("tokenKey2"));
 String tokenKeyCode=Util.null2String(request.getParameter("tokenKeyCode"));
 String isBind=Util.null2String(request.getParameter("isBind"));
 String requestFrom=Util.null2String(request.getParameter("requestFrom"));//绑定请求来自页面，system为来自系统设置绑定设置
 int logintype=Util.getIntValue(request.getParameter("logintype"),0);     //账号验证类型  
 String languageid=Util.null2String(request.getParameter("languageid"));
 if(logintype==0){
	 //验证该账号是否为AD账户 qc:128484
	 String mode = Prop.getPropValue(GCONST.getConfigFile(), "authentic");
	 String isADAccount = "";
	 RecordSet rs = new RecordSet();
	 //rs.executeSql("select isADAccount from hrmresource where loginid='"+loginid+"'");
	 rs.executeQuery("select isADAccount from hrmresource where loginid= ? ",loginid);
	 if(rs.next()) {
	 	isADAccount = rs.getString("isADAccount");
	 }
	 if(mode != null && mode.equals("ldap") && "1".equals(isADAccount))
		 logintype=2;
	 else
		 logintype=3;
 }
 
 String message="";
 String flag="0";

 if(!needusb.equals("1")){
	 response.sendRedirect("/login/Login.jsp");
}

 TokenJSCX token=new TokenJSCX();
 
 if(tokenKey1.startsWith("1"))       //动联1代
	 flag=token.bindDLTokenKeyBySN(loginid,userpassword,tokenKey1,tokenKeyCode,isBind,logintype,requestFrom,userid);
 else if(tokenKey1.startsWith("2"))  //动联2代
	 flag=token.bindDLTokenKey(loginid,userpassword,tokenKey1,tokenKeyCode,isBind,logintype);
 else if(tokenKey1.startsWith("3"))  //坚石1代
	 flag=token.bindTokenKey(loginid,userpassword,tokenKey1,tokenKeyCode,isBind,logintype);
 

 if(flag.equals("-1"))
	 message=SystemEnv.getHtmlLabelNames("2072,21695,27103",Util.getIntValue(languageid,7));
 else if(flag.equals("2"))
	 message=SystemEnv.getHtmlLabelNames("32897,21695,129130",Util.getIntValue(languageid,7));

 
%>
<html>
  <head>
    <title><%=SystemEnv.getHtmlLabelNames("129131,28032",Util.getIntValue(languageid,7)) %></title>
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
	       var usbType="<%=usbType%>";
	       var loginid=jQuery("#loginid");
	       var userpassword=jQuery("#userpassword");
	       var tokenKey1=jQuery("#tokenKey1");
	       var tokenKey2=jQuery("#tokenKey2");
	       var tokenKeyCode=jQuery("#tokenKeyCode");
	       
	       <%if(requestFrom.equals("system")){%>
           if(loginid.val()==""){
              showmsg("<%=SystemEnv.getHtmlLabelName(16647, Util.getIntValue(languageid,7))%>");
              loginid.focus();
              return ;
           }
           if(userpassword.val()==""){
              showmsg("<%=SystemEnv.getHtmlLabelName(16648, Util.getIntValue(languageid,7))%>");
              userpassword.focus();
              return ;
           } 
           <%}%>
           if(tokenKey1.val()==""){
              showmsg("<%=SystemEnv.getHtmlLabelName(129203, Util.getIntValue(languageid,7))%>");
              tokenKey1.focus();
              return ;
           }else if(!isdigit(tokenKey1.val())||tokenKey1.val().length!=10){
              showmsg("<%=SystemEnv.getHtmlLabelName(83745, Util.getIntValue(languageid,7))%>");
              tokenKey1.focus();
              return ;
           }	
           
           if(tokenKey1.val()!=tokenKey2.val()){
              showmsg("<%=SystemEnv.getHtmlLabelName(129132, Util.getIntValue(languageid,7))%>");
              tokenKey2.focus();
              return ;
           }
           
           var tokenType="";
           var startNumber=tokenKey1.val().substr(0,1);
           if(startNumber=="1")      //动联1代
               tokenType="5";
           //else if(startNumber=="2") //动联2代
           //    tokenType="4";    
           //else if(startNumber=="3") //坚石1代
           //    tokenType="3"; 
           else{
               showmsg("<%=SystemEnv.getHtmlLabelName(129133, Util.getIntValue(languageid,7))%>");
               tokenKey1.focus();
               return ;
           }
           
           if(tokenType=="3"||tokenType=="5"){
              var flag=true;
              if(tokenKeyCode.val()==""){
	              showmsg("<%=SystemEnv.getHtmlLabelName(84271, Util.getIntValue(languageid,7))%>！");
	              flag=false;
              }else if(!isdigit(tokenKeyCode.val())){
                  showmsg("<%=SystemEnv.getHtmlLabelName(127902, Util.getIntValue(languageid,7))%>");
                  flag=false;
              }else if(tokenKeyCode.val().length!=6){
                  showmsg("<%=SystemEnv.getHtmlLabelName(127903, Util.getIntValue(languageid,7))%>");   
                  flag=false; 
              } 
              if(!flag)   
                 return false;
           }
           
           jQuery.post("/login/LoginOperation.jsp?method=checkIsBind&requestFrom=<%=requestFrom%>&userid=<%=userid%>&loginid="+loginid.val()+"&tokenKey="+tokenKey1.val(),{},function(data){
                var isBind=jQuery.trim(data);
                jQuery("#isBind").val(isBind);
                if(isBind=="1"){
                   showmsg("<%=SystemEnv.getHtmlLabelName(129134, Util.getIntValue(languageid,7))%>");
                   return ;
                }else if(isBind=="0"){
                   showmsg("<%=SystemEnv.getHtmlLabelName(129135, Util.getIntValue(languageid,7))%>");
                   return ;
                }else if(isBind=="6"){
                   showmsg("<%=SystemEnv.getHtmlLabelName(129136, Util.getIntValue(languageid,7))%>");
                   return ;
                }
                <%if(!requestFrom.equals("system")){%>
	                if(isBind=="4"||isBind=="5"){
	                   showmsg("<%=SystemEnv.getHtmlLabelName(129137, Util.getIntValue(languageid,7))%>");
	                   return ;
	                }
                <%}%> 
                jQuery("#weaver").submit();
           });
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
<form name="weaver" id="weaver" action="bindTokenKey.jsp" method="post">
<input type="hidden" value="<%=requestFrom%>" id="requestFrom" name="requestFrom">
<input type="hidden" value="<%=userid%>" id="userid" name="userid">
<input type="hidden" value="<%=logintype%>" id="logintype" name="logintype">
<input type="hidden" value="<%=languageid%>" id="languageid" name="languageid">
<input type="hidden" value="0" id="isBind" name="isBind">
<div style="width: 100%;position:absolute;" align="center" id="messageArea">
    <div style="width: 582px;font-size:12px;height:309px;background:url(/wui/common/page/images/error_wev8.png) no-repeat;text-align:left;position: relative;" align="center">
	    <div style="height:45px;clear: both;font-size:16px;">
	         <div style="padding-left: 15px;padding-top:25px"><span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(129138, Util.getIntValue(languageid,7))%></span><span style="font-size: 12px;color: red">(<%=SystemEnv.getHtmlLabelName(129140, Util.getIntValue(languageid,7))%>)</span></div>
	    </div>
    <div>
    <div style="float:left; ">
    	<div style=" height:128px; width:123px;background: url(/wui/common/page/images/error_left1_wev8.png); margin-top:20px;margin-left:40px!important; margin-left:20px"></div>
    </div>
	<div style=" height:120px; border-left:solid 1px #e3e3e3; margin:20px; float:left; margin-left:40px;margin-top:20px"></div>
		<div style="height:260px; width:320px; float:left;margin-top:10px; line-height:25px;">
		<%if(flag.equals("0")||flag.equals("-1")||flag.equals("2")){%>
			<table style="margin-top: 10px;font-size:12px;">
			   <%if(!requestFrom.equals("system")){%>
			   <tr>
			       <td><%=SystemEnv.getHtmlLabelName(412, Util.getIntValue(languageid,7))%></td>
			       <td><input type="text" name="loginid" id="loginid" style="width: 150px;" value="<%=loginid%>"></td>
			   </tr>
			   <tr>
			       <td><%=SystemEnv.getHtmlLabelName(409, Util.getIntValue(languageid,7))%></td>
			       <td><input type="password" name="userpassword" id="userpassword" style="width: 150px;"></td>
			   </tr>
			   <%} %>
			   <tr>
			       <td><%=SystemEnv.getHtmlLabelName(32897, Util.getIntValue(languageid,7))%></td>
			       <td><input type="text" name="tokenKey1" id="tokenKey1" style="width: 150px;" maxlength="10">&nbsp;<%=SystemEnv.getHtmlLabelName(129141, Util.getIntValue(languageid,7))%></td>
			   </tr>
			   <tr>
			       <td><%=SystemEnv.getHtmlLabelName(129142, Util.getIntValue(languageid,7))%></td>
			       <td><input type="text" name="tokenKey2" id="tokenKey2" style="width: 150px;" maxlength="10">&nbsp;<%=SystemEnv.getHtmlLabelName(129141, Util.getIntValue(languageid,7))%></td>
			   </tr>
			   <tr id="tokenKeyCodeTr" style="display:<%=usbType.equals("4")?"none":""%>">
			       <td><%=SystemEnv.getHtmlLabelName(129143, Util.getIntValue(languageid,7))%></td>
			       <td><input type="text" name="tokenKeyCode" id="tokenKeyCode" style="width: 150px;" maxlength="6">&nbsp;<%=SystemEnv.getHtmlLabelName(129145, Util.getIntValue(languageid,7))%></td>
			   </tr>
			   <tr>
			       <td colspan="2">
			          <span style="color: red;"><%=message%></span>
			       </td>
			   </tr>
			   <tr>
			       <td colspan="2" align="center" style="padding-top: 5px;">
			         <input type="button" value="<%=SystemEnv.getHtmlLabelName(28032, Util.getIntValue(languageid,7))%>" onclick="dosave(this)">&nbsp;
			         <input type="reset" value="<%=SystemEnv.getHtmlLabelName(2022, Util.getIntValue(languageid,7))%>">
			      </td>
			   </tr>
			   
			</table>
		 <%}else if(flag.equals("1")){ %>	
		    <div style="margin-top: 45px;font-size: 15px;">
		      <span style="color: red;"><%=SystemEnv.getHtmlLabelName(129147, Util.getIntValue(languageid,7))%></span><br>
		       <%if(requestFrom.equals("system")) {%>
		           <script type="text/javascript">
		               window.returnValue={tokenKey:"<%=tokenKey1%>"}
		           </script>
		       <%}else{ %>
		           <%=SystemEnv.getHtmlLabelName(129149, Util.getIntValue(languageid,7))%>&nbsp;<a href="/login/Login.jsp" style="font-weight: bold;font-size: 14px;"><%=SystemEnv.getHtmlLabelName(674, Util.getIntValue(languageid,7))%></a><%=SystemEnv.getHtmlLabelName(129150, Util.getIntValue(languageid,7))%>
		       <%} %>
		    </div> 
		 <%}else if(usbType.equals("4")&&!flag.equals("1")){ %>
		     <div style="margin-top: 45px;font-size: 15px;">
		      <span style="color: red;"><%=SystemEnv.getHtmlLabelName(129147, Util.getIntValue(languageid,7))%></span><br>
		       <%=SystemEnv.getHtmlLabelName(129152, Util.getIntValue(languageid,7))%><span style="color: red;font-weight: bold;font-size: 16px;"><%=flag%></span><%=SystemEnv.getHtmlLabelName(129153, Util.getIntValue(languageid,7))%>
		       <%if(requestFrom.equals("system")) {%>
		          <script type="text/javascript">
		              window.returnValue={tokenKey:"<%=tokenKey1%>"}
		          </script>
		       <%}else{ %>
		          <%=SystemEnv.getHtmlLabelName(129154, Util.getIntValue(languageid,7))%>&nbsp;<a href="/login/login.jsp" style="font-weight: bold;font-size: 14px;"><%=SystemEnv.getHtmlLabelName(674, Util.getIntValue(languageid,7))%></a>
		       <%} %>
		    </div> 
		 <%} %>
	    </div>
	    </div>
    </div>
    
</div>
</form>
</body>
</html>    
  
