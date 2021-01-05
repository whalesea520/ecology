
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.email.po.Mailconfigureinfo"%>
<%@page import="weaver.email.MailReciveStatusUtils"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    String showTop = Util.null2String(request.getParameter("showTop"));
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
%>

<head>
    <script type="text/javascript" src="/js/weaver_wev8.js"></script>
    <link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
    <link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
    <script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>
<%
    Mailconfigureinfo mailconfigureinfo = MailReciveStatusUtils.getMailconfigureinfoFromCache();
    String innerMail = "" + mailconfigureinfo.getInnerMail();
    String outterMail = "" + mailconfigureinfo.getOutterMail();
    String autoReceive = "" + mailconfigureinfo.getAutoreceive();
    int isAll = mailconfigureinfo.getIsAll();
    int emlPeriod = mailconfigureinfo.getEmlPeriod();
    String emlpath = mailconfigureinfo.getEmlpath();
    int isEml = mailconfigureinfo.getIsEml();
    String emlattributes = "{samePair:'emldetail',display:'none'}";
    int clearTime = mailconfigureinfo.getClearTime();
    int dimissionEmpTime = mailconfigureinfo.getDimissionEmpTime();
    int isClear = mailconfigureinfo.getIsClear();
    int timecount = mailconfigureinfo.getTimecount();
    String timeattributes = "{samePair:'timedetail',display:'none'}";
    String clearattributes = "{samePair:'cleardetail',display:'none'}";
    String isAllattributes = "{samePair:'isalldetail',display:'none'}";
    String autoRecattributes = "{samePair:'autoRecdetail',display:'none'}";
    
    if("1".equals(innerMail))
        isAllattributes = "{samePair:'isalldetail'}";
    if("1".equals(outterMail)){
        autoRecattributes = "{samePair:'autoRecdetail'}";
        timeattributes = "{samePair:'timedetail'}";
    }
    if(isClear == 1)
        clearattributes = "{samePair:'cleardetail'}";
    if(isEml == 1)
        emlattributes = "{samePair:'emldetail'}";
    if(autoReceive.equals("1")){
        timeattributes = "{samePair:'timedetail'}";
    }
    int isRecordSuccessMailRemindLog = mailconfigureinfo.getIsRecordSuccessMailRemindLog();
    int clearMailRemindLogTimelimit = mailconfigureinfo.getClearMailRemindLogTimelimit();
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCFromPage="mailOption";//屏蔽右键菜单时使用
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveInfo(),_self} " ;    
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<body>
    <wea:layout attributes="{layoutTableId:topTitle}">
        <wea:group context="" attributes="{groupDisplay:none}">
            <wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
                <input class="e8_btn_top middle" onclick="saveInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
                <span title="菜单" class="cornerMenu"></span>
            </wea:item>
        </wea:group>
    </wea:layout>

    <form method="post" action="MailMaintOperation.jsp" name="weaver">
        <input type="hidden" name="method" value="basesetting">
        <wea:layout attributes="{'expandAllGroup':'true'}">
            <wea:group context="<%=SystemEnv.getHtmlLabelName(128676,user.getLanguage()) %>">
                <wea:item><%=SystemEnv.getHtmlLabelName(24714,user.getLanguage())%></wea:item>
                <wea:item>
                    <input type="checkbox" tzCheckbox="true" name="innerMail" id="innerMail" value="1" class="inputstyle" 
                        <%if(innerMail.equals("1"))out.println("checked=checked");%> onclick="showIsAllDetail(this)"/>
                </wea:item>
                <wea:item><%=SystemEnv.getHtmlLabelName(31139,user.getLanguage())%></wea:item>
                <wea:item>
                    <input type="checkbox" tzCheckbox="true" name="outterMail" id="outterMail" value="1" class="inputstyle" 
                        <%if(outterMail.equals("1"))out.println("checked=checked");%> onclick="showAutoRecDetail(this)"/>
                </wea:item>
                <wea:item attributes='<%=isAllattributes %>'><%=SystemEnv.getHtmlLabelName(82549,user.getLanguage())%></wea:item>
                <wea:item attributes='<%=isAllattributes %>'>
                    <input type="checkbox" tzCheckbox="true" name="isAll" id="isAll" value="1" class="inputstyle" 
                        <%if(isAll == 1)out.println("checked=checked");%> />
                </wea:item>
                <wea:item attributes='<%=autoRecattributes %>'><%=SystemEnv.getHtmlLabelName(23099,user.getLanguage())%></wea:item>
                <wea:item attributes='<%=autoRecattributes %>'>
                    <input type="checkbox" tzCheckbox="true" name="autoReceive" id="autoReceive" value="0" class="inputstyle" 
                        <%if(autoReceive.equals("1"))out.println("checked=checked");%> onclick="showTimeDetail(this)"/>
                </wea:item>
                <wea:item attributes='<%=timeattributes %>'><%=SystemEnv.getHtmlLabelName(128677,user.getLanguage()) %></wea:item>
                <wea:item attributes='<%=timeattributes %>'>
                    <span style="float:left;margin-right:10px;">
                        <SELECT  class=InputStyle name="timecount" id="timecount"  style="width: 120px;" >
                              <option value="300000" <%if(timecount == 300000)out.print("selected='selected'"); %>>5<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage()) %></option>
                              <option value="600000" <%if(timecount == 600000)out.print("selected='selected'"); %>>10<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage()) %></option>
                              <option value="900000" <%if(timecount == 900000)out.print("selected='selected'"); %>>15<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage()) %></option>
                              <option value="1200000" <%if(timecount == 1200000)out.print("selected='selected'"); %>>20<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage()) %></option>
                              <option value="1800000" <%if(timecount == 1800000)out.print("selected='selected'"); %>>30<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage()) %></option>
                        </SELECT>
                    </span>
                </wea:item>
            </wea:group>
            <wea:group context='<%="EML" + SystemEnv.getHtmlLabelName(68,user.getLanguage()) %>'>
                <wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%>EML</wea:item>
                <wea:item>
                    <input type="checkbox" tzCheckbox="true" name="isEml" id="isEml" value="1" class="inputstyle" 
                        <%if(isEml == 1)out.println("checked=checked");%> onclick="showEmlDetail(this)"/>
                </wea:item>
                <wea:item attributes='<%=emlattributes %>'>EML<%=SystemEnv.getHtmlLabelNames("30986,32520",user.getLanguage())%></wea:item>
                <wea:item attributes='<%=emlattributes %>'>
                            <input  name="emlpath"  id="emlpath" value="<%=emlpath %>" maxlength="50" style="width :300px"  class="InputStyle">
                        <img title="<%=SystemEnv.getHtmlLabelName(128678,user.getLanguage())%>" src="/email/images/help_mail_wev8.png" align="absMiddle" />
                </wea:item>
                <wea:item attributes='<%=emlattributes %>'>EML<%=SystemEnv.getHtmlLabelName(128679,user.getLanguage())%></wea:item>
                <wea:item attributes='<%=emlattributes %>'>
                    <wea:required id="emlPeriodSpan" required="true" >
                        <input  name="emlPeriod"  id="emlPeriod" value="<%=emlPeriod %>" maxlength="50" style="width :50px" 
                            onchange="checkinput('emlPeriod','emlPeriodSpan')" class="InputStyle">
                    </wea:required>
                </wea:item>
            </wea:group>
            <wea:group context="<%=SystemEnv.getHtmlLabelName(128680,user.getLanguage()) %>">
                <wea:item><%=SystemEnv.getHtmlLabelName(128681,user.getLanguage()) %></wea:item>
                <wea:item>
                    <input type="checkbox" tzCheckbox="true" name="isClear" id="isClear" value="1" class="inputstyle" 
                        <%if(isClear == 1)out.println("checked=checked");%> onclick="showClearDetail(this)" />
                </wea:item>
                <wea:item attributes='<%=clearattributes %>'><%=SystemEnv.getHtmlLabelName(128682,user.getLanguage()) %></wea:item>
                <wea:item attributes='<%=clearattributes %>'>
                    <span style="float:left;margin-right:10px;">
                        <select class=InputStyle name="clearTime" id="clearTime"  style="width: 120px;" >
                              <option value="1" <%if(clearTime == 1)out.print("selected='selected'"); %>><%=SystemEnv.getHtmlLabelName(84385,user.getLanguage()) %></option>
                              <option value="2" <%if(clearTime == 2)out.print("selected='selected'"); %>><%=SystemEnv.getHtmlLabelName(24490,user.getLanguage()) %></option>
                              <option value="3" <%if(clearTime == 3)out.print("selected='selected'"); %>><%=SystemEnv.getHtmlLabelName(24491,user.getLanguage()) %></option>
                              <option value="4" <%if(clearTime == 4)out.print("selected='selected'"); %>><%=SystemEnv.getHtmlLabelName(20729,user.getLanguage()) %></option>
                              <option value="5" <%if(clearTime == 5)out.print("selected='selected'"); %>><%=SystemEnv.getHtmlLabelName(25201,user.getLanguage()) %></option>
                        </select>
                    </span>
                </wea:item>
                <wea:item attributes='<%=clearattributes %>'><%=SystemEnv.getHtmlLabelName(128683,user.getLanguage()) %></wea:item>
                <wea:item attributes='<%=clearattributes %>'>
                    <span style="float:left;margin-right:10px;">
                        <select class=InputStyle name="dimissionEmpTime" id="dimissionEmpTime"  style="width: 120px;" >
                              <option value="1" <%if(dimissionEmpTime == 1)out.print("selected='selected'"); %>><%=SystemEnv.getHtmlLabelName(84385,user.getLanguage()) %></option>
                              <option value="2" <%if(dimissionEmpTime == 2)out.print("selected='selected'"); %>><%=SystemEnv.getHtmlLabelName(24490,user.getLanguage()) %></option>
                              <option value="3" <%if(dimissionEmpTime == 3)out.print("selected='selected'"); %>><%=SystemEnv.getHtmlLabelName(24491,user.getLanguage()) %></option>
                              <option value="4" <%if(dimissionEmpTime == 4)out.print("selected='selected'"); %>><%=SystemEnv.getHtmlLabelName(20729,user.getLanguage()) %></option>
                              <option value="5" <%if(dimissionEmpTime == 5)out.print("selected='selected'"); %>><%=SystemEnv.getHtmlLabelName(25201,user.getLanguage()) %></option>
                        </select>
                    </span>
                </wea:item>
            </wea:group>
            
            <!-- 群发日志设置 -->
            <wea:group context="<%=SystemEnv.getHtmlLabelName(130183,user.getLanguage()) %>">
                <wea:item><%=SystemEnv.getHtmlLabelName(130184,user.getLanguage()) %></wea:item>
                <wea:item>
                    <input type="checkbox" tzCheckbox="true" name="isRecordSuccessMailRemindLog" id="isRecordSuccessMailRemindLog" value="1" class="inputstyle" 
                        <%if(isRecordSuccessMailRemindLog == 1)out.println("checked=checked");%> />
                    <img title="<%=SystemEnv.getHtmlLabelName(130186,user.getLanguage())%>" src="/email/images/help_mail_wev8.png" align="absMiddle" />
                </wea:item>
                <wea:item><%=SystemEnv.getHtmlLabelName(130185,user.getLanguage())%></wea:item>
                <wea:item>
                    <wea:required id="clearMailRemindLogTimelimitSpan" required="true" >
                        <input  name="clearMailRemindLogTimelimit"  id="clearMailRemindLogTimelimit" value="<%=clearMailRemindLogTimelimit %>" maxlength="50" style="width :50px" 
                            onchange="checkinput('clearMailRemindLogTimelimit','clearMailRemindLogTimelimitSpan')" class="InputStyle">
                    </wea:required>
                </wea:item>
            </wea:group>
        </wea:layout>
    </form>
