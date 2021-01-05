<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.email.domain.*"%>
<%@page import="weaver.general.*"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.regex.Matcher"%>
<%@include file="/page/maint/common/initNoCache.jsp"%>

<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" />
<jsp:useBean id="mrfs" class="weaver.email.service.MailResourceFileService" />

<%!
    public String filterHtmlTags(String htmlStr) {
        htmlStr = Util.null2String(htmlStr);
        
        /*
        String regEx_meta = "<meta[^>]*?>"; // 定义meta的正则表达式
        Pattern p_meta = Pattern.compile(regEx_meta, Pattern.CASE_INSENSITIVE);
        Matcher m_meta = p_meta.matcher(htmlStr);
        htmlStr = m_meta.replaceAll(""); // 定义meta的正则表达式
        
        String regEx_title = "<title[^>]*?>[\\s\\S]*?<\\/title>"; // 定义title的正则表达式
        Pattern p_title = Pattern.compile(regEx_title, Pattern.CASE_INSENSITIVE);
        Matcher m_title = p_title.matcher(htmlStr);
        htmlStr = m_title.replaceAll(""); // 定义title的正则表达式
        
        //String regEx_style = "<style[^>]*?>[\\s\\S]*?<\\/style>"; // 定义style的正则表达式
        //Pattern p_style = Pattern.compile(regEx_style, Pattern.CASE_INSENSITIVE);
        //Matcher m_style = p_style.matcher(htmlStr);
        //htmlStr = m_style.replaceAll("style><\\/style>"); // 过滤style标签
        
        String regEx_cdata = "<!\\[CDATA\\[(.*)\\]\\]>"; // 定义CDATA的正则表达式
        Pattern p_cdata = Pattern.compile(regEx_cdata, Pattern.CASE_INSENSITIVE);
        Matcher m_cdata = p_cdata.matcher(htmlStr);
        htmlStr = m_cdata.replaceAll(""); // 过滤CDATA标签
        */
        
        String regEx_script = "<script[^>]*?>[\\s\\S]*?<\\/script>"; // 定义script的正则表达式
        Pattern p_script = Pattern.compile(regEx_script, Pattern.CASE_INSENSITIVE);
        Matcher m_script = p_script.matcher(htmlStr);
        htmlStr = m_script.replaceAll(""); // 过滤script标签
    
        return htmlStr.trim(); // 返回文本字符串
    }
%>

<html>
    <head>
        <style>
            html {margin:0;padding:0;}
            body {margin:0;padding:5px;color: #000000; font: 12px/1.5 "sans serif",tahoma,verdana,helvetica;}
            body, td {font:12px/1.5 "sans serif",tahoma,verdana,helvetica;}
            body, p, div {word-wrap: break-word;}
            p {margin:5px 0;}
            table {border-collapse:collapse;}
            img {border:0;}
            noscript {display:none;}
        </style>
        
        <script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
                initHeight();
                $('img').load(function(){
                    initHeight();
                });
                
                // 内容中增加超链接在新窗口中打开功能
                $('#mailContentdiv a').attr('target', '_blank');
            });
        
            function initFlashVideo (){}
            
            function initHeight(){
            	var parentHeight=$(parent.document).height();
            	var contentDivHeight=$("#mailContentdiv").height();
            	parent.setContentHeight(contentDivHeight);
            }
        </script>
    </head>
    <body>
        <%
            int mailid = Util.getIntValue(request.getParameter("mailid"), -1);
            String mailContent = "";

            if(mailid != -1) {
                //读取邮件，并加载到缓存中
                mrs.setId(String.valueOf(mailid));
                mrs.setResourceid(String.valueOf(user.getUID()));
                mrs.selectMailResource();
                mrs.next();

                mailContent = mrs.getContent();
                if ("1".equals(mrs.getHashtmlimage())) {
                    mrfs.selectMailResourceFileInfos(String.valueOf(mailid), "0");
                    while (mrfs.next()) {
                        int imgId = mrfs.getId();
                        String thecontentid = mrfs.getFilecontentid();
                        String oldsrc = "cid:" + thecontentid;
                        String newsrc = "http://" + Util.getRequestHost(request) + "/weaver/weaver.email.FileDownloadLocation?fileid=" + imgId;
                        //mailContent = Util.StringReplaceOnce(mailContent, oldsrc, newsrc);
                        mailContent = mailContent.replace(oldsrc, newsrc);
                    }
                }
                mailContent = Util.replace(mailContent, "==br==", "\n", 0);
                
                //对mailContentdiv内容进行过滤
                mailContent = filterHtmlTags(mailContent);
            }
        %>
        <div id="mailContentdiv" style="word-break: break-all;">
            <%=mailContent %>
        </div>
    </body>
</html>
