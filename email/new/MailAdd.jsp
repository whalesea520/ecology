<%@page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.alibaba.fastjson.JSONObject"%>
<%@page import="com.alibaba.fastjson.JSONArray"%>
<%@page import="weaver.email.po.Mailconfigureinfo"%>
<%@page import="weaver.email.MailReciveStatusUtils"%> 
<%@page import="weaver.hrm.resource.ResourceUtil"%>
<%@page import="weaver.email.domain.MailContact"%>
<%@page import="weaver.email.domain.MailGroup"%>
<%@page import="weaver.email.service.MailManagerService"%>
<%@page import="weaver.general.Util" %>
<%@page import="weaver.email.service.MailSystemSettingService" %>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.conn.RecordSet"%>

<%@include file="/systeminfo/init_wev8.jsp"%>
<%@taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>

<jsp:useBean id="mtus" class="weaver.email.service.MailTemplateUserService" scope="page" />
<jsp:useBean id="mts" class="weaver.email.service.MailTemplateService" scope="page" />
<jsp:useBean id="mms" class="weaver.email.service.MailManagerService" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />
<jsp:useBean id="gms" class="weaver.email.service.GroupManagerService" scope="page" />
<jsp:useBean id="mss" class="weaver.email.service.MailSignService" scope="page" />
<jsp:useBean id="SptmForMail" class="weaver.splitepage.transform.SptmForMail" />
<jsp:useBean id="msst" class="weaver.email.service.MailSettingService" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="weavermailUtil" class="weaver.email.WeavermailUtil" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>

<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>

<script type="text/javascript" src="/email/js/kindeditor/kindeditor-all.js"></script>

<link href="/email/js/autocomplete/jquery.autocomplete_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/email/js/autocomplete/jquery.autocomplete_wev8.js"></script>

<script type="text/javascript" src="/email/js/swfupload/vendor/swfupload/swfupload_wev8.js"/></script>
<script type="text/javascript" src="/email/js/swfupload/vendor/swfupload/swfupload.queue_wev8.js"/></script>
<script type="text/javascript" src="/email/js/swfupload/vendor/swfupload/fileprogress_wev8.js"/></script>
<script type="text/javascript" src="/email/js/swfupload/vendor/swfupload/handlers_wev8.js"/></script>
<script type="text/javascript" src="/email/js/swfupload/src/jquery.swfupload_wev8.js"/></script>

<script type="text/javascript" src="/js/weaver_wev8.js"></script> 
<script type="text/javascript" src="/email/js/progressbar/jquery.progressbar_wev8.js"/></script>
<link type='text/css' rel='stylesheet'  href='/blog/js/treeviewAsync/eui.tree_wev8.css'/>
<script language='javascript' type='text/javascript' src='/blog/js/treeviewAsync/jquery.treeview_wev8.js'></script>
<script language='javascript' type='text/javascript' src='/blog/js/treeviewAsync/jquery.treeview.async_wev8.js'></script>
<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/email/js/autosizetext/jquery.autosizetext_wev8.js"></script>
<script type="text/javascript" src="/email/js/leanModal/jquery.leanModal.min_wev8.js"></script>
<script type="text/javascript" src="/email/js/hotkeys/jquery.hotkeys_wev8.js"></script>
<script type="text/javascript" src="/email/js/easyui/jquery.easyui.min_wev8.js"></script>  
<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/skins/default/wui_wev8.css" />
<script type="text/javascript" src="/js/ecology8/browserCommon_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>

<link rel="stylesheet" href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type="text/css" />
<script type="text/javascript" src=" /js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<script language="javascript" src="/js/datetime_wev8.js"></script>
<script language="javascript" src="/js/selectDateTime_wev8.js"></script>
<script language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<%
    //判断浏览器是否支持select美化，IE8及以下不行
    boolean isNiceSelect = true;
    if("true".equals(isIE)) {
        String agent = Util.null2String(request.getHeader("user-agent"));
        StringTokenizer st = new StringTokenizer(agent,";"); 
        try{
            st.nextToken();
            //得到用户的浏览器名 
            String userbrowser = st.nextToken();
            String versinString = userbrowser.substring(userbrowser.indexOf("MSIE")+4,userbrowser.indexOf(".")).trim();
            int browserVersion = Integer.parseInt(versinString);
            if(browserVersion <= 8) {
                isNiceSelect = false;
            }
        }catch(Exception e){
        }
    }
%>

<%
    float space = 1;
    rst.execute("select totalSpace , occupySpace from HrmResource where id = "+user.getUID());
    if(rst.next()){
        space =  rst.getFloat("totalSpace") - rst.getFloat("occupySpace");
    }
    
    int mailid = Util.getIntValue(request.getParameter("mailId")); // 老邮件模块邮件ID参数
    String fileid = Util.null2String(request.getParameter("fileid"));//发送选中附件
    String fileAccStr = weavermailUtil.getAccInfo(fileid,user);
    if(mailid==-1){
        mailid = Util.getIntValue(request.getParameter("id"));
    }
    
    String to = Util.null2String(request.getParameter("to"));
    int flag = Util.getIntValue(request.getParameter("flag"));
    
    int isInternal =0;
    if(Util.null2String(request.getParameter("isInternal")).equals("")){
        msst.selectMailSetting(user.getUID());
        isInternal = "0".equals(msst.getDefaulttype())?1:0;
    }else{
        isInternal = Util.getIntValue(request.getParameter("isInternal"),0);
    }
    
    String internalto = Util.null2String(request.getParameter("internalto"));
    String internaltodpids = Util.null2String(request.getParameter("internaltodpids"));
    String internalcc = "";
    String internalbcc = "";
    
    //int mailfilesize = MailSystemSettingService.getMailFileSizeSetting(); // 附件大小限制
    
    mtus.selectDefaultMailTemplate(user.getUID());
    
    //默认模版信息
    int templateType = mtus.getTemplatetype();//0:个人模板 1:公司模板
    int defaultTemplateId = mtus.getTemplateid();
    
    //System.out.println("flag=" + flag);
    //System.out.println("templateType=" + templateType);
    //System.out.println("defaultTemplateId=" + defaultTemplateId);
    /**
        flag状态：
            -1：新建邮件 
             1：回复
             2：回复全部
             3：转发
             4：草稿
             5：再次编辑
    */
    
    String subject="";
    String sendfrom ="";
    String sendto = "";
    String sendcc = "";
    String sendbcc = "";
    String toall="";
    String toids="";
    String todpids="";
    String ccall = "";
    String ccids="";
    String bccids="";
    String ccdpids="";
    String bccall="";
    String bccdpids="";
    String mailContent="";
    String defaultSign="";
    String mailaccountid="";
    String priority="";
    String accStr="";
    String accids ="";
    String needReceipt ="";//是否需要回执
    String timingdate =""; //定时发送日期
    defaultSign = mms.getDefaultSign(user.getUID(), user); //发送邮件时添加的默认签名
    if(flag!=-1){
        if(flag ==1){ //回复
            mms.getReplayMailInfo(mailid+"",user);
        }else if(flag==2){ // 回复全部
            mms.getReplayAllMailInfo(mailid+"",user);
        }else if(flag==3){ // 转发
            mms.getForwardMailInfo(mailid+"",user);
        }else if(flag==4 || flag == 5){//草稿箱，或者再次编辑
            mms.getDraftMailInfo(mailid+"",user);
        }
        
        subject = mms.getSubject();
        isInternal = mms.getIsInternal();
        if(isInternal==1){
        
            if(flag ==1){
                //回复的时候，收件人为邮件的发起人
                 toall="";
                 todpids="";
                 toids=mms.getToids();
                 internalto=mms.getToids();
                 
            } else if(flag ==2) {
                //回复全部
                 toall=mms.getToall();
                 todpids=mms.getTodpids();
                 toids=mms.getToids();
                 internalto=mms.getToids();
                ccall =mms.getCcall();
                ccdpids = mms.getCcdpids();
                ccids=mms.getCcids();
                internalcc =mms.getCcids();
                
            }else if(flag ==3){
                 toall="";
                 todpids="";
                 toids="";
                 internalto="";
            }
            else  if(flag==4 || flag == 5){
                toall=mms.getToall();
                todpids=mms.getTodpids();
                toids=mms.getToids();
                internalto=mms.getToids();
                //草稿的时候
                ccall =mms.getCcall();
                ccdpids = mms.getCcdpids();
                ccids=mms.getCcids();
                internalcc =mms.getCcids();

                bccall =mms.getBccall();
                bccdpids =mms.getBccdpids();
                bccids=mms.getBccids();
                internalbcc =mms.getBccids();
                
            }
            sendfrom = mms.getSendfrom();
            
        }else{
            sendfrom = mms.getSendfrom();
            sendto = mms.getSendto();
            sendcc = mms.getSendcc();
            sendbcc = mms.getSendbcc();
        }
        
        mailContent = mms.getContent();
        mailContent = Util.replace(mailContent, "==br==", "\n", 0);
        priority = mms.getPriority();
        
        needReceipt=mms.getNeedReceipt();
        timingdate=mms.getTimingdate();
        
        accStr = mms.getAccStr();
        accids = mms.getAccids();
    }else{
        mas.clear();
        mas.setIsDefault("1");
        mas.setUserid(user.getUID()+"");
        mas.selectMailAccount();
        
        if(mas.next()){
            sendfrom = mas.getAccountMailAddress();
            mailaccountid = mas.getAccountid();
        }
        if(!to.equals("")){
            sendto = to;
        }
         toids=internalto;
         internalto=internalto;
         todpids=internaltodpids;
    }
    
    Mailconfigureinfo mailconfigureinfo = MailReciveStatusUtils.getMailconfigureinfoFromCache();
    int innerMail = mailconfigureinfo.getInnerMail();
    int outterMail = mailconfigureinfo.getOutterMail();
    int totalAttachmentSize = mailconfigureinfo.getTotalAttachmentSize();
    int perAttachmentSize = mailconfigureinfo.getPerAttachmentSize();
    int attachmentCount = mailconfigureinfo.getAttachmentCount();
    int isAll = mailconfigureinfo.getIsAll();
    
    if(innerMail ==1 && outterMail ==0 ){//只开启了内部邮件
        isInternal = 1;
    }
    if(innerMail ==0 && outterMail ==1 ){//只开启了外部邮件
        isInternal =0;
    }
    
    if(flag==1 || flag==2 || flag==3 || flag==-1) {
        //System.out.println("-----------defaultSign=" + defaultSign);
        mailContent = defaultSign + mailContent;
    }
    
    if(flag == 5){
        mailid = -1;//再次编辑，产生新邮件，重置mailid值
        accids  = "";
        accStr = "";
        fileAccStr= mms.getAccStr();
        fileid = mms.getAccids();
    }
    
    session.setAttribute("mailcontent", mailContent);
%>
<%
String date = "";
String time = "";
if(!"".equals(timingdate)){
    date = timingdate.substring(0, 10);
    time = timingdate.substring(11, 16);
}

String fontsize = "";
RecordSet rss = new RecordSet();
rss.executeSql("SELECT fontsize FROM MailSetting WHERE userId="+user.getUID()+"");
if(rss.next()) {
    fontsize = rss.getString("fontsize");
}
if(fontsize==null || "".equals(fontsize))fontsize = "12px";

%>
<html>
<body  style="overflow: auto;">
<form name="mailAddForm" id="mailAddForm" method="post" action="/email/MailOperationSend.jsp" enctype="multipart/form-data">
<input type="hidden" name="accids" id="accids" value="<%=accids%>">
<input type="hidden" name="fileid" id="fileid" value="<%=","+fileid+","%>">
<input type="hidden" name="delaccids" id="delaccids" value="">
<input type="hidden" name="folderid" id="folderid" />
<input type="hidden" name="operation" id="operation" />
<input type="hidden" name="attachmentCount" id="attachmentCount" value="-1" />
<input type="hidden" name="savedraft" id="savedraft" value="0" />
<input type="hidden" name="timingsubmitType" id="timingsubmitType"/>
<input type="hidden" name="msgid" id="msgid" value="" />
<input type="hidden" name="location" id="location" value="1" />
<input type="hidden" name="flag" id="flag" value="<%=flag %>" />
<input type="hidden" name="timingdate" id="timingdate" value="<%=timingdate%>"/>
<input type="hidden" name="tagetmailid" id="tagetmailid" value="<%=mailid %>" />
<input type="hidden" name="autoSave" id="autoSave" value="0" />

<%
if(flag==4){
    %>
    <input type="hidden" name="mailid" id="mailid" value="<%=mailid %>" />
    <%
}else{%>
    <input type="hidden" name="mailid" id="mailid" value="" />
<%}
%>


