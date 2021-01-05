
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.file.FileUpload"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.social.po.SocialProperties"%>
<%@page import="java.io.*"%>


<%@ taglib uri="/browserTag" prefix="brow"%>
<% 

%>
<%

if (!HrmUserVarify.checkUserRight("message:manager", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String userid = user.getUID()+ "";
String titlename =SystemEnv.getHtmlLabelName(18014,user.getLanguage()); //微博基本设置
String emPropPath = GCONST.getRootPath()+ "WEB-INF/prop/OpenfireModule.properties"; 
JSONObject result = new JSONObject();
FileUpload fu = new FileUpload(request,false);
String Openfire_save = Util.null2String(fu.getParameter("Openfire"));
System.out.print("Openfire_save=="+Openfire_save);
String openfireDomain_save = Util.null2String(fu.getParameter("openfireDomain"));
String openfireEMobileUrl_save = Util.null2String(fu.getParameter("openfireEMobileUrl"));
String openfireMobileClientUrl_save = Util.null2String(fu.getParameter("openfireMobileClientUrl"));
String openfireHttpbindPort_save = Util.null2String(fu.getParameter("openfireHttpbindPort"));
String openfireEmessageClientUrl_saves = Util.null2String(fu.getParameter("openfireEmessageClientUrl"));
String webinf = (GCONST.getRootPath()+ "WEB-INF").replace("\\","/");
String Openfire = "";
String openfireDomain = "";
String openfireEMobileUrl = "";
String openfireMobileClientUrl = "";
String openfireHttpbindPort = "" ;
String openfireEmessageClientUrl = "";
boolean  isOpenfire = false;
boolean  isOpenfirePort = false;
new BaseBean().writeLog("=============="+isOpenfirePort);
new BaseBean().writeLog("=============="+openfireHttpbindPort_save);
if(openfireHttpbindPort_save.equals("true")){
    openfireHttpbindPort_save = "7443";
    isOpenfirePort = true;
}else if(openfireHttpbindPort_save.equals("false")){
    openfireHttpbindPort_save = "7070";
    isOpenfirePort = false;
}
if(!Openfire_save.equals("")&&!openfireEMobileUrl_save.equals("")&&!openfireMobileClientUrl_save.equals("")&&!openfireHttpbindPort_save.equals("")){
    try{
        SocialProperties propertie = new SocialProperties();
        FileInputStream inputFile = new FileInputStream(emPropPath);
        propertie.load(inputFile);
        //propertie.clear();
        inputFile.close();
        propertie.setProperty("Openfire", Openfire_save);
        propertie.setProperty("openfireDomain", openfireDomain_save);
        propertie.setProperty("openfireEMobileUrl", openfireEMobileUrl_save);
        propertie.setProperty("openfireMobileClientUrl", openfireMobileClientUrl_save);
        propertie.setProperty("openfireHttpbindPort", openfireHttpbindPort_save);
        //Date d = new Date();
        //SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        //propertie.setProperty("update time", sdf.format(d));
        FileOutputStream outputFile = new FileOutputStream(emPropPath);
        propertie.store(outputFile,null);
        outputFile.close();
    }catch(Exception e){}
    Openfire = Openfire_save;
    if(Openfire_save.equals("true")){
        isOpenfire = true;
    }else if(Openfire_save.equals("false")){
        isOpenfire = false;
    }
    openfireDomain = openfireDomain_save;
    openfireEMobileUrl = openfireEMobileUrl_save;
    openfireMobileClientUrl = openfireMobileClientUrl_save;
    openfireHttpbindPort = openfireHttpbindPort_save;
    openfireEmessageClientUrl = openfireEmessageClientUrl_saves;
}else{
    try{
        File emPropFile = new File(emPropPath);
        OrderProperties emProp = new OrderProperties();
        if(emPropFile.exists()){
            emProp.load(emPropPath);
            List<String> it=emProp.getKeys();
            for(String key  : it){
                String value = Util.null2String(emProp.get(key));
                result.put(key,value);
            }
        }
    }catch(Exception e){}
    Openfire = result.getString("Openfire");
    if(Openfire.equals("true")){
        isOpenfire = true;
    }else if(Openfire.equals("false")){
        isOpenfire = false;
    }
    openfireDomain = result.getString("openfireDomain");
    openfireEMobileUrl = result.getString("openfireEMobileUrl");
    openfireMobileClientUrl = result.getString("openfireMobileClientUrl");
    openfireHttpbindPort = result.getString("openfireHttpbindPort");
    if(openfireHttpbindPort.equals("7070")){
        isOpenfirePort = false; 
    }else if(openfireHttpbindPort.equals("7443")){
        isOpenfirePort = true;
    }
    try{
        openfireEmessageClientUrl = result.getString("openfireEmessageClientUrl");
    }catch(Exception ex){
        openfireEmessageClientUrl ="";
    }
}
openfireEMobileUrl = openfireEMobileUrl.replace("\\", "");
%>
<!DOCTYPE HTML>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
    <SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
	<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()+"'></script>

 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</head>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="social"/>
   <jsp:param name="navName" value="消息服务配置"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
    <wea:group context="" attributes="{groupDisplay:none}">
        <wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
            <span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
                <input class="e8_btn_top middle" onclick="doSave()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
            </span>
            <span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
        </wea:item>
    </wea:group>
</wea:layout>

<form action="SocialIMOpenfire.jsp" method="post"  id="mainform" enctype="multipart/form-data">
<input type="hidden" value="upload" name="operation"/> 
<wea:layout>
    <wea:group context="消息连接参数配置">
        <wea:item><%="是否启用私有云消息服务"%></wea:item>
        <wea:item>  
            <input type="checkbox" tzCheckbox="true" name="Openfire" id="Openfire" value="<%=Openfire%>" class="inputstyle" 
                <%if(isOpenfire)out.println("checked=checked");%> onchange="changeValue(this);"/>
            <input type="hidden" name="Openfire" value="<%=Openfire%>">
                <span id="Openfire_span"></span>
        </wea:item>
        
        <wea:item attributes="{'samePair':'openfireEMobileUrl'}"><%="设置私有云服务控制台地址"%></wea:item>
        <wea:item attributes="{'samePair':'openfireEMobileUrl'}">
                <input name="openfireEMobileUrl" id="openfireEMobileUrl" info="私有云服务控制台地址"
                    value="<%=openfireEMobileUrl%>"
                    valueCache="<%=openfireEMobileUrl%>"
                    defaultMax="500" maxlength="100" style="width :200px" 
                    onchange="checkinput('openfireEMobileUrl', 'openfireEMobileUrl_span');validateValue(this);"  
                    class="InputStyle">
                <span id="openfireEMobileUrl_span"></span>
                <span error="false">(填写格式为http://emessageserviceip:9090，例如：emessage服务内网ip为192.168.1.3，则此处设置为http://192.168.1.3:9090)</span>
        </wea:item>
        
        <wea:item attributes="{'samePair':'openfireMobileClientUrl'}"><%="客户端连接消息服务地址"%></wea:item>
        <wea:item attributes="{'samePair':'openfireMobileClientUrl'}">
                <input name="openfireMobileClientUrl" id="openfireMobileClientUrl" info="客户端连接消息服务地址"
                    value="<%=openfireMobileClientUrl%>" 
                    valueCache="<%=openfireMobileClientUrl%>" 
                    defaultMax="500" maxlength="100" style="width :200px" 
                    onchange="checkinput('openfireMobileClientUrl', 'openfireMobileClientUrl_span');validateValue(this);"  
                    class="InputStyle">
                <span id="openfireMobileClientUrl_span"></span>
                <img title="详细说明请参考部署文档，点击打开" src="/email/images/help_mail_wev8.png" align="absMiddle" onClick = "openUrl()"/>
                <span error="false">(emessage客户端和手机客户端访问私有云服务的地址，建议配置为域名)</span>
        </wea:item>
        
        <wea:item attributes="{'samePair':'openfireEmessageClientUrl'}"><%="emessage连接消息服务地址"%></wea:item>
        <wea:item attributes="{'samePair':'openfireEmessageClientUrl'}">
                <input name="openfireEmessageClientUrl" id="openfireEmessageClientUrl"  info="emessage连接消息服务地址"
                    value="<%=openfireEmessageClientUrl%>" 
                    valueCache="<%=openfireEmessageClientUrl%>" 
                    defaultMax="500" maxlength="100" style="width :200px"
                    onchange="validateValue(this);"
                    class="InputStyle">
                <span id="openfireEmessageClientUrl_span"></span>
                <span error="false">(默认为空，直接请求客户端连接消息服务地址，如果此处配置了地址，则emessage请求消息服务直接使用此地址)</span>
        </wea:item>
        
        <wea:item attributes="{'samePair':'openfireHttpbindPort'}"><%="ecology服务是否启用https"%></wea:item>
        <wea:item attributes="{'samePair':'openfireHttpbindPort'}">
            <input type="checkbox" tzCheckbox="true" name="openfireHttpbindPort" id="openfireHttpbindPort" value="<%=isOpenfirePort%>" class="inputstyle" 
                <%if(isOpenfirePort)out.println("checked=checked");%> onchange="changeHttpValue(this);"/>
            <input type="hidden" name="openfireHttpbindPort" value="<%=isOpenfirePort%>">
                <span id="openfireHttpbindPort_span"></span>
                <img title="emessage私有云配置https方法说明，点击打开" src="/email/images/help_mail_wev8.png" align="absMiddle" onClick = "openHttps()"/>
                <span>(默认不启用表示ecology使用http方式，emessage请求7070端口，启用则表示ecology使用https方式，emessage请求7443端口，需给emessage服务配置证书)</span>
        </wea:item>
    </wea:group>
    
    <wea:group context="e-message问题检测（如果编辑了配置，请保存后再检测）">
    <wea:item attributes="{'samePair':'checkToken'}"><%="公有云消息token获取检测"%></wea:item>
    <wea:item attributes="{'samePair':'checkToken'}">
     <input type="button" value="验证" class="e8_btn_submit" onclick="checkToken();"/>
     </wea:item>
     
     
     <wea:item attributes="{'samePair':'checkConnect'}"><%="e-message连接故障检测"%></wea:item>
    <wea:item attributes="{'samePair':'checkConnect'}">
     <input type="button" value="验证" class="e8_btn_submit" onclick="checkConnect(this);"/>
     <img title="点击查看案例预览" info="checkConnect" src="/email/images/help_mail_wev8.png" align="absMiddle" onclick = "openErrorPic(this);"/>
     <span></span>
     </wea:item>
     
     <wea:item attributes="{'samePair':'checkSingleLogin'}"><%="e-message无法单点登录检测"%></wea:item>
    <wea:item attributes="{'samePair':'checkSingleLogin'}">
     <input type="button" value="验证" class="e8_btn_submit" onclick="checkSingleLogin(this);"/>
     <img title="点击查看案例预览" info="checkSingleLogin1" src="/email/images/help_mail_wev8.png" align="absMiddle" onclick = "openErrorPic(this);"/>
     <span></span>
     </wea:item>
     
     <wea:item attributes="{'samePair':'checkSingleLogin'}"><%="e-message下载文件打不开检测"%></wea:item>
    <wea:item attributes="{'samePair':'checkSingleLogin'}">
     <input type="button" value="验证" class="e8_btn_submit" onclick="checkSingleLogin(this);"/>
     <img title="点击查看案例预览" info="checkSingleLogin2" src="/email/images/help_mail_wev8.png" align="absMiddle" onclick = "openErrorPic(this);"/>
     <span></span>
     </wea:item>

     </wea:group>
</wea:layout>
</form>  
<!-- 
     <wea:item attributes="{'samePair':'wayToCheck'}"><%="访问emessage问题检测页面"%></wea:item>
     <wea:item attributes="{'samePair':'wayToCheck'}">
     <input type="button" value="点击跳转" class="e8_btn_submit" onclick="wayToCheck();"/>
     </wea:item>
      -->
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
 <script type="text/javascript">
  function doSave(){
     var openfireMobileClientUrl = $(document).find('form').find('input#openfireMobileClientUrl').next().next().next();
     var openfireEMobileUrl = $(document).find('form').find('input#openfireEMobileUrl').next().next();
     var openfireEmessageClientUrl = $(document).find('form').find('input#openfireEmessageClientUrl').next().next();
     var flag = false;
     if(openfireEMobileUrl.attr('error')=='true'){
        flag =true;
        window.top.Dialog.confirm(openfireEMobileUrl.html()+"</br>点击确定则忽略错误，继续保存，取消则不保存",function(){
            window.top.Dialog.alert("保存成功",function(){
                jQuery("#mainform").submit();
                return;
            });
        },function(){
            openfireEMobileUrl.siblings('input#openfireEMobileUrl').focus();
        return;
        });
     }
     if(openfireMobileClientUrl.attr('error')=='true'){
        flag =true;
        window.top.Dialog.confirm(openfireMobileClientUrl.html()+"</br>点击确定则忽略错误，继续保存，取消则不保存",function(){
            window.top.Dialog.alert("保存成功",function(){
                jQuery("#mainform").submit();
                return;
            });
        },function(){
            openfireMobileClientUrl.siblings('input#openfireMobileClientUrl').focus();
            return;
        });
        
     }
     if(openfireEmessageClientUrl.attr('error')=='true'){
        flag =true;
        window.top.Dialog.confirm(openfireEmessageClientUrl.html()+"</br>点击确定则忽略错误，继续保存，取消则不保存",function(){
            window.top.Dialog.alert("保存成功",function(){
                jQuery("#mainform").submit();
                return;
            });
        },function(){
            openfireEmessageClientUrl.siblings('input#openfireEmessageClientUrl').focus();
            return;
        });
     }
     if(!flag){
        window.top.Dialog.alert("保存成功",function(){
          jQuery("#mainform").submit();
          return;
        });
     }
  }
  
  jQuery(document).ready(function(){
	   var openfire = "<%=Openfire%>";
	   var openfireEMobileUrl = "<%=openfireEMobileUrl%>";
	   var openfireMobileClientUrl = "<%=openfireMobileClientUrl%>";
	   var openfireHttpbindPort = "<%=openfireHttpbindPort%>";
       var openfireEmessageClientUrl = "<%=openfireEmessageClientUrl%>";
	   if(openfire==='false'){
	       hideEle("openfireEMobileUrl");
           hideEle("openfireMobileClientUrl");
           hideEle("openfireEmessageClientUrl");
           hideEle("openfireHttpbindPort");
           hideEle("openfireHttpbindPort_check");
           hideEle("checkConnect");
	   }else{
	       hideEle("checkToken");
	   }
  });
  
  function wayToCheck(){
     var origin = window.location.origin;
     var pathname= "/social/manager/SocialIMCheck.jsp";
     var host = origin+pathname;
     window.open(host,"_blank");
  }
  
  function openErrorPic(obj){
      var dialog = new window.top.Dialog();
      dialog.currentWindow = window;
      dialog.Title = "错误展示";
      dialog.normalDialog= false;
      dialog.Drag = true;
      var inhtml = "";
      var name = $(obj).attr('info');
      var img = '';
      if(name=='checkConnect'){
          img = "<img src='../images/socialimcheck/ConnectError.png'>";
          dialog.Width = 700;
          dialog.Height = 600;
      }else if(name=='checkSingleLogin1'){
          img = "<img src='../images/socialimcheck/SingleLoginError.png'>";
          dialog.Width = 1400;
          dialog.Height = 750;
      }else if(name=='checkSingleLogin2'){
          img = "<img src='../images/socialimcheck/DownloadError.png'>";
          dialog.Width = 900;
          dialog.Height = 450;
      }
      inhtml += "<div style='font-size:15px;padding-top:27px;text-align: left;padding-left: 24px;'><h3>案例如图所示：</h3></br>"+
             img;
      dialog.InnerHtml = inhtml;
      dialog.show();
  }
  
  function checkConnect(obj){
      var openfire = "<%=Openfire%>";
      var openfireEMobileUrl = "<%=openfireEMobileUrl%>";
      var openfireMobileClientUrl = "<%=openfireMobileClientUrl%>";
      var openfireHttpbindPort = "<%=openfireHttpbindPort%>";
      var openfireEmessageClientUrl = "<%=openfireEmessageClientUrl%>";
      var a = document.createElement('a');  
      a.href = openfireEMobileUrl;  
      var host = a.hostname;
      var dialog = new window.top.Dialog();
      dialog.currentWindow = window;
      dialog.Title = "解决方案";
      dialog.Width = 300;
      dialog.Height = 200;
      dialog.normalDialog= false;
      dialog.Drag = true;
      var inhtml = '';
      var $main = $(obj).next().next();
      $main.html('<font color="red">正在检测，请稍候</font>');
      
      checkHostPort(host,"9090",function(flag){
          if(flag){
              checkToken2(function(flag){
                  if(flag){
                      var address = '';
                      if(openfireEmessageClientUrl!==''){
                          address = openfireEmessageClientUrl;
                      }else{
                          address = openfireMobileClientUrl;
                      }
                              testWebSocket(address,openfireHttpbindPort,function(flag){
                                  if(flag){
                                       window.top.Dialog.alert("<font color='green'>消息服务访问正常</font>");
                                       $main.html('');
                                       return;
                                  }else{
                                      //客户端没有端口没有开放
                                       window.top.Dialog.alert("<font color='red'>"+openfireHttpbindPort+"端口访问失败，该电脑无法访问"+address+"的"+openfireHttpbindPort+"端口，请联系网络管理员确认端口是否开放</font>");
                                       $main.html('');
                                       return;
                                  }
                              });
                  }else{
                      //获取token失败
                      window.top.Dialog.alert("<font color='red'>获取token异常，解决方案：</br>请重启一下ecology服务以及私有云消息服务后再登陆</font>");
                      $main.html('');
                      return;
                  }
              }); 
          }else{
              //9090端口访问不通
              //window.top.Dialog.alert("<font color='red'>私有云服务9090端口访问失败，1.请确认私有云服务是否正确启动，</br>2.请确认私有云服务初始化成功，请访问地址"+openfireEMobileUrl+"确认，</br>3.请确认</font>");
              inhtml += "<div style='color:red;font-size:15px;padding-top:27px'>私有云服务9090端口访问失败，解决方案：</br>"+
              "1、请确认私有云服务是否正确启动；</br>"+
              "2、请确认地址"+openfireEMobileUrl+"是否配置正确；</br>"+
              "3、请确认私有云服务是否初始化成功，可以访问地址"+openfireEMobileUrl+"确认<div>";
              dialog.InnerHtml = inhtml;
              $main.html('');
              dialog.show();
              return;
          }
      });
  
  }
  
  function checkSingleLoginBak(obj){
      var webinf = "<%=webinf%>";
      var dialog = new window.top.Dialog();
      dialog.currentWindow = window;
      dialog.Title = "解决方案";
      dialog.Width = 600;
      dialog.Height = 550;
      dialog.normalDialog= false;
      dialog.Drag = true;
      var inhtml = '';
      var $main = $(obj).next().next();
      $main.html('<font color="red">正在检测，请稍候</font>');
      jQuery.post('/social/manager/SocialIMCheckOperation.jsp?operation=isBaseFilterConfigured', function(flag){
         if(jQuery.trim(flag)==='true'){
             inhtml += "<div style='font-size:15px;padding-top:27px;text-align: left;padding-left: 24px;'><h3>已经配置了SocialIMFilter过滤器，但是问题没有解决，解决方案：</h3></br>"+
             "1、在"+webinf+"目录下找到<font color='red'>web.xml</font>文件；</br></br>" +
             "2、打开该文件，在文件中搜索<font color='red'>SocialIMFilter</font>关键字；</br></br>" +
             "3、把过滤器的配置内容拷贝出来，放到<font color='red'>web-app</font>的下方；</br></br>" + 
             "4、备注：过滤器配置内容应该和下方内容保持一致：</br></br>" + 
              "<div style='color:red;'><xmp><filter></xmp>"+
               "<xmp><filter-name>SocialIMFilter</filter-name></xmp>"+
                       "<xmp><filter-class>weaver.social.filter.SocialIMFilter</filter-class></xmp>"+
                     "<xmp></filter></xmp>"+
                      "<xmp><filter-mapping></xmp>"+
                        "<xmp><filter-name>SocialIMFilter</filter-name></xmp>"+
                        "<xmp><url-pattern>/social/im/*.jsp</url-pattern></xmp>"+
                      "<xmp></filter-mapping></xmp>"+
                      "<xmp><filter-mapping></xmp>"+
                        "<xmp><filter-name>SocialIMFilter</filter-name></xmp>"+
                        "<xmp><url-pattern>/weaver/weaver.file.FileDownload</url-pattern></xmp>"+
                      "<xmp></filter-mapping></xmp></div>";
              dialog.InnerHtml = inhtml;
              $main.html('');
              dialog.show();
             return;
         }else{
             inhtml += "<div style='font-size:15px;padding-top:27px;text-align: left;padding-left: 24px;'><h3>没有配置SocialIMFilter过滤器，解决办法：</h3></br>"+
             "1、在"+webinf+"目录下找到<font color='red'>web.xml</font>文件；</br></br>" +
             "2、打开该文件，在文件中搜索<font color='red'>WSessionClusterFilter</font>关键字，如果找到，就将下面配置内容放到<font color='red'>WSessionClusterFilter</font>过滤器的下方；</br></br>" +
             "3、如果没有找到该过滤器，那就将下面配置内容放到<font color='red'>web-app</font>的下方；</br></br>" + 
             "4、配置内容如下：</br></br>" + 
              "<div style='color:red;'><xmp><filter></xmp>"+
               "<xmp><filter-name>SocialIMFilter</filter-name></xmp>"+
                       "<xmp><filter-class>weaver.social.filter.SocialIMFilter</filter-class></xmp>"+
                     "<xmp></filter></xmp>"+
                      "<xmp><filter-mapping></xmp>"+
                        "<xmp><filter-name>SocialIMFilter</filter-name></xmp>"+
                        "<xmp><url-pattern>/social/im/*.jsp</url-pattern></xmp>"+
                      "<xmp></filter-mapping></xmp>"+
                      "<xmp><filter-mapping></xmp>"+
                        "<xmp><filter-name>SocialIMFilter</filter-name></xmp>"+
                        "<xmp><url-pattern>/weaver/weaver.file.FileDownload</url-pattern></xmp>"+
                      "<xmp></filter-mapping></xmp></div>";
              dialog.InnerHtml = inhtml;
              $main.html('');
              dialog.show();
             return;
         }
     });
  
  }
  
  function checkSingleLogin(obj){
      var webinf = "<%=webinf%>";
      var dialog = new window.top.Dialog();
      dialog.currentWindow = window;
      dialog.Title = "解决方案";
      dialog.Width = 600;
      dialog.Height = 600;
      dialog.normalDialog= false;
      dialog.Drag = true;
      var inhtml = '';
      var $main = $(obj).next().next();
      $main.html('<font color="red">正在检测，请稍候</font>');
      var title = "";
      var messsage3 = "";
      var messsage2 = "";
      jQuery.post('/social/manager/SocialIMCheckOperation.jsp?operation=checkALLFilter', function(data){
          var result = JSON.parse(jQuery.trim(data));
          var numSocialIMFilter = parseInt(result.isSocialIMFilter);
          var numWSessionClusterFilter = parseInt(result.isWSessionClusterFilter);
          var numSecurityFilter = parseInt(result.isSecurityFilter);
          var errorInfo = result.error;
          if(errorInfo==""){
	      if(numSocialIMFilter > 0){
	           title = "已经配置了SocialIMFilter过滤器，如果问题没有解决，解决方法：";
	           if(numWSessionClusterFilter>0&&numSecurityFilter>0){
	               if(numWSessionClusterFilter>numSocialIMFilter&&numSocialIMFilter>numSecurityFilter){
	                   window.top.Dialog.alert("<font color='green'>配置正确</font>");
	                   $main.html('');
	                   return;
	               }else if(numWSessionClusterFilter<numSocialIMFilter||numSocialIMFilter<numSecurityFilter){
	                   messsage2 = "2、打开该文件，在文件中搜索<font color='red'>WSessionClusterFilter</font>和<font color='red'>SocialIMFilter</font>关键字；</br></br>";
                       messsage3 = "3、把<font color='red'>SocialIMFilter</font>配置的内容剪切到<font color='red'>WSessionClusterFilter</font>过滤器的下方；</br></br>";
	               }else{
	                   messsage2 = "2、打开该文件，在文件中搜索<font color='red'>WSessionClusterFilter</font>和<font color='red'>SocialIMFilter</font>关键字；</br></br>";
                       messsage3 = "3、把<font color='red'>WSessionClusterFilter</font>配置的内容剪切到<font color='red'>web-app</font>节点的下方，并把<font color='red'>SocialIMFilter</font>配置的内容剪切到<font color='red'>WSessionClusterFilter</font>过滤器的下方；</br></br>";
	               }
	           }else if(numWSessionClusterFilter>0){
	               if(numWSessionClusterFilter>numSocialIMFilter){
	                   window.top.Dialog.alert("<font color='green'>配置正确</font>");
	                   $main.html('');
                       return;
	               }else{
	                   messsage2 = "2、打开该文件，在文件中搜索<font color='red'>WSessionClusterFilter</font>和<font color='red'>SocialIMFilter</font>关键字；</br></br>";
                       messsage3 = "3、把<font color='red'>SocialIMFilter</font>配置的内容剪切到<font color='red'>WSessionClusterFilter</font>过滤器的下方；</br></br>";
	               }
	           }else if(numSecurityFilter>0){
	               if(numSocialIMFilter>numSecurityFilter){
                       window.top.Dialog.alert("<font color='green'>配置正确</font>");
                       $main.html('');
                       return;
                   }else{
                       messsage2 = "2、打开该文件，在文件中搜索<font color='red'>SocialIMFilter</font>关键字；</br></br>";
                       messsage3 = "3、把<font color='red'>SocialIMFilter</font>配置的内容剪切到<font color='red'>web-app</font>节点的下方；</br></br>";
                   }
	           }else{
	                messsage2 = "2、打开该文件，在文件中搜索<font color='red'>SocialIMFilter</font>关键字；</br></br>";
                    messsage3 = "3、把<font color='red'>SocialIMFilter</font>配置的内容剪切到<font color='red'>web-app</font>节点的下方；</br></br>";
	           }
	      }else{
	           title = "没有配置SocialIMFilter过滤器，解决办法：";
	           if(numWSessionClusterFilter>0){
	               messsage2 = "2、打开该文件，在文件中搜索<font color='red'>WSessionClusterFilter</font>关键字；</br></br>";
	               messsage3 = "3、将下方标红的内容配置到<font color='red'>WSessionClusterFilter</font>过滤器的下方；</br></br>";
	           }else if(numSecurityFilter>0){
	               messsage2 = "2、打开该文件，在文件中搜索<font color='red'>SecurityFilter</font>关键字；</br></br>";
	               messsage3 = "3、将下方标红的内容配置到<font color='red'>SecurityFilter</font>过滤器的上方；</br></br>";
	           }else{
	               messsage2 = "2、打开该文件，在文件中搜索<font color='red'>web-app</font>关键字；</br></br>";
                   messsage3 = "3、将下方标红的内容配置到<font color='red'>web-app</font>节点的下方；</br></br>";
	           }
	      }
	      }else{
	           window.top.Dialog.alert("<font color='red'>服务异常，检查失败</font>");
	           $main.html('');
               return;
	      }
	      inhtml += "<div style='font-size:15px;padding-top:27px;text-align: left;padding-left: 24px;'><h3>"+title+"</h3></br>"+
	             "1、在<font color='red'>"+webinf+"</font>目录下找到<font color='red'>web.xml</font>文件，并先<font color='red'>备份</font>该文件；</br></br>" +
	              messsage2 +
	              messsage3 + 
	              "4、修改完成后需要重启ecology服务才会生效；</br></br>" +
	              "5、备注：<font color='red'>SocialIMFilter</font>过滤器配置内容应该和下方内容保持一致：</br></br>" + 
	              "<div style='color:red;'><xmp><filter></xmp>"+
	               "<xmp><filter-name>SocialIMFilter</filter-name></xmp>"+
	                       "<xmp><filter-class>weaver.social.filter.SocialIMFilter</filter-class></xmp>"+
	                     "<xmp></filter></xmp>"+
	                      "<xmp><filter-mapping></xmp>"+
	                        "<xmp><filter-name>SocialIMFilter</filter-name></xmp>"+
	                        "<xmp><url-pattern>/social/im/*.jsp</url-pattern></xmp>"+
	                      "<xmp></filter-mapping></xmp>"+
	                      "<xmp><filter-mapping></xmp>"+
	                        "<xmp><filter-name>SocialIMFilter</filter-name></xmp>"+
	                        "<xmp><url-pattern>/weaver/weaver.file.FileDownload</url-pattern></xmp>"+
	                      "<xmp></filter-mapping></xmp></div>";       
	       dialog.InnerHtml = inhtml;
	       $main.html('');
	       dialog.show();
	       return;
	  });
  }
  
  function checkHostPort(host,port,cb){
     jQuery.post('/social/manager/SocialIMCheckOperation.jsp?operation=checkPort',{port: port,hostname : host}, function(flag){
         if(jQuery.trim(flag)==='1'){
             cb(true);
         }else{
             cb(false);
         }
     });
 }
 
 function checkToken2(cb){
     jQuery.post('/social/manager/SocialIMCheckOperation.jsp?operation=checkToken&reFreshToken=1',{"host":""}, function(token){
         if(jQuery.trim(token)!==''){
             cb(true);
         }else{
             cb(false);
         }
     });
 }
  
  function checkToken(obj,host){
     //配置项检查，带有host为参数
     var isOpenfire = $(document).find('form').find('input#Openfire').attr('checked');
     var url = "";
     var userid = "<%=userid%>";
     if(isOpenfire){
       url = "/social/manager/SocialIMCheckOperation.jsp?operation=checkToken&reFreshToken=1";
     }else{
       url = "/social/im/SocialIMOperation.jsp?operation=getUserTokenOfRong&userid="+userid;
       host = "";
     }
     jQuery.post(url,{"host":host},function(token){
          if(jQuery.trim(token)!==''){
             if(isOpenfire){
                $(obj).next().next().attr("error","fasle").html('<font color="green">检测通过</font>')
             }else{
                window.top.Dialog.alert("获取token成功");
             }
          }else{
             if(isOpenfire){
                //window.top.Dialog.alert("获取token失败，请检查emssage服务是否正常");
                $(obj).next().next().attr("error","true").html('<font color="red">获取私有云token失败，请确认私有云服务是否正确启动并初始化，ecology服务是否能访问私有云服务的9090端口</font>');
                return;
             }else{
                window.top.Dialog.alert("获取token失败，请检查oa服务是否能够正常访问融云服务器");
                return;
             }
          }
     });
  }
   
  function openFilter(){
    window.open("http://emessage.e-cology.com.cn/html/emessagefile/message4.x%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98%E8%A7%A3%E5%86%B3%E6%96%B9%E6%A1%88.htm#_Toc502157626","_blank");
  }
  function openHttps(){
    window.open("http://emessage.e-cology.com.cn/html/download.html","_blank");
  }
  
  function checkEmessagePort(obj,ip,name){
       var port = "";
       var is7443 = $(document).find('form').find('input#openfireHttpbindPort').attr('checked');
       if(is7443){
            port = '7443'
       }else{
            port = '7070'
       }
       
       var $mainObj = null;
       if(name=='openfireMobileClientUrl'){
           $mainObj = $(obj).next().next().next();
       }else if(name=='openfireEmessageClientUrl'){
           $mainObj = $(obj).next().next();
       }
       
       if(ip.substring(0,4)=="http"||ip.substring(0,5)=="https"){
           $mainObj.attr("error","true").html('<font color="red">该地址不需要带上http或者https协议头</font>');
           return;
       }
       if(ip=="127.0.0.1"){
           $mainObj.attr("error","true").html('<font color="red">该地址不能配置为127.0.0.1</font>');
           return;
       }
       if(!checkIP(ip)){
           $mainObj.attr("error","true").html('<font color="red">该地址ip配置格式不正确</font>');
           return;
       }

       $mainObj.html('<font color="red">正在检测，请稍候</font>');
       
       jQuery.post('/social/manager/SocialIMCheckOperation.jsp?operation=checkPort',{"port": port,"hostname" : ip}, function(ok){
            if(jQuery.trim(ok)==='1'){
            testWebSocket(ip,port,function(flag){
                if(flag){
                    $mainObj.attr("error","fasle").html('<font color="green">检测通过</font>');
                    return;
                }else{
                    $mainObj.attr("error","true").html('<font color="red">客户端连接消息服务失败,请尝试：<a href="#" onClick="openHttps()" style="color:red">更新emessage更新包以及私有云更新包(点击跳转)</a></font>');
                    return; 
                }
            });
            }else{
                $mainObj.attr("error","true").html('<font color="red">emessage客户端连接消息服务失败，请检查该地址是否配置正确，私有云服务'+port+'端口是否开放</font>');
                return;
            }
       });
  }
  
  function testWebSocket(ip,port,cb){
    //ws://192.168.7.201:7070/ws/ 如果是https下 wss   wss://192.168.7.201:7070/ws/
    var url = '';
    var hostname ="";
    if(port=='7443'){
        hostname = "wss";
    }else{
        hostname = "ws";
    }
    url = hostname+'://'+ip+':'+port+'/ws/';
    var ws = new WebSocket(url,'xmpp');

    ws.onerror = function () {
        cb(false);
    };
        
    ws.onopen = function () {
        cb(true);
    };
  }
  
  
  function checkEmobilePort(){
       var hostname = "<%=openfireMobileClientUrl%>";
       jQuery.post('/social/manager/SocialIMCheckOperation.jsp?operation=checkPort',{port: 5222,hostname : hostname}, function(ok){
            if(jQuery.trim(ok)==='1'){
                window.top.Dialog.alert("emobile端连接消息成功");
            }else{
                window.top.Dialog.alert("emobile端连接消息失败，请检查私有云服务"+5222+"端口是否开放");
            }
       });
  }
  
  function checkFilter(){
    jQuery.post('/social/manager/SocialIMCheckOperation.jsp?operation=checkFilter', function(ok){
            if(jQuery.trim(ok)==='1'){
                window.top.Dialog.alert("过滤器已经配置");
            }else{
                window.top.Dialog.alert("过滤器没有配置成功");
            }
    });
  }
  
  function validateValue(obj){
       var $chk = jQuery(obj);
       var _name = $chk.attr("name");
       var value = $chk.val();
       var info = $chk.attr("info");
       var regex = '(?=(\b|\D))(((\d{1,2})|(1\d{1,2})|(2[0-4]\d)|(25[0-5]))\.){3}((\d{1,2})|(1\d{1,2})|(2[0-4]\d)|(25[0-5]))(?=(\b|\D))';
       var rex = new RegExp(strRegex);
       if(_name==='openfireEMobileUrl'){
           var host = "";
           var strRegex = "^(http\:\/\/|https\:\/\/)?" +
            "(([0-9]{1,3}\.){3}[0-9]{1,3}" +
            "|" +
            "([0-9a-z_!~*'()-]+\.)*" +
            "([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\." +
            "[a-z]{2,6})" +
            "(:[0-9]{1,5})?" +
            "((/?)|" +
            "(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$";
            var re = new RegExp(strRegex);
            if(value===''){
                $(obj).next().next().attr("error","true").html('<font color="red">'+info+'不允许为空</font>');
                return;
            }
            if (!re.test(value)) {
                //window.top.Dialog.alert("私有云服务控制台地址格式配置不正确");
                $(obj).next().next().attr("error","true").html('<font color="red">私有云服务控制台地址格式配置不正确,请修改</font>');
                return;
            }
            if(value.substring(0,4)!=="http"){
                $(obj).next().next().attr("error","true").html('<font color="red">私有云服务控制台地址格式配置不正确，缺少前缀http:\/\/或者https:\/\/</font>');
                return;
            }
           if(!(value.lastIndexOf(":")!==-1&&value.substring(value.lastIndexOf(":")+1,value.length)=="9090")){
               //window.top.Dialog.alert("私有云服务控制台地址端口为9090");
               $(obj).next().next().attr("error","true").html('<font color="red">私有云服务控制台地址端口应配置为9090</font>');
               return;
           }
           checkToken(obj,value);
       }else if(_name==='openfireMobileClientUrl'){
           if(value===''){
                $(obj).next().next().next().attr("error","true").html('<font color="red">'+info+'不允许为空</font>');
                return;
           }
           checkEmessagePort(obj,value,_name);
       }else if(_name==='openfireEmessageClientUrl'){
           if(value==""){
               $(obj).next().next().attr("error","false").html('<font color="green">检测通过</font>');
               return;
           }
           checkEmessagePort(obj,value,_name);
       }
  }
  
  function checkIP(ip){
    var re=/^(\d+)\.(\d+)\.(\d+)\.(\d+)$/;//正则表达式   
    if(re.test(ip))
    {   
       if( RegExp.$1<256 && RegExp.$2<256 && RegExp.$3<256 && RegExp.$4<256){
            return true;
       }else{
            return false;
       }
    }else{
        return true;
    }
  }
  
  
  function changeValue(obj){
        var $chk = jQuery(obj);
        var _name = $chk.attr("name");
        if($chk.val()=='false'){
            $chk.val('true');
            jQuery("input[name='"+_name+"']").val('true');
            showEle('openfireEMobileUrl','true');
            showEle('openfireMobileClientUrl','true');
            showEle('openfireEmessageClientUrl','true');
            showEle('openfireHttpbindPort','true');
            showEle('openfireHttpbindPort_check','true');
            hideEle("checkToken");
            showEle('checkConnect','true');
        }else{
            jQuery(obj).val('false');
            jQuery("input[name='"+_name+"']").val('false');
            hideEle("openfireEMobileUrl");
            hideEle("openfireMobileClientUrl");
            hideEle("openfireEmessageClientUrl");
            hideEle("openfireHttpbindPort");
            hideEle("openfireHttpbindPort_check");
            showEle("checkToken");
            hideEle("checkConnect");
        }
   }
   
   function changeHttpValue(obj){
         var $chk = jQuery(obj);
        var _name = $chk.attr("name");
        if($chk.val()=='false'){
            $chk.val('true');
            jQuery("input[name='"+_name+"']").val('true');
        }else{
            jQuery(obj).val('false');
            jQuery("input[name='"+_name+"']").val('false');
        }
   }
   
   function openUrl(){
        window.open("http://emessage.e-cology.com.cn/html/emessagefile/%E6%B3%9B%E5%BE%AEWindows%E7%89%88e-message4.1%E7%A7%81%E6%9C%89%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE%E6%89%8B%E5%86%8C.htm","_blank");
   }

 </script>
</html>
