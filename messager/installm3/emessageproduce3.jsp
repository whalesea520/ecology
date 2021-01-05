
<%@ page language="java" import="java.util.*,org.dom4j.*,org.dom4j.io.*"  contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String windowurl = "";
	String macurl="";
	String windowversion = "3.0";
	String datastr="20130325";
	//String macversion="";
	String emessageserver = "";
	String strSql="select propValue from ofProperty where name = 'xmpp.domain'";
	rs.executeSql(strSql);
	if(rs.next()){
		emessageserver = rs.getString("propValue");
	}
	//emessageserver = "wangyj";
	if(!emessageserver.equals("")){
		String updateXmlUrl= "http://"+emessageserver+":9090/plugins/emessage/update/update.xml";
		Document doc = null;
		SAXReader reader = new SAXReader();
		try {
			doc = reader.read(updateXmlUrl);
		} catch (DocumentException e) {
			updateXmlUrl= "http://127.0.0.1:9090/plugins/emessage/update/update.xml";
			try {
				doc = reader.read(updateXmlUrl);
			}catch (DocumentException ex) {
				
			}
	   	}
		if(doc!=null){
			Element root = doc.getRootElement();
			List listmsg = root.elements();
			for (int i =0;i<listmsg.size();i++) {
				Element element = (Element)listmsg.get(i);
				if(element.getName().equals("exe")){
					List info = element.elements();
					for (int j =0;j<info.size();j++) {
						Element infoelement = (Element)info.get(j);
						if(infoelement.getName().equals("url")){
							windowurl = infoelement.getText();
							int index = windowurl.lastIndexOf("/");
							String filename = windowurl.substring(index+1,windowurl.length());
							windowurl = windowurl.substring(0,index+1)+"airdownload?n="+filename;
							if(filename.indexOf("_")!=-1&&filename.indexOf(".")!=-1)
							datastr = filename.substring(filename.indexOf("_")+1,filename.lastIndexOf("."));
						}
						if(infoelement.getName().equals("version")){
							windowversion = infoelement.getText();
						}
					}
				}
				if(element.getName().equals("dmg")){
					List info = element.elements();
					for (int j =0;j<info.size();j++) {
						Element infoelement = (Element)info.get(j);
						if(infoelement.getName().equals("url")){
							macurl = infoelement.getText();
							int index = macurl.lastIndexOf("/");
							macurl = macurl.substring(0,index+1)+"airdownload?n="+macurl.substring(index+1,macurl.length());
						}
						//if(infoelement.getName().equals("version")){
						//	macversion = infoelement.getText();
						//}
					}
				}
			}
		}
   }
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

<title>E-Message安装页面</title>


<script type="text/javascript" src="../jquery_wev8.js"></script>
<script language="JavaScript" type="text/javascript">
	
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
			$(".contents").hide();
			$("#"+$(this).attr("sys")).show();
			$(".systemTabOver").removeClass("systemTabOver");
			$(this).addClass("systemTabOver");
		})
		$(".systemTabOver").trigger("click");
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
	background: url(/messager/installm3/imgs/emessage/e-message_wev8.png) center top no-repeat;
	height: 45px;
}
.logoText{
	color:#fff;
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
	width: 400px;
}
.systemTab{
	position:relative;
	height: 53px;
	float: left;
	width: 200px;
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
	width: 150px;
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
}
.item{
	width: 780px;
	color: #6f6f6f;
	font-size: 12px;
}

a{
	color:#52c2e5;
	text-decoration:none;
}
</style>
</head>