<table class="w-all h-all "  style="border-spacing: 0px">
    <tr>
        <td width="*" class="p-r-5 p-l-5 p-t-3">
            <table class="w-all h-all">
                <tr height="90px;">
                    <td>
                        <div class="w-all  relative" style="background:#f8f8f8 ">
                            <div class="absolute w-250" style="top: 5px; right: 10px;z-index:1000 ">
                                    
                                    <div class="right" id="miniToolBar" style="border:1px solid #dadada;">
                                        
                                        <div class="btnPage left" style="border-left:0px solid #dadada;width:60px;background:#fff;line-height:22px;">
                                            <div id="addCc" class="left" style="text-align:center;width:100%"><%=SystemEnv.getHtmlLabelName(19809, user.getLanguage())%></div>
                                            <div id="delCc" class="left" style="text-align:center;width:100%"><%=SystemEnv.getHtmlLabelName(81320, user.getLanguage())%></div>
                                            <div class="left"></div>
                                        </div>
                                        <div class="btnPage left" style="width:60px;background:#fff;line-height:22px;text-align:center;">
                                            <div id="addBcc" class="left" style="text-align:center;width:100%"><%=SystemEnv.getHtmlLabelName(19810, user.getLanguage())%></div>
                                            <div id="delBcc" class="left" style="text-align:center;width:100%"><%=SystemEnv.getHtmlLabelName(81321, user.getLanguage())%></div>
                                            <div class="left"></div>
                                        </div>
                                        <div class="left"></div>
                                        
                                    </div>
                                    <div class="clear"></div>
                            </div>
                            <div class="relative h-30 ">
                                <div class="left">
                                    <div class="color666 w-60 p-t-5 left"><%=SystemEnv.getHtmlLabelName(2034, user.getLanguage())%></div>
                                    <div class="left"  <%if(1==innerMail && 1 == outterMail){ %> style="border: 1px solid #e9e9e2"<%} %>>
                                        <p class="field switch">
                                        <%if(1==innerMail && 1 == outterMail){ %>
                                        <label class="cb-enable <%if(isInternal==1){ out.print("selected");}else{out.print("");} %>"><span><%=SystemEnv.getHtmlLabelName(24714, user.getLanguage())%></span></label>
                                        <label class="cb-disable <%if(isInternal!=1){ out.print("selected");}else{out.print("");} %>"><span><%=SystemEnv.getHtmlLabelName(31139, user.getLanguage())%></span></label>
                                        <%}%>
                                        <input type="checkbox" value="1" class="hide" <%if(isInternal==1){ out.print("checked='checked'");} %> name="isInternal" id="isInternal">
                                        </p>
                                    </div>
                                    
                                    <div id="sendFromDiv" class="color666 m-t-5 <%if(1==innerMail && 1 == outterMail){ %> p-l-10<%} %> left">
                                    
                                    <%
                                    mas.clear();
                                    mas.setUserid(user.getUID()+"");
                                    mas.selectMailAccount();
                                    if(mas.getCount() > 0){
                                    %>
                                        <select name="mailAccountId" id="mailAccountId" <% if(!isNiceSelect) { %>notBeauty=true <% } %> >
                                            <%
                                                if(null == sendfrom || "".equals(sendfrom)||flag ==3){
                                                    while(mas.next()){
                                                    if(mas.getIsDefault().equals("1")){
                                                        %>
                                                                <option value="<%=mas.getId()%>" selected="selected"><%=mas.getAccountname() %></option>
                                                            <%
                                                        }else{
                                                        
                                                            %>
                                                                <option value="<%=mas.getId()%>"><%=mas.getAccountname() %></option>
                                                            <%
                                                        }
                                                    }
                                                }else{
                                                    if(flag == 1 || flag == 2) {
                                                        RecordSet rss1 = new RecordSet();
                                                        rss1.executeSql("SELECT sendto FROM mailresource WHERE id="+mailid+"");
                                                        String sendtomail = "";
                                                        if(rss1.next())sendtomail = rss1.getString("sendto");
                                                        while(mas.next()){
                                                            String sendtoMailStr="";
                                                            if(sendtomail!=null&&sendtomail.indexOf(mas.getAccountMailAddress())!=-1){
                                                                %>
                                                                    <option value="<%=mas.getId()%>" selected="selected"><%=mas.getAccountname() %></option>
                                                                <%
                                                            }else{
                                                            
                                                                %>
                                                                    <option value="<%=mas.getId()%>"><%=mas.getAccountname() %></option>
                                                                <%
                                                            }
                                                        
                                                        }
                                                    }else {
                                                        while(mas.next()){
                                                            if(mas.getAccountMailAddress().equals(sendfrom)){
                                                                %>
                                                                    <option value="<%=mas.getId()%>" selected="selected"><%=mas.getAccountname() %></option>
                                                                <%
                                                            }else{
                                                                %>
                                                                    <option value="<%=mas.getId()%>"><%=mas.getAccountname() %></option>
                                                                <%
                                                            }   
                                                        }
                                                    }
                                                
                                                }
                                             %>
                                        </select>
                                    <%} %>
                                    </div>
                                    
                                    
                                    
                                    <div id="sendInternalFromDiv" class="m-t-5 <%if(1==innerMail && 1 == outterMail){ %> p-l-10<%} %> w-150 left">
                                        <%
                                            String[] resourceids=Util.TokenizerString2(Util.null2String(mms.getAllResourceids(""+user.getUID())),","); 
                                            if(resourceids.length>1){
                                        %>
                                                <select name="hrmAccountid" id="hrmAccountid">
                                                    <%for(int i=0;i<resourceids.length;i++){%>
                                                        <option value="<%=resourceids[i]%>" <%=resourceids[i].equals(sendfrom)?"selected":""%>><%=ResourceComInfo.getLastname(resourceids[i])%></option>
                                                    <%}%>
                                                </select>
                                            <%}else{%>
                                                <%=ResourceComInfo.getLastname(resourceids[0])%>
                                                <input type="hidden" name="hrmAccountid" id="hrmAccountid" value="<%=resourceids[0]%>"/>
                                            <%} %>
                                    </div>
                                    
                                    <div class="clear"></div>
                                </div>
                                
                                <div class="clear"></div>
                            </div>
                            
                            <div id="InternalMail"  <%if(isInternal!=1){ out.print("class='hide'"); } %>>
                                <div id="inputTo" class=''>
                                    <div class=" importInternalBtn hand w-60 p-t-5 left" target="internaltoDiv">
                                        <div class="left "><%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%></div>
                                        <div class=" left  relative   " id="addMailsBtn" style="width: 10px;">
                                            <img class="absolute" style="top:7px;left:5px;" src="/email/images/iconDArr_wev8.png"/>
                                        </div>
                                        
                                        <div class="clear"></div>
                                    </div>
                                    <div class="color666  p-t-5 left">
                                        <!--  <input class="w-500" type="hidden" name="to" id="to" value="<%=sendto%>">-->
                                        <%
                                        
                                        String hrmSpan = SptmForMail.getHrmShowNameHref(internalto);
                                        ResourceUtil ru = new ResourceUtil();
                                        String hrmName= ru.getHrmShowName(internalto);
                                        String hrmdpids = ru.getHrmShowDepartmentID(internalto);
                                        String hrmdpname = ru.getHrmDepartmentName(todpids);
                    
                                        //收件人
                                        if(isInternal==1){
                                             hrmName= ru.getHrmShowName(toids);
                                             //hrmdpids = ru.getHrmShowDepartmentID(internalto);
                                             hrmdpname = ru.getHrmDepartmentName(todpids);
                                        }
                                        %>
                                        <input class="mailInputHide" width="20" style="width: 20" type="hidden" name="internalto" id="internalto" value="<%=internalto%>" temptitle="<%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%>">
                                        <input class="mailInputHide" width="20" style="width: 20" type="hidden" relid="internalto" name="internaltodpid" id="internaltodpid" value="<%=todpids%>">
                                        <input class="mailInputHide" width="20" style="width: 20" type="hidden" relid="internalto" name="internaltoall" id="internaltoall" value="<%=toall%>">
                                        <input class="" width="20" style="width: 20" type="hidden" name="internaltohrmname" id="internaltohrmname" value="<%=hrmName%>">
                                        <input class="" width="20" style="width: 20" type="hidden" name="internaltohrmdpid" id="internaltohrmdpid" value="<%=hrmdpids%>">
                                        <input class="" width="20" style="width: 20" type="hidden" name="internaltodpidname" id="internaltodpidname" value="<%=hrmdpname%>">
            
                                        <div class="inputdiv mailInput  w-500" type="hrm" id="internaltoDiv" target="internalto">
                                                            
                                        </div>
                                        
                                    </div>
                                    <div id="addsrz" href="#contactAdd" style="position: static;" class="m-l-10 addFrom left" title="<%=SystemEnv.getHtmlLabelName(31184, user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(31184, user.getLanguage())%></div>
                                    <div name="clearAddressee" _isInternal=1 style="position: static;" class="m-l-10 addFrom left" title="<%=SystemEnv.getHtmlLabelName(127204, user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(127204, user.getLanguage())%></div>
                                    <div class="clear"></div>
                                </div>
                                
                                <div class='inputCc'>
                                    <div class=" importInternalBtn hand w-60 p-t-5 left" target="internalccDiv">
                                        <div class="left "><%=SystemEnv.getHtmlLabelName(17051, user.getLanguage())%></div>
                                        <div class=" left  relative   " id="addMailsBtn" style="width: 20px;;">
                                            <img class="absolute" style="top:7px;left:5px" src="/email/images/iconDArr_wev8.png"/>
                                        </div>                                      
                                        <div class="clear"></div>
                                    </div>
                                    <div class="color666  w-500 p-t-5 left">
                                        <!--  <input class="w-500" type="hidden" name="to" id="to" value="<%=sendto%>">-->
                                        <%
                                        
                                        hrmSpan = SptmForMail.getHrmShowNameHref(internalcc);
                                        
                                        hrmName= ru.getHrmShowName(internalcc);
                                        hrmdpids = ru.getHrmShowDepartmentID(internalcc);
                                        hrmdpname = ru.getHrmDepartmentName(ccdpids);
                                        //抄送人
                                        if(isInternal==1){
                                             hrmName= ru.getHrmShowName(ccids);
                                            // hrmdpids = ru.getHrmShowDepartmentID(internalto);
                                             hrmdpname = ru.getHrmDepartmentName(ccdpids);
                                        }
                                        %>
                                        <input class="mailInputHide" width="20" style="width: 20" type="hidden" name="internalcc" id="internalcc" value="<%=internalcc%>">
                                        <input class="mailInputHide" width="20" style="width: 20" type="hidden" relid="internalcc" name="internalccdpid" id="internalccdpid" value="<%=ccdpids%>">
                                        <input class="mailInputHide" width="20" style="width: 20" type="hidden" relid="internalcc" name="internalccall" id="internalccall" value="<%=ccall%>">
                                        <input class="" width="20" style="width: 20" type="hidden" name="internalcchrmname" id="internalcchrmname" value="<%=hrmName%>">
                                        <input class="" width="20" style="width: 20" type="hidden" name="internalcchrmdpid" id="internalcchrmdpid" value="<%=hrmdpids%>">
                                        <input class="" width="20" style="width: 20" type="hidden" name="internalccdpidname" id="internalccdpidname" value="<%=hrmdpname%>">
                                        
                                        <div class="inputdiv mailInput  w-500" type="hrm" id="internalccDiv" target="internalcc" style="min-height:28px; cursor: text;padding: 0px">
                                                                    
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                </div>
                                
                                <div class='inputBcc'>
                                    <div class=" importInternalBtn hand w-60 p-t-5 left" target="internalbccDiv">
                                        <div class="left "><%=SystemEnv.getHtmlLabelName(81316, user.getLanguage())%></div>
                                        <div class=" left  relative   " id="addMailsBtn" style="width: 20px;;">
                                            <img class="absolute" style="top:7px;left:5px" src="/email/images/iconDArr_wev8.png"/>
                                        </div>
                                        
                                        <div class="clear"></div>
                                    </div>
                                    <div class="color666  w-500 p-t-5 left">
                                        <!--  <input class="w-500" type="hidden" name="to" id="to" value="<%=sendto%>">-->
                                        <%
                                        
                                        hrmSpan = SptmForMail.getHrmShowNameHref(internalbcc);
                                        
                                        hrmName= ru.getHrmShowName(internalbcc);
                                        hrmdpids = ru.getHrmShowDepartmentID(internalbcc);
                                        hrmdpname = ru.getHrmDepartmentName(bccdpids);
                                            //抄送人
                                        if(isInternal==1){
                                             hrmName= ru.getHrmShowName(bccids);
                                            // hrmdpids = ru.getHrmShowDepartmentID(internalto);
                                             hrmdpname = ru.getHrmDepartmentName(bccdpids);
                                        }
                                        %>
                                        <input class="mailInputHide" width="20" style="width: 20" type="hidden" name="internalbcc" id="internalbcc" value="<%=internalbcc%>">
                                        <input class="mailInputHide" width="20" style="width: 20" type="hidden" relid="internalbcc" name="internalbccdpid" id="internalbccdpid" value="<%=bccdpids%>">
                                        <input class="mailInputHide" width="20" style="width: 20" type="hidden" relid="internalbcc" name="internalbccall" id="internalbccall" value="<%=bccall%>">
                                        <input class="" width="20" style="width: 20" type="hidden" name="internalbcchrmname" id="internalbcchrmname" value="<%=hrmName%>">
                                        <input class="" width="20" style="width: 20" type="hidden" name="internalbcchrmdpid" id="internalbcchrmdpid" value="<%=hrmdpids%>">
                                        <input class="" width="20" style="width: 20" type="hidden" name="internalbccdpidname" id="internalbccdpidname" value="<%=hrmdpname%>">
                                    
                                        <div class="inputdiv mailInput  w-500" type="hrm" id="internalbccDiv" target="internalbcc" style="min-height:28px; cursor: text;padding: 0px">
                                                                    
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                </div>
                                
                            </div>  
                            <div id="ExternalMail" <%if(isInternal==1){ out.print("class='hide'"); } %>>
                                <div id="inputTo">
                                    <div class=" importBtn hand w-60 p-t-5 left" target="toDiv">
                                        <div class="left color666"><%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%></div>
                                        <div class=" left relative" target="toDiv" id="addMailsBtn" style="width: 20px;;">
                                            <img class="absolute" style="top:7px;left:5px" src="/email/images/iconDArr_wev8.png"/>
                                        </div>
                                        
                                        <div class="clear"></div>
                                    </div>
                                    <div class="color666  w-500 p-t-5 left">
                                        <%
                                        String[] sendtoMails=sendto.split(",");
                                        String sendtoMailStr="";
                                        for(int i=0;i<sendtoMails.length;i++){
                                            if(sendtoMails[i].equals("") || sendtoMails[i].indexOf("@") == -1)  {
                                                continue; 
                                            }
                                            sendtoMailStr+=","+weavermailUtil.getEmailRealName(sendtoMails[i],user.getUID()+"",false)+"<"+sendtoMails[i]+">"; 
                                        }
                                        sendtoMailStr=sendtoMailStr.length()>0?sendtoMailStr.substring(1):sendtoMailStr;
                                        %>
                                        <input class="mailInputHide" width="20" style="width: 20" type="hidden" name="to" id="to" value="<%=sendtoMailStr%>" temptitle="<%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%>">
                                        
                                        <div class="inputdiv mailInput  w-500" id="toDiv" target="to" style="min-height:28px; cursor: text;padding: 0px">
                                            
                                        </div>
                                        
                                    </div>
                                    <div id="addContactGroup" style="position: static;" class="m-l-10 addFrom left" title="<%=SystemEnv.getHtmlLabelName(129761, user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(129761, user.getLanguage())%></div>
                                    <div name="clearAddressee" _isInternal=0 style="position: static;" class="m-l-10 addFrom left" title="<%=SystemEnv.getHtmlLabelName(127204, user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(127204, user.getLanguage())%></div>
                                    <div class="clear"></div>
                                </div>
                                
                                
                                
                                <div class="inputCc">
                                    <div class=" importBtn hand w-60 p-t-5 left" target="ccDiv">
                                        <div class="left "><%=SystemEnv.getHtmlLabelName(17051, user.getLanguage())%></div>
                                        <div class=" left  relative   " id="addMailsBtn" style="width: 20px;;">
                                            <img class="absolute" style="top:7px;left:5px" src="/email/images/iconDArr_wev8.png"/>
                                        </div>
                                        
                                        <div class="clear"></div>
                                    </div>
                                    
                                    <%
                                        String[] sendccMails=sendcc.split(",");
                                        String sendccMailStr="";
                                        for(int i=0;i<sendccMails.length;i++){
                                            if(sendccMails[i].equals("") || sendccMails[i].indexOf("@") == -1)  {
                                                continue; 
                                            }
                                        sendccMailStr+=","+weavermailUtil.getEmailRealName(sendccMails[i],user.getUID()+"",false)+"<"+sendccMails[i]+">"; 
                                        }
                                        sendccMailStr=sendccMailStr.length()>0?sendccMailStr.substring(1):sendccMailStr;
                                    %>
                                    <div class="color666  w-500 p-t-5 left">
                                    <input class="mailInputHide " style="width: 90%" type="hidden" name="cc" id="cc" value="<%=sendccMailStr%>">
                                    <div class="inputdiv mailInput w-500" id="ccDiv" target="cc" style="min-height: 28px;cursor: text;padding: 0px"></div>
                                    
                                    </div>
                                    <div class="clear"></div>
                                </div>
                                    
                                    
                                <div class="inputBcc">
                                    <div class=" importBtn hand w-60 p-t-5 left" target="bccDiv">
                                        <div class="left "><%=SystemEnv.getHtmlLabelName(81316, user.getLanguage())%></div>
                                        <div class=" left  relative   " id="addMailsBtn" style="width: 20px;;">
                                            <img class="absolute" style="top:7px;left:5px" src="/email/images/iconDArr_wev8.png"/>
                                        </div>
                                        
                                        <div class="clear"></div>
                                    </div>
                                    <div class="color666  w-500 p-t-5 left">
                                    <input class="mailInputHide" style="width: 90%" type="hidden"  name="bcc" id="bcc" value="<%=sendbcc%>">
                                    
                                    <div class="inputdiv mailInput w-500" id="bccDiv"  target="bcc" style="min-height:28px;cursor: text;padding: 0px">
                                                
                                    </div>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            </div>
                                    <div class="clear"></div>
                                </div>
                            </div>  
                            
                            <div>
                                <div class="color666 w-60 p-t-5 left"><%=SystemEnv.getHtmlLabelName(344, user.getLanguage())%></div>
                                <div class="color666  w-500 p-t-5 left">
                                    <input class="w-500 inputdiv mailInput" type="text" style="height:28px; line-height:28px; width:502px; padding: 0px;" id="subject" name="subject" maxlength="600" value="<%=subject %>" temptitle="<%=SystemEnv.getHtmlLabelName(344, user.getLanguage())%>" >
                                    <span id="subjectSpan1" class='hide'><%if(subject.equals("")) out.print("<img src='/images/BacoError_wev8.gif' align=\"absMiddle\">"); %></span>
                                </div>
                                <div class="clear"></div>
                            </div>
                            
                            
                            <div style="padding-left: 60px;" class="p-b-10">
                                <div class="color666 w-60 p-t-5 left m-r-20">
                                    <div class="swfupload-control left hand">
                                        <span id="spanButtonPlaceholder" ><%=SystemEnv.getHtmlLabelName(19812, user.getLanguage())%></span>
                                    </div>
                                </div>
                                
                                <div style="float: none;" class="color666 p-t-10">
                                    <span id="uploadInfo"></span>
                                </div>
                                
                                <div class="color666  w-500 p-t-5 left ">
                                        <%=accStr %>
                                        <%=fileAccStr %>
                                    <div id="progressDemo" class="hide">
                                        <div class="left m-t-3" style="background: url(/email/images/mailicon_wev8.png) -65px 0px  no-repeat ;width: 16px;height: 16px;">&nbsp;</div>
                                        <div class="left fileName p-b-3"  ></div>
                                        <div class="left fileSize p-l-5" ></div>
                                        <div class="left p-l-15 " ><div class="fileProgress m-b-5"><%=SystemEnv.getHtmlLabelName(83091, user.getLanguage())%>…</div></div>
                                        <div class="left p-l-15" ><a class="del" href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a></div>
                                        <div class="clear"></div>
                                    </div>
                                    <div id="fsUploadProgress"></div>
                                <input class="w-500" type="hidden" id="acc" value=""></div>
                                <div class="clear"></div>
                            </div>
                    </td>
                </tr>
                <tr>
                    <td height="*" class="">
                        <div id="editor" class="w-all">
                            <textarea class="w-all" style="height:300px;width:100%" id="mouldtext" name="mouldtext"></textarea>
                        </div>
                        
                        <!-- jquery_1.8.3下,lable for不起作用，jnice不能自动勾选 -->
                        <div id="toolBar" class="m-t-20">
                            <div class="left m-r-20">
                                <button class="btnGreen" type="button" onclick="doSubmit(this)"><%=SystemEnv.getHtmlLabelName(2083, user.getLanguage())%></button>
                                <button id="savebtn" class="btnGray" type="button" onclick="doSave(this)"><%=SystemEnv.getHtmlLabelName(220, user.getLanguage())%></button>
                            </div>
                            <div class="color666    left m-l-15  p-l-15"" id="prioritydiv">
                                <%if("1".equals(mms.getPriority())){ %>
                                        <input type="checkbox"  name="priority" id="priority" value="1" checked="checked">
                                    <% }else {%>
                                        <input type="checkbox"  name="priority" id="priority" value="1">
                                    <%} %>
                                        <label><%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())%></label>
                            </div>
                            <div class="left m-l-15 color666   p-l-15  ">
                                <input class=" " type="checkbox" name="savesend" id="savesend" value="1" checked="checked"> <label><%=SystemEnv.getHtmlLabelName(2092, user.getLanguage())%></label>
                            </div>
                            
                            <div class="left p-l-15 color666">
                                <input class=" p-r-5" type="checkbox" name='texttype' id="texttype" value="1" onclick="changeHTMLEditor(this)"><label><%=SystemEnv.getHtmlLabelName(19111, user.getLanguage())%></label>
                            </div>

                            <div class="left p-l-15 color666" id="needReceiptDiv">
                                <input class=" p-r-5" type="checkbox" name='needReceipt' id="needReceipt" value="1"><label><%=SystemEnv.getHtmlLabelName(25233, user.getLanguage())%></label>
                            </div>
                            <div class="left p-l-15 color666">
                                <input class=" p-r-5" type="checkbox" name='timeSetting' id="timeSetting" value="1" onclick="showTimeSetting(this)"><label> <%=SystemEnv.getHtmlLabelName(32028, user.getLanguage())%></label>
                                <span class=" p-l-15" id="timeSettingSpan">
                                    <button class="calendar" id="SelectDate" onclick="getDate('datespan','date')" type="button"></button>
                                    <SPAN id="datespan"><%=date%></SPAN><input type="hidden" name="date" id="date" value="<%=date%>">&nbsp;－&nbsp;
                                    <button class="Clock" style="height:16px" onclick="onShowTime(timespan,time)" type="button"></button>
                                    <span id="timespan"><%=time%></span><input type="hidden" name="time" id="time"  value="<%=time%>"/>
                                </span>
                            </div>
                            <div class="clear"></div>
                        </div>
                    </td>
                </tr>
                
                <tr style="height:20px;">
                    <td style="height:20px;"></td>
                </tr>
                
            </table>
        </td>
        <td width="208px" class="p-r-5 p-b-5 p-t-5 ">
            
            <table class="w-all" id="contacterTab" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td height="31px">
                        <div id="tabTitle" >
                            
                            <div id="internalContacter">
                                <div id="innerHrmTab" style="cursor:pointer;" class="left tab tabSelected tabitem1" target="innerHrmContent"><%=SystemEnv.getHtmlLabelName(572, user.getLanguage())%></div>
                                <div id="privateTab" style="cursor:pointer;" class="left tab  tabUnSelected tabitem1" target="privateContent"><%=SystemEnv.getHtmlLabelName(81554, user.getLanguage())%></div>
                                <div class="clear"></div>   
                            </div>
                            <div id="outerContacter" style="display:none;">
                                <div id="innerContacterTab" style="" class="left tab tabSelected tabitem2" target="innerHrmContent"><%=SystemEnv.getHtmlLabelName(83092, user.getLanguage())%></div>
                                <div id="customTab" class="left tab  tabUnSelected tabitem2" target="contactsContent"><%=SystemEnv.getHtmlLabelName(83093, user.getLanguage())%></div> 
                                <div class="clear"></div>
                            </div>
                            <div class="clear"></div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="tabContent  h-all" id="contactsContent">
                            <div class="p-l-10 p-t-10 relative" id="searchBar">
                                <input class="w-150 " type="text" id="fromSearch" > 
                                <div id="searchBtn" class="searchFrom"></div>
                                
                                <div id="addFrom" href="#contactAdd" style="font-size:20px;top:5px;" class="addFrom"  title="<%=SystemEnv.getHtmlLabelName(19956,user.getLanguage()) %>" onclick="addContact()">+</div>
                            </div>
                            <div id="contactsContent">
                                <!-- 联系人列表 -->
                                <div id="contactsTree" class="m-t-10">
                                </div>
                            </div>
                        </div>
                       
                        <!-- 内部员工 -->
                        <div id="innerHrmContent" class="tabContent h-all hide relative" >
                            <div onclick="reflashHrmTree(this)" style="position: absolute;left: 160px;padding-left: 2px;padding-right: 5px;margin-top: 5px;z-index: 11">
                                <img id="showaccounthrm" style="cursor:pointer;" src="/hrm/css/zTreeStyle/img/noaccounthide_wev8.png" title="显示无账号人员">
                                <img id="hideaccounthrm" style="cursor:pointer;" class="hide" src="/hrm/css/zTreeStyle/img/noaccountshow_wev8.png" title="隐藏无账号人员">
                            </div>
                            <ul id="innerHrmTree" style="width: 100%"></ul> 
                        </div>
                        <!-- 私人组 -->
                        <div id="privateContent" class="tabContent h-all hide relative" >
                            <ul id="hrmOrgTree" style="width: 100%"></ul>
                        </div>
                        
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    
</table>
<ul class="btnGrayDropContent importBtnDown hide " style="width: 100px;left: 0px;top:28px;" >
                                                
    <li class=""  style="font-weight: normal;line-height: 20px;" onclick="onShowResourcemail(this,'hrm')" ><button type="button" class="Browser"  title="<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>"></button><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></li>
    <!--
    <li class=""  style="font-weight: normal;line-height: 20px;" onclick="onShowResourcemail(this,'contacter')" ><button type="button" class="Browser"  title="<%=SystemEnv.getHtmlLabelName(17129,user.getLanguage())%>"></button><%=SystemEnv.getHtmlLabelName(17129,user.getLanguage())%></li>
    -->                                             
