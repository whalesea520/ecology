<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.docpreview.DocPreviewHtmlManager" %>
<%@ page import="weaver.rdeploy.doc.PrivateSeccategoryManager" %>
<HTML>
    <HEAD>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <%
        RecordSet rs = new RecordSet();
        boolean canread = false;
        boolean ismy = true;
        boolean isdelete = true;
        String extname = "";
        String filename = "";
        boolean readOnLine = false; //是否允许在线查看（否则下载）
        boolean isToDocDspExt = false;
        boolean isNotOffice=false;
        String iframeSrc = "";
        int fileId = Util.getIntValue(request.getParameter("fileid"),0);
        int shareid = Util.getIntValue(request.getParameter("shareid"),0);
        
        String checkSql = "select * from imagefileref where imagefileid = " + fileId;
        rs.executeSql(checkSql);
        if(rs.next()){
           isdelete = false;
             checkSql = "select * from imagefileref where createrid = "+ user.getUID() +" and imagefileid = " + fileId;
            rs.executeSql(checkSql);
            if(rs.next()){
               canread = true;
            }
            
            if(!canread && shareid > 0){
            	PrivateSeccategoryManager psm = new PrivateSeccategoryManager();
                checkSql = "select * from Networkfileshare where id=" + shareid + " and ((sharetype = 1 and tosharerid='" + user.getUID() + "') or (sharetype=2 and tosharerid in(" + psm.getGroupByUser(user) + "))) ";
                rs.executeSql(checkSql);
                if(rs.next()){
                    canread = true;
                }
                ismy = false;
            }
            
            if(!canread)
            {
                checkSql = "select * from Networkfileshare where sharetype = 1 and filetype = 1 and fileid = "+fileId+" and tosharerid = " + user.getUID();
                rs.executeSql(checkSql);
                if(rs.next()){
                   canread = true;
                }
                ismy = false;
            }
            
            if(!canread)
            {
            	PrivateSeccategoryManager psm = new PrivateSeccategoryManager();
                checkSql = "select * from Networkfileshare where sharetype = 2 and filetype = 1 and fileid = "+fileId+" and tosharerid in (" + psm.getGroupByUser(user) +")";
                rs.executeSql(checkSql);
                if(rs.next()){
                   canread = true;
                }
                ismy = false;
            }
            
            String agent = request.getHeader("user-agent");
            if((agent.contains("Firefox")||agent.contains(" Chrome")||agent.contains("Safari") )&& !agent.contains("Edge")){
                isIE = "false";
            }
            else{
                isIE = "true";
            }
            
            request.getSession().removeAttribute("hasRight_"+user.getUID()+"_"+Util.getIntValue(user.getLogintype(),1)+"_0_0_"+fileId);
            if(fileId == 0){
                //错误请求
                return;
            }
            
            if(canread){
                request.getSession().setAttribute("hasRight_"+user.getUID()+"_"+Util.getIntValue(user.getLogintype(),1)+"_0_0_"+fileId,"1");
            }
            
            rs.executeSql("select * from ImageFile where imagefileid=" + fileId);
            if(rs.next())
            {
                filename = Util.null2String(rs.getString("imagefilename"));
                extname = filename.indexOf(".") >=0 ? filename.substring(filename.lastIndexOf(".")) : "";
                extname = extname.toLowerCase();
                
                String IsUseDocPreview=Util.null2String(rs.getPropValue("docpreview","IsUseDocPreview"));
                String docPreviewType_prop=Util.null2String(rs.getPropValue("docpreview","DocPreviewType"));//文档预览方式    1：OpenOffice    2:html


               if(filename.toLowerCase().endsWith("png") || 
                   filename.toLowerCase().endsWith("gif") || 
                   filename.toLowerCase().endsWith("jpg") || 
                   filename.toLowerCase().endsWith("jpeg") || 
                   filename.toLowerCase().endsWith("bmp") ||
                   filename.toLowerCase().endsWith("pdf") ||
                   filename.toLowerCase().endsWith("html") ||
                   filename.toLowerCase().endsWith("htm")) {
                       isToDocDspExt = true;
               }else if((filename.toLowerCase().endsWith("sql") || 
                   filename.toLowerCase().endsWith("json") || 
                   filename.toLowerCase().endsWith("js") || 
                   filename.toLowerCase().endsWith("css") || 
                   filename.toLowerCase().endsWith("txt") ||
                   filename.toLowerCase().endsWith("pdf") ||
                   filename.toLowerCase().endsWith("swf") ||
                   filename.toLowerCase().endsWith("log"))&&IsUseDocPreview.equals("1")){
                       isToDocDspExt = true;
               }   
                
            if(!(filename.toLowerCase().endsWith(".doc") || 
                filename.toLowerCase().endsWith(".docx") || 
                filename.toLowerCase().endsWith(".ppt") || 
                filename.toLowerCase().endsWith(".pptx") || 
                filename.toLowerCase().endsWith(".wps") || 
                filename.toLowerCase().endsWith(".xls") || 
                filename.toLowerCase().endsWith(".xlsx"))){
                isNotOffice = true;//非office文档一定要往pdf预览的界面跳转
            }   
                
                //开启在线预览的时候   
                if(IsUseDocPreview.equals("1")){    //如果开启在线预览
                    //response.sendRedirect("/docs/docpreview/main.jsp?docId="+docid+"&versionId="+versionId);
                    String IsUseDocPreviewForIE=Util.null2String(rs.getPropValue("docpreview","IsUseDocPreviewForIE"));
                    if("false".equals(isIE)||"1".equals(IsUseDocPreviewForIE) || filename.toLowerCase().endsWith(".pdf")){//浏览器非IE或者IE下使用在线预览或者是PDF文件都跳转到pdf预览界面
                        readOnLine = true;  //
                        isToDocDspExt = true;
                    }
                }else if((!"false".equalsIgnoreCase(isIE)) && !isNotOffice){//没开启在线预览并且浏览器是IE并且是office文档的时候，不跳转到pdf预览界面，直接使用金格插件打开
                    readOnLine = false;
                }
                else if(!isToDocDspExt ){                           //非图片、html、pdf文件在没开启在线预览并且浏览器不是IE或者(浏览器是IE但文件不是office文件)的情况都直接根据下载权限进行提示
                    //response.sendRedirect(sysremindurl);
                }

                if(isToDocDspExt){
                    readOnLine = true;
                }
            }
              if(!readOnLine){
                  // iframeSrc = "/weaver/weaver.file.FileDownload?fileid=" + fileId;
              }else if(isIE.equals("false") || isToDocDspExt){
                  boolean isImage = false;
                  if(".png".equals(extname) || ".gif".equals(extname) || ".jpg".equals(extname) || ".jpeg".equals(extname) || ".bmp".equals(extname)){
                      isImage = true; 
                  }
                  iframeSrc = "/docs/docpreview/main.jsp?imageFileId=" + fileId + "&canPrint=true&canDownload=true&docPreviewType=" + (isImage ? 1 : 2);
              }
        }
        
        
        
        %>
        <title><%=SystemEnv.getHtmlLabelName(367, user.getLanguage())%>:<%=filename%></title>
    </HEAD>

    <script type="text/javascript"
        src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
    <script type="text/javascript"
        src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
    <script type="text/javascript"
        src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
    <link rel="stylesheet" href="/css/init_wev8.css" type="text/css" />
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

    <script language="javascript" src="/js/weaver_wev8.js"></script>
    <script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
    <link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css"
        rel="stylesheet"></link>
    <link type="text/css" href="/css/ecology8/crudoc_wev8.css"
        rel="stylesheet"></link>
    <style type="text/css">
