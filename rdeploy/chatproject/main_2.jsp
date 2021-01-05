<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.rdeploy.portal.PortalUtil"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";


/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
String mainFramesrc = "/rdeploy/im/IMMain.jsp"; 

String frommodel = Util.null2String(session.getAttribute("frommodel"));
if ("addModel".equals(frommodel)) {
    mainFramesrc = "/rdeploy/chatproject/addModel/index.jsp";
}
session.removeAttribute("frommodel");
RecordSet rs = new RecordSet();

Map<String, Map<String, String>> models = new HashMap<String, Map<String, String>>();
List<String> modellist = new ArrayList<String>();
rs.executeSql("SELECT a.modelid, b.modelname from user_model_config a LEFT JOIN system_model_base b ON a.modelid=b.id where userid=" + user.getUID() + " ORDER BY a.orderindex");
while (rs.next()) {
    Map<String, String> bean = new HashMap<String, String>();
    String modelid = rs.getString("modelid");
    bean.put("id", modelid);
    bean.put("name", Util.null2String(rs.getString("modelname")));
    String sicosrc = "";
    String sicosltsrc = "";
    switch (Util.getIntValue(modelid)) {
    case 1:
        sicosrc = "/rdeploy/assets/img/cproj/task.png";
        sicosltsrc = "/rdeploy/assets/img/cproj/task_slt.png";
        break;
    case 2:
        sicosrc = "/rdeploy/assets/img/cproj/workflow.png";
        sicosltsrc = "/rdeploy/assets/img/cproj/workflow_slt.png";
        break;
    case 3:
        sicosrc = "/rdeploy/assets/img/cproj/doc.png";
        sicosltsrc = "/rdeploy/assets/img/cproj/doc_slt.png";
        break;
    case 4:
        sicosrc = "/rdeploy/assets/img/cproj/bing.png";
        sicosltsrc = "/rdeploy/assets/img/cproj/bing_slt.png";
        break;
    case 5:
        sicosrc = "/rdeploy/assets/img/cproj/custom.png";
        sicosltsrc = "/rdeploy/assets/img/cproj/custom_slt.png";
        break;
    case 6:
        sicosrc = "/rdeploy/assets/img/cproj/schedule.png";
        sicosltsrc = "/rdeploy/assets/img/cproj/schedule_slt.png";
        break;
    case 7:
        sicosrc = "/rdeploy/assets/img/cproj/log.png";
        sicosltsrc = "/rdeploy/assets/img/cproj/log_slt.png";
        break;
    default:
    }
    
    bean.put("ico", sicosrc);
    bean.put("icoslt", sicosltsrc);
    
    models.put(modelid, bean);
    modellist.add(modelid);
}

if (modellist.size() == 0) {
    modellist.add("1");
}
%>