</ul>

<ul class="btnGrayDropContent importInternalBtnDown hide " style="width: 100px;left: 0px;top:28px;" >
                                                
    <li class=""  style="font-weight: normal;line-height: 20px;" onclick="onShowResource(this)" >
        <button type="button" class="Browser"  title="<%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%>"></button><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%>
    </li>
    <li class=""  style="font-weight: normal;line-height: 20px;" onclick="onShowDepartment(this)" ><button type="button" class="Browser"  title="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>"></button><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></li>
    <%if(isAll == 1) {%>
        <li class=""  style="font-weight: normal;line-height: 20px;" onclick="onShowAllResouceLi(this,event)" ><input type="checkbox" class="" onclick="onShowAllResouce(this,event)" title="<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>"><label><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></label></li>
    <% }%>
</ul>
</form>

<!-- 添加联系人 -->
<div id="contactAdd" class=" popWindow hide "></div>

<div  id="hidedivmsg" class="hide">
    <div class="h-30"></div>
    <table style="width: 100%">
        <tr class="h-35">
            <td class="p-l-30 p-r-15">
                <span class="color333 font12 w-100"><%=SystemEnv.getHtmlLabelName(19826,user.getLanguage()) %></span>
            </td>
            <td>
                <input type="text" class="w-300 styled input"  name="srzname" id="srzname" onchange='checkinput("srzname","srznamespan")'  maxlength="50">
                <span name="srznamespan" id="srznamespan" class="hide"><img src='/images/BacoError_wev8.gif' align="absMiddle"></span>
            </td>
            <td>
            </td>
        </tr>
        <tr class="h-35">
            <td class="p-l-30 p-r-15" valign="top">
                <span class="color333 font12 w-100"><%=SystemEnv.getHtmlLabelName(431,user.getLanguage()) %></span>
            </td>
            <td>
                <div class="w-300">
                    <ul style="overflow: auto;;height: 100px;" id="srzulid">
                    </ul>
                </div>
            </td>
        </tr>
    </table>
</div>
<style>
    .closeLb{
        background: url("/email/images/closeNew_wev8.png") left center;
        background-repeat: no-repeat;
        width: 18px;
        height: 20px;
        margin-right: 5px;
        z-index: 10000;
    }

