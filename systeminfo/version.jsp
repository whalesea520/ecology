
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
String companyName="";
String cversion="";
RecordSet.executeSql("select companyname,cversion from license");
if (RecordSet.next())
{
	companyName=RecordSet.getString("companyname");
	cversion=RecordSet.getString("cversion");
}
%>


<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(16900,user.getLanguage())%> ecology</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/Weaver_wev8.css" type="text/css">
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript">
	var dialog = parent.getDialog(window);
	</script>
<style>
.textfield{
	width:90%;
	height:auto;
	overflow:auto;
	margin-left:30px;
}

#splite{
	width:25px;
	display:inline;
}

.style01 {
display:block;
font-size: 14px; 
color: #1547c8;
vertical-align:middle;
margin-left:30px;
}

.style02 {
display:block;
font-size: 14px; 
color: #1d1d1d;
vertical-align:middle;
margin-left:30px;
}

.style03 {
display:inline-block;
font-size: 12px; 
color: #000000;
vertical-align:middle;
margin-left:30px;
}

.style04 {
display:inline-block;
font-size: 12px; 
color: #6abcfb;
vertical-align:middle;
}

#container {position:relative; display:block; background:#ffffff;width: 100%;height:80px;float:left;}

.logoimage{
float:left;
width:202px;
height:45px;
margin-top:20px;
background:url("/images_face/version/logo_wev8.png");
}
</style>	

</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" scroll="no">
<div style="min-width:600px;height:100%;overflow:hidden;">
<div id="container">
	<div style="width:30px!important;height:1px;float:left;"></div>
	<div class="logoimage"> </div>
</div>
<div style="clear:both;"></div>
<div style="background:rgb(204,204,204);width:90%;height:1px!important;margin-left:30px;"></div>
<div style="width:1px;height:20px!important;float:left;"></div>
<div id="container">
	<div>
		<span class="style01"><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>:&nbsp;<%=cversion%></span>
	</div>
	<div style="width:1px;height:5px!important;float:left;"></div>
	<div style="clear:both;"></div>
	<div>
		<span class="style02"><%=SystemEnv.getHtmlLabelName(16898,user.getLanguage())%>:&nbsp;<%=companyName%></span>
	</div>
	<div style="width:1px;height:15px!important;float:left;"></div>
	<div style="clear:both;"></div>
	<%if(user.getLanguage()==7){%>
	<div class="textfield"><div class='splite'></div>本软件是基于J2EE的各种技术，B/S模式的三层结构设计完成的，由上海泛微网络科技股份有限公司独立开发。<br>
	<div class='splite'></div>本软件的版权属于上海泛微网络科技股份有限公司，未经泛微公司的授权许可不得擅自发布或使用该软件。<br>
	<div class='splite'></div>weaver e-cology、泛微司标均是上海泛微网络科技股份有限公司商标，Windows、NT、Java等均是各相关公司的商标或注册商标。<br>
	<div class='splite'></div>警告:本计算机程序受著作权法和国际公约的保护，未经授权擅自复制或散布本程序的部分或全部，将承受严厉的民事和刑事处罚，对已知的违反者将给予法律范围内的全面制裁。</div>
	<%}else if(user.getLanguage()==8){%>
	<div class="textfield"><div class='splite'></div>This software is based on various technologies of J2EE and three-layer framework of B/S mode,It's developed independently by Shanghai Weaver Network Co., Ltd.<br>
	<div class='splite'></div>The copyright of this software belongs to Shanghai Weaver Network Co., Ltd.It is prohibited to release or use this software.<br>
	<div class='splite'></div>Weaver e-cology and releated are trademarks of Shanghai Weaver Network Co., Ltd.Windows, NT, Java and related are trademarks of the other companies.<br>
	<div class='splite'></div>Warning:This program is protected by the law of copyright and the law of international convention. Without permission, any copying or dispersing any part of the program will be subjected to civil and criminal penalties. Any trespasser who knows this warning will be measured out harsh justice.</div>
	<%}else if(user.getLanguage()==9){%>
	<div class="textfield"><div class='splite'></div>本軟件是基於J2EE的各種技術，B/S模式的三層結構設計完成的，由上海泛微網络科技股份有限公司獨立開發。<br> 
	<div class='splite'></div>本軟件的版權屬於上海泛微網络科技股份有限公司，未經泛微公司的授權許可不得擅自發布或使用該軟件。 <br>
	<div class='splite'></div>weaver e-cology、泛微司標均是上海泛微網络科技股份有限公司商標，Windows、NT、Java等均是各相關公司的商標或註冊商標。<br> 
	<div class='splite'></div>警告:本計算機程序受著作權法和國際公約的保護，未經授權擅自複製或散佈本程序的部分或全部，將承受嚴厲的民事和刑事處罰，對已知的違反者將給予法律範圍內的全面製裁。</div>
	<%}%>
	<div style="width:1px;height:20px!important;float:left;"></div>
	<div style="clear:both;"></div>
	<div>
		<div style="float:left;">
			<span class="style03"><%=SystemEnv.getHtmlLabelName(16899,user.getLanguage())%>&nbsp;&nbsp;&copy;&nbsp;&nbsp;Shanghai Weaver Network Co., Ltd</span>
		</div>
		<div style="float:right;margin-right:35px;">
			<span class="style03"><%=SystemEnv.getHtmlLabelName(16897,user.getLanguage())%>:</span>&nbsp;<a href="http://www.weaver.com.cn" target="_blank"><span class="style04">www.weaver.com.cn</span></a>
		</div>
	</div>
	<div style="width:1px;height:20px!important;float:left;"></div>
	<div style="clear:both;"></div>
	<div style="width: 100%;height:30px;margin-top:35px;">
		<div style="float:right;width:70px;height:30px;margin-right:35px;">
			<button name="submit" onclick="dialog.closeByHand()" style="width:70px;height:30px;background-color:#018df7;"><%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></button>
		</div>
	</div>
</div>
</div>

</body>
</html>