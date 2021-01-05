
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@page import="weaver.social.service.SocialIMService"%>
<%@ page import="java.io.File" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>
<%@page import="weaver.social.im.SocialImLogin"%> 
<%
    //判断升级版本
    SocialIMService.rootPath = application.getRealPath("/");
    boolean isE4 = SocialIMService.checkE4Version();
    
    if(!isE4){
        response.sendRedirect("emessageproduce3.jsp");
        return;
    }
    String rootPath = application.getRealPath("/");
    OrderProperties emProp = new OrderProperties();
	String emPropPath = rootPath+ "/social/im/resources/emessage.properties"; 
	File emPropFile = new File(emPropPath);
	String defaultVersion = "4.0.0";
	String defaultDate = "20160229";
	String emVersion="4.0",
		winBuildVersion=defaultVersion,
		osxBuildVersion=defaultVersion,
		xpbuildVersion=defaultVersion,
		standaloneVersion="";
	if(emPropFile.exists()){
		emProp.load(emPropPath);
		emVersion = Util.null2String(emProp.get("version"));
		winBuildVersion = emVersion + "." + Util.null2String(emProp.get("buildversion"));
		osxBuildVersion = emVersion + "." + Util.null2String(emProp.get("osxBuildVersion"));
		xpbuildVersion = emVersion + "." + Util.null2String(emProp.get("xpbuildVersion"));
		standaloneVersion = Util.null2String(emProp.get("standaloneVersion"));
	}
    
	standaloneVersion = standaloneVersion.isEmpty()?defaultDate:standaloneVersion;
	standaloneVersion = standaloneVersion.split("-")[0];
    String windowurl = "";
    String macurl="";
    
    if(windowurl.trim().equals("airdownload?n=")||windowurl.trim().equals("")){
        windowurl = "/messager/installm3/emessagedownloadinfo.jsp";
    }
    if(macurl.trim().equals("airdownload?n=")||macurl.trim().equals("")){
        macurl = "/messager/installm3/emessagedownloadinfo.jsp";
    }
    
    
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<LINK href="/css/commom_wev8.css" type=text/css rel=STYLESHEET>

<title>e-message安装页面</title>


<script type="text/javascript" src="../jquery_wev8.js"></script>
<script language="JavaScript" type="text/javascript">
    var winBuildVersion="<%=winBuildVersion%>";
	var osxBuildVersion="<%=osxBuildVersion%>";
	var xpbuildVersion="<%=xpbuildVersion%>";
	var updateInfo = {"mac": osxBuildVersion, "windows": winBuildVersion, "windowsxp": xpbuildVersion};
    $(document).ready(function () {
        $("a").bind("focus",function() {
            if(this.blur) {this.blur()};
        });
        //$("#winbtn").attr("href","www.baidu.com");
        $("#winbtn").click(function (){
            $("#winimg").attr("src","imgs/btn1_wev8.png");
            $("#macimg").attr("src","imgs/btn2_2_wev8.png");
            $("#windiv").attr("style","display");
            $("#macdiv").attr("style","display:none");
            
        });
        $("#macbtn").click(function (){
            $("#winimg").attr("src","imgs/btn1_2_wev8.png");
            $("#macimg").attr("src","imgs/btn2_wev8.png");
            $("#windiv").attr("style","display:none");
            $("#macdiv").attr("style","display");
        });
        
        $(".download").bind("click",function(){
            window.open($(this).attr("url"))
        })
        
        $(".systemTab").bind("click",function(){
        	var id = $(this).attr("sys");
            $(".contents").hide();
            $("#"+id).show();
            $(".systemTabOver").removeClass("systemTabOver");
            $(this).addClass("systemTabOver");
            // show version
            $("#updateVer").text(updateInfo[id]);
        })
        $(".systemTabOver").trigger("click");

        //xp
        $(".systemTab1").bind("click",function(){
            $(".win7-xp").hide();
            $("#"+$(this).attr("sys")).show();
            $(".systemTabOver1").removeClass("systemTabOver1");
            $(this).addClass("systemTabOver1");
        })
        $(".systemTabOver1").trigger("click");
    });

    
    
</script>

<style>
body{ margin:0; padding:0;font-family:微软雅黑 "Trebuchet MS", Arial, Helvetica, sans-serif; }
.main_top{ 

    height: 88px;
    background: #12addc;
    border-bottom: 1px solid #0e6983;
    position: relative;    

}

.logoInfo{
    position: absolute;
    left: 40px;
    width:85px;
    bottom: 0px;
}
.logo{
    background: url(/messager/installm3/images/win/logo.png) center top no-repeat;
    height: 40px;
}
.logoText{
    color:#fff;
    text-align: center;
}

.updateInfo{
    height: 40px;
    position: absolute;
    right: 40px;
    bottom: 0px;
}