<%if(isIE.equals("true")){%>
/* Used for the Switch effect: */
    .cb-enable {  display: block; float: left; }

    .cb-enable span {  background-position-x: left;background-position-y: -25px;padding: 0 10px;  }

    .cb-disable {  display: block; float: left; }

    .cb-disable span {  background-position-x: right;background-position-y: -25px;padding: 0 10px;  }

    .cb-enable span, .cb-disable span { line-height: 25px; display: block; background-repeat: no-repeat; font-weight: bold; }

    .selected { background-repeat: repeat-x; background-position: left -50px; }

    .selected span { background-repeat: no-repeat; background-position-y: -75px; color: #fff; }
    
    .switch label { cursor: pointer; }
    <%}else{%>
    .cb-enable, .cb-disable, .cb-enable span, .cb-disable span { /*background: url(/email/images/switch_wev8.gif) repeat-x;*/ display: block; float: left; }
    .cb-enable span, .cb-disable span { line-height: 25px; display: block; background-repeat: no-repeat; font-weight: bold; }
    .cb-enable span { background-position: left -75px; padding: 0 10px; }
    .cb-disable span { background-position: right -150px;padding: 0 10px; }
    .cb-disable.selected { background-position: 0 -25px; }
    .cb-disable.selected span { background-position: right -175px; color: #fff; }
    .cb-enable.selected { background-position: 0 -50px; }
    .cb-enable.selected span { background-position: left -125px; color: #fff; }
    .switch label { cursor: pointer; }
    <%}%>
</style>

<!-- 遮罩层 -->
<DIV id=bgAlpha></DIV>
<div id="loading">  
    <span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
    <span  id="loading-msg" style="font-size:12"><%=SystemEnv.getHtmlLabelName(31199, user.getLanguage())%>...</span>
</div>

    
</body>
</html> 
<style>
.sapn_top{
        padding-top:5px !important ;
        padding-top:2px ;
}

 table td{
    vertical-align: top;
 }
.ke-container{
    width: 100%!important;
}


 .inputSelected{
    border: 1px solid #bababa !important;
 } 

 div{
    font-size: 12px;
 }
 .overText{
    display:inline-block;
    overflow: hidden;
    white-space: nowrap;
    -o-text-overflow: ellipsis; /*--4 opera--*/
    text-overflow: ellipsis;
 }
 .spanBtn{
    
    margin-left:5px;
    padding:1px;
    cursor: pointer;
 }
 .spanBtnOver{
    padding:1px;
    cursor: pointer;
    color:#ffffff;
    background: #0083ff;
    border-radius:3px;
    margin-left:5px;    
 }
 
 .mailAdSelect{ 
    color:#ffffff!important;
    background: #0083ff !important;
    border-radius:3px;      
 }
 
 .mailAdOK{
    background: #DBF2E0;
    border-color:#8EAF95;
    border-radius:2px;  
 }
  .mailAdOK span{
    vertical-align: middle;
    margin-left: 5px;
  }
 .mailAdError{  
    color:#c30;
    background:  #FFEAEA;
    border-radius:3px;      
 }

 .tab{
    width: 102px !important ;
    height: 30px;
    border-top-left-radius:3px;
    border-top-right-radius:3px;
    border: 1px solid #cccccc;
    outline-color:#222222;
    line-height: 30px;
    text-align:center;
    color:#222222;
    font-weight: bold;
    cursor:pointer;
 }
 .tabSelected{
    background: #ffffff;
    border-bottom:0px;
 }
 .tabUnSelected{
    background: #eeeeee;
 }
 
 .tabContent{
    border-bottom: 1px solid #cccccc;
    border-left: 1px solid #cccccc;
    border-right: 1px solid #cccccc;
    
    overflow-y: scroll;
    overflow-x: hidden;
 }
 
 .searchFrom{
    background: url('/email/images/search_wev8.png') no-repeat;
    width: 13px;
    height: 13px;
    position: absolute;
    cursor: pointer;
    left: 138px;
    top:15px;
 }
  .clearFrom{
    color:#cccccc;
    width: 13px;
    height: 13px;
    position: absolute;
    cursor: pointer;
    left: 145px;
    top:13px;
    font-family: verdana!important;
 }
 
  .addFrom{
    /*background: url('/email/images/add_wev8.png') no-repeat;*/
    /*width: 60px;*/
    height: 35px;
    line-height: 35px;
    position: absolute;
    cursor: pointer;
    left: 160px;
    top:15px;
    font-size:12px;
    color:#0183fd;
 }
 .addFrom:hover{
    /*background: url('/email/images/addOver_wev8.png') no-repeat;*/
    color:#0183fd;
 }

 .contactsItem{
    height: 24px;
    line-height:24px;
    
 }
 .contactsItemOver{
    background: whiteSmoke;
 }
 
 .contactsFold{
    margin-top: 5px;
 }
 
 .ke-icon-sign {
    width: 16px;
    height: 16px;
    background:url("/email/images/sign_wev8.png"); 
    background-repeat: no-repeat;
}

 .ke-icon-mailTemplate {
    width: 16px;
    height: 16px;
    background:url("/email/images/template_wev8.png"); 
    background-repeat: no-repeat;
}

 .ke-icon-doc{
    width: 16px;
    height: 16px;
    background:url("/email/images/app-doc_wev8.png"); 
    background-repeat: no-repeat;
}

.ke-icon-project{
    width: 16px;
    height: 16px;
    background:url("/email/images/app-project_wev8.png"); 
    background-repeat: no-repeat;
}

.ke-icon-crm{
    width: 16px;
    height: 16px;
    background:url("/email/images/app-crm_wev8.png"); 
    background-repeat: no-repeat;
}

.ke-icon-workflow{
    width: 16px;
    height: 16px;
    background:url("/email/images/app-wl_wev8.png"); 
    background-repeat: no-repeat;
}

.ke-icon-task{
    width: 16px;
    height: 16px;
    background:url("/email/images/app-task_wev8.png"); 
    background-repeat: no-repeat;
}

.ke-icon-workplan{
    width: 16px;
    height: 16px;
    background:url("/workplan/calendar/css/images/icons/appt_wev8.gif"); 
    background-repeat: no-repeat;
}



 BUTTON.Browser{
    height: 16px;
 }
 
 .editableAddr-ipt{
    position:relative;
    left: 0;
    top: 0;
    width: 100%;
    font-family: tahoma,verdana;
    margin: 0;
    padding: 0;
    display: inline;
    border: 0;
    outline: 0;
    background: transparent;

    
}
.editableAddr-txt{
    visibility: hidden;
    color: #999;
    
}
.editableAddr {
    float: left;
    margin:3px;
    white-space: nowrap;
    position: relative;
    max-width: 465px;
    
    height: 15px;
    line-height: 15px;
    color: #999;
    font-size: 12px;
    cursor: text;
    
}

.mailInput{
    min-height: 28px;
    height:auto !important;height:28px;
    display: block;
    cursor: text;
    padding: 0px;
}

.huotu_dialog_overlay
    {
        z-index:99991;
        position:fixed;
        filter:alpha(opacity=30); BACKGROUND-COLOR: rgb(0, 0, 0);
        width:100%;
        bottom:0px;
        height:100%;
        top:0px;
        right:0px;
        left:0px;
        opacity:0.3;
        _position:absolute!important;       
        margin: 0px;
        padding: 0px;
        overflow: hidden;
        display: none;
    }
    .bd_dialog_main
    {   
    
          box-shadow:rgba(0,0,0,0.2) 0px 0px 5px 0px;
          border: 2px solid #90969E;
          background: #ffffff;
         display: none; 
         z-index:99998;
         position:fixed;
        _position:absolute!important;   
         width: 400px; 
         height: 200px; 
         background-color:white;    
         text-align: left; 
         line-height: 27px; 
         font-size:14px;
         font-weight: bold; 
    }
    .li_decimal{ list-style-type:decimal ; list-style-position: inside;}
    
    .mailAdItem{
        white-space: nowrap;
        cursor: pointer;
        float:left;
        margin:3px;
        line-height: 20px;
    } 
    
    .mailInputOverDisplay{
        height: 100px!important;
        overflow-y: auto!important;
    }
</style>

<script>

var currentInputId="";
var editorHeight=0;

var mailobj;
var diag=null;

function doInput(obj){
    //$(obj).css('position','relative');    
    //var oTextCount = document.getElementById("char"); 
    iCount = obj.value.replace(/([^\u0000-\u00FF])/g,'aa').length; 
    obj.size=iCount+1;          
}

function doRemove(obj){
    if($('.ac_results:visible').length > 0){
        return;
    }
    try {
        $(obj).parent().remove();
    } catch(e) {}
}

function mailLeave(obj){
    $(obj).removeClass('mailAdOver')
}

function mailOver(obj){
    $(".mailAdOver").removeClass("mailAdOver");
    $(obj).addClass('mailAdOver');
}

function insertBeforeThis(obj, event){
    $(".mailAdOver").removeClass("mailAdOver");
    $(".mailAdSelect").removeClass("mailAdSelect");
    $('.mailInput').find(".mailinputdiv").remove();
    var edit = $('<span class="mailinputdiv editableAddr"><input size=1 style="*width:1px;overflow-x:visible;overflow-y:visible;" onchange="addMailAddress(this)" class="editableAddr-ipt" oninput="doInput(this)" onpropertychange="doInput(this)" onblur="doRemove(this)" /><span class="editableAddr-txt"></span></span>')
    edit.insertBefore($(obj).parent());
    $('.mailInput').find('.editableAddr-ipt').focus();
    $(".editableAddr-ipt").bind('keydown', 'backspace',function (evt){
        if($(this).val()==''){
            $(this).parent().prev().remove();
        }
    });
    if($(obj).parent().parent().attr("type")=="hrm"){
        edit.find('.editableAddr-ipt').autocomplete("/email/new/GetData.jsp?searchtype=hrm", {
            minChars: 1,
            scroll: true,
            //max:30,
            width:400,
            multiple:"",
            matchSubset: false,
            scrollHeight: 240,
            matchContains: "word",
            autoFill: false,
            formatItem: function(row, i, max) {
                return  row.name +"&lt;"+row.department+"&gt;";
            },
            formatMatch: function(row, i, max) {
                return row.name+ " " + row.pinyin+ " " + row.loginid;
            },
            formatResult: function(row) {
                return row.name+"|"+row.id+"|"+row.dpid;
            }
        });
    }else{
        edit.find('.editableAddr-ipt').autocomplete("/email/new/EmailData.jsp", {
            minChars: 1,
            scroll: true,
            max:50,
            width:400,
            multiple:"",
            scrollHeight: 240,
            matchContains: "word",
            autoFill: false,
            formatItem: function(row, i, max) {
                return  row.name +"&lt;" + row.to + "&gt;";
            },
            formatMatch: function(row, i, max) {
                return row.name + " " + row.to;
            },
            formatResult: function(row) {
                return row.name +"|" + row.to;
            }
        });
    }
    stopEvent(event);
}

function insertAfterThis(obj,event){
    $(".mailAdOver").removeClass("mailAdOver");
    $(".mailAdSelect").removeClass("mailAdSelect");
    $('.mailInput').find(".mailinputdiv").remove();
    var edit = $('<span class="mailinputdiv editableAddr " ><input size=1 style="*width:1px;overflow-x:visible;overflow-y:visible;" class="editableAddr-ipt" oninput="doInput(this)" onpropertychange="doInput(this)" onchange="addMailAddress(this)" onblur="doRemove(this)"><span class="editableAddr-txt"></span></span>')
    
    edit.insertAfter($(obj).parent());
    $('.mailInput').find('.editableAddr-ipt').focus();
    $(".editableAddr-ipt").bind('keydown', 'backspace',function (evt){
        if($(this).val()==''){
            $(this).parent().prev().remove();
        }
    });
    if($(obj).parent().parent().attr("type")=="hrm"){
        edit.find('.editableAddr-ipt').autocomplete("/email/new/GetData.jsp?searchtype=hrm", {
            minChars: 1,
            scroll: true,
            //max:30,
            width:400,
            multiple:"",
            matchSubset: false,
            scrollHeight: 240,
            matchContains: "word",
            autoFill: false,
            formatItem: function(row, i, max) {
                return  row.name +"&lt;"+row.department+"&gt;";
            },
            formatMatch: function(row, i, max) {
                return row.name+ " " + row.pinyin+ " " + row.loginid;
            },
            formatResult: function(row) {
                return row.name+"|"+row.id+"|"+row.dpid;
            }
        });
    }else{
        edit.find('.editableAddr-ipt').autocomplete("/email/new/EmailData.jsp", {
            minChars: 1,
            scroll: true,
            max:50,
            width:400,
            multiple:"",
            scrollHeight: 240,
            matchContains: "word",
            autoFill: false,
            formatItem: function(row, i, max) {
                return  row.name +"&lt;" + row.to + "&gt;";
            },
            formatMatch: function(row, i, max) {
                return row.name + " " + row.to;
            },
            formatResult: function(row) {
                return row.name +"|" + row.to;
            }
        });
    }
    stopEvent(event);
}

function selectMail(obj,event){
    $(".mailAdSelect").removeClass("mailAdSelect");
    $(obj).parent().addClass("mailAdSelect");
    
}

function mailUnselect(obj,event){
    $(obj).remove("mailAdSelect");
    
}

function mail_keypress(obj){
    var evt = getEvent() || event;
    var keyCode = evt.which ? evt.which : evt.keyCode;
    if(keyCode == 186){
        $(obj).blur();
        
        $('.mailInput').click();
        if (evt.keyCode) {
            evt.keyCode = 0;evt.returnValue=false;     
        } else {
            evt.which = 0;evt.preventDefault();
        }
    }
    
}

function addMailAddress(obj){
    obj.value = obj.value.toLowerCase();
    if($('.ac_results:visible').length>0){
        // $('.ac_results').hide();
        return;
    }
    if(!addToInput($(obj).parent().parent().attr("id"),obj.value,obj)){
        obj.value = "";
    }
}

function showMailAddDiv($obj) {
    var value = $obj.val();
    var objId = $obj.attr('id');
    var list = $obj.val().split(",");
    var div = $(".mailInput[target='" + objId + "']");
    div.html("");
    if (objId == 'internalto' || objId == 'internalcc' || objId == 'internalbcc') {
        var listname = $("#" + objId + "hrmname").val().split(",");
        var listnamedpid = $("#" + objId + "hrmdpid").val().split(",");
        for (var i = 0; i < list.length; i++) {
            var mail = list[i];
            var dpid = listnamedpid[i];
            var name = listname[i];
            if (mail != '' && mail != '0') {
                addToInput(objId + "Div", name + "|" + mail + "|" + dpid);
            }
        }
        $("#" + objId + "Div").find(".clear").remove();
        
    } else if (objId == 'internaltodpid' || objId == 'internalccdpid' || objId == 'internalbccdpid') {
        var listname = $("#" + objId + "name").val().split(",");
        for (var i = 0; i < list.length; i++) {
            var dpid = list[i];
            var name = listname[i];
            if (dpid != '' && dpid != '0') {
                addToInput($obj.attr("relid") + "Div", name + "|0|" + dpid);
            }
        }
        $("#" + $obj.attr("relid") + "Div").find(".clear").remove();
        
    } else if (objId == 'internaltoall' || objId == 'internalccall' || objId == 'internalbccall') {
        var listname = '<%=SystemEnv.getHtmlLabelName(1340, user.getLanguage())%>';
        for (var i = 0; i < list.length; i++) {
            var dpid = list[i];
            var name = listname;
            if (dpid == '1') {
                addToInput($obj.attr("relid") + "Div", name + "|0|0");
            }
        }
        $("#" + $obj.attr("relid") + "Div").find(".clear").remove();
        
    } else {
        for (var i = 0; i < list.length; i++) {
            var mail = list[i];
            if (mail != '') {
                addToInput(div.attr("id"), mail)
            }
        }
    }
    //div.append("<div class='clear'></div>")
}

// 人力资源浏览框（人员）
function onShowResourcemail(obj, mailtype) {
    $(".btnGrayDropContent").hide();
    target = $(obj).parent().attr("target");
    var resourceid = $("#" + target).attr("target");
    var url = "/systeminfo/BrowserMain.jsp?url=/email/MutiResourceMailBrowser.jsp?selectedids=";
    var tabTitle = "<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>";
    if (mailtype == "contacter") {
        url = "/systeminfo/BrowserMain.jsp?url=/email/MailContacterBrowserMulti.jsp";
        tabTitle = "<%=SystemEnv.getHtmlLabelName(17129,user.getLanguage())%>";
    }
    showModalDialogForBrowser(event, url, '#', resourceid, false, 1, '', {
        name: 'resourceBrowser',
        hasInput: false,
        zDialog: true,
        needHidden: true,
        dialogTitle: tabTitle,
        arguments: '',
        _callback: resourceMailCallback
    });
}

function resourceMailCallback(event, data, name, oldid) {
    if (data != null) {
        if (data.id != "") {
            var _ids = data.id.split(",");
            var _names = data.name.split(",");
            var _emails = data.email.split(",");
            for (var i = 0; i < _names.length; i++) {
                if (_emails[i].indexOf("@") == -1) continue;
                addToInput(target, _names[i] + "<" + _emails[i] + ">")
            }
        }
    }
}


var target;  //记录打开人力资源框或者部门选择框时的输入对象

// 打开人力资源选择框
function onShowResource(obj) {
    $(".btnGrayDropContent").hide();
    target = $(obj).parent().attr("target");
    getRealMailAddress();
    var resourceid = $("#" + target).attr("target");
    var selectedids = $("#" + resourceid).val();
    if (selectedids == 0) selectedids = '';
    showModalDialogForBrowser(event, '/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids=' + selectedids, '#', resourceid, false, 1, '', {
        name: 'resourceBrowser',
        hasInput: false,
        zDialog: true,
        needHidden: true,
        dialogTitle: '<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>',
        arguments: '',
        _callback: resourceBrowserCallback
    });
}

// 人力资源选择框回调
function resourceBrowserCallback(event, data, name, oldid) {
    if (data != null) {
        if (data.id != "") {
            var _ids = data.id.split(",");
            var _names = data.name.split(",");
            var div = $("#" + target);
            for (var i = 0; i < _names.length; i++) {
                if (_ids[i] != "") {
                    addToInput(target, _names[i] + "|" + _ids[i] + "|0")
                }
            }
        } else {
            //var div = $("#" + target);
        }
    }
}

// 打开部门选择框
function onShowDepartment(obj) {
    $(".btnGrayDropContent").hide();
    target = $(obj).parent().attr("target");
    getRealMailAddress();
    var resourceid = $("#" + target).attr("target") + "dpid";
    var selectedids = $("#" + resourceid).val();
    showModalDialogForBrowser(event, '/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=' + selectedids, '#', resourceid, false, 1, '', {
        name: 'resourceBrowser',
        hasInput: false,
        zDialog: true,
        needHidden: true,
        dialogTitle: '<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>',
        arguments: '',
        _callback: departmentBrowserCallback
    });
}

// 部门选择框回调
function departmentBrowserCallback(event, data, name, oldid) {
    if (data != null) {
        if (data.id != "") {
            var _ids = data.id.split(",");
            var _names = data.name.split(",");
            var div = $("#" + target);
            for (var i = 0; i < _names.length; i++) {
                if (_ids[i] != "") {
                    addToInput(target, _names[i] + "|0|" + _ids[i])
                }
            }
        } else {
            //var div = $("#" + target);
        }
    }
}

function onShowAllResouceLi(obj, event) {
    if (jQuery(event.srcElement).closest(".jNiceCheckbox").length != 0 || jQuery(event.srcElement).closest(".jNiceHidden").length != 0) {
        return;
    }
    var target = $(obj).parent().attr("target");
    if ($(obj).find("input:checkbox").is(':checked') == true) {
        changeCheckboxStatus_1_8_3($(obj).find("input:checkbox")[0], false);
        $("#" + target).html("");
        $("#" + target).attr("disabled", "");
    } else {
        changeCheckboxStatus_1_8_3($(obj).find("input:checkbox")[0], true);
        addToInput(target, "<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>|0|0");
        $("#" + target).attr("disabled", "true");
    }
    $(".btnGrayDropContent").hide();
    stopEvent(event);
}

// jquery_1.8.3版本下变更jnicecheckbox的方法
function changeCheckboxStatus_1_8_3(obj, val) {
    var $obj = jQuery(obj);
    $obj.attr('checked', val);
    $obj.siblings('span.jNiceCheckbox').toggleClass('jNiceChecked');
}

//添加所有人为收件人
function onShowAllResouce(obj, event) {
    var target = $(obj).parents("ul").attr("target");
    if ($(obj).is(':checked')) {
        addToInput(target, "<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>|0|0")
        jQuery("#" + target).attr("disabled", "true");
    } else {
        jQuery("#" + target).html("");
        jQuery("#" + target).attr("disabled", "");
    }
    $(".btnGrayDropContent").hide();
    stopEvent(event);
}

//添加email地址
function addToInput(targetid, name, input) {
    var div = $("#" + targetid);
    // 判断当前地址是否已存在,存在则不能重复添加
    //if(mailIsExist(div,name)){
    //alert("<%=SystemEnv.getHtmlLabelName(31185,user.getLanguage()) %>!")
    //return false;
    //}
    //判断输入框类型，人力资源或邮件地址
    if (div.attr("type") == "hrm") {
        if (input == undefined) { // 由浏览框批量导入
            if (name != "") {
                var list = name.split("|");
                if ($(div).find(".mailAdItem[dpid='" + list[2] + "'][value='" + list[1] + "']").length > 0) { // 过滤重复的人员，部门数据
                    return;
                }
                if (parseInt(list[1]) > 0 && $(div).find(".mailAdItem[value='" + list[1] + "']").length > 0) {
                    return;
                }

                var html;
                if (list[1] == '0') { // 人员ID为0,即为部门信息
                    html = $("<div class='mailAdItem mailAdOK' unselectable='on' dpid='" + list[2] + "'  value='" + list[1] + "' title='" + list[0] + "'><span onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>" + list[0] + "<em class='hand closeLb'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</em></span></div>");
                } else {
                    html = $("<div class='mailAdItem mailAdOK' unselectable='on' dpid='" + list[2] + "' value='" + list[1] + "' title='" + list[0] + "'><span onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>" + list[0] + "<em class='hand closeLb'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</em></span></div>");
                }
                //清除浮动层clear样式
                div.find(".clear").remove();
                div.append(html);
            }
            autoDivHeight(div)
        } else { // 自动联想输入
            if (name != "") {
                if ($(input).attr("selected") == "true" || $(input).attr("selected") == "selected") {
                    var list = name.split("|")
                    if ($(div).find(".mailAdItem[dpid='" + list[2] + "'][value='" + list[1] + "']").length > 0) { // 过滤重复的人员，部门数据
                        return;
                    }
                    if (parseInt(list[1]) > 0 && $(div).find(".mailAdItem[value='" + list[1] + "']").length > 0) {
                        return;
                    }

                    if (list[1] == '0') { // 人员ID为0,即为部门信息
                        html = $("<div class='mailAdItem mailAdOK' unselectable='on' dpid='" + list[2] + "'  value='" + list[1] + "' title='" + list[0] + "'><span onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>" + list[0] + "<em class='hand closeLb'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</em></span></div>");
                    } else {
                        html = $("<div class='mailAdItem mailAdOK' unselectable='on' dpid='" + list[2] + "'  value='" + list[1] + "' title='" + list[0] + "'><span onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>" + list[0] + "<em class='hand closeLb'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</em></span></div>");
                    }
                    //清除浮动层clear样式
                    div.find(".clear").remove();
                    if ($(input).parent().prev().length > 0) {
                        html.insertAfter($(input).parent().prev());
                    } else if ($(input).parent().next().length > 0) {
                        html.insertBefore($(input).parent().prev());
                    } else {
                        div.append(html);
                    }
                }
            }
            autoDivHeight(div)
            input.value = "";
            div.focus();
            try { $(input).parent().remove(); } catch(e) {}
            div.click();
        }

    } else {
        if (input == undefined) { // 由浏览框批量导入
            //name 格式为 xxxx<yyyyy@yyy.com>，需要处理，获取地址和名称
            //var re = /([0-9A-Za-z\-_\.]+)@([\s\S]+\.[a-z]{2,3}(\.[a-z]{2})?)/gi;  // 这种匹配方式对xx@xx<xx@xx>形式的地址不行
            var re = /([\w\-\.]+@[\w\-\.]+(\.\w+)+?)/gi;
            var tmpemail = name.match(re); // 邮件地址
            if (tmpemail.length - 1 > 0) {
                tmpemail = tmpemail[tmpemail.length - 1]
            }

            if ($(div).find(".mailAdItem[title='" + tmpemail + "']").length > 0) { // 过滤重复的邮箱数据
                return;
            }
            var tmpname = name.replace("<" + tmpemail + ">", "") // 名称

            var classname = '';
            var validate = /^[\w\-\.]+@[\w\-\.]+(\.\w+)+$/;
            if (!validate.test(tmpemail)) {
                classname = 'mailAdError'
            } else {
                classname = 'mailAdOK'
            }
            if (tmpemail != "") {
                var html = $("<div class='mailAdItem " + classname + "' unselectable='on' title='" + tmpemail + "'><span onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>" + tmpname + "&lt;" + tmpemail + "&gt;<em class='hand closeLb'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</em></span></div>");
                //清除浮动层clear样式
                div.find(".clear").remove();
                div.append(html);
            } else {
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125940,user.getLanguage()) %>"); // 邮件地址不存在
            }
            autoDivHeight(div)

        } else {
            //name 格式为 xxxx|yyyyy@yyy.com ，需要处理，获取地址和名称
            //jQuery("#test").val(name+"==");
            if(name) {
            	name = name.replace(/</ig, '&lt;').replace(/>/ig, '&gt;');
            }
            if(name.length == 0){
				return;
            }
            var list = name.split("|")
            if (list.length == 1) {
                name = name + "|" + name;
                list = name.split("|")
            }
            var tmpemail = list[1]; // 邮件地址
            var tmpname = list[0] // 名称

            var classname = '';
            var validate = /^[\w\-\.]+@[\w\-\.]+(\.\w+)+$/;
            if (!validate.test(tmpemail)) {
                classname = 'mailAdError'
            } else {
                classname = 'mailAdOK'
            }
            if ($(div).find(".mailAdItem[title='" + tmpemail + "']").length > 0) { // 过滤重复的邮箱数据
                return;
            }
            if (tmpemail != "") {
                var html = $("<div class='mailAdItem " + classname + "' unselectable='on' title='" + tmpemail + "'><span onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>" + tmpname + "&lt;" + tmpemail + "&gt;<em class='hand closeLb'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</em></span></div>");
                //清除浮动层clear样式
                div.find(".clear").remove();
                if ($(input).parent().prev().length > 0) {
                    html.insertAfter($(input).parent().prev());
                } else if ($(input).parent().next().length > 0) {
                    html.insertBefore($(input).parent().prev());
                } else {
                    div.append(html);
                }
            } else {
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125940,user.getLanguage()) %>"); // 邮件地址不存在
            }
            autoDivHeight(div)
            input.value = "";
            $(input).parent().remove();
            div.click();
        }
    }
    return true;
}

function autoDivHeight(div) {
    div.find(".clear").remove();
    div.append("<div class='clear'></div>")
    if (div.height() > 100) {
        if (!div.hasClass("mailInputOverDisplay")) {
            div.addClass("mailInputOverDisplay")
        }
    } else if (div.height() < 90) {
        if (div.hasClass("mailInputOverDisplay")) {
            div.removeClass("mailInputOverDisplay")
        }
    }
}

// 判断邮箱地址是否存在，如果存在就不继续添加了
function mailIsExist(div, name) {
    var isExist = false;
    if (div.attr("type") == "hrm") {
        var list = name.split("|");
        //所有人
        if (div.find(".mailAdItem[value='0'][dpid='0']").length > 0) {
            isExist = true;
        }

        //人员
        if (div.find(".mailAdItem[dpid='" + list[2] + "'][value='" + list[1] + "']").length > 0) { // 判断是否有相同人员
            isExist = true;
        }

        //部门
        if (list[1] != 0) { // 判断是该人员部门已存在
            if (div.find(".mailAdItem[dpid='" + list[2] + "'][value='0']").length > 0) {
                isExist = true;
            }
        } else {
            if (list[2] == 0) {
                //div.find(".mailAdItem").remove();
            } else {
                //div.find(".mailAdItem[dpid="+list[2]+"][value!='0']").remove();
            }
        }
    } else {
        //var re = /([0-9A-Za-z\-_\.]+)@([0-9a-z]+\.[a-z]{2,3}(\.[a-z]{2})?)/gi;
        var re = /([\w\-\.]+@[\w\-\.]+(\.\w+)+?)/gi;
        var tmpemail = name.match(re);
        if (div.find(".mailAdItem[title='" + tmpemail + "']").length > 0) {
            isExist = true;
        }
    }
    return isExist;
}


var saveIntervalfn;
// 页面加载完成事件
jQuery(document).ready(function(){
    jQuery('body').jNice();
    
    $(".closeLb").live("click",function(event){
        var div = $(this).parent().parent().parent();   
        if (div[0].clientWidth < div[0].offsetWidth-4){   
            //执行相关脚本。   
        } else{
            div.removeClass("mailInputOverDisplay");    
        }
        //清除所有人选项
        var target=jQuery(this).parent().parent().parent().attr("id");
        var targetCheckbox =  $("ul[target='"+target+"']").find("input:checkbox");
        if(targetCheckbox.is(':checked')==true){
            changeCheckboxStatus_1_8_3(targetCheckbox[0],false);
        }
        jQuery(this).parent().parent().parent().removeAttr("disabled");
        $(this).parent().parent().remove(); 
        
        //alert(div.html())
        
        if (event.stopPropagation) { 
            // this code is for Mozilla and Opera 
            event.stopPropagation(); 
        } 
        else if (window.event) { 
            // this code is for IE 
            window.event.cancelBubble = true; 
        }
    })
    
      //设置邮件类型
     // if('<%=isIE%>'=='true'){
         //$(".mailInput").css("height","28px");
     // }
    $(".importBtn").bind("click",function(event){
        var id = $(this).attr("target");
        
        var x=$(this).offset().left
        var y=$(this).offset().top
        
        $(".importBtnDown").attr("target",id);
        
        $(".importBtnDown").css("left",x+25);
        $(".importBtnDown").css("top",y+20);
        $(".importBtnDown").toggle();
        event.stopPropagation(); 
        
    })
    
    $(".importInternalBtn").bind("click",function(event){
        var id = $(this).attr("target");
        getRealMailAddress();
        var input = $("#"+id).attr("target")
        if($("#"+input+"all").val()!='1'){
            $(".importInternalBtnDown").find("input:checkbox").attr("checked",false);
        }
        var x=$(this).offset().left
        var y=$(this).offset().top
        $(".importInternalBtnDown").attr("target",id);
        $(".importInternalBtnDown").css("left",x+25);
        $(".importInternalBtnDown").css("top",y+20);
        $(".importInternalBtnDown").toggle();
        event.stopPropagation(); 
    });
    
    
    $(document).bind("click",function(event){
        if(jQuery(event.target).parents(".btnGrayDropContent").length !=0){
            return;
        }
        $(".btnGrayDropContent").hide();
    });
    
    
    loadContactsTree();
    
    
    //$('.mailInput').autogrow();
    
    $(".mailInputHide").each(function (index) {
        showMailAddDiv($(this));
    });
    
    // 收件人等单击事件
    $('.mailInput').click(function (event) {
        if (event.target.tagName != 'DIV') {
            return;
        }
        var $this = $(this);
        var isDisabled = $this.attr("disabled");
        // jquery1.8.3是disabled，之前版本是true
        if (isDisabled && (isDisabled == 'disabled' || isDisabled == 'true')) {
            return;
        }
        
        $(".mailAdOver").removeClass("mailAdOver");
        $(".mailAdSelect").removeClass("mailAdSelect");
        var obj = "";
        if ($this.attr("type") == "hrm") {
            obj = $('<span class="mailinputdiv editableAddr"><input size=1 style="*width:1px;border-width: 0px;overflow-x:visible;overflow-y:visible;" class="editableAddr-ipt" onblur="doRemove(this)" oninput="doInput(this)" onpropertychange="doInput(this)" onkeydown="keyDownDelete(this,event)" onchange="addMailAddress(this)"><span class="editableAddr-txt"></span></span>')
        } else {
            obj = $('<span class="mailinputdiv editableAddr"><input size=1 style="*width:1px;border-width: 0px;overflow-x:visible;overflow-y:visible;" class="editableAddr-ipt" onkeydown="mail_keypress(this),keyDownDelete(this,event)" oninput="doInput(this)" onpropertychange="doInput(this)" onchange="addMailAddress(this)"><span class="editableAddr-txt"></span></span>')
        }
        var $mailinputdiv = $this.find(".mailinputdiv");
        if ($mailinputdiv.length == 0) {
            var $clear = $this.find('.clear');
            if ($clear.length > 0) {
                obj.insertBefore($clear);
            } else {
                $this.append(obj);
            }
        }
        $this.find('.editableAddr-ipt').focus();
     
        if ($this.attr("type") == "hrm") {
            //var tt = $mailinputdiv.find('.editableAddr-ipt').val();
            obj.find('.editableAddr-ipt').autocomplete("/email/new/GetData.jsp?searchtype=hrm", {
                minChars: 1,
                scroll: true,
                //max: 30,
                width: 400,
                multiple: "",
                matchSubset: false,
                scrollHeight: 240,
                matchContains: "word",
                autoFill: false,
                formatItem: function (row, i, max) {
                    return row.name + "&lt;" + row.department + "&gt;";
                },
                formatMatch: function (row, i, max) {
                    return row.name + " " + row.pinyin + " " + row.loginid;
                },
                formatResult: function (row) {
                    return row.name + "|" + row.id + "|0";
                }
            });
        } else {
            obj.find('.editableAddr-ipt').autocomplete("/email/new/EmailData.jsp", {
                minChars: 1,
                scroll: true,
                max: 50,
                width: 400,
                multiple: "",
                scrollHeight: 240,
                matchContains: "word",
                autoFill: false,
                formatItem: function (row, i, max) {
                    return row.name + "<" + row.to + ">";
                },
                formatMatch: function (row, i, max) {
                    return row.name + " " + row.to;
                },
                formatResult: function (row) {
                    return row.name + "|" + row.to;
                }
            });
        }
        
        //记录当前输入框ID
        currentInputId = $(this).attr("target");
        // 输入框选中高亮
        $(".inputSelected").removeClass("inputSelected");
        if(!$(this).hasClass("inputSelected")){
            $(this).addClass("inputSelected");
        }
        
        stopEvent(event);
    });
    
    $(".mailInput").live("blur",function(){
        $(this).removeClass("inputSelected");
    });
    
    editorHeight = $("#editor").outerHeight();
    editorHeight = editorHeight;
    
    // 邮件自动提示
    $(".clearFrom").click(function(){
        $("#fromSearch").val("");
        $(".searchFrom").show();
        $(".clearFrom").hide();
    });
    
    $("#fromSearch").bind("propertychange",function(){
        //只有当光标位于文本框内时，才触发这个事件
        //不然的的，在光标移出的时候也会触发该事件【如果此时我去点展开列表，展不开】
        if(document.activeElement.id == this.id){
            loadContactsTree();
        }
    })
    
    $("#fromSearch").bind("input",function(){
        loadContactsTree();
    });
    
    /*$("div#InternalMiniToolBar").find("span#addsrz").hover(
        function(){$(this).removeClass("spanBtn").addClass("spanBtnOver")},
        function(){$(this).removeClass("spanBtnOver").addClass("spanBtn")}
    );*/
    
    $("#miniToolBar").find("span").hover(
        function(){$(this).css("background-color","#0083ff")},
        function(){$(this).css("background-color","#fff")}
    );
    
    //输入框添加删除事件注册
    $("#addCc").bind("click",function(){
        $("#addCc").hide();
        $("#delCc").show();
        if($("#isInternal").is(':checked')){
            $("#InternalMail").find(".inputCc").show();
        }else{
            $("#ExternalMail").find(".inputCc").show();
        }
    })
    $("#delCc").bind("click",function(){
        $("#delCc").hide();
        $("#addCc").show();
        if($("#isInternal").is(':checked')){
            $("#InternalMail").find(".inputCc").hide();
            $("#InternalMail").find(".inputCc").find("#internalcc").val("");
            $("#internalccDiv").html("");
        }else{
            $("#ExternalMail").find(".inputCc").hide();
            $("#ExternalMail").find(".inputCc").find("#cc").val("");
            $("#ccDiv").html("");
        }
    });
    
    $("#addBcc").bind("click",function(){
        $("#addBcc").hide();
        $("#delBcc").show();
        if($("#isInternal").is(':checked')){
            $("#InternalMail").find(".inputBcc").show();
        }else{
            $("#ExternalMail").find(".inputBcc").show();
        }
    });
    
    $("#delBcc").bind("click",function(){
        $("#delBcc").hide();
        $("#addBcc").show();
        if($("#isInternal").is(':checked')){
            $("#InternalMail").find(".inputBcc").hide();
            $("#InternalMail").find(".inputBcc").find("#internalbcc").val("");
            $("#internalbccDiv").html("");
        }else{
            $("#ExternalMail").find(".inputBcc").hide();
            $("#ExternalMail").find(".inputBcc").find("#bcc").val("");
            $("#bccDiv").html("");
        }
    });
    
    $("#addContactGroup").click(function(){
        $("#srzulid").html(""); //防止内容重复
        diag = new window.top.Dialog();
        diag.currentWindow = window;
        diag.Width = 450;
        diag.Height = 300;
        diag.Title = "<%=SystemEnv.getHtmlLabelName(22306,user.getLanguage()) %>";
        diag.URL = "/email/new/ContactsGroupOutter.jsp";
        diag.show();
        //$("#hidedivmsg").show();
    });
    
    // 清空收件人 按钮事件
    $('div[name="clearAddressee"]').click(function(){
        var self = $(this);
        window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("127204", user.getLanguage())%>?', function(){
            var isInternal = self.attr("_isInternal");
            if(isInternal == '1') {
                $("#internaltoDiv").html('');
            } else if(isInternal == '0') {
                $('#toDiv').html('');
            }
        });
    });
    
    $("#addsrz").bind("click",function(){
        var ids = "";
        $("#internaltoDiv").find(".mailAdItem[value!=0]").each(function(){
            ids += "," + $(this).attr("value");
        });
        
        diag = new window.top.Dialog();
        diag.currentWindow = window;
        diag.Width = 500;
        diag.Height = 300;
        diag.Title = "<%=SystemEnv.getHtmlLabelName(31184,user.getLanguage()) %>";
        diag.URL = "/email/new/ContactsGroupInner.jsp?ids="+ids;
        diag.show();
    });
    
    
    //zzl关闭私人组
function closedsrz(){
    $("#srzname").val("");
    $("#hidediv").hide();
    $("#hidedivmsg").hide();
}

    /*
    //初始化编辑器
    if($("#isInternal").is(':checked')){
        highEditor("mouldtext",editorHeight,1)
    }else{
        highEditor("mouldtext",editorHeight,0)
    }
    */
    
    $("#fromSearch").bind("change",function(){
        if($(this).val()!=""){
            $(".searchFrom").hide();
            $(".clearFrom").show();
        }else{
            $(".searchFrom").show();
            $(".clearFrom").hide();
        }
    })
    
    $("#tabTitle").find(".tab").bind("click",function(){
        var parentdiv=$(this).parent();
        $(".tabSelected").removeClass("tabSelected").addClass("tabUnSelected");
        $(this).addClass("tabSelected").removeClass("tabUnSelected");
        
        $(".tabContent").hide();
        $("#"+$(this).attr("target")).show();
    })
    $("#tabTitle").find(".tab").css("z-index","-1")
    
    $('.contactsItem').hover(
        function () {
          $(this).addClass("contactsItemOver");
        }, 
        function () {
            $(this).removeClass("contactsItemOver");
        }
    );
   
    if(<%=isInternal%>==1) {
        changeMailType(1);
    } else{
        changeMailType(0);
    }
    
    
    jQuery("#contacterTab").css("height",(document.body.offsetHeight-jQuery("#contacterTab")[0].offsetTop-5)+"px");
    jQuery("#hrmOrgContent").css("height",(document.body.offsetHeight-jQuery("#contacterTab")[0].offsetTop-45)+"px");
    jQuery("#contactsTree").css("height",(document.body.offsetHeight-jQuery("#contacterTab")[0].offsetTop-90)+"px");
    
    jQuery("#contacterTab .tabContent").height(jQuery("#contacterTab").height()-$("#tabTitle").height()-5);
    
    // 初始化组织结构树
    setTimeout(function(){
        $("#hrmOrgTree").addClass("hrmOrg"); 
        $("#hrmOrgTree").treeview({
           url:"/email/new/hrmOrgTree.jsp?operation=private"
        });
        
        $("#innerHrmTree").addClass("hrmOrg"); 
        $("#innerHrmTree").treeview({
           url:"/email/new/hrmOrgTree.jsp?operation=innerHrm&isaccount=0"
        });
    }, 500);
    
    //每隔1分钟保存为草稿
    /*
     saveIntervalfn = setInterval(function(){
        autoSave($('#savebtn'));
     },20000);
    */
});

