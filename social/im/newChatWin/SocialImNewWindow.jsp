<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="net.sf.json.*"%>
<%@page import="weaver.social.service.SocialOpenfireUtil"%>
<%@ page import="weaver.social.po.SocialClientProp" %>

<%
//公共部分
//是否是基于openfire部署
boolean IS_BASE_ON_OPENFIRE = SocialOpenfireUtil.getInstanse().isBaseOnOpenfire();
String pcClientSettings = SocialClientProp.serialize();


%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="cache-control" content="max-age">
    <meta http-equiv="expires" content="0">
    <script>
     //加载公共数据
     ClientSet=JSON.parse('<%=pcClientSettings%>');
    </script>
    <script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
    <script src="/social/im/js/social_init.js"></script>
    <!-- 国际化插件 -->
    <script src="/social/js/i18n/jquery.i18n.properties-min-1.0.9.js"></script>
    <script type="text/javascript" src="/social/im/newChatWin/js/NewWinPcUtil.js"></script>
    <link rel="stylesheet" type="text/css" href="css/newWindow.css" />
</head>
<body>
<div class="newWindow">
    <!--窗口顶部-->
    <div class="header clear can-drag">
        <div id="newWindowTitle" class="title"></div>
        <div class="newWindow-close no-drag" title="关闭"></div>
    </div>
    <!--窗口中间空白显示部分-->
    <div class="center">
    <%
    String id = request.getParameter("id");
    String name ="";
    String type = "";
    String hrmids = "";
    String hrmnames = "";
    if(id.equals("8")){
        name = request.getParameter("name");
    }else if (id.equals("10")){
         type = request.getParameter("type");
         hrmids = request.getParameter("hrmids");
         hrmnames = request.getParameter("hrmnames");
    }
    int k = Integer.valueOf(id);
    switch(k){
        case 1:
    %>
        
        <jsp:include page="SocialIMNewPcSysSetting.jsp">
        </jsp:include>
    <%
        break;
        case 2:
    %>
        <jsp:include page="SocialImNewMyFavourite.jsp"></jsp:include>
    <%
        break;
        case 3:
    %>
        <jsp:include page="/social/im/SocialPcAppManager.jsp">
            <jsp:param name="id" value="<%= id %>" />
        </jsp:include>
     <%
        break;
        case 4:
     %>
       <jsp:include page="/social/im/newChatWin/SocialIMNewHrmDialogTab.jsp?_fromURL=GetUserIcon">
           <jsp:param name="loginid" value="<%= user.getLoginid() %>" />
       </jsp:include>
       <%
        break;
        case 5:
     %>
      <iframe src="/social/im/newChatWin/SocialIMNewBrowserMain.jsp?url=/social/im/newChatWin/SocialIMNewMutiResourceBrowser.jsp" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="530" width="100%"></iframe>
    <%
        break;
        case 6:
     %>
      <jsp:include page="/social/im/newChatWin/SocialImNewAlert.jsp">
      </jsp:include>
      <%
        break;
        case 7:
      %>
         <jsp:include page="/social/im/discussManage.jsp?operation=add">
         <jsp:param name="isopenfire" value="<%= (IS_BASE_ON_OPENFIRE?1:0) %>" />
         <jsp:param name="newWin" value="1" />
         </jsp:include>
      <%
        break;
        case 8:
      %>
      <jsp:include page="/social/im/discussManage.jsp?operation=rename">
         <jsp:param name="isopenfire" value="<%= (IS_BASE_ON_OPENFIRE?1:0) %>" />
         <jsp:param name="newWin" value="1" />
         <jsp:param name="orgname" value="<%= name %>" />
      </jsp:include>
      <%
        break;
        case 9:
      %>
       <jsp:include page="/social/im/newChatWin/SocialImNewComfirm.jsp">
         </jsp:include>
       <%
        break;
        case 10:
      %>
      <jsp:include page="/social/im/SocialHrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupAdd&isdialog=1">
      <jsp:param name="type" value="<%= type %>" />
         <jsp:param name="hrmids" value="<%= hrmids %>" />
         <jsp:param name="hrmnames" value="<%= hrmnames %>" />
         </jsp:include>
    <%
    }
    %>
    </div>
</div>  
 <script>
    $(function() {
                window.Electron.ipcRenderer.on('plugin-pcNewWindow-show', function(event, obj){
                    var win = window.Electron.currentWindow;
                    if(obj && obj != 'null') {
                        
                        var _args = obj.args;
                        $('#newWindowTitle').html(_args.title);
                        if(_args.text!==undefined&&_args.text!==''){
                            $('.alertContent').html(_args.text);
                        }
                        var userHost = window.Electron.ipcRenderer.sendSync('global-getHost');
                        $body = $('body');
                        var sizeArr = win.getSize();
                        $body.css('width', sizeArr[0]).css('height', sizeArr[1]);
                        if(!win.isFocused()){
                            win.minimize();
                            win.show();
                        }
                    }
                    
                    $('.newWindow-close').click(function(event) {
                        window.Electron.ipcRenderer.send('plugin-pcNewWindow-close');
                        win.close();
                    });
                });
                
                 window.Electron.ipcRenderer.on('check-update-finished', function(event, args){
                    window.top.Dialog.confirm(social_i18n('UpdateTip3'), function() {
                        PcMainUtils.logout();
                    });
                 });
            });
        </script>
</body>
</html>