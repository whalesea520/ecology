
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.User" %>
<%
  //从session中获取用户对象
  User user = (User) request.getSession(true).getAttribute("weaver_user@bean");
  //初始化languageId=7，默认为中文
  int languageId = 7;
  if(null != user){
	  languageId = user.getLanguage();
  }
  int labelid=Util.getIntValue(((String)request.getAttribute("labelid")==null?request.getParameter("labelid"):(String)request.getAttribute("labelid")),0);
  String msg=SystemEnv.getHtmlLabelName(labelid,languageId);
%>
<html>
  <head>
    <title><%=SystemEnv.getHtmlLabelName(84239,languageId) %></title>
    <script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
    <link type='text/css' rel='stylesheet'  href='/wui/theme/ecology7/skins/default/wui_wev8.css'/>
  </head>
<body style="margin:0px;padding:0px;">
<div style="width: 100%;position:absolute;margin-top: 10%" align="center" id="messageArea">
    <div style="width: 800px;font-family:微软雅黑;font-size:16px;height:247px;border:1px solid #e2e2e2;text-align:left;" align="center">
    <div style="float:left; ">
    	<div style=" height:80px; width:80px;background: url(/wui/common/page/images/error_left_wev8.png); margin-top:80px;margin-left:40px!important; margin-left:20px"></div>
    </div>
	<div style=" height:205px; border-left:solid 1px #e8e8e8; margin:20px;margin-top:22px; float:left; margin-left:40px;"></div>
	<div style="height:260px; width:610px; float:left; line-height:25px;">
		
		<%if(labelid==1){ //浏览器版本不支持提醒
		    String browserName=Util.null2String(request.getParameter("browserName"));
		    String browserVersion=request.getParameter("browserVersion");
		    String minVersion="";
		    if(browserName.equals("IE"))
		    	minVersion="IE 8";
		    else if(browserName.equals("FF"))
		    	minVersion="Firefox 9";
		    else if(browserName.equals("Chrome"))
		    	minVersion="Chrome 14";
		    else if(browserName.equals("Safari"))
		    	minVersion="Safari 5";
		%>
		  <p style=" font-weight:normal;color:#fe9200;">
		             <%=SystemEnv.getHtmlLabelName(125379,languageId) +browserName+SystemEnv.getHtmlLabelName(127923,languageId) +browserVersion+"，"+SystemEnv.getHtmlLabelName(125382,languageId) +"，"+SystemEnv.getHtmlLabelName(125383,languageId) +browserName+SystemEnv.getHtmlLabelName(15322,languageId) %><span style="color: #ff3000;"><%=minVersion%></span><%=SystemEnv.getHtmlLabelName(125384,languageId) %><br>
		            <a href="http://windows.microsoft.com/zh-CN/internet-explorer/products/ie/home"  style="text-decoration: underline !important;">IE</a>&nbsp;
		            <a href="http://www.google.cn/chrome/intl/zh-CN/landing_chrome.html" style="text-decoration: underline !important;">Chrome</a>&nbsp;
		            <a href="http://www.firefox.com.cn/download/"  style="text-decoration: underline !important;">Firefox</a>&nbsp;
		            <a href="http://www.apple.com.cn/safari/download/"  style="text-decoration: underline !important;">Safari</a>
		  </p>   
		<%}else if(labelid==2){  //移动设备访问提醒
			 String browserOS=Util.null2String(request.getParameter("browserOS"));
		%>   
			<p style=" font-weight:normal;color:#fe9200;">
	                 <%=SystemEnv.getHtmlLabelName(125385,languageId) %><span style="color: #ff3000;"><%=browserOS%></span><%=SystemEnv.getHtmlLabelName(127924,languageId) %>
            </p>
			
		 <%}else if(labelid==3){
			 String browserOS=Util.null2String(request.getParameter("browserOS"));
			 String browserName=Util.null2String(request.getParameter("browserName"));
		 %>
		     <p style=" font-weight:normal;color:#fe9200;">
	                 <%=SystemEnv.getHtmlLabelName(125385,languageId) %><span style="color: #ff3000;"><%=browserOS + SystemEnv.getHtmlLabelName(127926,languageId) + browserName+ SystemEnv.getHtmlLabelName(125380,languageId)%></span><%=SystemEnv.getHtmlLabelName(127927 ,languageId) %>
             </p>
		 <%}else if(labelid==4){%>
		     <object name="AXDemo" id="AXDemo" height="0" width="0"  classid="clsid:B248518D-6707-4710-BE96-7063C501A9F4" codebase="/weaverplugin/DownloadFilePrj.ocx"></object>
			 <p id="msg" style="font-weight:normal;color:#fe9200;">
	               <%=SystemEnv.getHtmlLabelName(127928,languageId) %><span style="color: #ff3000;">IE8</span><%=SystemEnv.getHtmlLabelName(125384,languageId) %><br>
             </p>
             <script type="text/javascript">
              if(confirm("<%=SystemEnv.getHtmlLabelName(127929,languageId) %>")){   
                   jQuery("#msg").html("<%=SystemEnv.getHtmlLabelName(127930,languageId) %>");
                   try{ 
			           AXDemo.DownloadFileByUrl('<%=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()%>/weaverplugin/IE8-WindowsXP-x86-CHS.exe'); //下载IE8 
			           jQuery("#msg").html("<%=SystemEnv.getHtmlLabelName(127931,languageId) %>"); 
			       }catch(e){
			           jQuery("#msg").html('<%=SystemEnv.getHtmlLabelName(127928,languageId) %><span style="color: red;">IE8</span><%=SystemEnv.getHtmlLabelName(125384,languageId) %><span style="color: red;"><br>'); 
			           alert("<%=SystemEnv.getHtmlLabelName(127932,languageId) %>"); 
			       }
		      }
            </script>
          <%}else if(labelid==5){%>
			 <p id="msg" style="font-weight:normal;color:#fe9200;">
	             <%=SystemEnv.getHtmlLabelName(127933,languageId) %>
	             <a href="/weaverplugin/iWebPlugin.exe"><%=SystemEnv.getHtmlLabelName(7171,languageId) %></a><br>
             </p>
          <%}else if(labelid==123456){%>
          	<p id="msg" style="font-weight:normal;color:#fe9200;">
	               <%=SystemEnv.getHtmlLabelName(127934,languageId) %>"<span style="color: #ff3000;"><%=SystemEnv.getHtmlLabelName(127935,languageId) %></span>"<%=SystemEnv.getHtmlLabelName(127936,languageId) %>
             </p>
		 <%}else if(labelid==129755){%>
			<p id="msg" style="font-weight:normal;color:#fe9200;">
			   <%=SystemEnv.getHtmlLabelName(129755,languageId) %>
			</p>
		 <%}else if(labelid==129757){%>
			<p id="msg" style="font-weight:normal;color:#fe9200;">
			   <%=SystemEnv.getHtmlLabelName(129757,languageId) %>
			</p>
		 <%}else if(labelid==-99999){%>
			 <p id="msg" style="font-weight:normal;color:#fe9200;margin-top: 75px;">
	              <%=SystemEnv.getHtmlLabelName(127937,languageId) %>
             </p>
			 <script type="text/javascript">
			 function finalDo(){
				var loading = top.document.getElementById('loading');
				if(loading){
					try{
							top.document.getElementById('loading').style.display="none";
							//top.finalDo("view");
					}catch(e){
						alert(e);
					}
				}else{
					window.setTimeout(function(){finalDo()},200);
				}
			}
				jQuery(top.document).ready(function(){
					finalDo();
				});
			</script>
		 <%}else{%>
		
			<p style=" font-weight:normal;color:#fe9200;">
					 <%=SystemEnv.getHtmlLabelName(127938,languageId) %>"<span style="color: #ff3000;"><%=msg%></span>"。
			</p>
			<%if(labelid==27889||labelid==27890){%><!-- 主题不支持提醒 -->
				<p style="color:#fe9200">
				<%=SystemEnv.getHtmlLabelName(125386,languageId) +SystemEnv.getHtmlLabelName(125387,languageId) %><a href="/wui/theme/ecology7/page/skinSetting.jsp?skin=default&theme=ecologyBasic"><%=SystemEnv.getHtmlLabelName(125388,languageId) %></a>
				</p>
			  <%}else if(labelid==124796){%>	<!-- 新表单Html设计器不支持提醒 -->
			  	<p style="color:#fe9200">
			     <%=SystemEnv.getHtmlLabelName(127939,languageId) %>
			    </p>
			    <p style="color:#8f8f8f;">
				<%=SystemEnv.getHtmlLabelName(127942,languageId) %>
				</p>
				<p style="color:#8f8f8f;">
				<%=SystemEnv.getHtmlLabelName(127941,languageId) %>
				</p>
			  <%}else{%>
			  <p style="color:#fe9200">
			    <%=SystemEnv.getHtmlLabelName(125386,languageId) %>
			   </p>
			   <p style="color:#8f8f8f;">
				<%=SystemEnv.getHtmlLabelName(127943,languageId) %>
				</p>
				<p style="color:#8f8f8f;">
				<%=SystemEnv.getHtmlLabelName(127941,languageId) %>
				</p>
			  <%}%>	
			 </p>  
		<%}%>	 
		<p style="color:#8f8f8f;">
			<%=SystemEnv.getHtmlLabelName(127944,languageId) %></p>
		</div>
    </div>
    
</div>
</body>
</html>    
  