function refreshTree(type) {
    if("inner" == type){
        $("#hrmOrgTree").html("");
        $("#hrmOrgTree").treeview({
           url:"/email/new/hrmOrgTree.jsp"
        });
    }else{
        loadContactsTree();
    }
    if(diag){
        diag.close();
    }
}

//加载联系人列表
function loadContactsTree() {
    var keyword = encodeURI($("#fromSearch").val())
    $("div#contactsContent div#contactsTree").html("");
    $("div#contactsContent div#contactsTree").load("/email/new/MailAddContactsGroupTree.jsp?keyword=" + keyword, function(data) {
        $(".contactsTree-item").hover(
            function() {
                $(this).find("span[name=SH]").show();
            }, function() {
                $(this).find("span[name=SH]").hide();
            }
        );
        $('.contactsItem').hover(
            function() {
                $(this).addClass("contactsItemOver");
            }, function() {
                $(this).removeClass("contactsItemOver");
            }
        );
    });
}

//初始化输入框状态
function initToolBarStatus() {
    if ($("#isInternal").is(':checked')) {
        //设置接收人为了所有人
        if ('<%=ccall%>' == '1' || '<%=ccdpids%>' != '') {
            $("#addCc").trigger("click");
        } else {
            if ('<%=internalcc%>' != '') {
                $("#addCc").trigger("click");
            } else {
                $("#delCc").trigger("click");
            }
        }
        //设置米送人为所有人
        if ("<%=bccall%>" == "1" || "<%=bccdpids%>" != "") {
            $("#addBcc").trigger("click");
        } else {
            if ('<%=internalbcc%>' != '') {
                $("#addBcc").trigger("click");
            } else {
                $("#delBcc").trigger("click");
            }
        }
    } else {
        if ('<%=sendcc%>' != '') {
            $("#addCc").trigger("click")
        } else {
            $("#delCc").trigger("click")
        }
        if ('<%=sendbcc%>' != '') {
            $("#addBcc").trigger("click")
        } else {
            $("#delBcc").trigger("click")
        }
    }
}

function openBlog(type,id,name,obj){
    isdb=false;
    var div = $(".mailInput[target='"+currentInputId+"']");
    var tabType=$("#tabTitle .tabSelected").attr("id");
    if(tabType=="privateTab"){  
        if(type==0){
            //添加组
             $.post("/email/new/hrmOrgTree.jsp?root="+id,"",function(data){
              });
              stopEvent();
        }else{
             addToInput(div.attr("id"),name+"|"+id)
        }
    }else{
        var hrmtype=id;
        var objid=type;
        addHrmOrgMail(hrmtype,objid);
    }   
}