.systemInfo{
    position: absolute;
    left: 250px;
    height: 53px;
    bottom: 0px;
    width: 700px;
}
.systemTab{
    position:relative;
    height: 53px;
    float: left;
    width: 210px;
    cursor: pointer;
    
}
.systemTabOver{
    height: 53px;
    background: #0f6a84;
    
}
.systemInfo .icon{
    position: absolute;
    height: 16px;
    width: 16px;
    top: 18px;
    left: 20px;
}

.systemInfo .name{
    position: absolute;
    line-height: 53px;
    font-size: 18px;
    color: #fff;
    text-align: center;
    width: 160px;
    left: 30px;
}
.content{
    
    padding-left: 30px;
    padding-right: 20px;
}

.download{
    height: 47px;
    width: 173px;
    background: #8ec73f;
    line-height: 47px;
    display: inline-block;
}
.box{
    width: 100%;
    border: 1px solid #d5d5d5;
    background: #fafafa;
}
.topIcon{
    left:-10px;
    top: -15px;
    position: absolute;
    text-align: left;
    display:none;
}
.item{
    width: 830px;
    color: #6f6f6f;
    font-size: 14px;
}

a{
    color:#52c2e5;
    text-decoration:none;
}

.text-center{
    text-align: left; 
}
.center {
    text-align: left;
    margin-left: auto;
    margin-right: auto;
}
.imgExp{
    text-align: center;
    padding-top: 30px;
}

.step{
    height: 30px;
    width: 30px;
    background: #12addc;
    border-radius: 20px;
    color: #fff;
    line-height: 30px;
    text-align: center;
    margin-top: 30px;
}

.m-l-400{
    margin-left:400px;
}

</style>
</head>

