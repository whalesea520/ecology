<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/rdeploy/hrm/js/jquery.zclip.js"></script>
<style>
	.e8_os{
	  height:35px; 
	}
	.e8_innerShowContent{
	  height: 30px;
	  padding: 7px 0 0 7px;
	}
	
	.e8_spanFloat{
	  padding: 5px 0 0 0;
	}
	.e8_browflow{
		
	}
</style>
<style type="text/css">
.line{margin-bottom:20px;}
/* 复制提示 */
.copy-tips{position:fixed;z-index:999;bottom:50%;left:50%;margin:0 0 -30px -55px;background-color:rgba(0, 0, 0, 0.2);filter:progid:DXImageTransform.Microsoft.Gradient(startColorstr=#30000000, endColorstr=#30000000);padding:6px;}
.copy-tips-wrap{padding:10px 20px;text-align:center;border:1px solid #F4D9A6;background-color:#FFFDEE;font-size:14px;}
</style>

</head>
<%!
/***
 * 随机数密码
 * @param n
 * @return
 */
public static String random(int n) {
  Random ran = new Random();
  if (n == 1) {
      return String.valueOf(ran.nextInt(10));
  }
  int bitField = 0;
  char[] chs = new char[n];
  for (int i = 0; i < n; i++) {
      while(true) {
          int k = ran.nextInt(10);
          if( (bitField & (1 << k)) == 0) {
              bitField |= 1 << k;
              chs[i] = (char)(k + '0');
              break;
          }
      }
  }
  return new String(chs);
}
%>
<%

String id= Util.null2String(request.getParameter("id"));

String uname = ResourceComInfo.getResourcename(id);
String loginId = ResourceComInfo.getLoginID(id);
String comname = CompanyComInfo.getCompanyname("1");

String managerName = user.getUsername();

String language = Util.null2String(request.getParameter("lg"));

String reUrl = request.getRequestURL().toString();

String invUrl =reUrl.substring(0,reUrl.indexOf("/rdeploy/hrm/RdSendMsgPage.jsp"));

//设置密码
String password_tmp =random(4);
String password = Util.getEncrypt(password_tmp);

rs.executeSql("  UPDATE HrmResource SET  PASSWORD = '"+password+"' WHERE ID ="+id);

ResourceComInfo.updateResourceInfoCache(id);

//if("2".equals(status)){
boolean canSend = true;
    try{
     rs.executeSql("select sendtime from rdeployhrmsendmsg where resourceid =  "+id);
     if(rs.next()){
         String sendtime = rs.getString(1);
         Calendar calendar = Calendar.getInstance();
         DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
         calendar.setTime(format.parse(sendtime));
         long a =System.currentTimeMillis()-calendar.getTime().getTime();
         if(a<1000*60*30){
            // other =",\"canSend\":\"1\"";
             canSend = false;
         }else{
            // other =",\"canSend\":\"2\"";
             canSend = true;
         }
     }else{
        // other =",\"canSend\":\"2\"";
         canSend = true;
     }
    }catch(Exception e){
        
    }
String content = managerName+SystemEnv.getHtmlLabelName(125172,user.getLanguage())+""+comname+SystemEnv.getHtmlLabelName(125173,user.getLanguage())+invUrl+" "+"</br></br>"+SystemEnv.getHtmlLabelName(2072,user.getLanguage())+" : "+loginId+SystemEnv.getHtmlLabelName(125169,user.getLanguage())+password_tmp+"";
String contentval = managerName+SystemEnv.getHtmlLabelName(125172,user.getLanguage())+comname+SystemEnv.getHtmlLabelName(125173,user.getLanguage())+invUrl+"/rdeploy/hrm/RdMobileLogin.jsp?uid="+id+SystemEnv.getHtmlLabelName(125174,user.getLanguage())+loginId+SystemEnv.getHtmlLabelName(125169,user.getLanguage())+password_tmp+"";
%>

<BODY>
<input name="hrmSId" id="hrmSId" value="<%=id %>" type="hidden"/>
<div style="padding-top: 55px;height: 100px;">
<table width="100%">
  <tr>
   <td align="center" style="padding: 0 20px 20px 50px; color: #526366;font-size: 14px;">
   	<%=SystemEnv.getHtmlLabelName(125315,user.getLanguage())%><span style="color: #5f9efe;font-size: 14px;padding-left: 10px;"><%= uname%></span>
   </td>
 </tr>
   <tr>
     <td align="center">
      <div style="height: 87px;font-size: 13px; padding:15px 0 0 9px;color: #546168;width: 525px;background-color: #ebf8f9;text-align: left; "><%=content %> </div>
     </td>
   </tr>
   <tr>
     <td align="right" style="padding:30px 130px 0 0; ">
     <% if(canSend){ %>
       <div  id="sendBefore" onclick="doSend()"  style="background-color:#4cc674;margin:5px 0 0 19px;width: 178px;text-align: center;height: 32px;font-size: 16px;padding-top: 9px;color: white;cursor:pointer;">
			 <%=SystemEnv.getHtmlLabelName(125316 ,user.getLanguage())%>
		</div>
		<div  id="sendAfter"   style="display: none;background-color:#4cc674;margin:5px 0 0 19px;width: 178px;text-align: center;height: 32px;font-size: 16px;padding-top: 9px;color: white;cursor:pointer;">
			 <img src="/rdeploy/assets/img/hrm/sendSuc.png" width="18px" height="18px" align="absMiddle" style="margin-right: 10px;"><%=SystemEnv.getHtmlLabelName(125317,user.getLanguage())%>
		</div>
	<%}else{ %>	
	<div  id="sendBefore" onclick="doSend()"   style="background-color:#4cc674;margin:5px 0 0 19px;width: 178px;text-align: center;height: 32px;font-size: 16px;padding-top: 9px;color: white;cursor:pointer;display: none;">
			 <%=SystemEnv.getHtmlLabelName(125316 ,user.getLanguage())%>
		</div>
       <div  id="sendAfter"   style="background-color:#4cc674;margin:5px 0 0 19px;width: 178px;text-align: center;height: 32px;font-size: 16px;padding-top: 9px;color: white;cursor:pointer;">
			 <img src="/rdeploy/assets/img/hrm/sendSuc.png" width="18px" height="18px" align="absMiddle" style="margin-right: 10px;top: -2px;"><%=SystemEnv.getHtmlLabelName(125317,user.getLanguage())%>
		</div>
	<%} %>	
     </td>
   </tr>
</table>
 
</div>
  <div class="line" style="top: 0;width: 520px;">
		    <a href="#none" class="copy-input" style="background-color:#4A79EF;width: 278px;text-align: center;height: 40px;font-size: 16px;padding: 10px 52px 10px 52px;color: white;top: 92px;position: relative;left:120px;"><%=SystemEnv.getHtmlLabelName(125318,user.getLanguage())%></a>
		    <input type="hidden" class="input" value="<%=contentval %>" />
	</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" id="dosubmit" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="back()">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
 
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script language=javascript>
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);	




function doSend() {
    $.ajax({
		 data:{"id":jQuery("#hrmSId").val(),"pwd":"<%=password_tmp%>","method":"sendMsg","content":"<%=contentval %>"},
		 type: "post",
		 cache:false,
		 url:"RdResourceOptAjax.jsp",
		 dataType: 'json',
		 async:false,
		 success:function(data){
		 	if(data.result){
				jQuery("#sendBefore").hide();
				jQuery("#sendAfter").show();
		 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125319,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
		 	}else{
		 		if(data.reason =="1"){
			 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125319,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
			 		jQuery("#sendBefore").hide();
				    jQuery("#sendAfter").show();
		 		}else{
			 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125307,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
		 		}
		 	}
		}	
	   });
}

function back()
{
	 window.parent.Dialog.close();
}

$(document).ready(function(){
/* 定义所有class为copy-input标签，点击后可复制class为input的文本 */
	$(".copy-input").zclip({
		path: "js/ZeroClipboard.swf",
		copy: function(){
		return $(this).parent().find(".input").val();
		},
		afterCopy:function(){/* 复制成功后的操作 */
			var $copysuc = $("<div class='copy-tips'><div class='copy-tips-wrap'><%=SystemEnv.getHtmlLabelName(125245,user.getLanguage())%></div></div>");
			$("body").find(".copy-tips").remove().end().append($copysuc);
			$(".copy-tips").fadeOut(3000);
        }
	});
});


</script>




</BODY></HTML>