html,body {
    height: 100%;
    overflow: hidden;
}

#ext-gen34,#ext-gen29 {
    Line-height: 161% !important;
    font-family: "verdana", "宋体" !important;
}

/**右键菜单*/
#rightClickMenu,#rightClickMenu ul{
    display:none;
    position:absolute;
    width:146px;
    border:1px solid #a4a4a4;
    padding:10px 0px;
    z-index:10;
    background:#f9f9f9;
    box-shadow:1px 2px 1px #E0DBDB;
}
#rightClickMenu li{
    list-style:none;
    line-height:25px;
    height:25px;
    cursor:pointer;
    position:relative;
    padding:0px 10px;
}
#rightClickMenu .lineLi{
    border-bottom:1px solid #d8d8d8;
    height:1px;
    padding:0px;
    margin:5px 0;
    cursor:default;
}
#rightClickMenu ul{
    top:0px;
    right:-146px;
}
#menuUploadDiv{
    position:absolute;
    width:100% ;
    height:25px;
    z-index:10;
}
#menuUploadDiv object{
    width:100% !important;
}

.h2{
    height:4px;
}

.rightMenu span.mtext{
    display:inline-block;
    padding-left:24px;
    background-repeat:no-repeat;
    background-position:left center;
    color:#000000;
    text-overflow:ellipsis;
    white-space:nowrap;
    overflow:hidden;
    width:90px;
}
.rightMenu .rightMenu2 span.mtext{
    width:80px;
}