function dblclickTree(type, id, name, obj) {
    isdb = true;
    var div = $(".mailInput[target='" + currentInputId + "']");
    var tabType = $("#tabTitle .tabSelected").attr("id");
    if (tabType == "privateTab") {
        if (type == 0) {
            //添加组
            $.post("/email/new/hrmOrgTree.jsp?root=" + id, "", function(data) {
                $.each(data, function(idx, item) {
                    addToInput(div.attr("id"), item.text + "|" + item.id + "|" + item.dpid)
                });
            });
        } else {
            addToInput(div.attr("id"), name + "|" + id)
        }
    } else {
        var hrmtype = id;
        var objid = type;
        dblclickHrmTree(hrmtype, objid);
    }
}

function addResourceMail(obj){
    var hrmtype=$(obj).attr("_orgType");
    var objid=$(obj).attr("_objid");
    addHrmOrgMail(hrmtype,objid);
}

function addHrmOrgMail(hrmtype,objid){
    var div = $(".mailInput[target='"+currentInputId+"']");
    var tabType=$("#tabTitle .tabSelected").attr("id");
    //人力资源树 type表示id id表示类型
    stopEvent();
}

function dblclickHrmTree(hrmtype,objid) { 
    var div = $(".mailInput[target='"+currentInputId+"']");
    var tabType=$("#tabTitle .tabSelected").attr("id");
    
    $.post("/email/new/hrmOrgTree.jsp?operation=getHrm&hrmtype="+hrmtype+"&objid="+objid,"",function(data){
        if(tabType=="innerHrmTab"){
            if(data.length>500){
                alert("<%=SystemEnv.getHtmlLabelName(83094,user.getLanguage())%>");
                return ;
            }
                $.each(data,function(idx,item){                                     
                addToInput(div.attr("id"),item.text+"|"+item.id+"|"+item.dpid)
            }); 
        }else if(tabType=="innerContacterTab"){
            if(data.length>500){
                alert("<%=SystemEnv.getHtmlLabelName(83094,user.getLanguage())%>");
                return ;
            }
            var dialogFlag=0;
            $.each(data,function(idx,item){
            if(item.email!="")                                  
                addAddress(item.text+"<"+item.email+">");
            else
                dialogFlag=1;
            });
            if(dialogFlag==1){
                    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125940,user.getLanguage()) %>");// 邮件地址不存在
            }
        }           
    });
    stopEvent();
}

function dblclickGroupTree(himself,_pagenum) {
    var mailacounts = $(himself).parent().find(".contactsGroupContent").children();
    if(mailacounts.length>0){
        for(var key in mailacounts) {
            var mailaddress = $(mailacounts[key]).attr('_mailaddress');
            if(mailaddress) { 
                addAddress(mailaddress);
            }
        }
    }
}

//阻止事件冒泡
function stopEvent(event) {
    if (event && event.stopPropagation) { 
        event.stopPropagation();
    } else if (window.event) { 
        window.event.cancelBubble = true; 
    }
}


/**封装签名插件**/
KindEditor.zh_cn_lang.sign = '<%=SystemEnv.getHtmlLabelName(20148,user.getLanguage()) %>';
KindEditor.plugin('sign', function(K) {
    var self = this, name = 'sign';
    self.clickToolbar(name, function() {
        var menu = self.createMenu({
                name : 'sign',
                width : 150
            });
        <%
            List<Map<String, String>> signList = new ArrayList<Map<String, String>>();
            mss.selectMailSignByUser(user.getUID());
            while(mss.next()) {
                Map<String, String> map = new HashMap<String, String>();
                map.put("id", mss.getId());
                map.put("descName", Util.getMoreStr(mss.getSignName(),7,"..."));
                map.put("name", mss.getSignName());
                map.put("desc", mss.getSignDesc());
                map.put("signContent", mss.getSignContent("", user));
                signList.add(map);
            }
        %>
        K.each(<%=JSONArray.toJSONString(signList) %>, function(i, val) {
            menu.addItem({
                title : '<span unselectable="on" title="' + val.name + '&#10;' + val.desc + '">' + val.descName + '</span>',
                click : function() {
                    self.insertHtml(val.signContent);
                    self.hideMenu();
                }
            });
        });
    });
});

/**封装模板插件**/
KindEditor.zh_cn_lang.mailTemplate = '<%=SystemEnv.getHtmlLabelName(64,user.getLanguage()) %>';
KindEditor.plugin('mailTemplate', function(K) {
    var self = this, name = 'mailTemplate';
    self.clickToolbar(name, function() {
        var menu = self.createMenu({
                name : 'mailTemplate',
                width : 150
            });
        var mailTemplateObjs = [];
        jQuery.ajax({
            async: false,
            url : '/email/new/MailOperation.jsp?opt=getTemplList',
            success : function(data){
                data = jQuery.parseJSON(jQuery.trim(data));
                mailTemplateObjs = data;
            },
            error : function(XMLHttpRequest, textStatus, errorThrown){
                console && console.error(errorThrown);
            }
        });
        // 模版维护
        mailTemplateObjs.push({ 
            templId: '-1', 
            templName: '<%=SystemEnv.getHtmlLabelName(129750, user.getLanguage())%>',
            templType: '-1'
        });
        K.each(mailTemplateObjs, function(i, val) {
            menu.addItem({
                title : '<span unselectable="on" title="' + val.templName + '">' + val.templName + '</span>',
                click : function() {
                    if(val.templId != '-1') {
                        loadMailTemplate(val.templId, val.templType);
                    } else {
                        openTemplDialog();
                    }
                    self.hideMenu();
                }
            });
        });
        
        function openTemplDialog() {
            var dialog = new window.top.Dialog();
            dialog.currentWindow = window;
            var url = "/email/MailTemplate.jsp";
            dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,16218",user.getLanguage())%>";
            dialog.Width = 800;
            dialog.Height = 495;
            dialog.Drag = true;
            dialog.URL = url;
            dialog.show();
        }
    });
});

/**封装模板插件**/
KindEditor.zh_cn_lang.doc = '<%=SystemEnv.getHtmlLabelName(22243,user.getLanguage()) %>';
KindEditor.plugin('doc', function(K) {
    var self = this, name = 'doc';
    self.clickToolbar(name, function() {
        openApp('doc');
    });
});

KindEditor.zh_cn_lang.project = "<%=SystemEnv.getHtmlLabelName(101,user.getLanguage()) %>";
KindEditor.plugin('project', function(K) {
    var self = this, name = 'project';
    self.clickToolbar(name, function() {
        openApp('project');
    });
});

KindEditor.zh_cn_lang.workplan = "<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage()) %>";
KindEditor.plugin('workplan', function(K) {
    var self = this, name = 'workplan';
    self.clickToolbar(name, function() {
        openApp('workplan');
    });
});

KindEditor.zh_cn_lang.workflow = "<%=SystemEnv.getHtmlLabelName(22244,user.getLanguage()) %>";
KindEditor.plugin('workflow', function(K) {
    var self = this, name = 'workflow';
    self.clickToolbar(name, function() {
        openApp('workflow');
    });
});

KindEditor.zh_cn_lang.crm = "<%=SystemEnv.getHtmlLabelName(136,user.getLanguage()) %>";
KindEditor.plugin('crm', function(K) {
    var self = this, name = 'crm';
    self.clickToolbar(name, function() {
        openApp('crm');
    });
});

KindEditor.zh_cn_lang.task = "<%=SystemEnv.getHtmlLabelName(1332,user.getLanguage()) %>";
KindEditor.plugin('task', function(K) {
    var self = this, name = 'task';
    self.clickToolbar(name, function() {
        openApp('task');
    });
});
// 重新执行一次语言初始化
KindEditor.lang(KindEditor.zh_cn_lang, 'zh-CN');

var isEdtiorFirstReady = false;
// 初始化html编辑器
function highEditor(remarkid, height, type) {

    if(!isEdtiorFirstReady) {
        height = $(document).height() - 270;
    } else {
        height = KE.util.getHeight(remarkid);
    }

    height = !height || height < 150 ? 150 : height;
    if (jQuery("#" + remarkid).is(":visible")) {
        var items;
        if(type == 1){
            items = [
                'source', '|', 
                //'undo', 'redo', '|',
                'bold', 'italic', 'underline', 'strikethrough', '|',
                'formatblock', 'fontname', 'fontsize', 'forecolor', 'hilitecolor', '|', 
                'justifyleft', 'justifycenter', 'justifyright', 'indent', 'outdent', '|', 
                'insertorderedlist', 'insertunorderedlist', '|',
                'image', 'link', 'unlink', '|',
                'table', 'hr', '|',
                'sign', 'mailTemplate', 'doc', 'workplan','workflow','crm','project','task', '|',
                'fullscreen'
            ];
        } else {
            items = [
                'source', '|', 
                //'undo', 'redo', '|',
                'bold', 'italic', 'underline', 'strikethrough', '|',
                'formatblock', 'fontname', 'fontsize', 'forecolor', 'hilitecolor', '|', 
                'justifyleft', 'justifycenter', 'justifyright', 'indent', 'outdent', '|', 
                'insertorderedlist', 'insertunorderedlist', '|',
                'image', 'link', 'unlink', '|',
                'table', 'hr', '|',
                'sign', 'mailTemplate', '|',
                'fullscreen'
            ];
        }
        var default_config = {
            id : remarkid,
            filterMode: false,
            items: items,
            height: height,
            width: '100%',
            resizeType: 1,
            uploadJson: '/email/new/upload_json.jsp',
            allowFileManager: false,
            cssData: 'body, td {font-size: <%=fontsize%>;} table.ke-zeroborder td{border: 0;}',
            mofontsize: '<%=fontsize%>',
            newlineTag: 'br',  // 段落分隔符
            afterCreate: function() {
                if(!isEdtiorFirstReady) {
                    isEdtiorFirstReady = true;  // 置状态
                    
                    var defaultTemplateId = <%=defaultTemplateId%>;
                    var templateType = <%=templateType%>;
                    var isInternal = <%=isInternal %>;
                    var flag = <%=flag %>;
                    
                    if(defaultTemplateId != -1 && flag == -1) {
                        //console && console.log('加载默认邮件模板');
                        loadMailTemplate(defaultTemplateId, templateType, 1); //加载默认邮件模板
                    } else {
                        //console && console.log('加载邮件内容');
                        loadMailContent(); // 加载邮件内容
                    }
                    
                    setTimeout(function(){
                        //KE.util.setFontname(remarkid, 'SimHei');  // 要先执行这句话，否则获取焦点有问题
                        if(flag == 1 || flag == 2) { 
                            KE.util.focus(remarkid);
                        } else {
                            var idname = isInternal == 1 ? 'internaltoDiv' : 'toDiv';
                            $('#' + idname).click();  //收件人获得焦点
                        }
                    }, 500);
                }
            }
        };
        //KindEditor.ready(function(K) {
            KindEditor.createEditor(default_config);
        //});
    }
}

//切换到纯文本模式
function removeEditor(remarkid) {
    K.remove('#' + remarkid);
}

//切换编辑器模式--纯文本格式和html格式切换
function changeHTMLEditor(obj) {
    if (obj.checked) {
        window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(31242, user.getLanguage())%>", function() {
            removeEditor("mouldtext");
        }, function() {
            changeCheckboxStatus_1_8_3(obj, false);
        });
    } else {
        if ($("#isInternal").is(':checked')) {
            highEditor("mouldtext", editorHeight, 1);
        } else {
            highEditor("mouldtext", editorHeight, 0);
        }
    }
}

/**
 * 附件上传控件
 */
var totalSize = 0;//记录总附件大小
var fileIdArr = new Array();//附件file.id+"-"+附件数据库id
var arr = new Array();
var fileSid = 0;  //上传附件ID
jQuery(function(){
    getFileSize();//获取总的附件大小
    setUploadInfo();
});

function getFileSize(){
    totalSize = 0;
    jQuery("input[name='fileSize']").each(function(){
        totalSize += parseFloat(this.value);
    });
}

function setUploadInfo(){
    if(totalSize <=0){
        jQuery("#uploadInfo").html("");
        return;
    }
    if(totalSize < 511){
        return jQuery("#uploadInfo").html("（100%，<%=SystemEnv.getHtmlLabelName(83095,user.getLanguage())%>"+totalSize+"B，<%=SystemEnv.getHtmlLabelName(83096,user.getLanguage())%>"+totalSize+"B）");
    }else if(totalSize < 1024*1024){
        jQuery("#uploadInfo").html("（100%，<%=SystemEnv.getHtmlLabelName(83095,user.getLanguage())%>"+(totalSize/1024).toFixed(2)+"KB，<%=SystemEnv.getHtmlLabelName(83096,user.getLanguage())%>"+(totalSize/1024).toFixed(2)+"KB）");
    } else {
        jQuery("#uploadInfo").html("（100%，<%=SystemEnv.getHtmlLabelName(83095,user.getLanguage())%>"+(totalSize/(1024*1024)).toFixed(2)+"MB，<%=SystemEnv.getHtmlLabelName(83096,user.getLanguage())%>"+(totalSize/(1024*1024)).toFixed(2)+"MB）");
    } 
}

$(function(){

    $('.swfupload-control').swfupload({
        // Backend Settings
        upload_url: "/email/new/uploader.jsp",    // Relative to the SWF file (or you can use absolute paths)
        // File Upload Settings
        // file_size_limit : "<%=perAttachmentSize*1024%>", //
        file_types : "*.*",
        file_types_description : "All Files",
        // file_upload_limit : "<%=attachmentCount%>",
        file_queue_limit : "0",
        // Button Settings
        button_placeholder_id : "spanButtonPlaceholder",
        button_width: 70,
        button_height: 20,
        button_text:"<div class='theFont' style='cursor:pointer;color:#666'><%=SystemEnv.getHtmlLabelName(124897, user.getLanguage())%></div>",
        button_text_left_padding: 0,
        button_text_top_padding: 3,
        button_window_mode:'transparent',
        button_text_style: ".theFont {font-size:12px;color:#666666;cursor:pointer;font-family:Microsoft YaHei;height:24px;}",
        button_image_url:"/email/images/acc_wev8.png",
        button_cursor: SWFUpload.CURSOR.HAND,
        // Flash Settings
        flash_url : "/email/js/swfupload/vendor/swfupload/swfupload.swf"
        
    });
    
    // assign our event handlers
    $('.swfupload-control')
        .bind('fileQueued', function(event, file){
            
            //附件数量限制
            if(jQuery("input[name='fileSize']").length >=<%=attachmentCount%>){
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83076,user.getLanguage()) %><%=attachmentCount%><%=SystemEnv.getHtmlLabelName(83077,user.getLanguage()) %>");
                var swfu = $.swfupload.getInstance('.swfupload-control');
                swfu.cancelUpload(file.id);
                return;
            }
            
            //单个附件大小限制
            if(<%=perAttachmentSize%> !="0" && file.size > <%=perAttachmentSize*1024*1024%>){
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24494,user.getLanguage()) %><%=perAttachmentSize%>M");
                var swfu = $.swfupload.getInstance('.swfupload-control');
                swfu.cancelUpload(file.id);
                return;
            }
            //总大小限制
            var total = parseFloat(file.size) + parseFloat(totalSize);
            if(1!=<%=user.getUID()%>){
            if(total/1024 > <%=space*1024%>){
                var swfu = $.swfupload.getInstance('.swfupload-control');
                swfu.cancelUpload(file.id);
                
                if(<%=space%> < 0){
                    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83097,user.getLanguage()) %>"+(<%=String.format("%.2f",(-1 * space))%>)+"MB，<%=SystemEnv.getHtmlLabelName(83098,user.getLanguage()) %>！")
                }else{
                    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83078,user.getLanguage()) %>"+(parseFloat(total/1024) - parseFloat(<%=space*1024%>))+"KB");
                }
                
                return;
            }
            }
            totalSize = total;
            
            $progress = $("#progressDemo").clone();
            $progress.attr("id",file.id);
            //var index = $("#fsUploadProgress").find(".progressBar").size();
            //$progress.find(".fileIndex").text(index);
            $progress.find(".fileName").text(file.name);
            
            var size = file.size/1024;
            var size_str;
            
            if(file.size <= 511){ 
                size_str = file.size+" B";
            }else if(size>511){
                size = size/1024;
                size_str = size.toFixed(2)+" MB";
            }else{
                size_str = size.toFixed(2)+" KB";
            }
            
            $progress.find(".fileSize").html("("+size_str+")<input type='hidden' name='fileSize' value='"+Math.round(file.size).toFixed()+"'>");
            $("#fsUploadProgress").append($progress);
            
            var saveFileName = arr.length+":"+file.name;
            arr[arr.length] = saveFileName;
            setSubject();//设置邮件主题
            
            $progress.find(".del").bind('click', function () { //Remove from queue on cancel click
                            var swfu = $.swfupload.getInstance('.swfupload-control');
                            swfu.cancelUpload(file.id);
                            $("#"+file.id).remove();
                            doDelAccFile(file.id);
                            //setButton();
                            getFileSize();//获取总的附件大小
                            setUploadInfo();
                            
                            for(var i =0 ;i <arr.length; i ++){
                                if(arr[i] == saveFileName){
                                    arr.splice(i,1);
                                }
                            }
                            setSubject();//设置邮件主题
                        });
            $progress.show();
         
            $(this).swfupload('startUpload');
        })
        .bind('fileQueueError', function (event, file, errorCode, message) {
            if(errorCode==-100){
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83076,user.getLanguage()) %><%=attachmentCount%><%=SystemEnv.getHtmlLabelName(83077,user.getLanguage()) %>");
                this.startUpload()
            }
            if(errorCode==-110){
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24494,user.getLanguage()) %><%=perAttachmentSize%>M");
            }
        })
        .bind('fileDialogComplete', function (event, numFilesSelected, numFilesQueued) {
            $('#queuestatus').text('Files Selected: ' + numFilesSelected + ' / Queued Files: ' + numFilesQueued);
            //setButton();
        })
        .bind('uploadStart', function (event, file) {
            $("#"+file.id).find(".btnred").hide();
            $("#cur_patch").text(file.name);
        })
        .bind('uploadProgress', function (event, file, bytesLoaded,bytesTotal) {
            var percentage = Math.round((bytesLoaded / bytesTotal) * 100);
       //   $('#' + file.id).find('.fileProgress').text(percentage + '%');
            $('#' + file.id).find('.fileProgress').progressBar(percentage);
        })
        .bind('uploadSuccess', function (event, file, serverData) {
            //处理返回值 serverData
            //alert(serverData)
            fileSid = jQuery.trim(serverData);
            $("#accids").val($("#accids").val()+","+jQuery.trim(serverData))
            var swfu = $.swfupload.getInstance('.swfupload-control');
            //判断所有文件上传成功后，进行处理
            fileIdArr[fileIdArr.length] = file.id+"-"+serverData;
            
            if( swfu.getStats().files_queued ===0){
                //nextStep();
                //提交表单
            }
        })
        .bind('uploadComplete', function (event, file) {
            var fnamediv = $('#' + file.id).find('.fileName');
            var fvalue = fnamediv.html();
  //        if(checkFileType(fvalue))
  //                fnamediv.html("<a href=\"javascript:openfile('/email/MailPreView.jsp?fileid="+fileSid+"')\" >"+ fvalue +" </a>");           
            // upload has completed, try the next one in the queue
            var swfu = $.swfupload.getInstance('.swfupload-control');
            var html = "<span style='color:green !important'><%=SystemEnv.getHtmlLabelName(83072,user.getLanguage()) %></span>";
            if(fileSid == '0' || typeof(fileSid) == 'undefined' || fileSid == '') {
                html = "<span style='color:red !important'><%=SystemEnv.getHtmlLabelName(25389,user.getLanguage()) %></span>"; 
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125955,user.getLanguage()) %>"); //附件上传失败，仅支持IE和chrome浏览器，同时请更新flash插件!
            }else {
                html += "<a style='margin-left: 15px; !important' href=\"javascript:openfile('"+fileSid+"',0)\" ><%=SystemEnv.getHtmlLabelName(221,user.getLanguage()) %></a>";             
            }

            $('#' + file.id).find('.fileProgress').html(html);
            if( swfu.getStats().files_queued ===0){
                //nextStep();
                // showLoading();
                //jQuery("#mailAddForm").submit();
                //提交表单
                
                setUploadInfo();
            }
        });
        
});

