<html>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*,HT.HTSrvAPI,java.math.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.systeminfo.setting.*" %>
<jsp:useBean id="rsSkin" class="weaver.conn.RecordSet" scope="page"/>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<head>
    <title>邮件管理</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" type="text/css" href="/wui/common/css/base_wev8.css" />
	
	<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
	<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
	
	<%
		String pslSkinfolder = "defalut";
	           rsSkin.execute("select * from ecology8theme where id=1");
	            if(rsSkin.next()){
	            	String e8skincss = rsSkin.getString("cssfile");
	%>
            	<link rel="stylesheet" id="themecolorfile" type="text/css"  href="/wui/theme/ecology8/skins/default/page/<%=e8skincss %>_wev8.css"> 
            	<STYLE TYPE="text/css" id="themecolor">
            	.logocolor{
					background-color:<%=rsSkin.getString("logocolor")%>!important;
				}
				.logobordercolor{
					border-color: <%=rsSkin.getString("logocolor")%>!important;
				}
				.hrmcolor{
					background-color:<%=rsSkin.getString("hrmcolor")%>;
				}
				.leftcolor{
					background-color:<%=rsSkin.getString("leftcolor")%>!important;
				}
				.topcolor{
					background-color:<%=rsSkin.getString("topcolor")%>;
				}
				</STYLE> 
	        <%
	            }
            %>
		
		<style type="text/css">
			*{
				font-size: 12px;
			}
			center{
				height: 100%;
			}
			#emailCenter{
				padding-bottom: 15px;
			}
			#mailFrameLefttd{
				height: 578px;
				background-color: #2A2E34;
			}
			#drillmenu{
				overflow: auto;
				height: 600px;
				width: 100%;
				margin-top: 15px;
				margin-left: 0;
				padding-botton: 15px;
			}
			#ulWriteBtn{
				width: 225px;
			}
			#ulReceiveBtn{
				width: 225px;
				left: -112px !important;
			}
		</style>
	
</head>
<body style="overflow: hidden;">
	<table style="width:100%;height:100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="width: 225px;" id="mailFrameLefttd" valign="top">
				<div id="drillmenu">
					<jsp:include page="/email/new/leftmenu8.jsp" ></jsp:include>
				</div>
			</td>
			<td style="width:8px; display: none;" valign="top">
				<iframe id="middleIframe" src="/email/MailToggle.jsp" frameborder=no scrolling=no style="width: 100%; height: 100%;"></iframe>
			</td>
			<td width="*" style="" valign="top">
				<iframe src="/email/new/MailInBox.jsp?folderid=0&receivemail=true" name="mainFrame" id="mainFrame" frameborder=no style="width: 100%; height: 100%;"></iframe>
			</td>
		</tr>
	</table>
    
    <script type="text/javascript">
        $(function(){
            var height = $('body').height();
        	$('#drillmenu').height(height);
        	$('#middleIframe').height(height);
            $('#mainFrame').height(height);

            $('#drillmenu').perfectScrollbar();

            
            $('body').resize(function(){
                var bodyHeight = $(this).height();
                $('#drillmenu').height(bodyHeight);
                $('#mainFrame').height(bodyHeight);
                $('#middleIframe').height(bodyHeight);

                
                $('#drillmenu').perfectScrollbar();
            });
        });
    </script>
</body>
</html>

<%--
<frameset id="mailFrameSet" cols="160,8,*" border="0">
    <frame src="/email/new/leftmenu.jsp?frame=mainFrame" name="mailFrameLeft" id="mailFrameLeft" frameborder=no />
    <frame src="/email/MailToggle.jsp" frameborder=no scrolling=no />  
    <frame src="" name="mainFrame" id="mainFrame" frameborder=no />
</frameset>
--%> 