#rightClickMenu li:hover{
    background-color:rgb(230,230,230);
}

#shareLi span.mtext{
    background-image:url("/rdeploy/assets/img/cproj/operate/menu_share.png");
}
#publicLi span.mtext{
    background-image:url("/rdeploy/assets/img/cproj/operate/menu_public.png");
}
#deleteLi span.mtext{
    background-image:url("/rdeploy/assets/img/cproj/operate/menu_delete.png");
}
#save2DistLi span.mtext{
    background-image:url("/rdeploy/assets/img/cproj/operate/menu_save_disk.png");
} 

.warm_message{
    text-align:center;
    margin-top:20%;
    font-size:18px;
}

.e8_rightBox {
    padding-top: 40px!important;
}
.browserBtn.e8_rightBox{
    padding-top: 6px!important;
} 

#dataloadingbg{
    position:fixed;
    top:0;
    left:0;
    height:100%;
    width:100%;
    background-color:#ffffff;
    filter:alpha(opacity=0);
    opacity:0;
    margin-top:40px;
    z-index:1998;
}
#dataloading{
    text-align:center;
    position:fixed;
    left:45%;
    z-index:1999;
}
#dataloadingbg, #dataloading{
    display:none;
}
</style>
    <%if (user.getLanguage() == 7) {%>
    <script type='text/javascript' src='/js/weaver-lang-cn-gbk_wev8.js'></script>
    <%} else if (user.getLanguage() == 8) {%>
    <script type='text/javascript' src='/js/weaver-lang-en-gbk_wev8.js'></script>
    <%} else if (user.getLanguage() == 9) {%>
    <script type='text/javascript' src='/js/weaver-lang-tw-gbk_wev8.js'></script>
    <% } %>
    <script type="text/javascript">
    jQuery(document).ready(function(){
        jQuery('.e8_box').Tabs({
            getLine:0,
            image:false,
            needLine:true,
            lineSep: ">",
            exceptHeight:true,
            objName:"<%=filename%>",
            mouldID:"<%=MouldIDConst.getID("doc")%>"
         });
         jQuery("div#divTab").show();
    });
    
window.__isBrowser = window.Electron ? false : true;
    
<% if(!isdelete) { if(canread) { %>
//鼠标事件（右键菜单）
jQuery(window).mousedown(function(e){
    e = e || event;
    if(e.button == "0"){
        if(jQuery(e.target).closest("#rightClickMenu").length > 0){
            return;
        }else if(jQuery(e.target).hasClass("cornerMenu")){
            showRightClickMenu();
            return;
        }
        hideRightClickMenu();
    }else if(e.button == "2"){
        if(jQuery(e.target).hasClass("cornerMenu")){
            showRightClickMenu();
        }else{
            showRightClickMenuByHand(e.clientX,e.clientY);
        }
        e.preventDefault();
    }
});
<%}}%>
//屏蔽浏览器默认右键菜单
jQuery(document).unbind("contextmenu").bind("contextmenu", function (e) {
     return false;
 });