function checkFileType(filename) {
    var isavailable = false;
    var filePostfixs = ['.pdf','.txt', '.png', '.doc', '.docx','.jpg', '.bmp', '.gif'];
    if(filename == "" || filename == null || typeof(filename)=="undefined")
        return isavailable;
        
    for(var i in filePostfixs) {
        var index = filename.toLowerCase().lastIndexOf(filePostfixs[i]);
        if((index+(filePostfixs[i].length)) == filename.length) { //判断文件名后缀是否以数组中的任意值结尾
            isavailable = true;
            break;      
        }  
    }
    
    return  isavailable;
}
var dialogfile = null;
//打开附件预览
function openfile(fileid,mailid) {
/*
    if(mailid == '' || mailid == null){
        mailid = $("#mailid").val();
    }
    if(mailid == ''||mailid == null) {
        mailid = '0';
    }
    dialogfile = new window.top.Dialog();
    dialogfile.currentWindow = window;
    dialogfile.Title = "<%=SystemEnv.getHtmlLabelNames("156,221",user.getLanguage()) %>";
    dialogfile.Width = 800;
    dialogfile.Height = 600;
    dialogfile.maxiumnable=true;
    dialogfile.Drag = true;
    dialogfile.URL = "/email/MailPreView.jsp?fileid="+fileid+"&mailid="+mailid;
    dialogfile.show();
*/
    window.open("/docs/view/imageFileView.jsp?fileid="+fileid);
}

var autoChangeSubject = <%= ("".equals(subject) || subject == null) ? false : true%>;//是否手动修改过邮件主题
function setSubject(){
    var subject = $("#subject").val();

    if("<%=flag%>" == 5){//草稿箱重新编辑
        return;
    }
    if(autoChangeSubject && ""!= subject){//人为修改过邮件主题，且主题不为空，则不重新设置
        return; 
    }

    if(arr.length > 0 ){//有附件，则将第一个附件名称赋给标题
        var title = arr[0];
        title = title.substring(title.indexOf(":")+1);
        $("#subject").val(title);
        return;
    }
    
    
    if(!autoChangeSubject && arr.length == 0){//没有附件，且客户也没有修改过标题，则标题设为空
        $("#subject").val("");
    }
    
}

$(function(){
    $("#subject").change(function(){
        autoChangeSubject = true;
    });
});

//在提交表单的时候将div中的收件人邮箱地址组装好，写入对应的input框中
function getRealMailAddress(){
    $(".mailInputHide").val("");
    $(".mailAdOK").each(function(index) {
        if($(this).parent().attr("type")=="hrm"){
            var value = $("#"+$(this).parent().attr("target")).val()
            var dpvalue =  $("#"+$(this).parent().attr("target")+"dpid").val()
            if($(this).attr("dpid")*1==0&&$(this).attr("value")*1==0){
                $("#"+$(this).parent().attr("target")+"all").val(1);
                $("#"+$(this).parent().attr("target")).val('0')
                $("#"+$(this).parent().attr("target")+"dpid").val('0')
            }else if($(this).attr("dpid")*1!=0&&$(this).attr("value")*1==0){
                dpvalue = dpvalue+$(this).attr("dpid")+","
                $("#"+$(this).parent().attr("target")+"dpid").val(dpvalue)
            }else{
                value =value+ $(this).attr("value")+","
                $("#"+$(this).parent().attr("target")).val(value)
            }
        }else{ 
            var value = $("#"+$(this).parent().attr("target")).val()
            value =value+ $(this).attr("title")+","
            $("#"+$(this).parent().attr("target")).val(value)
        }
     });
    if($("#internalto").val()==''&&($("#internaltodpid").val()!=''||$("#internaltoall").val()!='')){
        $("#internalto").val("0")
    }
}

function check_receiveStr(isInternal){
    var attrs = [];
    if(isInternal){
        attrs = [{id:'internalto', name:'<%=SystemEnv.getHtmlLabelName(2046,user.getLanguage()) %>'}, {id:'internalcc', name:'<%=SystemEnv.getHtmlLabelName(17051,user.getLanguage()) %>'}, {id:'internalbcc', name:'<%=SystemEnv.getHtmlLabelName(-81316,user.getLanguage()) %>'},{id:'internaltodpid', name:'<%=SystemEnv.getHtmlLabelName(2046,user.getLanguage()) %>'},{id:'internalccdpid', name:'<%=SystemEnv.getHtmlLabelName(17051,user.getLanguage()) %>'},{id:'internalbccdpid', name:'<%=SystemEnv.getHtmlLabelName(-81316,user.getLanguage()) %>'}];
    }else {
        return true;
    }
    for(var i=0; i<attrs.length; i++) {
        if(!check_receiveStr_length($('#' + attrs[i].id).val()+'')) {
            window.top.Dialog.alert(attrs[i].name + '<%=SystemEnv.getHtmlLabelName(81851,user.getLanguage()) %>');
            return false;
        }
             
    }
    return true;
}

function check_receiveStr_length(value){
    if(value.length != 0 && value.length > 3900) {
        return false;
    }
    return true;
}

// 保存邮件内容
function syncMailContent() {
    KE.sync('mouldtext'); // 需要先同步一次
    var content = '<div class="ke-content-new" style="font-size: <%=fontsize%>!important; ">'+$('#mouldtext').val()+'</div>';
    $('#mouldtext').val(content);
}

// 发送邮件
function doSubmit(obj){
    if(<%=space%> <= 0){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83075,user.getLanguage()) %>");  
        return;
    }
    syncMailContent();
    
    if(jQuery("#timeSetting").is(':checked')){
        $("#timingsubmitType").val("submit");
        timingsubmit(obj);
        return;
    }

 
    $("#savedraft").val("0");
    $("#folderid").val("-1");
    $("#autoSave").val("0");
    
    getRealMailAddress();
    if($("#isInternal").is(':checked')){
        if((check_form($G("mailAddForm"),'internalto,subject'))){
            if(!check_receiveStr(true))
                return;
            var swfu = $.swfupload.getInstance('.swfupload-control');
            if(swfu.getStats().files_queued >0){
                swfu.setButtonDisabled(true);
                swfu.startUpload();
            }else{
                showLoading();
                obj.disabled=true;
                jQuery("#mailAddForm").submit();
            }
        }
    }else{
        if($("#mailAccountId").length==0){
               window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83099,user.getLanguage()) %>");
               return;
        }
        if($(".mailAdError").length>0){
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage()) %>")
            return false;
        }
        if((check_form($G("mailAddForm"),'to,subject'))){
            if(!check_receiveStr(false))
                return;
        
            var swfu = $.swfupload.getInstance('.swfupload-control');
            if(swfu.getStats().files_queued >0){
                swfu.setButtonDisabled(true);
                swfu.startUpload();
                
                showLoading();
                obj.disabled=true;
                jQuery("#mailAddForm").submit();
            }else{
                showLoading();
                obj.disabled=true;
                jQuery("#mailAddForm").submit();
            }
            
        }
    }
}

function showLoading(type){
   $("#bgAlpha").show();
   switch(type){
      case 'saveing':
         $("#loading-msg").html("<%=SystemEnv.getHtmlLabelName(19941, user.getLanguage())%>...");
      break;
      default:
         $("#loading-msg").html("<%=SystemEnv.getHtmlLabelName(31199, user.getLanguage())%>...");   
      break;   
   }
   $("#loading").show();
}

//保存草稿
function doSave(obj) {
    setinputdatetime();

    $("#savedraft").val("1");
    $("#folderid").val("-2");
    $("#autoSave").val("0");
    syncMailContent();

    getRealMailAddress();
    
    if ($("#isInternal").is(':checked')) {
        var swfu = $.swfupload.getInstance('.swfupload-control');
        if (swfu.getStats().files_queued > 0) {
            swfu.setButtonDisabled(true);
            swfu.startUpload();
        } else {
            showLoading('saveing');
            obj.disabled=true;
            jQuery("#mailAddForm").submit();
        }
    } else {
        if ($(".mailAdError").length > 0) {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage()) %>")
            return false;
        }
        var swfu = $.swfupload.getInstance('.swfupload-control');
        if (swfu.getStats().files_queued > 0) {
            swfu.setButtonDisabled(true);
            swfu.startUpload();
        } else {
            showLoading('saveing');
            obj.disabled=true;
            jQuery("#mailAddForm").submit();
        }
    }
}

function autoSave(obj){
    if($("#subject").val() == "" && $("#mouldtext").val() == "")
        return;
    setinputdatetime();
    obj.disable=true;
    
    $("#savedraft").val("1");
    $("#folderid").val("-2");
    $("#autoSave").val("1");
    
    getRealMailAddress();
    
    if($("#isInternal").is(':checked')){
            var swfu = $.swfupload.getInstance('.swfupload-control');
            if(swfu.getStats().files_queued >0){
                swfu.setButtonDisabled(true);
                swfu.startUpload();
            }else{
                jQuery.ajax({
                    url: '/email/MailOperationSend.jsp',
                    data: $('#mailAddForm').serialize(),
                    type: "POST",
                    success: function(data) {
                        var mailid = $.trim(data);
                        $("#mailid").val(mailid);   
                        $("#flag").val('4');
                    }
                });
            }
    }else{
        if($(".mailAdError").length>0){
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage()) %>")
            return false;
        }
        var swfu = $.swfupload.getInstance('.swfupload-control');
        if(swfu.getStats().files_queued >0){
            swfu.setButtonDisabled(true);
            swfu.startUpload();
        }else{
            jQuery.ajax({
                url: '/email/MailOperationSend.jsp',
                data: $('#mailAddForm').serialize(),
                type: "POST",
                success: function(data) {
                    var mailid = $.trim(data);
                    $("#mailid").val(mailid);
                }
            });
        }
    }
}

/**
 * 验证邮件地址是否合法
 */
function validateForm() {
    if (validateMailAddress($G("to").value) && validateMailAddress($G("cc").value) && validateMailAddress($G("bcc").value)) {
        return true;
    } else {
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>"); //邮件地址格式错误
        return false;
    }
}

function validateMailAddress(str) {
    var valid = true;
    var arr = str.split(",");
    for (var i = 0; i < arr.length; i++) {
        var a = arr[i];
        var pos1 = a.indexOf("<");
        var pos2 = a.lastIndexOf(">");
        if (pos1 != -1 && pos2 != -1) {
            if (!checkEmail($.trim(a.substring(pos1 + 1, pos2)))) {
                valid = false;
                break;
            }
        } else {
            if (!checkEmail($.trim(a))) {
                valid = false;
                break;
            }
        }
    }
    return valid;
}

function checkEmail(emailStr) {
    if (emailStr.length == 0) {
        return true;
    }
    var emailPat = /^(.+)@(.+)$/;
    var specialChars = "\\(\\)<>@,;:\\\\\\\"\\.\\[\\]";
    var validChars = "\[^\\s" + specialChars + "\]";
    var quotedUser = "(\"[^\"]*\")";
    var ipDomainPat = /^(\d{1,3})[.](\d{1,3})[.](\d{1,3})[.](\d{1,3})$/;
    var atom = validChars + '+';
    var word = "(" + atom + "|" + quotedUser + ")";
    var userPat = new RegExp("^" + word + "(\\." + word + ")*$");
    var domainPat = new RegExp("^" + atom + "(\\." + atom + ")*$");
    var matchArray = emailStr.match(emailPat);
    if (matchArray == null) {
        return false;
    }
    var user = matchArray[1];
    var domain = matchArray[2];
    if (user.match(userPat) == null) {
        return false;
    }
    var IPArray = domain.match(ipDomainPat);
    if (IPArray != null) {
        for (var i = 1; i <= 4; i++) {
            if (IPArray[i] > 255) {
                return false;
            }
        }
        return true;
    }
    var domainArray = domain.match(domainPat);
    if (domainArray == null) {
        return false;
    }
    var atomPat = new RegExp(atom, "g");
    var domArr = domain.match(atomPat);
    var len = domArr.length;
    if ((domArr[domArr.length - 1].length < 0) || (domArr[domArr.length - 1].length > 50)) {
        return false;
    }
    if (len < 2) {
        return false;
    }
    return true;
}

/**
 * 添加邮件签名
 */
function setMailSign(signid) {
    if (signid == "") {
        return false;
    }
    var htmlstr = jQuery("#signContent_" + signid).html();
    if(KE.g["mouldtext"].designMode) {
        KE.insertHtml("mouldtext", htmlstr);
    } else {
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(27541,user.getLanguage())%>"); //请将编辑器切换到可视化模式！
    }
}

// 添加操作者
function addAddress(address){
    var div = $(".mailInput[target='"+currentInputId+"']");
    if(div.hasClass("inputSelected")!='true'){
        div.addClass("inputSelected");
    }
    addToInput(div.attr("id"),address)
}

// 加载邮件内容
function loadMailContent() {
    $.post("/email/new/MailManageOperation.jsp?operation=getMailcontent","",function(data){
        var d = jQuery.trim(data)
        var obj = eval('('+d+')')
        //KE.insertHtml("mouldtext", obj.mailcontent);
        KE.html("mouldtext", obj.mailcontent);
        //KE.util.focus("mouldtext");
        /*
        setTimeout(function(){
            var g = KE.g["mouldtext"];
            var obj=g.iframeDoc.body;
            obj.focus(); 
            var len = obj.innerHTML.length; 
            //IE
            if (g.iframeDoc.selection) { 
                var sel = g.iframeDoc.selection.createRange(); 
                sel.moveStart('character',-len); 
                sel.collapse(true); 
                sel.select(); 
            } 
            else{                                                 
                var sel = g.iframeWin.getSelection();
                var range = g.iframeDoc.createRange();
                range.setStart(obj, 0);
                range.collapse(false);
                sel.removeAllRanges();
                sel.addRange(range);
            }
        },500);
         */
    });
}

//加载邮件模版
function loadMailTemplate(mailTemplateId, mailTemplateType, isdefault) {
    if (isdefault == 1) {
        if (mailTemplateId == 0) { //清空模板内容
            KE.insertHtml("mouldtext", ""); //清空编辑器内容
            return false;
        }
        $.ajax({
            url: '/email/MailTemplateTemp.jsp?id=' + mailTemplateId + '&templateType=' + mailTemplateType + '&userId=<%=user.getUID()%>&t=' + Math.random(),
            success: function(data) {
                setTemplate(data);
            }
        });
    } else {
        if (confirm("<%=SystemEnv.getHtmlLabelName(19925, user.getLanguage())%>")) {
            if (mailTemplateId == 0) { //清空模板内容
                KE.insertHtml("mouldtext", ""); //清空编辑器内容
                return false;
            }
            $.ajax({
                url: '/email/MailTemplateTemp.jsp?id=' + mailTemplateId + '&templateType=' + mailTemplateType + '&userId=<%=user.getUID()%>&' + new Date(),
                success: function(data) {
                    setTemplate(data);
                }
            });
        }
    }
}