<!DOCTYPE HTML>
<html style="height:100%;">
  <head>
    <title></title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">    
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    
    <script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
    <link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/common.css">
    
    <script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
    <script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
    <LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
    <script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
    <link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
    <link href="/wui/theme/ecology8/skins/default/page/left_wev8.css" rel="stylesheet" type="text/css">
    <style>
    html, body {
        margin:0;
        padding:0;
        font-family:'微软雅黑';
        font-size:12px;
    }
    
    a, a:link,a:hover,a:visited{
        text-decoration: none;
        color:#242424; 
    }
    
    a:active{
        background-color:transparent;
    }
    
    
    .head {
        width:100%;
        height:55px;
        background-color:#4baadf;
    }
    .body {
        position:absolute;top:55px;width:100%;bottom:0px;
    }
    
    .body .navblock {
        float:left;width:113px;height:100%;
    }
    .body .conentblock {
        margin-left:113px;height:100%;overflow:hidden;
    }
    .e8_os {
    
    }
    .navblock ul {
        width:100%;
        list-style-type:none;
        margin:0;
        padding:0;
        background-color:#ededed;
        height:100%;
    }
    
    .navblock ul li a {
        display:inline-block;
        width:100%;
        height:41px;
        line-height:41px;
        cursor:pointer;
        color:#8e9598;
    }
    
    .navblock ul li a.selected {
        background-color:#fff;
        color:#4baadf;
    }
    
    .navblock ul li a.slt {
        background-color:#f6f6f6;
    }
    
    .navblock ul li a img {
        width:20px;
        height:20px;
        vertical-align:middle;
        margin-top:-5px;
    }
    
    .nav-text-spacing {
        padding:0 5px;
    }
    .nav-text-spacing-center {
        padding:0 3px;
    }
    
    .classtd {
        display:table-cell;height:55px;vertical-align:middle;
    }
    
    
    /* override */
    .input-group {
        width:295px;
        background-color:#5db2e1;
        border:none;
        float:none;
    }
    .input-group input {
        width:250px;
        padding:0;
        background-color:#5db2e1;
        color:#f2f2f2;
        border:none!important;
    }
    
    ::-webkit-input-placeholder { /* WebKit browsers */
        color:    #e4e4e4;
    }
    :-moz-placeholder { /* Mozilla Firefox 4 to 18 */
        color:    #e4e4e4;
    }
    ::-moz-placeholder { /* Mozilla Firefox 19+ */
        color:    #e4e4e4;
    }
    :-ms-input-placeholder { /* Internet Explorer 10+ */
        color:    #e4e4e4;
    }
    
    .input-group .input-group-btn {
        background:url('/rdeploy/assets/img/cproj/top/searchbtn.png') center center no-repeat;
    }
    .topbtn {
        padding:0;
        border:none;
        height:55px;
        width:24px;
        cursor:pointer;
    }
    .portalbtn {
        background:url('/rdeploy/assets/img/cproj/top/portal.png') center center no-repeat;
    }
    
    .portalbtn:hover {
        background:url('/rdeploy/assets/img/cproj/top/portal_slt.png') center center no-repeat;
    }
    
    .morebtn {
        background:url('/rdeploy/assets/img/cproj/top/more.png') center center no-repeat;
    }
    
    .morebtn:hover {
        background:url('/rdeploy/assets/img/cproj/top/more_slt.png') center center no-repeat;
    }
    
    .closebtn {
        background:url('/rdeploy/assets/img/cproj/top/close.png') center center no-repeat;
    }
    
    .closebtn:hover {
        background:url('/rdeploy/assets/img/cproj/top/close_slt.png') center center no-repeat;
    }
    
    .zDialogTitleTRClass td {
        font-family:'微软雅黑';
        height:45px!important;
        background:#5d9ffe!important;
    }
    </style>
    
    <script>
    
    $(function () {
        $("#navblock ul li a").hover(function () {
            if (!$(this).hasClass("selected")) {
                $(this).addClass("slt");
            }
        }, function () {
            $(this).removeClass("slt");
        });
        
        $("#navblock").on("click", " ul li a ",  function () {
            //if (!$(this).hasClass("selected")) {
                var oldselectedele = $("#navblock ul li a.selected");
                oldselectedele.removeClass("selected");
                oldselectedele.find("img").hide();
                oldselectedele.find("img").eq(0).show();
                
                $(this).removeClass("slt");
                $(this).addClass("selected");
                $(this).find("img").hide();
                $(this).find("img").eq(1).show();
                
                var model=$(this).find("input[name=model]").val();
                
                if(model=="message"){
                    $("#messagediv").show();
                    $("#mainFrame").hide();
                    return;
                }else{
                    $("#messagediv").hide();
                    $("#mainFrame").show();
                    
                    showmodel($(this).find("input[name=model]").val());
                }
            //}
        });
    })
    
    /**
     * 根据model元素的值，变更iframe的src
     */
    function showmodel(modelstr) {
        var iframesrc = "";
        switch(modelstr) {
            case "editmodel":
                iframesrc = "/rdeploy/chatproject/addModel/index.jsp"
                break;
            case "1":   //任务
                iframesrc = "";
                break;
            case "2":   //流程
                iframesrc = "/rdeploy/chatproject/workflow/index.jsp";
                break;
            case "3":   //网盘
                iframesrc = "/rdeploy/chatproject/doc/index.jsp";
                break;
            case "4":   //必应
                iframesrc = "/rdeploy/bing/BingMain.jsp";
                break;
            case "5":   //客户
                iframesrc = "/rdeploy/crm/CRMMain.jsp";
                break;
            case "6":   //日程
                iframesrc = "/rdeploy/chatproject/workplan/WorkPlanView.jsp";
                break;
            case "7":   //日志
                iframesrc = "";
                break; 
                
            case "message":   //消息
                iframesrc = "/rdeploy/im/IMMain.jsp";
                break; 
            case "addrbook":   //通讯录
                iframesrc = "/rdeploy/address/AddressMain.jsp";
                break;   
            default:
                iframesrc = "";
        }
        
        $("#mainFrame").attr("src", iframesrc);
    }
    
    function logout(){
       top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>",function(){
           window.location='/login/Logout.jsp';
       })
   }
   
     
    
       
    $(function () {
        //更多按钮
        jQuery(".toolbarMore").bind("click", function() {
            jQuery("#toolbarMore").hide();
        });
        
        jQuery("#toolbarMoreBtn").hover(function(){
        },function(){
            window.setTimeout(function(){
                if(jQuery("#toolbarMoreBtn").data("isOpen")){
                    jQuery("#toolbarMore").hide();
                    jQuery("#toolbarMoreBtn").removeClass("moreBtnSel");
                    jQuery("#toolbarMoreBtn").data("isOpen",false);
                }
            },600);
        });
        
        jQuery("#toolbarMore").hover(function() {
            jQuery("#toolbarMoreBtn").data("isOpen",false);
        }, function() {
            jQuery("#toolbarMore").hide();
            jQuery("#toolbarMoreBtn").removeClass("moreBtnSel");
            jQuery("#toolbarMoreBtn").data("isOpen",false);
        });
        
        jQuery(".moreBtn_option").hover(function(){
            jQuery(this).addClass("moreBtn_optionSelect");
         },function(){
            jQuery(this).removeClass("moreBtn_optionSelect");
         });
    });
    
    function toolbarMore() {
        jQuery("#toolbarMore").toggle();
        if(jQuery("#toolbarMore").css("display")=="none"){
            jQuery("#toolbarMoreBtn").removeClass("moreBtnSel");
            jQuery("#toolbarMoreBtn").data("isOpen",false);
        }else{
            jQuery("#toolbarMoreBtn").addClass("moreBtnSel");
            jQuery("#toolbarMoreBtn").data("isOpen",true);
            jQuery("#toolbarMoreTD").css({"right":"19px","top":"40px"})
        }
    }
    
    function searchbyws() {
        $("#messagediv").hide();
        $("#mainFrame").show();
        document.getElementById('searchForm').submit();
    }
    