//iframe内左右建事件
function displayRightMenu(obj){
    var _document = obj.contentWindow.document;
    jQuery(_document.body).css("height","100%");
    jQuery(_document.body).parent().css("height","100%");
    jQuery(_document.body).bind("contextmenu",function(e){
        showRightClickMenuByHand(e.clientX,e.clientY + (window.__isBrowser ? 60 : 100));
        e.preventDefault;
        return false;
    });
    _document.body.onclick=hideRightClickMenu;      
}

//点击菜单图标显示隐藏菜单
this.showMenu = true;

function showRightClickMenu(){
    if(this.showMenu){
        this.showMenu = false;
        showRightClickMenuByHand(jQuery(window).width() - 151,(window.__isBrowser ? 60 : 100)); 
    }else{
        hideRightClickMenu();
    }
}

//显示右键菜单    
function showRightClickMenuByHand(left,top,f){
    var selectTxt = getSelectTxt();
    jQuery("#copyLi").hide();
    if(window.__isBrowser){
        jQuery("#shareLi").hide();
    }
    jQuery("#rightClickMenu").show().css({
        left : left,
        top : top
    });
}   

function getSelectTxt(){
    var selectTxt = "";
    var selectTxt2 = "";
    if(window.getSelection) {
        selectTxt = window.getSelection().toString();
        if(document.getElementById("doccontentifm")){
            selectTxt2 = document.getElementById("doccontentifm").contentWindow.getSelection().toString();
            
        }
    } else if(document.selection && document.selection.createRange) {
        selectTxt = document.selection.createRange().text;
        if(document.getElementById("doccontentifm")){
            selectTxt2 = document.getElementById("doccontentifm").contentWindow.document.selection.createRange().text;
        }
    }
    return selectTxt + (selectTxt.length > 0 && selectTxt2.length > 0 ? "\n" : "") + selectTxt2;
}

//隐藏右键
function hideRightClickMenu(){
    this.showMenu = true;
    jQuery("#rightClickMenu").hide();
}

//下载    
function onDownLoad(){
    jQuery("#downloadIfr").attr("src","/weaver/weaver.file.FileDownload?fileid=<%=fileId%>&download=1");
}


var shareDialog = null;
var _shareDataMap;
//分享
function onShare(){
    hideRightClickMenu();
    
    _shareDataMap = {
        'folderArray' : [],
        'fileArray' : [
            {
                'id' : '<%=fileId%>',
                'name' : '<%=filename%>',
                'shareid' : ''
            }
        ]
    };
    
    shareDialog = new window.top.Dialog();
    shareDialog.currentWindow = window;
    var url = "/docs/networkdisk/SocialHrmBrowser.jsp";
    shareDialog.Title = "<%=SystemEnv.getHtmlLabelName(129253,user.getLanguage())%>";
    shareDialog.Width = 400;
    shareDialog.Height = 510;
    shareDialog.Drag = true;
    shareDialog.URL = url;
    shareDialog.show();
}

//发布到系统
var publicDialog = null;
function onPublic(dataMap){
    hideRightClickMenu();
    
    var dataMap = {
            folderid : '',
            fileid : '<%=fileId%>',
            shareid : ''
        }
    
    publicDialog = new window.top.Dialog();
    publicDialog.currentWindow = window;
    var url = "/docs/category/MultiCategorySingleBrowser.jsp?hasClear=0&hasCancel=1&hasWarm=1&operationcode=0";
    publicDialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
    publicDialog.Width = 700;
    publicDialog.Height = 400;
    publicDialog.Drag = true;
    publicDialog.URL = url;
    publicDialog.callback = function(data){
        dataMap.categoryid = data.id;
        dataMap.type = "public";
        jQuery.ajax({
            url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
            data : dataMap,
            type : "post",
            dataType : "json",
            success : function(data){
                if(data && data.flag == "1"){
                    if(data.needShare){ //是否需要打开 设置共享
                        docShare(data.dataList);
                    }else{
                        var ids = "";
                        for(var i = 0 ;i < data.dataList.length;i++){
                            if(data.dataList[i].status == "1" && data.dataList[i].docid != ""){
                                ids += "," + data.dataList[i].docid;
                            }
                        }
                        if(ids == ""){
                            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129250,user.getLanguage())%>!");
                            return;
                        }
                        ids = ids.substring(1);
                        jQuery.ajax({
                            url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
                            data : {docids : ids,"type" : "share"},
                            type : "post",
                            dataType : "json",
                            success : function(data){
                                if(data && data.flag == "1"){
                                    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129195,user.getLanguage())%>!");
                                }else{
                                    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129250,user.getLanguage())%>!");
                                }
                            }
                        });
                    }
                }
            },
            error : function(){
            }
        });
    }
    publicDialog.show();
}