<body>
    <div class="main_top">
        <div class="logoInfo">
            <div class="logo"></div>
            <div class="logoText" style="">e-message</div>
        </div>
        <div class="systemInfo">
            <div class="systemTab" sys="mac">
                <div class="icon" style="background: url(/messager/installm3/imgs/emessage/mac_wev8.png) center top no-repeat">
                </div>
                <div class="name">
                    Mac Os版
                </div>
            </div>
            <div class="systemTab systemTabOver" sys="windows">
                <div class="icon" style="background: url(/messager/installm3/imgs/emessage/windows_wev8.png) center top no-repeat">
                </div>
                <div class="name">
                    Windows7以上版
                </div>
            </div>
            <div class="systemTab" sys="windowsxp">
                <div class="icon" style="background: url(/messager/installm3/imgs/emessage/windows_wev8.png) center top no-repeat">
                </div>
                <div class="name">
                    Windows XP版
                </div>
            </div>
            <div class="clear"></div>
        </div>
        <div class=" updateInfo">
            <div class="colorfff font12">版本信息：<span id="updateVer"><%=osxBuildVersion%></span></div>
            <div class="colorfff font12">更新日期：<%=standaloneVersion%></div>
        </div>
    </div>
    
    <div class="content center">
        <div id="windows" class="contents">
            <div style="postion:relative; text-align: center;">
                <div class="download center relative colorfff hand m-t-20 font14" url="/social/im/resources/e-message.exe"> 
                    <img src="/messager/installm3/imgs/emessage/download_wev8.png" style="position: absolute;left:20px;top:10px;">
                    <span style="position: absolute;left:50px;">下载e-message</span>
                </div>
                <!--
                <div class="download center relative colorfff hand m-t-20 font14" url="/social/im/resources/dotNetFx45_Full_x86_x64.zip"> 
                    <img src="/messager/installm3/imgs/emessage/download_wev8.png" style="position: absolute;left:20px;top:10px;">
                    <span style="position: absolute;left:50px;">下载framework4.5</span>
                </div>
                -->
            </div>
            <div class=" m-t-20 relative" style="text-align: left" >
                <img src="/messager/installm3/imgs/emessage/1_wev8.png" class="topIcon"  >
                <div class="box center" style="font-size:14px;">
                    <div class="center item">
                        <!--
                        <div class="m-t-15">
                        -->
                            <!--  
                            <div style="background: url(/messager/installm3/imgs/emessage/01_wev8.png) center center no-repeat; height: 40px; padding: 0 10px;"></div>
                            -->    
                            
                            <!--                            
                            <div class="step">1</div>
                            <div class="text-center" style="line-height:30px;">
                                双击运行e-message安装文件，进行安装。
                                若本机没有Microsoft .NET Framework 4.5运行环境，程序会出现以下界面:
                            </div>
                            <div class="imgExp">
                                <img src="/messager/installm3/images/win/noframe_2.png"/>
                            </div>
                        </div>
                        <!--
                        <div class="m-t-15" style="padding: 0 10px;">
                            <div class="step">2</div>
                            <div class="text-center" style="line-height:30px;">
                                安装该组件需要客户机能够访问外网。
                            </div>
                            <div class="text-center" style="line-height:30px;">
                                注意事项：<br>
                                1、安装过程中若有如360安全卫士等安全软件提醒，请选择同意安装。<br>
                                2、安装前后可能需要用户重启电脑，是否需要重启请根据提醒进行操作。
                            </div>
                            <div class="imgExp">
                                <img src="/messager/installm3/images/win/noframe_4.png"/>
                            </div>
                        </div>
                        <div class="clear"></div>
                        <div style="line-height: 30px;">
                            <br>
                            此时需手动安装.NET Framework 4.5运行环境，可<a href="/social/im/resources/dotNetFx45_Full_x86_x64.zip">点此下载</a>或通过可访问外网的电脑前往<a href="https://www.microsoft.com/zh-cn/download/details.aspx?id=30653" target="_blank">https://www.microsoft.com/zh-cn/download/details.aspx?id=30653</a>官方下载。
                        </div>
                        
                        <div class="m-t-15">
                            <div class="step">3</div>
                            <div class="text-center" style="line-height:30px;">
                                运行下载后的文件并完成安装
                            </div>
                            <div class="m-t-15 m-b-15">
                                <div class="left" style="width:250px;height:200px;background: url(/messager/installm3/images/win/frame_1.png) center center no-repeat;"></div>
                                <div class="left" style="width:40px;height:170px;background: url(/messager/installm3/imgs/emessage/next.png) center center no-repeat;"></div>
                                <div class="left" style="width:250px;height:200px;background: url(/messager/installm3/images/win/frame_2.png) center center no-repeat;"></div>
                                <div class="left" style="width:40px;height:170px;background: url(/messager/installm3/imgs/emessage/next.png) center center no-repeat;"></div>
                                <div class="left" style="width:250px;height:200px;background: url(/messager/installm3/images/win/frame_3.png) center center no-repeat;"></div>
                                <div class="clear"></div>
                            </div>
                        </div>
                        -->
                        <div class="m-t-15">
                            <div class="step">1</div>
                            <div class="text-center font14" style="line-height:30px;">
                                安装e-message
                            </div>
                            <div class="center" style="width:500px;height: 400px;background: url(/messager/installm3/images/win/install_1.png) center center no-repeat;"></div>
                            <div>
                             安装说明：<br>
                                 1、程序安装完成，会在用户桌面生成e-message的快捷方式<br>
                                 2、安装后启动应用程序：勾选此项，安装完成后会自动打开e-message<br>
                                 3、安装位置：若不想程序安装到默认路径，可点击文件夹图标修改安装路径，为了避免软件运行出现问题，不要安装在带有中文路径的目录里面<br>
                             <br>
                             <br>   
                            <div>
                         </div>
                    </div>
                </div>
            </div>
        </div>
        <br>
        <br>
       </div>
     </div>
        <div id="windowsxp" class="contents">
            <div style="postion:relative; text-align: center;">
                <div class="download center relative colorfff hand m-t-20 font14" url="/social/im/resources/e-message-xp.exe"> 
                    <img src="/messager/installm3/imgs/emessage/download_wev8.png" style="position: absolute;left:20px;top:10px;">
                    <span style="position: absolute;left:50px;">下载e-message-xp</span>
                </div>
                <!--
                <div class="download center relative colorfff hand m-t-20 font14" url="/social/im/resources/dotNetFx40_Full_x86_x64.zip"> 
                    <img src="/messager/installm3/imgs/emessage/download_wev8.png" style="position: absolute;left:20px;top:10px;">
                    <span style="position: absolute;left:50px;">下载framework4.0</span>
                </div>
                -->
            </div>
            
            
            <div class=" m-t-20 relative" style="text-align: left" >
                <img src="/messager/installm3/imgs/emessage/1_wev8.png" class="topIcon"  >
                <div class="box center" style="font-size:14px;">
                    <div class="center item">
                        <!-- 
                        <div class="m-t-15">
                             
                            <div style="background: url(/messager/installm3/imgs/emessage/01_wev8.png) center center no-repeat; height: 40px; padding: 0 10px;"></div>
                            --> 
