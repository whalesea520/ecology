<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.email.service.MailFilePreviewService" %>
<HTML>
    <HEAD>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <%
			RecordSet rs = new RecordSet();
			// 是否允许使用文档预览
			String IsUseDocPreview=Util.null2String(rs.getPropValue("docpreview","IsUseDocPreview"));
			// 预览方式
			String docPreviewType_prop=Util.null2String(rs.getPropValue("docpreview","DocPreviewType"));
			
			String IsUseDocPreviewForIE=Util.null2String(rs.getPropValue("docpreview","IsUseDocPreviewForIE"));
			// 有权限阅读
			boolean canread = true;
			// 已被删除
			boolean isdelete = false;
			String downloadUrl = "";
			// 后缀
			String extname = "";
			// 文件名称
			String filename = "";
			// 是否允许在线查看（否则下载）
			boolean readOnLine = false; 
			boolean isToDocDspExt = false;
			boolean isNotOffice=false;
			String iframeSrc = "";
			int fileId = Util.getIntValue(request.getParameter("fileid"),0);
			
			String agent = request.getHeader("user-agent");
			if((agent.contains("Firefox")||agent.contains(" Chrome")||agent.contains("Safari") )&& !agent.contains("Edge"))
			{
				isIE = "false";
			}
			else
			{
				isIE = "true";
			}
			
			
			// 通过接口获取附件信息
			MailFilePreviewService mfps = new MailFilePreviewService();
			
			Map<String,String>	fileInfo = mfps.getFileInfoMap(user.getUID(),fileId + "");
			
			canread = fileInfo.get("canread").equals("true") ? true : false;
			isdelete = fileInfo.get("isdelete").equals("true") ? true : false;
			downloadUrl = fileInfo.get("downloadUrl");
			
			if(!isdelete)
			{
				filename = Util.null2String(fileInfo.get("filename"));
				extname = filename.indexOf(".") >=0 ? filename.substring(filename.lastIndexOf(".")) : "";
				extname = extname.toLowerCase();
				
			   if(filename.toLowerCase().endsWith("png") || 
				   filename.toLowerCase().endsWith("gif") || 
				   filename.toLowerCase().endsWith("jpg") || 
				   filename.toLowerCase().endsWith("jpeg") || 
				   filename.toLowerCase().endsWith("bmp") ||
				   filename.toLowerCase().endsWith("pdf") ||
				   filename.toLowerCase().endsWith("html") ||
				   filename.toLowerCase().endsWith("htm")) {
					   isToDocDspExt = true;
			   }else if((filename.toLowerCase().endsWith("txt") ||
				   filename.toLowerCase().endsWith("pdf"))&&IsUseDocPreview.equals("1")){
					   isToDocDspExt = true;
				}
					
				if(!(filename.toLowerCase().endsWith(".doc") || 
					filename.toLowerCase().endsWith(".docx") || 
					filename.toLowerCase().endsWith(".ppt") || 
					filename.toLowerCase().endsWith(".pptx") || 
					filename.toLowerCase().endsWith(".wps") || 
					filename.toLowerCase().endsWith(".xls") || 
					filename.toLowerCase().endsWith(".xlsx"))){
					isNotOffice = true;
				}
				if(IsUseDocPreview.equals("1")){
					if("false".equals(isIE)||"1".equals(IsUseDocPreviewForIE) || filename.toLowerCase().endsWith(".pdf")){
						readOnLine = true;
						isToDocDspExt = true;
					}
				}
				else if((!"false".equalsIgnoreCase(isIE)) && !isNotOffice)
				{
					readOnLine = false;
				}

				if(isToDocDspExt){
					readOnLine = true;
				}
			}
			
			if(isIE.equals("false") || isToDocDspExt){
				boolean isImage = false;
				if(".png".equals(extname) || ".gif".equals(extname) || ".jpg".equals(extname) || ".jpeg".equals(extname) || ".bmp".equals(extname))
				{
					isImage = true; 
				}
				iframeSrc = "/docs/view/main.jsp?imageFileId=" + fileId + "&docPreviewType=" + (isImage ? 1 : 2);
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


		.h2{
			height:4px;
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

//下载    
function onDownLoad(){
    jQuery("#downloadIfr").attr("src","<%= downloadUrl %>");
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
                                        <iframe id="doccontentifm"
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
        document.getElementById("WebOffice").RecordID="<%=fileId%>_email";
        document.getElementById("WebOffice").FileName="<%=filename%>";
        document.getElementById("WebOffice").FileType="<%=extname%>";
        document.getElementById("WebOffice").ShowToolBar="1"; //ShowToolBar:是否显示工具栏:1显示,0不显示  2 :隐藏OFFICE软件工具栏
        document.getElementById("WebOffice").WebOpen();
        document.getElementById("WebOffice").style.width = "100%";
        document.getElementById("WebOffice").style.height = parseInt(jQuery("#WebOffice").parent().height()) + 20 + "px";
     }catch(e){
        
     }
}
</script>
<style>
.x-ie-shadow {
    background-color: #fff; 
    background-color: #777 !important;
}
</style>