//设置共享
var docShareDialog = null;
function docShare(dataList){
    if(!dataList || dataList.length == 0)
        return;
    var ids = "";
    for(var i = 0 ;i < dataList.length;i++){
        if(dataList[i].status == "1" && dataList[i].docid != ""){
            ids += "," + dataList[i].docid;
        }
    }   
    if(ids == "")
        return;
        
    ids = ids.substring(1);
    docShareDialog = new window.top.Dialog();
    docShareDialog.currentWindow = window;
    //var url = "/systeminfo/BrowserMain.jsp?url=/rdeploy/chatproject/doc/DocShareConfirm.jsp?docids=" + ids;
    var url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocShareConfirm.jsp?isdialog=1&datasourceid=" + ids + "&actionid=netdisk";
    docShareDialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
    docShareDialog.Width = 580;
    docShareDialog.Height = 650;
    docShareDialog.Drag = true;
    docShareDialog.URL = url;
    docShareDialog.callback = function(){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129195,user.getLanguage())%>!");
        docShareDialog.close();
    };
    docShareDialog.show();
}
//删除操作
function onDelete(dataMap){
    hideRightClickMenu();
    var dataMap = {
            folderid : '',
            fileid : '<%=fileId%>',
            shareid : ''
        }
    var folderids = dataMap.folderid;
    
    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(129279,user.getLanguage())%>?",function(){
    dataMap.type = "delete";
    jQuery.ajax({
        url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
        data : dataMap,
        type : "post",
        dataType : "json",
        success : function(data){
            if(data && data.flag == "1"){
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20461,user.getLanguage())%>!",function(){
                    window.close();
                });
            }else{
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20462,user.getLanguage())%>!");
            }
        }
    });
});
    
}   

var privateDiaog = null;
function onSave2Disk(){
    hideRightClickMenu();
        
    privateDiaog = new window.top.Dialog();
    privateDiaog.currentWindow = window;
    var url = "/rdeploy/setting/MultiCategorySingleBrowser.jsp?hasClear=0&hasCancel=1&hasWarm=1&type=2";
    privateDiaog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
    privateDiaog.Width = 700;
    privateDiaog.Height = 400;
    privateDiaog.Drag = true;
    privateDiaog.URL = url;
    privateDiaog.callback = function(data){
        if(data && data.id != ""){
            jQuery.ajax({
                url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
                type : "post",
                data : {categoryid : data.id,type : "save2Disk",fileid : "<%=fileId%>"},
                dataType : "json",
                success : function(data){
                    if(data && data.flag == "1"){
                        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>!");
                    }else{
                        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>!");
                    }
                },
                error : function(){
                    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>!");
                }
            });
        }
    }
    privateDiaog.show();
}

function shareFile(sendType,msg,targetId,disName,resourceids,memList) {
    var args = {
        event : 'shareFile-to-us',
        args : {sendType:sendType,Msg:msg,TargetId:targetId,disName:disName,resourceids:resourceids,memList:memList}
    };
    
    window.Electron.ipcRenderer.send('send-to-mainChatWin', args);
}

function finalDo(){
    jQuery("#dataloadingbg, #dataloading").hide();  
}
</script>
    <body class="ext-ie ext-ie8 x-border-layout-ct" scroll="no"
        style="overflow-x: auto;">
        
<%@ include file="/docs/docs/iWebOfficeConf.jsp" %>     
<%

String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