function goopenWindow(title,url){   
    var dlg=new window.top.Dialog();//定义Dialog对象
    var title = title;
    dlg.currentWindow = window;
    //var chasm = screen.availWidth;
    //var mount = screen.availHeight;
    //if(chasm<600) chasm=600;
    //if(mount<500) mount=500;
    dlg.Model=true;
    dlg.Width=730;//定义长度
    dlg.Height=600;
    dlg.URL=url;
    dlg.Title=title;
    dlg.show();
    }

function goUrl(url){
    $("#messagediv").hide();
    $("#mainFrame").show();
    document.getElementById("mainFrame").src = url;
}

function showCalendarDialog(){
    var diag_xx = new Dialog();
    diag_xx.Width = 600;
    diag_xx.Height = 387;
    
    diag_xx.ShowCloseButton=true;
    diag_xx.Title = "<%=SystemEnv.getHtmlLabelName(490,user.getLanguage())%>";
    diag_xx.Modal = false;

    diag_xx.URL = "/calendar/wnl2.jsp";
    diag_xx.show();
}

function setSafeSite(){
  jQuery("#downLoadReg").attr("src","/weaverplugin/EcologyPlugin.zip");
}


function showVersion(){ 
    var dlg=new window.top.Dialog();//定义Dialog对象
    var url = "/systeminfo/version.jsp";
    var title = "关于e-cology";
    dlg.currentWindow = window;
    dlg.Model=true;
    dlg.Width=630;//定义长度
    dlg.Height=400;
    dlg.URL=url;
    dlg.Title=title;
    dlg.show();
}
    </script>
    
  </head>
  
  <body style="height:100%;overflow-y:hidden;">
  <iframe id="downLoadReg" style="display: none;"></iframe>
    <div class="head">
      <table width="100%" height="100%" cellpadding="0" cellspacing="0">
        <colgroup>
          <col width="200px">
          <col width="*">
          <col width="200px">
        </colgroup>
        <tr height="100%">
            <td class="padding-left-18">
                <img src="/rdeploy/assets/img/cproj/top/logo.png" width="180px" height="25px">
            </td>
            <td align="center">
                <form name="searchForm" id="searchForm" method="post" action="/system/QuickSearchOperation.jsp" target="mainFrame">
                <input type="hidden" name="searchtype" value="9">
                <div class="input-group">
                    <input type="text" name="searchvalue" class="form-control" style="margin-left:5px;" placeholder="请输入关键字搜索">
                    <span style="width:5px;display:inline-block;"></span>
                    <span class="input-group-btn" title="搜索" onclick="javascript:searchbyws()">
                    </span>
                </div>
                </form>
            </td>
            <td align="right" class="padding-right-18">
                <input type="button" height="55px" width="24px" class="topbtn portalbtn" title="门户" onclick="window.location.href='/wui/main.jsp'">
                <input type="button" height="55px" width="24px" id="toolbarMoreBtn" class="topbtn morebtn" title="更多" style="padding:0 20px;margin:0 5px!important;" onclick="toolbarMore()">
                <input type="button" height="55px" width="24px" class="topbtn closebtn" title="退出" onclick="logout();"  title="<%=SystemEnv.getHtmlLabelName(1205, user.getLanguage())%>">
            </td>
        </tr>
      </table>
      
      
       <div id="toolbarMore" class="moreBtn" style="top:55px;right:50px;z-index:9999;">
            <div id="toolbarMoreBlockTop" style="background-repeat:no-repeat;height:11px;overflow:hidden;width:184px;"></div>
             <%
             if (PortalUtil.isuserdeploy()) {
             %>
             <div class="moreBtn_option" style="margin-top:-11px;background-color: #d5ecff;color:#228ade;"  onclick="javascript:window.open('/rdeploy/main.jsp')">
                 <span class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/back-end_wev8.png" style="vertical-align:middle;"></span>
                 <span><%=SystemEnv.getHtmlLabelName(633,user.getLanguage())%></span>
             </div>
             
             <%} else { %>
             <div class="moreBtn_option" style="margin-top:-11px;background-color: #d5ecff;color:#228ade;"  onclick="javascript:window.open('/middlecenter/index.jsp')">
                 <span class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/back-end_wev8.png" style="vertical-align:middle;"></span>
                 <span><%=SystemEnv.getHtmlLabelName(83541,user.getLanguage())%></span>
             </div>
             <%} %>
             <div class="moreBtn_option" style=""  onclick="javascript:goUrl('/hrm/HrmTab.jsp?_fromURL=OrgChartHRM')">
                 <span class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/com_wev8.png" style="vertical-align:middle;"></span>
                 <span><%=SystemEnv.getHtmlLabelName(562,user.getLanguage()) %></span>
                 </div>
                 
                 <div class="moreBtn_option" style=""  onclick="javascript:goopenWindow('<%=SystemEnv.getHtmlLabelName(83543,user.getLanguage()) %>','/weaverplugin/PluginMaintenance.jsp')">
                 <span class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/download_wev8.png" style="vertical-align:middle;"></span>
                 <span><%=SystemEnv.getHtmlLabelName(83543,user.getLanguage()) %></span>
                 </div>
                 <div class="moreBtn_option" onclick="javascript:setSafeSite()">
                 <span  class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/plugin_wev8.png" style="vertical-align:middle;"></span>
                 <span><%=SystemEnv.getHtmlLabelName(28422,user.getLanguage()) %></span></div>
                 <div class="moreBtn_option" onclick="javascript:goopenWindow('<%=SystemEnv.getHtmlLabelName(18014,user.getLanguage()) %>','/hrm/HrmTab.jsp?_fromURL=licenseInfo')">
                 <span  class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/license_wev8.png" style="vertical-align:middle;"></span>
                 <span><%=SystemEnv.getHtmlLabelName(18014,user.getLanguage()) %></span></div>
                 <div class="moreBtn_option" onclick="javascript:showVersion()">
                 <span  class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/version_wev8.png" style="vertical-align:middle;"></span>
                 <span><%=SystemEnv.getHtmlLabelName(567,user.getLanguage()) %></span></div>
             </div>
    </div>
    
    <div class="body">
      <!-- 左侧 -->
      <div class="navblock" id="navblock">
        <ul>
          <li style="height:95px;">
            <div style="height:16px;">
            </div>
            <div style="display:table-cell;vertical-align:middle;height:34px;width:112px;text-align:center;">
                <img src="<%=ResourceComInfo.getMessagerUrls(user.getUID() + "") %>" height="34px" width="34px" style="border-radius:20px;">
            </div>
            <div style="height:10px;">
            </div>
            <div style="height:25px;text-align:center;lline-height:25px;">
                <%=user.getLastname() %><%=user.getUID() == 1 ?  "" : (PortalUtil.isAdmin(user) ? "（管理员）":"")%>
            </div>
            <div style="height:10px;">
            </div>
          </li>
          <li>
            <a href="javascript:void 0;"  class="<%="".equals(frommodel) ? "selected" : ""  %>">
              <input type="hidden" name="model" value="message">
              <span class="nav-text-spacing "></span>
              <img src="/rdeploy/assets/img/cproj/msg.png"  style="<%="".equals(frommodel) ? "display:none;" : ""  %>">
              <img src="/rdeploy/assets/img/cproj/msg_slt.png" style="<%=!"".equals(frommodel) ? "display:none;" : ""  %>">
              <span class="nav-text-spacing-center"></span>
                消息
            </a>
          </li>
          <li class="">
          <a href="javascript:void 0;">
            <input type="hidden" name="model" value="addrbook">
            <span class="nav-text-spacing "></span>
            <img src="/rdeploy/assets/img/cproj/addrbook.png">
            <img src="/rdeploy/assets/img/cproj/addrbook_slt.png" style="display:none;">
            <span class="nav-text-spacing-center"></span>
              通讯录
           </a>
          </li>
          <li class="">
          <%
          for (int i=0; i<modellist.size(); i++) {
              String modelid = modellist.get(i);
              Map<String, String> bean = models.get(modelid);
              
              if (bean == null) {
                  continue;
              }
              
              boolean islast = false;
              
          %>
          <a href="javascript:void 0;">
            <input type="hidden" name="model" value="<%=modelid %>">
            <span class="nav-text-spacing "></span>
            <img src="<%=bean.get("ico") %>">
            <img src="<%=bean.get("icoslt") %>" style="display:none;">
            <span class="nav-text-spacing-center"></span>
              <%=bean.get("name") %>
           </a>
          </li>
          
          <%
              if (i < modellist.size() - 1) {
                  %>
                  
          <li class="">
                  
                  <%
              }
          }
          %>
            
            
            
            
          
          <li>
            <div style="height:1px!important;background-color:#ced3d4;margin:0 10px;">
            </div>
          </li>
          
          <li class="">
            <a href="javascript:void 0;" class="<%="addModel".equals(frommodel) ? "selected" : "" %>">
            <input type="hidden" name="model" value="editmodel">
            <span class="nav-text-spacing "></span>
            <img src="/rdeploy/assets/img/cproj/addmdl.png">
            <img src="/rdeploy/assets/img/cproj/addmdl_slt.png" style="display:none;">
            <span class="nav-text-spacing-center"></span>
                添加
            </a>
          </li>
        </ul>
      </div>
      <!-- 右侧 -->
      <div class="conentblock" style="position:relative">
        <div id="messagediv">
		<!--
           <jsp:include page="/rdeploy/im/IMMain.jsp"></jsp:include>
        -->
        </div>
        <iframe name="mainFrame" style="display:none;" id="mainFrame" border="0" frameborder="no" noresize="noresize" 
            width="100%" height="100%" scrolling="auto" src="<%=mainFramesrc %>" style=""></iframe> 
      </div>
    </div>
  </body>
</html>