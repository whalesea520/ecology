
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
  <head>
    <title>安全包提醒</title>
  </head>
<body style="margin:0px;padding:0px;">
<div style="width: 100%;position:absolute;margin-top: 10%" align="center" id="messageArea">
    <div style="width: 800px;font-family:微软雅黑;font-size:16px;height:247px;border:1px solid #e2e2e2;text-align:left;" align="center">
    <div style="float:left; ">
    	<div style=" height:80px; width:80px;background: url(/security/page/images/error_left_wev8.png); margin-top:80px;margin-left:40px!important; margin-left:20px"></div>
    </div>
	<div style=" height:205px; border-left:solid 1px #e8e8e8; margin:20px;margin-top:22px; float:left; margin-left:40px;"></div>
	<div style="height:260px; width:610px; float:left; line-height:25px;">
		

	
			<p style=" font-weight:normal;color:#fe9200;">
	                 <font color="red"><b>请注意，系统启动过程中，安全包初始化失败，系统目前处于不受保护的状态！</b></font><br/>
					 请查看系统启动日志，日志路径如下：<br/>/ecology/WEB-INF/securitylog/systemRunInfo<%=new weaver.filter.XssUtil().getStartDate()%>.log<br/>
					 <a href="/main.jsp" target="_self">返回主页面</a>
            </p>
			
		</div>
    </div>
    
</div>
</body>
</html>    
  