String mServerUrl="/docs/office/"+mServerName;
String mClientUrl="/docs/docs/"+mClientName;

%>      
        <div id="dataloadingbg"></div>
        <div id="dataloading" style="top: 367px;">
            <img src="/rdeploy/assets/img/doc/loading.gif">
        </div>
        <div style="width: 100%; height: 100%;">
            <div id="divContentTab" style="width: 100%; height: 100%;">
                <table id="topTitle" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                        </td>
                        <td class="rightSearchSpan" style="text-align: right;">
                        <%
                            if(!isdelete) {
                                if(canread){
                                %>
                                <input type=button class="e8_btn_top" 
                                    onclick="javascript:onDownLoad()" value="<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>"></input>
                                    <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu middle" ></span>
                                    
                            <%}}%>
                        </td>
                    </tr>
                </table>
                <div class="e8_box demo2">
                    <div class="e8_boxhead">
                        <div class="div_e8_xtree" id="div_e8_xtree"></div>
                        <div class="e8_tablogo" id="e8_tablogo"></div>
                        <div class="e8_ultab">
                            <div class="e8_navtab" id="e8_navtab">
                                <span id="objName"></span>
                            </div>
                            <div>
                            
                            <div id="rightBox" class="e8_rightBox"></div>
                            </div>
                            <script>
                                if(window.__isBrowser){
                                    jQuery("#rightBox").addClass("browserBtn");
                                }
                            </script>
                        </div>
                    </div>
                    <div class="tab_box _synergyBox">
                        <div style="width: 100%; height: 100%;">
                            <div id="divContent" style="width: 100%;height: 100%;">
                                <%if(!isdelete) {
                                    if(canread){
                                        %>
                                <div id="divContentInfo" class="e8_propTab "
                                    style="width: 100%; height: 100%;position:relative">
                                    <%if(readOnLine || ("true".equals(isIE) && !isNotOffice)){
                                        if(isIE.equals("true") && !isToDocDspExt){ %>
                                            <OBJECT id="WebOffice" name="WebOffice" classid="<%=mClassId%>" style="POSITION:absolute;width:0px;height:0px;top:-20px" codebase="<%=mClientUrl%>" >
                                            </OBJECT>   
                                        <%}else{ %>
                                        <iframe id="doccontentifm" onload="displayRightMenu(this)"
                                            style="OVERFLOW: auto; width: 100%; height: 95%;"
                                            class="x-managed-iframe" src="" frameBorder=0></iframe>
                                        <%}
                                    }else{
                                        boolean flag = true;
                                        if(".pdf".equals(extname)){
                                            if(isIE.equals("true")){
                                                
                                            }
                                        }
                                        if(flag){
                                            iframeSrc = "/rdeploy/chatproject/doc/sysRemindDocpreview.jsp?labelid=999";
                                            if(".jpg".equals(extname) || ".jpeg".equals(extname) || ".gif".equals(extname) || ".png".equals(extname) || ".bmp".equals(extname) || ".html".equals(extname) ){
                                            iframeSrc = "/weaver/weaver.file.FileDownload?fileid="+fileId;
                                            }
                                            %>
                                            <iframe id="doccontentifm" onload="displayRightMenu(this)"
                                            style="OVERFLOW: auto; width: 100%; height: 100%;"
                                            class="x-managed-iframe" src="" frameBorder=0></iframe>
                                            <%
                                        }
                                    }
                                    %>
                                </div>
                                <%
                                }
                                    else{
                                        %>
                                        <div style="width: 100%;position:absolute;margin-top: 10%" align="center" id="messageArea">
                                        <div style="width: 800px;font-family:微软雅黑;font-size:16px;height:247px;border:1px solid #e2e2e2;text-align:left;" align="center">
                                        <div style="float:left; ">
                                            <div style=" height:80px; width:80px;background: url(/wui/common/page/images/error_left_wev8.png); margin-top:80px;margin-left:40px!important; margin-left:20px"></div>
                                        </div>
                                        <div style=" height:205px; border-left:solid 1px #e8e8e8; margin:20px;margin-top:22px; float:left; margin-left:40px;"></div>
                                        <div style="height:260px; width:610px; float:left; line-height:25px;">
                                            
                                                 <p id="msg" style="font-weight:normal;color:#fe9200;margin-top:85px">
                                                    <%=SystemEnv.getHtmlLabelName(129297,user.getLanguage())%>
                                                 </p>
                                        
                                            <p style="color:#8f8f8f;">
                                                <%=SystemEnv.getHtmlLabelName(127944,user.getLanguage())%></p>
                                            </div>
                                        </div>
                                        
                                    </div>
                                        <%
                                }}else{
                                    %>
                                    <div style="width: 100%;position:absolute;margin-top: 10%" align="center" id="messageArea">
                                        <div style="width: 800px;font-family:微软雅黑;font-size:16px;height:247px;border:1px solid #e2e2e2;text-align:left;" align="center">
                                        <div style="float:left; ">
                                            <div style=" height:80px; width:80px;background: url(/wui/common/page/images/error_left_wev8.png); margin-top:80px;margin-left:40px!important; margin-left:20px"></div>
                                        </div>
                                        <div style=" height:205px; border-left:solid 1px #e8e8e8; margin:20px;margin-top:22px; float:left; margin-left:40px;"></div>
                                        <div style="height:260px; width:610px; float:left; line-height:25px;">
                                            
                                                 <p id="msg" style="font-weight:normal;color:#fe9200;margin-top:85px">
                                                    <%=SystemEnv.getHtmlLabelName(129298,user.getLanguage())%>
                                                 </p>
                                        
                                            <p style="color:#8f8f8f;">
                                                <%=SystemEnv.getHtmlLabelName(127944,user.getLanguage())%></p>
                                            </div>
                                        </div>
                                        
                                    </div>
                                    <%
                                }
                                %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <ul id="rightClickMenu" class="rightMenu">
            
            <%if(!isdelete) { if(canread) { %>
                <% if(ismy) { %>
                    <li onclick="onShare()" id="shareLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(129144,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(129144,user.getLanguage())%></span></li>
                    <li onclick="onPublic()" id="publicLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%></span></li>
                    <li onclick="onDelete()" id="deleteLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span></li>
                <%}else{ %>
                    <li onclick="onSave2Disk()" id="save2DistLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(129159,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(129159,user.getLanguage())%></span></li>
                <%} %>
                <li onclick="onCopy()" id="copyLi"><span class="mtext"><%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%></span></li>
            <%  }}%>
        </ul>
        
        <iframe src="" style="display:none" id="downloadIfr"></iframe>
    </body>
