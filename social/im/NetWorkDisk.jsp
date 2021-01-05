<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.social.po.SocialClientProp" %>
<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv="cache-control" content="max-age">
        <meta http-equiv="expires" content="0">
        <title>我的云盘</title>
       <%String pcClientSettings = SocialClientProp.serialize();%> 
        <script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
		<script  type="text/javascript" src="/social/im/js/IMUtil_Ext_wev8.js"></script>
        
        <style type="text/css">
            .can-drag {
                -webkit-app-region: drag;
            }
            .no-drag {
                -webkit-app-region: no-drag;
            }
            body{
                overflow: hidden;
            }
            .pc-clear {
                clear: both;
            }
            .pc-toolbar {
                float: right;
                padding-right: 1px;
				height: 40px;
				background-color: #4ba9df;
            }

            .pc-imMinBtn {
                width: 26px;
                height: 26px;
                float: left;
                background: url("/social/images/im/pc_min.png") 0 0 no-repeat;
                cursor:pointer;
				margin-top: 5px;
            }
            .pc-imMinBtn:hover,.pc-imMaxBtn:hover,.pc-imMaxBtn-re:hover {
                background-color:#7cc3e0;
            }
            .pc-imMinBtn:active,.pc-imMaxBtn:active,.pc-imMaxBtn-re:active {
                background-color: #4ba9df;
            }

            .pc-imMaxBtn {
                width: 26px;
                height: 26px;
                float: left;
                background: url("/social/images/im/pc_max.png") 0 0 no-repeat;
                cursor:pointer;
				margin-top: 5px;
            }

            .pc-imMaxBtn-re {
                width: 26px;
                height: 26px;
                float: left;
                background: url("/social/images/im/pc_max_re.png") 0 0 no-repeat;
                cursor:pointer;
            }

            .pc-imCoseBtn {
                width: 26px;
                height: 26px;
                float: left;
                background: url("/social/images/im/pc_close.png") 0 0 no-repeat;
                cursor:pointer;
				margin-top: 5px;
            }
            .pc-imCoseBtn:hover {
                background: url("/social/images/im/pc_close1.png") 0 0 no-repeat;
            }
            .pc-imCoseBtn:active {
                background: url("/social/images/im/pc_close2.png") 0 0 no-repeat;
            }

        </style>
    </head>
    <body>
    	<%
		String url = request.getParameter("url");
		%>
        <div > 
               <jsp:include page="<%=url%>">
					
		        </jsp:include>				
        </div>
        <script>
		var ClientSet = {};
        	from = 'pc';
			var versionTag = undefined;
            $(function() {
				ClientSet=JSON.parse('<%=pcClientSettings%>');
                $('#contentall table').addClass('can-drag');
                $('.shareMenu').addClass('no-drag');
                $('.netDiskMenu').addClass('no-drag');
                $('.syncSetting').addClass('no-drag');
               var pcToolbar = '<div class="pc-toolbar pc-clear no-drag none-select">'+
                '<div id="pcMin" class="pc-imMinBtn" title="最小化"></div><!-- 最小化 -->'+
                ' <!-- <div id="pcMax" class="pc-imMaxBtn" title="最大化"></div>最大化 -->'+
                '<div id="pcClose" class="pc-imCoseBtn" title="关闭"></div><!-- 关闭 --></div>'
                 $('#contentall table>tbody>tr').before('<tr  style="background:#4ba9df"><td height="40px"><font style="font-size: 16px;color: white;padding-left: 16px;">云盘</font><td><td height="40px" colSpan="2" style="background:#4ba9df">'+pcToolbar+'<td></tr>')

                     $('#pcMin').click(function(){
                        window.Electron.currentWindow.minimize();
                    });
                        $('#pcClose').click(function(){
                        window.Electron.ipcRenderer.send('plugin-netWorkDisk-close');
                    });
            });
			
			function openUrl(url){
             var args = {
                event : 'open-url-local',
                args : { url : url, urlType : 0 }
                };
               window.Electron.ipcRenderer.send('send-to-mainChatWin', args);
         }
		 function shareFile(sendType,msg,targetId,disName,resourceids,memList) {
			var args = {
				event : 'shareFile-to-us',
				args : {sendType:sendType,Msg:msg,TargetId:targetId,disName:disName,resourceids:resourceids,memList:memList}
			};
			
			window.Electron.ipcRenderer.send('send-to-mainChatWin', args);
		}
        </script>
    </body>
</html>
