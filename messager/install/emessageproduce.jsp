
<%@ page language="java" import="java.util.*,org.dom4j.*,org.dom4j.io.*"  contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String strSql="select propValue from ofProperty where name = 'xmpp.domain'";
	String emessageurl="";
	String emessageserver = "";
	rs.executeSql(strSql);
	if(rs.next()){
		emessageserver = rs.getString("propValue");
	}
	if(!emessageserver.equals("")){
		String updateXmlUrl= "http://"+emessageserver+":9090/plugins/emessage/update/update.xml";
		SAXReader reader = new SAXReader();
		try {
			Document doc = reader.read(updateXmlUrl);
			Element root = doc.getRootElement();
			List listmsg = root.elements();
			for (int i =0;i<listmsg.size();i++) {
				Element element = (Element)listmsg.get(i);
				if(element.getName().equals("url")){
					emessageurl = element.getText();
				}
			}
	   } catch (DocumentException e) {

	   }
   }
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>E-Message安装</title>
<style>
body{ margin:0px; padding:0px;}
.div_top{ background:url(imgs/top_wev8.gif) no-repeat; height:193px; width:798px;}
.div_autobtn{ background:url(imgs/top_autobtn_wev8.gif) no-repeat;height:180px; width:217px; float:left;margin-top:-1px;}
.div_handbtn{ background:url(imgs/top_handbtn_wev8.gif) no-repeat;height:46px; width:131px; float:left; margin:118px 0 0 4px;}
.div_handbtn_bg{ background:url(imgs/top_handbtn_bg_wev8.gif) no-repeat; height:81px; width:227px; float:left; margin:86px 0 0 7px;}
.div_handbtn_bg1{margin:10px 0 0 20px;}
.div_handbtn_01{  height:27px; width:67px; float:left; margin-right:12px;}
.div_handbtn_02{  height:27px; width:118px; float:left}
.div_handbtn_bg2{margin:12px 0 0 18px;}
.div_handbtn_link1_a:link{text-decoration:none; color:#156cb5; font-family:Verdana, Geneva, sans-serif; font-size:14px; font-weight:bold;}
.div_handbtn_link2_a:link{text-decoration:none; color:#3f3f3f; font-family:Verdana, Geneva, sans-serif; font-size:14px;}
.line{margin:0 10px 0 10px; color:#333;}
.div_body1{ background:url(imgs/img1_wev8.gif) no-repeat; height:76px; width:798px;}
.div_body2{ background:url(imgs/img2_wev8.gif) no-repeat; height:313px; width:798px;}
.div_body3{ background:url(imgs/img3_wev8.gif) no-repeat; height:309px; width:798px;}
.div_body4{ background:url(imgs/img4_wev8.gif) no-repeat; height:177px; width:798px;}

</style>

<script type="text/javascript" src="highslide/highslide_wev8.js"></script>
<script type="text/javascript" src="highslide/highslide.config_wev8.js" charset="utf-8"></script>
<link rel="stylesheet" type="text/css" href="highslide/highslide_wev8.css" />
<script language="JavaScript" type="text/javascript">
		hs.graphicsDir = '/js/messagejs/highslide/graphics/';
		hs.outlineType = 'rounded-white';
		hs.fadeInOut = true;
		hs.headingEval = 'this.a.title';
		
function forwindows(){
	document.getElementById("forwindow").className  = 'div_handbtn_link1_a';
	document.getElementById("formac").className  = 'div_handbtn_link2_a';
	document.getElementById("airurl").href="AdobeAIRInstaller.zip";
	document.getElementById("airbtn").src ="imgs/top_handbtn_01_wev8.gif";
	document.getElementById("msgbtn").src ="imgs/top_handbtn_02_wev8.gif";
}

function formac(){
	document.getElementById("forwindow").className  = 'div_handbtn_link2_a';
	document.getElementById("formac").className  = 'div_handbtn_link1_a';
	document.getElementById("airurl").href="AdobeAIR.zip";
	document.getElementById("airbtn").src ="imgs/top_handbtn_03_wev8.gif";
	document.getElementById("msgbtn").src ="imgs/top_handbtn_04_wev8.gif";
}
</script>
</head>
<body>
<div class="div_top">
    <div class="div_autobtn">
      <jsp:include page="autoinstall.jsp" flush="true" > 
      	<jsp:param name="emessageurl" value="<%=emessageurl%>" /> 
      </jsp:include>
    </div>
    <div class="div_handbtn"></div>
    <div class="div_handbtn_bg">
    	<div class="div_handbtn_bg1">
            <a id="forwindow" class="div_handbtn_link1_a" href="javascript:forwindows();">for Windows</a> 
            <span class="line">|</span>
            <a id="formac" class="div_handbtn_link2_a" href="javascript:formac();">for Mac</a>
        </div>
        <div class="div_handbtn_bg2">
            <div  class="div_handbtn_01">
            	<a id="airurl" href="AdobeAIRInstaller.zip"><img id="airbtn" src="imgs/top_handbtn_01_wev8.gif" border="0"/></a>
            </div>
            <div  class="div_handbtn_02">
            	<a id="msgurl"  href="<%=emessageurl%>"><img id="msgbtn" src="imgs/top_handbtn_02_wev8.gif" border="0"/></a>
            </div>
        </div>
    </div>
</div>
<div class="div_body1">
	
</div>
<div class="div_body2">
	<a href="imgs/msg1_wev8.jpg" class="highslide" onclick="return hs.expand(this)" onFocus="this.blur()"><img border="0" src="imgs/msg1_wev8.jpg"  width="203" height="153" style="margin-top:116px;margin-left:37px;float:left;"/></a>
	<a href="imgs/msg2_wev8.jpg" class="highslide" onclick="return hs.expand(this)" onFocus="this.blur()"><img border="0" src="imgs/msg2_wev8.jpg"  width="205" height="100" style="margin-top:142px;margin-left:59px;float:left;"/></a>
	<a href="imgs/msg3_wev8.jpg" class="highslide" onclick="return hs.expand(this)" onFocus="this.blur()"><img border="0" src="imgs/msg3_wev8.jpg"  width="205" height="100" style="margin-top:142px;margin-left:60px;float:left;"/></a>
</div>
<div class="div_body3">
	<a href="imgs/msg4_wev8.jpg" class="highslide" onclick="return hs.expand(this)" onFocus="this.blur()"><img border="0" src="imgs/msg4_wev8.jpg"  width="203" height="160" style="margin-top:82px;margin-left:568px;float:left;"/></a>
</div>
<div class="div_body4"></div>
</body>
</html>