</html>
<script language="javascript" type="text/javascript">
$(document).ready(
    function(){
        try{
            if(jQuery("#WebOffice").size() > 0){
                onLoad();
            }
        } catch(e){}
        try{
            if(jQuery("#doccontentifm").size() > 0){
                jQuery("#dataloadingbg, #dataloading").show();
                jQuery("#doccontentifm").load(function(){
                    jQuery("#dataloadingbg, #dataloading").hide();
                });
                document.getElementById("doccontentifm").src = "<%=iframeSrc%>";
            }
        } catch(e){}
        try{    
            onLoadEnd();
        } catch(e){}
    }
);

function onLoad(){
     try{
        document.getElementById("WebOffice").WebUrl="<%=mServerUrl%>";
        document.getElementById("WebOffice").RecordID="<%=fileId%>";
        document.getElementById("WebOffice").FileName="<%=filename%>";
        document.getElementById("WebOffice").FileType="<%=extname%>";
        document.getElementById("WebOffice").ShowToolBar="2";      //ShowToolBar:是否显示工具栏:1显示,0不显示  2 :隐藏OFFICE软件工具栏
        document.getElementById("WebOffice").WebOpen();
        document.getElementById("WebOffice").style.width = "100%";
        document.getElementById("WebOffice").style.height = parseInt(jQuery("#WebOffice").parent().height()) + 20 + "px";
     }catch(e){
            //alert("error:"+e.description);
     }
}
</script>
<style>
.x-ie-shadow {
    background-color: #fff; 
    background-color: #777 !important;
}
</style>