<!--                            
                            <div class="step">1</div>
                            <div class="text-center" style="line-height:30px;">
                                双击运行e-message-xp安装文件，进行安装。
                                若本机没有Microsoft .NET Framework 4.0运行环境，程序会出现以下界面:
                            </div>
                            <div class="imgExp">
                                <img src="/messager/installm3/images/winxp/noframe_2.png"/>
                            </div>
                        </div>
                        
                        <div class="m-t-15" style="padding: 0 10px;">
                            <div class="step">2</div>
                            <div class="text-center" style="line-height:30px;">
                                安装该组件需要客户机能够访问外网。
                            </div>
                            <div class="text-center" style="line-height:30px;">
                                注意事项：<br>
                                1、安装过程中若有如360安全卫士等安全软件提醒，请选择同意安装。<br>
                                2、安装前后可能需要用户重启电脑，是否需要重启请根据提醒进行操作。
                            </div>
                            <div class="imgExp">
                                <img src="/messager/installm3/images/winxp/frame_1.png"/>
                            </div>
                        </div>
                        <div class="clear"></div>
                        <div style="line-height: 30px;">
                            <br>
                            此时需手动安装.NET Framework 4.0运行环境，可<a href="/social/im/resources/dotNetFx40_Full_x86_x64.zip">点此下载</a>或通过可访问外网的电脑前往<a href="https://www.microsoft.com/zh-CN/download/details.aspx?id=17718" target="_blank">https://www.microsoft.com/zh-CN/download/details.aspx?id=17718</a>官方下载。
                        </div>
                        
                        <div class="m-t-15">
                            <div class="step">3</div>
                            <div class="text-center" style="line-height:30px;">
                                运行下载后的文件并完成安装
                            </div>
                            <div class="m-t-15 m-b-15">
                                <div class="left" style="width:250px;height:220px;background: url(/messager/installm3/images/winxp/frame_1.png) center center no-repeat;"></div>
                                <div class="left" style="width:40px;height:170px;background: url(/messager/installm3/imgs/emessage/next.png) center center no-repeat;"></div>
                                <div class="left" style="width:250px;height:220px;background: url(/messager/installm3/images/winxp/frame_2.png) center center no-repeat;"></div>
                                <div class="left" style="width:40px;height:170px;background: url(/messager/installm3/imgs/emessage/next.png) center center no-repeat;"></div>
                                <div class="left" style="width:250px;height:220px;background: url(/messager/installm3/images/winxp/frame_3.png) center center no-repeat;"></div>
                                <div class="clear"></div>
                            </div>
                        </div>
                        -->
                        <div class="m-t-15">
                            <div class="step">1</div>
                            <div class="text-center font14" style="line-height:30px;">
                                安装e-message-xp
                            </div>
                            <div class="center" style="width:532px;height: 392px;background: url(/messager/installm3/images/winxp/install_1.png) center center no-repeat;"></div>
                            <div>
                             安装说明：<br>
                                 1、程序安装完成，会在用户桌面生成e-message-xp的快捷方式<br>
                                 2、安装后启动应用程序：勾选此项，安装完成后会自动打开e-message-xp<br>
                                 3、安装位置：若不想程序安装到默认路径，可点击文件夹图标修改安装路径，为了避免软件运行出现问题，不要安装在带有中文路径的目录里面<br>
                             <br>
                             <br>   
                            <div>
                         </div>
                    </div>
                </div>
            </div>
        </div>
        <br>
        <br>
       </div>
    </div>
   
    <div id="mac" class="contents">
            <div style="postion:relative; text-align: center;">
                <div class="download center relative colorfff hand m-t-20 font14" url="/social/im/resources/e-message.dmg"> 
                    <img src="/messager/installm3/imgs/emessage/download_wev8.png" style="position: absolute;left:20px;top:10px;">
                    <span style="position: absolute;left:50px;">下载e-message</span>
                </div>
            </div>
            
            <div class=" m-t-20 relative" style="text-align: left" >
                <img src="/messager/installm3/imgs/emessage/1_wev8.png" class="topIcon"  >
                <div class="box center" style="font-size:14px;">
                    <div class="center item">
                        <div class="m-t-15">
                            <div class="step">1</div>
                            <div class="text-center" style="line-height:30px;">
                                双击运行e-message安装文件，进行安装。
                            </div>
                            <div class="imgExp">
                                <img src="/messager/installm3/images/osx/install_1.png"/>
                            </div>
                        </div>
                        <div class="m-t-15" style="padding: 0 10px;">
                            <div class="step">2</div>
                            <div class="text-center" style="line-height:30px;">
                                如图，按照提示，点击左侧e-message应用，拖动放入Applications中，完成在osx系统安装
                            </div>
                            <div class="imgExp">
                                <img src="/messager/installm3/images/osx/install_2.png"/>
                            </div>
                        </div>
                        
                        <div class="m-t-15">
                            <div class="step">3</div>
                            <div class="text-center" style="line-height:30px;">
                                安装完成后，在程序面板Launchpad中，找到应用运行。
                            </div>
                            <div class="imgExp">
                                <img src="/messager/installm3/images/osx/exe_1.png"/>
                            </div>
                            <br>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <br>
        <br>
    </div>
   
</body>
</html>