//设置邮件模版
function setTemplate(data) {
    var templateContent = data;
    var reg = /\@\@\@(.*)\@\@\@/;
    if (templateContent.match(reg)) {
        $("#subject").val(templateContent.match(reg)[1]);
    }
    if ($("#subject").val() != "") {
        $("#subjectSpan").html('');
        autoChangeSubject = true; //邮件标题发生变更过
    } else {
        $("#subjectSpan").html("<img src='/images/BacoError_wev8.gif' align=\"absMiddle\">");
    }
    KE.html("mouldtext", templateContent.replace(reg, ""));
}

/**************start*****************MailContactAdd.jsp页面依赖代码******************************************/
//载入添加联系人页面
function addContact() {
    diag = new window.top.Dialog();
    diag.currentWindow = window;
    diag.Width = 500;
    diag.Height = 520;
    diag.Title = "<%=SystemEnv.getHtmlLabelName(19956,user.getLanguage()) %>";
    diag.URL = "/email/new/MailContacterAdd.jsp";
    diag.show();
}

function closeWin(){
    diag.close();
    $("div#contactsContent div#contactsTree").load("/email/new/MailAddContactsTree.jsp");
}
/**************end*****************MailContactAdd.jsp页面依赖代码******************************************/

function Spage(groupid,num,event,obj){
            num=parseInt(num)+1;
            //总页码
            var prevnum=$(obj).parent().prev().attr("_pagesize");
            var keyword =encodeURI($("#fromSearch").val())
            var t_str="?groupid="+groupid+"&type=1&fx=1&_pagenum="+num+"&keyword="+keyword;
            $.post("/email/new/MailAddContactsTree.jsp"+t_str,"",function(data){
                    $(obj).parent().append(data);   
                    var $pare=$(obj).parent();
                     $pare.find(".more_class").remove();
                     //"+groupId+","+_pagenum+",event,this
                    if(num<prevnum){
                             $pare.append("<div style=\"cursor: pointer;text-align: center;\" onclick=\"Spage('"+groupid+"','"+num+"',event,this)\"   class='more_class'><%=SystemEnv.getHtmlLabelName(17499, user.getLanguage())%></div>");
                    }
            });
            /* $(obj).parent().next().load("/email/new/MailAddContactsTree.jsp"+t_str,function(data){
                   $('.contactsItem').hover(
                        function () {
                          $(this).addClass("contactsItemOver");
                        }, 
                        function () {
                            $(this).removeClass("contactsItemOver");
                        }
                );
            }); */
            
            if (event.stopPropagation) { 
                event.stopPropagation(); 
            } 
            else { 
                window.event.cancelBubble = true; 
            }
        return false;
}
//显示或着隐藏联系人列表
function showOrHideContactList(himself,_pagenum) {
    if($(himself).parent().find(".contactsGroupContent").children().length<1){
        //$(himself).find(".contactsGroupContent").load()
        var keyword =encodeURI($("#fromSearch").val())
        var groupid=$(himself).attr("groupid");
        $(himself).parent().find(".contactsGroupContent").load("/email/new/MailAddContactsTree.jsp?groupid="+groupid+"&onlyNum="+_pagenum+"&keyword="+keyword,function(data){
            $('.contactsItem').hover(
                function () {
                  $(this).addClass("contactsItemOver");
                }, 
                function () {
                    $(this).removeClass("contactsItemOver");
                }
            );
        });
    }
    $(himself).next("#customGroup").toggle();
    $(himself).find("b").each(function(){
        if($(this).hasClass("hide")) {
            $(this).removeClass("hide");
        } else {
            $(this).addClass("hide");
        }
    });
}

//邮件类型切换
$("#isInternal").click(function(){
})

function changeMailType(mailType) {
    removeEditor("mouldtext");
    switch (mailType) {
        case 0:
            //外部邮件
            //$("#contatctsTab").trigger("select");
            $("#internalContacter").hide();
            $("#outerContacter").show().find(".tab:first").click();
            $("#InternalMail").hide();
            $("#ExternalMail").show();
            //$("#miniToolBar").show();
            $("#sendFromDiv").show();
            $("#sendInternalFromDiv").hide();
            $("#addsrz").hide();
            highEditor("mouldtext", editorHeight, 0);
            currentInputId = "to";
            break;
        case 1:
            //内部邮件
            //$("#hrmOrgTab").trigger("select");
            $("#internalContacter").show();
            $("#internalContacter").show().find(".tab:first").click();
            $("#outerContacter").hide();
            $("#InternalMail").show();
            $("#ExternalMail").hide();
            //$("#miniToolBar").hide();
            $("#sendFromDiv").hide();
            $("#sendInternalFromDiv").show();
            $("#addsrz").show();
            highEditor("mouldtext", editorHeight, 1)
            currentInputId = "internalto";
            break;
        default:
            break;
    }
    initToolBarStatus();
}

function checkinput(elementname, spanid) {
    var tmpvalue = $GetEle(elementname).value;
    // 处理$GetEle可能找不到对象时的情况，通过id查找对象
    if (tmpvalue == undefined) {
        tmpvalue = document.getElementById(elementname).value;
    }
    while (tmpvalue.indexOf(" ") >= 0) {
        tmpvalue = tmpvalue.replace(" ", "");
    }
    if (tmpvalue != "") {
        while (tmpvalue.indexOf("\r\n") >= 0) {
            tmpvalue = tmpvalue.replace("\r\n", "");
        }
        if (tmpvalue != "") {
            $GetEle(spanid).innerHTML = "";
        } else {
            $GetEle(spanid).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            //$GetEle(elementname).value = "";
        }
    } else {
        $GetEle(spanid).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
        //$GetEle(elementname).value = "";
    }
}

function doDelAccFile(fileid) {
    for (var i = 0; i < fileIdArr.length; i++) {
        var comId = fileIdArr[i];
        if (comId.indexOf(fileid) == -1) {
            continue;
        }
        var id = jQuery.trim(comId.substring(comId.lastIndexOf("-") + 1));
        doDelAcc(id);
        break;
    }
}

function doDelAcc(id) {
    var fileid = jQuery("#fileid").val();
    if (-1 != fileid.indexOf(id)) {
        fileid = fileid.replace("," + id + ",", ",");
        jQuery("#fileid").val(fileid);
        jQuery("#" + id).remove();
        return;
    }
    var ids = jQuery("#accids").val() + ",";
    ids = ids.replace("," + id + ",", ",")
    jQuery("#accids").val(ids);
    jQuery("#" + id).remove();
    var delids = jQuery("#delaccids").val();
    if (delids != "") {
        delids = delids + "," + id;
    } else {
        delids = id;
    }
    jQuery("#delaccids").val(delids);
    getFileSize(); //获取总的附件大小
    setUploadInfo();
}

$.fn.enable_changed_form_confirm = function() {
    var _f = this;
    $(':text, :password, textarea', this).each(function() {
        $(this).attr('_value', $(this).val());
    });
    $(':checkbox, :radio', this).each(function() {
        var _v = this.checked ? 'on' : 'off';
        $(this).attr('_value', _v);
    });
    $('select', this).each(function() {
        if (this.options.length > 0) {
            $(this).attr('_value', this.options[this.selectedIndex].value);
        }
    });
    $(this).submit(function() {
        window.onbeforeunload = null;
    });
    window.onbeforeunload = function() {
        //doSave($('#savebtn'));
        //提醒保存
        if (is_form_changed(_f)) {
            return "<%=SystemEnv.getHtmlLabelName(31243,user.getLanguage())%>";
        }
    }
}
  
function is_form_changed(f) {    
    var changed = false;    
    try{
        $(':text, :password, textarea', f).each(function() {    
            var _v = $(this).attr('_value');    
            if(typeof(_v) == 'undefined')   _v = '';    
            if(_v != $(this).val()) changed = true;    
        });    
      
        $(':checkbox, :radio', f).each(function() {    
            var _v = this.checked ? 'on' : 'off';  
            if(_v != $(this).attr('_value')) changed = true;    
        });    
       
        $('select', f).each(function() {    
            var _v = $(this).attr('_value');    
            if(typeof(_v) == 'undefined')   _v = '';    
            if(_v != this.options[this.selectedIndex].value) changed = true;  
        });   
    }catch(e){
        
    }
    return changed;    
}  

$(function() {    
    $('form').enable_changed_form_confirm();  
    $(".cb-enable").click(function(){
        var parent = $(this).parents('.switch');
        $('.cb-disable',parent).removeClass('selected');
        $(this).addClass('selected');
        $("#isInternal").attr('checked', true);
        $("#needReceiptDiv").hide();
        $("#needReceipt").attr('checked', false);
        changeMailType(1);
        //$("#isInternal").trigger("click")
    });
    $(".cb-disable").click(function(){
        var parent = $(this).parents('.switch');
        $('.cb-enable',parent).removeClass('selected');
        $(this).addClass('selected');
        $("#isInternal").attr('checked', false);
        $("#needReceiptDiv").show();
        
        changeMailType(0);
    });
    
    //如果初始化的不是内部邮件，则将内部回执功能影藏
    <%if(1 == isInternal){%>
        $("#needReceiptDiv").hide();
        $("#needReceipt").attr('checked', false);
    <%}%>
});  

function getFormIsChange(){
     clearInterval(saveIntervalfn);
/*
     if(is_form_changed($("form"))){
         return  !confirm("<%=SystemEnv.getHtmlLabelName(31243,user.getLanguage())%>\n\n<%=SystemEnv.getHtmlLabelName(31237,user.getLanguage())%>")
     }else{
         return false;
     } */
}

//打开应用程序
function openApp(type) {
    var editorId = "mouldtext";
    onShowApp(type);
}

function onShowApp(type) {
    var id1;
    var url;
    if (type == 'doc') {
        id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids=");
        url = "/docs/docs/DocDsp.jsp?id=";
    } else if (type == 'project') {
        id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?projectids=");
        url = "/proj/data/ViewProject.jsp?ProjID=";
    } else if (type == 'task') {
        id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp?resourceids=");
        url = "/proj/process/ViewTask.jsp?taskrecordid=";
    } else if (type == 'crm') {
        id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids=");
        url = "/CRM/data/ViewCustomer.jsp?CustomerID=";
    } else if (type == 'workflow') {
        id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids=");
        url = "/workflow/request/ViewRequest.jsp?requestid="
    } else if (type == "workplan") {
        id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workplan/data/WorkplanEventsBrowser.jsp");
        url = "/workplan/data/WorkPlanDetail.jsp?workid="
    }

    if (id1) {
        var ids = id1.id;
        var names = id1.name;
        var desc = id1.resourcedesc
        if (ids.length > 500) window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25379,user.getLanguage())%>");
        else if (ids.length > 0) {
            var tempids = ids.split(",");
            var tempnames = names.split(",");
            var description = (true && desc) ? desc.split("\7") : "";
            var sHtml = "";
            for (var i = 0; i < tempids.length; i++) {
                var tempid = tempids[i];
                var tempname = tempnames[i];
                if (tempid != '') {
                    if (type == "workplan") {
                        var desc_i = description[i];
                        var URIComponent = "";
                        if (URIComponent != "") URIComponent = decodeURIComponent(desc_i)
                        sHtml = sHtml + "<br/><a style=''   linkid=" + tempid + " target='_blank' linkType='" + type + "' href='" + url + tempid + "' ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>" + tempname + "</a>&nbsp<br/>" + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + URIComponent;
                    } else {
                        sHtml = sHtml + "<a  linkid=" + tempid + " linkType='" + type + "' href='" + url + tempid + "' target='_blank' ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>" + tempname + "</a>&nbsp";
                    }
                }
            }
            var editorId = "mouldtext";
            if (sHtml != null && sHtml != "" || typeof(sHtml) != 'undefined') {
                if (KE.g[editorId].designMode) {
                    KE.insertHtml(editorId, sHtml);
                } else {
                    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(27541,user.getLanguage())%>"); //请将编辑器切换到可视化模式！
                }
            }
        }
    }
}

//定时发送
function timingsubmit(obj) {
    $("#savedraft").val("1");
    $("#folderid").val("-2");
    getRealMailAddress();
    if ($("#isInternal").is(':checked')) {
        if ((check_form($G("mailAddForm"), 'internalto,subject'))) {
            settimingdate(obj);
        }
    } else {
        if ($("#mailAccountId").length == 0) {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83099,user.getLanguage()) %>");
            return;
        }
        if ($(".mailAdError").length > 0) {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage()) %>")
            return false;
        }
        if ((check_form($G("mailAddForm"), 'to,subject'))) {
            settimingdate(obj);
        }
    }
}

//验证时间
function settimingdate(obj) {
    var date = document.getElementById('date').value;
    var time = document.getElementById('time').value;
    if ("" == date || "" == time) {
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32029, user.getLanguage())%>");
        return;
    }
    var timingdate = date + " " + time + ":00";
    if (new Date(timingdate.replace(/-/g, "/")) < new Date()) {
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32030, user.getLanguage())%>");
        return;
    }
    jQuery("#timingdate").val(timingdate);
    var swfu = $.swfupload.getInstance('.swfupload-control');
    if (swfu.getStats().files_queued > 0) {
        swfu.setButtonDisabled(true);
        swfu.startUpload();
    } else {
        showLoading();
        obj.disabled=true;
        jQuery("#mailAddForm").submit();
    }
}

function setinputdatetime() {
    var date = document.getElementById('date').value;
    var time = document.getElementById('time').value;
    if ("" == date || "" == time) {
        return;
    }
    var timingdate = date + " " + time + ":00";
    if (new Date(timingdate.replace(/-/g, "/")) < new Date()) {
        return;
    }
    $("#timingsubmitType").val("save");
    jQuery("#timingdate").val(timingdate);
}

$(function(){
    if("1" == "<%=needReceipt%>"){
        changeCheckboxStatus_1_8_3(jQuery("#needReceipt")[0],true);
    }
    if(""!="<%=timingdate%>"){
        jQuery("#timeSettingSpan").show();
        changeCheckboxStatus_1_8_3(jQuery("#timeSetting")[0], true);
        return;
    }
    jQuery("#timeSettingSpan").hide();
});

function showTimeSetting(obj){
    if(obj.checked){
        jQuery("#timeSettingSpan").show();
    }else{
        jQuery("#timeSettingSpan").hide();
        jQuery("#timingdate").val("");
        jQuery("#date").val("");
        jQuery("#datespan").html("");
        jQuery("#time").val("");
        jQuery("#timespan").html("");
    }
}

function check_form(mainForm, element) {
    var element = element.split(",");
    for (var i = 0; i < element.length; i++) {
        if (element[i] != "") {
            var input = $(mainForm).find("input[name='" + element[i] + "']");
            if (input.val() == "") {
                var temptitle = input.attr("temptitle");
                var msg = "<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>!"
                if (temptitle) msg = "<%=SystemEnv.getHtmlLabelName(23073,user.getLanguage())%>" + temptitle;
                window.top.Dialog.alert(msg);
                return false;
            }
        }
    }
    return true;
}

function keyDownDelete(obj, event) {
    try {
        if (event.keyCode != 8) {
            return;
        }
        if ($(obj).val() == '') {
            if ($(obj).parent().prev().length > 0) {
                if ($(obj).parent().prev().parent()[0].clientWidth < $(obj).parent().prev().parent()[0].offsetWidth - 4) {
                    //执行相关脚本。   
                } else {
                    $(obj).parent().prev().parent().removeClass("mailInputOverDisplay");
                }
            }
            $(obj).parent().prev().remove();
        }
        if (event.stopPropagation) {
            // this code is for Mozilla and Opera 
            event.stopPropagation();
        } else if (window.event) {
            // this code is for IE 
            window.event.cancelBubble = true;
        }
    } catch (e) {
    }
}

function reflashHrmTree(obj) {
    var isaccount = 0;
    if($('#showaccounthrm').is(':hidden')){
        $('#showaccounthrm').show();
        $('#hideaccounthrm').hide();
        isaccount = 0;
    }else{
        $('#showaccounthrm').hide();
        $('#hideaccounthrm').show();
        isaccount = 1; 
    }
    
    $("#innerHrmTree").remove();
        $("#innerHrmContent").append("<ul id='innerHrmTree' style='width: 100%'></ul>");
        
        $("#innerHrmTree").addClass("hrmOrg"); 
        $("#innerHrmTree").treeview({
           url:"/email/new/hrmOrgTree.jsp?operation=innerHrm&isaccount="+isaccount
     });
}

jQuery(function(){
    if(<%=space%> <= 0){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83075,user.getLanguage()) %>");  
    }
});
</script>
<%!
    public String getDefaultSendFrom(MailManagerService mms,String accountMail){
        if(mms.getTagvalues().indexOf(accountMail.toLowerCase())>-1){
            return accountMail;
        }
        if(mms.getSendcc().toLowerCase().indexOf(accountMail.toLowerCase())>-1){
            return accountMail;
        }
        if(mms.getSendbcc().toLowerCase().indexOf(accountMail.toLowerCase())>-1){
            return accountMail;
        }
        return "";
    }
%>
