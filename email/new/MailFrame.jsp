<%-- --%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html> 
<head>
    <title></title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
</head>
<body style="overflow: hidden;">
    
	<table style="width:100%;height:100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="width:165px;" id="mailFrameLefttd">
				<iframe src="/email/new/leftmenu.jsp?frame=mailFrameRight" name="mailFrameLeft" id="mailFrameLeft" frameborder=no style="width: 100%; height: 100%;"></iframe>
			</td>
			<td style="width:8px;">
				<iframe src="/email/MailToggle.jsp" frameborder=no scrolling=no style="width: 100%; height: 100%;"></iframe>
			</td>
			<td width="*" style="">
				<iframe src="/email/new/MailInBox.jsp?folderid=0&receivemail=true" name="mailFrameRight" id="mailFrameRight" frameborder=no style="width: 100%; height: 100%;"></iframe>
			</td>
		</tr>
	</table>
    
    <script type="text/javascript">
        $(function(){
            $('iframe').height($('body').height());
            
            $('body').resize(function(){
                $('iframe').height($(this).height());
            });
        });
    </script>
</body>
</html>

<%--
<frameset id="mailFrameSet" cols="160,8,*" border="0">
    <frame src="/email/new/leftmenu.jsp?frame=mailFrameRight" name="mailFrameLeft" id="mailFrameLeft" frameborder=no />
    <frame src="/email/MailToggle.jsp" frameborder=no scrolling=no />  
    <frame src="" name="mailFrameRight" id="mailFrameRight" frameborder=no />
</frameset>
--%> 