<body>
	
	<div class="main_top">
		
		<div class="logoInfo">
			<div class="logo">
			</div>
			<div class="logoText" style="">e-message</div>
		</div>
		<div class="systemInfo">
			
			<div class="systemTab systemTabOver" sys="windows">
				<div class="icon" style="background: url(/messager/installm3/imgs/emessage/windows_wev8.png) center top no-repeat">
				</div>
				<div class="name">
					For Windows
				</div>
			</div>
			<div class="systemTab " sys="mac">
				<div class="icon" style="background: url(/messager/installm3/imgs/emessage/mac_wev8.png) center top no-repeat">
				</div>
				<div class="name">
					For Mac Os
				</div>
			</div>
			<div class="clear"></div>
		</div>
		<div class=" updateInfo">
			<div class="colorfff font12">版本信息：<%=windowversion%></div>
            <div class="colorfff font12">更新日期：<%=datastr%></div>
		</div>
	</div>
	
	<div class="content center">
		<div id="windows" class="contents">
			<div class="download center relative colorfff hand m-t-20 font14" url="<%=windowurl%>"> 
				<img src="/messager/installm3/imgs/emessage/download_wev8.png" style="position: absolute; left:40px;top:10px;">
				<span style="position: absolute;left: 70px;">点击下载</span>
			</div>
			<div class=" m-t-20 relative" style="text-align: left" >
				<img src="/messager/installm3/imgs/emessage/1_wev8.png" class="topIcon" >
				<div class="box center">
					<div class="center item">
						<div class="left m-t-15" style="width:390px;">
							<div style="background: url(/messager/installm3/imgs/emessage/01_wev8.png) center center no-repeat; height: 40px;"></div>
							<div class="text-center" style="line-height:30px;">
								双击运行e-message安装文件
							</div>
							<div class="text-center" style="line-height:30px;">
								若本机没有air运行环境，程序会出现以下界面，自动下载安装：
							</div>
							<div class="imgExp" style="height:250px;background: url(/messager/installm3/imgs/emessage/w1.png) center center no-repeat;">
							</div>
						</div>
						<div class="left m-t-15" style="width:390px;">
							<div style="background: url(/messager/installm3/imgs/emessage/02.png) center center no-repeat; height: 40px;"></div>
							<div class="text-center" style="line-height:30px;">
								若安装电脑无法连接外网，
							</div>
							<div class="text-center" style="line-height:30px;">
								即不能访问adobe官网获取air,会出现以下警告：
							</div>
							<div class="imgExp" style="height:250px;background: url(/messager/installm3/imgs/emessage/w2.png) center center no-repeat;">
							</div>
						</div>
						<div class="clear"></div>
						<div style="line-height: 30px;">
							此时需手动安装air运行环境，可<a href="AdobeAIRInstaller.zip">点此下载</a>或通过可访问外网的电脑前往<a href="http://www.adobe.com/go/getair_cn" target="_blank">http://www.adobe.com/go/getair_cn</a>官方下载。
						</div>
						
					</div>
					
					<div class="m-t-30" style="border-top:1px dashed  #cccccc;margin-left:30px;margin-right: 30px;">
						<div class="center item m-t-20">
							<div class="text-center" style="line-height:30px;">
								运行下载后的文件并完成安装
							</div>
							<div class="m-t-15 m-b-15">
								<div class="left" style="width:225px;height:170px;background: url(/messager/installm3/imgs/emessage/w3.png) center center no-repeat;"></div>
								<div class="left" style="width:40px;height:170px;background: url(/messager/installm3/imgs/emessage/next.png) center center no-repeat;"></div>
								<div class="left" style="width:220px;height:170px;background: url(/messager/installm3/imgs/emessage/w4.png) center center no-repeat;"></div>
								<div class="left" style="width:40px;height:170px;background: url(/messager/installm3/imgs/emessage/next.png) center center no-repeat;"></div>
								<div class="left" style="width:220px;height:170px;background: url(/messager/installm3/imgs/emessage/w5.png) center center no-repeat;"></div>
								<div class="clear"></div>
							</div>
						</div>
					</div>
					
				</div>
			</div>
			
			<div class=" m-t-20 relative" style="text-align: left;">
				<img src="/messager/installm3/imgs/emessage/2.png" class="topIcon" >
				<div class="box center">
					<div class="center item">
						<div class="text-center font14 m-t-30" style="line-height:30px;">
								安装E-Message
						</div>
						<div class="center" style="width:500px;height: 400px;background: url(/messager/installm3/imgs/emessage/w6.png) center center no-repeat;">
						</div>
						<div class="center " style="width:500px;line-height:30px;text-align: left;">
								安装选项说明：
						</div>
						<div class="center " style="width:500px;line-height:30px;text-align: left;">
								将快捷方式图标添加到桌面上：勾选此项，会在用户桌面生成E-Message的快捷方式
						</div>
						<div class="center " style="width:500px;line-height:30px;text-align: left;">
								安装后启动应用程序：勾选此项，安装完成后会自动打开E-Message
						</div>
						<div class="center " style="width:500px;line-height:30px;text-align: left;">
								安装位置：若不想程序安装到默认路径，可点击文件夹图标修改安装路径
						</div>
					</div>
				</div>	
			</div>
			
			<div class=" m-t-20 relative" style="text-align: left;">
				<img src="/messager/installm3/imgs/emessage/3.png" class="topIcon" >
				<div class="box center">
					<div class="center item">
						<div style=" height:150px;background: url(/messager/installm3/imgs/emessage/logo.png) center center no-repeat;"></div>
						<div class="center " style="line-height:30px;">
								安装完成点击快捷方式可进入程序（如同所示）
						</div>
					</div>
				</div>	
			</div>
			
			
			
		</div>
		
		<div id="mac" class="contents">
			<div class="download center relative colorfff hand m-t-20 font14" url="<%=macurl%>"> 
				<img src="/messager/installm3/imgs/emessage/download.png" style="position: absolute; left:40px;top:10px;">
				<span style="position: absolute;left: 70px;">点击下载</span>
			</div>
			<div class=" m-t-20 relative" style="text-align: left;">
				<img src="/messager/installm3/imgs/emessage/1.png" class="topIcon" >
				<div class="box center">
					<div class="center item">
						<div class=" m-t-15">
							<div style="background: url(/messager/installm3/imgs/emessage/01.png) center center no-repeat; height: 40px;"></div>
							<div class="text-center" style="line-height:30px;">
								双击运行e-message安装文件
							</div>
							<div class="text-center" style="line-height:30px;">
								若本机没有air运行环境，程序会出现以下界面，自动下载安装：
							</div>
							<div class="imgExp" style="height:250px;background: url(/messager/installm3/imgs/emessage/m1.png) center center no-repeat;">
							</div>
						</div>
						<div class=" m-t-15" >
							<div style="background: url(/messager/installm3/imgs/emessage/02.png) center center no-repeat; height: 40px;"></div>
							<div class="text-center" style="line-height:30px;">
								若安装电脑无法连接外网，即不能访问adobe官网获取air,会出现以下警告：
							</div>
							
							<div class="imgExp" style="height:250px;background: url(/messager/installm3/imgs/emessage/m2.png) center center no-repeat;">
							</div>
						</div>
						<div class="clear"></div>
						<div style="line-height: 30px;" class="m-t-15">
							此时需手动安装air运行环境，可<a href="AdobeAIRInstaller.zip">点此下载</a>或通过可访问外网的电脑前往<a href="http://www.adobe.com/go/getair_cn" target="_blank">http://www.adobe.com/go/getair_cn</a>官方下载。
						</div>
						
					</div>
					
					<div class="m-t-30" style="border-top:1px dashed  #cccccc;margin-left:30px;margin-right: 30px;">
						<div class="center item m-t-20">
							<div class="text-center" style="line-height:30px;">
								运行下载后的文件并完成安装
							</div>
							<div class="m-t-15 m-b-15">
								<div class="left" style="width:320px;height:260px;background: url(/messager/installm3/imgs/emessage/m3.png) center center no-repeat;"></div>
								<div class="left" style="width:80px;height:260px;background: url(/messager/installm3/imgs/emessage/next.png) center center no-repeat;"></div>
								<div class="left" style="width:320px;height:260px;background: url(/messager/installm3/imgs/emessage/m4.png) center center no-repeat;"></div>
								<div class="clear"></div>
								<div class="last" style="width:400px;height:70px;background: url(/messager/installm3/imgs/emessage/down.png) center center no-repeat;"></div>
								<div class="clear"></div>
								<div class="left" style="width:320px;height:160px;background: url(/messager/installm3/imgs/emessage/m6.png) center center no-repeat;"></div>
								<div class="left" style="width:80px;height:160px;background:;background: url(/messager/installm3/imgs/emessage/prev.png) center center no-repeat;"></div>
								<div class="left" style="width:320px;height:160px;background: url(/messager/installm3/imgs/emessage/m5.png) center center no-repeat;"></div>
								
								<div class="clear"></div>
							</div>
						</div>
					</div>
					
				</div>
			</div>
			
			<div class=" m-t-20 relative" style="text-align: left;">
				<img src="/messager/installm3/imgs/emessage/2.png" class="topIcon" >
				<div class="box center">
					<div class="center item">
						<div class="text-center font14 m-t-30" style="line-height:30px;">
								安装E-Message
						</div>
						<div>
							<div class="m-t-15 m-b-15">
								<div class="left" style="width:375px;height:300px;background: url(/messager/installm3/imgs/emessage/m7.png) center center no-repeat;"></div>
								<div class="left" style="width:80px;height:300px;background: url(/messager/installm3/imgs/emessage/next.png) center center no-repeat;"></div>
								<div class="left" style="width:320px;height:300px;background: url(/messager/installm3/imgs/emessage/m8.png) center center no-repeat;"></div>
								<div class="clear"></div>
							</div>
						</div>
						
						<div class=" " style="line-height:30px;text-align: left;">
								安装选项说明：
						</div>
						<div class=" " style="line-height:30px;text-align: left;">
								将快捷方式图标添加到桌面上：勾选此项，会在用户桌面生成E-Message的快捷方式
						</div>
						<div class=" " style="line-height:30px;text-align: left;">
								安装后启动应用程序：勾选此项，安装完成后会自动打开E-Message
						</div>
						<div class=" " style="line-height:30px;text-align: left;">
								安装位置：若不想程序安装到默认路径，可点击文件夹图标修改安装路径
						</div>
					</div>
				</div>	
			</div>
			
			<div class=" m-t-20 relative" style="text-align: left;">
				<img src="/messager/installm3/imgs/emessage/3.png" class="topIcon" >
				<div class="box center">
					<div class="center item">
						<div style=" height:150px;background: url(/messager/installm3/imgs/emessage/logo.png) center center no-repeat;"></div>
						<div class="center " style="line-height:30px;">
								安装完成点击快捷方式可进入程序（如同所示）
						</div>
					</div>
				</div>	
			</div>
			
			
			
		</div>
	</div>
</body>
</html>