</body>

<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>  
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
    jQuery(function(){
        jQuery("input[type=checkbox]").each(function(){
            if(jQuery(this).attr("tzCheckbox")=="true"){
               jQuery(this).tzCheckbox({labels:['','']});
            }
        });
    
        checkinput('emlPeriod','emlPeriodSpan');
        checkinput('clearMailRemindLogTimelimit','clearMailRemindLogTimelimitSpan');
        
        var $autoReceive = jQuery("#autoReceive");
        if($autoReceive.is(":checked")){
            $autoReceive.attr("value","1");
            showEle("timedetail");
        }else{
            $autoReceive.attr("value","0");
            hideEle("timedetail");
        }
    });

    function saveInfo(){
         if(!jQuery("#outterMail").is(":checked") && !jQuery("#innerMail").is(":checked")){
            window.top.Dialog.alert("不能禁用！内外部邮件应至少使用一个！");
            return;
        }
        if(check_form(weaver,'emlPeriod')){
         jQuery.post("MailMaintOperation.jsp",jQuery("form").serialize(),function(){
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22619,user.getLanguage())%>");
         });    
        }
    }
    
    function validateValue(obj){
        if(jQuery(obj).attr("name") == "innerMail" && jQuery(obj).is(":checked") && !jQuery("#outterMail").is(":checked")){
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128684,user.getLanguage()) %>"); // 不能禁用！内外部邮件应至少使用一个！
        }
        if(jQuery(obj).attr("name") == "outterMail" && jQuery(obj).is(":checked") && !jQuery("#innerMail").is(":checked")){
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128684,user.getLanguage()) %>"); // 不能禁用！内外部邮件应至少使用一个！
        }
    
    }
    
    function changeValue(obj){
        if(jQuery(obj).attr("value") == "0"){
            jQuery(obj).attr("value","1");
        }else{
            jQuery(obj).attr("value","0");
        }
    }
    
    function showIsAllDetail(obj){
        validateValue(obj);
        jQuery(obj).is(":checked") ? showEle("isalldetail") : hideEle("isalldetail");
    }
    
    function showAutoRecDetail(obj){
       validateValue(obj);
        if(jQuery(obj).is(":checked")){
            showEle("autoRecdetail");
            showEle("timedetail");
        } else {
            hideEle("autoRecdetail");
            hideEle("timedetail");
        }
    }
    
    function showEmlDetail(obj){
        jQuery(obj).is(":checked") ? showEle("emldetail") : hideEle("emldetail");
    }
    
    function showClearDetail(obj){
        jQuery(obj).is(":checked") ? showEle("cleardetail") : hideEle("cleardetail");
    }
    
    function showTimeDetail(obj){
        var $obj = jQuery(obj);
        if($obj.is(":checked")){
            jQuery(obj).attr("value","1");
            showEle("timedetail");
        }else{
            jQuery(obj).attr("value","0");
            hideEle("timedetail");
        }
    }
</script>

